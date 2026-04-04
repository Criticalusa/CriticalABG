//
//  CincinnatiStrokeView.swift
//  CriticalX
//
//  Created by Macbook 7 on 28/12/2021.
//  Updated with CriticalDesign neumorphic styling + floating glass score
//

import SwiftUI

struct CincinnatiStrokeView: View {
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
    
    // Selection states for each test (nil = not selected, false = normal, true = abnormal)
    @State private var facialResult: Bool? = nil
    @State private var armResult: Bool? = nil
    @State private var speechResult: Bool? = nil

    // Cincinnati stroke assessment data
    private let strokeTests: [CincinnatiTest] = [
        CincinnatiTest(
            title: "Facial Droop",
            instruction: "Ask the patient to smile and show their teeth.",
            normal: "Both sides of the face move equally.",
            abnormal: "One side of the face doesn't move at all.",
            color: CriticalDesign.Colors.accentRed
        ),
        CincinnatiTest(
            title: "Arm Drift",
            instruction: "Ask the patient to close their eyes and extend both arms straight out for 10 seconds.",
            normal: "Both arms move equally or not at all.",
            abnormal: "One arm either doesn't move, or one arm drifts down compared to the other arm.",
            color: CriticalDesign.Colors.accentGreen
        ),
        CincinnatiTest(
            title: "Speech",
            instruction: "Ask the patient to repeat \"The sky is blue in Cincinnati.\"",
            normal: "The patient repeats the sentence correctly with no slurring of the words.",
            abnormal: "The patient slurs words, is unable to speak, or says the wrong words.",
            color: CriticalDesign.Colors.accentOrange
        )
    ]
    
    // Computed score - count of abnormal findings
    private var abnormalCount: Int {
        var count = 0
        if facialResult == true { count += 1 }
        if armResult == true { count += 1 }
        if speechResult == true { count += 1 }
        return count
    }
    
    // Check if any selection has been made
    private var hasAnySelection: Bool {
        facialResult != nil || armResult != nil || speechResult != nil
    }
    
