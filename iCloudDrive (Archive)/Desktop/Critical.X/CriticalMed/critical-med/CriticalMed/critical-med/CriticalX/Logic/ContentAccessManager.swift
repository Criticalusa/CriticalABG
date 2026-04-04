//
//  ContentAccessManager.swift
//  CriticalX
//
//  Central gating logic for free vs premium content.
//  Works with SubscriptionManager and EnterpriseLicenseManager.
//

import SwiftUI

// MARK: - Content Access Manager

/// Manages access to premium content based on subscription status.
/// Use this to determine what content is free vs requires upgrade.
@MainActor
class ContentAccessManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = ContentAccessManager()
    
    // MARK: - Dependencies
    
    private let subscriptionManager = SubscriptionManager.shared
    /// Enterprise license check; when EnterpriseLicenseManager is in target, can replace with EnterpriseLicenseManager.shared.hasEnterpriseLicense
    private var hasEnterpriseLicense: Bool { false }
    
    // MARK: - Beta/Debug Access
    
    /// Returns true if running via TestFlight (beta build)
    static var isTestFlight: Bool {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return false }
        return receiptURL.lastPathComponent == "sandboxReceipt"
    }
    
    /// Returns true if running in DEBUG mode (Xcode)
    static var isDebugBuild: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    /// Manual override for testing (set via Settings or secret gesture)
    @Published var manualUnlockEnabled: Bool = false
    
    /// Whether beta testers should get full access
    /// Set to false before App Store release if you want to test the paywall in TestFlight
    static let grantBetaTestersFullAccess: Bool = true
    
    // MARK: - Computed Access
    
    /// Whether user has full access (Pro subscription OR Enterprise license OR Beta tester OR Debug)
    var hasFullAccess: Bool {
        // Beta testers and debug builds get full access
        if Self.grantBetaTestersFullAccess && (Self.isTestFlight || Self.isDebugBuild) {
            return true
        }
        
        // Manual unlock (for demos, testing)
        if manualUnlockEnabled {
            return true
        }
        
        // Normal access check
        return subscriptionManager.isProSubscribed || hasEnterpriseLicense
    }
    
    /// Whether user is on free tier (no subscription, no enterprise)
    var isFreeTier: Bool {
        !hasFullAccess
    }
    
    /// Returns the reason for full access (for display/debugging)
    var accessReason: String {
        if Self.isDebugBuild { return "Debug Build" }
        if Self.isTestFlight { return "TestFlight Beta" }
        if manualUnlockEnabled { return "Manual Unlock" }
        if hasEnterpriseLicense { return "Enterprise License" }
        if subscriptionManager.isProSubscribed { return "Pro Subscription" }
        return "Free Tier"
    }
    
    // MARK: - Free Content Definitions
    
    /// Medications that are available for free (by slug/ID)
    static let freeMedications: Set<String> = [
        "epinephrine",
        "adenosine",
        "atropine"
    ]
    
    /// Drips that are available for free (by slug/ID)
    static let freeDrips: Set<String> = [
        "norepinephrine",
        "dopamine"
    ]
    
    /// Calculators that are available for free (by title slugified)
    static let freeCalculators: Set<String> = [
        "body-mass-index",      // BMI Calculator
        "shock-index",          // Cardiovascular
        "unit-converter"        // Conversions
    ]
    
    /// EKG rhythms that are available for free
    static let freeEKGRhythms: Set<String> = [
        "nsr",
        "normal-sinus-rhythm"
    ]
    
    /// Moments that are available for free (one per category)
    /// Maps to moment type identifiers
    static let freeMoments: Set<String> = [
        "cardiac",              // CardiacMoment
        "abg",                  // ABGMoment (one free)
        "ekg",                  // EKGMoment (basic only)
        "airway"                // AirwayMoment (one free)
    ]
    
    /// ACLS quiz questions available for free (first N)
    static let freeACLSQuestionCount: Int = 2
    
    /// Pediatrics - only basic weight reference is free
    static let freePediatricsFeatures: Set<String> = [
        "weight-reference",
        "broselow-colors",
        "vital-signs"           // Basic vital signs reference
    ]
    
    /// Home page sections available for free (limited)
    static let freeHomeSections: Set<String> = [
        "medications",          // Shows first 3 meds
        "drips",                // Shows first 2 drips
        "calculators",          // Shows 2 calculators
        "ekg"                   // Shows NSR only
    ]
    
    // MARK: - Content Type Enum
    
    enum ContentType {
        case medication
        case drip
        case calculator
        case ekgRhythm
        case moment
        case aclsQuiz
        case pediatrics
        case other
    }
    
    // MARK: - Access Check Methods
    
    /// Check if specific content is accessible
    /// - Parameters:
    ///   - id: Content identifier (slug or ID)
    ///   - type: Type of content
    /// - Returns: true if content is accessible (free or user has subscription)
    func canAccess(id: String, type: ContentType) -> Bool {
        // Full access users can see everything
        if hasFullAccess { return true }
        
        // Check free content based on type
        let normalizedId = id.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch type {
        case .medication:
            return Self.freeMedications.contains(normalizedId)
        case .drip:
            return Self.freeDrips.contains(normalizedId)
        case .calculator:
            return Self.freeCalculators.contains(normalizedId)
        case .ekgRhythm:
            return Self.freeEKGRhythms.contains(normalizedId)
        case .moment:
            return Self.freeMoments.contains(normalizedId)
        case .pediatrics:
            return Self.freePediatricsFeatures.contains(normalizedId)
        case .aclsQuiz:
            return false // Handled by index-based check
        case .other:
            return false // Other content requires subscription
        }
    }
    
    /// Check if medication is accessible by name
    func canAccessMedication(_ name: String) -> Bool {
        canAccess(id: name.slugified, type: .medication)
    }
    
    /// Check if drip is accessible by name
    func canAccessDrip(_ name: String) -> Bool {
        canAccess(id: name.slugified, type: .drip)
    }
    
    /// Check if calculator is accessible
    func canAccessCalculator(_ id: String) -> Bool {
        canAccess(id: id, type: .calculator)
    }
    
    /// Check if EKG rhythm is accessible
    func canAccessEKGRhythm(_ id: String) -> Bool {
        canAccess(id: id, type: .ekgRhythm)
    }
    
    /// Check if moment is accessible
    func canAccessMoment(_ id: String) -> Bool {
        canAccess(id: id, type: .moment)
    }
    
    /// Check if ACLS question at index is accessible
    func canAccessACLSQuestion(at index: Int) -> Bool {
        if hasFullAccess { return true }
        return index < Self.freeACLSQuestionCount
    }
    
    /// Check if pediatrics feature is accessible
    func canAccessPediatricsFeature(_ feature: String) -> Bool {
        canAccess(id: feature, type: .pediatrics)
    }
    
    // MARK: - List Filtering
    
    /// Filter a list of medications to show accessible ones first, then locked
    func sortMedications<T>(_ medications: [T], idKeyPath: KeyPath<T, String>) -> (accessible: [T], locked: [T]) {
        if hasFullAccess {
            return (medications, [])
        }
        
        var accessible: [T] = []
        var locked: [T] = []
        
        for med in medications {
            let id = med[keyPath: idKeyPath].slugified
            if Self.freeMedications.contains(id) {
                accessible.append(med)
            } else {
                locked.append(med)
            }
        }
        
        return (accessible, locked)
    }
    
    /// Get the count of free items for display ("3 of 79 medications")
    func freeContentSummary(for type: ContentType, total: Int) -> String {
        let freeCount: Int
        switch type {
        case .medication:
            freeCount = Self.freeMedications.count
        case .drip:
            freeCount = Self.freeDrips.count
        case .calculator:
            freeCount = Self.freeCalculators.count
        case .ekgRhythm:
            freeCount = Self.freeEKGRhythms.count
        case .moment:
            freeCount = Self.freeMoments.count
        case .aclsQuiz:
            freeCount = Self.freeACLSQuestionCount
        case .pediatrics:
            freeCount = Self.freePediatricsFeatures.count
        case .other:
            freeCount = 0
        }
        
        return "\(freeCount) of \(total) available"
    }
}

