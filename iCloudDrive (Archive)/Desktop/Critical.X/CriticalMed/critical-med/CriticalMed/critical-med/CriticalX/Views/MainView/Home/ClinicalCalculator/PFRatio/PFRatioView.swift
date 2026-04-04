//
//  PFRatioView.swift
//  CriticalX
//
//  Created by Macbook 4 on 10/12/2021.
//  Redesigned with Premium Light Theme
//

import SwiftUI

// MARK: - Adaptive Background (Light/Dark)
struct PFLightBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false

    // Light mode orbs
    private let navyOrbLight = Color(red: 0.11, green: 0.21, blue: 0.34).opacity(0.04)
    private let goldOrbLight = Color(red: 0.79, green: 0.64, blue: 0.15).opacity(0.03)
    
    // Dark mode orbs (gold tinted)
    private let goldOrbDark = CriticalDesign.Colors.goldMid.opacity(0.08)
    private let blueOrbDark = CriticalDesign.Colors.accentTeal.opacity(0.06)

    var body: some View {
        ZStack {
            // Adaptive background gradient
            CriticalDesign.Adaptive.backgroundGradient(for: colorScheme)

            GeometryReader { geo in
                Circle()
                    .fill(colorScheme == .dark ? goldOrbDark : navyOrbLight)
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                        y: animate ? geo.size.height * 0.2 : geo.size.height * 0.4
                    )

                Circle()
                    .fill(colorScheme == .dark ? blueOrbDark : goldOrbLight)
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

// MARK: - Section Divider (Adaptive)
struct PFSectionDivider: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String

    var body: some View {
        HStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: colorScheme == .dark
                            ? [Color.white.opacity(0.2), Color.clear]
                            : [Color(red: 0.7, green: 0.7, blue: 0.75), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            Text(title)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : Color(red: 0.5, green: 0.5, blue: 0.55))
                .textCase(.uppercase)
                .tracking(2)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: colorScheme == .dark
                            ? [Color.clear, Color.white.opacity(0.2)]
                            : [Color.clear, Color(red: 0.7, green: 0.7, blue: 0.75)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.vertical, 4)
    }
}

struct PFRatioView: View {
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Adaptive Colors (Navy-centered dark mode)
    private var textPrimary: Color { RGBColorMap.textPrimary(for: colorScheme) }
    private var textSecondary: Color { RGBColorMap.textSecondary(for: colorScheme) }
    private var textTertiary: Color { colorScheme == .dark ? .white.opacity(0.5) : Color(red: 0.24, green: 0.35, blue: 0.50) }
    private var textMuted: Color { colorScheme == .dark ? .white.opacity(0.3) : Color(red: 0.42, green: 0.49, blue: 0.54) }

    // Adaptive navy for buttons
    private var navyPrimary: Color { RGBColorMap.textPrimary(for: colorScheme) }
    private var navyAccent: Color { RGBColorMap.textSecondary(for: colorScheme) }

    // Brand accent colors (work in both light and dark mode)
    private let accentBlue = CriticalDesign.Colors.accentBlue
    private let accentGreen = CriticalDesign.Colors.accentTeal

    // Semantic colors for ARDS classification (work in both modes)
    private let semanticRed = CriticalDesign.Colors.accentRed
    private let semanticOrange = CriticalDesign.Colors.accentOrange
    private let semanticYellow = CriticalDesign.Colors.gold
    private let semanticGreen = CriticalDesign.Colors.accentGreen

    // Legacy compatibility (using adaptive colors)
    private var accentRed: Color { semanticRed }
    private var accentOrange: Color { semanticOrange }
    private var accentYellow: Color { semanticYellow }
    private var accentTeal: Color { RGBColorMap.textSecondary(for: colorScheme) }

    // MARK: - State Properties
    @State private var isAppearing = false
    @State private var showResult = false

    // Input fields
    @State private var paO2Field: String = ""
    @State private var fiO2Field: String = ""

    // Results
    @State private var pfRatio: Double = 0
    @State private var paO2Value: Double = 0
    @State private var fiO2Value: Double = 0

    @State private var showingPopup: Bool = false
    
    // Validation state (simple booleans)
    @State private var paO2IsValid: Bool = true
    @State private var paO2ErrorMessage: String? = nil
    @State private var fiO2IsValid: Bool = true
    @State private var fiO2ErrorMessage: String? = nil

    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case paO2, fiO2
    }

    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Inline Validation Helpers
    private func validatePaO2(_ value: String) -> (isValid: Bool, message: String?) {
        guard let num = Double(value) else { return (true, nil) }
        if num < 20 { return (false, "Min: 20 mmHg") }
        if num > 600 { return (false, "Max: 600 mmHg") }
        return (true, nil)
    }
    
    private func validateFiO2(_ value: String) -> (isValid: Bool, message: String?) {
        guard let num = Double(value) else { return (true, nil) }
        if num < 21 { return (false, "Min: 21%") }
        if num > 100 { return (false, "Max: 100%") }
        return (true, nil)
    }

    // MARK: - ARDS Classification
    private var classification: ARDSClassification {
        if pfRatio < 100 { return .severe }
        else if pfRatio <= 200 { return .moderate }
        else if pfRatio <= 300 { return .mild }
        else { return .normal }
    }

    enum ARDSClassification {
        case severe, moderate, mild, normal

        var title: String {
            switch self {
            case .severe: return "Severe Hypoxemia"
            case .moderate: return "Moderate Hypoxemia"
            case .mild: return "Mild Hypoxemia"
            case .normal: return "Normal Oxygenation"
            }
        }

        var description: String {
            switch self {
            case .severe: return "ARDS criteria met • P/F < 100. Consider prone positioning, PEEP optimization, and neuromuscular blockade."
            case .moderate: return "ARDS criteria met • P/F 100-200. Optimize ventilation strategy and consider rescue therapies."
            case .mild: return "ARDS criteria met • P/F 200-300. Lung protective ventilation indicated."
            case .normal: return "Adequate oxygenation • P/F > 300. Normal gas exchange."
            }
        }

        func color(accentRed: Color, accentOrange: Color, accentYellow: Color, accentGreen: Color) -> Color {
            switch self {
            case .severe: return accentRed
            case .moderate: return accentOrange
            case .mild: return accentYellow
            case .normal: return accentGreen
            }
        }

        var icon: String {
            switch self {
            case .severe: return "exclamationmark.triangle.fill"
            case .moderate: return "exclamationmark.circle.fill"
            case .mild: return "info.circle.fill"
            case .normal: return "checkmark.circle.fill"
            }
        }
    }

    // MARK: - Info Sections
    private let infoSections: [(title: String, icon: String, content: String)] = [
        (
            title: "When to Use",
            icon: "timer",
            content: """
            Calculate **P/F Ratio** (PaO₂/FiO₂) to assess oxygenation status and ARDS severity.

            **Clinical Scenarios:**
            • ARDS severity classification
            • Respiratory failure assessment
            • Ventilator weaning evaluation
            • Monitoring oxygenation trends
            """
        ),
        (
            title: "Key Points",
            icon: "lightbulb.fill",
            content: """
            **Formula:**
            P/F Ratio = PaO₂ (mmHg) ÷ FiO₂ (decimal)

            **Berlin ARDS Criteria:**
            • **Mild:** P/F 200-300
            • **Moderate:** P/F 100-200
            • **Severe:** P/F < 100

            **Normal:** P/F > 300-400 (on room air ~400-500)
            """
        ),
        (
            title: "Clinical Use",
            icon: "stethoscope",
            content: """
            **ARDS Management by Severity:**
            • **Mild:** Low tidal volume ventilation
            • **Moderate:** PEEP optimization, prone consider
            • **Severe:** Prone, ECMO consider, paralysis

            **Limitations:**
            • FiO₂ and PEEP affect interpretation
            • Requires ABG measurement
            • Altitude adjustments needed
            """
        )
    ]

    var body: some View {
        ZStack {
            // Adaptive Canvas Background
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // MARK: - Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : -10)

                    // MARK: - Hero Section
                    heroSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)

                    // MARK: - Info Sections
                    IconTabBar(sections: infoSections)
                        .padding(.horizontal, 20)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)

                    // MARK: - ARDS Reference Card
                    ardsReferenceCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)

                    PFSectionDivider(title: "Blood Gas Values")
                        .padding(.horizontal, 20)
                        .opacity(isAppearing ? 1 : 0)

                    // MARK: - Input Section
                    inputSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)

                    // MARK: - Calculate Button
                    calculateButton
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)

                    // MARK: - Result Section
                    if showResult {
                        PFSectionDivider(title: "Results")
                            .padding(.horizontal, 20)

                        PFResultCardLight(
                            pfRatio: pfRatio,
                            paO2: paO2Value,
                            fiO2: fiO2Value,
                            classification: classification,
                            accentBlue: accentBlue,
                            accentRed: accentRed,
                            accentGreen: accentGreen,
                            accentOrange: accentOrange,
                            accentYellow: accentYellow,
                            accentTeal: accentTeal,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            textTertiary: textTertiary,
                            textMuted: textMuted
                        )
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95).combined(with: .opacity),
                            removal: .opacity
                        ))
                    }

                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
            }
            .onTapGesture {
                focusedField = nil
            }
            .dismissKeyboardOnScroll()
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: { moveToPreviousField() }) {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(focusedField != .paO2 ? navyAccent : Color.gray.opacity(0.5))
                    .disabled(focusedField == .paO2)

                    Button(action: { moveToNextField() }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(focusedField != .fiO2 ? navyAccent : Color.gray.opacity(0.5))
                    .disabled(focusedField == .fiO2)

                    Spacer()

                    Text(currentFieldLabel)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(textSecondary)
                        .fixedSize(horizontal: true, vertical: false)

                    Spacer()

                    Button("Done") {
                        focusedField = nil
                    }
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(navyAccent)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.1)) {
                isAppearing = true
            }
        }
        .fullScreenCover(isPresented: $showingPopup) {
            HoldOnPopupView(title: "Hold On!", message: "Enter PaO₂ and FiO₂ to calculate P/F ratio.")
                .background(BackgroundClearView())
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CriticalFavoriteButton(title: "P/F Ratio", type: "Cal")
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                haptic.impactOccurred()
                paO2Field = ""
                fiO2Field = ""
                showResult = false
                focusedField = nil
            }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textSecondary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    )
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            // Icon - Minimal navy aesthetic
            ZStack {
                Circle()
                    .fill(navyAccent.opacity(0.08))
                    .frame(width: 100, height: 100)

                Image(systemName: "lungs.fill")
                    .font(.system(size: 44, weight: .medium))
                    .foregroundColor(navyAccent)
            }

            VStack(spacing: 6) {
                Text("P/F Ratio")
                    .font(.custom("Poppins-Bold", size: 32))
                    .foregroundColor(textPrimary)

                Text("PaO₂ / FiO₂ Oxygenation Index")
                    .font(.custom("Poppins-Medium", size: 15))
                    .foregroundColor(textTertiary)
                    .tracking(0.5)
            }

            // Clinical Pearl Card - Minimal styling
            HStack(alignment: .top, spacing: 12) {
                Image("LogoMonogram")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)

                Text("The P/F ratio is the gold standard for assessing oxygenation impairment and ARDS severity classification.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(navyAccent.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 20)
        }
    }

    // MARK: - ARDS Reference Card
    private var ardsReferenceCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(navyAccent)

                Text("Berlin ARDS Criteria")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)

                Spacer()
            }

            VStack(spacing: 6) {
                ardsRow(range: "> 300", category: "Normal", color: semanticGreen)
                ardsRow(range: "200-300", category: "Mild ARDS", color: semanticYellow)
                ardsRow(range: "100-200", category: "Moderate ARDS", color: semanticOrange)
                ardsRow(range: "< 100", category: "Severe ARDS", color: semanticRed)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(navyAccent.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 20)
    }

    private func ardsRow(range: String, category: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            Text(range)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(color)
                .frame(width: 80, alignment: .leading)

            Text(category)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(textSecondary)

            Spacer()
        }
        .padding(.vertical, 2)
    }

    // MARK: - Input Section
    private var inputSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(navyAccent)

                Text("ABG Values")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)

                Spacer()
            }

            // PaO2 Input - using navy accent
            inputRow(
                title: "PaO₂",
                subtitle: "Arterial Oxygen Pressure",
                placeholder: "80",
                value: $paO2Field,
                unit: "mmHg",
                accentColor: navyAccent,
                field: .paO2
            )

            // Divider with formula
            HStack {
                Spacer()
                Text("÷")
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .foregroundColor(textMuted)
                Spacer()
            }
            .padding(.vertical, 4)

            // FiO2 Input - using navy accent
            inputRow(
                title: "FiO₂",
                subtitle: "Fraction of Inspired Oxygen",
                placeholder: "50",
                value: $fiO2Field,
                unit: "%",
                accentColor: navyAccent,
                field: .fiO2
            )

            // Info text
            Text("Enter FiO₂ as percentage (e.g., 50 for 50%)")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(textMuted)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(navyAccent.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 20)
    }

    // MARK: - Input Row Builder
    @ViewBuilder
    private func inputRow(
        title: String,
        subtitle: String,
        placeholder: String,
        value: Binding<String>,
        unit: String,
        accentColor: Color,
        field: Field
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(textSecondary)

                    Text(subtitle)
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(accentColor)
                }

                Spacer()

                HStack(spacing: 6) {
                    TextField(placeholder, text: value)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(accentColor)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .frame(width: 80)
                        .focused($focusedField, equals: field)
                        .onChange(of: value.wrappedValue) { newValue in
                            validateForField(field, value: newValue)
                        }

                    Text(unit)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(textMuted)
                        .frame(width: 50, alignment: .leading)
                }
            }
            
            // Validation warning
            if let warning = validationWarning(for: field) {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 10))
                    Text(warning)
                        .font(.custom("Poppins-Regular", size: 11))
                }
                .foregroundColor(.orange)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: paO2IsValid)
        .animation(.easeInOut(duration: 0.2), value: fiO2IsValid)
    }

    // MARK: - Calculate Button (Solid Navy with Micro Animation)
    private var calculateButton: some View {
        Button(action: {
            haptic.impactOccurred()
            focusedField = nil
            validateAndCalculate()
        }) {
            HStack(spacing: 10) {
                Text("Analyze")
                    .font(.custom("Poppins-SemiBold", size: 18))
                Image(systemName: "lungs.fill")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(navyPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 4)
        }
        .buttonStyle(PressableButtonStyle())
        .padding(.horizontal, 20)
    }

    // MARK: - Keyboard Navigation
    private var currentFieldLabel: String {
        switch focusedField {
        case .paO2:
            return "PaO₂"
        case .fiO2:
            return "FiO₂"
        case .none:
            return ""
        }
    }

    private func moveToNextField() {
        switch focusedField {
        case .paO2:
            focusedField = .fiO2
        case .fiO2, .none:
            break
        }
    }

    private func moveToPreviousField() {
        switch focusedField {
        case .fiO2:
            focusedField = .paO2
        case .paO2, .none:
            break
        }
    }
    
    // MARK: - Validation Helpers
    private func validateForField(_ field: Field, value: String) {
        guard !value.isEmpty else {
            switch field {
            case .paO2:
                paO2IsValid = true
                paO2ErrorMessage = nil
            case .fiO2:
                fiO2IsValid = true
                fiO2ErrorMessage = nil
            }
            return
        }
        
        switch field {
        case .paO2:
            let result = validatePaO2(value)
            paO2IsValid = result.isValid
            paO2ErrorMessage = result.message
            if !result.isValid {
                let haptic = UINotificationFeedbackGenerator()
                haptic.notificationOccurred(.warning)
            }
        case .fiO2:
            let result = validateFiO2(value)
            fiO2IsValid = result.isValid
            fiO2ErrorMessage = result.message
            if !result.isValid {
                let haptic = UINotificationFeedbackGenerator()
                haptic.notificationOccurred(.warning)
            }
        }
    }
    
    private func validationWarning(for field: Field) -> String? {
        switch field {
        case .paO2:
            return paO2IsValid ? nil : paO2ErrorMessage
        case .fiO2:
            return fiO2IsValid ? nil : fiO2ErrorMessage
        }
    }

    // MARK: - Calculation Logic
    private func validateAndCalculate() {
        guard !paO2Field.isEmpty, !fiO2Field.isEmpty else {
            showingPopup = true
            return
        }
        
        // Check inline validation
        if !paO2IsValid || !fiO2IsValid {
            let haptic = UINotificationFeedbackGenerator()
            haptic.notificationOccurred(.error)
            return
        }

        guard let paO2 = Double(paO2Field),
              let fiO2 = Double(fiO2Field),
              paO2 > 0, fiO2 > 0 else {
            showingPopup = true
            return
        }

        paO2Value = paO2
        fiO2Value = fiO2

        // Calculate P/F Ratio: PaO2 / (FiO2 as decimal)
        // FiO2 entered as %, convert to decimal
        pfRatio = (paO2 / fiO2) * 100
        pfRatio.round()

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            showResult = true
        }

        // Track in recents
        RecentlyUsedTracker.shared.trackCalculation(
            title: "P/F Ratio",
            icon: "lungs.fill",
            detail: "P/F \(String(format: "%.0f", pfRatio)) · \(classification.title)"
        )
    }
}