    // Score interpretation
    private var scoreInterpretation: (text: String, color: Color) {
        switch abnormalCount {
        case 0:
            if hasAnySelection {
                return ("No abnormal findings", CriticalDesign.Colors.accentGreen)
            } else {
                return ("Select findings to assess", CriticalDesign.Colors.secondary)
            }
        case 1:
            return ("1 abnormal - 72% predictive of stroke", CriticalDesign.Colors.accentOrange)
        case 2:
            return ("2 abnormal - High stroke probability", CriticalDesign.Colors.accentRed)
        case 3:
            return ("3 abnormal - Very high stroke probability", CriticalDesign.Colors.accentRed)
        default:
            return ("Select findings", CriticalDesign.Colors.secondary)
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header with scroll collapse animation
                    headerSection
                        .opacity(headerVisibility)
                        .scaleEffect(1 - (collapseProgress * 0.1), anchor: .top)
                        .offset(y: -collapseProgress * 20)
                        .animation(.easeOut(duration: 0.15), value: collapseProgress)
                    
                    // Score display card
                    scoreDisplayCard
                    
                    interpretationCard

                    // Interactive test cards
                    CincinnatiInteractiveTestCard(
                        test: strokeTests[0],
                        testNumber: 1,
                        selectedResult: $facialResult
                    )
                    
                    CincinnatiInteractiveTestCard(
                        test: strokeTests[1],
                        testNumber: 2,
                        selectedResult: $armResult
                    )
                    
                    CincinnatiInteractiveTestCard(
                        test: strokeTests[2],
                        testNumber: 3,
                        selectedResult: $speechResult
                    )
                    
                    // Reset button
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
        .onChange(of: abnormalCount) { newValue in
            if newValue != previousScore && hasAnySelection {
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
        let shouldShow = hasAnySelection && scrollOffset > scoreCardScrollThreshold
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
                
                Text("\(abnormalCount)")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }
            
            // Score details
            VStack(alignment: .leading, spacing: 4) {
                Text("Cincinnati Stroke")
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                
                Text("\(abnormalCount) of 3 Abnormal")
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(scoreInterpretation.color)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Quick status chips
            HStack(spacing: 4) {
                StatusChip(label: "F", isAbnormal: facialResult, color: CriticalDesign.Colors.accentRed)
                StatusChip(label: "A", isAbnormal: armResult, color: CriticalDesign.Colors.accentGreen)
                StatusChip(label: "S", isAbnormal: speechResult, color: CriticalDesign.Colors.accentOrange)
            }
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

            Text("Cincinnati Stroke Scale")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text("Prehospital Stroke Assessment")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }
    
    // MARK: - Score Display Card
    private var scoreDisplayCard: some View {
        HStack(spacing: CriticalDesign.Spacing.lg) {
            // Score circle
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
                
                VStack(spacing: 0) {
                    Text("\(abnormalCount)")
                        .font(.custom("Poppins-Bold", size: 36))
                        .foregroundColor(.white)
                    Text("/ 3")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Abnormal Findings")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text(scoreInterpretation.text)
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(scoreInterpretation.color)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(
                        LinearGradient(
                            colors: colorScheme == .dark
                                ? [CriticalDesign.Colors.cardBlue, CriticalDesign.Colors.cardBlue.opacity(0.9)]
                                : [Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                if colorScheme == .light {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(Color.clear)
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.gold.opacity(0.3)
                        : Color.white.opacity(0.6),
                    lineWidth: 1
                )
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Interpretation Card
    private var interpretationCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("Interpretation")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            cincinnatiInterpretationParagraph1
            cincinnatiInterpretationParagraph2
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(
                        LinearGradient(
                            colors: colorScheme == .dark
                                ? [CriticalDesign.Colors.cardBlue, CriticalDesign.Colors.cardBlue.opacity(0.9)]
                                : [Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                if colorScheme == .light {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(Color.clear)
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.gold.opacity(0.3)
                        : Color.white.opacity(0.6),
                    lineWidth: 1
                )
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    // MARK: - Interpretation Paragraph Helpers
    private var cincinnatiInterpretationParagraph1: some View {
        HStack(alignment: .top, spacing: 0) {
            Group {
                Text("One abnormal finding is 72% predictive of a stroke.")
                    .font(.custom("Poppins-SemiBold", size: 14))
                + Text(" Any abnormal finding should prompt immediate stroke protocol activation.")
                    .font(.custom("Poppins-Regular", size: 14))
            }
            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            .lineSpacing(6)
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var cincinnatiInterpretationParagraph2: some View {
        Text("The Cincinnati Prehospital Stroke Scale is a rapid, simple assessment tool designed for EMS providers to identify stroke patients in the field.")
            .font(.custom("Poppins-Regular", size: 14))
            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            .lineSpacing(6)
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Reset Button
    private var resetButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                facialResult = nil
                armResult = nil
                speechResult = nil
            }
            let haptic = UIImpactFeedbackGenerator(style: .light)
            haptic.impactOccurred()
        }) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 16, weight: .semibold))
                Text("Reset All")
                    .font(.custom("Poppins-SemiBold", size: 16))
            }
            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .fill(
                            colorScheme == .dark
                                ? CriticalDesign.Colors.cardBlue
                                : Color.white.opacity(0.9)
                        )
                    
                    if colorScheme == .light {
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                            .fill(Color.clear)
                            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 3, y: 3)
                            .shadow(color: Color.white, radius: 6, x: -3, y: -3)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .stroke(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.gold.opacity(0.3)
                            : Color.white.opacity(0.6),
                        lineWidth: 1
                    )
            )
        }
    }
}

// MARK: - Status Chip for Floating Score
private struct StatusChip: View {
    let label: String
    let isAbnormal: Bool?
    let color: Color
    
    var body: some View {
        Text(label)
            .font(.custom("Poppins-Bold", size: 10))
            .foregroundColor(chipForeground)
            .frame(width: 22, height: 22)
            .background(
                Circle()
                    .fill(chipBackground)
            )
    }
    
    private var chipBackground: Color {
        guard let isAbnormal = isAbnormal else {
            return Color.gray.opacity(0.2)
        }
        return isAbnormal ? color : CriticalDesign.Colors.accentGreen.opacity(0.2)
    }
    
    private var chipForeground: Color {
        guard let isAbnormal = isAbnormal else {
            return Color.gray
        }
        return isAbnormal ? .white : CriticalDesign.Colors.accentGreen
    }
}

// MARK: - Cincinnati Test Model
private struct CincinnatiTest {
    let title: String
    let instruction: String
    let normal: String
    let abnormal: String
    let color: Color
}

// MARK: - Cincinnati Interactive Test Card Component
private struct CincinnatiInteractiveTestCard: View {
    @Environment(\.colorScheme) var colorScheme
    let test: CincinnatiTest
    let testNumber: Int
    @Binding var selectedResult: Bool?

    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            // Header
            HStack(spacing: CriticalDesign.Spacing.md) {
                Text("\(testNumber)")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(test.color))

                Text(test.title)
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()
            }

            // Instruction
            Text(test.instruction)
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(CriticalDesign.Colors.accentBlue)
                .lineSpacing(3)

            // Normal response - tappable
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedResult = selectedResult == false ? nil : false
                }
                let haptic = UIImpactFeedbackGenerator(style: .light)
                haptic.impactOccurred()
            }) {
                HStack(alignment: .top, spacing: CriticalDesign.Spacing.md) {
                    Image(systemName: selectedResult == false ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Normal")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(CriticalDesign.Colors.accentGreen)

                        Text(test.normal)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            .lineSpacing(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedResult == false ? CriticalDesign.Colors.accentGreen.opacity(0.1) : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedResult == false ? CriticalDesign.Colors.accentGreen.opacity(0.5) : Color.clear, lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())

            // Abnormal response - tappable
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedResult = selectedResult == true ? nil : true
                }
                let haptic = UIImpactFeedbackGenerator(style: .light)
                haptic.impactOccurred()
            }) {
                HStack(alignment: .top, spacing: CriticalDesign.Spacing.md) {
                    Image(systemName: selectedResult == true ? "xmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .foregroundColor(CriticalDesign.Colors.accentRed)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Abnormal")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(CriticalDesign.Colors.accentRed)

                        Text(test.abnormal)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            .lineSpacing(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedResult == true ? CriticalDesign.Colors.accentRed.opacity(0.1) : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedResult == true ? CriticalDesign.Colors.accentRed.opacity(0.5) : Color.clear, lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(
                        LinearGradient(
                            colors: colorScheme == .dark
                                ? [CriticalDesign.Colors.cardBlue, CriticalDesign.Colors.cardBlue.opacity(0.9)]
                                : [Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                if colorScheme == .light {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(Color.clear)
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.gold.opacity(0.3)
                        : Color.white.opacity(0.6),
                    lineWidth: 1
                )
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
}

// MARK: - Preview
#Preview {
    CincinnatiStrokeView()
}
