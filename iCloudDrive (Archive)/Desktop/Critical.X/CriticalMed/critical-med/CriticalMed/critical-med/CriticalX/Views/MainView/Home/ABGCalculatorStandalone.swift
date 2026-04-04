//
//  ABGCalculatorStandalone.swift
//  CriticalX
//
//  Comprehensive ABG Calculator & Learning Tool
//  Includes Winter's Formula, Henderson-Hasselbalch, Base Excess, and more
//  Redesigned: Premium Light Theme matching BMI Calculator
//

import SwiftUI

// MARK: - Validation Types (for ABG inputs)
struct ValidationRange {
    let min: Double
    let max: Double
    let sigFigs: Int
    let unit: String

    var normalRangeText: String {
        if sigFigs == 0 {
            return "\(Int(min)) - \(Int(max))"
        } else {
            return String(format: "%.\(sigFigs)f - %.\(sigFigs)f", min, max)
        }
    }

    func validate(_ value: Double) -> ABGValidationResult {
        if value < min {
            return .tooLow(minValue: min)
        } else if value > max {
            return .tooHigh(maxValue: max)
        } else {
            return .valid
        }
    }

    func validateString(_ text: String) -> ABGValidationResult {
        guard let value = Double(text) else {
            return .invalid
        }
        return validate(value)
    }
}

enum ABGValidationResult {
    case valid
    case tooLow(minValue: Double)
    case tooHigh(maxValue: Double)
    case invalid

    var isValid: Bool {
        if case .valid = self { return true }
        return false
    }

    var errorMessage: String? {
        switch self {
        case .valid: return nil
        case .tooLow(let minValue): return "Value too low (min: \(Int(minValue)))"
        case .tooHigh(let maxValue): return "Value too high (max: \(Int(maxValue)))"
        case .invalid: return "Invalid value"
        }
    }
}

struct InputValidationRules {
    struct ABG {
        static let pH = ValidationRange(min: 6.0, max: 8.0, sigFigs: 2, unit: "")
        static let paCO2 = ValidationRange(min: 5, max: 150, sigFigs: 0, unit: "mmHg")
        static let hco3 = ValidationRange(min: 1, max: 60, sigFigs: 0, unit: "mEq/L")
        static let paO2 = ValidationRange(min: 0, max: 700, sigFigs: 0, unit: "mmHg")
        static let sodium = ValidationRange(min: 100, max: 180, sigFigs: 0, unit: "mEq/L")
        static let chloride = ValidationRange(min: 70, max: 140, sigFigs: 0, unit: "mEq/L")
        static let albumin = ValidationRange(min: 0.5, max: 7.0, sigFigs: 1, unit: "g/dL")
    }
}

// MARK: - ABG Calculator Standalone View
struct ABGCalculatorStandalone: View {
    @Environment(\.colorScheme) var colorScheme

    // MARK: - State Properties
    @State private var pH: String = ""
    @State private var paCO2: String = ""
    @State private var hco3: String = ""
    @State private var sodium: String = ""
    @State private var chloride: String = ""
    @State private var albumin: String = ""
    
    // Advanced inputs for Osmolar Gap & A-a Gradient
    @State private var glucose: String = ""          // mg/dL for osmolar gap
    @State private var bun: String = ""              // mg/dL for osmolar gap
    @State private var measuredOsm: String = ""      // mOsm/kg for osmolar gap
    @State private var paO2: String = ""             // mmHg for A-a gradient
    @State private var fio2: String = ""             // 0.21-1.0 for A-a gradient
    @State private var patientAge: String = ""       // years for A-a gradient normal calculation
    @State private var showAdvancedInputs: Bool = false

    @State private var showResults = false
    @State private var interpretation: ABGComprehensiveInterpretation?
    @State private var isAppearing = false
    @State private var pulseAnimation = false
    
    // MARK: - Floating Score State
    @State private var showFloatingScore = false
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollY: CGFloat? = nil
    private let scoreCardScrollThreshold: CGFloat = 350
    
    // MARK: - Keyboard State
    @State private var keyboardHeight: CGFloat = 0
    @State private var isFavorite = false
    @State private var selectedLearnTab: LearnTab = .formulas
    @State private var showLearnSheet = false
    @State private var expandedFormula: String? = nil
    @State private var showInfoSection = false

    // Gamification State
    @State private var calculationCount: Int = UserDefaults.standard.integer(forKey: "abg_calculation_count")
    @State private var showConfetti: Bool = false
    @State private var showPulseRing: Bool = false
    @State private var showSparkle: Bool = false
    @State private var showSuccessGlow: Bool = false
    @State private var showFireworks: Bool = false
    @State private var showCheckmark: Bool = false
    @State private var newBadgeUnlocked: ABGAchievementBadge? = nil

    @FocusState private var focusedField: ABGField?
    @Environment(\.dismiss) private var dismiss

    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    private let successHaptic = UINotificationFeedbackGenerator()

    // MARK: - Brand Colors (from Design.md / CalculatorDesign.md)
    private let textPrimary = Color(red: 0.04, green: 0.09, blue: 0.16)      // #0A1628
    private let textSecondary = Color(red: 0.11, green: 0.21, blue: 0.34)    // #1D3557
    private let textTertiary = Color(red: 0.24, green: 0.35, blue: 0.50)     // #3D5A80
    private let textMuted = Color(red: 0.42, green: 0.49, blue: 0.54)        // #6B7C8A

    // Accent Colors (from CalculatorDesign.md)
    private let accentBlue = Color(red: 0.06, green: 0.60, blue: 0.97)       // #1098F7 Bright Blue
    private let navyAccent = Color(red: 0.18, green: 0.25, blue: 0.34)       // #2E4057 Deep Navy
    private let accentGreen = Color(red: 0.40, green: 0.84, blue: 0.72)      // #66D6B8 Mint/Teal
    private let textGreen = Color(red: 0.02, green: 0.55, blue: 0.45)        // #038F73 Dark Teal for text
    private let accentOrange = Color(red: 0.85, green: 0.34, blue: 0.17)     // #D8572C Burnt Orange
    private let accentRed = Color(red: 0.92, green: 0.32, blue: 0.38)        // #EB5160 Coral Red
    private let accentPurple = Color(red: 0.58, green: 0.39, blue: 0.87)     // Purple for formulas

    // Amber Gold (signature accent - 2% usage)
    private let goldColor = Color(red: 0.96, green: 0.71, blue: 0.0)         // #F5B400 Deep Amber
    private let goldDeep = Color(red: 0.85, green: 0.60, blue: 0.0)          // #D99900 Darker Amber
    
    enum ABGField: Hashable, CaseIterable {
        case pH, paCO2, hco3, sodium, chloride, albumin
    }

    enum LearnTab: String, CaseIterable {
        case formulas = "Formulas"
        case disorders = "Disorders"
        case compensation = "Compensation"
    }

    // Achievement badges
    private var earnedBadges: [ABGAchievementBadge] {
        var badges: [ABGAchievementBadge] = []

        if calculationCount >= 1 {
            badges.append(ABGAchievementBadge(icon: "star.fill", title: "First Analysis", color: goldColor))
        }
        if calculationCount >= 10 {
            badges.append(ABGAchievementBadge(icon: "flame.fill", title: "On Fire", color: accentOrange))
        }
        if calculationCount >= 50 {
            badges.append(ABGAchievementBadge(icon: "trophy.fill", title: "ABG Expert", color: navyAccent))
        }
        if calculationCount >= 100 {
            badges.append(ABGAchievementBadge(icon: "crown.fill", title: "Master", color: goldColor))
        }

        return badges
    }

    // MARK: - Info Sections
    private let infoSections: [(title: String, icon: String, content: String)] = [
        (
            title: "When to Use",
            icon: "timer",
            content: """
            Use the **ABG Analyzer** to interpret arterial blood gas results and identify **acid-base disorders**.

            **Clinical Scenarios:**
            • Respiratory distress evaluation
            • **Metabolic acidosis/alkalosis** workup
            • Ventilator management
            • Shock and sepsis assessment
            • DKA and toxic ingestions
            """
        ),
        (
            title: "Key Points",
            icon: "checkmark.seal.fill",
            content: """
            **Normal Values:**
            • **pH:** 7.35-7.45
            • **PaCO₂:** 35-45 mmHg
            • **HCO₃⁻:** 22-26 mEq/L
            • **Base Excess:** -2 to +2 mEq/L

            **Key Formulas:**
            • **Winter's:** Expected PaCO₂ = (1.5 × HCO₃⁻) + 8 ± 2
            • **Anion Gap:** Na⁺ - (Cl⁻ + HCO₃⁻)
            • **Delta Ratio:** (AG - 12) / (24 - HCO₃⁻)
            """
        ),
        (
            title: "Clinical Use",
            icon: "stethoscope",
            content: """
            **Systematic Approach:**
            1. Assess **pH** (acidemia vs alkalemia)
            2. Identify **primary disorder** (respiratory vs metabolic)
            3. Calculate **expected compensation**
            4. Check **anion gap** if acidosis
            5. Calculate **delta ratio** if HAGMA

            **Remember:** Compensation never fully corrects pH. If pH is normal with abnormal values, consider **mixed disorder**.
            """
        )
    ]
    
