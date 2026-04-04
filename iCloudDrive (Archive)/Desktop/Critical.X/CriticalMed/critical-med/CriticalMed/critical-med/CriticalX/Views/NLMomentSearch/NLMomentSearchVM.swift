//
//  NLMomentSearchVM.swift
//  CriticalX
//
//  Natural Language Moment Search - ViewModel
//  Handles search input, debouncing, parsing, and moment matching
//  Supports hybrid offline + AI search for maximum accuracy
//

import Foundation
import Combine
import SwiftUI

// MARK: - Search Mode

enum SearchMode: String, CaseIterable {
    case offlineOnly = "Offline"
    case hybrid = "Hybrid"
    
    var icon: String {
        switch self {
        case .offlineOnly: return "bolt.fill"
        case .hybrid: return "sparkles"
        }
    }
}

// MARK: - NLMomentSearchVM
/// ViewModel for the Natural Language Moment Search feature
class NLMomentSearchVM: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Raw query text from user
    @Published var query: String = ""
    
    /// Parsed query with extracted entities
    @Published var parsed: ParsedQuery = .empty
    
    /// Matched moment outputs to display
    @Published var outputs: [NLMomentOutput] = []
    
    /// Whether a search is in progress (for loading states)
    @Published var isSearching: Bool = false
    
    /// Search mode: offline only or hybrid with AI fallback
    @Published var searchMode: SearchMode = .offlineOnly
    
    /// Last search latency in milliseconds
    @Published var lastLatencyMs: Int = 0
    
    /// Source of last result (for debugging)
    @Published var lastResultSource: String = ""
    
    /// AI clarification question (if any)
    @Published var clarificationPrompt: String?
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Debounce delay in milliseconds
    private let debounceDelay: Int = 200
    
    /// Current search task (for cancellation)
    private var currentSearchTask: Task<Void, Never>?
    
    // MARK: - Initialization
    
    init() {
        setupQueryObserver()
    }
    
    // MARK: - Setup
    
    private func setupQueryObserver() {
        $query
            .debounce(for: .milliseconds(debounceDelay), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.processQuery(text)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Query Processing
    
    private func processQuery(_ text: String) {
        // Cancel any in-flight search
        currentSearchTask?.cancel()
        
        isSearching = true
        clarificationPrompt = nil
        
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            parsed = .empty
            outputs = []
            isSearching = false
            lastLatencyMs = 0
            lastResultSource = ""
            return
        }
        
        // Choose search strategy based on mode
        switch searchMode {
        case .offlineOnly:
            processOfflineOnly(text)
        case .hybrid:
            processHybrid(text)
        }
    }
    
    // MARK: - Offline-Only Search (< 10ms)
    
    private func processOfflineOnly(_ text: String) {
        let startTime = Date()
        
        // Parse the query
        var newParsedQuery = QueryParser.parse(text)
        
        // Apply global weight if available
        if newParsedQuery.weightKg == nil,
           let globalWeight = GlobalPatientContext.shared.weightKg {
            newParsedQuery.weightKg = globalWeight
        }
        
        parsed = newParsedQuery
        
        // Match against moments
        var matched = NLMomentRegistry.shared.match(newParsedQuery)

        // When query has conversion intent (from/to units detected), put conversion cards first
        if newParsedQuery.conversionFromUnit != nil && newParsedQuery.conversionToUnit != nil {
            matched = matched.sorted { a, b in
                let aConv = a.momentId.hasPrefix("conversion_")
                let bConv = b.momentId.hasPrefix("conversion_")
                if aConv && !bConv { return true }
                if !aConv && bConv { return false }
                return false
            }
        }
        // Note: Removed blind pediatric priority sort — the score-based ranking
        // from NLMomentRegistry already handles this correctly. Pediatric moments
        // that are relevant score high via their +8 boost (only when baseMatchScore > 0),
        // so they naturally rank first when appropriate.

        // Safety: when explicit adult age (>= 18), filter out pediatric-only results
        if let age = newParsedQuery.ageYears, age >= 18 {
            matched = matched.filter { !$0.momentId.contains("peds") }
        }

        outputs = matched
        
        lastLatencyMs = Int(Date().timeIntervalSince(startTime) * 1000)
        lastResultSource = "offline"
        isSearching = false
    }
    
    // MARK: - Hybrid Search (Offline + AI Fallback)
    
    private func processHybrid(_ text: String) {
        // Check if AI is configured, otherwise fall back to offline
        guard AIFallbackConfig.isEnabled && APIKeyManager.isConfigured else {
            processOfflineOnly(text)
            return
        }
        
        currentSearchTask = Task { @MainActor in
            let result = await HybridMomentSearch.shared.search(text)
            
            // Check if task was cancelled
            guard !Task.isCancelled else { return }
            
            // Apply global weight if not in query
            var finalQuery = result.query
            let weightWasMissing = finalQuery.weightKg == nil
            if weightWasMissing,
               let globalWeight = GlobalPatientContext.shared.weightKg {
                finalQuery.weightKg = globalWeight
            }

            self.parsed = finalQuery

            // If global weight was injected, re-compute moments so dose calculations use it.
            // The original result.moments were computed WITHOUT the weight.
            var moments = weightWasMissing && finalQuery.weightKg != nil
                ? NLMomentRegistry.shared.match(finalQuery)
                : result.moments

            // When query has conversion intent, put conversion cards first
            if finalQuery.conversionFromUnit != nil && finalQuery.conversionToUnit != nil {
                moments = moments.sorted { a, b in
                    let aConv = a.momentId.hasPrefix("conversion_")
                    let bConv = b.momentId.hasPrefix("conversion_")
                    if aConv && !bConv { return true }
                    if !aConv && bConv { return false }
                    return false
                }
            }
            // When query indicates pediatric, put pediatric cards first
            else if finalQuery.isPediatricIntent {
                moments = moments.sorted { a, b in
                    let aPeds = a.momentId.contains("peds")
                    let bPeds = b.momentId.contains("peds")
                    if aPeds && !bPeds { return true }
                    if !aPeds && bPeds { return false }
                    return false
                }
            }

            // Safety: when explicit adult age (>= 18), filter out pediatric-only results
            if let age = finalQuery.ageYears, age >= 18 {
                moments = moments.filter { !$0.momentId.contains("peds") }
            }

            self.outputs = moments
            self.lastLatencyMs = result.latencyMs
            self.lastResultSource = result.source.rawValue
            self.clarificationPrompt = result.clarificationPrompt
            self.isSearching = false
        }
    }
    
    // MARK: - Weight Update
    
    /// Update weight from external input (e.g., weight sheet)
    func updateWeight(kg: Double) {
        // Update global patient context
        GlobalPatientContext.shared.setWeight(from: String(kg), unit: .kg)
        
        // If there's already text in the query, re-process to include the weight
        if !query.trimmingCharacters(in: .whitespaces).isEmpty {
            var updatedParsed = parsed
            updatedParsed.weightKg = kg
            parsed = updatedParsed
            
            // Re-match with the updated parsed query
            outputs = NLMomentRegistry.shared.match(parsed)
        }
    }
    
    /// Update weight by appending to query string (alternative method)
    func appendWeight(kg: Double) {
        // Remove any existing weight from query
        let cleanedQuery = query
            .replacingOccurrences(of: #"\d+(\.\d+)?\s*(kg|lb|lbs)"#, with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
        
        // Append the new weight
        query = "\(cleanedQuery) \(String(format: "%.1f", kg))kg"
    }
    
    // MARK: - Quick Actions
    
    /// Set a sample query (for demo purposes)
    func setSampleQuery(_ sample: String) {
        query = sample
    }
    
    /// Clear the search
    func clearSearch() {
        query = ""
        parsed = .empty
        outputs = []
        clarificationPrompt = nil
        lastLatencyMs = 0
        lastResultSource = ""
    }
    
    /// Toggle between offline and hybrid mode
    func toggleSearchMode() {
        searchMode = searchMode == .offlineOnly ? .hybrid : .offlineOnly
        // Re-process current query with new mode
        if !query.isEmpty {
            processQuery(query)
        }
    }
    
    // MARK: - Debug Helpers
    
    #if DEBUG
    /// Get performance stats for debugging
    func getDebugStats() async -> String {
        await HybridMomentSearch.shared.getPerformanceStats()
    }
    
    /// Get queries that need vocabulary improvement
    func getVocabularyGaps() async -> [String] {
        await HybridMomentSearch.shared.getVocabularyGaps()
    }
    #endif
}