// MARK: - String Extension for Slug

extension String {
    /// Convert string to URL-friendly slug
    var slugified: String {
        self.lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "/", with: "-")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Upgrade Prompt Modifier

/// View modifier that shows upgrade prompt when content is locked
struct PremiumContentModifier: ViewModifier {
    let contentId: String
    let contentType: ContentAccessManager.ContentType
    @State private var showUpgradeSheet = false
    
    @ObservedObject private var accessManager = ContentAccessManager.shared
    
    func body(content: Content) -> some View {
        if accessManager.canAccess(id: contentId, type: contentType) {
            content
        } else {
            // Show locked overlay
            content
                .overlay(
                    LockedContentOverlay(showUpgradeSheet: $showUpgradeSheet)
                )
                .sheet(isPresented: $showUpgradeSheet) {
                    UpgradePromptView()
                }
        }
    }
}

// MARK: - Locked Content Overlay

struct LockedContentOverlay: View {
    @Binding var showUpgradeSheet: Bool
    
    var body: some View {
        ZStack {
            // Blur background
            Color.black.opacity(0.4)
            
            VStack(spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                Text("Premium Content")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(.white)
                
                Text("Start your 7-day free trial to unlock")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.8))
                
                Button {
                    showUpgradeSheet = true
                } label: {
                    Text("Unlock Now")
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(CriticalDesign.Colors.cardBlue)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(CriticalDesign.Colors.gold))
                }
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Upgrade Prompt View

struct UpgradePromptView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                CriticalDesign.Colors.canvas.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Hero
                        VStack(spacing: 12) {
                            Image("icon-critical")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            
                            Text("Unlock CriticalMed Pro")
                                .font(.custom("Poppins-Bold", size: 28))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            
                            Text("7-day free trial, cancel anytime")
                                .font(.custom("Poppins-Medium", size: 16))
                                .foregroundColor(CriticalDesign.Colors.gold)
                        }
                        .padding(.top, 20)
                        