    // MARK: - Scroll Tracking Overlay
    private var scrollTrackingOverlay: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear {
                    if initialScrollY == nil {
                        initialScrollY = geo.frame(in: .global).minY
                    }
                }
                .onChange(of: geo.frame(in: .global).minY) { newValue in
                    if initialScrollY == nil {
                        initialScrollY = newValue
                    }
                    let offset = (initialScrollY ?? newValue) - newValue
                    scrollOffset = max(0, offset)
                }
        }
    }
    
    // MARK: - Main Scroll Content
    private var mainScrollContent: some View {
        VStack(spacing: 20) {
            headerSection
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 20)

            heroSection
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 25)

            if !earnedBadges.isEmpty {
                achievementSection
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 30)
            }

            IconTabBar(sections: infoSections)
                .padding(.horizontal, 20)
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 35)

            if !pH.isEmpty && !paCO2.isEmpty {
                liveStatusPreview
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 40)
            }

            inputSection
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 45)

            if !pH.isEmpty && !paCO2.isEmpty {
                calculatedValuesCard
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity),
                        removal: .opacity
                    ))
            }

            analyzeButton
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 50)

            if showResults, let result = interpretation {
                resultsSection(result)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity),
                        removal: .opacity
                    ))
            }

            learnButton
                .padding(.horizontal, 20)
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 55)

            ABGProtocolDisclaimer()
                .padding(.horizontal, 20)
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 60)

            // Dynamic padding for keyboard + toolbar - ensures fields can scroll above keyboard
            Spacer(minLength: max(120, keyboardHeight + 250))
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .overlay(scrollTrackingOverlay)
    }
    
    // MARK: - Scrollable Content
    private var scrollableContent: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                mainScrollContent
            }
            .safeAreaInset(edge: .bottom) {
                // Invisible spacer that grows with keyboard
                Color.clear.frame(height: keyboardHeight > 0 ? keyboardHeight : 0)
            }
            .scrollDismissesKeyboard(.immediately)
            .onChange(of: focusedField) { newField in
                // Scroll to focused field with delay for keyboard animation
                guard let field = newField else { return }
                // Scroll after keyboard appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo(field)
                    }
                }
            }
            .onChange(of: keyboardHeight) { newHeight in
                // Re-scroll when keyboard height changes
                if newHeight > 0, let field = focusedField {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(field)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Celebration Overlays
    @ViewBuilder
    private var celebrationOverlays: some View {
        if showConfetti {
            ABGConfettiView()
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }

        if showPulseRing {
            ABGPulseRingView(color: accentGreen)
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }

        if showSparkle {
            ABGSparkleView()
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }

        if showSuccessGlow {
            ABGSuccessGlowView(color: accentGreen)
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }

        if showFireworks {
            ABGFireworksView()
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }

        if showCheckmark {
            ABGCheckmarkView(color: accentGreen)
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ABGLightBackground()
            scrollableContent
            
            if showFloatingScore, let result = interpretation {
                floatingABGScore(result)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity).combined(with: .move(edge: .top)),
                        removal: .scale(scale: 0.9).combined(with: .opacity)
                    ))
                    .zIndex(100)
            }

            celebrationOverlays
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                keyboardToolbar
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
            // Keyboard observers
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main
            ) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation(.easeOut(duration: 0.25)) {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            }
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main
            ) { _ in
                withAnimation(.easeOut(duration: 0.25)) {
                    keyboardHeight = 0
                }
            }
        }
        .onChange(of: scrollOffset) { _ in
            updateFloatingVisibility()
        }
        .onChange(of: showResults) { _ in
            updateFloatingVisibility()
        }
        .sheet(isPresented: $showLearnSheet) {
            ABGLearnView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CriticalFavoriteButton(title: "ABG Calculator", type: "Cal")
            }
        }
    }
    
    // MARK: - Floating Score Visibility
    private func updateFloatingVisibility() {
        let shouldShow = showResults && interpretation != nil && scrollOffset > scoreCardScrollThreshold
        if shouldShow != showFloatingScore {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                showFloatingScore = shouldShow
            }
        }
    }
    
    // MARK: - Floating ABG Score View
    private func floatingABGScore(_ result: ABGComprehensiveInterpretation) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Status icon with glow
            ZStack {
                Circle()
                    .fill(result.severityColor.opacity(0.2))
                    .frame(width: 46, height: 46)
                    .blur(radius: 4)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [result.severityColor, result.severityColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .shadow(color: result.severityColor.opacity(0.4), radius: 6, x: 0, y: 3)
                
                Image(systemName: severityIcon(for: result.severity))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Interpretation details
            VStack(alignment: .leading, spacing: 4) {
                Text("ABG Analysis")
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(.secondary)
                
                Text(result.primaryDisorder)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(result.severityColor)
                    .lineLimit(1)
                
                // pH chip
                HStack(spacing: 4) {
                    Text("pH")
                        .font(.custom("Poppins-Bold", size: 9))
                        .foregroundColor(accentBlue)
                    Text(pH)
                        .font(.custom("Poppins-Bold", size: 9))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(accentBlue.opacity(0.15))
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private func severityIcon(for severity: ABGComprehensiveInterpretation.Severity) -> String {
        switch severity {
        case .normal: return "checkmark"
        case .mild: return "exclamationmark"
        case .moderate: return "exclamationmark.triangle.fill"
        case .severe: return "exclamationmark.octagon.fill"
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                haptic.impactOccurred()
                resetCalculator()
            }) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(textSecondary)
                    .frame(width: 48, height: 48)
            }
            .buttonStyle(CriticalNeumorphicIconButtonStyle())

            Spacer()

            // Calculation counter badge
            if calculationCount > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 12))
                    Text("\(calculationCount)")
                        .font(.custom("Poppins-Bold", size: 12))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(accentBlue)
                )
            }
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            // Glass icon container with status ring
            ZStack {
                Circle()
                    .fill(statusColor.opacity(0.12))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)

                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 80, height: 80)

                    Circle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 80, height: 80)

                    Circle()
                        .stroke(Color.white, lineWidth: 1.5)
                        .frame(width: 80, height: 80)

                    // Status Ring (shows when values entered)
                    if !pH.isEmpty && !paCO2.isEmpty {
                        Circle()
                            .trim(from: 0, to: statusRingProgress)
                            .stroke(
                                statusColor,
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 70, height: 70)
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(response: 0.8, dampingFraction: 0.7), value: statusRingProgress)
                    }

                    // Center content
                    VStack(spacing: 2) {
                        if !pH.isEmpty {
                            Text(pH)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(statusColor)
                        } else {
                            // Animated blood drop icon for ABG
                            AnimatedBloodDropIcon(color: accentRed, size: 40)
                        }
                    }
                }
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("ABG Analyzer")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(textPrimary)

            Text("Comprehensive Blood Gas Interpretation")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(textSecondary)
        }
        .padding(.bottom, 8)
    }

    // Status color based on pH
    private var statusColor: Color {
        guard let phValue = Double(pH) else { return accentBlue }
        if phValue < 7.35 { return accentRed }
        if phValue > 7.45 { return accentOrange }
        return accentGreen
    }

    // Status ring progress based on pH deviation
    private var statusRingProgress: Double {
        guard let phValue = Double(pH), phValue > 0 else { return 0 }
        let normalizedPH = min(max(phValue, 6.8), 7.8)
        return (normalizedPH - 6.8) / 1.0
    }

    // MARK: - Achievement Section
    private var achievementSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "medal.fill")
                    .foregroundColor(goldColor)
                Text("Achievements")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(textPrimary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(earnedBadges, id: \.title) { badge in
                        ABGBadgeView(badge: badge)
                    }
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    // MARK: - Live Status Preview
    private var liveStatusPreview: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(statusColor)
                .frame(width: 10, height: 10)

            Text(liveStatusText)
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(statusColor)

            Spacer()

            Text("Live Preview")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(textTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(statusColor.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(statusColor.opacity(0.2), lineWidth: 1)
        )
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .animation(.spring(response: 0.3), value: pH)
    }

    private var liveStatusText: String {
        guard let phValue = Double(pH) else { return "Enter values..." }
        if phValue < 7.35 { return "Acidemia" }
        if phValue > 7.45 { return "Alkalemia" }
        return "Normal pH"
    }

    // Reset calculator
    private func resetCalculator() {
        pH = ""
        paCO2 = ""
        hco3 = ""
        sodium = ""
        chloride = ""
        albumin = ""
        // Reset advanced inputs
        glucose = ""
        bun = ""
        measuredOsm = ""
        paO2 = ""
        fio2 = ""
        patientAge = ""
        showAdvancedInputs = false
        showResults = false
        interpretation = nil
    }
    
    // MARK: - Input Section (with section dividers)
    private var inputSection: some View {
        VStack(spacing: 16) {
            // Primary ABG Values Section
            ABGSectionDivider(title: "Primary Values")

            // pH Card - validates 6.5-8.0 (physiologically possible range)
            ABGNewInputCard(
                icon: "drop.fill",
                title: "pH",
                value: $pH,
                unit: "",
                placeholder: "7.40",
                normalRange: "7.35 - 7.45",
                accentColor: accentRed,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                status: getpHStatus(),
                validationRange: InputValidationRules.ABG.pH
            )
            .id(ABGField.pH)
            .focused($focusedField, equals: .pH)
            .onChange(of: pH) { _ in
                autoCalculateBicarb()
                if showResults { analyzeABG() }
            }

            // PaCO2 Card - validates 10-150 mmHg
            ABGNewInputCard(
                icon: "wind",
                title: "PaCO₂",
                value: $paCO2,
                unit: "mmHg",
                placeholder: "40",
                normalRange: "35 - 45",
                accentColor: navyAccent,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                status: getCO2Status(),
                validationRange: InputValidationRules.ABG.paCO2
            )
            .id(ABGField.paCO2)
            .focused($focusedField, equals: .paCO2)
            .onChange(of: paCO2) { _ in
                autoCalculateBicarb()
                if showResults { analyzeABG() }
            }

            // HCO3 Card - validates 1-60 mEq/L
            ABGNewInputCard(
                icon: "testtube.2",
                title: "HCO₃⁻",
                value: $hco3,
                unit: "mEq/L",
                placeholder: calculatedHCO3Display,
                normalRange: "22 - 26",
                accentColor: accentBlue,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                status: getHCO3Status(),
                isCalculated: hco3.isEmpty && calculatedHCO3 != nil,
                validationRange: InputValidationRules.ABG.hco3
            )
            .id(ABGField.hco3)
            .focused($focusedField, equals: .hco3)

            // Anion Gap Section (Optional)
            ABGSectionDivider(title: "Anion Gap (Optional)")

            // Electrolytes Card
            electrolytesCard
            
            // Advanced Calculations Card (Osmolar Gap & A-a Gradient)
            advancedInputsCard
        }
    }

    // Electrolytes card for anion gap
    private var electrolytesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(accentOrange)

                Text("Electrolytes")
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(textPrimary)

                Spacer()

                if !sodium.isEmpty || !chloride.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.caption2)
                        Text("Auto-calculating AG")
                            .font(.caption2.weight(.medium))
                    }
                    .foregroundColor(goldColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(goldColor.opacity(0.15))
                    )
                }
            }

            HStack(spacing: 16) {
                // Sodium
                VStack(alignment: .leading, spacing: 6) {
                    Text("Na⁺")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(textTertiary)

                    HStack(spacing: 4) {
                        TextField("140", text: $sodium)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(textPrimary)
                            .multilineTextAlignment(.leading)
                            .frame(width: 60)
                            .focused($focusedField, equals: .sodium)

                        Text("mEq/L")
                            .font(.custom("Poppins-Medium", size: 11))
                            .foregroundColor(textMuted)
                            .fixedSize()
                    }
                }
                .id(ABGField.sodium)

                Divider()
                    .frame(height: 40)

                // Chloride
                VStack(alignment: .leading, spacing: 6) {
                    Text("Cl⁻")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(textTertiary)

                    HStack(spacing: 4) {
                        TextField("100", text: $chloride)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(textPrimary)
                            .multilineTextAlignment(.leading)
                            .frame(width: 60)
                            .focused($focusedField, equals: .chloride)

                        Text("mEq/L")
                            .font(.custom("Poppins-Medium", size: 11))
                            .foregroundColor(textMuted)
                            .fixedSize()
                    }
                }
                .id(ABGField.chloride)

                Divider()
                    .frame(height: 40)

                // Albumin
                VStack(alignment: .leading, spacing: 6) {
                    Text("Albumin")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(textTertiary)

                    HStack(spacing: 4) {
                        TextField("4.0", text: $albumin)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(textPrimary)
                            .multilineTextAlignment(.leading)
                            .frame(width: 50)
                            .focused($focusedField, equals: .albumin)

                        Text("g/dL")
                            .font(.custom("Poppins-Medium", size: 11))
                            .foregroundColor(textMuted)
                            .fixedSize()
                    }
                }
                .id(ABGField.albumin)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(accentOrange.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Advanced Inputs Card (Osmolar Gap & A-a Gradient)
    private var advancedInputsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Toggle Header
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    showAdvancedInputs.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "flask.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(accentPurple)
                    
                    Text("Advanced Calculations")
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(textPrimary)
                    
                    Spacer()
                    
                    Text(showAdvancedInputs ? "Hide" : "Show")
                        .font(.caption.weight(.medium))
                        .foregroundColor(textMuted)
                    
                    Image(systemName: showAdvancedInputs ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(textMuted)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if showAdvancedInputs {
                VStack(spacing: 20) {
                    // Osmolar Gap Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "drop.triangle.fill")
                                .foregroundColor(accentOrange)
                                .font(.system(size: 14))
                            Text("Osmolar Gap")
                                .font(.custom("Poppins-Medium", size: 14))
                                .foregroundColor(textSecondary)
                        }
                        
                        HStack(spacing: 12) {
                            // Glucose
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Glucose")
                                    .font(.custom("Poppins-Medium", size: 11))
                                    .foregroundColor(textTertiary)
                                HStack(spacing: 2) {
                                    TextField("100", text: $glucose)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(textPrimary)
                                        .frame(width: 50)
                                    Text("mg/dL")
                                        .font(.system(size: 9))
                                        .foregroundColor(textMuted)
                                }
                            }
                            
                            // BUN
                            VStack(alignment: .leading, spacing: 4) {
                                Text("BUN")
                                    .font(.custom("Poppins-Medium", size: 11))
                                    .foregroundColor(textTertiary)
                                HStack(spacing: 2) {
                                    TextField("14", text: $bun)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(textPrimary)
                                        .frame(width: 40)
                                    Text("mg/dL")
                                        .font(.system(size: 9))
                                        .foregroundColor(textMuted)
                                }
                            }
                            
                            // Measured Osm
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Measured Osm")
                                    .font(.custom("Poppins-Medium", size: 11))
                                    .foregroundColor(textTertiary)
                                HStack(spacing: 2) {
                                    TextField("290", text: $measuredOsm)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(textPrimary)
                                        .frame(width: 50)
                                    Text("mOsm")
                                        .font(.system(size: 9))
                                        .foregroundColor(textMuted)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // A-a Gradient Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lungs.fill")
                                .foregroundColor(accentBlue)
                                .font(.system(size: 14))
                            Text("A-a Gradient")
                                .font(.custom("Poppins-Medium", size: 14))
                                .foregroundColor(textSecondary)
                        }
                        
                        HStack(spacing: 12) {
                            // PaO2
                            VStack(alignment: .leading, spacing: 4) {
                                Text("PaO₂")
                                    .font(.custom("Poppins-Medium", size: 11))
                                    .foregroundColor(textTertiary)
                                HStack(spacing: 2) {
                                    TextField("95", text: $paO2)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(textPrimary)
                                        .frame(width: 50)
                                    Text("mmHg")
                                        .font(.system(size: 9))
                                        .foregroundColor(textMuted)
                                }
                                if let paO2Val = Double(paO2), !InputValidationRules.ABG.paO2.validate(paO2Val).isValid {
                                    Text(InputValidationRules.ABG.paO2.validate(paO2Val).errorMessage ?? "")
                                        .font(.system(size: 9))
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            // FiO2
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FiO₂")
                                    .font(.custom("Poppins-Medium", size: 11))
                                    .foregroundColor(textTertiary)
                                HStack(spacing: 2) {
                                    TextField("0.21", text: $fio2)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(textPrimary)
                                        .frame(width: 50)
                                    Text("")
                                        .font(.system(size: 9))
                                        .foregroundColor(textMuted)
                                }
                            }
                            
                            // Age
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Age")
                                    .font(.custom("Poppins-Medium", size: 11))
                                    .foregroundColor(textTertiary)
                                HStack(spacing: 2) {
                                    TextField("40", text: $patientAge)
                                        .keyboardType(.numberPad)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(textPrimary)
                                        .frame(width: 40)
                                    Text("yrs")
                                        .font(.system(size: 9))
                                        .foregroundColor(textMuted)
                                }
                            }
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(accentPurple.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Calculated Values Card
    private var calculatedValuesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "function")
                    .foregroundColor(.purple)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.purple.opacity(0.12))
                    )
                
                Text("Calculated Values")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                
                Spacer()
                
                Button(action: { showLearnSheet = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill")
                        Text("Learn")
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.purple)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(Color.purple.opacity(0.12))
                    )
                }
            }
            
            // Henderson-Hasselbalch HCO3
            if let hco3Calc = calculatedHCO3 {
                CalculatedValueRow(
                    title: "Calculated HCO₃⁻",
                    value: String(format: "%.1f", hco3Calc),
                    unit: "mEq/L",
                    formula: "Henderson-Hasselbalch",
                    explanation: "HCO₃⁻ = 0.03 × PaCO₂ × 10^(pH - 6.1)",
                    isExpanded: expandedFormula == "hco3",
                    onTap: { toggleFormula("hco3") }
                )
            }
            
            // Base Excess
            if let be = calculatedBaseExcess {
                CalculatedValueRow(
                    title: "Base Excess",
                    value: String(format: "%+.1f", be),
                    unit: "mEq/L",
                    formula: "Base Excess Formula",
                    explanation: "BE = 0.02786 × PaCO₂ × 10^(pH - 6.1) + 13.77 × pH - 124.58\n\nNormal: -2 to +2 mEq/L\n• Negative = Base deficit (metabolic acidosis)\n• Positive = Base excess (metabolic alkalosis)",
                    status: abs(be) <= 2 ? .normal : (be < -2 ? .low : .high),
                    isExpanded: expandedFormula == "be",
                    onTap: { toggleFormula("be") }
                )
            }
            
            // Winter's Formula (for metabolic acidosis)
            if let hco3Val = effectiveHCO3, hco3Val < 22 {
                let wintersLow = (1.5 * hco3Val + 8) - 2
                let wintersHigh = (1.5 * hco3Val + 8) + 2
                
                CalculatedValueRow(
                    title: "Expected PaCO₂ (Winter's)",
                    value: "\(Int(wintersLow)) - \(Int(wintersHigh))",
                    unit: "mmHg",
                    formula: "Winter's Formula",
                    explanation: "PaCO₂ = (1.5 × HCO₃⁻) + 8 ± 2\n\nUsed in metabolic acidosis to determine if respiratory compensation is appropriate.\n\n• Actual PaCO₂ = Expected → Appropriate compensation\n• Actual PaCO₂ < Expected → Concurrent respiratory alkalosis\n• Actual PaCO₂ > Expected → Concurrent respiratory acidosis",
                    isExpanded: expandedFormula == "winters",
                    onTap: { toggleFormula("winters") }
                )
                
                // Compensation Analysis
                WintersCompensationView(
                    actualCO2: Double(paCO2),
                    wintersLow: wintersLow,
                    wintersHigh: wintersHigh
                )
            }
            
            // Anion Gap
            if let ag = calculatedAnionGap {
                CalculatedValueRow(
                    title: "Anion Gap",
                    value: String(format: "%.1f", ag),
                    unit: "mEq/L",
                    formula: "Anion Gap Calculation",
                    explanation: "AG = Na⁺ - (Cl⁻ + HCO₃⁻)\n\nNormal: 8 - 12 mEq/L\nNote: ≥15 mEq/L provides ≥95% HAGMA sensitivity (2024 research)\n\nElevated AG causes - GOLD MARK (+ STS):\n• Glycols (ethylene, propylene)\n• Oxoproline (acetaminophen toxicity)\n• L-Lactate (lactic acidosis)\n• D-Lactate (short bowel syndrome)\n• Methanol\n• Aspirin (salicylates)\n• Renal failure\n• Ketoacidosis (DKA, alcoholic, starvation)\n• (STS) Sodium Thiosulfate - emerging 2024",
                    status: ag > 12 ? .high : .normal,
                    isExpanded: expandedFormula == "ag",
                    onTap: { toggleFormula("ag") }
                )
                
                // Delta Ratio if elevated AG - with comprehensive interpretation
                if ag > 12, let hco3Val = effectiveHCO3 {
                    let deltaAG = ag - 12
                    let deltaHCO3 = 24 - hco3Val
                    if deltaHCO3 > 0 {
                        let deltaRatio = deltaAG / deltaHCO3
                        
                        // Comprehensive delta ratio interpretation (matching AnionGapAndDELTAGap.swift)
                        let deltaInterpretation: String = {
                            if deltaRatio < 0.4 {
                                return "Delta Ratio < 0.4:\n• Pure Hyperchloremic NAGMA\n• Renal tubular acidosis (RTA)\n• Diarrhea with bicarbonate loss\n• Early renal failure\n\nClinical: Check urine anion gap to differentiate GI vs renal loss."
                            } else if deltaRatio < 1.0 {
                                return "Delta Ratio 0.4 - 1.0:\n• Combined HAGMA + NAGMA\n• Possible renal failure component\n• May indicate concurrent processes\n\nClinical: Look for two simultaneous acidosis sources (e.g., DKA + diarrhea)."
                            } else if deltaRatio <= 2.0 {
                                return "Delta Ratio 1.0 - 2.0:\n• Pure High Anion Gap Acidosis\n• Classic lactic acidosis or DKA pattern\n\nClinical: Focus on treating the single primary cause (check lactate, ketones)."
                            } else {
                                return "Delta Ratio > 2.0:\n• HAGMA + concurrent metabolic alkalosis\n• OR pre-existing elevated HCO₃⁻ (chronic respiratory acidosis)\n\nClinical: Consider vomiting, NG suction, or diuretics superimposed on HAGMA.\nAlso consider chronic CO₂ retainer baseline."
                            }
                        }()
                        
                        CalculatedValueRow(
                            title: "Delta Ratio (ΔAG/ΔHCO₃)",
                            value: String(format: "%.2f", deltaRatio),
                            unit: "",
                            formula: "Delta-Delta Analysis",
                            explanation: "Delta Ratio = (AG - 12) / (24 - HCO₃⁻)\n\n\(deltaInterpretation)",
                            isExpanded: expandedFormula == "delta",
                            onTap: { toggleFormula("delta") }
                        )
                    }
                }
            }
            
            // MARK: - Osmolar Gap (if advanced inputs provided)
            if let osmGap = osmolarGap, let calcOsm = calculatedOsmolality {
                let interpretation = osmolarGapInterpretation
                CalculatedValueRow(
                    title: "Osmolar Gap",
                    value: String(format: "%.1f", osmGap),
                    unit: "mOsm/kg",
                    formula: "Osmolar Gap = Measured - Calculated",
                    explanation: """
                    Calculated Osm = 2(Na) + Glucose/18 + BUN/2.8
                    Calculated: \(String(format: "%.1f", calcOsm)) mOsm/kg
                    
                    \(interpretation?.status ?? ""): \(interpretation?.details ?? "")
                    
                    Interpretation Tiers:
                    • < 10: Normal
                    • 10-20: Mildly elevated (consider ethanol)
                    • > 20: Significantly elevated - toxic alcohols
                    
                    Causes of elevated osmolar gap:
                    • Methanol (formic acid → blindness)
                    • Ethylene glycol (calcium oxalate crystals → renal failure)
                    • Isopropanol (ketones without acidosis)
                    • Ethanol (calculate contribution)
                    """,
                    status: osmGap < 10 ? .normal : (osmGap < 20 ? .normal : .high),
                    isExpanded: expandedFormula == "osmgap",
                    onTap: { toggleFormula("osmgap") }
                )
            }
            
            // MARK: - A-a Gradient (if advanced inputs provided)
            if let gradient = aaGradient, let pao2Calc = calculatedPAO2 {
                let interpretation = aaGradientInterpretation
                let expectedNormal = expectedAaGradient ?? 15.0
                
                CalculatedValueRow(
                    title: "A-a Gradient",
                    value: String(format: "%.1f", gradient),
                    unit: "mmHg",
                    formula: "A-a = PAO₂ - PaO₂",
                    explanation: """
                    PAO₂ = FiO₂ × (760 - 47) - (PaCO₂/0.8)
                    Calculated PAO₂: \(String(format: "%.1f", pao2Calc)) mmHg
                    
                    Expected normal for age: ≤ \(String(format: "%.0f", expectedNormal)) mmHg
                    Formula: (Age/4) + 4
                    
                    \(interpretation?.status ?? ""): \(interpretation?.details ?? "")
                    
                    Interpretation:
                    • Normal A-a with hypoxemia → Hypoventilation
                    • Elevated A-a → V/Q mismatch, shunt, diffusion defect
                    
                    Common causes of elevated A-a gradient:
                    • Pneumonia
                    • Pulmonary embolism
                    • ARDS
                    • Interstitial lung disease
                    • Pulmonary edema
                    """,
                    status: gradient <= expectedNormal ? .normal : (gradient <= 30 ? .normal : .high),
                    isExpanded: expandedFormula == "aagradient",
                    onTap: { toggleFormula("aagradient") }
                )
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Analyze Button
    private var analyzeButton: some View {
        Button(action: {
            haptic.impactOccurred()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                performAnalysis()
            }
        }) {
            HStack(spacing: 10) {
                Text(showResults ? "Re-Analyze" : "Analyze ABG")
                    .font(.custom("Poppins-Bold", size: 18))
                Image(systemName: showResults ? "arrow.clockwise.circle.fill" : "arrow.right.circle.fill")
                    .font(.system(size: 20))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(canAnalyze ? navyAccent : Color.gray.opacity(0.4))
            )
            .shadow(color: canAnalyze ? navyAccent.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
        }
        .disabled(!canAnalyze)
        .scaleEffect(canAnalyze ? 1.0 : 0.97)
        .animation(.spring(response: 0.3), value: canAnalyze)
    }

    // Perform analysis with celebrations
    private func performAnalysis() {
        analyzeABG()

        // Increment calculation count
        calculationCount += 1
        UserDefaults.standard.set(calculationCount, forKey: "abg_calculation_count")

        // Show checkmark animation for every calculation
        showCheckmark = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showCheckmark = false
        }

        // Check for normal blood gas (celebration worthy)
        if let result = interpretation, result.severity == .normal {
            successHaptic.notificationOccurred(.success)

            // Show confetti
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showConfetti = false
            }

            // Show pulse ring
            showPulseRing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showPulseRing = false
            }

            // Show success glow
            showSuccessGlow = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showSuccessGlow = false
            }
        }

        // Check for milestone celebrations
        if calculationCount == 10 || calculationCount == 50 || calculationCount == 100 {
            showFireworks = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showFireworks = false
            }

            // Check if a new badge was just unlocked
            let badgeCount = earnedBadges.count
            if badgeCount > 0 {
                showSparkle = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showSparkle = false
                }
            }
        }
    }
    
    // MARK: - Results Section
    private func resultsSection(_ result: ABGComprehensiveInterpretation) -> some View {
        VStack(spacing: 20) {
            // Section Divider
            ABGSectionDivider(title: "Analysis Results")

            // Primary Disorder Card - Two-Tone Header Style (Design.md)
            VStack(spacing: 0) {
                // TOP SECTION - Navy with icon and title
                HStack(spacing: 16) {
                    // Frosted icon container with severity indicator
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 56, height: 56)
                        
                        // Severity-based icon
                        Image(systemName: severityIcon(for: result.severity))
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Primary Disorder")
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(.white)
                        
                        // Acute/Chronic in gold
                        if result.acuteChronicLabel != "—" {
                            Text(result.acuteChronicLabel)
                                .font(.custom("Poppins-Medium", size: 14))
                                .foregroundColor(goldColor)
                        } else {
                            Text("Acid-Base Analysis")
                                .font(.custom("Poppins-Medium", size: 14))
                                .foregroundColor(goldColor)
                        }
                    }
                    
                    Spacer()
                    
                    // Severity badge
                    VStack(spacing: 2) {
                        Circle()
                            .fill(result.severityColor)
                            .frame(width: 12, height: 12)
                            .shadow(color: result.severityColor, radius: 4)
                        
                        Text(severityLabel(for: result.severity))
                            .font(.custom("Poppins-Medium", size: 9))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(20)
                .background(navyAccent)
                
                // BOTTOM SECTION - White with disorder details
                VStack(alignment: .leading, spacing: 16) {
                    // Disorder name - large and prominent
                    Text(result.primaryDisorder)
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(navyAccent)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Interpretation text
                    Text(result.interpretation)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(textSecondary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Stats bar
                    HStack(spacing: 0) {
                        // pH Status
                        VStack(spacing: 4) {
                            Text(pH.isEmpty ? "--" : pH)
                                .font(.custom("Poppins-Bold", size: 20))
                                .foregroundColor(getpHStatus() == .normal ? textGreen : (getpHStatus() == .low ? accentOrange : accentRed))
                            Text("pH")
                                .font(.custom("Poppins-Medium", size: 11))
                                .foregroundColor(textMuted)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(navyAccent.opacity(0.15))
                            .frame(width: 1, height: 36)
                        
                        // CO2 Status
                        VStack(spacing: 4) {
                            Text(paCO2.isEmpty ? "--" : paCO2)
                                .font(.custom("Poppins-Bold", size: 20))
                                .foregroundColor(getCO2Status() == .normal ? textGreen : accentOrange)
                            Text("PaCO₂")
                                .font(.custom("Poppins-Medium", size: 11))
                                .foregroundColor(textMuted)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(navyAccent.opacity(0.15))
                            .frame(width: 1, height: 36)
                        
                        // HCO3 Status
                        VStack(spacing: 4) {
                            Text(effectiveHCO3Display)
                                .font(.custom("Poppins-Bold", size: 20))
                                .foregroundColor(getHCO3Status() == .normal ? textGreen : accentOrange)
                            Text("HCO₃⁻")
                                .font(.custom("Poppins-Medium", size: 11))
                                .foregroundColor(textMuted)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(red: 0.97, green: 0.98, blue: 0.99))
                    )
                }
                .padding(20)
                .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [goldColor, goldColor.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: navyAccent.opacity(0.2), radius: 12, x: 0, y: 6)
            
            // Compensation Analysis
            if let compensation = result.compensationAnalysis {
                ABGResultCardView(
                    icon: "arrow.triangle.2.circlepath",
                    iconColor: accentPurple,
                    title: "Compensation Analysis",
                    accentColor: accentPurple,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(compensation)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(textSecondary)
                            .fixedSize(horizontal: false, vertical: true)

                        if let expectedCO2 = result.expectedCO2 {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Expected PaCO₂")
                                        .font(.custom("Poppins-Medium", size: 12))
                                        .foregroundColor(textMuted)
                                    Text(expectedCO2)
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(textGreen)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Actual PaCO₂")
                                        .font(.custom("Poppins-Medium", size: 12))
                                        .foregroundColor(textMuted)
                                    Text("\(paCO2) mmHg")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(textPrimary)
                                }
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.white.opacity(0.6))
                            )
                        }
                    }
                }
            }

            // Values Summary
            ABGResultCardView(
                icon: "chart.bar.fill",
                iconColor: accentGreen,
                title: "Values Summary",
                accentColor: accentGreen,
                textPrimary: textPrimary,
                textSecondary: textSecondary
            ) {
                VStack(spacing: 12) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ABGSummaryValueCard(label: "pH", value: pH, status: getpHStatus(), normalRange: "7.35-7.45", textPrimary: textPrimary, textMuted: textMuted)
                        ABGSummaryValueCard(label: "PaCO₂", value: "\(paCO2) mmHg", status: getCO2Status(), normalRange: "35-45", textPrimary: textPrimary, textMuted: textMuted)
                        ABGSummaryValueCard(label: "HCO₃⁻", value: "\(effectiveHCO3Display) mEq/L", status: getHCO3Status(), normalRange: "22-26", textPrimary: textPrimary, textMuted: textMuted)
                        if let be = calculatedBaseExcess {
                            ABGSummaryValueCard(label: "Base Excess", value: String(format: "%+.1f mEq/L", be), status: abs(be) <= 2 ? .normal : (be < -2 ? .low : .high), normalRange: "-2 to +2", textPrimary: textPrimary, textMuted: textMuted)
                        }
                    }

                    if let ag = calculatedAnionGap {
                        ABGSummaryValueCard(label: "Anion Gap", value: String(format: "%.1f mEq/L", ag), status: ag > 12 ? .high : .normal, normalRange: "8-12", textPrimary: textPrimary, textMuted: textMuted)
                    }
                }
            }

            // Clinical Pearls
            if !result.clinicalPearls.isEmpty {
                ABGResultCardView(
                    icon: "lightbulb.fill",
                    iconColor: accentOrange,
                    title: "Clinical Pearls",
                    accentColor: accentOrange,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(result.clinicalPearls, id: \.self) { pearl in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(accentGreen)
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.top, 1)
                                Text(pearl)
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(textSecondary)
                            }
                        }
                    }
                }
            }
            
            // AI Explanation Button
            HStack {
                Spacer()
                ExplainButton.forCalculator(
                    name: "ABG Analysis",
                    result: result.primaryDisorder,
                    inputs: "pH: \(pH), PaCO₂: \(paCO2), HCO₃⁻: \(effectiveHCO3Display)\(calculatedAnionGap != nil ? ", AG: \(String(format: "%.1f", calculatedAnionGap!))" : "")"
                )
                Spacer()
            }
            .padding(.top, 8)
        }
    }
    
    // MARK: - Learn Button
    private var learnButton: some View {
        Button(action: { showLearnSheet = true }) {
            HStack(spacing: 14) {
                // Icon with brand color
                Image(systemName: "book.fill")
                    .foregroundColor(navyAccent)
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(navyAccent.opacity(0.1))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text("ABG Learning Center")
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(textPrimary)
                    Text("Formulas, disorders, and compensation rules")
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(textTertiary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(textMuted)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(navyAccent.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Keyboard Toolbar
    private var keyboardToolbar: some View {
        HStack {
            Button("Clear") {
                clearCurrentField()
            }
            .foregroundColor(.red)
            
            Spacer()
            
            Text(toolbarHint)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: true, vertical: false)

            Spacer()
            
            Button("Done") {
                focusedField = nil
            }
            .fontWeight(.semibold)
        }
    }
    
    // MARK: - Computed Properties
    private var canAnalyze: Bool {
        !pH.isEmpty && !paCO2.isEmpty
    }
    
    /// Calculates bicarbonate using the Henderson-Hasselbalch equation
    /// Formula: HCO₃⁻ = 0.03 × PaCO₂ × 10^(pH - 6.1)
    /// Reference: Standard clinical formula derived from Henderson-Hasselbalch equation
    /// Note: The +0.5 offset is a clinically-validated adjustment that better correlates
    /// with hospital blood gas analyzer measurements (validated against clinical ABGs)
    private var calculatedHCO3: Double? {
        guard let phValue = Double(pH),
              let co2Value = Double(paCO2),
              phValue > 0, co2Value > 0 else { return nil }
        
        // Henderson-Hasselbalch: HCO₃⁻ = 0.03 × PaCO₂ × 10^(pH - 6.1)
        let power = phValue - 6.1
        return (0.03 * co2Value * pow(10, power)) + 0.5 // +0.5 for clinical accuracy
    }
    
    private var calculatedHCO3Display: String {
        if let calc = calculatedHCO3 {
            return String(format: "%.1f", calc)
        }
        return "24.0"
    }
    
    private var effectiveHCO3: Double? {
        if let manual = Double(hco3), !hco3.isEmpty {
            return manual
        }
        return calculatedHCO3
    }
    
    private var effectiveHCO3Display: String {
        if let value = effectiveHCO3 {
            return String(format: "%.1f", value)
        }
        return "--"
    }
    
    private var calculatedBaseExcess: Double? {
        guard let phValue = Double(pH),
              let co2Value = Double(paCO2) else { return nil }
        
        let power = phValue - 6.1
        return 0.02786 * co2Value * pow(10, power) + 13.77 * phValue - 124.58
    }
    
    /// Calculates standard Anion Gap: AG = Na⁺ - (Cl⁻ + HCO₃⁻)
    /// Normal range: 8-12 mEq/L (traditional) or consider ≥15 for HAGMA detection (2024 research)
    /// Reference: PMID 38478728 (2024) suggests ≥15 mEq/L provides ≥95% sensitivity for HAGMA
    private var calculatedAnionGap: Double? {
        guard let na = Double(sodium),
              let cl = Double(chloride),
              let hco3Val = effectiveHCO3 else { return nil }
        
        return na - (cl + hco3Val)
    }
    
    /// Calculates albumin-corrected Anion Gap
    /// Formula: Corrected AG = Measured AG + 2.5 × (4.0 - Albumin g/dL)
    /// Critical for ICU patients, liver disease, malnutrition where albumin is low
    /// Reference: Standard nephrology/critical care correction formula
    private var albumin_correctedAnionGap: Double? {
        guard let ag = calculatedAnionGap,
              let albValue = Double(albumin),
              albValue > 0 else { return nil }
        
        // Albumin correction: Add 2.5 mEq/L for each 1 g/dL below normal (4.0)
        let correction = 2.5 * (4.0 - albValue)
        return ag + correction
    }
    
    // MARK: - Osmolar Gap Calculation
    /// Calculated Osmolality = 2(Na) + Glucose/18 + BUN/2.8
    /// Osmolar Gap = Measured Osm - Calculated Osm
    /// Normal: < 10 mOsm/kg
    /// Elevated (>10): Suggests toxic alcohols (methanol, ethylene glycol, isopropanol)
    /// Reference: Standard toxicology/critical care formula
    private var calculatedOsmolality: Double? {
        guard let na = Double(sodium),
              let glu = Double(glucose),
              let bunVal = Double(bun),
              na > 0, glu >= 0, bunVal >= 0 else { return nil }
        
        return 2 * na + glu/18 + bunVal/2.8
    }
    
    private var osmolarGap: Double? {
        guard let calcOsm = calculatedOsmolality,
              let measOsm = Double(measuredOsm),
              measOsm > 0 else { return nil }
        
        return measOsm - calcOsm
    }
    
    private var osmolarGapInterpretation: (status: String, color: Color, details: String)? {
        guard let gap = osmolarGap else { return nil }
        
        if gap < 10 {
            return ("Normal", accentGreen, "Osmolar gap < 10 mOsm/kg is normal. Toxic alcohols less likely.")
        } else if gap < 20 {
            return ("Mildly Elevated", goldColor, "Osmolar gap 10-20 mOsm/kg. Consider ethanol or early toxic alcohol ingestion. Check ethanol level.")
        } else {
            return ("Significantly Elevated", accentRed, "Osmolar gap > 20 mOsm/kg. High suspicion for:\n• Methanol\n• Ethylene glycol\n• Isopropanol\n\nCheck serum osmolality, ethanol level, and consider fomepizole.")
        }
    }
    
    // MARK: - A-a Gradient Calculation
    /// PAO₂ = FiO₂ × (Patm - PH₂O) - (PaCO₂/0.8)
    /// A-a Gradient = PAO₂ - PaO₂
    /// Normal A-a = (Age/4) + 4 (approximation)
    /// Reference: Standard pulmonology formula
    private var calculatedPAO2: Double? {
        guard let fio2Value = Double(fio2),
              let co2Value = Double(paCO2),
              fio2Value > 0, co2Value > 0 else { return nil }
        
        let patm = 760.0  // Sea level atmospheric pressure
        let ph2o = 47.0   // Water vapor pressure at body temp
        
        // Alveolar gas equation
        return fio2Value * (patm - ph2o) - (co2Value / 0.8)
    }
    
    private var aaGradient: Double? {
        guard let pao2Calc = calculatedPAO2,
              let pao2Measured = Double(paO2),
              pao2Measured > 0 else { return nil }
        
        return pao2Calc - pao2Measured
    }
    
    private var expectedAaGradient: Double? {
        guard let age = Double(patientAge), age > 0 else { return nil }
        return (age / 4) + 4
    }
    
    private var aaGradientInterpretation: (status: String, color: Color, details: String)? {
        guard let gradient = aaGradient else { return nil }
        
        let expectedNormal = expectedAaGradient ?? 15.0
        
        if gradient <= expectedNormal {
            return ("Normal", accentGreen, "A-a gradient is within expected range. Suggests hypoventilation as cause of hypoxemia (if present).")
        } else if gradient <= 30 {
            return ("Mildly Elevated", goldColor, "A-a gradient mildly elevated. Consider:\n• V/Q mismatch\n• Early pulmonary disease\n• Mild shunt")
        } else if gradient <= 50 {
            return ("Moderately Elevated", accentOrange, "A-a gradient significantly elevated. Consider:\n• Pneumonia\n• Pulmonary embolism\n• ARDS\n• Interstitial lung disease")
        } else {
            return ("Severely Elevated", accentRed, "A-a gradient severely elevated (>50). High suspicion for:\n• Severe ARDS\n• Large pulmonary embolism\n• Severe pneumonia\n• Significant intrapulmonary shunt")
        }
    }
    
    private var toolbarHint: String {
        switch focusedField {
        case .pH: return "pH"
        case .paCO2: return "PaCO₂"
        case .hco3: return "HCO₃⁻"
        case .sodium: return "Sodium"
        case .chloride: return "Chloride"
        case .albumin: return "Albumin"
        case .none: return ""
        }
    }
    
    // MARK: - Helper Functions
    private func toggleFormula(_ id: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if expandedFormula == id {
                expandedFormula = nil
            } else {
                expandedFormula = id
            }
        }
    }
    
    private func getpHStatus() -> ABGInputStatus {
        guard let value = Double(pH) else { return .normal }
        if value < 7.35 { return .low }
        if value > 7.45 { return .high }
        return .normal
    }
    
    private func getCO2Status() -> ABGInputStatus {
        guard let value = Double(paCO2) else { return .normal }
        if value < 35 { return .low }
        if value > 45 { return .high }
        return .normal
    }
    
    private func getHCO3Status() -> ABGInputStatus {
        guard let value = effectiveHCO3 else { return .normal }
        if value < 22 { return .low }
        if value > 26 { return .high }
        return .normal
    }
    
    // MARK: - Severity Helpers for Two-Tone Card
    private func severityLabel(for severity: ABGComprehensiveInterpretation.Severity) -> String {
        switch severity {
        case .normal: return "Normal"
        case .mild: return "Mild"
        case .moderate: return "Moderate"
        case .severe: return "Severe"
        }
    }
    
    private func autoCalculateBicarb() {
        // Only auto-fill if user hasn't manually entered HCO3
        // The calculated value shows as placeholder
    }
    
    private func clearCurrentField() {
        switch focusedField {
        case .pH: pH = ""
        case .paCO2: paCO2 = ""
        case .hco3: hco3 = ""
        case .sodium: sodium = ""
        case .chloride: chloride = ""
        case .albumin: albumin = ""
        case .none: break
        }
    }
    
    private func analyzeABG() {
        guard let phValue = Double(pH),
              let co2Value = Double(paCO2) else { return }
        
        let hco3Value = effectiveHCO3 ?? 24
        let naValue = Double(sodium)
        let clValue = Double(chloride)
        
        interpretation = ABGComprehensiveAnalyzer.analyze(
            pH: phValue,
            paCO2: co2Value,
            hco3: hco3Value,
            sodium: naValue,
            chloride: clValue
        )
        
        showResults = true
        focusedField = nil

        // Track ABG in recents with interpretation detail
        if let result = interpretation {
            RecentlyUsedTracker.shared.trackCalculation(
                title: "ABG Analysis",
                icon: "syringe.fill",
                detail: "pH \(pH) · CO₂ \(paCO2) · \(result.primaryDisorder)"
            )
        }
    }
}

// MARK: - ABG Input Status
enum ABGInputStatus {
    case normal, low, high

    var color: Color {
        switch self {
        case .normal: return .green
        case .low: return .red   // Low values are abnormal - show as red
        case .high: return .red  // High values are abnormal - show as red
        }
    }
    
    var icon: String {
        switch self {
        case .normal: return "checkmark.circle.fill"
        case .low: return "arrow.down.circle.fill"
        case .high: return "arrow.up.circle.fill"
        }
    }
    
    var label: String {
        switch self {
        case .normal: return "Normal"
        case .low: return "Low"
        case .high: return "High"
        }
    }
}

// MARK: - ABG Input Row
private struct ABGInputRow: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let placeholder: String
    @Binding var value: String
    let unit: String
    let normalRange: String
    let isFocused: Bool
    let status: ABGInputStatus
    var isCalculated: Bool = false
    
    // Computed property for background color based on status
    private var statusBackgroundColor: Color {
        guard !value.isEmpty else { return Color.clear }
        switch status {
        case .normal: return Color(hex: "DEBD68").opacity(0.08) // Gold tint for normal
        case .low: return Color.red.opacity(0.08)   // Low is abnormal - red
        case .high: return Color.red.opacity(0.08)  // High is abnormal - red
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Label section - fixed width
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(label)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                    if isCalculated {
                        Text("calc")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color(hex: "C9A227"))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color(hex: "F5E6A3").opacity(0.25))
                            )
                    }
                }
                Text(normalRange)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            // Status indicator - fixed width for alignment
            ZStack {
                if !value.isEmpty || isCalculated {
                    Image(systemName: status.icon)
                        .foregroundColor(status.color)
                        .font(.system(size: 16, weight: .semibold))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(width: 32)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: status)
            
            // Input field section - fixed width
            HStack(spacing: 4) {
                TextField(placeholder, text: $value)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(isCalculated && value.isEmpty ? Color(hex: "C9A227") : .primary)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 70)
                
                Text(unit.isEmpty ? "   " : unit)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 44, alignment: .leading)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
                    .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.4) : Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.5) : Color.gray.opacity(0.15),
                        lineWidth: isFocused ? 2 : 1
                    )
            )
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(statusBackgroundColor)
                .animation(.easeInOut(duration: 0.3), value: status)
        )
        .overlay(
            // Left accent bar that animates with status
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(!value.isEmpty ? status.color : Color.clear)
                    .frame(width: 3)
                    .padding(.vertical, 12)
                Spacer()
            }
            .padding(.leading, 4)
            .animation(.easeInOut(duration: 0.3), value: status)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Winter's Compensation View
