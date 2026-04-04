//
//  ACLSQuizViewModel.swift
//  CriticalX
//
//  ViewModel for ACLS Quiz - standalone implementation
//  Provides gamification, progress tracking, and AI explanations
//
//  Created: January 2026
//

import SwiftUI
import Combine

// MARK: - Quiz ViewModel

@MainActor
class ACLSQuizViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // Overall progress
    @Published var overallReadiness: Int = 0
    @Published var questionsAnswered: Int = 0
    @Published var accuracy: Int = 0
    
    // Gamification
    @Published var currentStreak: Int = 0
    @Published var questionsToday: Int = 0
    @Published var isProUser: Bool = false
    
    // Topic progress
    @Published var topicProgress: [QuizTopic] = []
    @Published var weakestTopic: QuizTopic?
    
    // Achievements
    @Published var achievements: [QuizAchievement] = []
    
    // Current session state
    @Published var currentQuestion: ACLSQuestion?
    @Published var selectedAnswerID: UUID?
    @Published var hasSubmitted: Bool = false
    @Published var isCorrect: Bool = false
    @Published var sessionQuestions: [ACLSQuestion] = []
    @Published var sessionIndex: Int = 0
    @Published var sessionCorrectCount: Int = 0
    
    // Timer (for exam mode)
    @Published var examTimeRemaining: Int = 3600
    @Published var isTimerRunning: Bool = false
    @Published var timerExpired: Bool = false
    
    // Missed Questions Review
    @Published var missedQuestions: [ACLSQuestion] = []
    @Published var hasMissedQuestions: Bool = false
    
    // Explanation state
    @Published var isLoadingExplanation: Bool = false
    @Published var explanationText: String = ""
    @Published var showExplanation: Bool = false
    @Published var hasRequestedLucaCoaching: Bool = false
    
    // MARK: - Content Access
    
    /// Whether user should see upgrade prompt for this question
    @Published var shouldShowUpgradePrompt: Bool = false
    
    /// Check if user can access current question (free users limited to first N)
    var canAccessCurrentQuestion: Bool {
        // Full access users can see all questions
        if ContentAccessManager.shared.hasFullAccess {
            return true
        }
        
        // Free users limited to first N questions per session
        return sessionIndex < ContentAccessManager.freeACLSQuestionCount
    }
    
    // MARK: - Private Properties
    
    private let bridge = ACLSCoreBridge.shared
    private var timerCancellable: AnyCancellable?
    private var questionStartTime: Date?
    
    // MARK: - Initialization
    
    init() {
        loadProgress()
        loadTopics()
        loadAchievements()
        checkProStatus()
        updateMissedQuestions()
    }
    
    // MARK: - Data Loading
    
    private func loadProgress() {
        let defaults = UserDefaults.standard
        questionsAnswered = defaults.integer(forKey: "acls_questions_answered")
        let totalCorrect = defaults.integer(forKey: "acls_total_correct")
        accuracy = questionsAnswered > 0 ? (totalCorrect * 100) / questionsAnswered : 0
        
        currentStreak = defaults.integer(forKey: "acls_streak")
        questionsToday = defaults.integer(forKey: "acls_today_count")
        
        checkDayReset()
        overallReadiness = bridge.overallReadiness()
    }
    
    private func checkDayReset() {
        let defaults = UserDefaults.standard
        let lastDate = defaults.object(forKey: "acls_last_date") as? Date ?? Date.distantPast
        
        if !Calendar.current.isDateInToday(lastDate) {
            if Calendar.current.isDateInYesterday(lastDate) && questionsToday > 0 {
                currentStreak += 1
            } else if !Calendar.current.isDateInYesterday(lastDate) {
                currentStreak = 0
            }
            
            questionsToday = 0
            defaults.set(Date(), forKey: "acls_last_date")
            defaults.set(currentStreak, forKey: "acls_streak")
            defaults.set(questionsToday, forKey: "acls_today_count")
        }
    }
    
    private func loadTopics() {
        let mastery = bridge.topicMastery()
        let defaults = UserDefaults.standard
        
        topicProgress = ACLSTopicType.allCases.map { topic in
            let m = mastery[topic] ?? defaults.integer(forKey: "acls_topic_\(topic.rawValue)_mastery")
            let answered = defaults.integer(forKey: "acls_topic_\(topic.rawValue)_answered")
            
            return QuizTopic(
                id: topic.rawValue,
                name: topic.displayName,
                icon: topic.icon,
                color: topic.color,
                mastery: m,
                questionsAnswered: answered,
                totalQuestions: 0
            )
        }
        
        weakestTopic = topicProgress.filter { $0.questionsAnswered > 0 }.min(by: { $0.mastery < $1.mastery })
            ?? topicProgress.first
    }
    
    private func loadAchievements() {
        let defaults = UserDefaults.standard
        
        achievements = [
            QuizAchievement(id: "first_q", name: "First Step", icon: "flag.fill", isUnlocked: defaults.bool(forKey: "acls_ach_first_q")),
            QuizAchievement(id: "streak_7", name: "Week Warrior", icon: "flame.fill", isUnlocked: defaults.bool(forKey: "acls_ach_streak_7")),
            QuizAchievement(id: "streak_30", name: "Monthly Master", icon: "star.fill", isUnlocked: defaults.bool(forKey: "acls_ach_streak_30")),
            QuizAchievement(id: "perfect_10", name: "Perfect 10", icon: "10.circle.fill", isUnlocked: defaults.bool(forKey: "acls_ach_perfect_10")),
            QuizAchievement(id: "hundred_q", name: "Century Club", icon: "100.circle.fill", isUnlocked: defaults.bool(forKey: "acls_ach_hundred_q")),
            QuizAchievement(id: "all_topics", name: "Well Rounded", icon: "circle.grid.3x3.fill", isUnlocked: defaults.bool(forKey: "acls_ach_all_topics")),
            QuizAchievement(id: "exam_pass", name: "Test Ready", icon: "checkmark.seal.fill", isUnlocked: defaults.bool(forKey: "acls_ach_exam_pass")),
            QuizAchievement(id: "ace", name: "ACLS Ace", icon: "crown.fill", isUnlocked: defaults.bool(forKey: "acls_ach_ace"))
        ]
    }
    
    // Reference to the shared subscription manager
    private let subscriptionManager = SubscriptionManager()

    private func checkProStatus() {
        subscriptionManager.checkSubscriptionStatus()
        isProUser = subscriptionManager.isProSubscribed
    }
    
    private func updateMissedQuestions() {
        missedQuestions = bridge.missedQuestions()
        hasMissedQuestions = !missedQuestions.isEmpty
    }
    
    // MARK: - Session Management
    
    func startSession(mode: QuizMode, topic: QuizTopic?) {
        if mode == .exam {
            examTimeRemaining = 3600
            timerExpired = false
            startTimer()
        } else {
            stopTimer()
        }
        
        sessionQuestions = generateQuestions(mode: mode, topic: topic)
        sessionIndex = 0
        sessionCorrectCount = 0
        hasSubmitted = false
        selectedAnswerID = nil
        explanationText = ""
        showExplanation = false
        
        if !sessionQuestions.isEmpty {
            currentQuestion = sessionQuestions[0]
            questionStartTime = Date()
        }
    }
    
    private func generateQuestions(mode: QuizMode, topic: QuizTopic?) -> [ACLSQuestion] {
        let aclsTopic = topic.flatMap { ACLSTopicType(rawValue: $0.id) }
        
        switch mode {
        case .practice:
            return bridge.practiceQuestions(count: 10, topic: aclsTopic)
            
        case .exam:
            return bridge.examQuestions()
            
        case .topicDrill:
            if let t = aclsTopic {
                return bridge.topicQuestions(topic: t, count: 15)
            }
            return bridge.weakAreaQuestions(count: 15)
            
        case .review:
            return bridge.missedQuestions()
            
        case .spacedRepetition:
            return bridge.questionsForReview()
            
        case .megacode:
            return bridge.megacodeQuestions(count: 10)
        }
    }
    
    // MARK: - Timer Management
    
    func startTimer() {
        isTimerRunning = true
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timerTick()
            }
    }
    
    func stopTimer() {
        isTimerRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    func pauseTimer() {
        isTimerRunning = false
        timerCancellable?.cancel()
    }
    
    func resumeTimer() {
        if examTimeRemaining > 0 {
            startTimer()
        }
    }
    
    private func timerTick() {
        guard examTimeRemaining > 0 else {
            timerExpired = true
            stopTimer()
            return
        }
        examTimeRemaining -= 1
    }
    
    var formattedTimeRemaining: String {
        let minutes = examTimeRemaining / 60
        let seconds = examTimeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var timerColor: Color {
        if examTimeRemaining <= 300 { return .red }
        else if examTimeRemaining <= 600 { return .orange }
        return .primary
    }
    
    // MARK: - Answer Handling
    
    func selectAnswer(_ answerID: UUID) {
        guard !hasSubmitted else { return }
        selectedAnswerID = answerID
    }
    
    func submitAnswer() {
        guard let currentQuestion = currentQuestion,
              let selectedAnswerID = selectedAnswerID,
              !hasSubmitted else { return }
        
        hasSubmitted = true
        isCorrect = currentQuestion.correctAnswerID == selectedAnswerID
        
        if isCorrect {
            sessionCorrectCount += 1
        }
        
        let timeSpent = Int(Date().timeIntervalSince(questionStartTime ?? Date()))
        
        bridge.recordAnswer(questionID: currentQuestion.id, correct: isCorrect, timeSpent: timeSpent)
        
        questionsAnswered += 1
        questionsToday += 1
        
        let defaults = UserDefaults.standard
        defaults.set(questionsAnswered, forKey: "acls_questions_answered")
        defaults.set(questionsToday, forKey: "acls_today_count")
        defaults.set(Date(), forKey: "acls_last_date")
        
        if isCorrect {
            let totalCorrect = defaults.integer(forKey: "acls_total_correct") + 1
            defaults.set(totalCorrect, forKey: "acls_total_correct")
            accuracy = (totalCorrect * 100) / questionsAnswered
        } else {
            let totalCorrect = defaults.integer(forKey: "acls_total_correct")
            accuracy = questionsAnswered > 0 ? (totalCorrect * 100) / questionsAnswered : 0
        }
        
        updateTopicMastery(topic: currentQuestion.topic, correct: isCorrect)
        checkAchievements()
        updateMissedQuestions()
        loadExplanation()
    }
    
    private func updateTopicMastery(topic: ACLSTopicType, correct: Bool) {
        guard let index = topicProgress.firstIndex(where: { $0.id == topic.rawValue }) else { return }
        
        topicProgress[index].questionsAnswered += 1
        
        let defaults = UserDefaults.standard
        let key = "acls_topic_\(topic.rawValue)_correct"
        var correctCount = defaults.integer(forKey: key)
        if correct {
            correctCount += 1
            defaults.set(correctCount, forKey: key)
        }
        
        let answered = topicProgress[index].questionsAnswered
        let mastery = answered > 0 ? (correctCount * 100) / answered : 0
        topicProgress[index].mastery = min(100, mastery)
        
        defaults.set(topicProgress[index].mastery, forKey: "acls_topic_\(topic.rawValue)_mastery")
        defaults.set(answered, forKey: "acls_topic_\(topic.rawValue)_answered")
        
        overallReadiness = bridge.overallReadiness()
        weakestTopic = topicProgress.filter { $0.questionsAnswered > 0 }.min(by: { $0.mastery < $1.mastery })
    }
    
    private func checkAchievements() {
        let defaults = UserDefaults.standard
        
        if questionsAnswered == 1 && !achievements[0].isUnlocked {
            achievements[0].isUnlocked = true
            defaults.set(true, forKey: "acls_ach_first_q")
        }
        
        if currentStreak >= 7 && !achievements[1].isUnlocked {
            achievements[1].isUnlocked = true
            defaults.set(true, forKey: "acls_ach_streak_7")
        }
        
        if currentStreak >= 30 && !achievements[2].isUnlocked {
            achievements[2].isUnlocked = true
            defaults.set(true, forKey: "acls_ach_streak_30")
        }
        
        if questionsAnswered >= 100 && !achievements[4].isUnlocked {
            achievements[4].isUnlocked = true
            defaults.set(true, forKey: "acls_ach_hundred_q")
        }
        
        let allTouched = topicProgress.allSatisfy { $0.questionsAnswered > 0 }
        if allTouched && !achievements[5].isUnlocked {
            achievements[5].isUnlocked = true
            defaults.set(true, forKey: "acls_ach_all_topics")
        }
        
        if overallReadiness >= 84 && !achievements[6].isUnlocked {
            achievements[6].isUnlocked = true
            defaults.set(true, forKey: "acls_ach_exam_pass")
        }
        
        if overallReadiness >= 95 && !achievements[7].isUnlocked {
            achievements[7].isUnlocked = true
            defaults.set(true, forKey: "acls_ach_ace")
        }
    }
    
    // MARK: - Explanation
    
    private func loadExplanation() {
        guard let question = currentQuestion else { return }

        let staticExplanation = bridge.richExplanationText(for: question, userAnswerID: selectedAnswerID)
        explanationText = staticExplanation
        showExplanation = true
        hasRequestedLucaCoaching = false
    }

    /// User-triggered Luca AI coaching - called when user taps "Ask Luca" button
    func requestLucaCoaching() {
        guard let question = currentQuestion, !hasRequestedLucaCoaching else { return }
        hasRequestedLucaCoaching = true
        enhanceWithAI(question: question, staticExplanation: explanationText)
    }

    private func enhanceWithAI(question: ACLSQuestion, staticExplanation: String) {
        isLoadingExplanation = true
        
        Task {
            do {
                let enhanced = try await generateAIEnhancement(question: question, baseExplanation: staticExplanation)
                await MainActor.run {
                    self.explanationText = enhanced
                    self.isLoadingExplanation = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingExplanation = false
                    self.explanationText = staticExplanation + "\n\n⚠️ AI coaching unavailable. Check your connection."
                    AppLogger.error("AI explanation failed: \(error)")
                }
            }
        }
    }
    
    private func generateAIEnhancement(question: ACLSQuestion, baseExplanation: String) async throws -> String {
        let userAnswerText = question.choices.first(where: { $0.id == selectedAnswerID })?.text ?? "Unknown"
        let correctAnswerText = question.correctChoice?.text ?? "Unknown"
        
        let prompt = """
        You are Luca, an AI clinical coach in CriticalMed. Speak like a calm, confident senior clinician who has seen this scenario many times. No drama, no hedging—just grounded guidance.

        QUESTION: \(question.stem)
        USER'S ANSWER: \(userAnswerText)
        CORRECT ANSWER: \(correctAnswerText)
        RESULT: \(isCorrect ? "CORRECT" : "INCORRECT")

        EXISTING EXPLANATION:
        \(baseExplanation)

        Add brief coaching (2-3 short paragraphs max):
        - If correct: reinforce their clinical reasoning in one line, then add one practical bedside tip
        - If incorrect: calmly clarify the key distinction they missed—no lecturing
        - End with a single confident takeaway that sticks

        Style: Short sentences. Plain language. Focus on what changes management. Make them feel calmer and more capable, not overwhelmed.
        """
        
        let aiService = AIService.shared
        let result = await aiService.query(prompt, useCase: .educationalDeepDive)
        
        switch result {
        case .success(let response):
            return baseExplanation + "\n\n---\n\n💡 **Luca AI Coaching**\n\n" + response.content
        case .failure:
            return baseExplanation
        }
    }
    
    // MARK: - Navigation
    
    func nextQuestion() {
        guard sessionIndex < sessionQuestions.count - 1 else { return }
        
        let nextIndex = sessionIndex + 1
        
        // Check if user can access next question (free users limited)
        if !ContentAccessManager.shared.hasFullAccess && nextIndex >= ContentAccessManager.freeACLSQuestionCount {
            // Free user trying to access premium questions
            shouldShowUpgradePrompt = true
            return
        }
        
        sessionIndex = nextIndex
        currentQuestion = sessionQuestions[sessionIndex]
        selectedAnswerID = nil
        hasSubmitted = false
        isCorrect = false
        explanationText = ""
        showExplanation = false
        questionStartTime = Date()
    }
    
    /// Dismiss the upgrade prompt
    func dismissUpgradePrompt() {
        shouldShowUpgradePrompt = false
    }
    
    var isLastQuestion: Bool {
        sessionIndex >= sessionQuestions.count - 1
    }
    
    var sessionProgress: Double {
        guard !sessionQuestions.isEmpty else { return 0 }
        return Double(sessionIndex + 1) / Double(sessionQuestions.count)
    }
    
    var sessionPercentage: Int {
        guard sessionQuestions.count > 0 else { return 0 }
        return (sessionCorrectCount * 100) / max(1, sessionIndex + (hasSubmitted ? 1 : 0))
    }
    
    // MARK: - Review Modes
    
    func startMissedQuestionsReview() {
        startSession(mode: .review, topic: nil)
    }
    
    func startSpacedRepetitionSession() {
        startSession(mode: .spacedRepetition, topic: nil)
    }
}

// MARK: - Quiz Mode

enum QuizMode {
    case practice
    case exam
    case topicDrill
    case review
    case spacedRepetition
    case megacode  // Complex multi-step clinical scenarios
}

// MARK: - QuizTopic

struct QuizTopic: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    var mastery: Int
    var questionsAnswered: Int
    var totalQuestions: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: QuizTopic, rhs: QuizTopic) -> Bool {
        lhs.id == rhs.id
    }
    
    var masteryColor: Color {
        switch mastery {
        case 84...100: return .green
        case 70..<84: return .orange
        default: return .red
        }
    }
}

// MARK: - QuizAchievement

struct QuizAchievement: Identifiable {
    let id: String
    let name: String
    let icon: String
    var isUnlocked: Bool
}
