//
//  ACLSQuizSessionView.swift
//  CriticalX
//
//  Premium ACLS Quiz Session - Matches EKG Detail Card Style
//  Glass cards with animated transitions
//
//  Created: January 2026
//

import SwiftUI
import SSSwiftUIGIFView

struct ACLSQuizSessionView: View {
    let mode: QuizMode
    let topic: QuizTopic?
    @ObservedObject var viewModel: ACLSQuizViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showExitConfirmation = false
    @State private var isAppearing = false
    @State private var selectedChoiceAnimation: UUID? = nil
    @State private var showQuizResults = false
    @State private var showChallengeShare = false
    
    // Accent color matching cardiac section
    private let accentColor = CriticalDesign.Colors.cardBlue
    private let correctColor = Color(red: 0.2, green: 0.7, blue: 0.4)
    private let incorrectColor = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    // Text colors
    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15)
    }
    private var textSecondary: Color {
        colorScheme == .dark ? Color.white.opacity(0.7) : Color(red: 0.4, green: 0.4, blue: 0.45)
    }
    
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            if viewModel.sessionQuestions.isEmpty {
                emptyStateView
            } else if let question = viewModel.currentQuestion {
                questionContent(question)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.startSession(mode: mode, topic: topic)
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
        .onDisappear {
            viewModel.stopTimer()
        }
        .alert("Exit Quiz?", isPresented: $showExitConfirmation) {
            Button("Continue", role: .cancel) { }
            Button("Exit", role: .destructive) {
                viewModel.stopTimer()
                dismiss()
            }
        } message: {
            Text("Your progress will be saved.")
        }
        .sheet(isPresented: $viewModel.shouldShowUpgradePrompt) {
            UpgradePromptView()
        }
        .sheet(isPresented: $showQuizResults) {
            ACLSQuizResultsSheet(
                score: viewModel.sessionCorrectCount,
                total: viewModel.sessionQuestions.count,
                topic: topic?.name ?? "ACLS",
                accentColor: accentColor,
                correctColor: correctColor,
                onChallenge: { showChallengeShare = true },
                onDone: { dismiss() }
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showChallengeShare) {
            ActivityViewController(items: [
                ClinicalShareHelper.quizChallengeMessage(
                    score: viewModel.sessionCorrectCount,
                    totalQuestions: viewModel.sessionQuestions.count,
                    topic: topic?.name ?? "ACLS"
                )
            ])
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(correctColor.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(correctColor)
            }
            
            Text(emptyStateTitle)
                .font(.custom("Poppins-Bold", size: 24))
                .foregroundColor(textPrimary)
            
            Text(emptyStateMessage)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            premiumButton(title: "Go Back", icon: "arrow.left") {
                dismiss()
            }
        }
    }
    
    private var emptyStateTitle: String {
        switch mode {
        case .review: return "All Caught Up!"
        case .spacedRepetition: return "Nothing Due"
        default: return "No Questions"
        }
    }
    
    private var emptyStateMessage: String {
        switch mode {
        case .review: return "You haven't missed any questions yet. Keep up the great work!"
        case .spacedRepetition: return "No questions are due for review. Check back later!"
        default: return "No questions available for this selection."
        }
    }
    
    // MARK: - Question Content
    
    private func questionContent(_ question: ACLSQuestion) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header with close button and progress
                headerSection
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 20)
                
                // Topic badge
                topicBadge(question)
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 25)
                
                // Clinical vignette (if available)
                if let vignette = question.vignette {
                    vignetteCard(vignette)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 30)
                }
                
                // Vitals (if available)
                if let vitals = question.vitals {
                    vitalsCard(vitals)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 35)
                }
                
                // Rhythm strip GIF (if available)
                if let gifName = question.rhythmStripGIF {
                    rhythmStripCard(gifName: gifName, description: question.rhythmDescription)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 37)
                }
                
                // ETCO2 waveform (if available)
                if let etco2Type = question.etco2WaveformType {
                    etco2WaveformCard(type: etco2Type)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 37)
                }
                
                // Question stem card
                questionStemCard(question.stem)
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 40)
                
                // Answer choices
                answersSection(question)
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 50)
                
                // Explanation (after submission)
                if viewModel.hasSubmitted && viewModel.showExplanation {
                    explanationCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 60)
                }
                
                // Navigation button
                navigationButton
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 70)
                
                Spacer(minLength: 60)
            }
            .padding(.top, 20)
        }
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            // Close button
            Button(action: { showExitConfirmation = true }) {
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.5))
                        .frame(width: 44, height: 44)
                    if colorScheme == .dark {
                        Circle()
                            .stroke(CriticalDesign.Colors.gold, lineWidth: 1)
                            .frame(width: 44, height: 44)
                    }
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(textPrimary)
                }
                .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.5) : Color.black.opacity(0.08), radius: 8, y: 4)
            }
            
            Spacer()
            
            // Progress indicator
            VStack(spacing: 4) {
                Text("Question \(viewModel.sessionIndex + 1) of \(viewModel.sessionQuestions.count)")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(textPrimary)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.2))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor, accentColor.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * viewModel.sessionProgress, height: 6)
                    }
                }
                .frame(width: 120, height: 6)
            }
            
            Spacer()
            
            // Timer or mode indicator
            timerBadge
        }
        .padding(.horizontal, 20)
    }
    
    private var timerBadge: some View {
        Group {
            if mode == .exam {
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .font(.system(size: 14, weight: .semibold))
                    Text(viewModel.formattedTimeRemaining)
                        .font(.custom("Poppins-SemiBold", size: 14))
                }
                .foregroundColor(viewModel.timerColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(viewModel.timerColor.opacity(0.12))
                )
            } else {
                Text("\(viewModel.sessionPercentage)%")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(viewModel.sessionPercentage >= 84 ? correctColor : accentColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill((viewModel.sessionPercentage >= 84 ? correctColor : accentColor).opacity(0.12))
                    )
            }
        }
    }
    
    // MARK: - Topic Badge
    
    private func topicBadge(_ question: ACLSQuestion) -> some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: question.topic.icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(question.topic.displayName)
                    .font(.custom("Poppins-SemiBold", size: 12))
            }
            .foregroundColor(question.topic.color)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(question.topic.color.opacity(0.12))
            )
            
            Spacer()
            
            // Difficulty dots
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(i < question.difficulty.sortOrder ? difficultyColor(question.difficulty) : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
                Text(question.difficulty.displayName)
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(textSecondary)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func difficultyColor(_ difficulty: ACLSDifficulty) -> Color {
        switch difficulty {
        case .easy: return correctColor
        case .medium: return .orange
        case .hard: return incorrectColor
        }
    }
    
    // MARK: - Vignette Card
    
    private func vignetteCard(_ vignette: String) -> some View {
        glassCard(accentColor: .blue) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "person.fill.questionmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.blue)
                    
                    Text("Clinical Scenario")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(textPrimary)
                }
                
                Text(vignette)
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundColor(textPrimary)
                    .lineSpacing(6)
            }
        }
    }
    
    // MARK: - Vitals Card
    
    private func vitalsCard(_ vitals: ACLSVitals) -> some View {
        glassCard(accentColor: .red) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.red)
                    
                    Text("Vital Signs")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(textPrimary)
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    if let hr = vitals.heartRate {
                        vitalItem(label: "HR", value: "\(hr)", unit: "bpm", color: .red)
                    }
                    if let bp = vitals.bloodPressureFormatted {
                        vitalItem(label: "BP", value: bp, unit: "mmHg", color: .orange)
                    }
                    if let spo2 = vitals.spO2 {
                        vitalItem(label: "SpO2", value: "\(spo2)", unit: "%", color: .blue)
                    }
                    if let rr = vitals.respiratoryRate {
                        vitalItem(label: "RR", value: "\(rr)", unit: "/min", color: .teal)
                    }
                    if let temp = vitals.temperature {
                        vitalItem(label: "Temp", value: String(format: "%.1f", temp), unit: "°C", color: .purple)
                    }
                }
            }
        }
    }
    
    private func vitalItem(label: String, value: String, unit: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.custom("Poppins-Medium", size: 10))
                .foregroundColor(textSecondary)
            Text(value)
                .font(.custom("Poppins-Bold", size: 20))
                .foregroundColor(color)
            Text(unit)
                .font(.custom("Poppins-Regular", size: 9))
                .foregroundColor(textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.08))
        .cornerRadius(12)
    }
    
    // MARK: - Rhythm Strip Card (Visual Recognition)
    
    private func rhythmStripCard(gifName: String, description: String?) -> some View {
        glassCard(accentColor: .red) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.red, .red.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "waveform.path.ecg")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Rhythm Strip")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(textPrimary)
                        
                        Text("Identify this rhythm")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(textSecondary)
                    }
                }
                
                // GIF Display
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.05))
                    
                    SwiftUIGIFPlayerView(gifName: gifName)
                        .frame(height: 120)
                        .cornerRadius(8)
                        .padding(8)
                }
                .frame(height: 140)
                
                // Rhythm description hint (optional - shown after answer for non-visual clue)
                if let desc = description {
                    HStack(spacing: 8) {
                        Image(systemName: "eye.slash.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        
                        Text("Hint: \(desc)")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(.orange)
                            .italic()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - ETCO2 Waveform Card
    
    private func etco2WaveformCard(type: ETCO2WaveformType) -> some View {
        glassCard(accentColor: .green) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.green, .green.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Capnography Reading")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(textPrimary)
                        
                        Text("End-Tidal CO2 Waveform")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(textSecondary)
                    }
                }
                
                // ETCO2 Waveform Visualization
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.85))
                    
                    VStack(spacing: 8) {
                        // Waveform representation
                        etco2WaveformView(type: type)
                            .frame(height: 60)
                            .padding(.horizontal, 16)
                        
                        // Waveform description
                        Text(type.rawValue)
                            .font(.custom("Poppins-SemiBold", size: 13))
                            .foregroundColor(.green)
                    }
                    .padding(.vertical, 12)
                }
                .frame(height: 100)
            }
        }
    }
    
    // Simple ETCO2 waveform visualization
    private func etco2WaveformView(type: ETCO2WaveformType) -> some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                path.move(to: CGPoint(x: 0, y: height))
                
                switch type {
                case .normal:
                    // Normal square wave pattern
                    for i in 0..<3 {
                        let startX = CGFloat(i) * (width / 3)
                        path.addLine(to: CGPoint(x: startX + 10, y: height))
                        path.addLine(to: CGPoint(x: startX + 15, y: height * 0.3))
                        path.addLine(to: CGPoint(x: startX + (width/3) - 15, y: height * 0.3))
                        path.addLine(to: CGPoint(x: startX + (width/3) - 10, y: height))
                    }
                    
                case .lowPerfusion:
                    // Very low amplitude waves
                    for i in 0..<4 {
                        let startX = CGFloat(i) * (width / 4)
                        path.addLine(to: CGPoint(x: startX + 10, y: height))
                        path.addLine(to: CGPoint(x: startX + 15, y: height * 0.85))
                        path.addLine(to: CGPoint(x: startX + (width/4) - 15, y: height * 0.85))
                        path.addLine(to: CGPoint(x: startX + (width/4) - 10, y: height))
                    }
                    
                case .roscSpike:
                    // Sudden jump in amplitude
                    path.addLine(to: CGPoint(x: width * 0.1, y: height))
                    path.addLine(to: CGPoint(x: width * 0.15, y: height * 0.8))
                    path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.8))
                    path.addLine(to: CGPoint(x: width * 0.4, y: height))
                    // Spike up
                    path.addLine(to: CGPoint(x: width * 0.5, y: height))
                    path.addLine(to: CGPoint(x: width * 0.55, y: height * 0.2))
                    path.addLine(to: CGPoint(x: width * 0.75, y: height * 0.2))
                    path.addLine(to: CGPoint(x: width * 0.8, y: height))
                    path.addLine(to: CGPoint(x: width, y: height))
                    
                case .esophageal:
                    // Flat line
                    path.addLine(to: CGPoint(x: width, y: height))
                    
                case .hyperventilation:
                    // Declining peaks
                    for i in 0..<5 {
                        let startX = CGFloat(i) * (width / 5)
                        let peakHeight = height * (0.3 + CGFloat(i) * 0.12)
                        path.addLine(to: CGPoint(x: startX + 5, y: height))
                        path.addLine(to: CGPoint(x: startX + 8, y: peakHeight))
                        path.addLine(to: CGPoint(x: startX + (width/5) - 8, y: peakHeight))
                        path.addLine(to: CGPoint(x: startX + (width/5) - 5, y: height))
                    }
                    
                case .bronchospasm:
                    // Shark fin pattern
                    for i in 0..<3 {
                        let startX = CGFloat(i) * (width / 3)
                        path.addLine(to: CGPoint(x: startX + 10, y: height))
                        path.addLine(to: CGPoint(x: startX + (width/3) - 20, y: height * 0.3))
                        path.addLine(to: CGPoint(x: startX + (width/3) - 10, y: height))
                    }
                    
                case .rebreathing:
                    // Elevated baseline
                    for i in 0..<3 {
                        let startX = CGFloat(i) * (width / 3)
                        path.addLine(to: CGPoint(x: startX + 10, y: height * 0.7))
                        path.addLine(to: CGPoint(x: startX + 15, y: height * 0.3))
                        path.addLine(to: CGPoint(x: startX + (width/3) - 15, y: height * 0.3))
                        path.addLine(to: CGPoint(x: startX + (width/3) - 10, y: height * 0.7))
                    }
                }
            }
            .stroke(Color.green, lineWidth: 2)
        }
    }
    
    // MARK: - Question Stem Card
    
    private func questionStemCard(_ stem: String) -> some View {
        glassCard(accentColor: accentColor) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [accentColor, accentColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                        
                        Text("Q")
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(.white)
                    }
                    
                    Text("Question")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(textPrimary)
                }
                
                Text(stem)
                    .font(.custom("Poppins-SemiBold", size: 17))
                    .foregroundColor(textPrimary)
                    .lineSpacing(6)
            }
        }
    }
    
    // MARK: - Answers Section
    
    private func answersSection(_ question: ACLSQuestion) -> some View {
        VStack(spacing: 12) {
            ForEach(Array(question.choices.enumerated()), id: \.element.id) { index, choice in
                answerButton(choice, index: index, question: question)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func answerButton(_ choice: ACLSChoice, index: Int, question: ACLSQuestion) -> some View {
        let isSelected = viewModel.selectedAnswerID == choice.id
        let isCorrect = choice.isCorrect
        let showResult = viewModel.hasSubmitted
        
        let cardColor: Color = {
            if showResult {
                if isCorrect { return correctColor }
                if isSelected && !isCorrect { return incorrectColor }
            }
            if isSelected { return accentColor }
            return Color.gray
        }()
        
        return Button(action: {
            if !viewModel.hasSubmitted {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    viewModel.selectAnswer(choice.id)
                    selectedChoiceAnimation = choice.id
                }
            }
        }) {
            HStack(alignment: .top, spacing: 14) {
                // Letter indicator
                ZStack {
                    Circle()
                        .fill(showResult && isCorrect ? correctColor : (isSelected ? cardColor : Color.clear))
                        .frame(width: 32, height: 32)
                    
                    Circle()
                        .stroke(cardColor, lineWidth: 2)
                        .frame(width: 32, height: 32)
                    
                    if showResult {
                        Image(systemName: isCorrect ? "checkmark" : (isSelected && !isCorrect ? "xmark" : ""))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Text(["A", "B", "C", "D", "E"][index])
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(isSelected ? .white : cardColor)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(choice.text)
                        .font(.custom("Poppins-Regular", size: 15))
                        .foregroundColor(textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    // Key takeaway after submission
                    if showResult && isCorrect, let takeaway = choice.keyTakeaway {
                        Text(takeaway)
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(correctColor)
                            .padding(.top, 4)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                ZStack {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                    }
                    if showResult && isCorrect {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(correctColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
                    } else if showResult && isSelected && !isCorrect {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(incorrectColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
                    } else if isSelected {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(accentColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isSelected || (showResult && isCorrect) ? cardColor : (colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.6) : Color.gray.opacity(0.2)),
                        lineWidth: isSelected || (showResult && isCorrect) ? 2 : 1
                    )
            )
            .shadow(color: colorScheme == .dark ? (isSelected ? cardColor.opacity(0.3) : CriticalDesign.Colors.darkCanvas.opacity(0.5)) : (isSelected ? cardColor.opacity(0.2) : Color.black.opacity(0.05)), radius: 8, y: 4)
            .scaleEffect(selectedChoiceAnimation == choice.id ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(viewModel.hasSubmitted)
    }
    
    // MARK: - Explanation Card
    
    private var explanationCard: some View {
        glassCard(accentColor: viewModel.isCorrect ? correctColor : .yellow) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [viewModel.isCorrect ? correctColor : .yellow, (viewModel.isCorrect ? correctColor : .yellow).opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: viewModel.isCorrect ? "checkmark" : "lightbulb.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text(viewModel.isCorrect ? "Correct!" : "Explanation")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(viewModel.isCorrect ? correctColor : textPrimary)
                }
                
                Text(viewModel.explanationText.formatMarkdown())
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundColor(textPrimary)
                    .lineSpacing(6)

                // Ask Luca button - only show if not already requested
                if !viewModel.hasRequestedLucaCoaching && !viewModel.isLoadingExplanation {
                    Button(action: {
                        viewModel.requestLucaCoaching()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Ask Luca")
                                .font(.custom("Poppins-SemiBold", size: 14))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [Color.purple, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .padding(.top, 12)
                } else if viewModel.isLoadingExplanation {
                    HStack(spacing: 8) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                            .scaleEffect(0.8)
                        Text("Luca is thinking...")
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(textSecondary)
                    }
                    .padding(.top, 12)
                }
            }
        }
    }

    // MARK: - Navigation Button
    
    private var navigationButton: some View {
        Group {
            if !viewModel.hasSubmitted {
                premiumButton(
                    title: "Submit Answer",
                    icon: "checkmark.circle.fill",
                    isDisabled: viewModel.selectedAnswerID == nil
                ) {
                    withAnimation(.spring(response: 0.4)) {
                        viewModel.submitAnswer()
                    }
                }
            } else {
                premiumButton(
                    title: viewModel.isLastQuestion ? "Finish Quiz" : "Next Question",
                    icon: viewModel.isLastQuestion ? "flag.checkered" : "arrow.right",
                    color: viewModel.isCorrect ? correctColor : accentColor
                ) {
                    if viewModel.isLastQuestion {
                        showQuizResults = true
                    } else {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isAppearing = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            viewModel.nextQuestion()
                            withAnimation(.easeOut(duration: 0.5)) {
                                isAppearing = true
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Helper Views
    
    private func glassCard<Content: View>(accentColor: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.08), Color.white.opacity(0.3), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.goldGradient
                        : LinearGradient(
                            colors: [accentColor.opacity(0.4), Color.white.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: 1
                )
        )
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.6) : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : accentColor.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
    
    private func premiumButton(title: String, icon: String, color: Color = CriticalDesign.Colors.cardBlue, isDisabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 17))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: isDisabled ? [Color.gray, Color.gray.opacity(0.8)] : [color, color.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .shadow(color: isDisabled ? Color.clear : color.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1)
    }
}