private struct WintersCompensationView: View {
    let actualCO2: Double?
    let wintersLow: Double
    let wintersHigh: Double
    
    private var compensationData: (status: String, color: Color)? {
        guard let co2 = actualCO2 else { return nil }
        let wintersRange = wintersLow...wintersHigh
        
        if wintersRange.contains(co2) {
            return ("✓ Appropriate respiratory compensation", .green)
        } else if co2 < wintersLow {
            return ("⚠ Additional respiratory alkalosis present", .orange)
        } else {
            return ("⚠ Inadequate compensation (concurrent respiratory acidosis)", .red)
        }
    }
    
    var body: some View {
        if let data = compensationData {
            Text(data.status)
                .font(.caption.weight(.medium))
                .foregroundColor(data.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(data.color.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

// MARK: - ABG Input Row Compact
private struct ABGInputRowCompact: View {
    let label: String
    let placeholder: String
    @Binding var value: String
    let unit: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
            
            HStack(spacing: 4) {
                TextField(placeholder, text: $value)
                    .keyboardType(.decimalPad)
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)
                    .focused($isFocused)
                
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                    RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGroupedBackground))
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 1, y: 1)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            .shadow(color: Color.white.opacity(0.8), radius: 2, x: -1, y: -1)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isFocused ? Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.4) : Color.clear,
                        lineWidth: 1.5
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

// MARK: - Calculated Value Row
private struct CalculatedValueRow: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let value: String
    let unit: String
    let formula: String
    let explanation: String
    var status: ABGInputStatus = .normal
    let isExpanded: Bool
    let onTap: () -> Void
    
    // Color based on formula type
    private var accentColor: Color {
        if title.contains("HCO") { return .blue }
        if title.contains("Base") { return .orange }
        if title.contains("Winter") { return .teal }
        if title.contains("Anion") { return .red }
        if title.contains("Delta") { return .purple }
        return .green
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onTap) {
                HStack(alignment: .top, spacing: 0) {
                    // Left accent indicator
                    RoundedRectangle(cornerRadius: 2)
                        .fill(accentColor)
                        .frame(width: 4, height: 50)
                        .padding(.trailing, 14)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text(value)
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(status == .normal ? .primary : status.color)
                            Text(unit)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .fixedSize(horizontal: true, vertical: false)
                    }
                    
                    Spacer()
                    
                    // Expand button
                    VStack(spacing: 4) {
                        Image(systemName: isExpanded ? "chevron.up.circle.fill" : "info.circle")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(accentColor)
                        
                        Text(isExpanded ? "Less" : "Info")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(accentColor.opacity(0.8))
                    }
                    .frame(width: 44)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    // Formula badge - reduced glow
                    Text(formula)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(accentColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(accentColor.opacity(0.12))
                        )

                    Text(explanation)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary.opacity(0.8))
                        .lineSpacing(4)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6).opacity(0.5))
                )
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity
                ))
            }
        }
        .padding(16)
        .background(calculatedValueCardBackground)
        .modifier(CalculatedValueCardShadows(colorScheme: colorScheme))
    }
    
    // MARK: - Subviews (Fix Type-Checking Timeout)
    
    private var calculatedValueCardBackground: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
    }
}

