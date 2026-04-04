//
//  GlascowComaScoreDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 28/12/2021.
//  Updated with CriticalDesign neumorphic styling + floating glass score
//  Updated with Clinical Teaching Content following Teaching Style Guide
//

import SwiftUI

struct GlascowComaScoreDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showFloatingScore = false
    @State private var previousScore: Int = 0
    @State private var isMentalModelExpanded = false
    
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

    // GCS Selection States
    @State private var selectedEye: Int? = nil
    @State private var selectedVerbal: Int? = nil
    @State private var selectedMotor: Int? = nil

    // GCS Options
    private let eyeOptions = [
        (score: 4, text: "Spontaneous"),
        (score: 3, text: "Opens Eyes to Voice"),
        (score: 2, text: "Opens Eyes to Pain"),
        (score: 1, text: "No Response")
    ]

    private let verbalOptions = [
        (score: 5, text: "Oriented"),
        (score: 4, text: "Confused"),
        (score: 3, text: "Inappropriate Words"),
        (score: 2, text: "Incomprehensible Sounds"),
        (score: 1, text: "No Response")
    ]

    private let motorOptions = [
        (score: 6, text: "Obeys Commands"),
        (score: 5, text: "Localizes Pain"),
        (score: 4, text: "Withdraws From Pain"),
        (score: 3, text: "Abnormal Flexion (Decorticate)"),
        (score: 2, text: "Abnormal Extension (Decerebrate)"),
        (score: 1, text: "No Response")
    ]

    private var totalGCS: Int {
        (selectedEye ?? 0) + (selectedVerbal ?? 0) + (selectedMotor ?? 0)
    }

    // Enhanced interpretation with action guidance
    private var gcsInterpretation: (text: String, action: String, color: Color) {
        if totalGCS == 0 {
            return ("Select options to calculate", "", CriticalDesign.Colors.secondary)
        } else if totalGCS >= 13 {
            return ("Minor Brain Injury", "Monitor for deterioration. Serial exams every 1-2 hours.", CriticalDesign.Colors.accentGreen)
        } else if totalGCS >= 9 {
            return ("Moderate Brain Injury", "Consider CT head. Close monitoring. Neurosurgery consult if declining.", CriticalDesign.Colors.accentOrange)
        } else {
            return ("Severe Brain Injury", "Airway protection likely needed. GCS ≤8 = intubate.", CriticalDesign.Colors.accentRed)
        }
    }
    
    // Gold color for signature card
    private let goldColor = Color(red: 0.79, green: 0.64, blue: 0.15)

    // Neumorphic card background with enhanced depth - adaptive for dark mode
    private var neumorphicCardBackground: some View {
        Group {
            if colorScheme == .dark {
                // Dark mode: CardBlue with gold stroke
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.cardBlue)
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                    )
            } else {
                // Light mode: Keep existing neumorphic styling
                ZStack {
                    // Base card fill
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(
                            LinearGradient(
                                colors: [Color.white, Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // Deep neumorphic shadows for more depth
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(Color.clear)
                        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
                        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 10, y: 10)
                        .shadow(color: Color.white, radius: 12, x: -6, y: -6)
                }
            }
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
                    
                    // Clinical Context Card - NEW
                    clinicalContextCard

                    // Score card
                    scoreDisplayCard
                    
                    // Mental Model Card - NEW
                    mentalModelCard

                    eyeOpeningCard
                    verbalResponseCard
                    motorResponseCard
                    resetButton
                    
                    // Clinical Takeaway Card - NEW
                    clinicalTakeawayCard

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

            // Floating Glass Score - only appears when score exists and card scrolled out
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
        .onChange(of: totalGCS) { newValue in
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

    // Threshold for when score card is considered "scrolled out"
    private let scoreCardScrollThreshold: CGFloat = 280
    
    private func updateFloatingVisibility() {
        // Show floating score when any selection is made AND scrolled past threshold
        let shouldShow = totalGCS > 0 && scrollOffset > scoreCardScrollThreshold
        if shouldShow != showFloatingScore {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                showFloatingScore = shouldShow
            }
        }
    }
    
    // MARK: - Clinical Context Card (Why This Matters)
    private var clinicalContextCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            // Header with accent line
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(CriticalDesign.Colors.cardBlue)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                }
                
                Text("Why This Matters")
                    .font(.custom("Poppins-SemiBold", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Spacer()
            }
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text("The Glasgow Coma Scale isn't about memorizing numbers—it's about communicating neurological status quickly and tracking changes over time.")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
                
                Text("A single GCS score tells you less than the trend.")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text("A patient at GCS 14 who was 15 an hour ago is more concerning than a patient who's been stable at 10 for days.")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
            }
            .padding(.leading, 60) // Align with header text
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.7))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 10)
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Mental Model Card (Collapsible)
    private var mentalModelCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header - Tappable to expand/collapse
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isMentalModelExpanded.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(CriticalDesign.Colors.accentTeal)
                        .frame(width: 4, height: 44)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(CriticalDesign.Colors.accentTeal.opacity(0.12))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(CriticalDesign.Colors.accentTeal)
                    }
                    
                    Text("The Mental Model")
                        .font(.custom("Poppins-SemiBold", size: 17))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Spacer()
                    
                    Image(systemName: isMentalModelExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
                .padding(CriticalDesign.Spacing.lg)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expandable Content
            if isMentalModelExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    // Three systems explanation
                    Text("Three questions, three systems:")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        MentalModelRow(label: "E", system: "Eyes", meaning: "Brainstem arousal", color: CriticalDesign.Colors.accentRed)
                        MentalModelRow(label: "V", system: "Verbal", meaning: "Cortical integration", color: CriticalDesign.Colors.accentTeal)
                        MentalModelRow(label: "M", system: "Motor", meaning: "Descending motor pathways", color: CriticalDesign.Colors.accentOrange)
                    }
                    
                    // Key insight
                    HStack(spacing: 10) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(goldColor)
                        
                        Text("Motor score is the most predictive of outcome. When in doubt, focus on the motor exam.")
                            .font(.custom("Poppins-Medium", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(goldColor.opacity(0.08))
                    )
                    
                    // The Rule
                    VStack(alignment: .leading, spacing: 8) {
                        Text("The Rule:")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(CriticalDesign.Colors.accentRed)
                        
                        HStack(spacing: 8) {
                            Text("GCS ≤8")
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(CriticalDesign.Colors.accentRed)
                                )
                            
                            Text("=")
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            
                            Text("Can't protect airway")
                                .font(.custom("Poppins-Medium", size: 14))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            
                            Text("=")
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            
                            Text("Intubate")
                                .font(.custom("Poppins-Bold", size: 14))
                                .foregroundColor(CriticalDesign.Colors.accentRed)
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(CriticalDesign.Colors.accentRed.opacity(0.08))
                    )
                    
                    // Trend warning
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(CriticalDesign.Colors.accentOrange)
                        
                        Text("A drop of 2+ points = urgent re-evaluation")
                            .font(.custom("Poppins-Medium", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(CriticalDesign.Colors.accentOrange.opacity(0.08))
                    )
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
                .padding(.bottom, CriticalDesign.Spacing.lg)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.7))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 10)
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Clinical Takeaway Card (Signature Style)
    private var clinicalTakeawayCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(goldColor)
                Text("Clinical Takeaway")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(.white)
            }
            
            Text("GCS is a communication tool, not a diagnosis. A single number matters less than the trajectory. If the patient is getting worse, act—don't wait for the number to catch up.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(red: 0.04, green: 0.09, blue: 0.16))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [goldColor, goldColor.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: goldColor.opacity(0.2), radius: 8, y: 4)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Floating Glass Score (Liquid Glass Style)
    private var floatingGlassScore: some View {
        HStack(alignment: .center, spacing: CriticalDesign.Spacing.md) {
            // Score circle with glow effect
            ZStack {
                // Outer glow
                Circle()
                    .fill(gcsInterpretation.color.opacity(0.2))
                    .frame(width: 46, height: 46)
                    .blur(radius: 4)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [gcsInterpretation.color, gcsInterpretation.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .shadow(color: gcsInterpretation.color.opacity(0.4), radius: 6, x: 0, y: 3)

                Text("\(totalGCS)")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }

            // Score details
            VStack(alignment: .leading, spacing: 4) {
                Text("GCS Score")
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                
                Text(gcsInterpretation.text)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(gcsInterpretation.color)

                // E V M chips - compact row
                HStack(spacing: 6) {
                    GCSFloatingChip(label: "E", value: selectedEye ?? 0, color: CriticalDesign.Colors.accentRed)
                    GCSFloatingChip(label: "V", value: selectedVerbal ?? 0, color: CriticalDesign.Colors.accentTeal)
                    GCSFloatingChip(label: "M", value: selectedMotor ?? 0, color: CriticalDesign.Colors.accentOrange)
                }
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

            Text("Glasgow Coma Scale")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text("Neurological Assessment Tool")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    // MARK: - Score Display Card (Enhanced with Action Guidance)
    private var scoreDisplayCard: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.lg) {
                // Total Score Circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [gcsInterpretation.color, gcsInterpretation.color.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)

                    Text("\(totalGCS)")
                        .font(.custom("Poppins-Bold", size: 36))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    Text("Total GCS Score")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Text(gcsInterpretation.text)
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(gcsInterpretation.color)

                    // Score breakdown
                    HStack(spacing: CriticalDesign.Spacing.md) {
                        GCSNeumorphicScoreChip(label: "E", value: selectedEye ?? 0, color: CriticalDesign.Colors.accentRed)
                        GCSNeumorphicScoreChip(label: "V", value: selectedVerbal ?? 0, color: CriticalDesign.Colors.accentTeal)
                        GCSNeumorphicScoreChip(label: "M", value: selectedMotor ?? 0, color: CriticalDesign.Colors.accentOrange)
                    }
                }

                Spacer()
            }
            
            // Action Guidance - Shows when score is calculated
            if totalGCS > 0 && !gcsInterpretation.action.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: totalGCS >= 13 ? "checkmark.circle.fill" : (totalGCS >= 9 ? "exclamationmark.circle.fill" : "exclamationmark.triangle.fill"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(gcsInterpretation.color)
                    
                    Text(gcsInterpretation.action)
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(gcsInterpretation.color.opacity(0.1))
                )
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.gold.opacity(0.3)
                        : Color.white.opacity(0.8),
                    lineWidth: 1
                )
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Eye Opening Card
    private var eyeOpeningCard: some View {
        GCSNeumorphicCategoryCard(
            title: "Eye Opening",
            subtitle: "Best eye response",
            selectedScore: selectedEye,
            options: eyeOptions,
            accentColor: CriticalDesign.Colors.accentRed,
            onSelect: { score in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedEye = selectedEye == score ? nil : score
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Verbal Response Card
    private var verbalResponseCard: some View {
        GCSNeumorphicCategoryCard(
            title: "Verbal Response",
            subtitle: "Best verbal response",
            selectedScore: selectedVerbal,
            options: verbalOptions,
            accentColor: CriticalDesign.Colors.accentTeal,
            onSelect: { score in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedVerbal = selectedVerbal == score ? nil : score
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Motor Response Card
    private var motorResponseCard: some View {
        GCSNeumorphicCategoryCard(
            title: "Motor Response",
            subtitle: "Best motor response",
            selectedScore: selectedMotor,
            options: motorOptions,
            accentColor: CriticalDesign.Colors.accentOrange,
            onSelect: { score in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedMotor = selectedMotor == score ? nil : score
                }
            }
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }

    // MARK: - Reset Button
    private var resetButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedEye = nil
                selectedVerbal = nil
                selectedMotor = nil
            }
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
            .background(neumorphicCardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .stroke(
                        LinearGradient(
                            colors: colorScheme == .dark
                                ? [CriticalDesign.Colors.gold.opacity(0.3), CriticalDesign.Colors.gold.opacity(0.2)]
                                : [Color.white.opacity(0.8), Color.white.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
    }
}

// MARK: - Mental Model Row Component
private struct MentalModelRow: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let system: String
    let meaning: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(color)
                )
            
            Text(system)
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .frame(width: 60, alignment: .leading)
            
            Image(systemName: "arrow.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            
            Text(meaning)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - GCS Neumorphic Score Chip Component
private struct GCSNeumorphicScoreChip: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(color)
            Text("\(value)")
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.15))
        )
    }
}

// MARK: - GCS Neumorphic Category Card Component
private struct GCSNeumorphicCategoryCard: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let subtitle: String
    let selectedScore: Int?
    let options: [(score: Int, text: String)]
    let accentColor: Color
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Text(subtitle)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }

                Spacer()

                // Current score
                Text("\(selectedScore ?? 0)")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(accentColor.opacity(0.15))
                    )
            }

            // Options
            VStack(spacing: CriticalDesign.Spacing.sm) {
                ForEach(options, id: \.score) { option in
                    GCSNeumorphicOptionRow(
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
                        // Base card fill
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white, Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        // Deep neumorphic shadows for more depth
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(Color.clear)
                            .shadow(color: Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
                            .shadow(color: Color.black.opacity(0.08), radius: 20, x: 10, y: 10)
                            .shadow(color: Color.white, radius: 12, x: -6, y: -6)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.8), Color.white.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                }
            }
        )
    }
}

// MARK: - GCS Neumorphic Option Row Component
private struct GCSNeumorphicOptionRow: View {
    let score: Int
    let text: String
    let isSelected: Bool
    let accentColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: CriticalDesign.Spacing.md) {
                // Score badge
                Text("\(score)")
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(isSelected ? .white : accentColor)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(isSelected ? accentColor : accentColor.opacity(0.15))
                    )

                // Text
                Text(text)
                    .font(.custom(isSelected ? "Poppins-SemiBold" : "Poppins-Medium", size: 15))
                    .foregroundColor(isSelected ? accentColor : CriticalDesign.Colors.primary)

                Spacer()

                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(accentColor)
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(isSelected ? accentColor.opacity(0.1) : CriticalDesign.Colors.canvas)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Floating Chip Component (Compact)
private struct GCSFloatingChip: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        HStack(spacing: 1) {
            Text(label)
                .font(.custom("Poppins-Bold", size: 9))
                .foregroundColor(color)
            Text("\(value)")
                .font(.custom("Poppins-Bold", size: 9))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(color.opacity(0.15))
        )
    }
}

// MARK: - Preview
#Preview {
    GlascowComaScoreDetailView()
}
