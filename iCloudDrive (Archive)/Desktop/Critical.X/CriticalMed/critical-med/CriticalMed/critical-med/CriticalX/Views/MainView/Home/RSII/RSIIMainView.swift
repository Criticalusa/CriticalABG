//
//  RSIIMainView.swift
//  CriticalX
//
//  Redesigned — conic ring hero, live dose preview, shimmer CTA, glassmorphic cards
//

import SwiftUI

// MARK: - RSI Conic Ring Icon
private struct RSIConicRingIcon: View {
    @Environment(\.colorScheme) var colorScheme

    private let accentBlue  = Color(red: 0.06, green: 0.60, blue: 0.97)
    private let navyAccent  = Color(red: 0.18, green: 0.25, blue: 0.34)
    private let accentTeal  = Color(red: 0.08, green: 0.72, blue: 0.65)

    @State private var spinAngle: Double = 0
    @State private var pulse1Scale: CGFloat = 0.8
    @State private var pulse1Opacity: Double = 0.5
    @State private var pulse2Scale: CGFloat = 0.8
    @State private var pulse2Opacity: Double = 0.5
    @State private var showPulse = false

    private var ringGradient: AngularGradient {
        colorScheme == .dark
            ? AngularGradient(
                gradient: Gradient(colors: [
                    CriticalDesign.Colors.goldMid,
                    CriticalDesign.Colors.goldDeep,
                    CriticalDesign.Colors.goldMid
                ]),
                center: .center
              )
            : AngularGradient(
                gradient: Gradient(colors: [
                    accentBlue,
                    accentTeal,
                    accentBlue
                ]),
                center: .center
              )
    }

    private var iconGradient: LinearGradient {
        colorScheme == .dark
            ? LinearGradient(
                colors: [CriticalDesign.Colors.goldMid, CriticalDesign.Colors.goldDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            : LinearGradient(
                colors: [accentBlue, navyAccent],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
    }

    private var pulseColor: Color {
        colorScheme == .dark ? CriticalDesign.Colors.goldMid : accentBlue
    }

    var body: some View {
        ZStack {
            // Pulse ring 1
            if showPulse {
                Circle()
                    .stroke(pulseColor.opacity(pulse1Opacity), lineWidth: 2)
                    .frame(width: 96, height: 96)
                    .scaleEffect(pulse1Scale)

                // Pulse ring 2
                Circle()
                    .stroke(pulseColor.opacity(pulse2Opacity), lineWidth: 1.5)
                    .frame(width: 96, height: 96)
                    .scaleEffect(pulse2Scale)
            }

            // Spinning conic ring
            Circle()
                .stroke(ringGradient, lineWidth: 4)
                .frame(width: 92, height: 92)
                .rotationEffect(.degrees(spinAngle))

            // Inner circle
            Circle()
                .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .stroke(
                            colorScheme == .dark
                                ? CriticalDesign.Colors.goldGradient
                                : LinearGradient(
                                    colors: [accentBlue.opacity(0.25)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                  ),
                            lineWidth: 1.5
                        )
                )

            // Icon
            Image(systemName: "lungs.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(iconGradient)
        }
        .shadow(
            color: colorScheme == .dark
                ? CriticalDesign.Colors.darkCanvas.opacity(0.5)
                : Color.black.opacity(0.08),
            radius: 12, x: 0, y: 6
        )
        .onAppear {
            // Spin loop
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                spinAngle = 360
            }

            // Pulse rings appear and animate
            showPulse = true
            withAnimation(.easeOut(duration: 2).repeatForever(autoreverses: false)) {
                pulse1Scale = 1.4
                pulse1Opacity = 0
            }
            withAnimation(.easeOut(duration: 2).delay(1).repeatForever(autoreverses: false)) {
                pulse2Scale = 1.4
                pulse2Opacity = 0
            }

            // Hide pulse rings after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeOut(duration: 0.4)) {
                    showPulse = false
                }
            }
        }
    }
}

// MARK: - RSI Weight Toggle
private struct RSIWeightToggle: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isKg: Bool

    private let haptic = UIImpactFeedbackGenerator(style: .light)
    private let accentBlue = Color(red: 0.06, green: 0.60, blue: 0.97)