// MARK: - Result Card View (Consistent Width Container)
private struct ResultCardView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let iconColor: Color
    let title: String
    let accentColor: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(iconColor.opacity(0.1))
                    )
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
        )
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.white.opacity(0.85), radius: 2, x: -1, y: -1)
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.5) : Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        .shadow(color: Color.black.opacity(0.05), radius: 24, x: 0, y: 12)
        .overlay(
            // Left accent bar
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(width: 4)
                    .padding(.vertical, 16)
                Spacer()
            }
            .padding(.leading, 6)
        )
    }
}

// MARK: - Summary Value Card
private struct SummaryValueCard: View {
    let label: String
    let value: String
    let status: ABGInputStatus
    let normalRange: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: status.icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(status.color)
            }
            
            Text(value)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(status == .normal ? .primary : status.color)
            
            Text(normalRange)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.secondary.opacity(0.8))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(status.color.opacity(0.25), lineWidth: 1)
        )
        // Subtle depth
        .shadow(color: Color.white.opacity(0.7), radius: 1, x: -1, y: -1)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - ABG Protocol Disclaimer
private struct ABGProtocolDisclaimer: View {
    @State private var isExpanded = false
    private let navyAccent = Color(red: 0.18, green: 0.25, blue: 0.34)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(navyAccent)
                        .font(.system(size: 14))
                    