                        // Features
                        VStack(alignment: .leading, spacing: 16) {
                            featureRow(icon: "pills.fill", title: "79+ Medications", subtitle: "Complete drug database with dosing")
                            featureRow(icon: "drop.fill", title: "All Drips & Calculators", subtitle: "Weight-based calculations")
                            featureRow(icon: "waveform.path.ecg", title: "EKG Interpretation", subtitle: "15 rhythms with action plans")
                            featureRow(icon: "brain.head.profile", title: "Luca AI Assistant", subtitle: "Clinical guidance on demand")
                            featureRow(icon: "checkmark.seal.fill", title: "ACLS Test Prep", subtitle: "Practice quizzes with explanations")
                            featureRow(icon: "figure.child", title: "Pediatric Dosing", subtitle: "PALS-aligned weight-based doses")
                        }
                        .padding(.horizontal, 20)
                        
                        // Pricing
                        VStack(spacing: 12) {
                            // Yearly (best value)
                            pricingOption(
                                title: "Yearly",
                                price: "$99.99/year",
                                subtitle: "Best value — Save 44%",
                                isRecommended: true
                            )
                            
                            // Monthly
                            pricingOption(
                                title: "Monthly",
                                price: "$14.99/month",
                                subtitle: "Flexible, cancel anytime",
                                isRecommended: false
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // CTA
                        Button {
                            // Trigger purchase flow
                            // subscriptionManager.purchase(...)
                            dismiss()
                        } label: {
                            Text("Start Free Trial")
                                .font(.custom("Poppins-Bold", size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(CriticalDesign.Colors.cardBlue)
                                )
                        }
                        .padding(.horizontal, 20)
                        
                        // Terms
                        Text("7-day free trial. Cancel anytime. Subscription auto-renews.")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Maybe Later") { dismiss() }
                }
            }
        }
    }
    
    private func featureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(CriticalDesign.Colors.gold)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(CriticalDesign.Colors.accentGreen)
        }
    }
    
    private func pricingOption(title: String, price: String, subtitle: String, isRecommended: Bool) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    if isRecommended {
                        Text("BEST VALUE")
                            .font(.custom("Poppins-Bold", size: 10))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(CriticalDesign.Colors.gold))
                    }
                }
                
                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            
            Spacer()
            
            Text(price)
                .font(.custom("Poppins-Bold", size: 18))
                .foregroundColor(CriticalDesign.Colors.gold)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isRecommended ? CriticalDesign.Colors.gold : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - View Extension for Premium Content

extension View {
    /// Apply premium content gating to a view
    func premiumContent(id: String, type: ContentAccessManager.ContentType) -> some View {
        self.modifier(PremiumContentModifier(contentId: id, contentType: type))
    }
}