    var body: some View {
        HStack(spacing: 0) {
            segmentButton(label: "kg", active: isKg) {
                guard !isKg else { return }
                haptic.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isKg = true
                }
            }
            segmentButton(label: "lbs", active: !isKg) {
                guard isKg else { return }
                haptic.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isKg = false
                }
            }
        }
        .background(
            Capsule()
                .fill(colorScheme == .dark
                    ? Color.white.opacity(0.08)
                    : Color.black.opacity(0.06))
        )
    }

    private func segmentButton(label: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(active ? .white : CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(active ? accentBlue : Color.clear)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - RSI Dose Chip
private struct RSIDoseChip: View {
    @Environment(\.colorScheme) var colorScheme
    let drugName: String
    let doseValue: String
    let chipColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(drugName.uppercased())
                .font(.custom("Poppins-Bold", size: 10))
                .foregroundColor(chipColor)
                .lineLimit(1)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(doseValue)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Text("mg")
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(colorScheme == .dark
                    ? Color.white.opacity(0.04)
                    : Color.white.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(chipColor.opacity(0.25), lineWidth: 1)
        )
    }
}

// MARK: - RSI Dose Preview Strip
private struct RSIDosePreviewStrip: View {
    let weightKg: Double?

    private let accentGreen  = Color(red: 0.40, green: 0.84, blue: 0.72)
    private let accentBlue   = Color(red: 0.06, green: 0.60, blue: 0.97)
    private let accentOrange = Color(red: 0.85, green: 0.34, blue: 0.17)
    private let accentRed    = Color(red: 0.92, green: 0.32, blue: 0.38)

    private func formatted(_ value: Double) -> String {
        value < 10
            ? String(format: "%.1f", value)
            : String(format: "%.0f", value)
    }

    private var ketamine: String {
        guard let w = weightKg, w > 0 else { return "—" }
        return formatted(w * 2)
    }
    private var etomidate: String {
        guard let w = weightKg, w > 0 else { return "—" }
        return formatted(w * 0.3)
    }
    private var succinylcholine: String {
        guard let w = weightKg, w > 0 else { return "—" }
        return formatted(w * 1.5)
    }
    private var rocuronium: String {
        guard let w = weightKg, w > 0 else { return "—" }
        return formatted(w * 1.2)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                RSIDoseChip(drugName: "Ketamine", doseValue: ketamine, chipColor: accentGreen)
                RSIDoseChip(drugName: "Etomidate", doseValue: etomidate, chipColor: accentBlue)
                RSIDoseChip(drugName: "Succinylcholine", doseValue: succinylcholine, chipColor: accentOrange)
                RSIDoseChip(drugName: "Rocuronium", doseValue: rocuronium, chipColor: accentRed)
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 2)
        }
    }
}

// MARK: - RSI Shimmer Button Style
private struct RSIShimmerButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    @State private var shimmerOffset: CGFloat = -200

    private let accentBlue = Color(red: 0.06, green: 0.60, blue: 0.97)
    private let navyAccent = Color(red: 0.18, green: 0.25, blue: 0.34)

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geo in
            ZStack {
                // Blue gradient base
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [accentBlue, accentBlue.opacity(0.75), navyAccent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Shimmer overlay
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.15),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 80)
                    .offset(x: shimmerOffset)
                    .clipped()

                configuration.label
            }
        }
        .frame(height: 54)
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
        .shadow(
            color: accentBlue.opacity(0.4),
            radius: 10, x: 0, y: 5
        )
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                shimmerOffset = 400
            }
        }
    }
}

// MARK: - RSI Quick Ref Card
private struct RSIQuickRefCard: View {
    @Environment(\.colorScheme) var colorScheme
    let phaseColor: Color
    let phaseLabel: String
    let drugName: String
    let dose: String
    let onset: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Phase header
            HStack(spacing: 6) {
                Circle()
                    .fill(phaseColor)
                    .frame(width: 8, height: 8)
                Text(phaseLabel)
                    .font(.custom("Poppins-SemiBold", size: 10))
                    .foregroundColor(phaseColor)
                    .textCase(.uppercase)
                    .tracking(0.8)
            }

            // Drug name
            Text(drugName)
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineLimit(1)

            // Dose
            Text(dose)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            // Onset
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.system(size: 10))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                Text(onset)
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(phaseColor.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Section Divider (preserved)
struct RSISectionDivider: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String

    init(title: String) {
        self.title = title
    }

    private var lineColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.15) : Color(red: 0.7, green: 0.7, blue: 0.75)
    }

    var body: some View {
        HStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [lineColor, Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            Text(title)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.5) : Color(red: 0.5, green: 0.5, blue: 0.55))
                .textCase(.uppercase)
                .tracking(2)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, lineColor],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Main View
