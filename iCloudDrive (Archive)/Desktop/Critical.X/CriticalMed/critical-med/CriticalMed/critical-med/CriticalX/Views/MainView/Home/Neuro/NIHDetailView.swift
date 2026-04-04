//
//  NIHDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 29/12/2021.
//  Updated with CriticalDesign neumorphic styling
//

import SwiftUI

struct NIHDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showFloatingScore = false
    @State private var scoreCardScrolledOut = false
    @State private var previousScore: Int = 0

    // MARK: - Scroll Animation State
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollY: CGFloat? = nil

    private let animationStartOffset: CGFloat = 40
    private let animationEndOffset: CGFloat = 140

    private var collapseProgress: CGFloat {
        guard scrollOffset > animationStartOffset else { return 0 }
        guard scrollOffset < animationEndOffset else { return 1 }
        return (scrollOffset - animationStartOffset) / (animationEndOffset - animationStartOffset)
    }

    private var headerVisibility: CGFloat {
        1 - collapseProgress
    }

    // Selection states for all 11 categories
    @State private var selectedLOC: Int? = nil
    @State private var selectedLOCQuestions: Int? = nil
    @State private var selectedLOCCommands: Int? = nil
    @State private var selectedGaze: Int? = nil
    @State private var selectedVisual: Int? = nil
    @State private var selectedFacial: Int? = nil
    @State private var selectedMotorLeft: Int? = nil
    @State private var selectedMotorRight: Int? = nil
    @State private var selectedAtaxia: Int? = nil
    @State private var selectedSensory: Int? = nil
    @State private var selectedLanguage: Int? = nil
    @State private var selectedDysarthria: Int? = nil
    @State private var selectedNeglect: Int? = nil

    private var totalScore: Int {
        let scores = [selectedLOC, selectedLOCQuestions, selectedLOCCommands,
                     selectedGaze, selectedVisual, selectedFacial,
                     selectedMotorLeft, selectedMotorRight, selectedAtaxia,
                     selectedSensory, selectedLanguage, selectedDysarthria, selectedNeglect]
        return scores.compactMap { $0 }.reduce(0, +)
    }

    private var scoreInterpretation: (text: String, color: Color) {
        if totalScore == 0 {
            return ("No Stroke Symptoms", CriticalDesign.Colors.accentGreen)
        } else if totalScore <= 4 {
            return ("Minor Stroke", CriticalDesign.Colors.accentGreen)
        } else if totalScore <= 15 {
            return ("Moderate Stroke", CriticalDesign.Colors.accentOrange)
        } else if totalScore <= 20 {
            return ("Moderate to Severe Stroke", CriticalDesign.Colors.accentOrange)
        } else {
            return ("Severe Stroke", CriticalDesign.Colors.accentRed)
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

                    // Score card with scroll visibility tracking
                    scoreDisplayCard
                        .trackScrollVisibility(isHidden: $scoreCardScrolledOut)

                    introCard

                    // All 13 NIHSS Categories
                    locCard
                    locQuestionsCard
                    locCommandsCard
                    gazeCard
                    visualCard
                    facialCard
                    motorLeftCard
                    motorRightCard
                    ataxiaCard
                    sensoryCard
                    languageCard
                    dysarthriaCard
                    neglectCard

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
    }

    private func updateFloatingVisibility() {
        let shouldShow = totalScore > 0 && scoreCardScrolledOut
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
                Text("NIHSS Score")
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

                Text(scoreInterpretation.text)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(scoreInterpretation.color)
                    .lineLimit(1)
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
        .padding(.horizontal, CriticalDesign.Spacing.lg)
        .padding(.top, 8)
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            GradientEdgeFadeImage(imageName: "icon-neuro", size: 120)

            Text("NIH Stroke Scale")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("National Institutes of Health")
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
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Total NIHSS Score")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text(scoreInterpretation.text)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(scoreInterpretation.color)

                Text("Max Score: 42")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }

            Spacer()
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
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Intro Card
    private var introCard: some View {
        Text(CriticalDesign.markdownToAttributedString("""
        The **NIHSS** quantifies stroke severity by assessing level of consciousness, eye movements, visual fields, facial palsy, motor strength, ataxia, sensory function, language, dysarthria, and neglect.

        A higher score indicates **more severe impairment**. Use this scale to track changes over time and guide treatment decisions.
        """))
            .font(.custom("Poppins-Regular", size: 14))
            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            .lineSpacing(5)
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
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
            .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 1a. LOC Card
    private var locCard: some View {
        NIHSSNeumorphicCard(
            number: "1a",
            title: "Level of Consciousness",
            selectedScore: selectedLOC,
            options: [
                (0, "Alert; keenly responsive"),
                (1, "Not alert; but arousable by minor stimulation"),
                (2, "Not alert; requires repeated stimulation"),
                (3, "Responds only with reflex motor or autonomic effects")
            ],
            accentColor: CriticalDesign.Colors.accentRed,
            onSelect: { selectedLOC = selectedLOC == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 1b. LOC Questions Card
    private var locQuestionsCard: some View {
        NIHSSNeumorphicCard(
            number: "1b",
            title: "LOC Questions",
            subtitle: "Ask patient the month and their age",
            selectedScore: selectedLOCQuestions,
            options: [
                (0, "Answers both questions correctly"),
                (1, "Answers one question correctly"),
                (2, "Answers neither question correctly")
            ],
            accentColor: CriticalDesign.Colors.accentOrange,
            onSelect: { selectedLOCQuestions = selectedLOCQuestions == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 1c. LOC Commands Card
    private var locCommandsCard: some View {
        NIHSSNeumorphicCard(
            number: "1c",
            title: "LOC Commands",
            subtitle: "Ask patient to open/close eyes and grip/release hand",
            selectedScore: selectedLOCCommands,
            options: [
                (0, "Performs both tasks correctly"),
                (1, "Performs one task correctly"),
                (2, "Performs neither task correctly")
            ],
            accentColor: CriticalDesign.Colors.accentGreen,
            onSelect: { selectedLOCCommands = selectedLOCCommands == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 2. Best Gaze Card
    private var gazeCard: some View {
        NIHSSNeumorphicCard(
            number: "2",
            title: "Best Gaze",
            subtitle: "Horizontal eye movements only",
            selectedScore: selectedGaze,
            options: [
                (0, "Normal"),
                (1, "Partial gaze palsy"),
                (2, "Forced deviation or total gaze paresis")
            ],
            accentColor: CriticalDesign.Colors.accentBlue,
            onSelect: { selectedGaze = selectedGaze == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 3. Visual Card
    private var visualCard: some View {
        NIHSSNeumorphicCard(
            number: "3",
            title: "Visual Fields",
            subtitle: "Test by confrontation",
            selectedScore: selectedVisual,
            options: [
                (0, "No visual loss"),
                (1, "Partial hemianopia"),
                (2, "Complete hemianopia"),
                (3, "Bilateral hemianopia (blind)")
            ],
            accentColor: CriticalDesign.Colors.accentPurple,
            onSelect: { selectedVisual = selectedVisual == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 4. Facial Palsy Card
    private var facialCard: some View {
        NIHSSNeumorphicCard(
            number: "4",
            title: "Facial Palsy",
            subtitle: "Ask patient to show teeth or smile",
            selectedScore: selectedFacial,
            options: [
                (0, "Normal symmetrical movements"),
                (1, "Minor paralysis (flattened nasolabial fold)"),
                (2, "Partial paralysis (lower face)"),
                (3, "Complete paralysis (one or both sides)")
            ],
            accentColor: CriticalDesign.Colors.accentTeal,
            onSelect: { selectedFacial = selectedFacial == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 5a. Motor Left Arm Card
    private var motorLeftCard: some View {
        NIHSSNeumorphicCard(
            number: "5a",
            title: "Motor Arm - Left",
            subtitle: "Arm extended 90° (sitting) or 45° (supine) for 10 sec",
            selectedScore: selectedMotorLeft,
            options: [
                (0, "No drift; holds arm for full 10 seconds"),
                (1, "Drift; holds arm but drifts before 10 seconds"),
                (2, "Some effort against gravity"),
                (3, "No effort against gravity; limb falls"),
                (4, "No movement")
            ],
            accentColor: CriticalDesign.Colors.accentRed,
            onSelect: { selectedMotorLeft = selectedMotorLeft == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 5b. Motor Right Arm Card
    private var motorRightCard: some View {
        NIHSSNeumorphicCard(
            number: "5b",
            title: "Motor Arm - Right",
            subtitle: "Arm extended 90° (sitting) or 45° (supine) for 10 sec",
            selectedScore: selectedMotorRight,
            options: [
                (0, "No drift; holds arm for full 10 seconds"),
                (1, "Drift; holds arm but drifts before 10 seconds"),
                (2, "Some effort against gravity"),
                (3, "No effort against gravity; limb falls"),
                (4, "No movement")
            ],
            accentColor: CriticalDesign.Colors.accentOrange,
            onSelect: { selectedMotorRight = selectedMotorRight == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 7. Limb Ataxia Card
    private var ataxiaCard: some View {
        NIHSSNeumorphicCard(
            number: "7",
            title: "Limb Ataxia",
            subtitle: "Finger-nose-finger and heel-shin tests",
            selectedScore: selectedAtaxia,
            options: [
                (0, "Absent"),
                (1, "Present in one limb"),
                (2, "Present in two limbs")
            ],
            accentColor: CriticalDesign.Colors.accentGreen,
            onSelect: { selectedAtaxia = selectedAtaxia == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 8. Sensory Card
    private var sensoryCard: some View {
        NIHSSNeumorphicCard(
            number: "8",
            title: "Sensory",
            subtitle: "Test sensation with pinprick",
            selectedScore: selectedSensory,
            options: [
                (0, "Normal; no sensory loss"),
                (1, "Mild-moderate sensory loss"),
                (2, "Severe or total sensory loss")
            ],
            accentColor: CriticalDesign.Colors.accentBlue,
            onSelect: { selectedSensory = selectedSensory == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 9. Best Language Card
    private var languageCard: some View {
        NIHSSNeumorphicCard(
            number: "9",
            title: "Best Language",
            subtitle: "Have patient describe picture, name items, read sentences",
            selectedScore: selectedLanguage,
            options: [
                (0, "No aphasia; normal"),
                (1, "Mild-moderate aphasia"),
                (2, "Severe aphasia"),
                (3, "Mute; global aphasia; no usable speech")
            ],
            accentColor: CriticalDesign.Colors.accentPurple,
            onSelect: { selectedLanguage = selectedLanguage == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 10. Dysarthria Card
    private var dysarthriaCard: some View {
        NIHSSNeumorphicCard(
            number: "10",
            title: "Dysarthria",
            subtitle: "Have patient read or repeat words",
            selectedScore: selectedDysarthria,
            options: [
                (0, "Normal"),
                (1, "Mild-moderate; slurs some words"),
                (2, "Severe; nearly unintelligible or worse")
            ],
            accentColor: CriticalDesign.Colors.accentTeal,
            onSelect: { selectedDysarthria = selectedDysarthria == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - 11. Extinction/Inattention Card
    private var neglectCard: some View {
        NIHSSNeumorphicCard(
            number: "11",
            title: "Extinction / Inattention",
            subtitle: "Use double simultaneous stimulation",
            selectedScore: selectedNeglect,
            options: [
                (0, "No abnormality"),
                (1, "Visual, tactile, auditory, or spatial inattention"),
                (2, "Profound hemi-inattention or neglect")
            ],
            accentColor: CriticalDesign.Colors.accentRed,
            onSelect: { selectedNeglect = selectedNeglect == $0 ? nil : $0 }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Reset Button
    private var resetButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedLOC = nil
                selectedLOCQuestions = nil
                selectedLOCCommands = nil
                selectedGaze = nil
                selectedVisual = nil
                selectedFacial = nil
                selectedMotorLeft = nil
                selectedMotorRight = nil
                selectedAtaxia = nil
                selectedSensory = nil
                selectedLanguage = nil
                selectedDysarthria = nil
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
}

// MARK: - NIHSS Neumorphic Card Component
private struct NIHSSNeumorphicCard: View {
    @Environment(\.colorScheme) var colorScheme
    let number: String
    let title: String
    var subtitle: String? = nil
    let selectedScore: Int?
    let options: [(Int, String)]
    let accentColor: Color
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            // Header Row
            HStack {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Text(number)
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(accentColor))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.custom("Poppins-Bold", size: 17))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.custom("Poppins-Medium", size: 12))
                                .foregroundColor(CriticalDesign.Colors.accentGreen)
                        }
                    }
                }

                Spacer()

                Text("\(selectedScore ?? 0)")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(accentColor.opacity(0.12))
                    )
            }

            // Options
            VStack(spacing: CriticalDesign.Spacing.sm) {
                ForEach(options, id: \.0) { option in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            onSelect(option.0)
                        }
                    }) {
                        HStack(spacing: CriticalDesign.Spacing.md) {
                            Text("\(option.0)")
                                .font(.custom("Poppins-Bold", size: 13))
                                .foregroundColor(selectedScore == option.0 ? .white : accentColor)
                                .frame(width: 28, height: 28)
                                .background(
                                    Circle()
                                        .fill(selectedScore == option.0 ? accentColor : accentColor.opacity(0.12))
                                )

                            Text(option.1)
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(selectedScore == option.0 ? CriticalDesign.Colors.primary : CriticalDesign.Colors.secondary)
                                .multilineTextAlignment(.leading)

                            Spacer()

                            if selectedScore == option.0 {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(accentColor)
                            }
                        }
                        .padding(CriticalDesign.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                                .fill(selectedScore == option.0 ? accentColor.opacity(0.08) : CriticalDesign.Colors.canvas.opacity(0.5))
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
    NIHDetailView()
}
