//
//  RaceStrokeDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 28/12/2021.
//  Updated with CriticalDesign neumorphic styling + floating glass score
//

import SwiftUI

struct RaceStrokeDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showFloatingScore = false
    @State private var previousScore: Int = 0
    
    // MARK: - Scroll Animation State
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollY: CGFloat? = nil
    
    private let animationStartOffset: CGFloat = 40
    private let animationEndOffset: CGFloat = 140
    private let scoreCardScrollThreshold: CGFloat = 280
    
    private var collapseProgress: CGFloat {
        guard scrollOffset > animationStartOffset else { return 0 }
        guard scrollOffset < animationEndOffset else { return 1 }
        return (scrollOffset - animationStartOffset) / (animationEndOffset - animationStartOffset)
    }
    
    private var headerVisibility: CGFloat {
        1 - collapseProgress
    }

    // Selection states
    @State private var selectedFacial: Int? = nil
    @State private var selectedArm: Int? = nil
    @State private var selectedLeg: Int? = nil
    @State private var selectedGaze: Int? = nil
    @State private var selectedHemiSide: String? = nil
    @State private var selectedAgnosia: Int? = nil
    @State private var selectedAphasia: Int? = nil

    // Assessment options
    private let facialOptions = [
        (score: 0, text: "Normal to Mild"),
        (score: 1, text: "Mild"),
        (score: 2, text: "Moderate to Severe")
    ]

    private let armOptions = [
        (score: 0, text: "Normal to Mild"),
        (score: 1, text: "Mild"),
        (score: 2, text: "Moderate to Severe")
    ]

    private let legOptions = [
        (score: 0, text: "Normal to Mild"),
        (score: 1, text: "Mild"),
        (score: 2, text: "Moderate to Severe")
    ]

    private let gazeOptions = [
        (score: 0, text: "Absent"),
        (score: 1, text: "Present")
    ]

    private let agnosiaOptions = [
        (score: 0, text: "Pt. recognizes their arm & the impairment"),
        (score: 1, text: "Pt. recognizes either arm or impairment"),
        (score: 2, text: "Doesn't recognize arm or impairment")
    ]

    private let aphasiaOptions = [
        (score: 0, text: "Performs both tasks correctly"),
        (score: 1, text: "Performs one task correctly"),
        (score: 2, text: "Performs neither task")
    ]

    private var totalScore: Int {
        var score = (selectedFacial ?? 0) + (selectedArm ?? 0) + (selectedLeg ?? 0) + (selectedGaze ?? 0)
        if selectedHemiSide == "Left" {
            score += (selectedAgnosia ?? 0)
        } else if selectedHemiSide == "Right" {
            score += (selectedAphasia ?? 0)
        }
        return score
    }

    private var raceInterpretation: (text: String, color: Color) {
        if totalScore == 0 {
            return ("Select options to calculate", CriticalDesign.Colors.secondary)
        } else if totalScore >= 5 {
            return ("High likelihood of LVO", CriticalDesign.Colors.accentRed)
        } else {
            return ("Calculate for LVO probability", CriticalDesign.Colors.accentBlue)
        }
    }

    private var sensitivitySpecificity: (sensitivity: String, specificity: String) {
        switch totalScore {
        case 1: return ("100%", "13%")
        case 2: return ("97%", "27%")
        case 3: return ("93%", "40%")
        case 4: return ("89%", "55%")
        case 5: return ("85%", "68%")
        case 6: return ("72%", "77%")
        case 7: return ("53%", "89%")
        case 8: return ("32%", "95%")
        case 9: return ("7%", "99%")
        default: return ("--", "--")
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            CriticalDesign.Colors.canvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header with scroll collapse animation
                    headerSection
                        .opacity(headerVisibility)
                        .scaleEffect(1 - (collapseProgress * 0.1), anchor: .top)
                        .offset(y: -collapseProgress * 20)
                        .animation(.easeOut(duration: 0.15), value: collapseProgress)

                    // Score card
                    scoreDisplayCard

                    introCard
                    facialCard
                    armCard
                    legCard
                    gazeAndHemiCard
                    if selectedHemiSide != nil {
                        hemiAssessmentCard
                    }
                    resultCard
                    resetButton

                    Spacer(minLength: CriticalDesign.Spacing.xl)
                }
                .padding(.vertical, CriticalDesign.Spacing.lg)
                // Scroll tracking overlay
                .overlay(
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
                )
            }

            // Floating Glass Score - only appears when score exists and scrolled past threshold
            if showFloatingScore {
                floatingGlassScore
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity).combined(with: .move(edge: .top)),
                        removal: .scale(scale: 0.9).combined(with: .opacity)
                    ))
                    .zIndex(100)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
        .onChange(of: totalScore) { newValue in
            // Haptic feedback when score changes
            if newValue != previousScore && newValue > 0 {
                let haptic = UIImpactFeedbackGenerator(style: .medium)
                haptic.impactOccurred()
            }
            previousScore = newValue
            updateFloatingVisibility()
        }
        .onChange(of: scrollOffset) { _ in
            updateFloatingVisibility()
        }
    }

    private func updateFloatingVisibility() {
        let shouldShow = totalScore > 0 && scrollOffset > scoreCardScrollThreshold
        if shouldShow != showFloatingScore {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                showFloatingScore = shouldShow
            }
        }
    }

    // MARK: - Floating Glass Score (Compact, Left-aligned)
    private var floatingGlassScore: some View {
        HStack(alignment: .center, spacing: CriticalDesign.Spacing.sm) {
            // Score circle - smaller
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [raceInterpretation.color, raceInterpretation.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                    .shadow(color: raceInterpretation.color.opacity(0.3), radius: 4, x: 0, y: 2)

                Text("\(totalScore)")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }

            // Interpretation + LVO badge stacked
            VStack(alignment: .leading, spacing: 3) {
                Text(raceInterpretation.text)
                    .font(.custom("Poppins-SemiBold", size: 12))
                    .foregroundColor(raceInterpretation.color)
                    .lineLimit(1)

                // LVO indicator - compact
                if totalScore >= 5 {
                    HStack(spacing: 3) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 9))
                        Text("LVO Likely")
                            .font(.custom("Poppins-Bold", size: 9))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(CriticalDesign.Colors.accentRed)
                    )
                } else {
                    // Show sensitivity when not LVO threshold
                    Text("Sens: \(sensitivitySpecificity.sensitivity)")
                        .font(.custom("Poppins-Medium", size: 9))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            // Glass effect
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        )
        .padding(.leading, CriticalDesign.Spacing.lg)
        .padding(.trailing, 140) // Narrower box
        .padding(.top, 6)
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            GradientEdgeFadeImage(imageName: "icon-neuro", size: 120)

            Text("RACE Stroke Scale")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("Rapid Arterial Occlusion Evaluation")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    // MARK: - Score Display Card
    private var scoreDisplayCard: some View {
        HStack(spacing: CriticalDesign.Spacing.lg) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [totalScore >= 5 ? CriticalDesign.Colors.accentRed : CriticalDesign.Colors.accentBlue,
                                    (totalScore >= 5 ? CriticalDesign.Colors.accentRed : CriticalDesign.Colors.accentBlue).opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: (totalScore >= 5 ? CriticalDesign.Colors.accentRed : CriticalDesign.Colors.accentBlue).opacity(0.4), radius: 8, x: 0, y: 4)

                Text("\(totalScore)")
                    .font(.custom("Poppins-Bold", size: 36))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Total RACE Score")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                if totalScore >= 5 {
                    Text("High likelihood of LVO")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                } else if totalScore > 0 {
                    Text("Calculate for LVO probability")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                } else {
                    Text("Select options to calculate")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
            }

            Spacer()
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Intro Card
    private var introCard: some View {
        Text(CriticalDesign.markdownToAttributedString("""
        The **RACE scale** identifies patients with acute stroke caused by **large vessel occlusion (LVO)** who may benefit from endovascular therapy.

        A score of **≥5** suggests high probability of LVO and should trigger consideration for transfer to a thrombectomy-capable center.
        """))
            .font(.custom("Poppins-Regular", size: 14))
            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            .lineSpacing(5)
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)
            .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Facial Card
    private var facialCard: some View {
        RACENeumorphicCard(
            title: "Facial Palsy",
            selectedScore: selectedFacial,
            options: facialOptions,
            accentColor: CriticalDesign.Colors.accentRed,
            onSelect: { score in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedFacial = selectedFacial == score ? nil : score
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Arm Card
    private var armCard: some View {
        RACENeumorphicCard(
            title: "Arm Motor Impairment",
            selectedScore: selectedArm,
            options: armOptions,
            accentColor: CriticalDesign.Colors.accentGreen,
            onSelect: { score in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedArm = selectedArm == score ? nil : score
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Leg Card
    private var legCard: some View {
        RACENeumorphicCard(
            title: "Leg Motor Impairment",
            selectedScore: selectedLeg,
            options: legOptions,
            accentColor: CriticalDesign.Colors.accentBlue,
            onSelect: { score in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedLeg = selectedLeg == score ? nil : score
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Gaze and Hemi Selection Card
    private var gazeAndHemiCard: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            // Gaze Deviation
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text("Head & Gaze Deviation")
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                ForEach(gazeOptions, id: \.score) { option in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedGaze = selectedGaze == option.score ? nil : option.score
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text("\(option.score)")
                                .font(.custom("Poppins-Bold", size: 12))
                                .foregroundColor(selectedGaze == option.score ? .white : CriticalDesign.Colors.accentPurple)
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(selectedGaze == option.score ? CriticalDesign.Colors.accentPurple : CriticalDesign.Colors.accentPurple.opacity(0.12)))

                            Text(option.text)
                                .font(.custom("Poppins-Medium", size: 13))
                                .foregroundColor(selectedGaze == option.score ? CriticalDesign.Colors.primary : CriticalDesign.Colors.secondary)
                        }
                        .padding(CriticalDesign.Spacing.sm)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.sm)
                                .fill(selectedGaze == option.score ? CriticalDesign.Colors.accentPurple.opacity(0.08) : CriticalDesign.Colors.canvas.opacity(0.5))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(neumorphicCardBackground)
            .frame(maxWidth: .infinity)

            // Hemiparesis Side Selection
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text("Hemiparesis?")
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                ForEach(["Left", "Right"], id: \.self) { side in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedHemiSide = selectedHemiSide == side ? nil : side
                            selectedAgnosia = nil
                            selectedAphasia = nil
                        }
                    }) {
                        Text(side)
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(selectedHemiSide == side ? CriticalDesign.Colors.primary : CriticalDesign.Colors.secondary)
                            .padding(CriticalDesign.Spacing.md)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: CriticalDesign.Radius.sm)
                                    .fill(selectedHemiSide == side ? CriticalDesign.Colors.accentBlue.opacity(0.08) : CriticalDesign.Colors.canvas.opacity(0.5))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(neumorphicCardBackground)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Hemi Assessment Card
    private var hemiAssessmentCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            Text(selectedHemiSide == "Left" ? "Agnosia Assessment" : "Aphasia Assessment")
                .font(.custom("Poppins-Bold", size: 17))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text(selectedHemiSide == "Left" ?
                 "Ask: \"Whose arm is this?\" and \"Can you lift both hands and clap?\"" :
                 "Instruct: \"Close your eyes\" and \"Make a fist\"")
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(CriticalDesign.Colors.accentGreen)

            let options = selectedHemiSide == "Left" ? agnosiaOptions : aphasiaOptions
            let selected = selectedHemiSide == "Left" ? selectedAgnosia : selectedAphasia

            ForEach(options, id: \.score) { option in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if selectedHemiSide == "Left" {
                            selectedAgnosia = selectedAgnosia == option.score ? nil : option.score
                        } else {
                            selectedAphasia = selectedAphasia == option.score ? nil : option.score
                        }
                    }
                }) {
                    HStack(spacing: CriticalDesign.Spacing.md) {
                        Text("\(option.score)")
                            .font(.custom("Poppins-Bold", size: 13))
                            .foregroundColor(selected == option.score ? .white : CriticalDesign.Colors.accentOrange)
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(selected == option.score ? CriticalDesign.Colors.accentOrange : CriticalDesign.Colors.accentOrange.opacity(0.12)))

                        Text(option.text)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(selected == option.score ? CriticalDesign.Colors.primary : CriticalDesign.Colors.secondary)

                        Spacer()

                        if selected == option.score {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(CriticalDesign.Colors.accentOrange)
                        }
                    }
                    .padding(CriticalDesign.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                            .fill(selected == option.score ? CriticalDesign.Colors.accentOrange.opacity(0.08) : CriticalDesign.Colors.canvas.opacity(0.5))
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Result Card
    private var resultCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            Text("Results")
                .font(.custom("Poppins-Bold", size: 17))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            HStack(spacing: CriticalDesign.Spacing.lg) {
                VStack(spacing: 8) {
                    Text(sensitivitySpecificity.sensitivity)
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(CriticalDesign.Colors.accentRed)

                    Text("Sensitivity")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

                    Text("for LVO")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(CriticalDesign.Colors.muted)
                    .frame(width: 1, height: 60)

                VStack(spacing: 8) {
                    Text(sensitivitySpecificity.specificity)
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)

                    Text("Specificity")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

                    Text("for LVO")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Reset Button
    private var resetButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedFacial = nil
                selectedArm = nil
                selectedLeg = nil
                selectedGaze = nil
                selectedHemiSide = nil
                selectedAgnosia = nil
                selectedAphasia = nil
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 16, weight: .semibold))
                Text("Reset All")
                    .font(.custom("Poppins-SemiBold", size: 16))
            }
            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            .padding(.vertical, 14)
            .padding(.horizontal, 28)
            .background(neumorphicCardBackground)
        }
    }

    // MARK: - Neumorphic Card Background
    @ViewBuilder
    private var neumorphicCardBackground: some View {
        if colorScheme == .dark {
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.cardBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                )
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(Color.clear)
                    .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            }
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
            )
        }
    }
}