struct RSIIMainView: View {

    // MARK: - Environment
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Global Patient Context
    @ObservedObject private var patientContext = GlobalPatientContext.shared

    // MARK: - Brand Colors
    private var textPrimary: Color   { CriticalDesign.Adaptive.textPrimary(for: colorScheme) }
    private var textSecondary: Color { CriticalDesign.Adaptive.textSecondary(for: colorScheme) }
    private var textTertiary: Color  { CriticalDesign.Adaptive.textTertiary(for: colorScheme) }
    private var textMuted: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.5)
            : Color(red: 0.42, green: 0.49, blue: 0.54)
    }

    private let accentBlue   = Color(red: 0.06, green: 0.60, blue: 0.97)
    private let navyAccent   = Color(red: 0.18, green: 0.25, blue: 0.34)
    private let accentGreen  = Color(red: 0.40, green: 0.84, blue: 0.72)
    private let accentOrange = Color(red: 0.85, green: 0.34, blue: 0.17)
    private let accentRed    = Color(red: 0.92, green: 0.32, blue: 0.38)
    private let accentTeal   = Color(red: 0.08, green: 0.72, blue: 0.65)

    // MARK: - State
    @State private var weightField: String = ""
    @State private var isKg: Bool = true
    @State private var isAppearing = false
    @State private var showingResultSheet = false
    @State private var showingPopup = false
    @State private var weight: Double = 0
    @State private var showCheckmark = false

    @FocusState private var focusedField: Field?

    enum Field: Hashable { case weight }

    private let haptic        = UIImpactFeedbackGenerator(style: .medium)
    private let successHaptic = UINotificationFeedbackGenerator()

    // MARK: - Computed
    /// Always returns the entered weight converted to kg regardless of unit mode
    private var weightInKg: Double? {
        guard let val = Double(weightField), val > 0 else { return nil }
        return isKg ? val : val / 2.20462
    }

    /// Shows the weight in the opposite unit as a hint
    private var liveConversionText: String {
        guard let val = Double(weightField), val > 0 else { return "—" }
        if isKg {
            return "\(String(format: "%.0f", val * 2.20462)) lbs"
        } else {
            return "\(String(format: "%.1f", val / 2.20462)) kg"
        }
    }

    // MARK: - Info Sections
    private let infoSections: [(title: String, icon: String, content: String)] = [
        (
            title: "When to Use",
            icon: "timer",
            content: """
            **Rapid Sequence Intubation (RSI)** is the preferred method for emergency airway management.

            **Indications:**
            • Patients requiring emergent intubation
            • Risk of aspiration
            • Need for rapid airway control
            • Unable to maintain airway/oxygenation

            **Weight-based dosing** is critical for optimal drug effect and patient safety.
            """
        ),
        (
            title: "Key Points",
            icon: "star.fill",
            content: """
            **RSI Sequence:**
            1. **Preparation** — Equipment, medications, backup plan
            2. **Preoxygenation** — 3-5 min high-flow O₂
            3. **Pretreatment** — Optional agents (3 min before)
            4. **Paralysis + Induction** — Simultaneous admin
            5. **Protection + Positioning** — Optimize for intubation
            6. **Placement** — ETT insertion
            7. **Post-intubation** — Confirm, secure, settings

            **Always have a backup airway plan ready.**
            """
        ),
        (
            title: "Clinical Use",
            icon: "stethoscope",
            content: """
            **Induction Agents:**
            • **Ketamine** — Hemodynamic stability, bronchodilation
            • **Etomidate** — Neutral hemodynamics
            • **Propofol** — Rapid onset, short duration

            **Paralytics:**
            • **Succinylcholine** — Fastest onset (45-60 sec)
            • **Rocuronium** — Longer duration, reversible

            **Choose agents based on patient condition and hemodynamic status.**
            """
        )
    ]

    // MARK: - Body
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)

                    // Hero
                    heroSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 25)

                    // Info Tabs
                    IconTabBar(sections: infoSections)
                        .padding(.horizontal, 20)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 30)

                    // Weight Input
                    weightInputSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 35)

                    // Calculate Button
                    calculateButton
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)

                    // Quick Reference
                    quickReferenceSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 45)

                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .contentShape(Rectangle())
                .onTapGesture { focusedField = nil }
            }
            .dismissKeyboardOnScroll()

            // Checkmark overlay
            if showCheckmark {
                RSICheckmarkView(color: accentGreen)
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            isKg = patientContext.weightUnit == .kg

            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }

            if let globalWeight = patientContext.weightKg, globalWeight > 0, weightField.isEmpty {
                let display = isKg ? globalWeight : globalWeight * 2.20462
                weightField = String(format: "%.0f", display)
            }
        }
        .onChange(of: patientContext.weightKg) { newWeight in
            if let kg = newWeight, kg > 0 {
                let display = isKg ? kg : kg * 2.20462
                let formatted = String(format: "%.0f", display)
                if weightField != formatted { weightField = formatted }
            }
        }
        .onChange(of: isKg) { nowKg in
            // Convert displayed value between units
            if let val = Double(weightField), val > 0 {
                if nowKg {
                    // Was lbs, convert to kg
                    weightField = String(format: "%.1f", val / 2.20462)
                } else {
                    // Was kg, convert to lbs
                    weightField = String(format: "%.0f", val * 2.20462)
                }
            }
            patientContext.weightUnit = nowKg ? .kg : .lbs
        }
        .fullScreenCover(isPresented: $showingResultSheet) {
            RSIIResultDesignView(weightEntered: $weight, isPresented: $showingResultSheet)
        }
        .fullScreenCover(isPresented: $showingPopup) {
            HoldOnPopupView(title: "Hold On!", message: "Please enter a valid patient weight to calculate RSI medications.")
                .background(BackgroundClearView())
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CriticalFavoriteButton(title: "RSI", type: "Cal")
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                haptic.impactOccurred()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    weightField = ""
                    focusedField = nil
                }
            }) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(textSecondary)
                    .frame(width: 48, height: 48)
            }
            .buttonStyle(CriticalNeumorphicIconButtonStyle())

            Spacer()

            NavigationLink {
                SettingView(showingPopup: .constant(false))
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "gear")
                        .font(.system(size: 14, weight: .medium))
                    Text("Settings")
                        .font(.custom("Poppins-Medium", size: 13))
                }
                .foregroundColor(textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(colorScheme == .dark
                            ? CriticalDesign.Colors.cardBlue
                            : Color.white.opacity(0.5))
                )
                .overlay(
                    Capsule()
                        .stroke(
                            colorScheme == .dark
                                ? CriticalDesign.Colors.goldGradient
                                : LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom),
                            lineWidth: colorScheme == .dark ? 1 : 0
                        )
                )
                .shadow(
                    color: colorScheme == .dark
                        ? CriticalDesign.Colors.darkCanvas.opacity(0.4)
                        : Color.black.opacity(0.06),
                    radius: 8, x: 0, y: 4
                )
            }

            Spacer()
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            RSIConicRingIcon()

            // Tag pill
            HStack(spacing: 6) {
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(accentBlue.opacity(0.8))
                Text("Weight-Based Dosing")
                    .font(.custom("Poppins-SemiBold", size: 11))
                    .foregroundColor(accentBlue.opacity(0.9))
                    .tracking(0.3)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(accentBlue.opacity(colorScheme == .dark ? 0.15 : 0.1))
            )

            Text("Rapid Sequence Intubation")
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(textPrimary)

            Text("RSI Medication Calculator")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(textSecondary)
        }
        .padding(.bottom, 8)
    }

    // MARK: - Weight Input Section
    private var weightInputSection: some View {
        VStack(spacing: 16) {
            RSISectionDivider(title: "Patient Data")

            // Glassmorphic weight card
            VStack(alignment: .leading, spacing: 14) {
                // Row: label + unit toggle
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "scalemass.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(accentBlue)
                        Text("Patient Weight")
                            .font(.custom("Poppins-SemiBold", size: 16))
                            .foregroundColor(textPrimary)
                    }

                    Spacer()

                    RSIWeightToggle(isKg: $isKg)
                }

                // Large weight input
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    TextField(isKg ? "70" : "155", text: $weightField)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(accentBlue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .weight)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(isKg ? "kg" : "lbs")
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundColor(textSecondary)
                        .padding(.bottom, 4)
                }

                // Live conversion hint
                HStack(spacing: 4) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 10))
                        .foregroundColor(accentBlue.opacity(0.6))
                    Text(liveConversionText)
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(accentBlue.opacity(0.7))
                }

                // Dose preview strip
                if weightInKg != nil {
                    Divider()
                        .background(colorScheme == .dark
                            ? Color.white.opacity(0.08)
                            : Color.black.opacity(0.06))

                    RSIDosePreviewStrip(weightKg: weightInKg)
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.goldGradient
                            : LinearGradient(
                                colors: [accentBlue.opacity(0.15)],
                                startPoint: .top,
                                endPoint: .bottom
                              ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark
                    ? CriticalDesign.Colors.darkCanvas.opacity(0.4)
                    : Color.black.opacity(0.04),
                radius: 10, x: 0, y: 5
            )

            // Helper text
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 11))
                    .foregroundColor(accentGreen)
                Text("Use actual body weight for accurate medication dosing")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(accentGreen)
                Spacer()
            }
        }
    }

    // MARK: - Calculate Button
    private var calculateButton: some View {
        Button(action: {
            haptic.impactOccurred()
            focusedField = nil
            validateAndCalculate()
        }) {
            HStack(spacing: 10) {
                Text("Calculate Medications")
                    .font(.custom("Poppins-Bold", size: 18))
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .buttonStyle(RSIShimmerButtonStyle())
    }

    // MARK: - Quick Reference Section (2x2 grid)
    private var quickReferenceSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(navyAccent)
                Text("Quick Reference")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                Spacer()
            }

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                spacing: 10
            ) {
                RSIQuickRefCard(
                    phaseColor: accentGreen,
                    phaseLabel: "Induction",
                    drugName: "Ketamine",
                    dose: "1–2 mg/kg IV",
                    onset: "45–60 sec"
                )
                RSIQuickRefCard(
                    phaseColor: accentBlue,
                    phaseLabel: "Induction",
                    drugName: "Etomidate",
                    dose: "0.3 mg/kg IV",
                    onset: "15–45 sec"
                )
                RSIQuickRefCard(
                    phaseColor: accentOrange,
                    phaseLabel: "Paralytic",
                    drugName: "Succinylcholine",
                    dose: "1.5 mg/kg IV",
                    onset: "45–60 sec"
                )
                RSIQuickRefCard(
                    phaseColor: accentRed,
                    phaseLabel: "Paralytic",
                    drugName: "Rocuronium",
                    dose: "1.2 mg/kg IV",
                    onset: "60–90 sec"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.goldGradient
                        : LinearGradient(
                            colors: [navyAccent.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                          ),
                    lineWidth: 1
                )
        )
        .shadow(
            color: colorScheme == .dark
                ? CriticalDesign.Colors.darkCanvas.opacity(0.4)
                : Color.black.opacity(0.04),
            radius: 12, x: 0, y: 6
        )
    }

    // MARK: - Validation
    private func validateAndCalculate() {
        guard !weightField.isEmpty else {
            showingPopup = true
            return
        }

        guard let kg = weightInKg else {
            showingPopup = true
            return
        }

        weight = kg

        // Sync global patient context (always stores kg)
        patientContext.weightKg = kg

        withAnimation(.spring()) {
            showCheckmark = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation { showCheckmark = false }
            showingResultSheet = true

            let etomDose = String(format: "%.1f", kg * 0.3)
            let rocDose  = String(format: "%.0f", kg * 1.2)
            RecentlyUsedTracker.shared.trackCalculation(
                title: "RSI — \(Int(kg))kg patient",
                icon: "syringe.fill",
                detail: "Etom \(etomDose)mg · Roc \(rocDose)mg"
            )
        }
    }
}

// MARK: - Checkmark Animation (preserved)
struct RSICheckmarkView: View {
    let color: Color
    @State private var drawProgress: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.5

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 100, height: 100)

                RSICheckmarkShape()
                    .trim(from: 0, to: drawProgress)
                    .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                    .frame(width: 50, height: 50)
            }
            .position(x: geo.size.width / 2, y: geo.size.height * 0.35)
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    opacity = 1
                    scale = 1
                }
                withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                    drawProgress = 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        opacity = 0
                        scale = 0.8
                    }
                }
            }
        }
    }
}

struct RSICheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startX = rect.width  * 0.15
        let startY = rect.height * 0.5
        let midX   = rect.width  * 0.4
        let midY   = rect.height * 0.75
        let endX   = rect.width  * 0.85
        let endY   = rect.height * 0.25

        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: midX, y: midY))
        path.addLine(to: CGPoint(x: endX, y: endY))

        return path
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        RSIIMainView()
    }
}