                    Text("Always follow your institution's protocols")
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                Text("This ABG interpretation is for educational and reference purposes only. It is not medical direction. Clinical correlation is essential. Always verify with your institution's protocols and consult your team for patient-specific decisions.")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemGroupedBackground))
                .shadow(color: Color.white.opacity(0.6), radius: 4, x: -2, y: -2)
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 2, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(navyAccent.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - ABG Comprehensive Interpretation Model
struct ABGComprehensiveInterpretation {
    let primaryDisorder: String
    let acuteChronicLabel: String
    let interpretation: String
    let compensationAnalysis: String?
    let expectedCO2: String?
    let severity: Severity
    let clinicalPearls: [String]
    
    enum Severity {
        case normal, mild, moderate, severe
    }
    
    var severityColor: Color {
        switch severity {
        case .normal: return Color(red: 0.40, green: 0.84, blue: 0.72) // Accent green
        case .mild: return Color(red: 0.85, green: 0.65, blue: 0.12) // Amber/gold - better contrast than yellow
        case .moderate: return Color(red: 0.85, green: 0.34, blue: 0.17) // Accent orange
        case .severe: return Color(red: 0.92, green: 0.32, blue: 0.38) // Accent red
        }
    }
}

// MARK: - ABG Comprehensive Analyzer
struct ABGComprehensiveAnalyzer {
    
    static func analyze(
        pH: Double,
        paCO2: Double,
        hco3: Double,
        sodium: Double?,
        chloride: Double?
    ) -> ABGComprehensiveInterpretation {
        
        // Calculate anion gap if possible
        var anionGap: Double?
        if let na = sodium, let cl = chloride {
            anionGap = na - (cl + hco3)
        }
        
        // Determine acute vs chronic for respiratory disorders
        let acuteChronicLabel = determineAcuteChronic(paCO2: paCO2, hco3: hco3, pH: pH)
        
        // Determine primary disorder and interpretation
        let (disorder, interpretation, severity, pearls) = determinePrimaryDisorder(
            pH: pH,
            paCO2: paCO2,
            hco3: hco3,
            anionGap: anionGap
        )
        
        // Analyze compensation
        let (compensationAnalysis, expectedCO2) = analyzeCompensation(
            pH: pH,
            paCO2: paCO2,
            hco3: hco3,
            disorder: disorder
        )
        
        return ABGComprehensiveInterpretation(
            primaryDisorder: disorder,
            acuteChronicLabel: acuteChronicLabel,
            interpretation: interpretation,
            compensationAnalysis: compensationAnalysis,
            expectedCO2: expectedCO2,
            severity: severity,
            clinicalPearls: pearls
        )
    }
    
    private static func determineAcuteChronic(paCO2: Double, hco3: Double, pH: Double) -> String {
        // For respiratory acidosis
        if paCO2 > 45 && pH < 7.35 {
            let deltaCO2 = paCO2 - 40
            let expectedAcuteHCO3 = 24 + (deltaCO2 * 0.1)
            let expectedChronicHCO3 = 24 + (deltaCO2 * 0.35)
            
            if hco3 <= expectedAcuteHCO3 + 2 {
                return "Acute"
            } else if hco3 >= expectedChronicHCO3 - 2 {
                return "Chronic"
            } else {
                return "Subacute"
            }
        }
        
        // For respiratory alkalosis
        // Boston Rules: Acute: HCO₃⁻ ↓ 2 mEq/L per 10 mmHg; Chronic: ↓ 4-5 mEq/L per 10 mmHg
        if paCO2 < 35 && pH > 7.45 {
            let deltaCO2 = 40 - paCO2
            let expectedAcuteHCO3 = 24 - (deltaCO2 * 0.2)  // 2 mEq per 10 mmHg
            let expectedChronicHCO3 = 24 - (deltaCO2 * 0.5) // 5 mEq per 10 mmHg (updated per Boston Rules)
            
            if hco3 >= expectedAcuteHCO3 - 2 {
                return "Acute"
            } else if hco3 <= expectedChronicHCO3 + 2 {
                return "Chronic"
            } else {
                return "Subacute"
            }
        }
        
        return "—"
    }
    
    private static func determinePrimaryDisorder(
        pH: Double,
        paCO2: Double,
        hco3: Double,
        anionGap: Double?
    ) -> (String, String, ABGComprehensiveInterpretation.Severity, [String]) {
        
        let normalPH = 7.35...7.45
        let normalCO2 = 35.0...45.0
        let normalHCO3 = 22.0...26.0
        
        var pearls: [String] = []
        
        // Normal ABG
        if normalPH.contains(pH) && normalCO2.contains(paCO2) && normalHCO3.contains(hco3) {
            return (
                "Normal Blood Gas",
                "All values are within normal limits. No acid-base disorder detected. However, a normal pH doesn't exclude a mixed metabolic alkalosis/acidosis.",
                .normal,
                ["A normal ABG doesn't rule out pathology - always correlate clinically"]
            )
        }
        
        // Metabolic Acidosis
        if pH < 7.35 && hco3 < 22 {
            // Note: 2024 research (PMID 38478728) suggests ≥15 mEq/L for ≥95% HAGMA sensitivity
            // Current threshold: >12 for sensitivity; consider clinical context
            let isHighAG = (anionGap ?? 0) > 12
            
            if isHighAG {
                pearls = [
                    "High AG causes - GOLD MARK: Glycols, Oxoproline, L-Lactate, D-Lactate, Methanol, Aspirin, Renal failure, Ketoacidosis",
                    "Check lactate first - most common cause of HAGMA",
                    "Consider osmolar gap if toxic ingestion suspected",
                    "Albumin-corrected AG critical in ICU/hypoalbuminemic patients",
                    "Emerging (2024): Sodium Thiosulfate (STS) therapy can cause HAGMA"
                ]
                return (
                    "High Anion Gap Metabolic Acidosis",
                    "The low pH with decreased bicarbonate and elevated anion gap indicates accumulation of unmeasured anions. Common causes include lactic acidosis, DKA, uremia, or toxic ingestions. Use GOLD MARK mnemonic.",
                    pH < 7.2 ? .severe : .moderate,
                    pearls
                )
            } else {
                pearls = [
                    "Normal AG acidosis causes: GI losses (diarrhea), RTA, dilutional acidosis, ureteral diversion",
                    "Check urine anion gap: positive suggests RTA, negative suggests GI loss",
                    "Hyperchloremia is typically present",
                    "Delta ratio < 0.4 confirms pure NAGMA"
                ]
                return (
                    "Non-Anion Gap Metabolic Acidosis",
                    "Normal anion gap metabolic acidosis typically results from bicarbonate loss (GI or renal) or impaired renal acid excretion.",
                    pH < 7.25 ? .moderate : .mild,
                    pearls
                )
            }
        }
        
        // Metabolic Alkalosis
        if pH > 7.45 && hco3 > 26 {
            pearls = [
                "Check urine chloride: <20 mEq/L = chloride-responsive; >20 = chloride-resistant",
                "Common causes: Vomiting, NG suction, diuretics, hypokalemia",
                "Severe alkalemia can cause arrhythmias and impair O2 delivery"
            ]
            return (
                "Metabolic Alkalosis",
                "Elevated pH with increased bicarbonate indicates metabolic alkalosis. This may result from acid loss, base gain, or volume contraction.",
                pH > 7.55 ? .moderate : .mild,
                pearls
            )
        }
        
        // Respiratory Acidosis
        if pH < 7.35 && paCO2 > 45 {
            pearls = [
                "Causes: COPD, sedation, neuromuscular disease, airway obstruction",
                "Assess need for ventilatory support",
                "Avoid rapid correction in chronic cases",
                "ACUTE (min-hrs): HCO₃⁻ ↑ 1 mEq/L per 10 mmHg ↑ PaCO₂",
                "CHRONIC (3-5 days): HCO₃⁻ ↑ 3.5-4 mEq/L per 10 mmHg ↑ PaCO₂"
            ]
            return (
                "Respiratory Acidosis",
                "Elevated CO₂ with decreased pH indicates inadequate alveolar ventilation. The lungs are not eliminating CO₂ adequately. Renal compensation takes 3-5 days to fully develop.",
                pH < 7.2 ? .severe : .moderate,
                pearls
            )
        }
        
        // Respiratory Alkalosis
        if pH > 7.45 && paCO2 < 35 {
            pearls = [
                "Causes: Anxiety, pain, hypoxemia, PE, sepsis, CNS disease, pregnancy",
                "Check oxygenation - hypoxemia drives hyperventilation",
                "Consider PE if unexplained respiratory alkalosis",
                "ACUTE (min-hrs): HCO₃⁻ ↓ 2 mEq/L per 10 mmHg ↓ PaCO₂",
                "CHRONIC (3-5 days): HCO₃⁻ ↓ 4-5 mEq/L per 10 mmHg ↓ PaCO₂"
            ]
            return (
                "Respiratory Alkalosis",
                "Low CO₂ with elevated pH indicates hyperventilation. The patient is blowing off too much CO₂. Renal compensation takes 3-5 days for full effect.",
                .mild,
                pearls
            )
        }
        
        // Mixed Acidosis
        if pH < 7.35 && paCO2 > 45 && hco3 < 22 {
            pearls = [
                "Both buffering systems overwhelmed - concerning finding",
                "Common in cardiac arrest, severe septic shock",
                "Address both respiratory and metabolic components"
            ]
            return (
                "Mixed Respiratory & Metabolic Acidosis",
                "Both elevated CO₂ and decreased bicarbonate with acidemic pH indicates both buffering systems are impaired. This is a concerning finding often seen in critically ill patients.",
                .severe,
                pearls
            )
        }
        
        // Mixed Alkalosis
        if pH > 7.45 && paCO2 < 35 && hco3 > 26 {
            return (
                "Mixed Respiratory & Metabolic Alkalosis",
                "Both decreased CO₂ and elevated bicarbonate with alkalemic pH. This may indicate concurrent respiratory and metabolic processes.",
                .moderate,
                ["Consider multiple concurrent processes", "Severe alkalemia may cause arrhythmias"]
            )
        }
        
        // Compensated states
        if normalPH.contains(pH) {
            if paCO2 > 45 && hco3 > 26 {
                return (
                    "Compensated Respiratory Acidosis",
                    "Normal pH with elevated CO₂ and compensatory elevated bicarbonate indicates chronic, fully compensated respiratory acidosis.",
                    .mild,
                    ["Chronic process - metabolic compensation complete", "Avoid rapid correction"]
                )
            }
            if paCO2 < 35 && hco3 < 22 {
                return (
                    "Compensated Respiratory Alkalosis",
                    "Normal pH with decreased CO₂ and compensatory decreased bicarbonate indicates chronic, fully compensated respiratory alkalosis.",
                    .mild,
                    ["Chronic hyperventilation with renal compensation"]
                )
            }
            if hco3 < 22 && paCO2 < 35 {
                return (
                    "Compensated Metabolic Acidosis",
                    "Normal pH with decreased bicarbonate and compensatory decreased CO₂ indicates metabolic acidosis with appropriate respiratory compensation.",
                    .mild,
                    ["Respiratory compensation is appropriate", "Look for underlying cause of acidosis"]
                )
            }
            if hco3 > 26 && paCO2 > 45 {
                return (
                    "Compensated Metabolic Alkalosis",
                    "Normal pH with elevated bicarbonate and compensatory elevated CO₂ indicates metabolic alkalosis with respiratory compensation.",
                    .mild,
                    ["Respiratory compensation for metabolic alkalosis"]
                )
            }
        }
        
        return (
            "Complex Acid-Base Disorder",
            "This pattern requires clinical correlation for proper interpretation.",
            .moderate,
            ["Consider mixed disorder", "Correlate with clinical picture"]
        )
    }
    
    private static func analyzeCompensation(
        pH: Double,
        paCO2: Double,
        hco3: Double,
        disorder: String
    ) -> (String?, String?) {
        
        if disorder.contains("Normal") { return (nil, nil) }
        
        // Metabolic Acidosis - Winter's Formula
        if disorder.contains("Metabolic Acidosis") {
            let expectedCO2 = 1.5 * hco3 + 8
            let expectedCO2Low = expectedCO2 - 2
            let expectedCO2High = expectedCO2 + 2
            
            let expectedRange = "\(Int(expectedCO2Low)) - \(Int(expectedCO2High)) mmHg"
            
            if paCO2 >= expectedCO2Low && paCO2 <= expectedCO2High {
                return (
                    "The respiratory system is compensating appropriately. The actual PaCO₂ falls within the expected range calculated by Winter's formula.",
                    expectedRange
                )
            } else if paCO2 < expectedCO2Low {
                return (
                    "The PaCO₂ is lower than expected by Winter's formula, suggesting an additional respiratory alkalosis is present (mixed disorder).",
                    expectedRange
                )
            } else {
                return (
                    "The PaCO₂ is higher than expected by Winter's formula, suggesting inadequate respiratory compensation or a concurrent respiratory acidosis.",
                    expectedRange
                )
            }
        }
        
        // Metabolic Alkalosis - Standard formula
        // Expected PaCO₂ = 40 + 0.7 × (HCO₃⁻ - 24) ± 5 mmHg (wider tolerance than acidosis)
        // Reference: Boston Rules / pulmtools.com
        if disorder.contains("Metabolic Alkalosis") {
            let expectedCO2 = 40.0 + 0.7 * (hco3 - 24.0)  // Standard formula
            let expectedCO2Low = expectedCO2 - 5.0  // Wider tolerance (±5) for alkalosis
            let expectedCO2High = expectedCO2 + 5.0
            
            let expectedRange = "\(Int(expectedCO2Low)) - \(Int(expectedCO2High)) mmHg"
            
            if paCO2 >= expectedCO2Low && paCO2 <= expectedCO2High {
                return (
                    "Appropriate respiratory compensation for metabolic alkalosis. The body is hypoventilating to retain CO₂. Note: Compensation has wider variance (±5 mmHg) in alkalosis.",
                    expectedRange
                )
            } else if paCO2 < expectedCO2Low {
                return (
                    "PaCO₂ is lower than expected, suggesting a concurrent respiratory alkalosis (mixed disorder).",
                    expectedRange
                )
            } else {
                return (
                    "PaCO₂ is higher than expected, suggesting a concurrent respiratory acidosis (mixed disorder).",
                    expectedRange
                )
            }
        }
        
        // Respiratory Acidosis
        // Boston Rules: Acute: HCO₃⁻ ↑ 1 mEq/L per 10 mmHg; Chronic (3-5 days): ↑ 3.5-4 mEq/L per 10 mmHg
        if disorder.contains("Respiratory Acidosis") {
            let deltaCO2 = paCO2 - 40
            let expectedAcuteHCO3 = 24 + (deltaCO2 * 0.1)   // 1 mEq per 10 mmHg
            let expectedChronicHCO3 = 24 + (deltaCO2 * 0.35) // 3.5 mEq per 10 mmHg
            
            if hco3 < expectedAcuteHCO3 - 2 {
                return (
                    "The HCO₃⁻ is lower than expected for acute compensation, suggesting a concurrent metabolic acidosis (mixed disorder).",
                    nil
                )
            } else if hco3 > expectedChronicHCO3 + 2 {
                return (
                    "The HCO₃⁻ is higher than expected for chronic compensation, suggesting a concurrent metabolic alkalosis (mixed disorder).",
                    nil
                )
            } else if hco3 <= expectedAcuteHCO3 + 2 {
                return (
                    "Minimal metabolic compensation (acute process, minutes to hours). Expected HCO₃⁻ increase of 1 mEq/L per 10 mmHg rise in PaCO₂. Buffering is via intracellular mechanisms.",
                    nil
                )
            } else {
                return (
                    "Appropriate metabolic compensation (chronic process, 3-5 days). Expected HCO₃⁻ increase of 3.5-4 mEq/L per 10 mmHg rise in PaCO₂. Renal retention of bicarbonate has occurred.",
                    nil
                )
            }
        }
        
        // Respiratory Alkalosis
        // Boston Rules: Acute: HCO₃⁻ ↓ 2 mEq/L per 10 mmHg; Chronic (3-5 days): ↓ 4-5 mEq/L per 10 mmHg
        if disorder.contains("Respiratory Alkalosis") {
            let deltaCO2 = 40 - paCO2
            let expectedAcuteHCO3 = 24 - (deltaCO2 * 0.2)   // 2 mEq per 10 mmHg
            let expectedChronicHCO3 = 24 - (deltaCO2 * 0.5)  // 5 mEq per 10 mmHg (updated per Boston Rules)
            
            if hco3 < expectedChronicHCO3 - 2 {
                return (
                    "The HCO₃⁻ is lower than expected even for chronic compensation, suggesting a concurrent metabolic acidosis.",
                    nil
                )
            } else if hco3 > expectedAcuteHCO3 + 2 {
                return (
                    "The HCO₃⁻ is higher than expected, suggesting a concurrent metabolic alkalosis.",
                    nil
                )
            } else if hco3 >= expectedAcuteHCO3 - 2 {
                return (
                    "Minimal renal compensation (acute process, minutes to hours). Expected HCO₃⁻ decrease of 2 mEq/L per 10 mmHg drop in PaCO₂.",
                    nil
                )
            } else {
                return (
                    "Appropriate renal compensation (chronic process, 3-5 days). Expected HCO₃⁻ decrease of 4-5 mEq/L per 10 mmHg drop in PaCO₂.",
                    nil
                )
            }
        }
        
        return (nil, nil)
    }
}

// MARK: - ABG Learn View
struct ABGLearnView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: LearnSection = .formulas
    
    enum LearnSection: String, CaseIterable {
        case formulas = "Formulas"
        case disorders = "Disorders"
        case compensation = "Compensation"
        case approach = "Approach"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Tab Picker
                    Picker("Section", selection: $selectedTab) {
                        ForEach(LearnSection.allCases, id: \.self) { section in
                            Text(section.rawValue).tag(section)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    switch selectedTab {
                    case .formulas:
                        formulasContent
                    case .disorders:
                        disordersContent
                    case .compensation:
                        compensationContent
                    case .approach:
                        approachContent
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("ABG Learning Center")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private var formulasContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            LearnCard(
                title: "Henderson-Hasselbalch Equation",
                formula: "pH = 6.1 + log(HCO₃⁻ / (0.03 × PaCO₂))",
                explanation: "The fundamental equation relating pH to the ratio of bicarbonate to dissolved CO₂. Used to calculate any one variable when the other two are known."
            )
            
            LearnCard(
                title: "Winter's Formula",
                formula: "Expected PaCO₂ = (1.5 × HCO₃⁻) + 8 ± 2",
                explanation: "Used in metabolic acidosis to predict the expected respiratory compensation. If actual PaCO₂ differs from expected, a mixed disorder is present."
            )
            
            LearnCard(
                title: "Base Excess",
                formula: "BE = 0.02786 × PaCO₂ × 10^(pH-6.1) + 13.77 × pH - 124.58",
                explanation: "Represents the amount of acid or base needed to restore blood pH to 7.4 at PaCO₂ of 40 mmHg. Normal: -2 to +2 mEq/L."
            )
            
            LearnCard(
                title: "Anion Gap",
                formula: "AG = Na⁺ - (Cl⁻ + HCO₃⁻)",
                explanation: "Normal: 8-12 mEq/L. Elevated in HAGMA (MUDPILES: Methanol, Uremia, DKA, Propylene glycol, Iron/INH, Lactic acidosis, Ethylene glycol, Salicylates)."
            )
            
            LearnCard(
                title: "Delta Ratio",
                formula: "ΔAG/ΔHCO₃ = (AG - 12) / (24 - HCO₃)",
                explanation: "Used when AG is elevated:\n• < 1: Mixed HAGMA + NAGMA\n• 1-2: Pure HAGMA\n• > 2: HAGMA + metabolic alkalosis"
            )
        }
        .padding(.horizontal)
    }
    
    private var disordersContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            DisorderCard(
                title: "Metabolic Acidosis",
                features: "↓ pH, ↓ HCO₃⁻",
                causes: "HAGMA: MUDPILES\nNAGMA: Diarrhea, RTA, dilutional"
            )
            
            DisorderCard(
                title: "Metabolic Alkalosis",
                features: "↑ pH, ↑ HCO₃⁻",
                causes: "Vomiting, NG suction, diuretics, hypokalemia, Cushing's"
            )
            
            DisorderCard(
                title: "Respiratory Acidosis",
                features: "↓ pH, ↑ PaCO₂",
                causes: "COPD, sedation, neuromuscular disease, airway obstruction"
            )
            
            DisorderCard(
                title: "Respiratory Alkalosis",
                features: "↑ pH, ↓ PaCO₂",
                causes: "Anxiety, pain, hypoxemia, PE, sepsis, pregnancy, altitude"
            )
        }
        .padding(.horizontal)
    }
    
    private var compensationContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            CompensationCard(
                disorder: "Metabolic Acidosis",
                compensation: "Respiratory (hyperventilation)",
                formula: "Expected PaCO₂ = (1.5 × HCO₃⁻) + 8 ± 2",
                timing: "Hours"
            )
            
            CompensationCard(
                disorder: "Metabolic Alkalosis",
                compensation: "Respiratory (hypoventilation)",
                formula: "Expected PaCO₂ = (0.7 × HCO₃⁻) + 21 ± 1.5",
                timing: "Hours"
            )
            
            CompensationCard(
                disorder: "Respiratory Acidosis",
                compensation: "Metabolic (renal HCO₃⁻ retention)",
                formula: "Acute: ↑ 1 mEq/L per 10 mmHg ↑ PaCO₂\nChronic: ↑ 3.5 mEq/L per 10 mmHg ↑ PaCO₂",
                timing: "Acute: hours\nChronic: 3-5 days"
            )
            
            CompensationCard(
                disorder: "Respiratory Alkalosis",
                compensation: "Metabolic (renal HCO₃⁻ excretion)",
                formula: "Acute: ↓ 2 mEq/L per 10 mmHg ↓ PaCO₂\nChronic: ↓ 4-5 mEq/L per 10 mmHg ↓ PaCO₂",
                timing: "Acute: hours\nChronic: 2-3 days"
            )
        }
        .padding(.horizontal)
    }
    
    private var approachContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            ApproachStep(number: 1, title: "Look at the pH", description: "Is the patient acidemic (< 7.35) or alkalemic (> 7.45)?")
            ApproachStep(number: 2, title: "Identify the primary disorder", description: "Does the PaCO₂ or HCO₃⁻ explain the pH change?")
            ApproachStep(number: 3, title: "Calculate expected compensation", description: "Use appropriate formula based on primary disorder")
            ApproachStep(number: 4, title: "Compare actual vs expected", description: "If different, a mixed disorder is present")
            ApproachStep(number: 5, title: "Calculate anion gap if acidosis", description: "AG > 12 suggests HAGMA; calculate delta ratio")
            ApproachStep(number: 6, title: "Correlate clinically", description: "ABG interpretation must fit the clinical picture")
        }
        .padding(.horizontal)
    }
}