// MARK: - RACE Neumorphic Card Component
private struct RACENeumorphicCard: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let selectedScore: Int?
    let options: [(score: Int, text: String)]
    let accentColor: Color
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack {
                Text(title)
                    .font(.custom("Poppins-Bold", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()

                Text("\(selectedScore ?? 0)")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(accentColor.opacity(0.12)))
            }

            VStack(spacing: CriticalDesign.Spacing.sm) {
                ForEach(options, id: \.score) { option in
                    Button(action: { onSelect(option.score) }) {
                        HStack(spacing: CriticalDesign.Spacing.md) {
                            Text("\(option.score)")
                                .font(.custom("Poppins-Bold", size: 13))
                                .foregroundColor(selectedScore == option.score ? .white : accentColor)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(selectedScore == option.score ? accentColor : accentColor.opacity(0.12)))

                            Text(option.text)
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(selectedScore == option.score ? CriticalDesign.Colors.primary : CriticalDesign.Colors.secondary)

                            Spacer()

                            if selectedScore == option.score {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(accentColor)
                            }
                        }
                        .padding(CriticalDesign.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                                .fill(selectedScore == option.score ? accentColor.opacity(0.08) : CriticalDesign.Colors.canvas.opacity(0.5))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
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
                    ZStack {
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(Color.clear)
                            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                            .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.white.opacity(0.6), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    RaceStrokeDetailView()
}
