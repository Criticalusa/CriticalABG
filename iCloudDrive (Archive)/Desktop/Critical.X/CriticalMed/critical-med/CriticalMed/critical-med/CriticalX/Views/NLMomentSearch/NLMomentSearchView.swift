//
//  NLMomentSearchView.swift
//  CriticalX
//
//  Natural Language Moment Search - Main Search View
//  Allows users to type clinical questions and get instant moment cards
//  Styled to match CriticalDesign system (neumorphic, Poppins fonts)
//

import SwiftUI
import Combine

// MARK: - NLMomentSearchView
/// Main search view for natural language clinical queries
struct NLMomentSearchView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = NLMomentSearchVM()
    @FocusState private var searchFieldFocused: Bool
    @State private var isSearchFocused: Bool = false
    @State private var showWeightSheet: Bool = false
    @State private var showAPIKeySetup: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    private let haptic = UIImpactFeedbackGenerator(style: .light)
    
    // Sample queries for demonstration
    private let sampleQueries = [
        ("VF Code", "5 yo 40lb vf epi dose"),
        ("Adult Sepsis", "70kg septic shock levophed"),
        ("RSI Drugs", "80kg adult rsi rocuronium"),
        ("SVT", "adult svt adenosine dose"),
        ("Anaphylaxis", "anaphylaxis epi 0.3mg"),
        ("Bradycardia", "symptomatic bradycardia atropine")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                CriticalDesign.Colors.canvas.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search header (always visible)
                    searchHeader
                    
                    // Content - dismiss keyboard on scroll
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: CriticalDesign.Spacing.lg) {
                            // Parsed chips row
                            if !viewModel.query.isEmpty {
                                ParsedChipRow(viewModel: viewModel)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            
                            // Results or empty state
                            if viewModel.outputs.isEmpty {
                                if viewModel.query.isEmpty {
                                    emptyStateView
                                } else {
                                    noResultsView
                                }
                            } else {
                                resultsList
                            }
                        }
                        .padding(.top, CriticalDesign.Spacing.md)
                        .padding(.bottom, 100)
                    }
                    .scrollDismissesKeyboard(.interactively)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.body.weight(.semibold))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.query.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: viewModel.outputs.count)
        .sheet(isPresented: $showWeightSheet) {
            WeightInputSheet(
                initialWeightKg: viewModel.parsed.weightKg,
                onSave: { weight in
                    viewModel.updateWeight(kg: weight)
                }
            )
        }
        .sheet(isPresented: $showAPIKeySetup) {
            APIKeySetupView()
        }
    }
    
    // MARK: - Search Header
    
    private var searchHeader: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Title
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("ASK A QUESTION")
                        .font(.custom("Poppins-Bold", size: 10))
                        .foregroundColor(CriticalDesign.Colors.cardBlue)
                        .tracking(1.5)
                    
                    Text("Co-Pilot Search")
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                }
                
                Spacer()
                
                // Search mode toggle
                Button(action: {
                    haptic.impactOccurred()
                    // If switching to hybrid and no API key, show setup
                    if viewModel.searchMode == .offlineOnly && !APIKeyManager.isConfigured {
                        showAPIKeySetup = true
                    } else {
                        viewModel.toggleSearchMode()
                    }
                }) {
                    VStack(spacing: 2) {
                        Image(systemName: viewModel.searchMode.icon)
                            .font(.system(size: 18))
                        
                        Text(viewModel.searchMode.rawValue)
                            .font(.custom("Poppins-Medium", size: 10))
                    }
                    .foregroundColor(viewModel.searchMode == .hybrid ? CriticalDesign.Colors.cardBlue : CriticalDesign.Colors.secondary)
                    .frame(width: 56, height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : CriticalDesign.Colors.canvas)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.08), radius: 6, x: 3, y: 3)
                            .shadow(color: Color.white.opacity(colorScheme == .dark ? 0 : 0.9), radius: 6, x: -3, y: -3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                            .stroke(
                                viewModel.searchMode == .hybrid ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.clear,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture {
                    // Long press to access API key settings
                    haptic.impactOccurred()
                    showAPIKeySetup = true
                }
                
                // Weight quick-add button
                Button(action: { showWeightSheet = true }) {
                    VStack(spacing: 2) {
                        Image(systemName: "scalemass.fill")
                            .font(.system(size: 18))
                        
                        if let weight = viewModel.parsed.weightKg {
                            Text("\(Int(weight)) kg")
                                .font(.custom("Poppins-Bold", size: 10))
                        } else {
                            Text("Weight")
                                .font(.custom("Poppins-Medium", size: 10))
                        }
                    }
                    .foregroundColor(viewModel.parsed.weightKg != nil ? CriticalDesign.Colors.goldDeep : CriticalDesign.Colors.secondary)
                    .frame(width: 56, height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : CriticalDesign.Colors.canvas)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.08), radius: 6, x: 3, y: 3)
                            .shadow(color: Color.white.opacity(colorScheme == .dark ? 0 : 0.9), radius: 6, x: -3, y: -3)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, CriticalDesign.Spacing.lg)
            
            // Search field
            HStack(spacing: CriticalDesign.Spacing.md) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSearchFocused ? CriticalDesign.Colors.cardBlue : CriticalDesign.Colors.secondary)
                
                TextField("e.g., \"5 yo 40lb vf epi dose\"", text: $viewModel.query)
                    .focused($searchFieldFocused)
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                searchFieldFocused = false
                            }
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(CriticalDesign.Colors.cardBlue)
                        }
                    }
                
                if !viewModel.query.isEmpty {
                    Button(action: {
                        haptic.impactOccurred()
                        viewModel.query = ""
                        searchFieldFocused = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    }
                }
            }
            .padding(CriticalDesign.Spacing.md + 4)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : CriticalDesign.Colors.canvas)
                    .shadow(
                        color: colorScheme == .dark ? Color.clear : (isSearchFocused ? CriticalDesign.Colors.cardBlue.opacity(0.15) : Color.black.opacity(0.08)),
                        radius: isSearchFocused ? 12 : 8,
                        x: 4, y: 4
                    )
                    .shadow(color: Color.white.opacity(colorScheme == .dark ? 0 : 0.9), radius: 8, x: -4, y: -4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .stroke(
                        isSearchFocused ? CriticalDesign.Colors.cardBlue.opacity(0.4) : Color.clear,
                        lineWidth: 2
                    )
            )
            .padding(.horizontal, CriticalDesign.Spacing.lg)
            .onChange(of: searchFieldFocused) { focused in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isSearchFocused = focused
                }
            }
        }
        .padding(.vertical, CriticalDesign.Spacing.md)
        .background(
            Rectangle()
                .fill(CriticalDesign.Colors.canvas)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: CriticalDesign.Spacing.xl) {
            // Icon
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.cardBlue.opacity(0.08))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "text.magnifyingglass")
                    .font(.system(size: 44, weight: .light))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
            }
            
            VStack(spacing: 8) {
                Text("Search Co-Pilot")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text("Type a clinical question to get instant\ndose calculations and protocols")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
            }
            
            // Example queries
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                Text("TRY THESE EXAMPLES")
                    .font(.custom("Poppins-Bold", size: 10))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .tracking(1)
                    .padding(.horizontal, CriticalDesign.Spacing.md)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(sampleQueries, id: \.0) { label, query in
                        ExampleQueryButton(label: label, query: query) {
                            haptic.impactOccurred()
                            viewModel.query = query
                            searchFieldFocused = false
                        }
                    }
                }
            }
            .padding(CriticalDesign.Spacing.lg)
            .background(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(CriticalDesign.Colors.cardBlue)
                    } else {
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 5, y: 5)
                            .shadow(color: Color.white.opacity(0.9), radius: 10, x: -5, y: -5)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
            )
            .padding(.horizontal, CriticalDesign.Spacing.lg)
        }
        .padding(.top, CriticalDesign.Spacing.xl)
    }
    
    // MARK: - No Results View
    
    private var noResultsView: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            // Loading indicator when searching with AI
            if viewModel.isSearching && viewModel.searchMode == .hybrid {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: CriticalDesign.Colors.cardBlue))
                    .scaleEffect(1.2)
                
                Text("Searching...")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            } else {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                
                VStack(spacing: 4) {
                    Text("No moments found")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Text(viewModel.searchMode == .hybrid 
                         ? "Try rephrasing or use more specific terms"
                         : "Try adding a drug name, scenario, or weight")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                }
                
                // Suggest switching to hybrid mode if offline
                if viewModel.searchMode == .offlineOnly {
                    Button(action: {
                        haptic.impactOccurred()
                        viewModel.toggleSearchMode()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                            Text("Try AI-Enhanced Search")
                        }
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [CriticalDesign.Colors.cardBlue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Quick weight add if missing
                if viewModel.parsed.weightKg == nil {
                    Button(action: { showWeightSheet = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Patient Weight")
                        }
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(CriticalDesign.Colors.cardBlue)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, CriticalDesign.Spacing.xl * 2)
    }
    
    // MARK: - Results List
    
    private var resultsList: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Results header with stats
            HStack {
                Text("\(viewModel.outputs.count) \(viewModel.outputs.count == 1 ? "moment" : "moments") found")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                
                Spacer()
                
                // Search mode & latency indicator
                searchStatsIndicator
            }
            .padding(.horizontal, CriticalDesign.Spacing.lg)
            
            // AI clarification prompt (if any)
            if let clarification = viewModel.clarificationPrompt {
                clarificationBanner(clarification)
            }
            
            // Moment cards — use InlinePedsDoseCard for pediatric moments (inline dose, not redirect)
            ForEach(viewModel.outputs) { output in
                Group {
                    if output.momentId.contains("peds") {
                        InlinePedsDoseCard(output: output) {
                            showWeightSheet = true
                        }
                    } else {
                        NLMomentCard(output: output) {
                            showWeightSheet = true
                        }
                    }
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
            }
        }
    }
    
    // MARK: - Search Stats Indicator
    
    private var searchStatsIndicator: some View {
        HStack(spacing: 6) {
            // Search mode icon
            Image(systemName: viewModel.searchMode.icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(sourceColor)
            
            // Latency
            if viewModel.lastLatencyMs > 0 {
                Text("\(viewModel.lastLatencyMs)ms")
                    .font(.custom("Poppins-Medium", size: 10))
                    .foregroundColor(latencyColor)
            }
            
            // Source badge
            if !viewModel.lastResultSource.isEmpty {
                Text(sourceLabel)
                    .font(.custom("Poppins-Bold", size: 8))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(sourceColor)
                    )
            }
        }
        .onTapGesture {
            // Toggle search mode on tap
            haptic.impactOccurred()
            viewModel.toggleSearchMode()
        }
    }
    
    private var sourceLabel: String {
        switch viewModel.lastResultSource {
        case "offline": return "OFFLINE"
        case "ai": return "AI"
        case "cached_ai": return "CACHED"
        default: return ""
        }
    }
    
    private var sourceColor: Color {
        switch viewModel.lastResultSource {
        case "offline": return CriticalDesign.Colors.goldDeep
        case "ai": return CriticalDesign.Colors.cardBlue
        case "cached_ai": return .purple
        default: return CriticalDesign.Colors.secondary
        }
    }
    
    private var latencyColor: Color {
        if viewModel.lastLatencyMs < 50 {
            return CriticalDesign.Colors.goldDeep
        } else if viewModel.lastLatencyMs < 200 {
            return CriticalDesign.Colors.cardBlue
        } else {
            return .orange
        }
    }
    
    // MARK: - AI Clarification Banner
    
    private func clarificationBanner(_ text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 16))
                .foregroundColor(CriticalDesign.Colors.cardBlue)
            
            Text(text)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Spacer()
        }
        .padding(CriticalDesign.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(CriticalDesign.Colors.cardBlue.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(CriticalDesign.Colors.cardBlue.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
}

// MARK: - ExampleQueryButton
/// Button for example queries
private struct ExampleQueryButton: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let query: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.custom("Poppins-Bold", size: 13))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)

                Text(query)
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(CriticalDesign.Spacing.sm + 4)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : CriticalDesign.Colors.canvas)
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.06), radius: 4, x: 2, y: 2)
                    .shadow(color: Color.white.opacity(colorScheme == .dark ? 0 : 0.8), radius: 4, x: -2, y: -2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    NLMomentSearchView()
}