// MARK: - PF Result Card (Premium Light Theme)
struct PFResultCardLight: View {
    let pfRatio: Double
    let paO2: Double
    let fiO2: Double
    let classification: PFRatioView.ARDSClassification

    // Colors
    let accentBlue: Color
    let accentRed: Color
    let accentGreen: Color
    let accentOrange: Color
    let accentYellow: Color
    let accentTeal: Color
    let textPrimary: Color
    let textSecondary: Color
    let textTertiary: Color
    let textMuted: Color

    @Environment(\.colorScheme) var colorScheme
    @State private var animateIn: Bool = false

    private var classificationColor: Color {
        classification.color(accentRed: accentRed, accentOrange: accentOrange, accentYellow: accentYellow, accentGreen: accentGreen)
    }

    // Navy accent for header — adaptive so it's visible on dark card backgrounds
    private var navyAccent: Color { RGBColorMap.textSecondary(for: colorScheme) }

    // Card fill — semi-transparent in light mode, elevated surface in dark mode
    private var cardFill: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.8)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Image(systemName: "lungs.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(navyAccent)

                Text("P/F Ratio Results")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(textPrimary)

                Spacer()
            }
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 10)

            // Main Result Card
            mainResultCard
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 10)
                .animation(.easeOut(duration: 0.4).delay(0.1), value: animateIn)

            // Classification Card
            classificationCard
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 10)
                .animation(.easeOut(duration: 0.4).delay(0.2), value: animateIn)

            // Severity Scale
            severityScale
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 10)
                .animation(.easeOut(duration: 0.4).delay(0.3), value: animateIn)
        }
        .padding(.horizontal, 20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                animateIn = true
            }
        }
    }

    // MARK: - Main Result Card
    private var mainResultCard: some View {
        VStack(spacing: 12) {
            // Input summary - using navy tones
            HStack(spacing: 6) {
                Text("PaO₂")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(textSecondary)

                Text("\(Int(paO2))")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(navyAccent)

                Text("÷")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(textTertiary)

                Text("FiO₂")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(textSecondary)

                Text("\(Int(fiO2))%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(navyAccent)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Capsule().fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.6)))

            Text("P/F RATIO")
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(textTertiary)
                .tracking(1)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(Int(pfRatio))")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundColor(classificationColor)

                Text("mmHg")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(textSecondary)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(classificationColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
    }

    // MARK: - Classification Card
    private var classificationCard: some View {
        VStack(spacing: 12) {
            // Status Icon & Badge
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(classificationColor.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(systemName: classification.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(classificationColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(classification.title)
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .foregroundColor(classificationColor)

                    Text(pfRatio < 300 ? "Berlin ARDS Criteria" : "Normal Range")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(textTertiary)
                }

                Spacer()
            }

            // Description
            Text(classification.description)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(classificationColor.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(classificationColor.opacity(0.15), lineWidth: 1)
        )
    }

    // MARK: - Severity Scale
    private var severityScale: some View {
        VStack(spacing: 10) {
            Text("OXYGENATION SCALE")
                .font(.custom("Poppins-Medium", size: 11))
                .foregroundColor(textTertiary)
                .tracking(1)

            // Scale visualization
            GeometryReader { geometry in
                let width = geometry.size.width

                ZStack(alignment: .leading) {
                    // Gradient bar
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(accentRed)
                            .frame(width: width * 0.25)

                        Rectangle()
                            .fill(accentOrange)
                            .frame(width: width * 0.25)

                        Rectangle()
                            .fill(accentYellow)
                            .frame(width: width * 0.25)

                        Rectangle()
                            .fill(accentGreen)
                            .frame(width: width * 0.25)
                    }
                    .frame(height: 12)
                    .cornerRadius(6)

                    // Position indicator
                    let maxValue: Double = 400
                    let clampedRatio = min(max(pfRatio, 0), maxValue)
                    let position = (clampedRatio / maxValue) * width

                    Circle()
                        .fill(Color.white)
                        .frame(width: 18, height: 18)
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                        .offset(x: position - 9)
                }
            }
            .frame(height: 18)
            .padding(.horizontal, 12)

            // Labels
            HStack {
                Text("<100")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(accentRed)

                Spacer()

                Text("200")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(accentOrange)

                Spacer()

                Text("300")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(accentYellow)

                Spacer()

                Text(">400")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(accentGreen)
            }
            .padding(.horizontal, 16)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Preview
struct PFRatioView_Previews: PreviewProvider {
    static var previews: some View {
        PFRatioView()
    }
}