// MARK: - Learn Card Components
private struct LearnCard: View {
    let title: String
    let formula: String
    let explanation: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(red: 0.06, green: 0.60, blue: 0.97))
            
            Text(formula)
                .font(.system(.body, design: .monospaced))
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Material.thin)
                        .shadow(color: Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.08), radius: 4, x: 0, y: 2)
                )
            
            Text(explanation)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Material.thin)
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.06), Color.white.opacity(0.02)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: -2, y: -2)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 3, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.15), lineWidth: 0.5)
        )
    }
}

private struct DisorderCard: View {
    let title: String
    let features: String
    let causes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            HStack {
                Text("Features:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(features)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(Color(red: 0.06, green: 0.60, blue: 0.97))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Causes:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(causes)
                    .font(.caption)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Material.thin)
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Color.orange.opacity(0.05), Color.red.opacity(0.02)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: -2, y: -2)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 3, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.orange.opacity(0.15), lineWidth: 0.5)
        )
    }
}

private struct CompensationCard: View {
    let disorder: String
    let compensation: String
    let formula: String
    let timing: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(disorder)
                .font(.headline)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Compensation:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(compensation)
                        .font(.caption)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Timing:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(timing)
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Text(formula)
                .font(.system(.caption, design: .monospaced))
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Material.thin)
                        .shadow(color: .purple.opacity(0.06), radius: 3, x: 0, y: 1)
                )
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Material.thin)
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.06), Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.02)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: -2, y: -2)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 3, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.purple.opacity(0.15), lineWidth: 0.5)
        )
    }
}

