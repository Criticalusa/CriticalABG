//
//  FastEDStrokeScale.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 3/14/22.
//  Updated with CriticalDesign neumorphic styling
//

import SwiftUI

struct FastEDStrokeScale: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showFloatingScore = false
    @State private var scoreCardScrolledOut = false
    @State private var previousScore: Int = 0

    // Selection states
    @State private var selectedFacial: Int? = nil
    @State private var selectedArm: Int? = nil
    @State private var selectedSpeechExpressive: Int? = nil
    @State private var selectedSpeechReceptive: Int? = nil
    @State private var selectedEye: Int? = nil
    @State private var selectedNeglect: Int? = nil

    // Assessment options
    private let facialOptions = [
        (score: 0, text: "Both sides of the face move equally or not at all"),
        (score: 1, text: "One side of the face droops or is clearly asymmetric")
    ]

    private let armOptions = [
        (score: 0, text: "Both arms move equally or not at all"),
        (score: 1, text: "One arm drifts compared to the other"),
        (score: 2, text: "One or both arms fall rapidly or no movement")
    ]

    private let expressiveOptions = [
        (score: 0, text: "Names 2 to 3 items correctly"),
        (score: 1, text: "Names only 0-1 items correctly")
    ]

    private let receptiveOptions = [
        (score: 0, text: "Normal - patient can follow simple command"),
        (score: 1, text: "Unable to follow simple command")
    ]

    private let eyeOptions = [
        (score: 0, text: "No gaze palsy - eyes move normally"),
        (score: 1, text: "Partial gaze palsy"),
        (score: 2, text: "Forced eye deviation - gaze is fixed")
    ]

    private let neglectOptions = [
        (score: 0, text: "No neglect - recognizes arm on both sides"),
        (score: 1, text: "Extinction to bilateral simultaneous stimulation"),
        (score: 2, text: "Profound hemi-inattention or neglect")
    ]

    private var totalScore: Int {
        let facial = selectedFacial ?? 0
        let arm = selectedArm ?? 0
        let expressive = selectedSpeechExpressive ?? 0
        let receptive = selectedSpeechReceptive ?? 0
        let eye = selectedEye ?? 0
        let neglect = selectedNeglect ?? 0
        return facial + arm + expressive + receptive + eye + neglect
    }

    private var scoreInterpretation: (text: String, color: Color) {
        if totalScore == 0 {
            return ("Select options to calculate", CriticalDesign.Colors.tertiary)
        } else if totalScore >= 4 {
            return ("High likelihood of LVO - Consider thrombectomy-capable center", CriticalDesign.Colors.accentRed)
        } else if totalScore >= 2 {
            return ("Moderate concern for LVO", CriticalDesign.Colors.accentOrange)
        } else {
            return ("Lower likelihood of LVO", CriticalDesign.Colors.accentGreen)
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    headerSection

                    // Score card with scroll visibility tracking
                    scoreDisplayCard
                        .trackScrollVisibility(isHidden: $scoreCardScrolledOut)

                    introCard
                    facialCard
                    armCard
                    speechCard
                    eyeCard
                    neglectCard
                    resetButton

                    Spacer(minLength: CriticalDesign.Spacing.xl)
                }
                .padding(.vertical, CriticalDesign.Spacing.lg)
            }

            // Floating Glass Score
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
            if newValue != previousScore && newValue > 0 {
                let haptic = UIImpactFeedbackGenerator(style: .medium)
                haptic.impactOccurred()
            }
            previousScore = newValue
            updateFloatingVisibility()
        }
        .onChange(of: scoreCardScrolledOut) { _ in
            updateFloatingVisibility()
        }
        .onChange(of: hasAnySelection) { _ in
            updateFloatingVisibility()
        }
    }

    // Check if any selection has been made
    private var hasAnySelection: Bool {
        selectedFacial != nil || selectedArm != nil ||
        selectedSpeechExpressive != nil || selectedSpeechReceptive != nil ||
        selectedEye != nil || selectedNeglect != nil
    }

    private func updateFloatingVisibility() {
        let shouldShow = hasAnySelection && scoreCardScrolledOut
        if shouldShow != showFloatingScore {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                showFloatingScore = shouldShow
            }
        }
    }

    // MARK: - Floating Glass Score
    private var floatingGlassScore: some View {
        HStack(alignment: .center, spacing: CriticalDesign.Spacing.md) {
            // Score circle with glow
            ZStack {
                Circle()
                    .fill(scoreInterpretation.color.opacity(0.2))
                    .frame(width: 46, height: 46)
                    .blur(radius: 4)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [scoreInterpretation.color, scoreInterpretation.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .shadow(color: scoreInterpretation.color.opacity(0.4), radius: 6, x: 0, y: 3)

                Text("\(totalScore)")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }

            // Score details
            VStack(alignment: .leading, spacing: 4) {
                Text("FAST-ED Score")
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

                Text(totalScore >= 4 ? "High LVO Risk" : totalScore >= 2 ? "Moderate Risk" : "Lower Risk")
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(scoreInterpretation.color)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 3)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
        .padding(.top, 8)
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            GradientEdgeFadeImage(imageName: "icon-neuro", size: 120)

            Text("FAST-ED Score")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text("Large Vessel Occlusion Detection")
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
                            colors: [scoreInterpretation.color, scoreInterpretation.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: scoreInterpretation.color.opacity(0.4), radius: 8, x: 0, y: 4)

                Text("\(totalScore)")
                    .font(.custom("Poppins-Bold", size: 36))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Total FAST-ED Score")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text(scoreInterpretation.text)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(scoreInterpretation.color)
                    .lineSpacing(2)
            }

            Spacer()
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Intro Card
    private var introCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            fastEDIntroParagraph1
            fastEDIntroParagraph2
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Facial Card
    private var facialCard: some View {
        FASTEDNeumorphicCard(
            title: "Facial Palsy",
            subtitle: "Ask patient to smile",
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
        FASTEDNeumorphicCard(
            title: "Arm Weakness",
            subtitle: "Arms extended, palms up, eyes closed for 10 seconds",
            selectedScore: selectedArm,
            options: armOptions,
            accentColor: CriticalDesign.Colors.accentTeal,
            onSelect: { score in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedArm = selectedArm == score ? nil : score
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Speech Card
    private var speechCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack {
                Text("Speech Changes")
                    .font(.custom("Poppins-Bold", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()

                Text("\((selectedSpeechExpressive ?? 0) + (selectedSpeechReceptive ?? 0))")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(CriticalDesign.Colors.accentOrange.opacity(0.12)))
            }

            // Expressive Aphasia
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                Text("Expressive Aphasia")
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("Ask patient to repeat: \"The sky is blue in Michigan\"")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Colors.accentGreen)

                ForEach(expressiveOptions, id: \.score) { option in
                    FASTEDNeumorphicOptionRow(
                        score: option.score,
                        text: option.text,
                        isSelected: selectedSpeechExpressive == option.score,
                        accentColor: CriticalDesign.Colors.accentOrange,
                        onTap: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedSpeechExpressive = selectedSpeechExpressive == option.score ? nil : option.score
                            }
                        }
                    )
                }
            }

            Divider()
                .background(CriticalDesign.Colors.muted)

            // Receptive Aphasia
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                Text("Receptive Aphasia")
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("Ask patient to follow command: \"Show me two fingers\"")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Colors.accentGreen)

                ForEach(receptiveOptions, id: \.score) { option in
                    FASTEDNeumorphicOptionRow(
                        score: option.score,
                        text: option.text,
                        isSelected: selectedSpeechReceptive == option.score,
                        accentColor: CriticalDesign.Colors.accentOrange,
                        onTap: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedSpeechReceptive = selectedSpeechReceptive == option.score ? nil : option.score
                            }
                        }
                    )
                }
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Eye Card
    private var eyeCard: some View {
        FASTEDNeumorphicCard(
            title: "Eye Deviation",
            subtitle: "Assess gaze and eye movements",
            selectedScore: selectedEye,
            options: eyeOptions,
            accentColor: CriticalDesign.Colors.accentPurple,
            onSelect: { score in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedEye = selectedEye == score ? nil : score
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Neglect Card
    private var neglectCard: some View {
        FASTEDNeumorphicCard(
            title: "Denial/Neglect",
            subtitle: "Assess for hemispatial neglect",
            selectedScore: selectedNeglect,
            options: neglectOptions,
            accentColor: CriticalDesign.Colors.accentBlue,
            onSelect: { score in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedNeglect = selectedNeglect == score ? nil : score
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Reset Button
    private var resetButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedFacial = nil
                selectedArm = nil
                selectedSpeechExpressive = nil
                selectedSpeechReceptive = nil
                selectedEye = nil
                selectedNeglect = nil
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

    // MARK: - Intro Paragraph Helpers
    private var fastEDIntroParagraph1: some View {
        HStack(alignment: .top, spacing: 0) {
            Group {
                Text("FAST-ED")
                    .font(.custom("Poppins-SemiBold", size: 14))
                + Text(" extends the classic FAST assessment with ")
                    .font(.custom("Poppins-Regular", size: 14))
                + Text("Eye deviation")
                    .font(.custom("Poppins-SemiBold", size: 14))
                + Text(" and ")
                    .font(.custom("Poppins-Regular", size: 14))
                + Text("Denial/Neglect")
                    .font(.custom("Poppins-SemiBold", size: 14))
                + Text(" to better identify large vessel occlusions.")
                    .font(.custom("Poppins-Regular", size: 14))
            }
            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            .lineSpacing(6)
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var fastEDIntroParagraph2: some View {
        HStack(alignment: .top, spacing: 0) {
            Group {
                Text("A score ")
                    .font(.custom("Poppins-Regular", size: 14))
                + Text("\u{2265}4")
                    .font(.custom("Poppins-SemiBold", size: 14))
                + Text(" has high sensitivity for LVO and may benefit from direct transport to a thrombectomy-capable stroke center.")
                    .font(.custom("Poppins-Regular", size: 14))
            }
            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            .lineSpacing(6)
            .fixedSize(horizontal: false, vertical: true)
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

// MARK: - FAST-ED Neumorphic Card Component
private struct FASTEDNeumorphicCard: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let subtitle: String
    let selectedScore: Int?
    let options: [(score: Int, text: String)]
    let accentColor: Color
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Poppins-Bold", size: 17))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Text(subtitle)
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                }

                Spacer()

                Text("\(selectedScore ?? 0)")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(accentColor.opacity(0.12)))
            }

            VStack(spacing: CriticalDesign.Spacing.sm) {
                ForEach(options, id: \.score) { option in
                    FASTEDNeumorphicOptionRow(
                        score: option.score,
                        text: option.text,
                        isSelected: selectedScore == option.score,
                        accentColor: accentColor,
                        onTap: { onSelect(option.score) }
                    )
                }
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            Group {
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
        )
    }
}

// MARK: - FAST-ED Neumorphic Option Row Component
private struct FASTEDNeumorphicOptionRow: View {
    @Environment(\.colorScheme) var colorScheme
    let score: Int
    let text: String
    let isSelected: Bool
    let accentColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: CriticalDesign.Spacing.md) {
                Text("\(score)")
                    .font(.custom("Poppins-Bold", size: 13))
                    .foregroundColor(isSelected ? .white : accentColor)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle().fill(isSelected ? accentColor : accentColor.opacity(0.12))
                    )

                Text(text)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(isSelected ? CriticalDesign.Colors.primary : CriticalDesign.Colors.secondary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(accentColor)
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(isSelected ? accentColor.opacity(0.08) : CriticalDesign.Colors.canvas.opacity(0.5))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    FastEDStrokeScale()
}
