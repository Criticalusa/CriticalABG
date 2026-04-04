//
//  ACLSQuizMainView.swift
//  CriticalX
//
//  ACLS Test Prep - Premium Glass Card Design
//  Matches EKG Detail Views (SinusBradycardia, etc.)
//  Gamified Learning Experience with AI-powered explanations
//
//  Created: January 2026
//

import SwiftUI

// MARK: - Main Quiz Landing View

struct ACLSQuizMainView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = ACLSQuizViewModel()
    @State private var isAppearing = false
    @State private var showPracticeMode = false
    @State private var showExamMode = false
    @State private var selectedTopic: QuizTopic? = nil
    @State private var showProUpgrade = false
    @State private var showReviewMode = false
    @State private var showSpacedRepetition = false
    @State private var showAlgorithms = false
    @State private var showMegacode = false
    
    // Accent color for quiz (red for cardiac/ACLS)
    private let accentColor = Color.red
    
    // Text colors (home page theme)
    private var textPrimary: Color {
        CriticalDesign.Adaptive.textPrimary(for: colorScheme)
    }
    private var textSecondary: Color {
        CriticalDesign.Adaptive.textSecondary(for: colorScheme)
    }
    
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Close button
                    HStack {
                        Spacer()
                        PremiumLightCloseButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }
                    
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    readinessGauge
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 30)
                    
                    streakCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)
                        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
                    
                    studyModesCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 50)
                        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
                    
                    topicMasteryCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 60)
                        .animation(.easeOut(duration: 0.4).delay(0.3), value: isAppearing)
                    
                    achievementsCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 70)
                        .animation(.easeOut(duration: 0.4).delay(0.4), value: isAppearing)
                    
                    Spacer(minLength: 60)
                }
                .padding(.top, 20)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
            GlobalPatientContext.shared.showFloatingButton = false
        }
        .onDisappear {
            GlobalPatientContext.shared.showFloatingButton = true
        }
        .sheet(isPresented: $showPracticeMode) {
            ACLSQuizSessionView(mode: .practice, topic: nil, viewModel: viewModel)
        }
        .sheet(isPresented: $showExamMode) {
            ACLSQuizSessionView(mode: .exam, topic: nil, viewModel: viewModel)
        }
        .sheet(item: $selectedTopic) { topic in
            ACLSQuizSessionView(mode: .topicDrill, topic: topic, viewModel: viewModel)
        }
        .sheet(isPresented: $showProUpgrade) {
            ProUpgradeView(feature: "ACLS Quiz")
        }
        .sheet(isPresented: $showReviewMode) {
            ACLSQuizSessionView(mode: .review, topic: nil, viewModel: viewModel)
        }
        .sheet(isPresented: $showSpacedRepetition) {
            ACLSQuizSessionView(mode: .spacedRepetition, topic: nil, viewModel: viewModel)
        }
        .sheet(isPresented: $showAlgorithms) {
            ACLSAlgorithmSelectionView()
        }
        .sheet(isPresented: $showMegacode) {
            ACLSQuizSessionView(mode: .megacode, topic: nil, viewModel: viewModel)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(colorScheme == .dark ? 0.25 : 0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                ZStack {
                    if colorScheme == .dark {
                        Circle()
                            .fill(CriticalDesign.Colors.cardBlue)
                            .frame(width: 80, height: 80)
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [CriticalDesign.Colors.gold.opacity(0.6), CriticalDesign.Colors.gold.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                            .frame(width: 80, height: 80)
                    } else {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 80, height: 80)
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 80, height: 80)
                        Circle()
                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                            .frame(width: 80, height: 80)
                    }
                    
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 36, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentColor, accentColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.35) : Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            
            Text("ACLS Mastery")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Pass the first time. Guaranteed.")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(textSecondary)
            
            Text("TEST PREP")
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(accentColor)
                .tracking(2)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(accentColor.opacity(0.12))
                )
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Readiness Gauge
    
    private var readinessGauge: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "gauge.with.needle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(accentColor)
                
                Text("Exam Readiness")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textPrimary)
                
                Spacer()
                
                Text("\(viewModel.overallReadiness)%")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(readinessColor)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color(.systemGray5))
                        .frame(height: 16)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: readinessGradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * CGFloat(viewModel.overallReadiness) / 100), height: 16)
                        .animation(.easeInOut(duration: 1), value: viewModel.overallReadiness)
                    
                    // Pass threshold marker (84%)
                    Rectangle()
                        .fill(Color.green.opacity(0.8))
                        .frame(width: 3, height: 24)
                        .offset(x: geometry.size.width * 0.84 - 1.5)
                }
            }
            .frame(height: 24)
            
            HStack {
                Label("Pass Threshold: 84%", systemImage: "checkmark.seal.fill")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(.green)
                Spacer()
                Text("\(viewModel.questionsAnswered) questions practiced")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(textSecondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(glassCardBackground)
        .overlay(glassCardBorder(color: accentColor))
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .shadow(color: accentColor.opacity(colorScheme == .dark ? 0.2 : 0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
    
    private var readinessColor: Color {
        switch viewModel.overallReadiness {
        case 84...100: return .green
        case 70..<84: return .orange
        default: return .red
        }
    }
    
    private var readinessGradientColors: [Color] {
        switch viewModel.overallReadiness {
        case 84...100: return [.green, .green.opacity(0.7)]
        case 70..<84: return [.orange, .yellow]
        default: return [.red, .orange]
        }
    }
    
    // MARK: - Streak Card
    
    private var streakCard: some View {
        HStack(spacing: 0) {
            // Current streak
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(viewModel.currentStreak)")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(textPrimary)
                }
                Text("Day Streak")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(textSecondary)
            }
            .frame(maxWidth: .infinity)
            
            // Divider
            Rectangle()
                .fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.2))
                .frame(width: 1, height: 50)
            
            // Questions today
            VStack(spacing: 4) {
                Text("\(viewModel.questionsToday)")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(textPrimary)
                Text("Today")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(textSecondary)
            }
            .frame(maxWidth: .infinity)
            
            // Divider
            Rectangle()
                .fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.2))
                .frame(width: 1, height: 50)
            
            // Accuracy
            VStack(spacing: 4) {
                Text("\(viewModel.accuracy)%")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(viewModel.accuracy >= 84 ? .green : textPrimary)
                Text("Accuracy")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(glassCardBackground)
        .overlay(glassCardBorder(color: .orange))
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Study Modes Card
    
    private var studyModesCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "book.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.blue.opacity(0.3), radius: 4, y: 2)
                
                Text("Study Modes")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            VStack(spacing: 12) {
                // Practice Mode
                studyModeRow(
                    title: "Practice Mode",
                    subtitle: "Learn at your own pace",
                    icon: "book.fill",
                    color: .blue,
                    isPro: false
                ) {
                    showPracticeMode = true
                }
                
                // Exam Simulation
                studyModeRow(
                    title: "Exam Simulation",
                    subtitle: "50 questions, 60 minutes",
                    icon: "timer",
                    color: .red,
                    isPro: true,
                    isLocked: !viewModel.isProUser
                ) {
                    if viewModel.isProUser {
                        showExamMode = true
                    } else {
                        showProUpgrade = true
                    }
                }
                
                // Target Weak Areas
                studyModeRow(
                    title: "Target Weak Areas",
                    subtitle: "AI-focused practice",
                    icon: "target",
                    color: .orange,
                    isPro: true,
                    isLocked: !viewModel.isProUser
                ) {
                    if viewModel.isProUser {
                        selectedTopic = viewModel.weakestTopic
                    } else {
                        showProUpgrade = true
                    }
                }
                
                // Review Missed
                if viewModel.hasMissedQuestions {
                    studyModeRow(
                        title: "Review Missed (\(viewModel.missedQuestions.count))",
                        subtitle: "Go back through wrong answers",
                        icon: "arrow.counterclockwise",
                        color: .purple,
                        isPro: false
                    ) {
                        showReviewMode = true
                    }
                }
                
                // Spaced Repetition
                studyModeRow(
                    title: "Smart Review",
                    subtitle: "Spaced repetition",
                    icon: "brain",
                    color: .teal,
                    isPro: true,
                    isLocked: !viewModel.isProUser
                ) {
                    if viewModel.isProUser {
                        showSpacedRepetition = true
                    } else {
                        showProUpgrade = true
                    }
                }
                
                // Interactive Algorithms
                studyModeRow(
                    title: "Interactive Algorithms",
                    subtitle: "Step through ACLS algorithms",
                    icon: "arrow.triangle.branch",
                    color: .indigo,
                    isPro: false
                ) {
                    showAlgorithms = true
                }
                
                // Megacode Scenarios - Complex clinical simulations
                studyModeRow(
                    title: "Megacode Scenarios",
                    subtitle: "50 complex clinical cases",
                    icon: "person.3.fill",
                    color: .pink,
                    isPro: false
                ) {
                    showMegacode = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(glassCardBackground)
        .overlay(glassCardBorder(color: .blue))
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
    
    private func studyModeRow(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        isPro: Bool = false,
        isLocked: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(color)
                }
                
                // Text
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(textPrimary)
                        
                        if isPro {
                            Text("PRO")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    LinearGradient(
                                        colors: [CriticalDesign.Colors.gold, CriticalDesign.Colors.gold.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(subtitle)
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(textSecondary)
                }
                
                Spacer()
                
                // Arrow or lock
                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14))
                        .foregroundColor(textSecondary)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(color)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(colorScheme == .dark ? color.opacity(0.2) : color.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.25) : color.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(isLocked ? 0.7 : 1)
    }
    
    // MARK: - Topic Mastery Card
    
    private var topicMasteryCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [.purple, .purple.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.purple.opacity(0.3), radius: 4, y: 2)
                
                Text("Topic Mastery")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                Spacer()
                
                Text("Tap to drill")
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor(textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            VStack(spacing: 8) {
                ForEach(viewModel.topicProgress) { topic in
                    topicRow(topic)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(glassCardBackground)
        .overlay(glassCardBorder(color: .purple))
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
    
    private func topicRow(_ topic: QuizTopic) -> some View {
        Button(action: { selectedTopic = topic }) {
            HStack(spacing: 12) {
                // Topic icon
                Image(systemName: topic.icon)
                    .font(.system(size: 16))
                    .foregroundColor(topic.color)
                    .frame(width: 28)
                
                // Topic name
                VStack(alignment: .leading, spacing: 2) {
                    Text(topic.name)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(textPrimary)
                    
                    Text("\(topic.questionsAnswered)/\(topic.totalQuestions)")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(textSecondary)
                }
                
                Spacer()
                
                // Progress circle
                ZStack {
                    Circle()
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color(.systemGray5), lineWidth: 4)
                        .frame(width: 36, height: 36)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(topic.mastery) / 100)
                        .stroke(topic.masteryColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 36, height: 36)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(topic.mastery)%")
                        .font(.custom("Poppins-SemiBold", size: 9))
                        .foregroundColor(textPrimary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundColor(textSecondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Achievements Card
    
    private var achievementsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [CriticalDesign.Colors.gold, CriticalDesign.Colors.gold.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: CriticalDesign.Colors.gold.opacity(0.3), radius: 4, y: 2)
                
                Text("Achievements")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.achievements) { achievement in
                        achievementBadge(achievement)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(glassCardBackground)
        .overlay(glassCardBorder(color: CriticalDesign.Colors.gold))
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
    
    private func achievementBadge(_ achievement: QuizAchievement) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked
                            ? LinearGradient(colors: [CriticalDesign.Colors.gold, CriticalDesign.Colors.gold.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 56, height: 56)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 22))
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
            }
            
            Text(achievement.name)
                .font(.custom("Poppins-Medium", size: 10))
                .foregroundColor(achievement.isUnlocked ? textPrimary : textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 65)
        }
        .opacity(achievement.isUnlocked ? 1 : 0.5)
    }
    
    // MARK: - Glass Card Helpers (home page theme in dark)
    
    private var glassCardBackground: some View {
        Group {
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(CriticalDesign.Colors.cardBlue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [CriticalDesign.Colors.gold.opacity(0.5), CriticalDesign.Colors.gold.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.5))
                }
            }
        }
    }
    
    private func glassCardBorder(color: Color) -> some View {
        Group {
            if colorScheme == .dark {
                // Border already applied in glassCardBackground for dark
                EmptyView()
            } else {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [color.opacity(0.3), Color.white.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        }
    }
}

// MARK: - Preview

#Preview("Light") {
    ACLSQuizMainView()
        .preferredColorScheme(.light)
}
#Preview("Dark") {
    ACLSQuizMainView()
        .preferredColorScheme(.dark)
}