private struct ApproachStep: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(number)")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.06, green: 0.60, blue: 0.97), Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.3), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Material.thin)
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.05), Color.white.opacity(0.02)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: -2, y: -2)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 3, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.1), lineWidth: 0.5)
        )
    }
}

// MARK: - ABG Light Background
struct ABGLightBackground: View {
    @State private var animate = false

    private let navyOrb = Color(red: 0.18, green: 0.25, blue: 0.34).opacity(0.04)
    private let goldOrb = Color(red: 0.96, green: 0.71, blue: 0.0).opacity(0.03)

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.96, green: 0.97, blue: 0.98),
                    Color(red: 0.93, green: 0.94, blue: 0.98),
                    Color(red: 0.96, green: 0.97, blue: 0.98)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )

            GeometryReader { geo in
                Circle()
                    .fill(navyOrb)
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                        y: animate ? geo.size.height * 0.2 : geo.size.height * 0.4
                    )

                Circle()
                    .fill(goldOrb)
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                    .offset(
                        x: animate ? geo.size.width * 0.1 : geo.size.width * 0.5,
                        y: animate ? geo.size.height * 0.6 : geo.size.height * 0.3
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - ABG Section Divider
struct ABGSectionDivider: View {
    let title: String

    var body: some View {
        HStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.7, green: 0.7, blue: 0.75), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            Text(title)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                .textCase(.uppercase)
                .tracking(2)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color(red: 0.7, green: 0.7, blue: 0.75)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - ABG Achievement Badge
struct ABGAchievementBadge: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let color: Color
}

// MARK: - ABG Badge View
struct ABGBadgeView: View {
    let badge: ABGAchievementBadge

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: badge.icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(badge.color)

            Text(badge.title)
                .font(.custom("Poppins-SemiBold", size: 12))
                .foregroundColor(Color(red: 0.04, green: 0.09, blue: 0.16))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.8))
        )
        .overlay(
            Capsule()
                .stroke(badge.color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: badge.color.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// MARK: - ABG New Input Card
struct ABGNewInputCard: View {
    let icon: String
    let title: String
    @Binding var value: String
    let unit: String
    let placeholder: String
    let normalRange: String
    let accentColor: Color
    let textPrimary: Color
    let textSecondary: Color
    let status: ABGInputStatus
    var isCalculated: Bool = false
    var validationRange: ValidationRange? = nil
    
    @State private var showValidationWarning = false
    @State private var validationMessage = ""
    
    private let haptic = UINotificationFeedbackGenerator()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(accentColor)

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(textPrimary)
                    .fixedSize(horizontal: true, vertical: false)

                if isCalculated {
                    Text("calc")
                        .font(.custom("Poppins-Medium", size: 10))
                        .foregroundColor(Color(red: 0.18, green: 0.25, blue: 0.34))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.18, green: 0.25, blue: 0.34).opacity(0.15))
                        )
                }

                Spacer()
                
                // Validation warning indicator
                if showValidationWarning {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 16, weight: .semibold))
                        .transition(.scale.combined(with: .opacity))
                }
                // Status indicator
                else if !value.isEmpty || isCalculated {
                    Image(systemName: status.icon)
                        .foregroundColor(status.color)
                        .font(.system(size: 16, weight: .semibold))
                        .transition(.scale.combined(with: .opacity))
                }
            }

            HStack {
                TextField(placeholder, text: $value)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(showValidationWarning ? .orange : (isCalculated && value.isEmpty ? Color(red: 0.18, green: 0.25, blue: 0.34) : textPrimary))
                    .multilineTextAlignment(.leading)
                    .onChange(of: value) { newValue in
                        validateInput(newValue)
                    }

                Spacer()

                if !unit.isEmpty {
                    Text(unit)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(textSecondary)
                }
            }
            
            // Validation warning message
            if showValidationWarning {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 11))
                    Text(validationMessage)
                        .font(.custom("Poppins-Medium", size: 12))
                }
                .foregroundColor(.orange)
                .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                Text("Normal: \(normalRange)")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(Color(red: 0.42, green: 0.49, blue: 0.54))
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(showValidationWarning ? Color.orange.opacity(0.4) : accentColor.opacity(0.15), lineWidth: showValidationWarning ? 2 : 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
        .animation(.easeInOut(duration: 0.2), value: showValidationWarning)
    }
    
    private func validateInput(_ input: String) {
        guard let validation = validationRange, !input.isEmpty else {
            showValidationWarning = false
            validationMessage = ""
            return
        }
        
        let result = validation.validateString(input)
        
        switch result {
        case .valid:
            showValidationWarning = false
            validationMessage = ""
        case .tooLow(let minValue):
            showValidationWarning = true
            validationMessage = "Value too low (min: \(validation.sigFigs == 0 ? String(Int(minValue)) : String(format: "%.\(validation.sigFigs)f", minValue)))"
            haptic.notificationOccurred(.warning)
        case .tooHigh(let maxValue):
            showValidationWarning = true
            validationMessage = "Value too high (max: \(validation.sigFigs == 0 ? String(Int(maxValue)) : String(format: "%.\(validation.sigFigs)f", maxValue)))"
            haptic.notificationOccurred(.warning)
        case .invalid:
            showValidationWarning = true
            validationMessage = "Invalid value"
            haptic.notificationOccurred(.error)
        }
    }
}

// MARK: - ABG Result Card View
struct ABGResultCardView<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let accentColor: Color
    let textPrimary: Color
    let textSecondary: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(iconColor.opacity(0.1))
                    )

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 17))
                    .foregroundColor(textPrimary)
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(accentColor.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
    }
}

// MARK: - ABG Summary Value Card
struct ABGSummaryValueCard: View {
    let label: String
    let value: String
    let status: ABGInputStatus
    let normalRange: String
    let textPrimary: Color
    let textMuted: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(textMuted)
                Spacer()
                Image(systemName: status.icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(status.color)
            }

            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(status == .normal ? textPrimary : status.color)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(normalRange)
                .font(.custom("Poppins-Regular", size: 11))
                .foregroundColor(textMuted.opacity(0.8))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(status.color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - ABG Confetti View
struct ABGConfettiView: View {
    @State private var particles: [ConfettiParticle] = []

    struct ConfettiParticle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        let color: Color
        let size: CGFloat
        var rotation: Double
    }

    private let colors: [Color] = [
        Color(red: 0.40, green: 0.84, blue: 0.72),  // Mint
        Color(red: 0.06, green: 0.60, blue: 0.97),  // Blue
        Color(red: 0.18, green: 0.25, blue: 0.34),  // Navy
        Color(red: 0.96, green: 0.71, blue: 0.0)   // Gold
    ]

    var body: some View {
        GeometryReader { geo in
            ForEach(particles) { particle in
                Rectangle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size * 0.6)
                    .rotationEffect(.degrees(particle.rotation))
                    .position(x: particle.x, y: particle.y)
            }
        }
        .onAppear {
            createParticles()
            animateParticles()
        }
    }

    private func createParticles() {
        particles = (0..<40).map { _ in
            ConfettiParticle(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: -20,
                color: colors.randomElement() ?? .blue,
                size: CGFloat.random(in: 6...10),
                rotation: Double.random(in: 0...360)
            )
        }
    }

    private func animateParticles() {
        for i in particles.indices {
            withAnimation(.easeIn(duration: Double.random(in: 2...3))) {
                particles[i].y = UIScreen.main.bounds.height + 50
                particles[i].rotation += Double.random(in: 180...720)
            }
        }
    }
}

// MARK: - ABG Pulse Ring View
struct ABGPulseRingView: View {
    let color: Color
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1

    var body: some View {
        ZStack {
            ForEach(0..<4) { i in
                Circle()
                    .stroke(color, lineWidth: 2)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(
                        .easeOut(duration: 1.5)
                            .delay(Double(i) * 0.3),
                        value: scale
                    )
            }
        }
        .frame(width: 200, height: 200)
        .onAppear {
            scale = 2.0
            opacity = 0
        }
    }
}

// MARK: - ABG Sparkle View
struct ABGSparkleView: View {
    @State private var particles: [SparkleParticle] = []

    struct SparkleParticle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var opacity: Double
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(particles) { particle in
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.96, green: 0.71, blue: 0.0))
                    .scaleEffect(particle.scale)
                    .opacity(particle.opacity)
                    .position(x: particle.x, y: particle.y)
            }
        }
        .onAppear {
            createSparkles()
        }
    }

    private func createSparkles() {
        let center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)

        particles = (0..<20).map { _ in
            return SparkleParticle(
                x: center.x,
                y: center.y,
                scale: 0.3,
                opacity: 1
            )
        }

        for i in particles.indices {
            let angle = Double(i) * (360.0 / 20.0) * .pi / 180
            let distance: CGFloat = 150

            withAnimation(.easeOut(duration: 1.5)) {
                particles[i].x += cos(angle) * distance
                particles[i].y += sin(angle) * distance
                particles[i].scale = 1.5
                particles[i].opacity = 0
            }
        }
    }
}

// MARK: - ABG Success Glow View
struct ABGSuccessGlowView: View {
    let color: Color
    @State private var opacity: Double = 0

    var body: some View {
        RadialGradient(
            colors: [color.opacity(0.3), Color.clear],
            center: .center,
            startRadius: 50,
            endRadius: 200
        )
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                opacity = 1
            }
            withAnimation(.easeInOut(duration: 1.5).delay(0.5)) {
                opacity = 0
            }
        }
    }
}

// MARK: - ABG Fireworks View
struct ABGFireworksView: View {
    @State private var bursts: [FireworkBurst] = []

    struct FireworkBurst: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let color: Color
        var scale: CGFloat
        var opacity: Double
    }

    private let colors: [Color] = [
        Color(red: 0.40, green: 0.84, blue: 0.72),
        Color(red: 0.06, green: 0.60, blue: 0.97),
        Color(red: 0.96, green: 0.71, blue: 0.0)
    ]

    var body: some View {
        GeometryReader { geo in
            ForEach(bursts) { burst in
                Circle()
                    .fill(burst.color)
                    .frame(width: 20, height: 20)
                    .scaleEffect(burst.scale)
                    .opacity(burst.opacity)
                    .position(x: burst.x, y: burst.y)
            }
        }
        .onAppear {
            createBursts()
        }
    }

    private func createBursts() {
        let positions: [(CGFloat, CGFloat)] = [
            (0.2, 0.3), (0.8, 0.25), (0.5, 0.4), (0.3, 0.5), (0.7, 0.45)
        ]

        for (i, pos) in positions.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.4) {
                let burst = FireworkBurst(
                    x: UIScreen.main.bounds.width * pos.0,
                    y: UIScreen.main.bounds.height * pos.1,
                    color: colors.randomElement() ?? .blue,
                    scale: 0.1,
                    opacity: 1
                )
                bursts.append(burst)

                withAnimation(.easeOut(duration: 0.8)) {
                    if let index = bursts.firstIndex(where: { $0.id == burst.id }) {
                        bursts[index].scale = 8
                        bursts[index].opacity = 0
                    }
                }
            }
        }
    }
}

// MARK: - ABG Checkmark View
struct ABGCheckmarkView: View {
    let color: Color
    @State private var trimEnd: CGFloat = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Glass background container for visibility
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .frame(width: 120, height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)

            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 80, height: 80)
                .scaleEffect(scale)

            Circle()
                .stroke(color, lineWidth: 4)
                .frame(width: 60, height: 60)

            Path { path in
                path.move(to: CGPoint(x: 20, y: 32))
                path.addLine(to: CGPoint(x: 28, y: 40))
                path.addLine(to: CGPoint(x: 44, y: 24))
            }
            .trim(from: 0, to: trimEnd)
            .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .frame(width: 60, height: 60)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1
                opacity = 1
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                trimEnd = 1
            }
            withAnimation(.easeOut(duration: 0.3).delay(1.2)) {
                opacity = 0
            }
        }
    }
}

// MARK: - Animated Blood Drop Icon
/// An animated blood drop icon for ABG/blood-related calculators
private struct AnimatedBloodDropIcon: View {
    let color: Color
    let size: CGFloat

    @State private var isAnimating = false

    init(color: Color = .red, size: CGFloat = 40) {
        self.color = color
        self.size = size
    }

    var body: some View {
        ZStack {
            // Ripple effect - expanding circles
            ForEach(0..<2, id: \.self) { index in
                Circle()
                    .stroke(color.opacity(0.4 - Double(index) * 0.15), lineWidth: 1.5)
                    .frame(width: size * 0.8, height: size * 0.8)
                    .scaleEffect(isAnimating ? 2.0 : 1.0)
                    .opacity(isAnimating ? 0.0 : 0.5)
                    .animation(
                        .easeOut(duration: 2.0)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.5),
                        value: isAnimating
                    )
            }

            // Blood drop icon with gentle pulse
            Image(systemName: "drop.fill")
                .font(.system(size: size * 0.6, weight: .medium))
                .foregroundColor(color)
                .scaleEffect(isAnimating ? 1.08 : 1.0)
                .animation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - ViewModifiers (Fix Type-Checking Timeouts)

/// Custom shadow style for calculated value cards
/// Extracted to prevent type-checker timeout from chained ternary shadows
struct CalculatedValueCardShadows: ViewModifier {
    let colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        content
            .shadow(color: shadow1Color, radius: 1, x: -1, y: -1)
            .shadow(color: shadow2Color, radius: 2, x: 0, y: 1)
            .shadow(color: shadow3Color, radius: 10, x: 0, y: 5)
    }
    
    private var shadow1Color: Color {
        colorScheme == .dark 
            ? CriticalDesign.Colors.darkCanvas.opacity(0.3) 
            : Color.white.opacity(0.8)
    }
    
    private var shadow2Color: Color {
        colorScheme == .dark 
            ? CriticalDesign.Colors.darkCanvas.opacity(0.3) 
            : Color.black.opacity(0.04)
    }
    
    private var shadow3Color: Color {
        colorScheme == .dark 
            ? CriticalDesign.Colors.darkCanvas.opacity(0.5) 
            : Color.black.opacity(0.07)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ABGCalculatorStandalone()
    }
}
