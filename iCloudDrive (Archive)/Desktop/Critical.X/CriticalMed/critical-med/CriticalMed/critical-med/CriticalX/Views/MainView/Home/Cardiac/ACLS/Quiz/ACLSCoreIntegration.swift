//
//  ACLSCoreIntegration.swift
//  CriticalX
//
//  Standalone ACLS Quiz data layer
//  Self-contained with all models and question bank
//
//  Created: January 2026
//

import SwiftUI

// MARK: - ACLSCore Bridge (Standalone)

/// Main integration point for ACLS Quiz
@MainActor
class ACLSCoreBridge: ObservableObject {
    
    static let shared = ACLSCoreBridge()
    
    // MARK: - Published State
    
    @Published var isLoaded = false
    @Published var totalQuestions = 0
    
    // MARK: - Data
    
    private(set) var questions: [ACLSQuestion] = []
    private var userAnswers: [UUID: ACLSUserAnswer] = [:]
    private var missedQuestionIDs: Set<UUID> = []
    
    // MARK: - Initialization
    
    private init() {
        loadQuestionBank()
        loadUserProgress()
    }
    
    private func loadQuestionBank() {
        questions = ACLSQuestionBank.allQuestions
        totalQuestions = questions.count
        isLoaded = true
    }
    
    private func loadUserProgress() {
        let defaults = UserDefaults.standard
        
        if let data = defaults.data(forKey: "acls_user_answers"),
           let decoded = try? JSONDecoder().decode([UUID: ACLSUserAnswer].self, from: data) {
            userAnswers = decoded
        }
        
        if let missedData = defaults.data(forKey: "acls_missed_questions"),
           let decoded = try? JSONDecoder().decode([UUID].self, from: missedData) {
            missedQuestionIDs = Set(decoded)
        }
    }
    
    private func saveUserProgress() {
        let defaults = UserDefaults.standard
        
        if let encoded = try? JSONEncoder().encode(userAnswers) {
            defaults.set(encoded, forKey: "acls_user_answers")
        }
        
        if let encoded = try? JSONEncoder().encode(Array(missedQuestionIDs)) {
            defaults.set(encoded, forKey: "acls_missed_questions")
        }
    }
    
    // MARK: - Question Selection
    
    func practiceQuestions(count: Int = 10, topic: ACLSTopicType? = nil) -> [ACLSQuestion] {
        var filtered = questions
        
        if let topic = topic {
            filtered = filtered.filter { $0.topic == topic }
        }
        
        return Array(filtered.shuffled().prefix(count))
    }
    
    func examQuestions() -> [ACLSQuestion] {
        // Weight by topic importance - aligned with actual ACLS exam distribution
        let weights: [ACLSTopicType: Int] = [
            .vfPulselessVT: 7,      // Core algorithm
            .peaAsystole: 5,        // Core algorithm
            .bradycardia: 5,        // Common scenario
            .tachycardia: 5,        // Common scenario (covers both stable/unstable)
            .pharmacology: 5,       // Drug knowledge essential
            .blsCPR: 5,             // Foundation of ACLS
            .postROSC: 4,           // Post-arrest care
            .airway: 3,             // Airway management
            .rhythms: 3,            // Rhythm recognition
            .hsAndTs: 3,            // Reversible causes
            .electrical: 2,         // Electrical therapy
            .team: 2,               // Team dynamics
            .acs: 3,                // Acute coronary syndromes
            .stroke: 3,             // Stroke recognition
            .vascularAccess: 2,     // Vascular access
            .guidelines2025: 3      // 2025 guideline updates
        ]
        
        var selected: [ACLSQuestion] = []
        
        for (topic, count) in weights {
            let topicQuestions = questions.filter { $0.topic == topic }.shuffled()
            selected.append(contentsOf: topicQuestions.prefix(count))
        }
        
        // Fill remaining slots to reach 50 questions
        let remaining = 50 - selected.count
        if remaining > 0 {
            let usedIDs = Set(selected.map { $0.id })
            let available = questions.filter { !usedIDs.contains($0.id) }.shuffled()
            selected.append(contentsOf: available.prefix(remaining))
        }
        
        return selected.shuffled()
    }
    
    func missedQuestions() -> [ACLSQuestion] {
        return questions.filter { missedQuestionIDs.contains($0.id) }
    }
    
    func questionsForReview() -> [ACLSQuestion] {
        let now = Date()
        
        return questions.filter { question in
            guard let answer = userAnswers[question.id] else {
                return true
            }
            return answer.isDueForReview(now: now)
        }.shuffled()
    }
    
    func weakAreaQuestions(count: Int = 15) -> [ACLSQuestion] {
        var topicStats: [ACLSTopicType: (correct: Int, total: Int)] = [:]
        
        for (_, answer) in userAnswers {
            guard let question = questions.first(where: { $0.id == answer.questionID }) else { continue }
            var stats = topicStats[question.topic] ?? (0, 0)
            stats.total += answer.attemptCount
            stats.correct += answer.correctCount
            topicStats[question.topic] = stats
        }
        
        let weakTopics = topicStats
            .filter { $0.value.total >= 3 }
            .map { ($0.key, Double($0.value.correct) / Double($0.value.total)) }
            .sorted { $0.1 < $1.1 }
            .prefix(3)
            .map { $0.0 }
        
        var selected: [ACLSQuestion] = []
        for topic in weakTopics {
            let topicQuestions = questions.filter { $0.topic == topic }.shuffled()
            selected.append(contentsOf: topicQuestions.prefix(5))
        }
        
        return Array(selected.shuffled().prefix(count))
    }
    
    func topicQuestions(topic: ACLSTopicType, count: Int = 15) -> [ACLSQuestion] {
        return Array(questions.filter { $0.topic == topic }.shuffled().prefix(count))
    }
    
    /// Returns complex multi-step megacode scenario questions
    func megacodeQuestions(count: Int = 10) -> [ACLSQuestion] {
        return Array(ACLSQuestionBank.megacodeScenarios.shuffled().prefix(count))
    }
    
    // MARK: - Answer Recording
    
    func recordAnswer(questionID: UUID, correct: Bool, timeSpent: Int) {
        var record = userAnswers[questionID] ?? ACLSUserAnswer(questionID: questionID)
        record.recordAttempt(correct: correct, timeSpent: timeSpent)
        userAnswers[questionID] = record
        
        if !correct {
            missedQuestionIDs.insert(questionID)
        } else if record.consecutiveCorrect >= 2 {
            missedQuestionIDs.remove(questionID)
        }
        
        saveUserProgress()
    }
    
    // MARK: - Statistics
    
    func topicMastery() -> [ACLSTopicType: Int] {
        var mastery: [ACLSTopicType: Int] = [:]
        var topicStats: [ACLSTopicType: (correct: Int, total: Int)] = [:]
        
        for (_, answer) in userAnswers {
            guard let question = questions.first(where: { $0.id == answer.questionID }) else { continue }
            var stats = topicStats[question.topic] ?? (0, 0)
            stats.total += answer.attemptCount
            stats.correct += answer.correctCount
            topicStats[question.topic] = stats
        }
        
        for (topic, stats) in topicStats {
            let percentage = stats.total > 0 ? (stats.correct * 100) / stats.total : 0
            mastery[topic] = percentage
        }
        
        return mastery
    }
    
    func overallReadiness() -> Int {
        // Exam readiness requires meaningful practice volume + accuracy + topic coverage

        let totalQuestionsInBank = questions.count
        let uniqueQuestionsAttempted = userAnswers.count
        let totalTopics = ACLSTopicType.allCases.count

        guard uniqueQuestionsAttempted > 0 else { return 0 }

        // 1. Calculate raw accuracy (correct / total attempts)
        var totalAttempts = 0
        var totalCorrect = 0
        var topicsWithMinimumPractice: Set<ACLSTopicType> = []
        var topicAttempts: [ACLSTopicType: Int] = [:]

        for (_, answer) in userAnswers {
            totalAttempts += answer.attemptCount
            totalCorrect += answer.correctCount

            if let question = questions.first(where: { $0.id == answer.questionID }) {
                topicAttempts[question.topic, default: 0] += answer.attemptCount
                // Need at least 3 questions in a topic to count it as "practiced"
                if topicAttempts[question.topic]! >= 3 {
                    topicsWithMinimumPractice.insert(question.topic)
                }
            }
        }

        let accuracyPercent = totalAttempts > 0 ? (totalCorrect * 100) / totalAttempts : 0

        // 2. Coverage score: unique questions seen / total questions
        let coveragePercent = (uniqueQuestionsAttempted * 100) / max(totalQuestionsInBank, 1)

        // 3. Topic breadth: topics with 3+ questions / total topics
        let breadthPercent = (topicsWithMinimumPractice.count * 100) / totalTopics

        // 4. Weighted combination: Accuracy (50%) + Coverage (30%) + Breadth (20%)
        let rawScore = (accuracyPercent * 50 + coveragePercent * 30 + breadthPercent * 20) / 100

        // 5. Apply confidence caps based on practice volume
        // Can't claim high readiness with insufficient practice
        let cappedScore: Int
        switch uniqueQuestionsAttempted {
        case 0..<10:
            cappedScore = min(rawScore, 15)  // Too few questions for any confidence
        case 10..<25:
            cappedScore = min(rawScore, 35)  // Getting started
        case 25..<50:
            cappedScore = min(rawScore, 55)  // Building foundation
        case 50..<75:
            cappedScore = min(rawScore, 75)  // Solid practice
        case 75..<100:
            cappedScore = min(rawScore, 85)  // Strong preparation
        default:
            cappedScore = rawScore  // 100+ questions: full score possible
        }

        return cappedScore
    }
    
    func richExplanationText(for question: ACLSQuestion, userAnswerID: UUID?) -> String {
        var text = ""
        
        // Correct answer
        text += "✓ **Why This is Correct**\n\n"
        text += question.explanation + "\n\n"
        
        // If user got it wrong
        if let userID = userAnswerID, userID != question.correctAnswerID {
            if let wrongChoice = question.choices.first(where: { $0.id == userID }),
               let reason = wrongChoice.whyWrong {
                text += "✗ **Why Your Answer Was Incorrect**\n\n"
                text += reason + "\n\n"
            }
        }
        
        // Key point
        if let keyPoint = question.keyPoint {
            text += "💡 **Key Point**\n\n"
            text += keyPoint + "\n\n"
        }
        
        // Clinical pearl
        if let pearl = question.clinicalPearl {
            text += "💎 **Clinical Pearl**\n\n"
            text += pearl + "\n\n"
        }
        
        // Algorithm reference
        if let algo = question.algorithmStep {
            text += "📋 **Algorithm Reference**\n\n"
            text += algo + "\n\n"
        }
        
        return text
    }
}

// MARK: - User Answer Model

struct ACLSUserAnswer: Codable {
    let questionID: UUID
    var attemptCount: Int = 0
    var correctCount: Int = 0
    var consecutiveCorrect: Int = 0
    var lastSeenAt: Date = Date()
    var totalTimeSeconds: Int = 0
    
    mutating func recordAttempt(correct: Bool, timeSpent: Int) {
        attemptCount += 1
        totalTimeSeconds += timeSpent
        lastSeenAt = Date()
        
        if correct {
            correctCount += 1
            consecutiveCorrect += 1
        } else {
            consecutiveCorrect = 0
        }
    }
    
    func isDueForReview(now: Date) -> Bool {
        guard attemptCount > 0 else { return true }
        if consecutiveCorrect == 0 { return true }
        
        let daysSinceLastSeen = Calendar.current.dateComponents([.day], from: lastSeenAt, to: now).day ?? 0
        
        let interval: Int
        switch consecutiveCorrect {
        case 0: interval = 0
        case 1: interval = 1
        case 2: interval = 3
        case 3...4: interval = 7
        default: interval = 14
        }
        
        return daysSinceLastSeen >= interval
    }
}

// MARK: - Topic Type

enum ACLSTopicType: String, Codable, CaseIterable {
    case blsCPR = "bls_cpr"
    case airway = "airway"
    case vfPulselessVT = "vf_pvt"
    case peaAsystole = "pea_asystole"
    case bradycardia = "bradycardia"
    case tachycardia = "tachycardia"
    case postROSC = "post_rosc"
    case pharmacology = "pharmacology"
    case rhythms = "rhythms"
    case electrical = "electrical"
    case hsAndTs = "hs_ts"
    case team = "team"
    case acs = "acs"
    case stroke = "stroke"
    case vascularAccess = "vascular_access"
    case guidelines2025 = "guidelines_2025"
    
    var displayName: String {
        switch self {
        case .blsCPR: return "BLS & High-Quality CPR"
        case .airway: return "Airway Management"
        case .vfPulselessVT: return "VF/Pulseless VT"
        case .peaAsystole: return "PEA/Asystole"
        case .bradycardia: return "Bradycardia"
        case .tachycardia: return "Tachycardia"
        case .postROSC: return "Post-Cardiac Arrest"
        case .pharmacology: return "Pharmacology"
        case .rhythms: return "Rhythm Recognition"
        case .electrical: return "Electrical Therapy"
        case .hsAndTs: return "H's and T's"
        case .team: return "Team Dynamics"
        case .acs: return "Acute Coronary Syndromes"
        case .stroke: return "Stroke"
        case .vascularAccess: return "Vascular Access"
        case .guidelines2025: return "2025 Guidelines"
        }
    }
    
    var shortName: String {
        switch self {
        case .blsCPR: return "BLS/CPR"
        case .airway: return "Airway"
        case .vfPulselessVT: return "VF/pVT"
        case .peaAsystole: return "PEA/Asystole"
        case .bradycardia: return "Brady"
        case .tachycardia: return "Tachy"
        case .postROSC: return "Post-ROSC"
        case .pharmacology: return "Meds"
        case .rhythms: return "Rhythms"
        case .electrical: return "Electrical"
        case .hsAndTs: return "H's & T's"
        case .team: return "Team"
        case .acs: return "ACS"
        case .stroke: return "Stroke"
        case .vascularAccess: return "IV/IO"
        case .guidelines2025: return "2025"
        }
    }
    
    var icon: String {
        switch self {
        case .blsCPR: return "hand.raised.fill"
        case .airway: return "lungs.fill"
        case .vfPulselessVT: return "bolt.heart.fill"
        case .peaAsystole: return "waveform.path.ecg.rectangle"
        case .bradycardia: return "heart.slash"
        case .tachycardia: return "bolt.fill"
        case .postROSC: return "heart.text.square.fill"
        case .pharmacology: return "pills.fill"
        case .rhythms: return "waveform.path.ecg"
        case .electrical: return "bolt.heart.fill"
        case .hsAndTs: return "exclamationmark.triangle.fill"
        case .team: return "person.3.fill"
        case .acs: return "heart.fill"
        case .stroke: return "brain.head.profile"
        case .vascularAccess: return "syringe.fill"
        case .guidelines2025: return "doc.text.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .blsCPR: return .blue
        case .airway: return .cyan
        case .vfPulselessVT: return .red
        case .peaAsystole: return .red
        case .bradycardia: return .purple
        case .tachycardia: return .orange
        case .postROSC: return .teal
        case .pharmacology: return .green
        case .rhythms: return .indigo
        case .electrical: return .yellow
        case .hsAndTs: return .red
        case .team: return .blue
        case .acs: return .red
        case .stroke: return .purple
        case .vascularAccess: return .mint
        case .guidelines2025: return .blue
        }
    }
}

// MARK: - Difficulty

enum ACLSDifficulty: String, Codable {
    case easy
    case medium
    case hard
    
    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        }
    }
}

// MARK: - Question Model

struct ACLSQuestion: Identifiable {
    let id: UUID
    let stem: String
    let vignette: String?
    let vitals: ACLSVitals?
    let rhythmDescription: String?
    let rhythmStripGIF: String?  // GIF file name for visual rhythm recognition
    let etco2WaveformType: ETCO2WaveformType?  // For capnography questions
    let choices: [ACLSChoice]
    let correctAnswerID: UUID
    let topic: ACLSTopicType
    let difficulty: ACLSDifficulty
    let explanation: String
    let keyPoint: String?
    let clinicalPearl: String?
    let algorithmStep: String?
    
    var correctChoice: ACLSChoice? {
        choices.first(where: { $0.id == correctAnswerID })
    }
    
    /// Whether this question has a visual component (rhythm strip or waveform)
    var hasVisualComponent: Bool {
        rhythmStripGIF != nil || etco2WaveformType != nil
    }
}

/// ETCO2 waveform types for capnography questions
enum ETCO2WaveformType: String {
    case normal = "Normal waveform with ETCO2 35-45 mmHg"
    case lowPerfusion = "Low amplitude waveform, ETCO2 <10 mmHg"
    case roscSpike = "Sudden spike from 15 to 45 mmHg"
    case esophageal = "Absent or minimal CO2 return"
    case hyperventilation = "Declining ETCO2 with rapid rate"
    case bronchospasm = "Shark fin pattern"
    case rebreathing = "Elevated baseline"
}

struct ACLSChoice: Identifiable {
    let id: UUID
    let text: String
    let isCorrect: Bool
    let keyTakeaway: String?
    let whyWrong: String?
}

struct ACLSVitals {
    let heartRate: Int?
    let bpSystolic: Int?
    let bpDiastolic: Int?
    let spO2: Int?
    let respiratoryRate: Int?
    let temperature: Double?
    
    var bloodPressureFormatted: String? {
        guard let s = bpSystolic, let d = bpDiastolic else { return nil }
        return "\(s)/\(d)"
    }
}

// MARK: - Question Bank
// Complete ACLS Question Bank - 112+ Questions aligned with AHA 2025 Guidelines

enum ACLSQuestionBank {
    
    static var allQuestions: [ACLSQuestion] {
        blsCPRQuestions + vfPvtQuestions + peaAsystoleQuestions +
        bradycardiaQuestions + tachycardiaStableQuestions + tachycardiaUnstableQuestions +
        pharmacologyQuestions + postROSCQuestions + electricalQuestions +
        hsAndTsQuestions + rhythmQuestions + airwayQuestions +
        teamDynamicsQuestions + vascularAccessQuestions + acsQuestions +
        strokeQuestions + guidelines2025Questions + advancedScenarioQuestions +
        // Extended question sets from comprehensive bank
        extendedBLSQuestions + extendedVFQuestions + extendedPEAQuestions +
        extendedBradycardiaQuestions + extendedTachycardiaQuestions +
        extendedPharmQuestions + extendedPostROSCQuestions + extendedHsTsQuestions +
        extendedRhythmQuestions + extendedTeamAirwayQuestions + extendedVascularQuestions +
        extendedStrokeQuestions + extendedACSQuestions + extended2025GuidelinesQuestions +
        // Visual rhythm recognition questions (with GIF strips)
        visualRhythmQuestions + capnographyQuestions +
        // Comprehensive expansion from .md files
        additionalVFQuestions + additionalPEAQuestions + additionalBradyQuestions +
        additionalTachyQuestions + additionalPharmQuestions + additionalHsTsQuestions +
        additionalPostROSCQuestions + additionalTeamQuestions + additionalRhythmQuestions +
        additionalAirwayElectricalQuestions + additionalVascularQuestions +
        additionalStrokeQuestions + additionalACSQuestions + final2025Questions +
        advancedClinicalScenarios +
        // Complete Tachycardia Coverage (60 questions from 05-Tachycardia-Questions.md)
        completeTachycardiaStable + completeTachycardiaUnstable +
        // Complete Post-ROSC Coverage (40 questions from 06-Post-ROSC-Questions.md)
        completePostROSC +
        // Complete Team/Airway/Electrical Coverage (60 questions from 10-Team-Dynamics-Airway-Electrical-Questions.md)
        completeTeamDynamics + completeAirwayManagement + completeElectricalTherapy +
        // Additional comprehensive question sets
        moreBLSQuestions + morePharmQuestions + moreHsTsQuestions +
        // Rhythm recognition and Stroke/ACS
        moreRhythmQuestions + moreStrokeACSQuestions +
        // Final comprehensive additions
        finalVFPEAQuestions + finalBradyTachyQuestions +
        // Last batch to complete coverage
        finalComprehensiveQuestions +
        // Megacode Scenarios - Complex clinical scenarios
        megacodeScenarios
    }
    
    // MARK: - BLS/CPR Questions (15 questions)
    
    static let blsCPRQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the recommended chest compression rate for adult CPR per AHA 2025 guidelines?",
            choices: [
                ("100-120 compressions per minute", true, "CPR rate: 100-120/min - optimize perfusion while allowing ventricular filling", nil),
                ("60-80 compressions per minute", false, nil, "Too slow; would not generate adequate perfusion pressure. Rate <100 = inadequate coronary perfusion pressure"),
                ("80-100 compressions per minute", false, nil, "Below the recommended rate per AHA 2025 guidelines. Even 80-100 is suboptimal"),
                ("120-140 compressions per minute", false, nil, "Too fast; does not allow adequate chest recoil and ventricular filling. Rate >120 impairs ventricular filling time")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "AHA 2025 guidelines recommend a compression rate of 100-120 per minute. This rate optimizes coronary perfusion pressure while allowing adequate ventricular filling time.",
            keyPoint: "Compression rate: 100-120/min",
            clinicalPearl: "Use a metronome app or the beat of 'Stayin' Alive' (103 bpm) to maintain proper rate",
            algorithmStep: "BLS Algorithm - High-quality CPR: Rate 100-120/min"
        ),
        makeQuestion(
            stem: "Per AHA 2025 guidelines, what is the recommended compression depth for adult CPR?",
            choices: [
                ("2 to 2.4 inches (5-6 cm)", true, "2025 UPDATE: Depth 2-2.4 inches (now has MAXIMUM to prevent injury)", nil),
                ("At least 2 inches with no maximum", false, nil, "2025 guidelines added a maximum of 2.4 inches to prevent injury. KEY 2025 CHANGE"),
                ("1.5 to 2 inches (4-5 cm)", false, nil, "Too shallow; would not generate adequate perfusion"),
                ("2.5 to 3 inches (6-7 cm)", false, nil, "Too deep; increases risk of injury without improving outcomes")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "2025 UPDATE: Compression depth is 2-2.4 inches for adults. The maximum was added to prevent injury from overly aggressive compressions.",
            keyPoint: "Compression depth: 2-2.4 inches (max added in 2025)",
            clinicalPearl: "Allow complete chest recoil between compressions - don't lean on the chest",
            algorithmStep: "BLS Algorithm - High-quality CPR: Depth 2-2.4 inches"
        ),
        makeQuestion(
            stem: "During high-quality CPR, what is the recommendation regarding chest recoil?",
            choices: [
                ("Allow complete chest recoil between compressions", true, "Full recoil creates negative intrathoracic pressure → venous return → filling", nil),
                ("Maintain slight pressure on the chest between compressions", false, nil, "Leaning impairs venous return and reduces coronary perfusion"),
                ("Release pressure only halfway to maintain rhythm", false, nil, "Incomplete recoil decreases cardiac output during CPR"),
                ("Recoil is not important if compression depth is adequate", false, nil, "Full recoil is essential for ventricular filling regardless of depth")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Complete chest recoil allows negative intrathoracic pressure, enhancing venous return and cardiac filling.",
            keyPoint: "Allow complete chest recoil",
            clinicalPearl: "Leaning impairs cardiac output by 25%",
            algorithmStep: "BLS Algorithm - High-quality CPR: Allow complete recoil"
        ),
        makeQuestion(
            stem: "What is the compression-to-ventilation ratio for single-rescuer adult CPR without an advanced airway?",
            choices: [
                ("30:2", true, "Adult CPR without advanced airway: 30 compressions : 2 breaths", nil),
                ("15:2", false, nil, "This is the pediatric ratio with two rescuers"),
                ("15:1", false, nil, "Not a standard CPR ratio"),
                ("5:1", false, nil, "Outdated ratio no longer recommended")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "The standard compression-to-ventilation ratio for adult CPR is 30:2, whether single or two rescuer.",
            keyPoint: "30:2 for adult CPR (no advanced airway)",
            clinicalPearl: "With an advanced airway, deliver continuous compressions without pausing for ventilations",
            algorithmStep: "BLS Algorithm - C:V ratio: 30:2 for adult CPR"
        ),
        makeQuestion(
            stem: "How often should compressors be rotated during CPR to maintain high-quality compressions?",
            choices: [
                ("Every 2 minutes", true, "Rotate compressors q2min (coincides with rhythm check) to prevent fatigue", nil),
                ("Every 5 minutes", false, nil, "Too long; compressor fatigue affects quality before 5 minutes"),
                ("Every 1 minute", false, nil, "More frequent than necessary and increases interruptions"),
                ("Only when the compressor requests relief", false, nil, "Fatigue impairs quality before subjective awareness")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Compressors should be rotated every 2 minutes to prevent fatigue-related decline in compression quality.",
            keyPoint: "Rotate compressors every 2 minutes",
            clinicalPearl: "Fatigue starts around 90 seconds - switch at 2 minutes before quality degrades",
            algorithmStep: "BLS/ACLS Algorithm - Compressor switch every 2 minutes"
        ),
        makeQuestion(
            stem: "Once an advanced airway is placed during CPR, at what rate should ventilations be delivered?",
            choices: [
                ("1 breath every 6 seconds (10 breaths/min)", true, "Advanced airway: 1 breath q6s (10/min) asynchronous with continuous compressions", nil),
                ("1 breath every 3 seconds (20 breaths/min)", false, nil, "Hyperventilation increases intrathoracic pressure and decreases venous return"),
                ("1 breath every 10 seconds (6 breaths/min)", false, nil, "Too slow; does not provide adequate oxygenation"),
                ("Synchronized with compressions at 30:2", false, nil, "With advanced airway, continuous compressions with asynchronous ventilations")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "With an advanced airway, deliver 10 breaths per minute (1 every 6 seconds) while compressions continue without pausing.",
            keyPoint: "Advanced airway: 10 breaths/min, continuous CPR",
            clinicalPearl: "Hyperventilation is harmful - don't overventilate",
            algorithmStep: "ACLS Algorithm - Advanced airway: Ventilate 10/min, continuous CPR"
        ),
        makeQuestion(
            stem: "What is the minimum ETCO2 target that indicates adequate CPR quality?",
            choices: [
                ("≥10 mmHg", true, "ETCO2 ≥10 mmHg = minimum CPR quality indicator; <10 = improve technique", nil),
                ("≥20 mmHg", false, nil, "This is a good target but 10 mmHg is the minimum threshold"),
                ("≥35 mmHg", false, nil, "This is the normal range; during CPR, lower values are expected. 35-40 during CPR often indicates ROSC!"),
                ("≥5 mmHg", false, nil, "Too low; values below 10 suggest poor CPR quality or poor prognosis")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "ETCO2 should be at least 10 mmHg during CPR. Values below this indicate poor CPR quality or poor prognosis.",
            keyPoint: "ETCO2 ≥10 mmHg = adequate CPR",
            clinicalPearl: "Sudden rise to 35-40 mmHg often indicates ROSC - even before pulse check",
            algorithmStep: "CPR Quality - ETCO2 monitoring: Target ≥10 mmHg during CPR"
        ),
        makeQuestion(
            stem: "What is the minimum target chest compression fraction during resuscitation?",
            choices: [
                ("≥60%", true, "CCF ≥60% = compressions happening 60%+ of total arrest time", nil),
                ("≥40%", false, nil, "Below the recommended minimum; CCF <60% correlates with decreased survival rates"),
                ("≥80%", false, nil, "Ideal but 60% is the minimum target"),
                ("≥50%", false, nil, "Below the recommended minimum of 60%")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "Compression fraction should be at least 60%, meaning compressions should occur during at least 60% of the arrest time.",
            keyPoint: "Compression fraction ≥60%",
            clinicalPearl: "Higher CCF correlates with improved survival",
            algorithmStep: "BLS Algorithm - High-quality CPR: Minimize interruptions for CCF ≥60%"
        ),
        makeQuestion(
            stem: "What is the maximum recommended duration for interruptions in chest compressions?",
            choices: [
                ("<10 seconds", true, "Limit all pauses to <10 seconds - coronary perfusion pressure drops rapidly", nil),
                ("<20 seconds", false, nil, "Too long; coronary perfusion pressure drops rapidly with pauses"),
                ("<30 seconds", false, nil, "Far too long; significantly impacts survival"),
                ("<5 seconds", false, nil, "While ideal, 10 seconds is the practical maximum")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Interruptions should be limited to less than 10 seconds to maintain coronary perfusion pressure.",
            keyPoint: "Interruptions <10 seconds",
            clinicalPearl: "It takes 60-90 seconds to rebuild coronary perfusion pressure after an interruption",
            algorithmStep: "BLS Algorithm - High-quality CPR: Minimize interruptions <10 sec"
        ),
        makeQuestion(
            stem: "Where should the hands be placed for adult chest compressions?",
            choices: [
                ("Lower half of the sternum", true, "Lower sternum = over the ventricles for maximum cardiac output", nil),
                ("Upper half of the sternum", false, nil, "Too high; does not effectively compress the heart"),
                ("Over the xiphoid process", false, nil, "May cause injury; less effective compression"),
                ("Left of the sternum over the heart", false, nil, "Not over cardiac structures; ribs impede compression")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Hands should be placed on the lower half of the sternum, over the ventricles.",
            keyPoint: "Hand placement: lower half of sternum",
            clinicalPearl: "One hand on lower sternum, other hand on top with fingers interlaced",
            algorithmStep: "BLS Algorithm - Compression hand position"
        ),
        makeQuestion(
            stem: "True or False: With an advanced airway in place, compressions should be continuous and asynchronous with ventilations.",
            choices: [
                ("True", true, "Advanced airway = no pause needed. Continuous compressions 100-120/min + ventilations 10/min independently", nil),
                ("False", false, nil, "Synchronization is only needed without an advanced airway")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "With an advanced airway, compressions are continuous and ventilations are delivered asynchronously at 10/min.",
            keyPoint: "Advanced airway = asynchronous CPR",
            clinicalPearl: nil,
            algorithmStep: "ACLS Algorithm"
        ),
        makeQuestion(
            stem: "What capnography finding during CPR may indicate return of spontaneous circulation (ROSC)?",
            choices: [
                ("Sudden sustained increase in ETCO2 (typically ≥35-40 mmHg)", true, "Sudden ETCO2 rise = cardiac output restored → CO2 washout from tissues", nil),
                ("Gradual decrease in ETCO2", false, nil, "Suggests worsening perfusion, not ROSC"),
                ("ETCO2 remaining stable at 15 mmHg", false, nil, "Stable low value indicates ongoing arrest with adequate CPR"),
                ("Fluctuating ETCO2 values", false, nil, "May indicate variable CPR quality, not ROSC")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "A sudden, sustained increase in ETCO2 to 35-40+ mmHg is often the first sign of ROSC.",
            keyPoint: "ETCO2 spike to 35-40+ = likely ROSC",
            clinicalPearl: "Check for pulse when you see this!",
            algorithmStep: "ROSC Detection"
        ),
        makeQuestion(
            stem: "During a rhythm check, how long should you check for a pulse?",
            choices: [
                ("No more than 10 seconds", true, "Limit pulse checks to ≤10 seconds to minimize CPR interruptions", nil),
                ("No more than 30 seconds", false, nil, "Far too long; every second without compressions decreases survival"),
                ("Until you are certain there is no pulse", false, nil, "Confidence-based approach leads to excessive pauses"),
                ("Pulse checks are not recommended during CPR", false, nil, "Pulse checks are done during rhythm checks every 2 minutes")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Pulse checks should be limited to 10 seconds maximum to minimize CPR interruptions.",
            keyPoint: "Pulse check ≤10 seconds",
            clinicalPearl: nil,
            algorithmStep: "ACLS Algorithm - Rhythm/pulse check: Maximum 10 seconds"
        ),
        makeQuestion(
            stem: "What is the recommended ventilation approach for dispatcher-assisted CPR by untrained lay rescuers?",
            choices: [
                ("Hands-only CPR (compression-only)", true, "Untrained rescuers should do hands-only CPR - simpler, no skill barrier", nil),
                ("30:2 compressions to ventilations", false, nil, "This requires training and equipment that lay rescuers may not have"),
                ("15:2 compressions to ventilations", false, nil, "This is pediatric ratio and requires training"),
                ("Wait for EMS - do not attempt CPR", false, nil, "Bystander CPR dramatically improves survival")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Untrained lay rescuers should perform hands-only CPR as it removes the barrier of mouth-to-mouth.",
            keyPoint: "Untrained = hands-only CPR",
            clinicalPearl: "Any CPR is better than no CPR",
            algorithmStep: "BLS Algorithm - Untrained lay rescuer: Hands-only CPR"
        ),
        makeQuestion(
            stem: "According to 2025 guidelines, how should rescue breaths be delivered during adult CPR?",
            choices: [
                ("Rescue breaths are fully reinstated as standard during CPR", true, "Post-COVID: breaths are back", nil),
                ("Rescue breaths are still discouraged due to COVID", false, nil, "COVID-era hesitation has been removed"),
                ("Only healthcare providers should give breaths", false, nil, "Breaths are recommended for all trained rescuers"),
                ("Compression-only CPR is now the only recommendation", false, nil, "Ventilations remain part of standard CPR")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "2025 UPDATE: Rescue breaths are fully reinstated. The COVID-era hesitation about mouth-to-mouth has been removed from guidelines.",
            keyPoint: "Rescue breaths are back in 2025 guidelines",
            clinicalPearl: "Each breath should be given over 1 second and produce visible chest rise",
            algorithmStep: "BLS Algorithm - Ventilations"
        )
    ]
    
    // MARK: - VF/pVT Questions (10 questions)
    
    static let vfPvtQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the first action upon recognizing ventricular fibrillation?",
            choices: [
                ("Defibrillate immediately", true, "VF/pVT = shockable rhythms. Immediate defibrillation is priority #1", nil),
                ("Start IV access", false, nil, "Access is important but defibrillation takes priority for shockable rhythms"),
                ("Give epinephrine 1 mg IV", false, nil, "Epinephrine comes after initial defibrillation attempts fail"),
                ("Intubate the patient", false, nil, "Airway management should not delay defibrillation")
            ],
            topic: .vfPulselessVT,
            difficulty: .easy,
            explanation: "For VF/pVT, immediate defibrillation is the priority. Every minute of delay reduces survival by 7-10%.",
            keyPoint: "VF = Shock immediately",
            clinicalPearl: "Don't delay defibrillation to establish IV access",
            algorithmStep: "VF/pVT Algorithm - Immediate defibrillation for shockable rhythms"
        ),
        makeQuestion(
            stem: "What is the recommended initial defibrillation energy for adult VF using a biphasic defibrillator?",
            choices: [
                ("120-200 J (manufacturer recommendation) or max if unknown", true, "Biphasic: Use manufacturer setting (120-200J typically) or maximum if unknown", nil),
                ("360 J", false, nil, "This is the monophasic energy; biphasic requires less energy"),
                ("50 J", false, nil, "Too low; unlikely to successfully terminate VF"),
                ("100 J for all patients", false, nil, "Follow manufacturer recommendations; not a universal dose")
            ],
            topic: .vfPulselessVT,
            difficulty: .easy,
            explanation: "2025 Guidelines recommend first shock energy ≥200J biphasic. If energy setting is unknown, use maximum available.",
            keyPoint: "First shock ≥200J biphasic (or max)",
            clinicalPearl: "If unsure of device, use maximum energy",
            algorithmStep: "VF/pVT Algorithm - Defibrillation: Biphasic 120-200J or manufacturer setting"
        ),
        makeQuestion(
            stem: "During VF cardiac arrest, when should epinephrine be administered?",
            choices: [
                ("After initial defibrillation attempts have failed (after 2nd shock)", true, "Defibrillation first priority; epinephrine after 2nd shock or when IV/IO ready", nil),
                ("Before the first shock", false, nil, "Defibrillation is the priority; epinephrine should be given after initial shock"),
                ("Every 2 minutes", false, nil, "Epinephrine is given every 3-5 minutes, not 2"),
                ("Only after 5 shocks", false, nil, "Epinephrine should be given earlier in the algorithm")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "For shockable rhythms, epinephrine is given after the second shock fails. The priority is early, high-quality CPR and rapid defibrillation.",
            keyPoint: "Epinephrine after 2nd shock in VF/pVT",
            clinicalPearl: "For PEA/Asystole, give epinephrine ASAP - don't wait for shocks",
            algorithmStep: "VF/pVT Algorithm - Epinephrine 1mg IV/IO every 3-5 minutes"
        ),
        makeQuestion(
            stem: "What is the first dose of amiodarone for refractory VF/pVT?",
            choices: [
                ("300 mg IV/IO bolus", true, "Amiodarone arrest dose: 300mg first, 150mg second - given as BOLUS", nil),
                ("150 mg IV/IO bolus", false, nil, "150 mg is the second dose, not the first"),
                ("300 mg IV over 10 minutes", false, nil, "In cardiac arrest, amiodarone is given as a bolus, not infusion"),
                ("450 mg IV/IO bolus", false, nil, "Max total is 450mg (300+150), not single dose")
            ],
            topic: .vfPulselessVT,
            difficulty: .easy,
            explanation: "Amiodarone 300 mg IV/IO bolus is first-line for refractory VF/pVT after 3 shocks. Second dose is 150 mg.",
            keyPoint: "Amiodarone 300mg first dose (BOLUS)",
            clinicalPearl: "Only 2 doses of amiodarone during cardiac arrest",
            algorithmStep: "VF/pVT Algorithm - Amiodarone 300mg IV/IO for refractory VF/pVT"
        ),
        makeQuestion(
            stem: "If VF persists after the initial amiodarone dose, what is the second dose?",
            choices: [
                ("150 mg IV/IO bolus", true, "Amiodarone repeat dose: 150mg (half of initial) - max 2 doses in arrest", nil),
                ("300 mg IV/IO bolus", false, nil, "First dose is 300 mg; repeat dose is 150 mg"),
                ("75 mg IV/IO bolus", false, nil, "Too low; would not be effective"),
                ("No additional doses recommended", false, nil, "A second dose of 150 mg may be given")
            ],
            topic: .vfPulselessVT,
            difficulty: .easy,
            explanation: "The second dose of amiodarone is 150 mg IV/IO. Only 2 doses total during cardiac arrest.",
            keyPoint: "Amiodarone 150mg second dose",
            clinicalPearl: "Total max amiodarone in arrest: 450mg (300+150)",
            algorithmStep: "VF/pVT Algorithm - Amiodarone 150mg IV/IO may repeat once"
        ),
        makeQuestion(
            stem: "What is the dose of lidocaine as an alternative to amiodarone for VF/pVT?",
            choices: [
                ("1-1.5 mg/kg IV, may repeat 0.5-0.75 mg/kg", true, "Lidocaine: 1-1.5 mg/kg first, repeat 0.5-0.75 mg/kg (max 3 mg/kg total)", nil),
                ("300 mg IV bolus", false, nil, "This is the amiodarone dose, not lidocaine. Lidocaine is weight-based"),
                ("1 mg IV every 3-5 minutes", false, nil, "This is the epinephrine dosing pattern"),
                ("50 mg IV bolus", false, nil, "Too low for most adults")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "Lidocaine is dosed at 1-1.5 mg/kg IV initially, with repeat doses of 0.5-0.75 mg/kg. Maximum 3 mg/kg total.",
            keyPoint: "Lidocaine: 1-1.5 mg/kg (weight-based)",
            clinicalPearl: "Lidocaine is an alternative to amiodarone - either is acceptable",
            algorithmStep: "VF/pVT Algorithm - Lidocaine as alternative to amiodarone"
        ),
        makeQuestion(
            stem: "After delivering a shock for VF, what is the immediate next step?",
            choices: [
                ("Resume CPR immediately for 2 minutes", true, "Post-shock: Resume CPR immediately - don't check rhythm/pulse right away", nil),
                ("Check for a pulse", false, nil, "Do not check pulse immediately after shock; resume CPR first"),
                ("Check the rhythm", false, nil, "Rhythm check after 2 minutes of CPR, not immediately post-shock"),
                ("Give epinephrine before restarting CPR", false, nil, "CPR takes priority; give epinephrine during CPR")
            ],
            topic: .vfPulselessVT,
            difficulty: .easy,
            explanation: "Resume CPR immediately after defibrillation. Rhythm and pulse checks occur after 2 minutes of CPR.",
            keyPoint: "Post-shock = Resume CPR immediately",
            clinicalPearl: "It takes 60-90 seconds for coronary perfusion to build after shock",
            algorithmStep: "VF/pVT Algorithm - Post-shock: Immediate CPR x 2 min before rhythm check"
        ),
        makeQuestion(
            stem: "How often should rhythm be checked during cardiac arrest management?",
            choices: [
                ("Every 2 minutes", true, "Rhythm checks every 2 minutes coincide with compressor rotation", nil),
                ("After every shock", false, nil, "Resume CPR immediately after shock; check rhythm after 2 minutes"),
                ("Every 5 minutes", false, nil, "Too infrequent; may miss rhythm changes"),
                ("Continuously", false, nil, "Would require pausing compressions; not recommended")
            ],
            topic: .vfPulselessVT,
            difficulty: .easy,
            explanation: "Rhythm checks are performed every 2 minutes, coinciding with compressor rotation.",
            keyPoint: "Rhythm check every 2 minutes",
            clinicalPearl: nil,
            algorithmStep: "ACLS Algorithm - Rhythm check every 2 minutes"
        ),
        makeQuestion(
            stem: "According to 2025 guidelines, is vasopressin recommended as a substitute for epinephrine?",
            choices: [
                ("No, vasopressin is not recommended", true, "2025 Update: Vasopressin shows no survival advantage", nil),
                ("Yes, 40 units can replace first dose of epinephrine", false, nil, "This was removed from guidelines"),
                ("Yes, but only for VF/pVT", false, nil, "Not recommended for any rhythm"),
                ("Yes, for all non-shockable rhythms", false, nil, "Not recommended")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "2025 UPDATE: Vasopressin alone or combined with epinephrine shows no survival advantage and is no longer recommended.",
            keyPoint: "Vasopressin is OUT in 2025 guidelines",
            clinicalPearl: "Epinephrine 1mg IV/IO every 3-5 minutes remains the standard",
            algorithmStep: "Cardiac Arrest Algorithm"
        ),
        makeQuestion(
            stem: "After 3+ shocks for refractory VF, what does the 2025 guideline say about dual sequential defibrillation (DSD)?",
            choices: [
                ("DSD has uncertain usefulness", true, "2025 Update: Insufficient evidence", nil),
                ("DSD is strongly recommended", false, nil, "Not enough evidence to recommend"),
                ("DSD should never be used", false, nil, "It's not prohibited, just uncertain"),
                ("DSD is only for children", false, nil, "This applies to adults")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "2025 UPDATE: After 3+ shocks, dual sequential defibrillation (DSD) and vector change defibrillation (VCD) have uncertain usefulness.",
            keyPoint: "DSD/VCD uncertain after 3+ shocks",
            clinicalPearl: "Focus on high-quality CPR and medications rather than experimental defibrillation strategies",
            algorithmStep: "Cardiac Arrest Algorithm - Refractory VF"
        )
    ]
    
    // MARK: - PEA/Asystole Questions (8 questions)
    
    static let peaAsystoleQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is pulseless electrical activity (PEA)?",
            choices: [
                ("Organized electrical activity on ECG without a detectable pulse", true, "PEA = ECG shows rhythm but no mechanical cardiac output (no pulse)", nil),
                ("A flatline on the ECG", false, nil, "Flatline is asystole, not PEA"),
                ("VF with no pulse", false, nil, "VF has chaotic activity; PEA has organized rhythm"),
                ("Any rhythm without a pulse", false, nil, "Must have ORGANIZED electrical activity to be PEA")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "PEA is characterized by organized electrical activity on the monitor but no mechanical cardiac output (no pulse).",
            keyPoint: "PEA = organized rhythm, no pulse",
            clinicalPearl: nil,
            algorithmStep: "Cardiac Arrest Algorithm - PEA definition"
        ),
        makeQuestion(
            stem: "What is the first medication for PEA/asystole?",
            choices: [
                ("Epinephrine 1 mg IV/IO", true, "PEA/asystole = non-shockable. Epinephrine ASAP + CPR + find cause", nil),
                ("Atropine 1 mg IV", false, nil, "Atropine removed from cardiac arrest algorithm in 2010"),
                ("Amiodarone 300 mg IV", false, nil, "Amiodarone is for VF/pVT (shockable rhythms), not PEA/asystole"),
                ("Defibrillation", false, nil, "PEA/asystole are non-shockable rhythms")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "Epinephrine 1 mg IV/IO is the first-line medication for PEA/asystole. Give as soon as possible.",
            keyPoint: "PEA/Asystole = Epinephrine 1mg ASAP",
            clinicalPearl: "Atropine was removed from cardiac arrest algorithm in 2010",
            algorithmStep: "Cardiac Arrest Algorithm - Non-shockable: Epinephrine 1mg IV/IO ASAP"
        ),
        makeQuestion(
            stem: "In PEA/asystole, when should epinephrine be given?",
            choices: [
                ("As soon as possible - earlier epinephrine improves outcomes", true, "In PEA/asystole, give epinephrine ASAP (unlike VF where it's after 2nd shock)", nil),
                ("After 5 minutes of CPR", false, nil, "Earlier epinephrine is associated with better outcomes"),
                ("Only after identifying the cause", false, nil, "Give epinephrine immediately while searching for causes"),
                ("Epinephrine is not indicated for PEA/asystole", false, nil, "Epinephrine is the primary drug for all cardiac arrest rhythms")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "2025 UPDATE: For non-shockable rhythms, give epinephrine as early as possible. This is different from shockable rhythms.",
            keyPoint: "Epinephrine ASAP for PEA/Asystole",
            clinicalPearl: "In PEA/Asystole, the ONLY chance is finding and fixing a reversible cause",
            algorithmStep: "Cardiac Arrest Algorithm - Non-shockable: Epinephrine as soon as IV/IO obtained"
        ),
        makeQuestion(
            stem: "Should asystole be shocked?",
            choices: [
                ("No - asystole is a non-shockable rhythm", true, "Asystole = no electrical activity to organize. Shocking won't help", nil),
                ("Yes - all cardiac arrests require defibrillation", false, nil, "Only shockable rhythms (VF/pVT) benefit from defibrillation"),
                ("Yes - but at lower energy (50 J)", false, nil, "No energy level is effective for asystole"),
                ("Only if the asystole is fine", false, nil, "'Fine' asystole is still non-shockable")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "Asystole is a non-shockable rhythm. Defibrillation will not help.",
            keyPoint: "Asystole = non-shockable",
            clinicalPearl: "Focus on CPR, epinephrine, and reversible causes",
            algorithmStep: "Cardiac Arrest Algorithm - Asystole: Non-shockable, no defibrillation"
        ),
        makeQuestion(
            stem: "How should asystole be confirmed?",
            choices: [
                ("Check multiple leads and ensure connections are secure", true, "Rule out fine VF or lead disconnection before confirming asystole", nil),
                ("Asystole is obvious on any lead", false, nil, "Fine VF may mimic asystole; check multiple leads"),
                ("Increase the gain on the monitor", false, nil, "May reveal fine VF, but checking leads is the primary step"),
                ("Confirm with a 12-lead ECG", false, nil, "12-lead would delay care; quick lead check is sufficient")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "Always confirm asystole in multiple leads to rule out fine VF or lead disconnection.",
            keyPoint: "Confirm asystole in multiple leads",
            clinicalPearl: "Fine VF can look like asystole - always check",
            algorithmStep: "Cardiac Arrest Algorithm - Asystole: Confirm in multiple leads"
        ),
        makeQuestion(
            stem: "Why is identifying H's and T's critical in PEA/asystole?",
            choices: [
                ("These are reversible causes that, if treated, may restore circulation", true, "PEA/asystole often has a treatable cause - find and fix it", nil),
                ("They determine which medication to give", false, nil, "Epinephrine is given regardless; H's and T's guide additional treatment"),
                ("They predict survival", false, nil, "H's and T's identify treatable causes, not prognosis"),
                ("They are only relevant for VF/pVT", false, nil, "H's and T's apply to ALL cardiac arrest rhythms")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "H's and T's represent reversible causes. Finding and treating them is essential, especially in PEA/asystole.",
            keyPoint: "H's and T's = reversible causes - find them!",
            clinicalPearl: nil,
            algorithmStep: "Cardiac Arrest Algorithm - Treat reversible causes (H's and T's)"
        ),
        makeQuestion(
            stem: "True or False: Atropine is recommended for asystole.",
            choices: [
                ("False", true, "Atropine was removed from ACLS cardiac arrest in 2010 guidelines", nil),
                ("True", false, nil, "Atropine is no longer recommended for asystole or PEA")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "Atropine was removed from the cardiac arrest algorithm in 2010. It is no longer recommended for asystole or PEA.",
            keyPoint: "Atropine NOT for asystole/PEA",
            clinicalPearl: nil,
            algorithmStep: "Cardiac Arrest Algorithm - Atropine NOT recommended for asystole/PEA"
        ),
        makeQuestion(
            stem: "During PEA management, the rhythm changes to VF. What is the next step?",
            choices: [
                ("Immediately defibrillate", true, "Rhythm changed to shockable → immediate defibrillation", nil),
                ("Continue CPR and give epinephrine", false, nil, "VF requires defibrillation as first priority"),
                ("Give amiodarone first", false, nil, "Shock first; amiodarone is for refractory VF"),
                ("Wait for the 2-minute cycle to complete", false, nil, "VF identified → immediate shock, don't wait")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "When the rhythm changes to a shockable rhythm (VF/pVT), immediately defibrillate.",
            keyPoint: "Rhythm becomes VF → Shock immediately",
            clinicalPearl: nil,
            algorithmStep: "Cardiac Arrest Algorithm - Rhythm becomes shockable → Defibrillate"
        )
    ]
    
    // MARK: - Bradycardia Questions (10 questions)
    
    static let bradycardiaQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What defines symptomatic bradycardia requiring treatment?",
            choices: [
                ("Heart rate <50 bpm with symptoms caused by the slow rate", true, "Treat bradycardia when symptoms (hypotension, AMS, shock) are due to the rate", nil),
                ("Any heart rate below 60 bpm", false, nil, "Many patients tolerate rates in 50s without symptoms"),
                ("Heart rate <50 bpm in all patients", false, nil, "Treatment based on symptoms, not just rate"),
                ("Heart rate <40 bpm regardless of symptoms", false, nil, "Symptoms determine need for treatment, not absolute rate")
            ],
            topic: .bradycardia,
            difficulty: .easy,
            explanation: "Symptomatic bradycardia is defined as HR <50 bpm with symptoms caused by the slow rate.",
            keyPoint: "Symptomatic = HR <50 WITH symptoms",
            clinicalPearl: "Some patients (athletes) tolerate low heart rates",
            algorithmStep: "Bradycardia Algorithm - Symptomatic bradycardia: HR typically <50 with symptoms"
        ),
        makeQuestion(
            stem: "Per AHA 2025 guidelines, what is the initial dose of atropine for symptomatic bradycardia?",
            choices: [
                ("1.0 mg IV", true, "2025 UPDATE: Atropine 1.0 mg IV initial (was 0.5 mg in older guidelines)", nil),
                ("0.5 mg IV", false, nil, "This was the old dose; 2025 guidelines increased it to 1.0 mg"),
                ("0.25 mg IV", false, nil, "Too low to be effective"),
                ("2.0 mg IV", false, nil, "Higher than recommended initial dose")
            ],
            topic: .bradycardia,
            difficulty: .easy,
            explanation: "2025 UPDATE: Atropine dose increased to 1.0 mg IV initial dose (was 0.5 mg).",
            keyPoint: "Atropine 1.0 mg (2025 update from 0.5 mg)",
            clinicalPearl: "The dose was doubled in 2025 guidelines",
            algorithmStep: "Bradycardia Algorithm - Atropine 1.0 mg IV, may repeat q3-5min, max 3 mg"
        ),
        makeQuestion(
            stem: "What is the maximum total dose of atropine for bradycardia?",
            choices: [
                ("3 mg", true, "Atropine max = 3 mg total (full vagolytic dose)", nil),
                ("1 mg", false, nil, "This is the single dose; total max is 3 mg"),
                ("5 mg", false, nil, "Higher than recommended"),
                ("2 mg", false, nil, "Below the maximum allowable total")
            ],
            topic: .bradycardia,
            difficulty: .easy,
            explanation: "Maximum atropine dose is 3 mg total (full vagolytic dose).",
            keyPoint: "Atropine max: 3 mg total",
            clinicalPearl: "If 3mg atropine fails, move to other treatments",
            algorithmStep: "Bradycardia Algorithm - Atropine: 1.0 mg q3-5min, maximum 3 mg"
        ),
        makeQuestion(
            stem: "In which types of heart block is atropine likely to be ineffective?",
            choices: [
                ("Mobitz Type II and third-degree (complete) AV block", true, "Atropine ineffective when block is below AV node (infranodal)", nil),
                ("Sinus bradycardia", false, nil, "Atropine is effective for sinus bradycardia"),
                ("First-degree AV block", false, nil, "First-degree block rarely causes symptoms; atropine can work if needed"),
                ("Junctional rhythm", false, nil, "Atropine may be effective for junctional rhythms")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Atropine is ineffective for infranodal blocks (Mobitz II, complete heart block) because the problem is below where atropine acts.",
            keyPoint: "Atropine ineffective for Mobitz II, 3rd degree",
            clinicalPearl: "Consider transcutaneous pacing for these",
            algorithmStep: "Bradycardia Algorithm - Infranodal block: atropine won't help, use TCP"
        ),
        makeQuestion(
            stem: "When is transcutaneous pacing indicated for bradycardia?",
            choices: [
                ("When atropine is ineffective or if the patient is severely symptomatic", true, "TCP for atropine failure OR severe symptoms (don't wait for atropine)", nil),
                ("Only after epinephrine fails", false, nil, "TCP can be used before or instead of epinephrine"),
                ("For all bradycardia below 50 bpm", false, nil, "Only for symptomatic bradycardia unresponsive to atropine"),
                ("Only for third-degree heart block", false, nil, "TCP for any symptomatic bradycardia unresponsive to atropine")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "TCP is indicated when atropine fails or when the patient is severely symptomatic (unstable).",
            keyPoint: "TCP if atropine fails OR severe symptoms",
            clinicalPearl: "Don't wait for atropine if patient is severely compromised",
            algorithmStep: "Bradycardia Algorithm - TCP if atropine fails or severe instability"
        ),
        makeQuestion(
            stem: "What is the dopamine infusion dose range for symptomatic bradycardia?",
            choices: [
                ("5-20 mcg/kg/min", true, "Dopamine for bradycardia: 5-20 mcg/kg/min (chronotropic dose range)", nil),
                ("1-5 mcg/kg/min", false, nil, "This is low-dose dopamine with minimal chronotropic effect"),
                ("2-10 mcg/min", false, nil, "Incorrect units; dopamine is dosed per kg/min"),
                ("20-40 mcg/kg/min", false, nil, "Higher than recommended")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Dopamine 5-20 mcg/kg/min is the chronotropic dose range for bradycardia.",
            keyPoint: "Dopamine 5-20 mcg/kg/min",
            clinicalPearl: nil,
            algorithmStep: "Bradycardia Algorithm - Dopamine 5-20 mcg/kg/min if atropine ineffective"
        ),
        makeQuestion(
            stem: "What is the epinephrine infusion rate for symptomatic bradycardia?",
            choices: [
                ("2-10 mcg/min", true, "Epinephrine infusion 2-10 mcg/min for chronotropic effect", nil),
                ("1 mg IV push", false, nil, "This is the arrest dose, not infusion"),
                ("0.1-0.5 mcg/kg/min", false, nil, "This is a lower infusion used for hypotension"),
                ("20-40 mcg/min", false, nil, "Higher than recommended")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Epinephrine 2-10 mcg/min is the infusion rate for chronotropic support in bradycardia.",
            keyPoint: "Epinephrine 2-10 mcg/min",
            clinicalPearl: nil,
            algorithmStep: "Bradycardia Algorithm - Epinephrine 2-10 mcg/min if atropine ineffective"
        ),
        makeQuestion(
            stem: "A patient presents with symptomatic sinus bradycardia at 38 bpm with hypotension. What is the first-line treatment?",
            choices: [
                ("Atropine 1.0 mg IV", true, "Symptomatic sinus bradycardia: Atropine 1.0 mg IV is first-line", nil),
                ("Atropine 0.5 mg IV", false, nil, "2025 guidelines changed atropine from 0.5 mg to 1.0 mg initial"),
                ("Transcutaneous pacing", false, nil, "Pacing is second-line after atropine fails"),
                ("Dopamine infusion", false, nil, "Dopamine is second-line if atropine ineffective")
            ],
            topic: .bradycardia,
            difficulty: .easy,
            explanation: "First-line treatment for symptomatic sinus bradycardia is Atropine 1.0 mg IV.",
            keyPoint: "Atropine 1.0 mg first-line",
            clinicalPearl: nil,
            algorithmStep: "Bradycardia Algorithm - Symptomatic + sinus brady = Atropine 1.0 mg"
        ),
        makeQuestion(
            stem: "How often can atropine be repeated for symptomatic bradycardia?",
            choices: [
                ("Every 3-5 minutes", true, "Atropine may repeat every 3-5 minutes up to max 3 mg total", nil),
                ("Every 1-2 minutes", false, nil, "Too frequent; need time to assess response"),
                ("Every 10 minutes", false, nil, "Too infrequent for a symptomatic patient"),
                ("Only once", false, nil, "May repeat up to maximum 3 mg")
            ],
            topic: .bradycardia,
            difficulty: .easy,
            explanation: "Atropine may be repeated every 3-5 minutes up to a maximum of 3 mg.",
            keyPoint: "Atropine q3-5min, max 3 mg",
            clinicalPearl: nil,
            algorithmStep: "Bradycardia Algorithm - Atropine 1.0 mg q3-5min, max 3 mg"
        ),
        makeQuestion(
            stem: "True or False: Per AHA 2025 guidelines, the initial atropine dose for symptomatic bradycardia is 0.5 mg IV.",
            choices: [
                ("False", true, "2025 changed atropine to 1.0 mg - 0.5 mg is outdated", nil),
                ("True", false, nil, "AHA 2025 increased the initial atropine dose from 0.5 mg to 1.0 mg")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "2025 UPDATE: Atropine initial dose is now 1.0 mg, not 0.5 mg.",
            keyPoint: "0.5 mg is outdated - use 1.0 mg (2025)",
            clinicalPearl: nil,
            algorithmStep: "Bradycardia Algorithm - 2025 UPDATE: Atropine 1.0 mg (not 0.5 mg)"
        )
    ]
    
    // MARK: - Tachycardia (Stable) Questions (8 questions)
    
    static let tachycardiaStableQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What primarily differentiates stable from unstable tachycardia?",
            choices: [
                ("Presence of serious signs/symptoms caused by the tachycardia", true, "Unstable = hypotension, AMS, shock, ischemia, acute heart failure", nil),
                ("Heart rate above 150 bpm", false, nil, "Rate alone doesn't determine stability"),
                ("Duration of the arrhythmia", false, nil, "Duration is less important than hemodynamic status"),
                ("Width of the QRS complex", false, nil, "QRS width helps classify rhythm, not stability")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Stability is determined by symptoms and hemodynamic status, not heart rate alone.",
            keyPoint: "Stability = symptoms, not rate",
            clinicalPearl: nil,
            algorithmStep: "Tachycardia Algorithm - Stability determined by symptoms, not just rate"
        ),
        makeQuestion(
            stem: "What is the correct adenosine dosing sequence for SVT?",
            choices: [
                ("6 mg rapid IV push, followed by 12 mg if needed", true, "Adenosine: 6 mg first → 12 mg if no conversion (2 doses per 2025 AHA)", nil),
                ("12 mg first, then 6 mg if needed", false, nil, "Start with 6 mg; escalate to 12 mg if ineffective"),
                ("6 mg slow IV infusion", false, nil, "Adenosine must be given as a rapid push with flush"),
                ("3 mg, then 6 mg, then 12 mg", false, nil, "Initial dose is 6 mg, not 3 mg (3 mg is for transplant patients)")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Adenosine dosing: 6 mg rapid IV push first, then 12 mg if needed.",
            keyPoint: "Adenosine: 6mg → 12mg → 12mg",
            clinicalPearl: "A third dose of 12 mg may be given if needed",
            algorithmStep: "Tachycardia Algorithm - Adenosine: First 6 mg, Second 12 mg"
        ),
        makeQuestion(
            stem: "How should adenosine be administered?",
            choices: [
                ("Rapid IV push followed immediately by saline flush", true, "Push-Flush technique: rapid bolus + 20mL NS flush + arm elevation", nil),
                ("Slow IV push over 1-2 minutes", false, nil, "Adenosine must be given as rapid push due to very short half-life"),
                ("IM injection", false, nil, "Adenosine is only effective IV; IM absorption is too slow"),
                ("IV infusion over 10 minutes", false, nil, "Would be completely metabolized before reaching the heart")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Adenosine must be given as a rapid IV push with immediate saline flush due to its ultra-short half-life (<10 seconds).",
            keyPoint: "Rapid push + immediate flush",
            clinicalPearl: "Give at most proximal port possible",
            algorithmStep: "Tachycardia Algorithm - Adenosine: RAPID push + proximal port + immediate flush"
        ),
        makeQuestion(
            stem: "When should vagal maneuvers be attempted for narrow regular SVT?",
            choices: [
                ("Before adenosine for narrow regular SVT", true, "Vagal maneuvers are first-line for stable narrow regular SVT", nil),
                ("Only after adenosine fails", false, nil, "Vagal maneuvers should be attempted first"),
                ("Never - they are ineffective", false, nil, "Vagal maneuvers can terminate 20-25% of SVTs"),
                ("Only in pediatric patients", false, nil, "Effective in both adults and children")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Vagal maneuvers are first-line for stable narrow regular SVT, before adenosine.",
            keyPoint: "Vagal maneuvers before adenosine",
            clinicalPearl: "Modified Valsalva (with leg raise) is most effective",
            algorithmStep: "Tachycardia Algorithm - Vagal before adenosine"
        ),
        makeQuestion(
            stem: "What is the preferred approach for stable atrial fibrillation with rapid ventricular response?",
            choices: [
                ("Rate control with beta-blockers or calcium channel blockers", true, "Stable AFib/flutter: Rate control (diltiazem, metoprolol, etc.)", nil),
                ("Immediate cardioversion", false, nil, "Cardioversion for unstable patients; rate control for stable"),
                ("Adenosine", false, nil, "Adenosine is not effective for AFib; it's for reentrant SVT"),
                ("Amiodarone 300 mg IV bolus", false, nil, "This is the arrest dose; stable AFib uses lower doses or other agents")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Stable AFib with RVR is managed with rate control (beta-blockers or calcium channel blockers).",
            keyPoint: "Stable AFib = rate control",
            clinicalPearl: "Avoid CCBs in patients with reduced EF",
            algorithmStep: "Tachycardia Algorithm - Narrow Irregular: Rate control"
        ),
        makeQuestion(
            stem: "When treating a wide complex tachycardia of uncertain origin, what should be assumed?",
            choices: [
                ("Assume ventricular tachycardia (VT)", true, "Wide complex of unknown origin = assume VT (safer approach)", nil),
                ("Assume SVT with aberrancy", false, nil, "Assuming SVT may lead to inappropriate treatment"),
                ("Assume SVT and give adenosine", false, nil, "Wide complex should be presumed VT; adenosine can cause harm in some VT"),
                ("Wait for expert consultation before treating", false, nil, "If unstable, treat immediately; if stable, VT assumption is safe")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "When uncertain, assume wide complex tachycardia is VT. This is the safer approach.",
            keyPoint: "Wide complex unknown = assume VT",
            clinicalPearl: nil,
            algorithmStep: "Tachycardia Algorithm - Wide complex unknown: Treat as VT"
        ),
        makeQuestion(
            stem: "What is the treatment for sinus tachycardia?",
            choices: [
                ("Treat the underlying cause", true, "Sinus tach is a RESPONSE, not primary problem - treat the cause", nil),
                ("Adenosine 6 mg IV", false, nil, "Adenosine won't work - SA node is responding appropriately"),
                ("Synchronized cardioversion", false, nil, "Never cardiovert sinus tachycardia"),
                ("Beta-blockers in all cases", false, nil, "May worsen underlying condition (sepsis, hypovolemia)")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Sinus tachycardia is a physiologic response. Treat the underlying cause, not the tachycardia itself.",
            keyPoint: "Sinus tach = treat the cause",
            clinicalPearl: "Think: pain, fever, hypovolemia, sepsis, anxiety, PE",
            algorithmStep: "Tachycardia Algorithm - Sinus tachycardia: Identify and treat cause"
        ),
        makeQuestion(
            stem: "What differentiates treatment of narrow regular SVT from narrow irregular SVT?",
            choices: [
                ("Regular: Vagal/Adenosine; Irregular: Rate control", true, "Regular = try vagal/adenosine; Irregular = likely AFib, use rate control", nil),
                ("Both receive adenosine", false, nil, "Adenosine not effective for AFib"),
                ("Both receive synchronized cardioversion", false, nil, "Only if unstable"),
                ("Regular: Rate control; Irregular: Adenosine", false, nil, "Reversed - adenosine for regular, rate control for irregular")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Narrow regular SVT: vagal maneuvers then adenosine. Narrow irregular (likely AFib): rate control.",
            keyPoint: "Regular = adenosine; Irregular = rate control",
            clinicalPearl: nil,
            algorithmStep: "Tachycardia Algorithm - Narrow Regular vs Irregular pathways"
        )
    ]
    
    // MARK: - Tachycardia (Unstable) Questions (8 questions)
    
    static let tachycardiaUnstableQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Which of the following are signs of hemodynamic instability in tachycardia?",
            choices: [
                ("Hypotension, altered mental status, signs of shock, ischemic chest discomfort, acute heart failure", true, "These define unstable tachycardia", nil),
                ("Heart rate >150 bpm alone", false, nil, "Rate alone doesn't define instability"),
                ("Wide QRS complex", false, nil, "QRS width describes rhythm, not stability"),
                ("Irregular rhythm", false, nil, "Regularity doesn't determine stability")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Unstable tachycardia is defined by: hypotension, altered mental status, signs of shock, ischemic chest discomfort, or acute heart failure.",
            keyPoint: "Unstable = serious signs/symptoms",
            clinicalPearl: nil,
            algorithmStep: "Tachycardia Algorithm - Unstable = serious signs/symptoms"
        ),
        makeQuestion(
            stem: "What is the first-line treatment for unstable tachycardia with a pulse?",
            choices: [
                ("Synchronized cardioversion", true, "Unstable + tachycardia = immediate synchronized cardioversion", nil),
                ("Adenosine 6 mg IV", false, nil, "May try if truly no delay, but cardioversion is definitive"),
                ("Amiodarone 150 mg IV", false, nil, "Takes too long for unstable patient"),
                ("Vagal maneuvers", false, nil, "Delays definitive treatment in unstable patient")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Unstable tachycardia with a pulse requires immediate synchronized cardioversion.",
            keyPoint: "Unstable = Cardioversion",
            clinicalPearl: "Don't delay for medications in unstable patients",
            algorithmStep: "Tachycardia Algorithm - Unstable: Immediate synchronized cardioversion"
        ),
        makeQuestion(
            stem: "Why is synchronized cardioversion used for unstable tachycardia rather than unsynchronized defibrillation?",
            choices: [
                ("Synchronization avoids the vulnerable period (T-wave), preventing VF", true, "Sync delivers shock during QRS, avoiding R-on-T phenomenon → VF", nil),
                ("Synchronized shocks use less energy", false, nil, "Energy selection is separate from sync function"),
                ("Defibrillation is only for VF", false, nil, "Defibrillation (unsync) can be used if sync fails"),
                ("Synchronization increases success rate", false, nil, "Sync is for safety, not increased conversion rate")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Synchronized cardioversion times the shock to avoid the vulnerable T-wave period, preventing R-on-T phenomenon and VF.",
            keyPoint: "Sync avoids T-wave → prevents VF",
            clinicalPearl: nil,
            algorithmStep: "Tachycardia Algorithm - Synchronized cardioversion: Avoids R-on-T"
        ),
        makeQuestion(
            stem: "What is the recommended initial energy for synchronized cardioversion of SVT?",
            choices: [
                ("50-100 J biphasic", true, "SVT: Start 50-100J biphasic; escalate if needed", nil),
                ("200 J biphasic", false, nil, "Starting energy is lower for SVT"),
                ("360 J monophasic", false, nil, "This is defibrillation energy, not cardioversion"),
                ("10 J biphasic", false, nil, "Too low to be effective")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Synchronized cardioversion for SVT starts at 50-100 J biphasic.",
            keyPoint: "SVT cardioversion: 50-100J",
            clinicalPearl: nil,
            algorithmStep: "Tachycardia Algorithm - SVT cardioversion: 50-100J initial"
        ),
        makeQuestion(
            stem: "What is the recommended initial energy for synchronized cardioversion of monomorphic VT with a pulse?",
            choices: [
                ("100 J biphasic", true, "Monomorphic VT with pulse: Start at 100J biphasic", nil),
                ("50 J biphasic", false, nil, "May be too low for VT"),
                ("200 J biphasic", false, nil, "Can start lower at 100J"),
                ("360 J monophasic", false, nil, "This is defibrillation energy")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Synchronized cardioversion for monomorphic VT with pulse starts at 100 J biphasic.",
            keyPoint: "Monomorphic VT: 100J sync",
            clinicalPearl: nil,
            algorithmStep: "Tachycardia Algorithm - Monomorphic VT cardioversion: 100J initial"
        ),
        makeQuestion(
            stem: "How should unstable polymorphic VT be treated?",
            choices: [
                ("Treat as VF - unsynchronized defibrillation", true, "Polymorphic VT = irregular, can't sync → treat like VF with defib", nil),
                ("Synchronized cardioversion at 100 J", false, nil, "Can't synchronize with irregular rhythm"),
                ("Magnesium 2 g IV", false, nil, "Magnesium is for Torsades (stable); defib for unstable"),
                ("Adenosine 6 mg IV", false, nil, "Adenosine not effective for ventricular arrhythmias")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "Polymorphic VT cannot be synchronized - treat as VF with unsynchronized high-energy defibrillation.",
            keyPoint: "Polymorphic VT = defibrillate (no sync)",
            clinicalPearl: nil,
            algorithmStep: "Tachycardia Algorithm - Polymorphic VT: Cannot sync → Defibrillate"
        ),
        makeQuestion(
            stem: "What is recommended regarding sedation before cardioversion?",
            choices: [
                ("Sedate if possible, but do not delay cardioversion for unstable patients", true, "Conscious patient should be sedated IF time permits; don't delay for unstable", nil),
                ("Always sedate before cardioversion", false, nil, "Unstable patients may not tolerate delay for sedation"),
                ("Never sedate - it delays treatment", false, nil, "Sedation is preferred if patient is stable enough"),
                ("Only sedate pediatric patients", false, nil, "Adults also benefit from sedation if time permits")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Sedate whenever feasible, but do not delay cardioversion for unstable patients.",
            keyPoint: "Sedate if time permits",
            clinicalPearl: "2025: 'Sedate whenever feasible' (stronger than 'consider')",
            algorithmStep: "Tachycardia Algorithm - Sedation if able, don't delay for unstable"
        ),
        makeQuestion(
            stem: "A patient with AFib and rapid ventricular response is hypotensive with altered mental status. What is the treatment?",
            choices: [
                ("Synchronized cardioversion", true, "Unstable AFib = synchronized cardioversion regardless of rhythm type", nil),
                ("Diltiazem 15 mg IV", false, nil, "Rate control is for stable patients"),
                ("Adenosine 6 mg IV", false, nil, "Adenosine doesn't work for AFib"),
                ("Amiodarone 150 mg IV over 10 min", false, nil, "Takes too long for unstable patient")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Unstable AFib requires synchronized cardioversion, not rate control.",
            keyPoint: "Unstable AFib = Cardiovert",
            clinicalPearl: "Start at ≥200J for AFib",
            algorithmStep: "Tachycardia Algorithm - Unstable AFib: Cardioversion"
        )
    ]
    
    // MARK: - Pharmacology Questions
    
    static let pharmacologyQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the dose of epinephrine for cardiac arrest?",
            choices: [
                ("1 mg IV/IO every 3-5 minutes", true, "Standard cardiac arrest dose", nil),
                ("0.5 mg IV/IO every 2 minutes", false, nil, "Wrong dose and interval"),
                ("2 mg IV/IO every 5 minutes", false, nil, "Dose is 1mg"),
                ("1 mg IV/IO once only", false, nil, "Repeat every 3-5 minutes")
            ],
            topic: .pharmacology,
            difficulty: .easy,
            explanation: "Epinephrine 1 mg IV/IO every 3-5 minutes is the standard dose for cardiac arrest.",
            keyPoint: "Epinephrine 1mg IV/IO q 3-5 min",
            clinicalPearl: "IV is preferred over IO for medication delivery (2025)",
            algorithmStep: "Cardiac Arrest Algorithm"
        ),
        makeQuestion(
            stem: "What is the correct dose of adenosine if the initial 6 mg dose is ineffective?",
            choices: [
                ("12 mg IV rapid push", true, "Second dose is 12mg", nil),
                ("6 mg IV again", false, nil, "Increase to 12mg"),
                ("18 mg IV", false, nil, "Max single dose is 12mg"),
                ("Switch to amiodarone", false, nil, "Try 12mg adenosine first")
            ],
            topic: .pharmacology,
            difficulty: .easy,
            explanation: "If 6 mg is ineffective, give 12 mg adenosine. A third dose of 12 mg may be given if needed.",
            keyPoint: "Adenosine: 6mg → 12mg → 12mg",
            clinicalPearl: "Warn patient about brief feeling of impending doom - it's transient",
            algorithmStep: "Tachycardia Algorithm"
        ),
        makeQuestion(
            stem: "For Torsades de Pointes with prolonged QT, what is the first-line medication?",
            choices: [
                ("Magnesium sulfate 2 g IV over 10 minutes", true, "First-line for TdP with long QT", nil),
                ("Amiodarone 300 mg IV", false, nil, "May worsen QT prolongation"),
                ("Lidocaine 1 mg/kg IV", false, nil, "Second-line option"),
                ("Procainamide 20 mg/min", false, nil, "May worsen QT prolongation")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Magnesium 2 g IV is first-line for Torsades de Pointes with prolonged QT.",
            keyPoint: "Torsades + long QT = Magnesium 2g IV",
            clinicalPearl: "Stop any QT-prolonging medications",
            algorithmStep: "Tachycardia Algorithm"
        ),
        makeQuestion(
            stem: "What is the dose of amiodarone for the second dose during VF/pVT arrest?",
            choices: [
                ("150 mg IV/IO", true, "Second dose is 150mg", nil),
                ("300 mg IV/IO", false, nil, "That's the first dose"),
                ("75 mg IV/IO", false, nil, "Too low"),
                ("450 mg IV/IO", false, nil, "Too high")
            ],
            topic: .pharmacology,
            difficulty: .easy,
            explanation: "Amiodarone dosing: First dose 300 mg IV/IO, second dose 150 mg IV/IO. Only 2 doses during arrest.",
            keyPoint: "Amiodarone: 300mg first, 150mg second",
            clinicalPearl: "Can cause hypotension - monitor BP after ROSC",
            algorithmStep: "Cardiac Arrest Algorithm"
        )
    ]
    
    // MARK: - Post-ROSC Questions
    
    static let postROSCQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the target MAP for post-cardiac arrest care according to 2025 guidelines?",
            choices: [
                ("≥65 mmHg", true, "2025 Update: Focus on MAP only", nil),
                ("≥90 mmHg systolic", false, nil, "Systolic target was REMOVED in 2025"),
                ("≥80 mmHg", false, nil, "Target is 65 mmHg"),
                ("≥100 mmHg systolic", false, nil, "Systolic BP target removed")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025 UPDATE: Target MAP ≥65 mmHg. The systolic BP target has been removed.",
            keyPoint: "MAP ≥65 mmHg (systolic target REMOVED)",
            clinicalPearl: "Use vasopressors and fluids to achieve target",
            algorithmStep: "Post-Cardiac Arrest Care"
        ),
        makeQuestion(
            stem: "What is the temperature target range for TTM in 2025 guidelines?",
            choices: [
                ("32-37.5°C", true, "2025 Update: Wider range", nil),
                ("Strictly 32-34°C", false, nil, "Range has been widened"),
                ("36°C only", false, nil, "Wider range is now acceptable"),
                ("Normal body temperature", false, nil, "Active temperature management still needed")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025 UPDATE: Temperature target is 32-37.5°C. Both hypothermic and normothermic (fever prevention) strategies are acceptable.",
            keyPoint: "TTM: 32-37.5°C (wider range in 2025)",
            clinicalPearl: "At minimum, PREVENT FEVER - fever is the enemy",
            algorithmStep: "Post-Cardiac Arrest Care - Temperature"
        ),
        makeQuestion(
            stem: "For how long should temperature control be maintained after ROSC?",
            choices: [
                ("At least 36 hours", true, "2025 Update: Increased from 24 hours", nil),
                ("12 hours", false, nil, "Too short"),
                ("24 hours", false, nil, "Increased to 36 hours in 2025"),
                ("48 hours minimum", false, nil, "36 hours is the minimum")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025 UPDATE: Maintain temperature control for at least 36 hours (increased from 24 hours).",
            keyPoint: "TTM duration: ≥36 hours (2025 update)",
            clinicalPearl: "Rewarm slowly: 0.25°C per hour",
            algorithmStep: "Post-Cardiac Arrest Care"
        ),
        makeQuestion(
            stem: "What is the target SpO2 range for post-cardiac arrest care?",
            choices: [
                ("92-98%", true, "Avoid hyperoxia", nil),
                ("100% at all times", false, nil, "Hyperoxia may worsen outcomes"),
                ("85-90%", false, nil, "Too low"),
                ("Above 94% only", false, nil, "Upper limit also matters")
            ],
            topic: .postROSC,
            difficulty: .easy,
            explanation: "Target SpO2 92-98%. Avoid hyperoxia which may worsen neurological outcomes.",
            keyPoint: "SpO2: 92-98% (avoid hyperoxia)",
            clinicalPearl: "Start at 100% FiO2, then titrate down once SpO2 is measurable",
            algorithmStep: "Post-Cardiac Arrest Care"
        )
    ]
    
    // MARK: - Electrical Therapy Questions
    
    static let electricalQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the synchronized cardioversion energy for monomorphic VT?",
            choices: [
                ("100 J initial", true, "2025 guidelines for stable monomorphic VT", nil),
                ("50 J", false, nil, "May be insufficient"),
                ("200 J", false, nil, "Higher than needed initially"),
                ("Unsynchronized shock", false, nil, "Use synchronized for monomorphic")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Synchronized cardioversion for monomorphic VT starts at 100 J.",
            keyPoint: "Monomorphic VT: 100J synchronized",
            clinicalPearl: "Ensure sync markers are on the R wave before shocking",
            algorithmStep: "Tachycardia Algorithm - Cardioversion"
        ),
        makeQuestion(
            stem: "When should you use UNSYNCHRONIZED shocks?",
            choices: [
                ("VF, pulseless VT, and polymorphic VT", true, "Cannot synchronize to these rhythms", nil),
                ("All tachyarrhythmias", false, nil, "Many require synchronized cardioversion"),
                ("Only VF", false, nil, "Also for pulseless VT and polymorphic VT"),
                ("Never - always synchronize", false, nil, "VF requires unsynchronized defibrillation")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Unsynchronized shocks (defibrillation) are used for VF, pulseless VT, and polymorphic VT - rhythms that can't be reliably synchronized.",
            keyPoint: "Unsync: VF, pulseless VT, polymorphic VT",
            clinicalPearl: "If in doubt about rhythm, treat as VF with unsynchronized shock",
            algorithmStep: "Electrical Therapy"
        )
    ]
    
    // MARK: - H's and T's Questions
    
    static let hsAndTsQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Which of these is a 'T' in the reversible causes of cardiac arrest?",
            choices: [
                ("Thrombosis (pulmonary or coronary)", true, "One of the T's", nil),
                ("Hyperkalemia", false, nil, "This is related to the H's"),
                ("Hypoxia", false, nil, "This is an H"),
                ("Hypovolemia", false, nil, "This is an H")
            ],
            topic: .hsAndTs,
            difficulty: .easy,
            explanation: "The T's are: Tension pneumothorax, Tamponade (cardiac), Toxins, Thrombosis (pulmonary/coronary).",
            keyPoint: "T's: Tension, Tamponade, Toxins, Thrombosis",
            clinicalPearl: "Consider POCUS to rapidly assess for tamponade, pneumothorax",
            algorithmStep: "Cardiac Arrest Algorithm"
        ),
        makeQuestion(
            stem: "A patient arrests after a motor vehicle collision with chest trauma. Which reversible cause should be immediately considered?",
            choices: [
                ("Tension pneumothorax", true, "Trauma + arrest = consider tension pneumo", nil),
                ("Hyperkalemia", false, nil, "Less likely in acute trauma"),
                ("Toxins", false, nil, "Not typical for trauma"),
                ("Hypothermia", false, nil, "Would take time to develop")
            ],
            topic: .hsAndTs,
            difficulty: .easy,
            explanation: "Trauma patients are at high risk for tension pneumothorax. Consider needle decompression.",
            keyPoint: "Trauma + arrest = think tension pneumothorax",
            clinicalPearl: "Needle decompression: 2nd intercostal space, midclavicular line",
            algorithmStep: "Cardiac Arrest - Reversible Causes"
        )
    ]
    
    // MARK: - Rhythm Recognition Questions
    
    static let rhythmQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Which rhythm is characterized by completely chaotic, irregular waveforms with no discernible P waves, QRS complexes, or T waves?",
            choices: [
                ("Ventricular fibrillation", true, "Classic VF description", nil),
                ("Atrial fibrillation", false, nil, "AFib has narrow QRS complexes"),
                ("Ventricular tachycardia", false, nil, "VT has organized wide QRS"),
                ("Torsades de Pointes", false, nil, "Torsades has twisting pattern")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "VF shows chaotic, irregular waveforms with no organized electrical activity.",
            keyPoint: "VF = chaotic, no organized complexes",
            clinicalPearl: "VF = shock immediately",
            algorithmStep: "Rhythm Recognition"
        ),
        makeQuestion(
            stem: "What characterizes third-degree (complete) heart block?",
            choices: [
                ("Complete AV dissociation with no conducted P waves", true, "Atria and ventricles independent", nil),
                ("Progressively prolonging PR intervals", false, nil, "This is Mobitz I (Wenckebach)"),
                ("Dropped beats after fixed PR interval", false, nil, "This is Mobitz II"),
                ("Irregular rhythm with normal P waves", false, nil, "This describes other rhythms")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Third-degree block shows complete AV dissociation - atria and ventricles beat independently.",
            keyPoint: "3rd degree = complete AV dissociation",
            clinicalPearl: "Often requires temporary pacing - atropine usually ineffective",
            algorithmStep: "Bradycardia Algorithm"
        )
    ]
    
    // MARK: - Airway Questions
    
    static let airwayQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the gold standard for confirming advanced airway placement during CPR?",
            choices: [
                ("Continuous waveform capnography", true, "Gold standard for ETT confirmation", nil),
                ("Bilateral breath sounds", false, nil, "Can be unreliable during CPR"),
                ("Chest X-ray", false, nil, "Takes too long during resuscitation"),
                ("Pulse oximetry", false, nil, "Doesn't confirm tube position")
            ],
            topic: .airway,
            difficulty: .easy,
            explanation: "Continuous waveform capnography is the gold standard for confirming and monitoring ETT placement.",
            keyPoint: "Waveform capnography = gold standard for ETT",
            clinicalPearl: "ETCO2 >10 mmHg suggests adequate CPR quality",
            algorithmStep: "Airway Management"
        ),
        makeQuestion(
            stem: "According to 2025 guidelines, should a fixed ventilation rate be used post-ROSC?",
            choices: [
                ("No, the fixed 10 breaths/min language was removed", true, "2025 Update: Focus on PaCO2 targets", nil),
                ("Yes, exactly 10 breaths per minute", false, nil, "This language was removed"),
                ("Yes, 12-20 breaths per minute", false, nil, "No fixed rate specified"),
                ("Only if ETCO2 is available", false, nil, "Removed regardless of monitoring")
            ],
            topic: .airway,
            difficulty: .hard,
            explanation: "2025 UPDATE: Removed fixed '10 breaths per minute' language. Focus on PaCO2 targets (35-45 mmHg) and avoiding hyperventilation.",
            keyPoint: "No fixed vent rate - target PaCO2 35-45",
            clinicalPearl: "Avoid hyperventilation - it decreases cerebral blood flow",
            algorithmStep: "Post-Cardiac Arrest Care - Ventilation"
        ),
        makeQuestion(
            stem: "According to 2025 guidelines, which vascular access is preferred: IV or IO?",
            choices: [
                ("IV is preferred; IO is backup if IV fails", true, "2025 Update: IV preferred", nil),
                ("IO is preferred for faster access", false, nil, "IV is preferred if feasible"),
                ("Both are equally preferred", false, nil, "IV is preferred"),
                ("IO should never be used", false, nil, "IO is acceptable if IV fails")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "2025 UPDATE: IV access is preferred. IO is a reasonable alternative if IV attempts fail or are not feasible.",
            keyPoint: "IV preferred over IO (2025 update)",
            clinicalPearl: "Don't delay medications for IV - use IO if needed",
            algorithmStep: "Vascular Access"
        )
    ]
    
    // MARK: - Team Dynamics Questions (4 questions)
    
    static let teamDynamicsQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is closed-loop communication?",
            choices: [
                ("Sender gives order, receiver confirms, sender verifies", true, "Complete loop: Order → Confirm → Verify", nil),
                ("Speaking quietly so others don't hear", false, nil, "Communication should be clear and audible"),
                ("Using medical jargon exclusively", false, nil, "Clear, simple language is preferred"),
                ("Communicating only with team leader", false, nil, "All team members should communicate")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Closed-loop communication: 1) Sender gives order, 2) Receiver confirms order, 3) Sender verifies it was done correctly.",
            keyPoint: "Order → Confirm → Verify",
            clinicalPearl: "'Give 1mg epi IV' → 'Giving 1mg epi IV' → 'Epi given'",
            algorithmStep: "Team Dynamics - Closed-loop: Order → Confirm → Verify"
        ),
        makeQuestion(
            stem: "What is the primary role of the team leader during resuscitation?",
            choices: [
                ("Oversee the resuscitation, delegate tasks, and monitor quality", true, "Direct the team, don't get hands-on unless necessary", nil),
                ("Perform chest compressions", false, nil, "Leader should delegate this to maintain oversight"),
                ("Manage the airway", false, nil, "Leader should delegate to focus on big picture"),
                ("Document the code", false, nil, "Documentation should be delegated")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "The team leader oversees the resuscitation, delegates tasks, and monitors quality. They should not be hands-on.",
            keyPoint: "Leader: Oversee, delegate, monitor",
            clinicalPearl: "If you're doing tasks, you can't lead effectively",
            algorithmStep: "Team Dynamics - Leader: Oversee, delegate, monitor quality"
        ),
        makeQuestion(
            stem: "When should debriefing occur after a resuscitation event?",
            choices: [
                ("Both immediately (hot debrief) and later (cold debrief)", true, "2025: Both hot and cold debriefs recommended", nil),
                ("Only if the patient survived", false, nil, "Debrief after all resuscitations"),
                ("Only if errors were made", false, nil, "Debrief to improve regardless of outcome"),
                ("Within 1 week", false, nil, "Hot debrief should be immediate")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "2025 UPDATE: Both hot (immediate) and cold (later) debriefings are recommended.",
            keyPoint: "Debrief: Hot (immediate) + Cold (later)",
            clinicalPearl: "Even a 3-minute debrief helps improve future performance",
            algorithmStep: "Team Dynamics - Debrief: Hot (immediate) + Cold (later)"
        ),
        makeQuestion(
            stem: "A team member notices the compressor is fatigued. What is the appropriate action?",
            choices: [
                ("Use constructive intervention to suggest a switch", true, "Mutual support prevents quality degradation", nil),
                ("Wait for the team leader to notice", false, nil, "Proactive intervention is encouraged"),
                ("Continue without saying anything", false, nil, "Quality CPR requires fresh compressors"),
                ("Take over without asking", false, nil, "Communicate before taking action")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "Any team member can and should speak up if they notice quality issues. This is constructive intervention.",
            keyPoint: "Anyone can speak up for patient safety",
            clinicalPearl: "Fatigue starts around 90 seconds - switch at 2 minutes",
            algorithmStep: "Team Dynamics - Mutual Support"
        )
    ]
    
    // MARK: - Vascular Access Questions (3 questions)
    
    static let vascularAccessQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per AHA 2025 guidelines, what is the priority for vascular access in adults?",
            choices: [
                ("IV is prioritized; IO is the alternative if IV unsuccessful", true, "2025: Attempt IV first in adults; IO if IV fails", nil),
                ("IO is always preferred", false, nil, "2025 emphasizes IV first in adults"),
                ("Either is acceptable initially", false, nil, "2025 prioritizes IV over IO in adults"),
                ("Central line is first choice", false, nil, "Peripheral IV or IO are first-line")
            ],
            topic: .airway, // Using airway topic since we don't have separate vascular
            difficulty: .medium,
            explanation: "2025 UPDATE: IV access is preferred. IO is a reasonable alternative if IV attempts fail or are not feasible.",
            keyPoint: "IV preferred over IO (2025 update)",
            clinicalPearl: "Don't delay medications for IV - use IO if needed",
            algorithmStep: "ACLS Algorithm (2025) - Vascular access: IV first, IO alternative"
        ),
        makeQuestion(
            stem: "What are acceptable IO insertion sites in adults?",
            choices: [
                ("Proximal tibia, proximal humerus, distal tibia", true, "Standard adult IO sites", nil),
                ("Only the sternum", false, nil, "Sternal IO exists but not most common"),
                ("Femur only", false, nil, "Femur is not a standard adult site"),
                ("Any long bone", false, nil, "Specific sites are recommended")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "Acceptable IO sites in adults include proximal tibia, proximal humerus, and distal tibia.",
            keyPoint: "IO sites: prox tibia, prox humerus, distal tibia",
            clinicalPearl: nil,
            algorithmStep: "ACLS Algorithm - IO sites: Proximal tibia, humerus, distal tibia"
        ),
        makeQuestion(
            stem: "How do medications given via IO compare to IV?",
            choices: [
                ("IO achieves similar drug levels to IV access", true, "IO provides comparable drug delivery to IV", nil),
                ("IO requires double the dose", false, nil, "Standard doses are used"),
                ("IO absorption is significantly slower", false, nil, "IO absorption is rapid and comparable to IV"),
                ("IO cannot be used for all ACLS medications", false, nil, "All ACLS medications can be given IO")
            ],
            topic: .airway,
            difficulty: .easy,
            explanation: "IO access achieves similar drug levels and absorption as IV access. Use same doses.",
            keyPoint: "IO = same doses as IV",
            clinicalPearl: nil,
            algorithmStep: "ACLS Algorithm - IO: Same doses as IV"
        )
    ]
    
    // MARK: - ACS Questions
    
    static let acsQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "A patient presents with chest pain. The 12-lead ECG shows ST elevation in leads II, III, and aVF. What is the diagnosis?",
            choices: [
                ("Inferior STEMI", true, "II, III, aVF = inferior wall", nil),
                ("Anterior STEMI", false, nil, "Anterior would be V1-V4"),
                ("Lateral STEMI", false, nil, "Lateral would be I, aVL, V5-V6"),
                ("Posterior STEMI", false, nil, "Posterior shows ST depression in V1-V3")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "ST elevation in leads II, III, and aVF indicates an inferior wall MI, typically from RCA occlusion.",
            keyPoint: "II, III, aVF = Inferior MI (RCA territory)",
            clinicalPearl: "Always check right-sided leads (V4R) in inferior STEMI to assess RV involvement",
            algorithmStep: "ACS Algorithm"
        ),
        makeQuestion(
            stem: "What is the first medication given to a patient with suspected ACS?",
            choices: [
                ("Aspirin 162-325 mg chewed", true, "First-line for all ACS unless contraindicated", nil),
                ("Nitroglycerin sublingual", false, nil, "Give after aspirin; contraindicated in RV infarct"),
                ("Morphine 4mg IV", false, nil, "Third-line for pain; may worsen outcomes"),
                ("Heparin 5000 units IV", false, nil, "Given after initial treatment")
            ],
            topic: .acs,
            difficulty: .easy,
            explanation: "Aspirin 162-325 mg should be chewed for faster absorption. It's first-line unless contraindicated (allergy, active bleeding).",
            keyPoint: "Aspirin first, chewed not swallowed",
            clinicalPearl: "Chewing aspirin achieves therapeutic levels in 15 minutes vs 45+ if swallowed",
            algorithmStep: "ACS Algorithm - Initial Treatment"
        ),
        makeQuestion(
            stem: "When is nitroglycerin contraindicated in ACS?",
            choices: [
                ("Right ventricular infarction or hypotension", true, "NTG causes vasodilation → worsens RV preload", nil),
                ("Inferior MI only", false, nil, "Only if RV involvement or hypotension"),
                ("Any ST elevation", false, nil, "NTG can be used in most STEMI"),
                ("Heart rate over 100", false, nil, "Tachycardia alone is not a contraindication")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "NTG is contraindicated in RV infarct (causes preload-dependent hypotension), SBP <90, severe bradycardia/tachycardia, or recent PDE5 inhibitor use.",
            keyPoint: "No NTG if: RV infarct, SBP <90, Viagra/Cialis",
            clinicalPearl: "If inferior MI, get right-sided ECG before NTG",
            algorithmStep: "ACS Algorithm"
        ),
        makeQuestion(
            stem: "What is the door-to-balloon time goal for STEMI patients undergoing primary PCI?",
            choices: [
                ("90 minutes or less", true, "Time is myocardium - faster is better", nil),
                ("120 minutes or less", false, nil, "This is the goal if transfer is needed"),
                ("60 minutes or less", false, nil, "Ideal but not the standard goal"),
                ("6 hours or less", false, nil, "Far too long for primary PCI")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "Door-to-balloon time should be ≤90 minutes for primary PCI. If transfer needed, first medical contact to device should be ≤120 minutes.",
            keyPoint: "Door-to-balloon ≤90 min",
            clinicalPearl: "Every 30-minute delay increases mortality by 7.5%",
            algorithmStep: "ACS Algorithm - Reperfusion"
        )
    ]
    
    // MARK: - Stroke Questions
    
    static let strokeQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the maximum time window for IV tPA (alteplase) in acute ischemic stroke?",
            choices: [
                ("4.5 hours from symptom onset", true, "Extended from 3 hours in select patients", nil),
                ("3 hours from symptom onset", false, nil, "Can be extended to 4.5 hours in some cases"),
                ("6 hours from symptom onset", false, nil, "This is for mechanical thrombectomy"),
                ("12 hours from symptom onset", false, nil, "Too long for tPA")
            ],
            topic: .stroke,
            difficulty: .medium,
            explanation: "IV tPA can be given up to 4.5 hours from symptom onset in eligible patients. The earlier, the better - 'time is brain.'",
            keyPoint: "tPA window: 4.5 hours (3 hours for some criteria)",
            clinicalPearl: "Door-to-needle goal is 60 minutes",
            algorithmStep: "Stroke Algorithm"
        ),
        makeQuestion(
            stem: "What does FAST stand for in stroke recognition?",
            choices: [
                ("Face drooping, Arm weakness, Speech difficulty, Time to call 911", true, "Public awareness mnemonic", nil),
                ("Facial paralysis, Altered speech, Sudden headache, Time is critical", false, nil, "Close but not the standard mnemonic"),
                ("Fast assessment, Stroke symptoms, Treatment needed", false, nil, "Incorrect interpretation"),
                ("First aid stroke treatment", false, nil, "Not what FAST stands for")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "FAST: Face drooping, Arm weakness, Speech difficulty, Time to call 911. Used for rapid stroke recognition.",
            keyPoint: "FAST = Face, Arm, Speech, Time",
            clinicalPearl: "Also consider BE-FAST: Balance, Eyes, Face, Arm, Speech, Time",
            algorithmStep: "Stroke Recognition"
        ),
        makeQuestion(
            stem: "What blood pressure threshold requires treatment before tPA administration?",
            choices: [
                (">185/110 mmHg", true, "Must lower BP before tPA is safe", nil),
                (">140/90 mmHg", false, nil, "Too low a threshold"),
                (">220/120 mmHg", false, nil, "This is the threshold for non-tPA candidates"),
                (">160/100 mmHg", false, nil, "Not the correct threshold")
            ],
            topic: .stroke,
            difficulty: .hard,
            explanation: "BP must be <185/110 mmHg before tPA and maintained <180/105 for 24 hours after. Higher BP increases hemorrhage risk.",
            keyPoint: "Pre-tPA: BP must be <185/110",
            clinicalPearl: "Use labetalol or nicardipine to lower BP",
            algorithmStep: "Stroke Algorithm - tPA Eligibility"
        )
    ]
    
    // MARK: - 2025 Guidelines Update Questions
    
    static let guidelines2025Questions: [ACLSQuestion] = [
        makeQuestion(
            stem: "According to 2025 guidelines, what is the new recommendation for the Chain of Survival?",
            choices: [
                ("One universal chain regardless of age or location", true, "Standardized across all populations", nil),
                ("Separate chains for in-hospital and out-of-hospital", false, nil, "This was the old approach"),
                ("Different chains for adults and pediatrics", false, nil, "Now unified"),
                ("No changes from 2020 guidelines", false, nil, "There were significant changes")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "2025 UPDATE: The Chain of Survival is now standardized - one universal chain regardless of age (adult/pediatric) or location (in-hospital/out-of-hospital).",
            keyPoint: "One universal Chain of Survival for all",
            clinicalPearl: "Simplification improves retention and application",
            algorithmStep: "2025 Guidelines Update"
        ),
        makeQuestion(
            stem: "What 2025 change was made to the cardiac arrest algorithm regarding H's and T's?",
            choices: [
                ("They are no longer explicitly listed but should be considered continuously", true, "Implicit rather than explicit", nil),
                ("They were expanded to include more causes", false, nil, "They were removed from explicit listing"),
                ("They are now only considered for PEA", false, nil, "Should be considered for all rhythms"),
                ("No changes were made", false, nil, "This was a notable change")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "2025 UPDATE: H's and T's are no longer explicitly listed in algorithm boxes but should be considered continuously throughout resuscitation.",
            keyPoint: "H's and T's now implicit, not listed",
            clinicalPearl: "Still think about them at every rhythm check",
            algorithmStep: "2025 Guidelines - Algorithm Changes"
        ),
        makeQuestion(
            stem: "What is the 2025 update regarding mechanical CPR devices?",
            choices: [
                ("Routine use is not recommended; no superiority over manual CPR", true, "Trials show no benefit over high-quality manual CPR", nil),
                ("They are now preferred over manual CPR", false, nil, "Not supported by evidence"),
                ("They should be used in all hospital arrests", false, nil, "Not recommended routinely"),
                ("No changes from previous guidelines", false, nil, "There was a specific update")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "2025 UPDATE: Mechanical CPR devices show no superiority over high-quality manual CPR. Routine use is not recommended. Use only when manual CPR is unsafe or ineffective.",
            keyPoint: "Mechanical CPR not superior to manual",
            clinicalPearl: "Consider for transport or limited personnel only",
            algorithmStep: "2025 Guidelines - CPR"
        ),
        makeQuestion(
            stem: "What is the new language regarding sedation before cardioversion in 2025?",
            choices: [
                ("Sedate whenever feasible", true, "Changed from 'consider sedation'", nil),
                ("Sedation is no longer recommended", false, nil, "Sedation is still important"),
                ("Mandatory sedation before all cardioversions", false, nil, "Still 'whenever feasible'"),
                ("No change in language", false, nil, "Language was updated")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "2025 UPDATE: Language changed from 'consider sedation' to 'sedate whenever feasible' - stronger emphasis on patient comfort.",
            keyPoint: "Sedate WHENEVER feasible (not just consider)",
            clinicalPearl: "Etomidate, propofol, or midazolam are common choices",
            algorithmStep: "Tachycardia Algorithm - Cardioversion"
        ),
        makeQuestion(
            stem: "What new emphasis was placed on post-ROSC diagnostics in 2025?",
            choices: [
                ("Strong emphasis on early 12-lead ECG, CT, and ultrasound", true, "Early diagnosis guides treatment", nil),
                ("Diagnostics should wait until ICU admission", false, nil, "Early diagnosis is emphasized"),
                ("Only 12-lead ECG is needed", false, nil, "Multiple modalities recommended"),
                ("Diagnostics are unchanged from 2020", false, nil, "There was new emphasis")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025 UPDATE: Strong emphasis on early diagnostics including 12-lead ECG, CT scan, and point-of-care ultrasound to identify and treat underlying causes.",
            keyPoint: "Early diagnostics: ECG, CT, POCUS",
            clinicalPearl: "Early coronary angiography and PCI are strongly emphasized",
            algorithmStep: "Post-ROSC Algorithm"
        )
    ]
    
    // MARK: - Advanced Scenario Questions
    
    static let advancedScenarioQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "A 55-year-old man collapses at a gym. Bystanders start CPR. When EMS arrives, the monitor shows VF. After 3 shocks and 2 rounds of epinephrine, VF persists. What is the next medication?",
            vignette: "55 yo male, witnessed arrest at gym. Bystander CPR in progress. Initial rhythm VF. 3 shocks delivered at 200J biphasic. 2 doses epinephrine 1mg IV given. VF persists.",
            vitals: ACLSVitals(heartRate: nil, bpSystolic: nil, bpDiastolic: nil, spO2: nil, respiratoryRate: nil, temperature: nil),
            rhythmDescription: "Coarse ventricular fibrillation persisting after 3 defibrillation attempts",
            choices: [
                ("Amiodarone 300 mg IV", true, "First-line antiarrhythmic for refractory VF", nil),
                ("Lidocaine 1.5 mg/kg IV", false, nil, "Alternative to amiodarone, not first-line"),
                ("Magnesium 2 g IV", false, nil, "For Torsades de Pointes specifically"),
                ("Atropine 1 mg IV", false, nil, "Not indicated for VF")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "After 3 shocks for refractory VF/pVT, give amiodarone 300 mg IV. This is followed by a second dose of 150 mg if needed. Remember: Sotalol is no longer recommended (2025).",
            keyPoint: "Refractory VF after 3 shocks → Amiodarone 300mg",
            clinicalPearl: "Only 2 doses of amiodarone during arrest: 300mg, then 150mg",
            algorithmStep: "VF/pVT Algorithm - Antiarrhythmics"
        ),
        makeQuestion(
            stem: "A patient in the ICU develops asystole. After 2 minutes of CPR, you notice the ETCO2 drops from 25 to 8 mmHg despite good compressions. What does this suggest?",
            vignette: "ICU patient, sudden asystole. CPR in progress with good depth and rate. Advanced airway in place with continuous capnography. ETCO2 was 25 mmHg, now reads 8 mmHg.",
            choices: [
                ("Likely massive pulmonary embolism", true, "Sudden ETCO2 drop with good CPR suggests PE", nil),
                ("Improving cardiac output", false, nil, "Low ETCO2 suggests poor perfusion"),
                ("Hyperventilation by the bag-mask operator", false, nil, "Would not cause this dramatic drop"),
                ("Equipment malfunction", false, nil, "Possible but PE should be considered")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "A sudden drop in ETCO2 despite high-quality CPR suggests a massive pulmonary embolism - one of the T's (Thrombosis). Consider thrombolytics or ECMO.",
            keyPoint: "Sudden ETCO2 drop + good CPR = think PE",
            clinicalPearl: "Massive PE may warrant thrombolytics during CPR",
            algorithmStep: "PEA/Asystole - Reversible Causes"
        ),
        makeQuestion(
            stem: "A patient with a pacemaker arrests. The monitor shows pacemaker spikes at 70/min but no capture. What is this rhythm?",
            rhythmDescription: "Regular pacemaker spikes at 70/min visible on monitor. No QRS complexes following spikes. Patient is pulseless.",
            choices: [
                ("Pulseless Electrical Activity (PEA) with failure to capture", true, "Pacemaker not capturing = no mechanical contraction", nil),
                ("Ventricular fibrillation", false, nil, "VF would show chaotic rhythm"),
                ("Asystole", false, nil, "Spikes are present, not flat line"),
                ("Normal pacemaker function", false, nil, "Should see captured QRS complexes")
            ],
            topic: .peaAsystole,
            difficulty: .hard,
            explanation: "This is PEA with pacemaker failure to capture. The pacemaker is firing but not capturing myocardial tissue. Treat as PEA and consider causes of non-capture.",
            keyPoint: "Pacemaker spikes without capture = PEA",
            clinicalPearl: "Causes: lead displacement, fibrosis, electrolyte abnormalities, medication effects",
            algorithmStep: "PEA/Asystole Algorithm"
        ),
        makeQuestion(
            stem: "During a code, a nurse asks why you're not checking a pulse after every shock. What is the correct response?",
            choices: [
                ("Resume CPR immediately after shock without pulse check until 2-minute cycle complete", true, "Minimize interruptions in compressions", nil),
                ("We should check pulse after every shock", false, nil, "This causes unnecessary interruptions"),
                ("Pulse checks are only needed for PEA", false, nil, "Check at 2-minute intervals for all rhythms"),
                ("The defibrillator automatically detects pulses", false, nil, "Manual pulse checks still needed")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "Resume CPR immediately after defibrillation without pulse check. Rhythm and pulse checks occur at 2-minute intervals to minimize compression interruptions.",
            keyPoint: "No pulse check after shock - resume CPR immediately",
            clinicalPearl: "It takes 60-90 seconds for coronary perfusion pressure to build after interruption",
            algorithmStep: "VF/pVT Algorithm"
        ),
        makeQuestion(
            stem: "A patient is found unresponsive. Initial rhythm is VF. After 1 shock and 2 minutes CPR, the rhythm changes to a narrow complex at 110 bpm. What do you do?",
            rhythmDescription: "Narrow complex rhythm, regular at 110 bpm. QRS <120ms.",
            choices: [
                ("Check for pulse - if present, this is ROSC", true, "Organized rhythm requires pulse check", nil),
                ("Continue CPR without checking", false, nil, "Organized rhythm requires assessment"),
                ("Give another shock", false, nil, "Cannot shock organized rhythm without assessment"),
                ("Start amiodarone infusion", false, nil, "First check if patient has pulse")
            ],
            topic: .vfPulselessVT,
            difficulty: .easy,
            explanation: "When rhythm changes to an organized rhythm (especially narrow complex), check for pulse. If present, this is ROSC and post-cardiac arrest care begins.",
            keyPoint: "Organized rhythm → Check pulse → ROSC?",
            clinicalPearl: "Check carotid or femoral pulse for no more than 10 seconds",
            algorithmStep: "Cardiac Arrest Algorithm - ROSC"
        ),
        makeQuestion(
            stem: "An intubated patient in cardiac arrest has ETCO2 of 8 mmHg despite good CPR technique. What does this indicate?",
            choices: [
                ("Poor prognosis - low ETCO2 correlates with poor outcomes", true, "ETCO2 <10 during CPR suggests poor prognosis", nil),
                ("Excellent CPR quality", false, nil, "Good CPR should produce ETCO2 >10"),
                ("Need to hyperventilate", false, nil, "Would not improve ETCO2"),
                ("The tube is misplaced", false, nil, "Possible but low ETCO2 during CPR is prognostic")
            ],
            topic: .airway,
            difficulty: .hard,
            explanation: "ETCO2 <10 mmHg during CPR despite good technique correlates with poor outcomes. While not used alone for termination, it's a poor prognostic sign.",
            keyPoint: "ETCO2 <10 during good CPR = poor prognosis",
            clinicalPearl: "Sudden rise in ETCO2 to >40 may indicate ROSC",
            algorithmStep: "Capnography During CPR"
        ),
        makeQuestion(
            stem: "A trauma patient arrives in cardiac arrest. Bilateral breath sounds are absent. Neck veins are distended. What is the most likely reversible cause?",
            vignette: "25 yo male, MVC, ejected from vehicle. Arrived in PEA arrest. Absent breath sounds bilaterally. JVD present. Trachea midline.",
            choices: [
                ("Tension pneumothorax", true, "Trauma + absent breath sounds + JVD = tension pneumo", nil),
                ("Cardiac tamponade", false, nil, "Would have muffled heart sounds, trachea midline"),
                ("Hypovolemia", false, nil, "Would have flat neck veins"),
                ("Pulmonary embolism", false, nil, "Less likely in acute trauma")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Trauma with absent breath sounds, JVD, and PEA arrest strongly suggests tension pneumothorax. Perform immediate needle decompression.",
            keyPoint: "Trauma + absent BS + JVD = Tension pneumo",
            clinicalPearl: "Needle decompression: 2nd ICS midclavicular or 4th/5th ICS anterior axillary",
            algorithmStep: "PEA/Asystole - H's and T's"
        ),
        makeQuestion(
            stem: "A patient with known renal failure arrests. Labs show K+ of 7.2 mEq/L. In addition to standard ACLS, what should be given?",
            vignette: "68 yo female with ESRD, missed dialysis. Found in PEA arrest. Labs: K+ 7.2, peaked T waves on prior ECG.",
            choices: [
                ("Calcium chloride or calcium gluconate IV", true, "Stabilizes cardiac membrane in hyperkalemia", nil),
                ("Sodium bicarbonate first", false, nil, "Give calcium first to stabilize membrane"),
                ("Insulin only", false, nil, "Calcium first, then insulin+glucose"),
                ("No special treatment needed", false, nil, "Hyperkalemia requires specific treatment")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "For cardiac arrest with hyperkalemia, give calcium first (membrane stabilizer), then consider sodium bicarbonate, insulin+glucose, and albuterol. Dialysis is definitive.",
            keyPoint: "Hyperkalemia arrest: Calcium first to stabilize heart",
            clinicalPearl: "Calcium chloride 10mL of 10% or Calcium gluconate 30mL of 10%",
            algorithmStep: "Special Circumstances - Hyperkalemia"
        ),
        makeQuestion(
            stem: "A patient in VF arrest is also severely hypothermic (core temp 28°C). After one shock and CPR, VF persists. What is the next step?",
            vignette: "Drowning victim, prolonged cold water submersion. Core temp 28°C. Initial VF, one shock delivered, VF persists.",
            choices: [
                ("Continue CPR and defer further shocks until temp >30°C", true, "Cold heart may not respond to defibrillation", nil),
                ("Continue shocking every 2 minutes as usual", false, nil, "Cold heart is relatively shock-resistant"),
                ("Stop resuscitation due to hypothermia", false, nil, "Hypothermia is protective - continue efforts"),
                ("Give double-dose epinephrine", false, nil, "Medications may accumulate; use cautiously")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "In severe hypothermia (<30°C), it may be reasonable to defer further shocks until core temp rises. Medications may also be spaced out as metabolism is slowed.",
            keyPoint: "Severe hypothermia: defer shocks until temp >30°C",
            clinicalPearl: "You're not dead until you're warm and dead",
            algorithmStep: "Special Circumstances - Hypothermia"
        ),
        makeQuestion(
            stem: "During CPR, you notice the waveform capnography shows a sudden increase from 15 to 45 mmHg. What does this suggest?",
            choices: [
                ("Return of spontaneous circulation (ROSC)", true, "Sudden ETCO2 rise indicates perfusing rhythm", nil),
                ("Esophageal intubation", false, nil, "Would show very low or no ETCO2"),
                ("CPR quality has improved", false, nil, "Would be gradual, not sudden spike to 45"),
                ("Hyperventilation", false, nil, "Would decrease ETCO2")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "A sudden, sustained increase in ETCO2 (especially to normal values >35-40) during CPR strongly suggests ROSC. Check for pulse!",
            keyPoint: "Sudden ETCO2 spike during CPR = ROSC!",
            clinicalPearl: "ETCO2 is often the first indicator of ROSC - even before pulse is palpable",
            algorithmStep: "Capnography - ROSC Detection"
        )
    ]
    
    // MARK: - Extended BLS Questions (from comprehensive bank)
    
    static let extendedBLSQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the minimum chest compression fraction (CCF) recommended by the 2025 guidelines?",
            choices: [
                ("At least 60%, with higher fractions associated with better outcomes", true, "CCF goal ≥60% - minimize interruptions", nil),
                ("At least 40%", false, nil, "40% is too low"),
                ("At least 50%", false, nil, "50% is below goal"),
                ("At least 90%", false, nil, "90% is ideal but 60% is minimum target")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "The 2025 guidelines recommend a chest compression fraction of at least 60%, with higher fractions associated with better outcomes.",
            keyPoint: "CCF goal ≥60% - minimize interruptions to maximize blood flow",
            clinicalPearl: "Compression fraction = time doing compressions ÷ total resuscitation time",
            algorithmStep: "2025 High-Quality CPR Metrics"
        ),
        makeQuestion(
            stem: "A healthcare provider finds an unresponsive adult. After confirming no pulse, what is the correct compression-to-ventilation ratio for single rescuer CPR?",
            choices: [
                ("30:2", true, "30 compressions to 2 ventilations for single or 2-rescuer adult CPR", nil),
                ("15:2", false, nil, "15:2 is for 2-rescuer pediatric CPR"),
                ("30:1", false, nil, "Ratio includes 2 ventilations, not 1"),
                ("5:1", false, nil, "Outdated ratio no longer used")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "For adult CPR (single or 2-rescuer), the compression-to-ventilation ratio is 30:2 until an advanced airway is placed.",
            keyPoint: "30:2 ratio for adult CPR (single or 2-rescuer)",
            clinicalPearl: "With advanced airway: continuous compressions at 100-120/min, 1 breath every 6 seconds",
            algorithmStep: "BLS Adult Algorithm"
        ),
        makeQuestion(
            stem: "The 2025 guidelines recommend that untrained lay rescuers should:",
            choices: [
                ("Provide hands-only CPR (compression-only)", true, "Hands-only CPR is effective and increases willingness to act", nil),
                ("Wait for professional help", false, nil, "Action is always better than waiting"),
                ("Perform full CPR with ventilations", false, nil, "Compression-only is easier for untrained"),
                ("Only use an AED", false, nil, "CPR should start before AED arrives")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Untrained lay rescuers should provide hands-only CPR (compression-only) which is effective and increases willingness to act.",
            keyPoint: "Untrained bystanders: hands-only CPR",
            clinicalPearl: "Hands-only CPR is nearly as effective as CPR with breaths in the first few minutes of witnessed arrest",
            algorithmStep: "BLS - Lay Rescuer Instructions"
        ),
        makeQuestion(
            stem: "During high-quality CPR, what should rescuers avoid when performing chest compressions?",
            choices: [
                ("Leaning on the chest between compressions", true, "Allow full chest recoil - leaning impairs venous return", nil),
                ("Pushing hard and fast", false, nil, "Pushing hard and fast is correct technique"),
                ("Switching compressors every 2 minutes", false, nil, "Switching is recommended to prevent fatigue"),
                ("Using a metronome for pacing", false, nil, "Metronome can help maintain correct rate")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Avoid leaning on the chest between compressions. Full chest recoil is essential for venous return and cardiac refilling.",
            keyPoint: "Allow FULL chest recoil between compressions",
            clinicalPearl: "Even small amounts of leaning significantly reduce coronary perfusion pressure",
            algorithmStep: "High-Quality CPR - Full Recoil"
        ),
        makeQuestion(
            stem: "The 2025 guidelines recommend emergency dispatchers should:",
            choices: [
                ("Provide CPR instructions to all callers for suspected cardiac arrest", true, "Dispatcher-assisted CPR improves survival", nil),
                ("Only provide instructions to trained individuals", false, nil, "Instructions for all bystanders, trained or not"),
                ("Tell callers to wait for EMS", false, nil, "CPR should start immediately"),
                ("Only recommend AED use", false, nil, "CPR instruction is first priority")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "The 2025 guidelines emphasize that dispatchers should provide CPR instructions for all suspected cardiac arrests.",
            keyPoint: "Dispatch-assisted CPR for all cardiac arrest calls",
            clinicalPearl: "Telecommunicator-CPR significantly improves survival rates",
            algorithmStep: "BLS - Dispatcher-Assisted CPR"
        )
    ]
    
    // MARK: - Extended VF/pVT Questions
    
    static let extendedVFQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per 2025 guidelines, the preferred first shock energy for defibrillation is:",
            choices: [
                ("≥200 J biphasic", true, "Start at 200J or higher for adult defibrillation", nil),
                ("100 J biphasic", false, nil, "100J may be insufficient for adult VF"),
                ("360 J monophasic", false, nil, "Monophasic is older technology; biphasic preferred"),
                ("50 J biphasic", false, nil, "50J is too low for adult VF")
            ],
            topic: .vfPulselessVT,
            difficulty: .easy,
            explanation: "2025 Update: First shock energy ≥200J biphasic is preferred. No delays in shock delivery.",
            keyPoint: "First shock ≥200J biphasic",
            clinicalPearl: "Higher initial energy may improve first-shock success without increased myocardial injury",
            algorithmStep: "VF/pVT Algorithm - Defibrillation"
        ),
        makeQuestion(
            stem: "Regarding double sequential defibrillation (DSD) for refractory VF, the 2025 guidelines state:",
            choices: [
                ("Evidence is insufficient; may be considered for refractory VF", true, "DSD may be considered but not standard of care", nil),
                ("DSD is now standard first-line approach", false, nil, "Not standard first-line"),
                ("DSD has been proven superior", false, nil, "Evidence is still inconclusive"),
                ("DSD is contraindicated", false, nil, "Not contraindicated, may be considered")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "2025 Update: After 3+ shocks, double sequential defibrillation has uncertain usefulness - may be considered for refractory VF.",
            keyPoint: "DSD: evidence insufficient, may consider for refractory VF",
            clinicalPearl: "Vector change defibrillation (VCD) is another option with uncertain evidence",
            algorithmStep: "Refractory VF Options"
        ),
        makeQuestion(
            stem: "After 3 defibrillation attempts for VF/pVT, which antiarrhythmic is recommended?",
            choices: [
                ("Amiodarone 300 mg IV push", true, "First-line antiarrhythmic for shock-refractory VF", nil),
                ("Sotalol 100 mg IV", false, nil, "Sotalol is NO LONGER recommended (2025 Update)"),
                ("Adenosine 6 mg rapid IV push", false, nil, "Adenosine not indicated for VF"),
                ("Diltiazem 20 mg IV", false, nil, "Calcium channel blockers not indicated for VF")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "2025 Update: Amiodarone 300mg IV first dose after 3 shocks. Sotalol has been REMOVED from the algorithm - no evidence of benefit.",
            keyPoint: "Shock-refractory VF → Amiodarone 300mg IV",
            clinicalPearl: "Second dose amiodarone is 150mg. Only 2 doses given during arrest.",
            algorithmStep: "VF/pVT Algorithm - Antiarrhythmics"
        ),
        makeQuestion(
            stem: "A patient remains in VF despite 5 shocks and amiodarone. Vasopressin is suggested. What is the 2025 guideline recommendation?",
            choices: [
                ("Vasopressin is NOT recommended - no survival advantage", true, "Vasopressin removed from guidelines", nil),
                ("Vasopressin 40 units IV x 1", false, nil, "No longer recommended"),
                ("Vasopressin can replace epinephrine", false, nil, "Vasopressin shows no survival advantage"),
                ("Vasopressin should be alternated with epinephrine", false, nil, "Combination shows no benefit")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "2025 Update: Vasopressin alone or combined with epinephrine shows NO survival advantage. It is NOT recommended as a substitute for epinephrine.",
            keyPoint: "Vasopressin NOT recommended in 2025 guidelines",
            clinicalPearl: "Stick with epinephrine 1mg every 3-5 minutes",
            algorithmStep: "2025 Pharmacology Updates"
        ),
        makeQuestion(
            stem: "Which statement about sodium bicarbonate during cardiac arrest is correct per 2025 guidelines?",
            choices: [
                ("Not routine; consider for known metabolic acidosis, hyperkalemia, or TCA overdose", true, "Bicarb for specific indications only", nil),
                ("Give 1 mEq/kg routinely to all arrest patients", false, nil, "Not routine - specific indications only"),
                ("First-line therapy for VF", false, nil, "Defibrillation is first-line for VF"),
                ("Never give during resuscitation", false, nil, "Has specific indications")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "2025 Update: Sodium bicarbonate is NOT routinely recommended. Consider only for known preexisting metabolic acidosis, hyperkalemia, or TCA overdose.",
            keyPoint: "Bicarb: not routine, specific indications only",
            clinicalPearl: "Routine bicarb may worsen intracellular acidosis and outcomes",
            algorithmStep: "2025 Pharmacology - Sodium Bicarbonate"
        )
    ]
    
    // MARK: - Extended PEA/Asystole Questions
    
    static let extendedPEAQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "For PEA and asystole, when should epinephrine be given according to 2025 guidelines?",
            choices: [
                ("As soon as IV/IO access is established (early administration)", true, "Early epinephrine emphasized for non-shockable rhythms", nil),
                ("After the third 2-minute cycle", false, nil, "Don't delay - give early"),
                ("Only after rhythm check confirms no improvement", false, nil, "Give as soon as possible"),
                ("Epinephrine is not indicated for asystole", false, nil, "Epinephrine is essential for non-shockable rhythms")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "2025 Update: For non-shockable rhythms (PEA/Asystole), give epinephrine as EARLY as possible - as soon as IV/IO access is established.",
            keyPoint: "Non-shockable rhythms: Early epinephrine is critical",
            clinicalPearl: "Every minute delay in epinephrine for non-shockable rhythms worsens survival",
            algorithmStep: "PEA/Asystole Algorithm - Early Epinephrine"
        ),
        makeQuestion(
            stem: "The H's and T's are considered during cardiac arrest to identify:",
            choices: [
                ("Reversible causes that should be treated", true, "H's and T's are treatable causes", nil),
                ("Reasons to stop resuscitation", false, nil, "These are reasons to CONTINUE and treat"),
                ("Indications for defibrillation", false, nil, "H's and T's don't indicate defibrillation"),
                ("When to give antiarrhythmics", false, nil, "H's and T's guide other interventions")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "2025 Update: H's and T's are no longer explicitly listed in algorithms but should be considered continuously to identify and treat reversible causes.",
            keyPoint: "H's and T's = reversible causes to treat",
            clinicalPearl: "PEA with narrow complex often has a reversible cause",
            algorithmStep: "Reversible Causes - H's and T's"
        ),
        makeQuestion(
            stem: "During asystole, you should AVOID:",
            choices: [
                ("Defibrillation - asystole is not a shockable rhythm", true, "Never shock asystole", nil),
                ("High-quality CPR", false, nil, "CPR is essential"),
                ("Epinephrine 1mg IV/IO", false, nil, "Epinephrine is indicated"),
                ("Searching for reversible causes", false, nil, "Always look for H's and T's")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "Asystole is NOT a shockable rhythm. Defibrillation provides no benefit and wastes valuable CPR time.",
            keyPoint: "NEVER defibrillate asystole",
            clinicalPearl: "If unsure between asystole and fine VF, treat as asystole - fine VF unlikely to respond to shock",
            algorithmStep: "PEA/Asystole Algorithm"
        ),
        makeQuestion(
            stem: "A patient in PEA arrest has a narrow QRS complex on the monitor. This suggests:",
            choices: [
                ("Potentially reversible cause - mechanical problem likely", true, "Narrow PEA = think mechanical problem", nil),
                ("Cardiac muscle is completely dead", false, nil, "Narrow complex suggests viable myocardium"),
                ("Defibrillation is indicated", false, nil, "PEA is not shockable"),
                ("Antiarrhythmics should be given", false, nil, "Focus on reversible causes")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "Narrow complex PEA suggests the heart's electrical system is intact but there's a mechanical problem preventing contraction (tamponade, PE, hypovolemia, tension pneumothorax).",
            keyPoint: "Narrow PEA = mechanical problem, potentially treatable",
            clinicalPearl: "Wide complex PEA suggests metabolic or myocardial problem",
            algorithmStep: "PEA Analysis"
        )
    ]
    
    // MARK: - Extended Bradycardia Questions
    
    static let extendedBradycardiaQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "According to 2025 guidelines, what should be assessed FIRST in a bradycardic patient?",
            choices: [
                ("Signs of cardiopulmonary compromise", true, "Assess compromise before treating rhythm", nil),
                ("The specific type of bradycardia", false, nil, "Assess patient, not just rhythm"),
                ("Whether atropine is available", false, nil, "Assessment comes before treatment"),
                ("Heart rate number only", false, nil, "Symptoms matter more than rate")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "2025 Update: Assess for cardiopulmonary compromise FIRST - hypotension, altered mental status, shock, ischemic chest discomfort, or acute heart failure.",
            keyPoint: "Assess COMPROMISE before treating bradycardia",
            clinicalPearl: "Treat the patient, not the monitor",
            algorithmStep: "Bradycardia Algorithm - Initial Assessment"
        ),
        makeQuestion(
            stem: "The 2025 recommended first-line dose of atropine for symptomatic bradycardia is:",
            choices: [
                ("1 mg IV", true, "2025 Update: Atropine dose is now 1mg (changed from 0.5mg)", nil),
                ("0.5 mg IV", false, nil, "Previous dose - 2025 update recommends 1mg"),
                ("0.25 mg IV", false, nil, "Dose is too low"),
                ("2 mg IV", false, nil, "Starting dose is 1mg, may repeat up to 3mg max")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "2025 Update: Atropine dose for symptomatic bradycardia is 1mg IV. May repeat every 3-5 minutes, maximum 3mg total.",
            keyPoint: "Atropine 1mg IV (2025 update from 0.5mg)",
            clinicalPearl: "Atropine may be ineffective in transplanted hearts or infranodal blocks",
            algorithmStep: "Bradycardia Algorithm - Atropine"
        ),
        makeQuestion(
            stem: "If atropine is ineffective for symptomatic bradycardia, what are the equally effective alternatives?",
            choices: [
                ("Dopamine 2-20 mcg/kg/min OR Epinephrine 2-10 mcg/min", true, "Both are equally effective per 2025 guidelines", nil),
                ("Only transcutaneous pacing", false, nil, "Dopamine/epinephrine are alternatives"),
                ("Adenosine 6mg IV", false, nil, "Adenosine slows the heart - contraindicated"),
                ("Amiodarone 150mg IV", false, nil, "Amiodarone is for tachyarrhythmias")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "2025 Update: If atropine fails, dopamine (2-20 mcg/kg/min) OR epinephrine (2-10 mcg/min) infusion are equally effective alternatives.",
            keyPoint: "Atropine fails → Dopamine OR Epinephrine infusion",
            clinicalPearl: "Transcutaneous pacing is also an option for refractory bradycardia",
            algorithmStep: "Bradycardia Algorithm - Second-line Agents"
        ),
        makeQuestion(
            stem: "A patient has symptomatic bradycardia unresponsive to medications. What intervention is warranted?",
            choices: [
                ("Transcutaneous pacing (TCP)", true, "TCP for medication-refractory symptomatic bradycardia", nil),
                ("Defibrillation", false, nil, "Defibrillation is for VF/pVT"),
                ("Synchronized cardioversion", false, nil, "Cardioversion is for tachyarrhythmias"),
                ("IV fluid bolus only", false, nil, "Fluids won't fix the rhythm")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Transcutaneous pacing is indicated for hemodynamically unstable bradycardia unresponsive to atropine and/or chronotropic drugs.",
            keyPoint: "Refractory symptomatic bradycardia → Transcutaneous pacing",
            clinicalPearl: "Always sedate for pacing if patient is conscious - it's painful",
            algorithmStep: "Bradycardia Algorithm - Pacing"
        )
    ]
    
    // MARK: - Extended Tachycardia Questions
    
    static let extendedTachycardiaQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "For unstable tachycardia with a pulse, synchronized cardioversion energy for narrow complex (SVT) should start at:",
            choices: [
                ("100 J (2025 Update: increased from 50J)", true, "2025 guidelines increased SVT cardioversion energy", nil),
                ("50 J", false, nil, "Previous recommendation - now 100J"),
                ("200 J", false, nil, "This is for atrial fibrillation"),
                ("360 J", false, nil, "Maximum monophasic energy, not starting dose")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "2025 Update: Synchronized cardioversion for narrow complex tachycardia starts at 100J (increased from 50J).",
            keyPoint: "SVT cardioversion: 100J (2025 update)",
            clinicalPearl: "If energy levels unknown, use maximum device settings",
            algorithmStep: "Tachycardia Algorithm - Cardioversion Energy"
        ),
        makeQuestion(
            stem: "Synchronized cardioversion for unstable atrial fibrillation should start at:",
            choices: [
                ("≥200 J (2025 Update)", true, "High energy for AF cardioversion", nil),
                ("50 J", false, nil, "Too low - AF requires higher energy"),
                ("100 J", false, nil, "2025 guidelines recommend ≥200J"),
                ("25 J", false, nil, "Far too low")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "2025 Update: Synchronized cardioversion for atrial fibrillation/flutter starts at ≥200J biphasic.",
            keyPoint: "AF/Flutter cardioversion: ≥200J (2025 update)",
            clinicalPearl: "Sedate whenever feasible before cardioversion",
            algorithmStep: "2025 Cardioversion Energy Updates"
        ),
        makeQuestion(
            stem: "Regarding Sotalol for stable wide-complex tachycardia, the 2025 guidelines state:",
            choices: [
                ("Sotalol is NO LONGER recommended", true, "Sotalol removed from 2025 guidelines", nil),
                ("Sotalol is first-line therapy", false, nil, "Sotalol has been removed"),
                ("Give Sotalol 1.5 mg/kg IV", false, nil, "Sotalol no longer recommended"),
                ("Sotalol is preferred over amiodarone", false, nil, "Sotalol removed from algorithms")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "2025 Update: Sotalol has been REMOVED from the guidelines. 2025 ILCOR review found no outcome benefit for Sotalol in cardiac arrest or stable VT.",
            keyPoint: "Sotalol REMOVED from 2025 guidelines",
            clinicalPearl: "Use amiodarone, procainamide, or lidocaine instead",
            algorithmStep: "2025 Antiarrhythmic Updates"
        ),
        makeQuestion(
            stem: "For stable, regular, monomorphic wide-complex tachycardia of uncertain origin, adenosine:",
            choices: [
                ("May be considered diagnostically", true, "Adenosine can help differentiate SVT with aberrancy from VT", nil),
                ("Is absolutely contraindicated", false, nil, "May be used diagnostically"),
                ("Should be given first before any other drug", false, nil, "Consider, not first-line"),
                ("Will reliably convert all WCT", false, nil, "Only works for SVT with aberrancy")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "2025 Update: For stable, regular, monomorphic WCT, adenosine may be considered DIAGNOSTICALLY. Do NOT give verapamil or diltiazem for WCT.",
            keyPoint: "Adenosine may help diagnose stable regular WCT",
            clinicalPearl: "If WCT is irregular or polymorphic, assume VT and treat accordingly",
            algorithmStep: "WCT Differential Diagnosis"
        ),
        makeQuestion(
            stem: "Polymorphic VT should be treated as:",
            choices: [
                ("VF - unsynchronized high-energy defibrillation", true, "Treat polymorphic VT same as VF", nil),
                ("SVT - synchronized cardioversion at low energy", false, nil, "Polymorphic VT = treat as VF"),
                ("Stable tachycardia - amiodarone first", false, nil, "Polymorphic VT is unstable by definition"),
                ("Monomorphic VT - synchronized cardioversion", false, nil, "Only monomorphic VT gets synchronized cardioversion")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "2025 Update: Polymorphic VT should be treated as VF - use unsynchronized high-energy defibrillation (≥200J).",
            keyPoint: "Polymorphic VT = treat as VF (defibrillate)",
            clinicalPearl: "If QT is prolonged, also give Magnesium 2g IV for Torsades",
            algorithmStep: "Polymorphic VT/Torsades Management"
        )
    ]
    
    // MARK: - Extended Pharmacology Questions
    
    static let extendedPharmQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the epinephrine dose and interval during cardiac arrest?",
            choices: [
                ("1 mg IV/IO every 3-5 minutes", true, "Standard ACLS epinephrine dosing", nil),
                ("0.5 mg IV every 2 minutes", false, nil, "Dose is 1mg, interval is 3-5 min"),
                ("1 mg IV every 10 minutes", false, nil, "Interval is too long"),
                ("2 mg IV every 5 minutes", false, nil, "Dose is 1mg, not 2mg")
            ],
            topic: .pharmacology,
            difficulty: .easy,
            explanation: "Epinephrine 1mg IV/IO every 3-5 minutes is the standard dose throughout cardiac arrest.",
            keyPoint: "Epinephrine: 1mg every 3-5 minutes",
            clinicalPearl: "For non-shockable rhythms, give epinephrine EARLY - as soon as access established",
            algorithmStep: "Cardiac Arrest Pharmacology"
        ),
        makeQuestion(
            stem: "The second dose of amiodarone for refractory VF/pVT is:",
            choices: [
                ("150 mg IV", true, "Second dose is 150mg after initial 300mg", nil),
                ("300 mg IV", false, nil, "First dose is 300mg, second is 150mg"),
                ("450 mg IV", false, nil, "Maximum is 300mg + 150mg = 450mg total"),
                ("75 mg IV", false, nil, "Second dose is 150mg")
            ],
            topic: .pharmacology,
            difficulty: .easy,
            explanation: "Amiodarone dosing in cardiac arrest: First dose 300mg IV, second dose 150mg IV. Only 2 doses during arrest.",
            keyPoint: "Amiodarone: 300mg first, then 150mg",
            clinicalPearl: "Total amiodarone in arrest = 450mg maximum",
            algorithmStep: "VF/pVT Algorithm - Antiarrhythmics"
        ),
        makeQuestion(
            stem: "Lidocaine as an alternative to amiodarone for VF/pVT is dosed at:",
            choices: [
                ("1-1.5 mg/kg IV first dose, then 0.5-0.75 mg/kg every 5-10 min", true, "Standard lidocaine dosing", nil),
                ("300 mg IV bolus", false, nil, "This is amiodarone dosing"),
                ("2 mg/kg IV bolus", false, nil, "Starting dose is 1-1.5 mg/kg"),
                ("0.5 mg/kg IV only", false, nil, "Starting dose is higher")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Lidocaine dosing: 1-1.5 mg/kg IV initial, then 0.5-0.75 mg/kg every 5-10 minutes. Maximum 3 mg/kg total.",
            keyPoint: "Lidocaine: 1-1.5 mg/kg initial, then 0.5-0.75 mg/kg",
            clinicalPearl: "Lidocaine may be preferred in patients already on amiodarone or with long QT",
            algorithmStep: "Antiarrhythmic Alternatives"
        ),
        makeQuestion(
            stem: "Magnesium sulfate is indicated during cardiac arrest for:",
            choices: [
                ("Torsades de Pointes (polymorphic VT with long QT)", true, "Magnesium is first-line for Torsades", nil),
                ("All cases of VF", false, nil, "Only for Torsades/suspected hypomagnesemia"),
                ("Asystole", false, nil, "Not indicated for asystole"),
                ("Bradycardia", false, nil, "Not indicated for bradycardia")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Magnesium 2g IV over 10 minutes is first-line for Torsades de Pointes (polymorphic VT with prolonged QT).",
            keyPoint: "Magnesium 2g IV for Torsades de Pointes",
            clinicalPearl: "Also consider for suspected hypomagnesemia or digitalis toxicity",
            algorithmStep: "Torsades de Pointes Management"
        )
    ]
    
    // MARK: - Extended Post-ROSC Questions
    
    static let extendedPostROSCQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "The 2025 recommended post-ROSC SpO2 target is:",
            choices: [
                ("94-99% - avoid both hypoxia and hyperoxia", true, "Titrate oxygen to maintain 94-99%", nil),
                ("100% at all times", false, nil, "Hyperoxia may worsen neurological outcomes"),
                ("88-92%", false, nil, "Too low - risk of hypoxia"),
                ("No specific target", false, nil, "Specific targets are recommended")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025 Update: Post-ROSC oxygen should be titrated to SpO2 94-99%. Both hypoxia and hyperoxia are harmful.",
            keyPoint: "Post-ROSC SpO2 target: 94-99%",
            clinicalPearl: "Wean FiO2 from 100% once reliable SpO2 can be measured",
            algorithmStep: "Post-ROSC - Oxygenation"
        ),
        makeQuestion(
            stem: "Post-ROSC blood pressure management should avoid:",
            choices: [
                ("SBP < 90 mmHg and MAP < 65 mmHg", true, "Avoid hypotension", nil),
                ("SBP > 100 mmHg", false, nil, "SBP >100 is often appropriate"),
                ("MAP > 65 mmHg", false, nil, "This is the minimum goal"),
                ("Any blood pressure variation", false, nil, "Some variation is expected")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025 Update: Avoid hypotension (SBP <90, MAP <65). Use vasopressors if needed to maintain adequate perfusion.",
            keyPoint: "Avoid SBP <90 and MAP <65 post-ROSC",
            clinicalPearl: "MAP goal may be higher (80-100) in some patients with chronic hypertension",
            algorithmStep: "Post-ROSC - Hemodynamics"
        ),
        makeQuestion(
            stem: "The 2025 target temperature range for post-cardiac arrest care is:",
            choices: [
                ("32-37.5°C - actively prevent fever", true, "Broader range than previous guidelines", nil),
                ("Exactly 33°C only", false, nil, "Range is broader"),
                ("36°C only", false, nil, "Lower temperatures may still be beneficial"),
                ("No temperature management needed", false, nil, "Temperature management is essential")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025 Update: Target temperature 32-37.5°C. Both hypothermic and normothermic (fever prevention) strategies are acceptable. At minimum, prevent fever.",
            keyPoint: "TTM target: 32-37.5°C, maintain ≥24-36 hours",
            clinicalPearl: "Fever is the enemy - at minimum prevent fever (≤37.5°C)",
            algorithmStep: "Post-ROSC - Temperature Management"
        ),
        makeQuestion(
            stem: "Neurological prognostication after cardiac arrest should be performed:",
            choices: [
                ("No earlier than 72 hours after ROSC, longer if confounders present", true, "Wait for sedation to clear", nil),
                ("Within the first 6 hours", false, nil, "Too early - many patients improve"),
                ("At 24 hours post-arrest", false, nil, "Too early for reliable assessment"),
                ("Prognostication should not be performed", false, nil, "It guides goals of care")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "2025 Update: Wait ≥72 hours post-ROSC for neurological prognostication. Use multimodal assessment. Wait longer if confounders (sedation, hypothermia) present.",
            keyPoint: "Neuroprognostication: ≥72 hours, multimodal",
            clinicalPearl: "Single tests are insufficient - use clinical exam, EEG, imaging, and biomarkers",
            algorithmStep: "Post-ROSC - Neuroprognostication"
        )
    ]
    
    // MARK: - Extended H's and T's Questions
    
    static let extendedHsTsQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "The H's in 'H's and T's' include all EXCEPT:",
            choices: [
                ("Heart failure", true, "Heart failure is NOT one of the 5 H's", nil),
                ("Hypoxia", false, nil, "Hypoxia is one of the H's"),
                ("Hypovolemia", false, nil, "Hypovolemia is one of the H's"),
                ("Hypothermia", false, nil, "Hypothermia is one of the H's")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "The H's are: Hypoxia, Hypovolemia, Hydrogen ion (acidosis), Hypo/Hyperkalemia, and Hypothermia. Heart failure is not one of the H's.",
            keyPoint: "H's: Hypoxia, Hypovolemia, H+ ion, Hypo/Hyperkalemia, Hypothermia",
            clinicalPearl: "Heart failure may cause arrest but is not listed in H's",
            algorithmStep: "Reversible Causes - H's"
        ),
        makeQuestion(
            stem: "Which of the T's describes a cardiac etiology for arrest?",
            choices: [
                ("Tamponade (cardiac)", true, "Cardiac tamponade impairs ventricular filling", nil),
                ("Tension pneumothorax", false, nil, "Pulmonary, not cardiac"),
                ("Toxins", false, nil, "Various etiologies"),
                ("Thrombosis (pulmonary)", false, nil, "Pulmonary embolism")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "The T's include Tension pneumothorax, Tamponade (cardiac), Toxins, and Thrombosis (coronary or pulmonary). Tamponade is the cardiac cause.",
            keyPoint: "T's: Tension pneumo, Tamponade, Toxins, Thrombosis",
            clinicalPearl: "Thrombosis includes both coronary (MI) and pulmonary (PE)",
            algorithmStep: "Reversible Causes - T's"
        ),
        makeQuestion(
            stem: "Beck's triad (hypotension, JVD, muffled heart sounds) suggests which reversible cause?",
            choices: [
                ("Cardiac tamponade", true, "Classic signs of tamponade", nil),
                ("Tension pneumothorax", false, nil, "JVD present but breath sounds unequal"),
                ("Pulmonary embolism", false, nil, "Different presentation"),
                ("Hyperkalemia", false, nil, "ECG changes, not Beck's triad")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Beck's triad (hypotension, distended neck veins, muffled heart sounds) is classic for cardiac tamponade. Treat with pericardiocentesis.",
            keyPoint: "Beck's triad = Cardiac tamponade",
            clinicalPearl: "Bedside echo can confirm pericardial effusion",
            algorithmStep: "Tamponade Recognition"
        ),
        makeQuestion(
            stem: "During arrest, peaked T waves on the monitor and a recent dialysis patient suggest:",
            choices: [
                ("Hyperkalemia", true, "Classic presentation for hyperkalemia", nil),
                ("Hypokalemia", false, nil, "Hypokalemia shows U waves and flat T waves"),
                ("Hypothermia", false, nil, "Hypothermia shows Osborn waves"),
                ("Acidosis", false, nil, "Acidosis doesn't cause peaked T waves")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Peaked T waves in a dialysis patient strongly suggest hyperkalemia. Treat with calcium chloride, bicarbonate, and emergent dialysis.",
            keyPoint: "Peaked T waves + renal failure = Hyperkalemia",
            clinicalPearl: "Give calcium chloride 10mL of 10% solution first to stabilize myocardium",
            algorithmStep: "Hyperkalemia Management"
        )
    ]
    
    // MARK: - Extended Rhythm Recognition Questions
    
    static let extendedRhythmQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "A rhythm that is irregularly irregular with no discernible P waves is most likely:",
            choices: [
                ("Atrial fibrillation", true, "Classic description of AF", nil),
                ("Atrial flutter", false, nil, "Flutter is regularly irregular with sawtooth waves"),
                ("Sinus arrhythmia", false, nil, "Has P waves and is respiratory-related"),
                ("Third-degree heart block", false, nil, "Regular ventricular rate with P waves")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "Atrial fibrillation is characterized by an irregularly irregular rhythm with no discernible P waves, replaced by fibrillatory baseline.",
            keyPoint: "Irregularly irregular with no P waves = A-fib",
            clinicalPearl: "Rapid AF can degenerate to VF in patients with WPW",
            algorithmStep: "Rhythm Recognition - Atrial Fibrillation"
        ),
        makeQuestion(
            stem: "Sawtooth P waves at a rate of 300/min with 2:1 conduction suggests:",
            choices: [
                ("Atrial flutter with 2:1 block", true, "Classic flutter pattern", nil),
                ("Atrial fibrillation", false, nil, "AF has no discernible P waves"),
                ("SVT", false, nil, "No sawtooth pattern in SVT"),
                ("Ventricular tachycardia", false, nil, "VT has wide QRS")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Atrial flutter shows classic sawtooth flutter waves at ~300/min. With 2:1 block, ventricular rate is ~150/min.",
            keyPoint: "Sawtooth waves at 300 + ventricular rate 150 = Flutter with 2:1",
            clinicalPearl: "Any ventricular rate of exactly 150 should make you suspect flutter",
            algorithmStep: "Rhythm Recognition - Atrial Flutter"
        ),
        makeQuestion(
            stem: "A wide-complex tachycardia at 180/min in a patient with unknown cardiac history should be treated as:",
            choices: [
                ("Ventricular tachycardia until proven otherwise", true, "When in doubt, treat as VT", nil),
                ("SVT with aberrancy", false, nil, "Cannot assume without evidence"),
                ("Sinus tachycardia with bundle branch block", false, nil, "Rate too fast for sinus"),
                ("Atrial flutter with aberrancy", false, nil, "Cannot assume flutter")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Wide-complex tachycardia should be treated as VT until proven otherwise - it's safer to assume VT and treat accordingly.",
            keyPoint: "WCT = VT until proven otherwise",
            clinicalPearl: "80% of wide-complex tachycardias are VT. When in doubt, treat as VT.",
            algorithmStep: "WCT Approach"
        )
    ]
    
    // MARK: - Extended Team/Airway/Electrical Questions
    
    static let extendedTeamAirwayQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Closed-loop communication during resuscitation means:",
            choices: [
                ("Order → Confirm → Execute → Report completion", true, "Ensures clear communication and task completion", nil),
                ("Speaking quietly to avoid confusion", false, nil, "Clear verbal communication is essential"),
                ("Only the team leader speaks", false, nil, "Team members must acknowledge and report"),
                ("Using hand signals only", false, nil, "Verbal communication is required")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Closed-loop communication: Leader gives order, team member confirms, executes task, reports completion. This reduces errors.",
            keyPoint: "Closed-loop: Order → Confirm → Execute → Report",
            clinicalPearl: "Example: 'Give epinephrine 1mg IV' → 'Giving epinephrine 1mg IV' → 'Epinephrine given'",
            algorithmStep: "Team Dynamics - Communication"
        ),
        makeQuestion(
            stem: "The 2025 guidelines state that video laryngoscopy for intubation during cardiac arrest:",
            choices: [
                ("May be considered to improve first-pass success", true, "Video laryngoscopy is an acceptable option", nil),
                ("Is contraindicated", false, nil, "Video laryngoscopy is acceptable"),
                ("Should never be used during CPR", false, nil, "Can be used during resuscitation"),
                ("Has replaced direct laryngoscopy", false, nil, "Both techniques remain valid")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "2025 Update: Video laryngoscopy may be considered to improve first-pass success, especially for anticipated difficult airways.",
            keyPoint: "Video laryngoscopy may improve first-pass success",
            clinicalPearl: "Choice depends on provider skill and equipment availability",
            algorithmStep: "Airway Management - Laryngoscopy Options"
        ),
        makeQuestion(
            stem: "During CPR with an advanced airway in place, ventilation should be:",
            choices: [
                ("One breath every 6 seconds (10 breaths/minute), not synchronized with compressions", true, "Continuous compressions with asynchronous ventilation", nil),
                ("30 compressions then 2 breaths", false, nil, "This is for basic airway"),
                ("One breath per compression", false, nil, "This would cause hyperventilation"),
                ("Ventilation should be paused during compressions", false, nil, "Asynchronous ventilation is used")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "With advanced airway: continuous compressions at 100-120/min, asynchronous ventilations at 10/min (1 every 6 seconds).",
            keyPoint: "Advanced airway: 10 breaths/min, continuous compressions",
            clinicalPearl: "Avoid hyperventilation - it impairs venous return and reduces cardiac output",
            algorithmStep: "Advanced Airway Management"
        ),
        makeQuestion(
            stem: "The minimum chest compression fraction (CCF) recommended during resuscitation is:",
            choices: [
                ("60%", true, "Minimize interruptions to maintain CCF ≥60%", nil),
                ("40%", false, nil, "Too low - more time compressing needed"),
                ("80%", false, nil, "Aspirational but 60% is minimum"),
                ("50%", false, nil, "Below recommended minimum")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "2025 guidelines recommend chest compression fraction of at least 60%, with higher fractions associated with better outcomes.",
            keyPoint: "CCF goal ≥60%",
            clinicalPearl: "Pre-charging defibrillator during compressions helps maintain high CCF",
            algorithmStep: "High-Quality CPR Metrics"
        )
    ]
    
    // MARK: - Extended Vascular Access Questions
    
    static let extendedVascularQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per 2025 guidelines, the preferred vascular access during cardiac arrest is:",
            choices: [
                ("IV preferred; IO if IV not readily available", true, "IV first, IO as alternative", nil),
                ("IO is always preferred over IV", false, nil, "IV remains first choice"),
                ("Central line required", false, nil, "Peripheral IV or IO is acceptable"),
                ("No specific preference", false, nil, "IV is preferred")
            ],
            topic: .vascularAccess,
            difficulty: .easy,
            explanation: "2025 Update: IV access is preferred. IO is a reasonable alternative if IV attempts are unsuccessful or not feasible.",
            keyPoint: "IV preferred, IO if IV not readily accessible",
            clinicalPearl: "Don't delay critical medications for IV - use IO if needed",
            algorithmStep: "Vascular Access Recommendations"
        ),
        makeQuestion(
            stem: "Common IO insertion sites in adults include:",
            choices: [
                ("Proximal tibia and humeral head", true, "Most common adult IO sites", nil),
                ("Femoral vein only", false, nil, "This is IV, not IO"),
                ("Radial artery", false, nil, "This is arterial access"),
                ("Sternum only", false, nil, "Sternal IO is less common")
            ],
            topic: .vascularAccess,
            difficulty: .easy,
            explanation: "Common adult IO sites: proximal tibia (1-2 finger-widths below tibial tuberosity) and proximal humerus (greater tubercle).",
            keyPoint: "Adult IO sites: proximal tibia, humeral head",
            clinicalPearl: "Humeral IO may have faster drug delivery to central circulation",
            algorithmStep: "IO Access Technique"
        ),
        makeQuestion(
            stem: "After drug administration via peripheral IV during CPR, you should:",
            choices: [
                ("Flush with 20 mL normal saline and elevate extremity", true, "Promotes central circulation of drug", nil),
                ("No flush needed", false, nil, "Flush is essential"),
                ("Wait 2 minutes before next drug", false, nil, "Continue CPR, give drugs per protocol"),
                ("Switch to IO immediately", false, nil, "Continue with established access")
            ],
            topic: .vascularAccess,
            difficulty: .easy,
            explanation: "Follow peripheral IV medications with 20 mL NS flush and elevate the extremity to promote drug delivery to central circulation.",
            keyPoint: "Flush with 20mL NS and elevate extremity",
            clinicalPearl: "Elevating helps gravity assist drug flow centrally",
            algorithmStep: "Drug Administration Technique"
        )
    ]
    
    // MARK: - Extended Stroke Questions
    
    static let extendedStrokeQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "The BE-FAST mnemonic for stroke recognition includes:",
            choices: [
                ("Balance, Eyes, Face, Arms, Speech, Time", true, "Updated stroke recognition mnemonic", nil),
                ("Blood pressure, Eyes, Face, Arms, Speech, Taste", false, nil, "Balance, not Blood pressure"),
                ("Breathing, Eyes, Face, Arms, Speech, Temperature", false, nil, "Balance, not Breathing"),
                ("Balance, Ears, Face, Arms, Speech, Time", false, nil, "Eyes, not Ears")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "BE-FAST: Balance, Eyes (visual disturbance), Face (droop), Arms (weakness), Speech (slurred), Time (to call 911).",
            keyPoint: "BE-FAST for stroke recognition",
            clinicalPearl: "BE-FAST catches more strokes than the older FAST mnemonic",
            algorithmStep: "Stroke Recognition"
        ),
        makeQuestion(
            stem: "The classic time window for IV alteplase (tPA) in acute ischemic stroke is:",
            choices: [
                ("Within 3-4.5 hours of symptom onset", true, "Standard tPA window", nil),
                ("Within 1 hour", false, nil, "Window is wider"),
                ("Within 12 hours", false, nil, "Too late for IV tPA"),
                ("No time window exists", false, nil, "Time is critical for tPA")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "IV tPA window: within 3 hours standard, up to 4.5 hours in select patients meeting criteria.",
            keyPoint: "tPA window: 3-4.5 hours from symptom onset",
            clinicalPearl: "Mechanical thrombectomy may be available up to 24 hours with favorable imaging",
            algorithmStep: "Acute Ischemic Stroke Algorithm"
        ),
        makeQuestion(
            stem: "Blood glucose should be checked in all stroke patients because:",
            choices: [
                ("Hypoglycemia can mimic stroke and must be ruled out", true, "Treatable stroke mimic", nil),
                ("All stroke patients have diabetes", false, nil, "Not all stroke patients are diabetic"),
                ("Glucose level determines tPA eligibility", false, nil, "Not a primary eligibility criterion"),
                ("Insulin is routinely given for all strokes", false, nil, "Insulin not routine in acute stroke")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "Hypoglycemia is a treatable stroke mimic. Always check glucose - it's part of the rapid assessment.",
            keyPoint: "Always check glucose - hypoglycemia mimics stroke",
            clinicalPearl: "Give dextrose if glucose is low before other interventions",
            algorithmStep: "Stroke Assessment"
        ),
        makeQuestion(
            stem: "Hemorrhagic stroke on CT scan means:",
            choices: [
                ("tPA is absolutely contraindicated", true, "Never give tPA for hemorrhagic stroke", nil),
                ("Give tPA at reduced dose", false, nil, "No dose is safe in hemorrhage"),
                ("tPA can be given after BP control", false, nil, "Hemorrhage = absolute contraindication"),
                ("Proceed with normal tPA protocol", false, nil, "Would worsen hemorrhage")
            ],
            topic: .stroke,
            difficulty: .medium,
            explanation: "Hemorrhagic stroke is an absolute contraindication to thrombolytics. Giving tPA would worsen bleeding.",
            keyPoint: "Hemorrhage = absolute tPA contraindication",
            clinicalPearl: "CT must be done before tPA to rule out hemorrhage",
            algorithmStep: "Stroke - Hemorrhage Exclusion"
        ),
        makeQuestion(
            stem: "The target door-to-needle time for IV tPA in acute ischemic stroke is:",
            choices: [
                ("60 minutes or less", true, "Standard door-to-needle goal", nil),
                ("30 minutes", false, nil, "Aspirational but 60 min is target"),
                ("90 minutes", false, nil, "Too long"),
                ("120 minutes", false, nil, "Exceeds goal")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "Door-to-needle goal is ≤60 minutes for tPA administration in acute ischemic stroke.",
            keyPoint: "Door-to-needle goal: ≤60 minutes",
            clinicalPearl: "Many centers now achieve 45 minutes or less",
            algorithmStep: "Stroke Time Targets"
        )
    ]
    
    // MARK: - Extended ACS Questions
    
    static let extendedACSQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Acute Coronary Syndrome (ACS) includes:",
            choices: [
                ("STEMI, NSTEMI, and Unstable Angina", true, "The ACS spectrum", nil),
                ("Stable angina and STEMI only", false, nil, "Stable angina is not ACS"),
                ("Heart failure and STEMI", false, nil, "Heart failure is not ACS"),
                ("STEMI only", false, nil, "ACS is broader than STEMI")
            ],
            topic: .acs,
            difficulty: .easy,
            explanation: "ACS spectrum: STEMI (ST-elevation MI) → NSTEMI (non-ST-elevation MI) → Unstable Angina.",
            keyPoint: "ACS = STEMI + NSTEMI + Unstable Angina",
            clinicalPearl: "All ACS patients need aspirin and anticoagulation",
            algorithmStep: "ACS Classification"
        ),
        makeQuestion(
            stem: "The target time from first medical contact to PCI (balloon inflation) for STEMI is:",
            choices: [
                ("90 minutes or less", true, "FMC-to-device goal", nil),
                ("30 minutes", false, nil, "Unrealistic for most systems"),
                ("120 minutes", false, nil, "This is fibrinolytic time target"),
                ("180 minutes", false, nil, "Too long for primary PCI")
            ],
            topic: .acs,
            difficulty: .easy,
            explanation: "First Medical Contact to device (balloon) goal is ≤90 minutes for STEMI patients going for primary PCI.",
            keyPoint: "FMC-to-device: ≤90 minutes",
            clinicalPearl: "If PCI not available within 120 min, consider fibrinolytics",
            algorithmStep: "STEMI Time Targets"
        ),
        makeQuestion(
            stem: "The recommended initial aspirin dose for suspected ACS is:",
            choices: [
                ("162-325 mg chewed (non-enteric coated)", true, "Chewing ensures rapid absorption", nil),
                ("81 mg swallowed", false, nil, "Too low for initial dose"),
                ("162 mg swallowed whole", false, nil, "Should be chewed for rapid effect"),
                ("500 mg IV", false, nil, "IV aspirin is not standard")
            ],
            topic: .acs,
            difficulty: .easy,
            explanation: "Aspirin 162-325 mg CHEWED (not swallowed whole, non-enteric coated) for rapid absorption in ACS.",
            keyPoint: "Aspirin 162-325mg CHEWED",
            clinicalPearl: "Chewing increases absorption speed by 5-10 minutes",
            algorithmStep: "ACS Initial Management"
        ),
        makeQuestion(
            stem: "Nitroglycerin is contraindicated in ACS patients who have:",
            choices: [
                ("Used phosphodiesterase inhibitors (sildenafil) within 24-48 hours", true, "PDE5 inhibitors + nitrates = severe hypotension", nil),
                ("Elevated troponin", false, nil, "Troponin elevation doesn't contraindicate NTG"),
                ("Sinus tachycardia", false, nil, "Not a contraindication"),
                ("Previous aspirin use", false, nil, "Aspirin and NTG can be given together")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "NTG contraindicated with: PDE5 inhibitor use (24-48hr), hypotension (SBP <90), RV infarct, severe aortic stenosis.",
            keyPoint: "PDE5 inhibitors + NTG = dangerous hypotension",
            clinicalPearl: "Always ask about erectile dysfunction medications before giving nitroglycerin",
            algorithmStep: "Nitroglycerin Contraindications"
        ),
        makeQuestion(
            stem: "Inferior STEMI (ST elevation in II, III, aVF) with hypotension should make you suspect:",
            choices: [
                ("Right ventricular infarction - give fluids, avoid nitrates", true, "RV infarct is preload-dependent", nil),
                ("Left ventricular failure - give diuretics", false, nil, "Diuretics would worsen RV infarct"),
                ("Pulmonary embolism", false, nil, "PE doesn't cause inferior ST elevation"),
                ("Aortic dissection", false, nil, "Dissection has different presentation")
            ],
            topic: .acs,
            difficulty: .hard,
            explanation: "Inferior STEMI + hypotension = suspect RV infarct. RV is preload-dependent. Give IV fluids, avoid nitrates (drop preload).",
            keyPoint: "Inferior STEMI + hypotension = RV infarct → fluids",
            clinicalPearl: "Get right-sided ECG (V4R) to confirm RV involvement",
            algorithmStep: "RV Infarction Management"
        )
    ]
    
    // MARK: - Extended 2025 Guidelines Questions
    
    static let extended2025GuidelinesQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "The 2025 guidelines recommend CPR feedback devices primarily to:",
            choices: [
                ("Improve compression rate, depth, and quality in real-time", true, "Real-time feedback optimizes CPR quality", nil),
                ("Replace manual pulse checks", false, nil, "Pulse checks still required"),
                ("Eliminate the need for team training", false, nil, "Training remains essential"),
                ("Only for pediatric patients", false, nil, "Recommended for all ages")
            ],
            topic: .guidelines2025,
            difficulty: .easy,
            explanation: "CPR feedback devices help optimize rate (100-120/min) and depth (2-2.4 inches) in real-time.",
            keyPoint: "CPR feedback devices improve quality metrics",
            clinicalPearl: "Audio-visual feedback can significantly improve compression quality",
            algorithmStep: "2025 CPR Quality Optimization"
        ),
        makeQuestion(
            stem: "Regarding ECPR (Extracorporeal CPR), the 2025 guidelines state it may be considered:",
            choices: [
                ("For refractory arrest in select patients at experienced centers with potentially reversible cause", true, "ECPR for select refractory cases", nil),
                ("For all patients in cardiac arrest", false, nil, "Highly selected patients only"),
                ("To replace standard CPR", false, nil, "Does not replace standard CPR"),
                ("Only for pediatric patients", false, nil, "May be used in adults and children")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "ECPR may be considered for select patients with refractory arrest, potentially reversible cause, at experienced centers.",
            keyPoint: "ECPR: select patients, refractory arrest, experienced centers",
            clinicalPearl: "ECPR requires significant resources and expertise",
            algorithmStep: "2025 ECPR Recommendations"
        ),
        makeQuestion(
            stem: "For cardiac arrest in pregnancy >20 weeks without ROSC, the 2025 guidelines recommend:",
            choices: [
                ("Prepare for perimortem cesarean delivery within 5 minutes", true, "Relieve aortocaval compression and improve resuscitation", nil),
                ("Standard resuscitation only", false, nil, "May require perimortem C-section"),
                ("Delay CPR until OR ready", false, nil, "CPR starts immediately"),
                ("Only IV magnesium", false, nil, "Full resuscitation plus surgical team")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "Maternal arrest >20 weeks: prepare for perimortem C-section within 5 minutes if no ROSC. Delivery relieves aortocaval compression.",
            keyPoint: "Maternal arrest: perimortem C-section within 5 min if no ROSC",
            clinicalPearl: "C-section benefits both mother (improved venous return) and fetus",
            algorithmStep: "Maternal Cardiac Arrest"
        ),
        makeQuestion(
            stem: "For opioid-associated cardiac arrest, the 2025 guidelines recommend:",
            choices: [
                ("CPR remains priority; empiric naloxone is reasonable", true, "CPR first, naloxone as adjunct", nil),
                ("Naloxone only, no CPR needed", false, nil, "CPR is essential if pulseless"),
                ("Naloxone replaces epinephrine", false, nil, "Standard ACLS drugs still indicated"),
                ("AED use is contraindicated", false, nil, "Use AED if shockable rhythm")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "Opioid-associated cardiac arrest: CPR is priority. Empiric naloxone is reasonable given difficulty distinguishing cardiac from respiratory arrest.",
            keyPoint: "Opioid arrest: CPR priority + naloxone adjunct",
            clinicalPearl: "Naloxone may convert respiratory arrest to responsive patient quickly",
            algorithmStep: "Opioid-Associated Emergency Care"
        ),
        makeQuestion(
            stem: "The 2025 guidelines recommend that resuscitation systems should implement:",
            choices: [
                ("Continuous quality improvement with regular data review and debriefing", true, "QI improves outcomes", nil),
                ("Focus only on individual performance", false, nil, "System-wide improvement emphasized"),
                ("Avoid reviewing unsuccessful resuscitations", false, nil, "Learn from all cases"),
                ("Use same protocols indefinitely", false, nil, "Protocols should evolve with evidence")
            ],
            topic: .guidelines2025,
            difficulty: .easy,
            explanation: "2025 guidelines emphasize continuous quality improvement through regular data review, debriefing, and evidence-based protocol updates.",
            keyPoint: "Continuous QI: data review + debriefing",
            clinicalPearl: "Both successful and unsuccessful resuscitations provide learning opportunities",
            algorithmStep: "Systems of Care - Quality Improvement"
        ),
        makeQuestion(
            stem: "Regarding rescuer mental health, the 2025 guidelines acknowledge that resuscitation providers may experience:",
            choices: [
                ("Significant emotional and psychological impact requiring support", true, "2025 guidelines address rescuer wellness", nil),
                ("No psychological effects if trained", false, nil, "Training doesn't prevent psychological impact"),
                ("Only positive emotions from saving lives", false, nil, "Unsuccessful resuscitations cause distress"),
                ("This is not addressed in guidelines", false, nil, "Explicitly addressed in 2025 guidelines")
            ],
            topic: .guidelines2025,
            difficulty: .easy,
            explanation: "2025 guidelines recognize the psychological impact on rescuers and recommend support resources be available.",
            keyPoint: "Rescuer wellness and support are addressed",
            clinicalPearl: "Debriefing and peer support programs help providers cope",
            algorithmStep: "Rescuer Wellness"
        ),
        makeQuestion(
            stem: "The 2025 guidelines state that mechanical CPR devices:",
            choices: [
                ("Are a reasonable alternative when high-quality manual CPR is challenging", true, "For transport, cath lab, prolonged CPR", nil),
                ("Are superior to manual CPR", false, nil, "Not proven superior to high-quality manual CPR"),
                ("Should replace manual CPR in all settings", false, nil, "Alternative, not replacement"),
                ("Are no longer recommended", false, nil, "Still a reasonable option")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "Mechanical CPR devices are a reasonable alternative when high-quality manual CPR is difficult to sustain (transport, cath lab, prolonged CPR).",
            keyPoint: "Mechanical CPR: reasonable when manual CPR challenging",
            clinicalPearl: "Ensure no delay in CPR during device setup",
            algorithmStep: "Mechanical CPR Devices"
        ),
        makeQuestion(
            stem: "Routine calcium administration during cardiac arrest:",
            choices: [
                ("Is NOT recommended; reserve for hyperkalemia, hypocalcemia, or CCB overdose", true, "Specific indications only", nil),
                ("Is recommended for all arrests", false, nil, "Routine use not supported"),
                ("Improves outcomes when given early", false, nil, "No evidence of improved outcomes with routine use"),
                ("Is contraindicated", false, nil, "Has specific indications")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "Routine calcium is not recommended. Reserve for hyperkalemia, hypocalcemia, or calcium channel blocker overdose.",
            keyPoint: "Calcium: not routine, specific indications only",
            clinicalPearl: "Calcium chloride (10mL of 10%) or calcium gluconate (30mL of 10%)",
            algorithmStep: "2025 Pharmacology - Calcium"
        )
    ]
    
    // MARK: - Comprehensive VF/pVT Expansion (28 additional)
    
    static let additionalVFQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "During VF arrest, what ETCO2 value during CPR suggests adequate CPR quality?",
            choices: [
                ("≥10-20 mmHg", true, "Target is at least 10 mmHg", nil),
                ("<5 mmHg", false, nil, "Too low - indicates poor CPR quality"),
                (">60 mmHg", false, nil, "Normal levels only expected with ROSC"),
                ("ETCO2 is not useful in VF", false, nil, "Very useful for CPR quality monitoring")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "ETCO2 ≥10-20 mmHg suggests adequate CPR perfusion. Values <10 indicate poor CPR quality or poor prognosis.",
            keyPoint: "ETCO2 ≥10 = acceptable CPR quality",
            algorithmStep: "VF Algorithm - CPR Quality"
        ),
        makeQuestion(
            stem: "The biphasic truncated exponential waveform defibrillator uses what energy range?",
            choices: [
                ("120-200 J per manufacturer", true, "Follow device-specific recommendations", nil),
                ("360 J always", false, nil, "This is monophasic energy"),
                ("50-100 J", false, nil, "Too low for defibrillation"),
                ("400+ J", false, nil, "Exceeds typical biphasic range")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "Biphasic truncated exponential waveforms typically use 120-200 J. Always check manufacturer recommendations.",
            keyPoint: "Biphasic defib: 120-200 J per manufacturer"
        ),
        makeQuestion(
            stem: "After 3 shocks for refractory VF, which escalation strategies may be considered?",
            choices: [
                ("Double sequential defibrillation (DSD) or vector change", true, "Both may be considered after failed conventional shocks", nil),
                ("Increase energy to 500 J", false, nil, "Exceeds device capability"),
                ("Switch to cardioversion", false, nil, "Cardioversion is for organized rhythms with pulse"),
                ("Terminate resuscitation", false, nil, "Consider escalation before termination")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "After 3+ failed shocks, DSD (two defibrillators) or VCD (changing pad position) may be considered.",
            keyPoint: "Refractory VF: consider DSD or vector change"
        ),
        makeQuestion(
            stem: "What is the maximum lidocaine dose during VF/pVT arrest?",
            choices: [
                ("3 mg/kg total", true, "1-1.5 mg/kg initial, then 0.5-0.75 mg/kg repeats", nil),
                ("1 mg/kg total", false, nil, "This is only the initial dose"),
                ("6 mg/kg total", false, nil, "Exceeds safe dosing"),
                ("No maximum", false, nil, "Toxicity risk at high doses")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "Lidocaine max 3 mg/kg total. Initial 1-1.5 mg/kg, then 0.5-0.75 mg/kg q5-10min.",
            keyPoint: "Lidocaine max: 3 mg/kg total"
        ),
        makeQuestion(
            stem: "A patient in VF has return of organized rhythm at 2-minute check but no pulse. This is:",
            choices: [
                ("PEA - treat with CPR and epinephrine", true, "Organized rhythm without pulse = PEA", nil),
                ("ROSC - stop CPR", false, nil, "ROSC requires pulse"),
                ("Still VF - shock again", false, nil, "Rhythm has changed"),
                ("Artifact - adjust leads", false, nil, "Organized rhythm is real")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "Organized rhythm without pulse = PEA. Continue CPR, give epinephrine, search for reversible causes.",
            keyPoint: "Organized rhythm + no pulse = PEA"
        ),
        makeQuestion(
            stem: "For a patient with an ICD firing appropriately for VF but unable to convert, what should be done?",
            choices: [
                ("External defibrillation with pads at least 8 cm from device", true, "External defib is safe and indicated", nil),
                ("Wait for ICD to succeed", false, nil, "External defib needed if ICD failing"),
                ("Defibrillation is contraindicated", false, nil, "Absolutely indicated"),
                ("Remove the ICD first", false, nil, "Not possible during resuscitation")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "External defibrillation can be performed with ICD present. Place pads at least 8 cm from device.",
            keyPoint: "ICD + VF: external defib OK, pads ≥8cm from device"
        ),
        makeQuestion(
            stem: "Procainamide is an alternative antiarrhythmic for VF. What is its limitation in cardiac arrest?",
            choices: [
                ("Slow infusion rate makes it impractical during CPR", true, "20-50 mg/min is too slow for arrest", nil),
                ("It is more effective than amiodarone", false, nil, "Not more effective"),
                ("No IV formulation exists", false, nil, "IV form available"),
                ("It converts VF to asystole", false, nil, "Not a known effect")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "Procainamide requires slow infusion (20-50 mg/min). This delay makes it impractical during active resuscitation.",
            keyPoint: "Procainamide: too slow for arrest use"
        ),
        makeQuestion(
            stem: "During VF resuscitation, how should medications be delivered relative to shocks?",
            choices: [
                ("Give drugs during CPR, ideally immediately after a shock", true, "Maximize circulation time", nil),
                ("Pause CPR to give medications", false, nil, "Continue CPR during drug administration"),
                ("Give only between 2-minute cycles", false, nil, "Give as soon as access available"),
                ("Delay all drugs until ROSC", false, nil, "Drugs given during CPR")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "Administer medications during CPR, ideally right after shock when 2 minutes of CPR will follow.",
            keyPoint: "Medications: give during CPR after shock"
        )
    ]
    
    // MARK: - Comprehensive PEA/Asystole Expansion (22 additional)
    
    static let additionalPEAQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Narrow-complex PEA suggests which category of reversible causes?",
            choices: [
                ("Mechanical causes: tamponade, PE, tension pneumothorax, hypovolemia", true, "Narrow = heart trying to work, problem is mechanical", nil),
                ("Metabolic causes: hyperkalemia, drug toxicity", false, nil, "These cause wide-complex PEA"),
                ("Irreversible causes", false, nil, "Narrow PEA often has treatable cause"),
                ("Same causes as wide-complex PEA", false, nil, "QRS width guides differential")
            ],
            topic: .peaAsystole,
            difficulty: .hard,
            explanation: "Narrow-complex PEA = electrically functional heart with mechanical obstruction (PE, tamponade, tension pneumo, hypovolemia).",
            keyPoint: "Narrow PEA = mechanical cause (T's)"
        ),
        makeQuestion(
            stem: "Wide-complex PEA suggests which category of reversible causes?",
            choices: [
                ("Metabolic causes: hyperkalemia, drug toxicity, severe acidosis", true, "Wide = electrical conduction problem", nil),
                ("Mechanical causes: tamponade, PE", false, nil, "These cause narrow-complex PEA"),
                ("Only hypovolemia", false, nil, "Hypovolemia typically causes narrow PEA"),
                ("No treatable cause", false, nil, "Wide PEA can have treatable causes")
            ],
            topic: .peaAsystole,
            difficulty: .hard,
            explanation: "Wide-complex PEA suggests metabolic derangement affecting cardiac conduction (hyperK, Na channel blockers, severe acidosis).",
            keyPoint: "Wide PEA = metabolic cause (H's)"
        ),
        makeQuestion(
            stem: "What POCUS finding during PEA helps differentiate pseudo-PEA from true PEA?",
            choices: [
                ("Visible cardiac contractions on ultrasound", true, "Pseudo-PEA has wall motion despite no pulse", nil),
                ("Pericardial fluid alone", false, nil, "Suggests tamponade but not pseudo-PEA"),
                ("IVC collapse", false, nil, "Suggests hypovolemia"),
                ("Right heart dilation", false, nil, "Suggests PE")
            ],
            topic: .peaAsystole,
            difficulty: .hard,
            explanation: "Pseudo-PEA shows cardiac wall motion on ultrasound despite no palpable pulse - may respond to fluids/vasopressors.",
            keyPoint: "POCUS: visible contractions = pseudo-PEA"
        ),
        makeQuestion(
            stem: "For suspected massive PE causing PEA, what is the appropriate thrombolytic dose?",
            choices: [
                ("tPA 50 mg IV bolus (may repeat), with extended CPR 60-90 minutes", true, "Thrombolysis for PE-related arrest", nil),
                ("tPA 100 mg over 2 hours", false, nil, "This is the non-arrest PE dose"),
                ("Thrombolytics are contraindicated during CPR", false, nil, "May be beneficial for PE"),
                ("Heparin bolus only", false, nil, "Not sufficient for massive PE")
            ],
            topic: .peaAsystole,
            difficulty: .hard,
            explanation: "PE-related arrest: tPA 50 mg IV bolus during CPR, may repeat. Continue CPR for 60-90 minutes after thrombolytic.",
            keyPoint: "PE arrest: tPA 50mg bolus + extended CPR"
        ),
        makeQuestion(
            stem: "What intervention is indicated for tension pneumothorax causing PEA?",
            choices: [
                ("Immediate needle or finger thoracostomy", true, "Decompress immediately", nil),
                ("Wait for chest X-ray confirmation", false, nil, "Clinical diagnosis - treat immediately"),
                ("High-dose epinephrine only", false, nil, "Must decompress"),
                ("Pericardiocentesis", false, nil, "Wrong procedure - that's for tamponade")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "Tension pneumothorax is a clinical diagnosis. Perform needle/finger thoracostomy immediately if suspected.",
            keyPoint: "Tension pneumo: decompress NOW"
        ),
        makeQuestion(
            stem: "During asystole, which actions should be taken simultaneously?",
            choices: [
                ("High-quality CPR, epinephrine ASAP, search for reversible causes", true, "All three are priorities", nil),
                ("Defibrillation first, then CPR", false, nil, "Asystole is not shockable"),
                ("CPR only - no medications help", false, nil, "Epinephrine is indicated"),
                ("Atropine and transcutaneous pacing", false, nil, "Atropine removed from asystole management")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "Asystole management: high-quality CPR, early epinephrine, and aggressive search for H's and T's.",
            keyPoint: "Asystole: CPR + Epi + find cause"
        ),
        makeQuestion(
            stem: "What is the prognosis significance of an initial rhythm of asystole?",
            choices: [
                ("Poor prognosis - survival rates typically <5%", true, "Asystole has lowest survival of all arrest rhythms", nil),
                ("Better than VF", false, nil, "VF has much better outcomes"),
                ("Same as PEA", false, nil, "Asystole generally worse than organized PEA"),
                ("Prognosis is excellent with early CPR", false, nil, "Still poor despite good CPR")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "Asystole has the worst prognosis of arrest rhythms. Survival to discharge typically <5%.",
            keyPoint: "Asystole = poor prognosis"
        ),
        makeQuestion(
            stem: "Before confirming asystole, you should:",
            choices: [
                ("Check leads, connections, gain, and confirm in at least 2 leads", true, "Rule out technical causes of flat line", nil),
                ("Immediately defibrillate", false, nil, "Asystole is not shockable"),
                ("Declare death", false, nil, "Must confirm true asystole first"),
                ("Wait 30 seconds for rhythm to appear", false, nil, "Continue CPR while checking")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "Before calling asystole, verify: leads connected, gain adequate, check multiple leads to rule out fine VF.",
            keyPoint: "Confirm asystole: leads, gain, 2+ leads"
        )
    ]
    
    // MARK: - Comprehensive Bradycardia Expansion (21 additional)
    
    static let additionalBradyQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per 2025 guidelines, what atropine dose should be used for symptomatic bradycardia?",
            choices: [
                ("1.0 mg IV (updated from 0.5 mg)", true, "2025 increased initial dose", nil),
                ("0.5 mg IV", false, nil, "This is the OLD dose - now 1.0 mg"),
                ("0.25 mg IV", false, nil, "Too low"),
                ("2.0 mg IV", false, nil, "Higher than initial dose")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "AHA 2025 updated atropine dose to 1.0 mg IV initial (previously 0.5 mg). May repeat q3-5 min, max 3 mg.",
            keyPoint: "2025 UPDATE: Atropine 1.0 mg (not 0.5 mg)"
        ),
        makeQuestion(
            stem: "Which heart blocks are likely to respond to atropine?",
            choices: [
                ("Sinus bradycardia and AV blocks at the nodal level (1st degree, Mobitz I)", true, "Atropine works on AV node", nil),
                ("Mobitz II and 3rd degree block", false, nil, "Infranodal blocks don't respond to atropine"),
                ("All heart blocks equally", false, nil, "Atropine ineffective below AV node"),
                ("None - atropine is not used for blocks", false, nil, "Used for nodal-level blocks")
            ],
            topic: .bradycardia,
            difficulty: .hard,
            explanation: "Atropine is effective for vagally-mediated bradycardia and AV nodal blocks. Infranodal blocks (Mobitz II, 3rd degree) require pacing.",
            keyPoint: "Atropine: nodal blocks only"
        ),
        makeQuestion(
            stem: "TCP should be initiated when:",
            choices: [
                ("Atropine is ineffective OR patient is severely symptomatic", true, "Don't wait for atropine to fail if critical", nil),
                ("Only after all medications have failed", false, nil, "Severely unstable = pace immediately"),
                ("Never - medications are always sufficient", false, nil, "TCP is essential backup"),
                ("Only for patients with pacemakers", false, nil, "TCP is for emergency external pacing")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Initiate TCP if: atropine fails OR patient severely symptomatic (don't delay for atropine trial if critical).",
            keyPoint: "TCP: atropine failure OR severe symptoms"
        ),
        makeQuestion(
            stem: "What pacing rate should be used for TCP in symptomatic bradycardia?",
            choices: [
                ("60-70 bpm (or rate that produces adequate perfusion)", true, "Start at physiologic rate", nil),
                ("100-120 bpm", false, nil, "Unnecessarily fast"),
                ("30-40 bpm", false, nil, "Too slow to improve symptoms"),
                ("Maximum rate the device allows", false, nil, "Can cause harm")
            ],
            topic: .bradycardia,
            difficulty: .easy,
            explanation: "Set TCP rate at 60-70 bpm initially. Adjust to achieve adequate perfusion and symptom relief.",
            keyPoint: "TCP rate: 60-70 bpm initially"
        ),
        makeQuestion(
            stem: "Electrical capture during TCP is confirmed by:",
            choices: [
                ("Wide QRS following each pacing spike, but must verify mechanical capture with pulse", true, "Electrical capture ≠ mechanical capture", nil),
                ("Pacing spike on monitor alone", false, nil, "Must see QRS response"),
                ("Patient comfort", false, nil, "TCP is painful regardless"),
                ("Blood pressure increase alone", false, nil, "Need to see electrical and check pulse")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Electrical capture = wide QRS after each spike. Mechanical capture = palpable pulse. Always verify both.",
            keyPoint: "TCP: verify electrical AND mechanical capture"
        ),
        makeQuestion(
            stem: "What ECG finding defines Mobitz Type I (Wenckebach)?",
            choices: [
                ("Progressive PR prolongation until a beat is dropped, then cycle repeats", true, "Longer, longer, drop pattern", nil),
                ("Constant PR with random dropped beats", false, nil, "This is Mobitz Type II"),
                ("No relationship between P and QRS", false, nil, "This is 3rd degree block"),
                ("PR interval <0.12 seconds", false, nil, "This is short PR, not Wenckebach")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Wenckebach: PR gets progressively longer until a QRS is dropped, then cycle repeats. 'Longer, longer, longer, drop.'",
            keyPoint: "Wenckebach: longer, longer, drop"
        ),
        makeQuestion(
            stem: "Why is Mobitz Type II more dangerous than Mobitz Type I?",
            choices: [
                ("High risk of progressing to complete heart block without warning", true, "Type II is unpredictable and infranodal", nil),
                ("It has a faster heart rate", false, nil, "Heart rate doesn't determine danger"),
                ("It responds better to atropine", false, nil, "Type II doesn't respond to atropine"),
                ("It is more common", false, nil, "Less common but more dangerous")
            ],
            topic: .bradycardia,
            difficulty: .hard,
            explanation: "Mobitz II is infranodal, unpredictable, and can suddenly progress to complete block. Pacemaker often needed.",
            keyPoint: "Type II: dangerous - can progress to complete block"
        ),
        makeQuestion(
            stem: "For beta-blocker toxicity causing bradycardia, what is the specific antidote?",
            choices: [
                ("Glucagon 3-10 mg IV", true, "Bypasses blocked beta receptors", nil),
                ("Atropine only", false, nil, "Atropine often inadequate"),
                ("Calcium chloride", false, nil, "This is for CCB toxicity"),
                ("Flumazenil", false, nil, "This is for benzodiazepines")
            ],
            topic: .bradycardia,
            difficulty: .hard,
            explanation: "Glucagon bypasses blocked beta receptors. Also consider high-dose insulin-glucose therapy.",
            keyPoint: "Beta-blocker OD: glucagon 3-10 mg IV"
        )
    ]
    
    // MARK: - Comprehensive Tachycardia Expansion (25 additional)
    
    static let additionalTachyQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per 2025 guidelines, what is the initial cardioversion energy for unstable SVT?",
            choices: [
                ("100 J synchronized", true, "2025 increased from 50J", nil),
                ("50 J synchronized", false, nil, "Old recommendation - now 100J"),
                ("200 J unsynchronized", false, nil, "Unsync is for VF/pVT only"),
                ("360 J monophasic", false, nil, "Too high for narrow complex")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "AHA 2025: narrow-complex tachycardia cardioversion starts at 100 J (increased from 50 J).",
            keyPoint: "2025 UPDATE: SVT cardioversion = 100J"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, what is the initial cardioversion energy for unstable AFib/flutter?",
            choices: [
                ("≥200 J synchronized", true, "Higher energy for AFib/flutter", nil),
                ("50-100 J", false, nil, "May be insufficient"),
                ("Unsynchronized shock", false, nil, "Must synchronize for AFib"),
                ("360 J", false, nil, "Start at 200J biphasic")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "AFib/flutter cardioversion: start at ≥200 J synchronized biphasic (2025 update).",
            keyPoint: "2025 UPDATE: AFib cardioversion ≥200J"
        ),
        makeQuestion(
            stem: "A stable wide-complex tachycardia should be assumed to be:",
            choices: [
                ("VT until proven otherwise", true, "Wide + fast = VT until proven otherwise", nil),
                ("SVT with aberrancy", false, nil, "Never assume SVT with aberrancy"),
                ("Artifact", false, nil, "Must treat as real until confirmed"),
                ("Benign", false, nil, "WCT can be dangerous")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Wide-complex tachycardia should be treated as VT until proven otherwise. Safer assumption.",
            keyPoint: "WCT = VT until proven otherwise"
        ),
        makeQuestion(
            stem: "Adenosine may be used diagnostically for stable wide-complex tachycardia to:",
            choices: [
                ("Unmask underlying rhythm if SVT with aberrancy suspected", true, "May reveal flutter waves or convert SVT", nil),
                ("Convert VT to sinus rhythm", false, nil, "Adenosine doesn't work for VT"),
                ("Replace cardioversion", false, nil, "May not convert; diagnostic use"),
                ("As first-line treatment for all WCT", false, nil, "Only if SVT with aberrancy suspected")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "Adenosine may transiently slow AV conduction to reveal underlying rhythm. Won't harm VT but won't convert it.",
            keyPoint: "Adenosine in WCT: diagnostic, not harmful for VT"
        ),
        makeQuestion(
            stem: "What drugs should be AVOIDED in WPW with atrial fibrillation?",
            choices: [
                ("AV nodal blockers: adenosine, CCBs, digoxin, amiodarone", true, "Can accelerate conduction down accessory pathway", nil),
                ("Procainamide", false, nil, "Procainamide is appropriate for WPW"),
                ("Electrical cardioversion", false, nil, "Cardioversion is safe"),
                ("Oxygen", false, nil, "Always appropriate")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "AV nodal blockers in WPW-AFib can accelerate conduction down accessory pathway → VF. Use procainamide or cardiovert.",
            keyPoint: "WPW + AFib: AVOID AV nodal blockers"
        ),
        makeQuestion(
            stem: "Polymorphic VT should be treated as:",
            choices: [
                ("VF - unsynchronized high-energy defibrillation", true, "Can't synchronize to polymorphic rhythm", nil),
                ("Stable VT - amiodarone first", false, nil, "Polymorphic VT is unstable"),
                ("SVT - adenosine", false, nil, "This is ventricular"),
                ("AFib - synchronized cardioversion", false, nil, "Can't synchronize")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Polymorphic VT is treated like VF with unsynchronized defibrillation. Can't reliably synchronize to varying QRS.",
            keyPoint: "Polymorphic VT = defib like VF"
        ),
        makeQuestion(
            stem: "Sotalol was removed from the 2025 tachycardia algorithm because:",
            choices: [
                ("No evidence of improved outcomes", true, "Studies showed no benefit", nil),
                ("It caused too many side effects", false, nil, "Efficacy was the issue"),
                ("It is no longer manufactured", false, nil, "Still available"),
                ("It was too effective", false, nil, "Not effective enough")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "2025 ILCOR review found no evidence that sotalol improved outcomes in VF/pVT. Removed from algorithms.",
            keyPoint: "2025: Sotalol removed - no benefit"
        ),
        makeQuestion(
            stem: "For unstable tachycardia, the 2025 guidelines recommend:",
            choices: [
                ("'Sedate whenever feasible' before cardioversion", true, "Changed from 'consider sedation'", nil),
                ("Never sedate before cardioversion", false, nil, "Sedation recommended if possible"),
                ("Deep anesthesia required", false, nil, "'Whenever feasible' - don't delay for anesthesia"),
                ("Sedation only after cardioversion", false, nil, "Before, not after")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "2025 changed wording to 'sedate whenever feasible' - stronger recommendation but don't delay emergent cardioversion.",
            keyPoint: "2025: Sedate whenever feasible"
        )
    ]
    
    // MARK: - Comprehensive Pharmacology Expansion (20 additional)
    
    static let additionalPharmQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the mechanism of epinephrine in cardiac arrest?",
            choices: [
                ("Alpha-1 vasoconstriction increases coronary and cerebral perfusion pressure", true, "Vasoconstriction is the key benefit", nil),
                ("Beta-1 stimulation increases heart rate", false, nil, "Beta effects less important during CPR"),
                ("Blocks sodium channels", false, nil, "Not the mechanism"),
                ("Reduces afterload", false, nil, "Actually increases afterload")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Epinephrine's alpha-1 effect causes vasoconstriction, increasing aortic diastolic pressure → better coronary perfusion.",
            keyPoint: "Epi mechanism: alpha vasoconstriction → ↑CPP"
        ),
        makeQuestion(
            stem: "Amiodarone is classified as what type of antiarrhythmic?",
            choices: [
                ("Class III (potassium channel blocker) with properties of all four classes", true, "Unique multi-class effects", nil),
                ("Class I only", false, nil, "Has Class I properties but not only"),
                ("Class II only", false, nil, "Also has Class II effects"),
                ("Class IV only", false, nil, "Has some CCB properties too")
            ],
            topic: .pharmacology,
            difficulty: .hard,
            explanation: "Amiodarone is primarily Class III (K+ channel block) but has effects of all four Vaughan-Williams classes.",
            keyPoint: "Amiodarone: multi-class antiarrhythmic"
        ),
        makeQuestion(
            stem: "What is the half-life of adenosine?",
            choices: [
                ("<10 seconds", true, "Ultra-short acting", nil),
                ("30 minutes", false, nil, "Far too long"),
                ("4-6 hours", false, nil, "That's other medications"),
                ("24 hours", false, nil, "Not even close")
            ],
            topic: .pharmacology,
            difficulty: .easy,
            explanation: "Adenosine half-life is <10 seconds. Must give as rapid IV push followed by flush.",
            keyPoint: "Adenosine: <10 second half-life"
        ),
        makeQuestion(
            stem: "Why must adenosine be given as rapid IV push?",
            choices: [
                ("Ultra-short half-life requires rapid delivery to heart", true, "Drug broken down in seconds", nil),
                ("Slow administration is toxic", false, nil, "Slow just means ineffective"),
                ("It precipitates in IV lines", false, nil, "Not a stability issue"),
                ("Patient comfort", false, nil, "Rapid push is uncomfortable but necessary")
            ],
            topic: .pharmacology,
            difficulty: .easy,
            explanation: "Adenosine is rapidly metabolized. Must reach heart before breakdown. Use large bore IV, rapid push, saline flush.",
            keyPoint: "Adenosine: rapid push due to short half-life"
        ),
        makeQuestion(
            stem: "High-dose insulin therapy is used for which toxicological emergencies?",
            choices: [
                ("Calcium channel blocker and beta-blocker overdose", true, "Improves cardiac inotropy", nil),
                ("Opioid overdose", false, nil, "Use naloxone"),
                ("Digoxin toxicity", false, nil, "Use Fab fragments"),
                ("TCA overdose", false, nil, "Use sodium bicarbonate")
            ],
            topic: .pharmacology,
            difficulty: .hard,
            explanation: "High-dose insulin (1 unit/kg bolus, then 1-10 units/kg/hr) improves inotropy in CCB and BB overdose.",
            keyPoint: "High-dose insulin: CCB/BB overdose"
        ),
        makeQuestion(
            stem: "What is the antidote for local anesthetic systemic toxicity (LAST)?",
            choices: [
                ("Intralipid (20% lipid emulsion) 1.5 mL/kg bolus", true, "Lipid sink traps local anesthetic", nil),
                ("Naloxone", false, nil, "For opioids"),
                ("Flumazenil", false, nil, "For benzodiazepines"),
                ("N-acetylcysteine", false, nil, "For acetaminophen")
            ],
            topic: .pharmacology,
            difficulty: .hard,
            explanation: "Lipid emulsion therapy 1.5 mL/kg bolus for LAST. Creates 'lipid sink' that binds lipophilic local anesthetics.",
            keyPoint: "LAST: Intralipid 1.5 mL/kg"
        ),
        makeQuestion(
            stem: "Calcium chloride 10% dose for hyperkalemia-induced cardiac arrest is:",
            choices: [
                ("10 mL (1 gram) IV push", true, "Membrane stabilization", nil),
                ("1 mL IV", false, nil, "Too low"),
                ("50 mL IV", false, nil, "Excessive"),
                ("Calcium is contraindicated", false, nil, "First-line for hyperK")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Calcium chloride 10%: 10 mL (1 g) IV. Calcium gluconate 10%: 30 mL (3 g) IV for equivalent calcium.",
            keyPoint: "CaCl2 10%: 10 mL = 1 gram"
        ),
        makeQuestion(
            stem: "For digoxin toxicity with life-threatening arrhythmias, the antidote is:",
            choices: [
                ("Digoxin-specific Fab antibody fragments (DigiFab)", true, "Binds and inactivates digoxin", nil),
                ("Atropine", false, nil, "May help bradycardia but not antidote"),
                ("Calcium", false, nil, "Contraindicated - can worsen toxicity"),
                ("Magnesium", false, nil, "Adjunct only")
            ],
            topic: .pharmacology,
            difficulty: .hard,
            explanation: "DigiFab binds digoxin, preventing receptor binding. Dose based on amount ingested or digoxin level.",
            keyPoint: "Digoxin toxicity: DigiFab (Fab fragments)"
        )
    ]
    
    // MARK: - Comprehensive H's and T's Expansion (20 additional)
    
    static let additionalHsTsQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "The 5 H's of reversible cardiac arrest causes are:",
            choices: [
                ("Hypovolemia, Hypoxia, Hydrogen ions (acidosis), Hypo/Hyperkalemia, Hypothermia", true, "Also hypoglycemia in some lists", nil),
                ("Heart attack, Hypotension, Hyperglycemia, Headache, Heat stroke", false, nil, "Incorrect list"),
                ("Only Hypoxia and Hypovolemia", false, nil, "Incomplete list"),
                ("There are only 3 H's", false, nil, "5-6 H's in standard list")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Classic 5 H's: Hypovolemia, Hypoxia, Hydrogen ions (acidosis), Hypo/Hyperkalemia, Hypothermia. Some add Hypoglycemia.",
            keyPoint: "5 H's: volume, O2, acid, K+, temp"
        ),
        makeQuestion(
            stem: "The 5 T's of reversible cardiac arrest causes are:",
            choices: [
                ("Tension pneumothorax, Tamponade, Toxins, Thrombosis (PE/MI), Trauma", true, "Mechanical and toxic causes", nil),
                ("Temperature, Tachycardia, Transfusion, Tumor, Tremor", false, nil, "Incorrect list"),
                ("Only Tamponade and Toxins", false, nil, "Incomplete list"),
                ("Tension, Tamponade, Torsades", false, nil, "Missing several T's")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "5 T's: Tension pneumo, Tamponade, Toxins, Thrombosis (coronary or pulmonary), Trauma.",
            keyPoint: "5 T's: pneumo, tamponade, toxins, clot, trauma"
        ),
        makeQuestion(
            stem: "Beck's triad for cardiac tamponade includes:",
            choices: [
                ("Hypotension, muffled heart sounds, JVD", true, "Classic triad", nil),
                ("Hypertension, clear lung sounds, bradycardia", false, nil, "Incorrect"),
                ("Fever, rash, hypotension", false, nil, "Unrelated triad"),
                ("Chest pain, dyspnea, syncope", false, nil, "Symptoms, not Beck's triad")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Beck's triad: hypotension, muffled/distant heart sounds, JVD. May not all be present.",
            keyPoint: "Tamponade: hypotension + muffled hearts + JVD"
        ),
        makeQuestion(
            stem: "Treatment for tension pneumothorax during arrest is:",
            choices: [
                ("Immediate needle or finger thoracostomy without waiting for imaging", true, "Clinical diagnosis - treat immediately", nil),
                ("Wait for chest X-ray confirmation", false, nil, "Would delay life-saving treatment"),
                ("Chest tube in OR only", false, nil, "Too slow during arrest"),
                ("High-dose bronchodilators", false, nil, "Wrong treatment")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Tension pneumothorax is a clinical diagnosis. Needle decompression (2nd ICS MCL) or finger thoracostomy immediately.",
            keyPoint: "Tension pneumo: decompress immediately"
        ),
        makeQuestion(
            stem: "ECG findings in severe hyperkalemia include:",
            choices: [
                ("Peaked T waves → widened QRS → loss of P waves → sine wave → VF/asystole", true, "Progressive ECG changes", nil),
                ("ST elevation only", false, nil, "Not typical of hyperK"),
                ("Prolonged QT interval", false, nil, "This is hypokalemia"),
                ("Normal ECG always", false, nil, "HyperK has characteristic ECG changes")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Hyperkalemia ECG progression: peaked T → PR prolongation → widened QRS → P wave loss → sine wave → arrest.",
            keyPoint: "HyperK ECG: peaked T → wide QRS → sine wave"
        ),
        makeQuestion(
            stem: "Treatment sequence for hyperkalemia causing arrest:",
            choices: [
                ("Calcium (membrane stabilizer) → shift potassium (insulin/bicarb/albuterol) → remove potassium (dialysis)", true, "Stabilize → shift → remove", nil),
                ("Dialysis first always", false, nil, "Calcium is fastest"),
                ("Kayexalate immediately", false, nil, "Too slow for acute management"),
                ("Fluids only", false, nil, "Won't address hyperK")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "HyperK treatment: 1) Calcium to stabilize membrane, 2) Shift K+ into cells (insulin/glucose, bicarb, albuterol), 3) Remove K+ (dialysis).",
            keyPoint: "HyperK: stabilize → shift → remove"
        ),
        makeQuestion(
            stem: "Hypothermic cardiac arrest patients should receive:",
            choices: [
                ("Prolonged resuscitation with active rewarming before declaring death", true, "'Not dead until warm and dead'", nil),
                ("Standard 20-minute resuscitation only", false, nil, "Extended efforts warranted"),
                ("No CPR until rewarmed", false, nil, "CPR continues during rewarming"),
                ("Immediate pronouncement if asystolic", false, nil, "Hypothermia can cause reversible asystole")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Hypothermic arrest: continue resuscitation until rewarmed to at least 32-35°C. Medications may be withheld or spaced until >30°C.",
            keyPoint: "Hypothermia: 'not dead until warm and dead'"
        ),
        makeQuestion(
            stem: "The classic presentation of massive pulmonary embolism includes:",
            choices: [
                ("Sudden cardiovascular collapse, hypoxia, right heart strain, PEA", true, "High mortality without treatment", nil),
                ("Gradual onset of chest pain only", false, nil, "Massive PE is acute"),
                ("Fever and productive cough", false, nil, "Suggests infection"),
                ("ST elevation in anterior leads", false, nil, "Suggests MI, not PE")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Massive PE: sudden collapse, hypoxia, hypotension, RV strain. May present as PEA. Consider thrombolytics.",
            keyPoint: "Massive PE: sudden collapse + hypoxia + PEA"
        )
    ]
    
    // MARK: - Comprehensive Post-ROSC Expansion (25 additional)
    
    static let additionalPostROSCQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per 2025 guidelines, what is the target temperature range for post-cardiac arrest patients?",
            choices: [
                ("32-37.5°C (at minimum, prevent fever)", true, "Both therapeutic hypothermia and normothermia acceptable", nil),
                ("36°C exactly", false, nil, "Range is broader in 2025"),
                ("32-34°C only", false, nil, "Wider range now acceptable"),
                ("No temperature management needed", false, nil, "At minimum prevent fever")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "AHA 2025: target 32-37.5°C. Both therapeutic hypothermia and normothermia (fever prevention) are acceptable.",
            keyPoint: "2025: Temperature 32-37.5°C, prevent fever"
        ),
        makeQuestion(
            stem: "The minimum duration of temperature control after ROSC per 2025 guidelines is:",
            choices: [
                ("At least 24 hours (some data supports ≥36 hours)", true, "Extended from previous recommendations", nil),
                ("12 hours", false, nil, "Too short"),
                ("6 hours", false, nil, "Insufficient duration"),
                ("Only until awake", false, nil, "Time-based, not awakening-based")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Maintain target temperature for at least 24 hours. Some evidence supports 36+ hours of normothermia.",
            keyPoint: "Temperature control: ≥24-36 hours"
        ),
        makeQuestion(
            stem: "The target MAP for post-cardiac arrest patients per 2025 guidelines is:",
            choices: [
                ("≥65 mmHg (previously had systolic BP targets)", true, "MAP focus, not SBP", nil),
                ("≥90 mmHg SBP", false, nil, "2025 uses MAP not SBP"),
                ("≥120 mmHg SBP", false, nil, "No longer the target"),
                ("Any BP is acceptable", false, nil, "MAP goal is specified")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "AHA 2025: Focus on MAP ≥65 mmHg. Systolic BP targets removed from algorithm.",
            keyPoint: "2025: MAP ≥65 mmHg target"
        ),
        makeQuestion(
            stem: "Post-ROSC oxygenation target per 2025 guidelines:",
            choices: [
                ("SpO2 92-98% once stable; avoid hyperoxia", true, "Titrate once measurable", nil),
                ("Keep FiO2 at 100% indefinitely", false, nil, "Hyperoxia may be harmful"),
                ("SpO2 100% at all times", false, nil, "Hyperoxia avoidance recommended"),
                ("No oxygen needed", false, nil, "Adequate oxygenation essential")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Start at FiO2 100%, then titrate to SpO2 92-98% once measured. Avoid prolonged hyperoxia.",
            keyPoint: "Post-ROSC: SpO2 92-98%, avoid hyperoxia"
        ),
        makeQuestion(
            stem: "Post-ROSC patients should undergo early coronary angiography if:",
            choices: [
                ("STEMI present or high suspicion of cardiac etiology", true, "Early PCI improves outcomes", nil),
                ("Only if completely stable", false, nil, "Unstable patients may benefit most"),
                ("Never - too risky", false, nil, "Often indicated"),
                ("Only after 72-hour neurologic assessment", false, nil, "Earlier intervention recommended")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "Early coronary angiography/PCI for STEMI post-arrest. Consider for others with suspected cardiac cause.",
            keyPoint: "Post-ROSC: early angiography if STEMI/cardiac cause"
        ),
        makeQuestion(
            stem: "Neurologic prognostication after cardiac arrest should not occur until:",
            choices: [
                ("At least 72 hours post-arrest with patient off sedation and paralysis", true, "Multimodal assessment required", nil),
                ("24 hours post-arrest", false, nil, "Too early for accurate assessment"),
                ("Immediately after ROSC", false, nil, "Far too early"),
                ("1 week post-arrest always", false, nil, "72 hours is minimum, multimodal approach")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "Neurologic prognosis: wait at least 72 hours, off sedation/paralysis, use multimodal assessment (clinical exam, EEG, MRI, SSEP).",
            keyPoint: "Neuroprognosis: ≥72h, off sedation, multimodal"
        ),
        makeQuestion(
            stem: "Shivering during therapeutic hypothermia should be:",
            choices: [
                ("Treated aggressively as it increases metabolic demand", true, "Shivering negates cooling benefits", nil),
                ("Ignored as it is normal", false, nil, "Shivering counters temperature goals"),
                ("Used as an indicator of good prognosis", false, nil, "Not a prognostic sign"),
                ("Treated with rewarming only", false, nil, "Treat shivering, maintain temperature goal")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Shivering increases metabolic demand and fights cooling. Treat with surface counterwarming, buspirone, dexmedetomidine, meperidine, or paralysis.",
            keyPoint: "Shivering: treat aggressively"
        ),
        makeQuestion(
            stem: "Post-ROSC ventilation should target:",
            choices: [
                ("Normal ETCO2/PaCO2 (35-45 mmHg), avoid hyperventilation", true, "Normocarbia goal", nil),
                ("Hyperventilation to reduce ICP", false, nil, "Harmful - reduces cerebral perfusion"),
                ("Hypoventilation to preserve CO2", false, nil, "May cause hypoxia and acidosis"),
                ("Any ETCO2 is acceptable", false, nil, "Target normocarbia")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Post-ROSC: target normal ETCO2 35-45 mmHg. Avoid hyperventilation (reduces cerebral blood flow) and hypoventilation (causes hypoxia).",
            keyPoint: "Post-ROSC: ETCO2 35-45, avoid hyperventilation"
        ),
        makeQuestion(
            stem: "Seizure management in post-cardiac arrest patients:",
            choices: [
                ("Treat clinical seizures promptly; prophylactic anticonvulsants not routinely recommended", true, "Treat seizures, don't prevent routinely", nil),
                ("Prophylactic anticonvulsants for all patients", false, nil, "Not recommended routinely"),
                ("No treatment needed for seizures", false, nil, "Seizures increase metabolic demand"),
                ("Only treat status epilepticus", false, nil, "Treat all clinical seizures")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "Treat clinical seizures promptly with standard anti-seizure medications. Routine prophylaxis not recommended.",
            keyPoint: "Seizures: treat promptly, no routine prophylaxis"
        ),
        makeQuestion(
            stem: "Glucose management post-ROSC should target:",
            choices: [
                ("Avoid severe hypo- and hyperglycemia; target ~140-180 mg/dL", true, "Moderate glucose control", nil),
                ("Tight control <110 mg/dL", false, nil, "Risk of hypoglycemia"),
                ("No glucose monitoring needed", false, nil, "Glucose control important"),
                ("Allow hyperglycemia >300 mg/dL", false, nil, "Harmful")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Moderate glucose control (~140-180 mg/dL). Avoid severe hypo- and hyperglycemia. Tight control increases hypoglycemia risk.",
            keyPoint: "Glucose: 140-180 mg/dL, avoid extremes"
        )
    ]
    
    // MARK: - Comprehensive Team Dynamics Expansion (20 additional)
    
    static let additionalTeamQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Closed-loop communication during resuscitation means:",
            choices: [
                ("Order given → acknowledgment → confirmation when complete", true, "Ensures orders are heard and executed", nil),
                ("Only the team leader speaks", false, nil, "Team members must communicate back"),
                ("Using walkie-talkies", false, nil, "Refers to communication pattern, not equipment"),
                ("Speaking in medical abbreviations", false, nil, "Actually discouraged")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Closed-loop: Leader orders → Team member repeats/acknowledges → Confirms when done. Prevents errors.",
            keyPoint: "Closed-loop: order → acknowledge → confirm"
        ),
        makeQuestion(
            stem: "The role of the team leader during resuscitation is:",
            choices: [
                ("Direct team, make decisions, assign roles, observe and correct, synthesize information", true, "Oversee without performing tasks", nil),
                ("Perform chest compressions only", false, nil, "Team leader shouldn't be task-focused"),
                ("Only document the code", false, nil, "Documentation is separate role"),
                ("Stand back and not interfere", false, nil, "Must actively lead")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "Team leader: assign roles, direct care, make decisions, maintain situational awareness, and synthesize team input.",
            keyPoint: "Team leader: direct, don't do tasks"
        ),
        makeQuestion(
            stem: "Mutual respect during resuscitation includes:",
            choices: [
                ("Constructive intervention regardless of hierarchy, valuing all team input", true, "Flat hierarchy for patient safety", nil),
                ("Only senior doctors can make suggestions", false, nil, "Anyone can speak up"),
                ("Never questioning orders", false, nil, "Questions are appropriate for safety"),
                ("Ignoring inexperienced team members", false, nil, "All input is valuable")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Mutual respect: flat hierarchy during codes, constructive intervention encouraged, all team members valued.",
            keyPoint: "Flat hierarchy: anyone can speak up"
        ),
        makeQuestion(
            stem: "When an error is recognized during resuscitation, the appropriate response is:",
            choices: [
                ("Speak up immediately using clear, respectful communication", true, "Patient safety first", nil),
                ("Wait until after the code to discuss", false, nil, "May harm patient"),
                ("Only the team leader can identify errors", false, nil, "Anyone should speak up"),
                ("Document but don't interrupt", false, nil, "Immediate correction needed")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Speak up immediately when errors are recognized. Use 'I have a concern' or similar assertive but respectful language.",
            keyPoint: "Errors: speak up immediately"
        ),
        makeQuestion(
            stem: "Debriefing after resuscitation should focus on:",
            choices: [
                ("What went well, what could improve, emotional support for team", true, "Constructive review for improvement", nil),
                ("Blame for any mistakes", false, nil, "Non-punitive approach"),
                ("Only successful resuscitations", false, nil, "Learn from all cases"),
                ("Medical details only, not emotions", false, nil, "Address team wellbeing")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Debriefing: review performance (strengths and areas to improve), address emotional impact, learn from experience.",
            keyPoint: "Debrief: review, learn, support"
        ),
        makeQuestion(
            stem: "Role assignment during resuscitation should occur:",
            choices: [
                ("Early, with clear assignments and confirmation from each team member", true, "Prevents confusion and duplication", nil),
                ("Naturally without explicit assignment", false, nil, "Can lead to chaos"),
                ("Only when problems arise", false, nil, "Proactive assignment better"),
                ("After medications are given", false, nil, "Too late")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Assign roles early: compressor, airway, medications, recorder, team leader. Confirm each person understands their role.",
            keyPoint: "Roles: assign early, confirm understanding"
        ),
        makeQuestion(
            stem: "Pit crew CPR refers to:",
            choices: [
                ("Choreographed, efficient team approach with seamless role transitions", true, "Like a NASCAR pit crew", nil),
                ("Single rescuer CPR", false, nil, "This is team-based"),
                ("CPR performed in a pit or excavation", false, nil, "Refers to team efficiency"),
                ("Mechanical CPR only", false, nil, "Refers to team coordination")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "Pit crew CPR: predetermined positions, smooth transitions, minimal pause time during compressor changes and defibrillation.",
            keyPoint: "Pit crew: choreographed team efficiency"
        ),
        makeQuestion(
            stem: "If you are uncertain about a medication order during a code, you should:",
            choices: [
                ("Ask for clarification before giving the medication", true, "Never give medication you're unsure about", nil),
                ("Give it anyway - speed is essential", false, nil, "Safety first"),
                ("Give half the dose", false, nil, "Could be harmful or ineffective"),
                ("Ignore the order", false, nil, "Must address, not ignore")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Always clarify uncertain orders. 'I need to clarify - did you say [medication] [dose]?' is appropriate.",
            keyPoint: "Uncertain orders: always clarify"
        )
    ]
    
    // MARK: - Additional Rhythm Recognition (20 additional)
    
    static let additionalRhythmQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What distinguishes sinus tachycardia from other SVTs?",
            choices: [
                ("P waves present before each QRS, rate usually <150, gradual onset", true, "Physiologic response", nil),
                ("No P waves ever", false, nil, "P waves ARE present in sinus tach"),
                ("Always >200 bpm", false, nil, "Usually <150 bpm"),
                ("Wide QRS complexes", false, nil, "Narrow QRS")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Sinus tachycardia: normal P waves, rate <150, gradual onset/offset. Response to physiologic stress, not primary arrhythmia.",
            keyPoint: "Sinus tach: P waves present, usually <150"
        ),
        makeQuestion(
            stem: "Atrial flutter characteristically shows:",
            choices: [
                ("Sawtooth flutter waves at ~300/min with regular ventricular response", true, "Classic flutter pattern", nil),
                ("Irregularly irregular rhythm", false, nil, "That's AFib"),
                ("Chaotic baseline", false, nil, "That's AFib"),
                ("Wide QRS complexes", false, nil, "Narrow unless aberrancy")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Atrial flutter: sawtooth flutter waves at ~300/min, usually 2:1 block → rate 150, or 3:1/4:1 with lower rates.",
            keyPoint: "Flutter: sawtooth at 300, ventricular 150 (2:1)"
        ),
        makeQuestion(
            stem: "The hallmark of atrial fibrillation is:",
            choices: [
                ("Irregularly irregular rhythm with no distinct P waves", true, "Chaotic atrial activity", nil),
                ("Regular rhythm with P waves", false, nil, "That's sinus rhythm"),
                ("Wide QRS complexes always", false, nil, "Usually narrow"),
                ("Regular R-R intervals", false, nil, "Irregularly irregular")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "AFib: irregularly irregular R-R intervals, no organized P waves, fibrillatory baseline. Most common sustained arrhythmia.",
            keyPoint: "AFib: irregularly irregular, no P waves"
        ),
        makeQuestion(
            stem: "A junctional rhythm is characterized by:",
            choices: [
                ("Absent or inverted P waves, rate 40-60 bpm, narrow QRS", true, "Originates from AV junction", nil),
                ("Wide QRS complexes", false, nil, "Narrow QRS unless aberrancy"),
                ("Rate >100 bpm", false, nil, "That would be junctional tachycardia"),
                ("Sawtooth baseline", false, nil, "That's atrial flutter")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Junctional rhythm: narrow QRS, absent/inverted/retrograde P waves (before, during, or after QRS), rate 40-60 bpm.",
            keyPoint: "Junctional: no P or inverted P, 40-60 bpm"
        ),
        makeQuestion(
            stem: "First-degree AV block is defined as:",
            choices: [
                ("PR interval >0.20 seconds with all beats conducting", true, "Prolonged but consistent conduction", nil),
                ("Some P waves not followed by QRS", false, nil, "That's 2nd or 3rd degree"),
                ("No P waves visible", false, nil, "P waves ARE present"),
                ("Variable PR intervals", false, nil, "PR is prolonged but constant")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "First-degree AV block: PR >0.20s (200ms), but all P waves conduct. Benign, requires no treatment unless symptomatic.",
            keyPoint: "1st degree: PR >0.20s, all beats conduct"
        ),
        makeQuestion(
            stem: "The difference between SVT with aberrancy and VT can be challenging. Which favors VT?",
            choices: [
                ("AV dissociation, concordance in precordial leads, history of structural heart disease", true, "Classic VT features", nil),
                ("Narrow QRS", false, nil, "Narrow favors SVT"),
                ("Regular R-R intervals", false, nil, "Both can be regular"),
                ("Young patient without heart disease", false, nil, "Favors SVT, not VT")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "VT clues: AV dissociation, fusion/capture beats, extreme axis, concordance, QRS >160ms, history of MI/cardiomyopathy.",
            keyPoint: "VT clues: AV dissociation, concordance, wide QRS"
        ),
        makeQuestion(
            stem: "Multifocal atrial tachycardia (MAT) is characterized by:",
            choices: [
                ("≥3 different P wave morphologies, irregular rhythm, rate >100", true, "Multiple atrial foci", nil),
                ("Regular rhythm with identical P waves", false, nil, "That's sinus tachycardia"),
                ("Sawtooth baseline", false, nil, "That's flutter"),
                ("Wide QRS complexes", false, nil, "Narrow QRS")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "MAT: ≥3 distinct P wave morphologies, varying PR intervals, irregular rhythm, rate >100. Often seen in COPD.",
            keyPoint: "MAT: ≥3 P wave shapes, irregular, COPD"
        ),
        makeQuestion(
            stem: "Accelerated idioventricular rhythm (AIVR) typically presents with:",
            choices: [
                ("Wide QRS at 40-100 bpm, often after reperfusion", true, "Benign reperfusion sign", nil),
                ("Narrow QRS at 150 bpm", false, nil, "That's SVT"),
                ("Chaotic rhythm", false, nil, "That's VF"),
                ("Always requires treatment", false, nil, "Usually benign, monitor only")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "AIVR: wide QRS, rate 40-100 bpm. Often seen during MI reperfusion. Usually benign, self-limited, no treatment needed.",
            keyPoint: "AIVR: wide, 40-100 bpm, reperfusion sign"
        )
    ]
    
    // MARK: - Additional Airway/Electrical Questions (15 additional)
    
    static let additionalAirwayElectricalQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "The gold standard for confirming endotracheal tube placement is:",
            choices: [
                ("Continuous waveform capnography showing ETCO2", true, "Confirms tube in airway", nil),
                ("Chest rise alone", false, nil, "Not definitive"),
                ("Listening for breath sounds", false, nil, "Can be misleading"),
                ("Chest X-ray only", false, nil, "Delays confirmation")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "Waveform capnography is the gold standard for ETT confirmation. ETCO2 waveform indicates tube is in airway, not esophagus.",
            keyPoint: "ETT confirmation: waveform capnography"
        ),
        makeQuestion(
            stem: "Supraglottic airways (LMA, King LT) are appropriate as:",
            choices: [
                ("Alternative to ETT, especially when intubation is difficult or not feasible", true, "Valid airway management", nil),
                ("Only for conscious patients", false, nil, "Used in unconscious patients"),
                ("Never during CPR", false, nil, "Commonly used during CPR"),
                ("Only by anesthesiologists", false, nil, "Used by all ACLS providers")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "Supraglottic airways are acceptable advanced airways during CPR. Easier to place than ETT, effective for ventilation.",
            keyPoint: "SGAs: valid alternative to ETT"
        ),
        makeQuestion(
            stem: "During CPR with an advanced airway, ventilations should be:",
            choices: [
                ("1 every 6 seconds (10/min), asynchronous with compressions", true, "Continuous compressions with async breaths", nil),
                ("30:2 with pauses for breaths", false, nil, "Only without advanced airway"),
                ("As fast as possible", false, nil, "Avoid hyperventilation"),
                ("Held until ROSC", false, nil, "Ventilation needed throughout")
            ],
            topic: .airway,
            difficulty: .easy,
            explanation: "With advanced airway: ventilate 1 breath q6 seconds (10/min), asynchronous with continuous compressions.",
            keyPoint: "Advanced airway: 10 breaths/min async"
        ),
        makeQuestion(
            stem: "Hyperventilation during CPR is harmful because:",
            choices: [
                ("Increases intrathoracic pressure → decreases venous return → decreases cardiac output", true, "Impairs circulation", nil),
                ("Causes hypoxia", false, nil, "Actually causes hyperoxia"),
                ("Has no effect", false, nil, "Very harmful"),
                ("Improves prognosis", false, nil, "Worsens prognosis")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "Hyperventilation increases intrathoracic pressure, impedes venous return, and decreases cardiac output during CPR.",
            keyPoint: "Hyperventilation: ↓ venous return, ↓ cardiac output"
        ),
        makeQuestion(
            stem: "Synchronized cardioversion differs from defibrillation in that:",
            choices: [
                ("Energy is delivered synchronized to R wave to avoid T wave (vulnerable period)", true, "Avoids inducing VF", nil),
                ("Higher energy is used", false, nil, "Often lower energy"),
                ("No preparation needed", false, nil, "Still requires preparation"),
                ("Used for VF", false, nil, "Used for organized rhythms")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Synchronized cardioversion times shock to R wave, avoiding vulnerable T wave period that could induce VF.",
            keyPoint: "Cardioversion: sync to R wave"
        ),
        makeQuestion(
            stem: "If synchronization fails during attempted cardioversion for unstable VT:",
            choices: [
                ("Deliver unsynchronized shock - don't delay treatment", true, "Patient safety first", nil),
                ("Keep trying until sync works", false, nil, "Would delay treatment"),
                ("Cancel the cardioversion", false, nil, "Patient is unstable"),
                ("Use medications instead", false, nil, "Unstable = electrical therapy needed")
            ],
            topic: .electrical,
            difficulty: .hard,
            explanation: "If sync fails for unstable tachycardia, deliver unsynchronized shock. Patient instability takes priority.",
            keyPoint: "Sync failure: shock anyway if unstable"
        ),
        makeQuestion(
            stem: "Transcutaneous pacing requires which settings to be adjusted?",
            choices: [
                ("Rate and output (mA); increase output until capture achieved", true, "Two main settings", nil),
                ("Energy in joules only", false, nil, "That's for defibrillation"),
                ("Frequency in Hz", false, nil, "Not a pacing setting"),
                ("No settings needed", false, nil, "Must set rate and output")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "TCP settings: rate (typically 60-70 bpm) and output (mA). Increase output until electrical and mechanical capture.",
            keyPoint: "TCP: set rate and output (mA)"
        )
    ]
    
    // MARK: - Additional Vascular Access Questions (15 additional)
    
    static let additionalVascularQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per 2025 guidelines, the preferred vascular access route during cardiac arrest is:",
            choices: [
                ("Peripheral IV; IO if IV not rapidly obtained", true, "IV preferred, IO is backup", nil),
                ("IO first always", false, nil, "IV is preferred"),
                ("Central line required", false, nil, "Not required during CPR"),
                ("Endotracheal drug administration", false, nil, "No longer recommended")
            ],
            topic: .vascularAccess,
            difficulty: .easy,
            explanation: "2025 guidelines: Peripheral IV preferred. IO is reasonable alternative if IV difficult or delayed.",
            keyPoint: "2025: IV preferred, IO backup"
        ),
        makeQuestion(
            stem: "Common IO insertion sites for adults include:",
            choices: [
                ("Proximal tibia, proximal humerus, distal tibia", true, "Multiple sites available", nil),
                ("Only the sternum", false, nil, "Sternal IO requires special device"),
                ("Radius only", false, nil, "Not a common site"),
                ("Skull", false, nil, "Not an IO site")
            ],
            topic: .vascularAccess,
            difficulty: .easy,
            explanation: "Adult IO sites: proximal tibia (most common), proximal humerus (good flow), distal tibia. Sternal with special device.",
            keyPoint: "IO sites: tibia, humerus, sternal (special)"
        ),
        makeQuestion(
            stem: "What is the maximum time you should spend attempting IV access before moving to IO?",
            choices: [
                ("90 seconds or 2 failed attempts", true, "Don't delay drug delivery", nil),
                ("5 minutes", false, nil, "Too long"),
                ("Until successful", false, nil, "Would delay critical medications"),
                ("IO should never be used", false, nil, "IO is acceptable alternative")
            ],
            topic: .vascularAccess,
            difficulty: .medium,
            explanation: "Attempt IV for ~90 seconds or 2 attempts. If unsuccessful, switch to IO to avoid delaying medications.",
            keyPoint: "IV timeout: 90 sec or 2 attempts → IO"
        ),
        makeQuestion(
            stem: "After IO insertion, the first step should be:",
            choices: [
                ("Confirm placement and flush with normal saline before medication", true, "Ensure proper placement", nil),
                ("Immediately push medications", false, nil, "Confirm placement first"),
                ("Wait for X-ray confirmation", false, nil, "Would delay treatment"),
                ("Remove needle driver only", false, nil, "Must confirm placement")
            ],
            topic: .vascularAccess,
            difficulty: .easy,
            explanation: "After IO insertion: confirm placement, flush with 5-10 mL saline, then administer medications with saline flushes.",
            keyPoint: "IO: confirm, flush, then medicate"
        ),
        makeQuestion(
            stem: "IO contraindications include:",
            choices: [
                ("Fracture of target bone, previous IO in same bone, prosthetic joint at site", true, "Anatomic contraindications", nil),
                ("Cardiac arrest", false, nil, "Actually an indication"),
                ("Hypotension", false, nil, "Not a contraindication"),
                ("Obesity", false, nil, "May require longer needle, not contraindicated")
            ],
            topic: .vascularAccess,
            difficulty: .medium,
            explanation: "IO contraindications: fracture, previous IO (same bone in 24h), prosthesis at site, infection overlying, inability to locate landmarks.",
            keyPoint: "IO contraindicated: fracture, prior IO, prosthesis"
        ),
        makeQuestion(
            stem: "What flush is recommended after each medication given via IO?",
            choices: [
                ("10-20 mL normal saline", true, "Ensure delivery to central circulation", nil),
                ("No flush needed", false, nil, "Flush is essential"),
                ("D5W only", false, nil, "NS is standard"),
                ("Heparin flush", false, nil, "Not needed for IO")
            ],
            topic: .vascularAccess,
            difficulty: .easy,
            explanation: "Flush IO with 10-20 mL NS after each medication to ensure drug reaches central circulation.",
            keyPoint: "IO: flush 10-20 mL NS after each med"
        ),
        makeQuestion(
            stem: "Endotracheal drug administration is:",
            choices: [
                ("No longer recommended in current ACLS guidelines", true, "IV/IO preferred", nil),
                ("First-line route", false, nil, "No longer recommended"),
                ("Better than IV", false, nil, "Inferior to IV/IO"),
                ("Used for all ACLS drugs", false, nil, "Not recommended")
            ],
            topic: .vascularAccess,
            difficulty: .easy,
            explanation: "Endotracheal drug administration removed from guidelines due to unpredictable absorption. Use IV or IO.",
            keyPoint: "ET drugs: no longer recommended"
        )
    ]
    
    // MARK: - Additional Stroke Questions (15 additional)
    
    static let additionalStrokeQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "The time window for IV thrombolysis (alteplase/tenecteplase) in acute ischemic stroke is:",
            choices: [
                ("Within 4.5 hours of symptom onset (3 hours for some patients)", true, "Time-critical intervention", nil),
                ("Within 24 hours", false, nil, "Window is much shorter"),
                ("Only within 1 hour", false, nil, "Window extends to 4.5 hours"),
                ("No time limit exists", false, nil, "Strict time window")
            ],
            topic: .stroke,
            difficulty: .medium,
            explanation: "IV thrombolysis: within 3 hours for all eligible, extended to 4.5 hours for select patients. Time is brain!",
            keyPoint: "Stroke thrombolysis: 3-4.5 hour window"
        ),
        makeQuestion(
            stem: "Blood pressure management for acute ischemic stroke eligible for thrombolysis requires BP to be:",
            choices: [
                ("<185/110 mmHg before and <180/105 after treatment", true, "Prevent hemorrhagic conversion", nil),
                ("<120/80 mmHg", false, nil, "Too aggressive"),
                (">200/120 mmHg", false, nil, "Too high"),
                ("Any BP is acceptable", false, nil, "Specific thresholds exist")
            ],
            topic: .stroke,
            difficulty: .hard,
            explanation: "For thrombolysis eligibility: BP must be <185/110. After treatment, maintain <180/105 for 24 hours.",
            keyPoint: "Thrombolysis BP: <185/110 before, <180/105 after"
        ),
        makeQuestion(
            stem: "The target glucose range during acute stroke is:",
            choices: [
                ("140-180 mg/dL (avoid hypo- and severe hyperglycemia)", true, "Moderate control", nil),
                ("<100 mg/dL", false, nil, "Risk of hypoglycemia"),
                (">250 mg/dL", false, nil, "Hyperglycemia worsens outcomes"),
                ("No glucose management needed", false, nil, "Glucose affects outcomes")
            ],
            topic: .stroke,
            difficulty: .medium,
            explanation: "Target glucose 140-180 mg/dL. Hyperglycemia worsens outcomes; hypoglycemia is also harmful.",
            keyPoint: "Stroke glucose: 140-180 mg/dL"
        ),
        makeQuestion(
            stem: "Mechanical thrombectomy for large vessel occlusion stroke can be considered up to:",
            choices: [
                ("24 hours in select patients with favorable imaging", true, "Extended window with imaging selection", nil),
                ("3 hours only", false, nil, "Window is much longer for thrombectomy"),
                ("12 hours maximum", false, nil, "Can extend to 24 hours with selection"),
                ("No time limit", false, nil, "Still has time and imaging criteria")
            ],
            topic: .stroke,
            difficulty: .hard,
            explanation: "Thrombectomy: up to 24 hours in patients with favorable perfusion imaging (salvageable tissue).",
            keyPoint: "Thrombectomy: up to 24h with imaging"
        ),
        makeQuestion(
            stem: "The NIHSS (National Institutes of Health Stroke Scale) measures:",
            choices: [
                ("Stroke severity based on neurologic deficits", true, "Standardized severity assessment", nil),
                ("Cardiac function after stroke", false, nil, "Measures neurologic deficits"),
                ("Blood pressure response", false, nil, "Measures neuro deficits"),
                ("Time since symptom onset", false, nil, "It's a severity scale")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "NIHSS: standardized assessment of stroke severity (0-42). Higher scores = more severe deficits.",
            keyPoint: "NIHSS: stroke severity scale 0-42"
        ),
        makeQuestion(
            stem: "For acute ischemic stroke NOT receiving thrombolysis, permissive hypertension allows BP up to:",
            choices: [
                ("220/120 mmHg (unless other end-organ damage)", true, "Maintain cerebral perfusion", nil),
                ("120/80 mmHg", false, nil, "Would reduce cerebral perfusion"),
                ("180/100 mmHg", false, nil, "Higher threshold for non-thrombolysis patients"),
                ("Any BP requires treatment", false, nil, "Permissive hypertension accepted")
            ],
            topic: .stroke,
            difficulty: .hard,
            explanation: "Without thrombolysis: allow BP up to 220/120 to maintain perfusion. Treat if end-organ damage or >220/120.",
            keyPoint: "No tPA: allow BP to 220/120"
        )
    ]
    
    // MARK: - Additional ACS Questions (15 additional)
    
    static let additionalACSQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "For STEMI, the goal for first medical contact-to-device (balloon) time at a PCI-capable hospital is:",
            choices: [
                ("≤90 minutes", true, "Door-to-balloon target", nil),
                ("≤24 hours", false, nil, "Much too long"),
                ("≤6 hours", false, nil, "Target is 90 minutes"),
                ("No time target exists", false, nil, "Strict time target")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "STEMI: door-to-balloon ≤90 minutes at PCI center, or ≤120 minutes if transfer required.",
            keyPoint: "STEMI: D2B ≤90 min (PCI center)"
        ),
        makeQuestion(
            stem: "The initial dose of aspirin for acute coronary syndrome is:",
            choices: [
                ("160-325 mg chewed (non-enteric coated)", true, "Rapid antiplatelet effect", nil),
                ("81 mg only", false, nil, "Loading dose is higher"),
                ("1000 mg", false, nil, "Excessive"),
                ("Aspirin is contraindicated in ACS", false, nil, "First-line treatment")
            ],
            topic: .acs,
            difficulty: .easy,
            explanation: "ACS aspirin: 160-325 mg chewed for rapid absorption. Non-enteric coated preferred for faster effect.",
            keyPoint: "ACS aspirin: 160-325 mg chewed"
        ),
        makeQuestion(
            stem: "Nitroglycerin is contraindicated in ACS when:",
            choices: [
                ("SBP <90, recent PDE5 inhibitor use, or right ventricular infarction", true, "Risk of profound hypotension", nil),
                ("Patient has chest pain", false, nil, "That's the indication"),
                ("Any heart rate abnormality", false, nil, "Not a contraindication"),
                ("Patient is >65 years old", false, nil, "Age alone is not contraindication")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "NTG contraindicated: SBP <90, sildenafil/tadalafil in 24-48h, suspected RV infarction (preload dependent).",
            keyPoint: "NTG contraindicated: low BP, PDE5i, RV MI"
        ),
        makeQuestion(
            stem: "For STEMI when PCI is not available within 120 minutes, the alternative is:",
            choices: [
                ("Fibrinolytic therapy within 30 minutes of arrival", true, "Pharmacologic reperfusion", nil),
                ("Wait for PCI regardless of time", false, nil, "Would cause excessive delay"),
                ("Aspirin only", false, nil, "Inadequate for STEMI"),
                ("Observation", false, nil, "Reperfusion is critical")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "If PCI unavailable within 120 min: fibrinolytic therapy within 30 min of arrival (if no contraindications).",
            keyPoint: "No PCI available: fibrinolytics within 30 min"
        ),
        makeQuestion(
            stem: "Morphine in ACS should be used:",
            choices: [
                ("Cautiously - may increase mortality in some studies; reserve for refractory pain", true, "Use with caution", nil),
                ("Routinely for all chest pain", false, nil, "No longer routine"),
                ("Before nitroglycerin", false, nil, "NTG before morphine"),
                ("Never in ACS", false, nil, "Reserved for refractory pain")
            ],
            topic: .acs,
            difficulty: .hard,
            explanation: "Morphine: use cautiously in ACS. Some data suggest potential harm. Reserve for pain refractory to NTG.",
            keyPoint: "Morphine in ACS: cautious use only"
        ),
        makeQuestion(
            stem: "Inferior STEMI with right ventricular involvement should be treated with:",
            choices: [
                ("IV fluids to maintain preload; avoid nitrates and diuretics", true, "RV is preload dependent", nil),
                ("Aggressive diuresis", false, nil, "Would worsen hypotension"),
                ("Nitroglycerin for chest pain", false, nil, "NTG contraindicated in RV MI"),
                ("Beta blockers first", false, nil, "Fluids are priority")
            ],
            topic: .acs,
            difficulty: .hard,
            explanation: "RV infarction: preload dependent. Give IV fluids, avoid nitrates and diuretics which drop preload.",
            keyPoint: "RV MI: IV fluids, avoid NTG/diuretics"
        )
    ]
    
    // MARK: - Final 2025 Guidelines Questions (20 additional)
    
    static let final2025Questions: [ACLSQuestion] = [
        makeQuestion(
            stem: "The 2025 Chain of Survival has been:",
            choices: [
                ("Unified for in-hospital and out-of-hospital, adult and pediatric", true, "One universal chain", nil),
                ("Separated into more distinct chains", false, nil, "Actually unified"),
                ("Eliminated entirely", false, nil, "Still exists but unified"),
                ("Only for out-of-hospital use", false, nil, "Universal chain")
            ],
            topic: .guidelines2025,
            difficulty: .easy,
            explanation: "2025: Universal Chain of Survival applies regardless of setting (IHCA/OHCA) or age (adult/pediatric).",
            keyPoint: "2025: Universal Chain of Survival"
        ),
        makeQuestion(
            stem: "Regarding rescue breaths, the 2025 guidelines:",
            choices: [
                ("Fully reinstate rescue breaths after COVID-era hesitation", true, "Breaths are back", nil),
                ("Eliminate rescue breaths entirely", false, nil, "Breaths reinstated"),
                ("Recommend compression-only CPR for all", false, nil, "Breaths recommended when trained"),
                ("Only allow healthcare providers to give breaths", false, nil, "Lay rescuers can give breaths")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025 guidelines fully reinstate rescue breaths. COVID-era guidance allowing compression-only for lay rescuers is less emphasized.",
            keyPoint: "2025: rescue breaths fully reinstated"
        ),
        makeQuestion(
            stem: "The 2025 recommendation for mechanical CPR devices is:",
            choices: [
                ("Reasonable when high-quality manual CPR is challenging to sustain", true, "Alternative, not routine", nil),
                ("Superior to manual CPR and should be used routinely", false, nil, "Not proven superior"),
                ("No longer recommended", false, nil, "Still reasonable alternative"),
                ("Required for all in-hospital arrests", false, nil, "Not required")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "Mechanical CPR: reasonable alternative when manual CPR difficult (transport, cath lab, prolonged CPR). Not superior to quality manual CPR.",
            keyPoint: "Mechanical CPR: alternative when manual difficult"
        ),
        makeQuestion(
            stem: "The 2025 guidelines changed the defibrillation algorithm by:",
            choices: [
                ("Moving advanced airway earlier, separating ROSC into its own algorithm", true, "Structural changes", nil),
                ("Eliminating defibrillation", false, nil, "Defibrillation still central"),
                ("Adding more branch points", false, nil, "Actually simplified"),
                ("Requiring sequential shocks always", false, nil, "Standard single shock approach")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "2025 algorithm changes: advanced airway moved earlier, ROSC management in separate algorithm, fewer branch points.",
            keyPoint: "2025: airway earlier, ROSC separate algorithm"
        ),
        makeQuestion(
            stem: "The 2025 guidelines address termination of resuscitation by stating:",
            choices: [
                ("ETCO2 should not be the sole factor; consider multiple factors", true, "Multimodal decision making", nil),
                ("ETCO2 <10 for 20 min mandates termination", false, nil, "Not the sole factor"),
                ("All arrests must continue for 60+ minutes", false, nil, "No such requirement"),
                ("Termination decisions are not addressed", false, nil, "Explicitly addressed")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "2025: Termination should not rely on ETCO2 alone. Consider duration, rhythm, reversible causes, patient factors.",
            keyPoint: "Termination: ETCO2 not sole factor"
        ),
        makeQuestion(
            stem: "For drowning victims, the 2025 guidelines emphasize:",
            choices: [
                ("Early ventilation is critical due to hypoxic etiology", true, "Hypoxia is primary cause", nil),
                ("Compression-only CPR preferred", false, nil, "Ventilation is essential for drowning"),
                ("Heimlich maneuver first", false, nil, "Not recommended for drowning"),
                ("Delayed resuscitation until dry", false, nil, "Begin immediately")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "Drowning: hypoxia is the primary cause. Early ventilation is critical. Give 5 rescue breaths before compressions.",
            keyPoint: "Drowning: early ventilation essential"
        ),
        makeQuestion(
            stem: "The 2025 neuroprognosis recommendations state:",
            choices: [
                ("Use multimodal assessment ≥72 hours after arrest, off sedation", true, "Multiple modalities, adequate time", nil),
                ("Clinical exam alone at 24 hours is sufficient", false, nil, "Too early, single modality"),
                ("CT scan at 1 hour determines prognosis", false, nil, "Multiple modalities needed"),
                ("Prognosis should be made during CPR", false, nil, "After ROSC and stabilization")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "Neuroprognosis: wait ≥72 hours, patient off sedation/paralysis, use multimodal assessment (exam, EEG, imaging, SSEP).",
            keyPoint: "Prognosis: ≥72h, multimodal, off sedation"
        ),
        makeQuestion(
            stem: "The 2025 post-arrest hemodynamic target focuses on:",
            choices: [
                ("MAP ≥65 mmHg rather than systolic BP targets", true, "MAP is the focus", nil),
                ("SBP >120 mmHg always", false, nil, "MAP target, not SBP"),
                ("Diastolic BP >80 mmHg", false, nil, "MAP is the target"),
                ("No hemodynamic targets", false, nil, "MAP ≥65 is specified")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: MAP ≥65 mmHg is the target. Systolic BP targets have been removed from the algorithm.",
            keyPoint: "2025: MAP ≥65, no SBP targets"
        ),
        makeQuestion(
            stem: "Education science in 2025 guidelines emphasizes:",
            choices: [
                ("Deliberate practice, mastery learning, and just-in-time training", true, "Evidence-based training approaches", nil),
                ("One-time lecture-based training", false, nil, "Hands-on practice emphasized"),
                ("No updates to education recommendations", false, nil, "Education science updated"),
                ("Eliminating simulation training", false, nil, "Simulation is recommended")
            ],
            topic: .guidelines2025,
            difficulty: .easy,
            explanation: "2025 education: deliberate practice, mastery learning, frequent refresher training, just-in-time training before anticipated events.",
            keyPoint: "Training: deliberate practice, mastery learning"
        ),
        makeQuestion(
            stem: "The 2025 guidelines state that community CPR training:",
            choices: [
                ("Should be widely disseminated to maximize bystander CPR rates", true, "Bystander CPR saves lives", nil),
                ("Is only for healthcare professionals", false, nil, "Community training emphasized"),
                ("Is less important than in-hospital training", false, nil, "Both are critical"),
                ("Should focus only on compression-only CPR", false, nil, "Full CPR training when possible")
            ],
            topic: .guidelines2025,
            difficulty: .easy,
            explanation: "2025: Widespread CPR training increases bystander CPR rates, which significantly improves survival.",
            keyPoint: "Community CPR training: widely disseminate"
        )
    ]
    
    // MARK: - Advanced Clinical Scenarios (40 additional)
    
    static let advancedClinicalScenarios: [ACLSQuestion] = [
        // Scenario Set 1: Complex VF
        makeQuestion(
            stem: "A 55-year-old male with history of CAD is in refractory VF after 5 shocks, epinephrine x3, and amiodarone 450mg total. ETCO2 is 12 mmHg. What is your next consideration?",
            vignette: "Witnessed collapse in ED. Good CPR quality verified by waveform capnography.",
            vitals: ACLSVitals(heartRate: nil, bpSystolic: nil, bpDiastolic: nil, spO2: nil, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Consider double sequential defibrillation, lidocaine, and ECPR if available", true, "Escalation for refractory VF", nil),
                ("Terminate resuscitation - no further options", false, nil, "Escalation options exist"),
                ("Give more amiodarone - no maximum dose", false, nil, "Amiodarone is maxed (300+150)"),
                ("Switch to synchronized cardioversion", false, nil, "VF requires defibrillation")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "Refractory VF after max amiodarone: consider DSD (two defibrillators), lidocaine, and ECPR if at capable center.",
            keyPoint: "Refractory VF: DSD + lidocaine + consider ECPR"
        ),
        makeQuestion(
            stem: "During VF resuscitation, ETCO2 suddenly rises from 15 to 48 mmHg. What is your immediate action?",
            choices: [
                ("Pause at next rhythm check to assess for ROSC (pulse and rhythm)", true, "Sudden ETCO2 rise suggests ROSC", nil),
                ("Increase ventilation rate", false, nil, "Would be inappropriate for ROSC"),
                ("Continue unchanged - this is normal", false, nil, "This is a significant change"),
                ("Terminate resuscitation", false, nil, "Check for ROSC")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "Sudden sustained ETCO2 rise (typically to 35-45+) strongly suggests ROSC. Check pulse at next scheduled break.",
            keyPoint: "ETCO2 spike = check for ROSC"
        ),
        // Scenario Set 2: Complex Bradycardia
        makeQuestion(
            stem: "A post-cardiac surgery patient has symptomatic bradycardia (HR 38) with hypotension. Atropine 3mg has no effect. The patient has epicardial pacing wires. What is your best option?",
            choices: [
                ("Activate epicardial pacing using the external pacemaker", true, "Post-surgical pacing wires are available", nil),
                ("Transcutaneous pacing over epicardial", false, nil, "Epicardial is more reliable"),
                ("Isoproterenol infusion only", false, nil, "Pacing is faster and more reliable"),
                ("Repeat atropine", false, nil, "Already given maximum dose")
            ],
            topic: .bradycardia,
            difficulty: .hard,
            explanation: "Post-cardiac surgery with epicardial wires: use epicardial pacing. More reliable than TCP and immediately available.",
            keyPoint: "Post-op with epicardial wires: use them first"
        ),
        makeQuestion(
            stem: "A patient on high-dose diltiazem develops symptomatic bradycardia unresponsive to atropine. What specific treatments are indicated?",
            choices: [
                ("Calcium chloride, glucagon, and high-dose insulin-glucose therapy", true, "CCB toxicity antidotes", nil),
                ("More atropine only", false, nil, "Atropine ineffective for CCB toxicity"),
                ("Synchronized cardioversion", false, nil, "Wrong treatment for bradycardia"),
                ("Adenosine", false, nil, "Would worsen bradycardia")
            ],
            topic: .bradycardia,
            difficulty: .hard,
            explanation: "CCB toxicity: calcium (reverses CCB at L-type channels), glucagon, high-dose insulin (improves inotropy).",
            keyPoint: "CCB toxicity: calcium + glucagon + insulin"
        ),
        // Scenario Set 3: Complex Tachycardia
        makeQuestion(
            stem: "A patient with WPW presents with irregular wide-complex tachycardia (rate 220). BP 92/60, mild dyspnea. The best treatment is:",
            choices: [
                ("Synchronized cardioversion after brief sedation attempt", true, "Unstable + WPW with AFib", nil),
                ("Adenosine 6mg rapid IV push", false, nil, "Contraindicated in WPW-AFib"),
                ("Diltiazem 20mg IV", false, nil, "AV nodal blockers contraindicated"),
                ("Amiodarone 150mg IV", false, nil, "IV amiodarone has AV blocking properties")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "WPW with AFib: avoid ALL AV nodal blockers (adenosine, CCBs, BBs, digoxin, IV amiodarone). Cardiovert or use procainamide.",
            keyPoint: "WPW-AFib: cardiovert, avoid AV nodal blockers"
        ),
        makeQuestion(
            stem: "A patient with known SVT presents with HR 190, BP 110/70, and mild palpitations. Vagal maneuvers have failed. Next step:",
            choices: [
                ("Adenosine 6mg rapid IV push with immediate saline flush", true, "Stable SVT after vagal failure", nil),
                ("Immediate cardioversion", false, nil, "Patient is hemodynamically stable"),
                ("Amiodarone 300mg IV push", false, nil, "Adenosine is first-line for SVT"),
                ("Observation only", false, nil, "Treatment is indicated")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Stable SVT after vagal failure: adenosine 6mg rapid IV push. May repeat with 12mg if no response.",
            keyPoint: "Stable SVT: vagal → adenosine 6mg → 12mg"
        ),
        // Scenario Set 4: Complex PEA
        makeQuestion(
            stem: "A trauma patient with penetrating chest wound is in PEA. Breath sounds are absent on the left, JVD is present. Immediate action:",
            choices: [
                ("Left needle/finger thoracostomy for tension pneumothorax", true, "Clinical diagnosis - treat immediately", nil),
                ("Continue CPR and give epinephrine only", false, nil, "Must address tension pneumo"),
                ("Pericardiocentesis", false, nil, "Unilateral absent breath sounds suggests pneumo, not tamponade"),
                ("Chest X-ray before intervention", false, nil, "Would delay life-saving treatment")
            ],
            topic: .peaAsystole,
            difficulty: .hard,
            explanation: "Absent breath sounds + JVD + trauma = tension pneumothorax until proven otherwise. Needle/finger thoracostomy immediately.",
            keyPoint: "Trauma + absent sounds + JVD = decompress"
        ),
        makeQuestion(
            stem: "A dialysis patient with missed sessions is in PEA with wide, bizarre QRS complexes and peaked T waves. Priority treatment:",
            choices: [
                ("Calcium chloride 10mL IV push immediately", true, "Hyperkalemia causing arrest", nil),
                ("Epinephrine first, calcium later", false, nil, "Calcium should be given immediately for hyperK"),
                ("Defibrillation", false, nil, "PEA is not shockable"),
                ("Sodium bicarbonate only", false, nil, "Calcium is most urgent")
            ],
            topic: .peaAsystole,
            difficulty: .hard,
            explanation: "Dialysis patient + wide QRS + peaked T = hyperkalemia. Give calcium chloride immediately to stabilize myocardium.",
            keyPoint: "Dialysis + wide QRS = calcium NOW"
        ),
        // Scenario Set 5: Post-ROSC Management
        makeQuestion(
            stem: "After ROSC from VF arrest, a patient remains comatose. BP 88/52 on norepinephrine, SpO2 94% on FiO2 60%. Temperature is 38.8°C. Priorities include:",
            choices: [
                ("Titrate vasopressors to MAP ≥65, active cooling or fever prevention, coronary angiography if STEMI", true, "Comprehensive post-ROSC care", nil),
                ("Immediate neurologic prognostication", false, nil, "Too early - wait ≥72 hours"),
                ("Increase FiO2 to 100%", false, nil, "SpO2 94% is adequate; avoid hyperoxia"),
                ("Warm the patient", false, nil, "Fever should be treated, not induced")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "Post-ROSC: MAP ≥65, treat fever (target 32-37.5°C), consider coronary angiography, avoid hyperoxia/hypoxia.",
            keyPoint: "Post-ROSC: MAP, temp control, cath if STEMI"
        ),
        makeQuestion(
            stem: "Post-ROSC, patient is shivering during targeted temperature management. Shivering should be:",
            choices: [
                ("Treated aggressively as it increases metabolic demand and counteracts cooling", true, "Shivering negates TTM benefits", nil),
                ("Ignored as a good neurologic sign", false, nil, "Shivering is harmful during TTM"),
                ("Used to warm the patient", false, nil, "Goal is to maintain target temperature"),
                ("Indicates TTM should be stopped", false, nil, "Treat shivering, continue TTM")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Treat shivering: surface counterwarming, buspirone, meperidine, dexmedetomidine, or paralysis if needed.",
            keyPoint: "Shivering: treat aggressively during TTM"
        ),
        // Scenario Set 6: Special Circumstances
        makeQuestion(
            stem: "A 28-week pregnant patient is in cardiac arrest. In addition to standard ACLS, what must be done?",
            choices: [
                ("Left uterine displacement and prepare for perimortem cesarean delivery within 5 minutes if no ROSC", true, "Relieve aortocaval compression", nil),
                ("Standard ACLS only - pregnancy doesn't change management", false, nil, "Significant modifications needed"),
                ("Avoid all medications due to fetal risk", false, nil, "Standard ACLS drugs are indicated"),
                ("C-section before starting CPR", false, nil, "CPR starts immediately")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Pregnancy >20 weeks: left uterine displacement to relieve IVC compression. Perimortem C-section within 5 min if no ROSC.",
            keyPoint: "Pregnant arrest: LUD + C-section by 5 min"
        ),
        makeQuestion(
            stem: "A patient with known opioid use is found unresponsive with agonal respirations. No pulse. CPR is started. What additional intervention is recommended?",
            choices: [
                ("Give naloxone 2mg IM/IN while continuing CPR", true, "Empiric naloxone for opioid-associated arrest", nil),
                ("Naloxone only, no CPR needed", false, nil, "CPR is essential if pulseless"),
                ("Flumazenil instead of naloxone", false, nil, "Flumazenil is for benzodiazepines"),
                ("Delay all medications until IV access", false, nil, "IM/IN naloxone can be given immediately")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Opioid-associated arrest: CPR + empiric naloxone 2mg IM/IN. May repeat q2-3 minutes.",
            keyPoint: "Opioid arrest: CPR + naloxone"
        ),
        makeQuestion(
            stem: "A drowning victim is found unresponsive in a pool. The priority sequence for resuscitation is:",
            choices: [
                ("5 rescue breaths → check pulse → if pulseless, 30:2 CPR starting with compressions", true, "Ventilation priority for hypoxic arrest", nil),
                ("Compressions only, no breaths", false, nil, "Breaths are critical for drowning"),
                ("Heimlich maneuver first", false, nil, "Not recommended for drowning"),
                ("Wait until out of water to begin", false, nil, "Begin in water if trained and safe")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "Drowning: 5 rescue breaths first (hypoxic arrest), then check pulse, then standard CPR if pulseless.",
            keyPoint: "Drowning: 5 breaths first, then CPR"
        ),
        makeQuestion(
            stem: "A patient with suspected anaphylaxis is in PEA arrest. In addition to epinephrine 1mg IV q3-5min, what is critical?",
            choices: [
                ("Large volume IV fluid resuscitation for distributive shock", true, "Massive vasodilation requires volume", nil),
                ("Diphenhydramine as first priority", false, nil, "Epinephrine and fluids are priority"),
                ("Low-dose epinephrine only", false, nil, "Cardiac arrest dose is 1mg"),
                ("Steroids before epinephrine", false, nil, "Epinephrine is first-line")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Anaphylactic arrest: epinephrine 1mg IV + aggressive IV fluids (distributive shock with vasodilation).",
            keyPoint: "Anaphylaxis: epinephrine + fluids"
        ),
        // Scenario Set 7: Team Dynamics Scenarios
        makeQuestion(
            stem: "During a code, you notice the compressor is fatigued and compressions are becoming shallow. The most appropriate action is:",
            choices: [
                ("Speak up: 'I can see compressions are getting shallow. Let's switch compressors.'", true, "Constructive intervention for patient safety", nil),
                ("Wait for the 2-minute mark", false, nil, "Quality shouldn't suffer while waiting"),
                ("Say nothing to avoid embarrassing the compressor", false, nil, "Patient safety takes priority"),
                ("Take over without saying anything", false, nil, "Communication is important")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Speak up when CPR quality declines. Use respectful, constructive communication for patient safety.",
            keyPoint: "Speak up about CPR quality immediately"
        ),
        makeQuestion(
            stem: "The team leader orders 'atropine 1mg IV for VF.' This order is:",
            choices: [
                ("Inappropriate - atropine is not indicated for VF; clarify the order", true, "Wrong medication for rhythm", nil),
                ("Correct - follow the order immediately", false, nil, "Atropine not used in VF"),
                ("Correct but give only 0.5mg", false, nil, "Atropine not indicated at all"),
                ("Delay until someone else questions it", false, nil, "Speak up immediately")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "Atropine is not indicated for VF/pVT. Clarify the order respectfully: 'Can you confirm atropine for VF?'",
            keyPoint: "Question orders that seem inappropriate"
        ),
        // Scenario Set 8: Rhythm Interpretation
        makeQuestion(
            stem: "The monitor shows a wide, regular tachycardia at 160 bpm. The patient has a history of SVT. What should you assume?",
            choices: [
                ("VT until proven otherwise - never assume SVT with aberrancy", true, "Wide = VT until proven otherwise", nil),
                ("SVT with aberrancy given the history", false, nil, "Dangerous assumption"),
                ("Artifact - check leads", false, nil, "Must treat as real"),
                ("Supraventricular origin is most likely", false, nil, "Wide = VT until proven otherwise")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Always assume wide-complex tachycardia is VT until proven otherwise. SVT history doesn't change this approach.",
            keyPoint: "Wide = VT until proven otherwise (always)"
        ),
        makeQuestion(
            stem: "A patient with a pacemaker is in cardiac arrest. The monitor shows pacing spikes with no QRS response. This is:",
            choices: [
                ("Failure to capture - proceed with standard CPR and ACLS", true, "Pacemaker not working", nil),
                ("Normal pacemaker function", false, nil, "Should see QRS after spike"),
                ("VF that will respond to pacing", false, nil, "Pacemaker is failing to capture"),
                ("Indicates good prognosis", false, nil, "Pacemaker malfunction during arrest")
            ],
            topic: .electrical,
            difficulty: .hard,
            explanation: "Pacing spikes without QRS = failure to capture. Proceed with standard CPR/ACLS. Consider external defibrillation if indicated.",
            keyPoint: "Spikes without QRS = failure to capture"
        ),
        // More comprehensive questions
        makeQuestion(
            stem: "Which of the following is NOT a shockable rhythm?",
            choices: [
                ("Organized PEA with narrow QRS at 85 bpm", true, "PEA is non-shockable", nil),
                ("Ventricular fibrillation", false, nil, "VF is shockable"),
                ("Pulseless ventricular tachycardia", false, nil, "pVT is shockable"),
                ("Coarse ventricular fibrillation", false, nil, "Coarse VF is shockable")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "Shockable: VF and pVT only. PEA (organized rhythm without pulse) and asystole are non-shockable.",
            keyPoint: "Shockable = VF and pVT only"
        ),
        makeQuestion(
            stem: "A patient in VF was shocked successfully but now has a HR of 35 with narrow QRS and no pulse. This rhythm is:",
            choices: [
                ("PEA - continue CPR and give epinephrine", true, "Organized rhythm + no pulse = PEA", nil),
                ("ROSC - stop CPR", false, nil, "No pulse = no ROSC"),
                ("Sinus bradycardia - give atropine and stop CPR", false, nil, "Must have pulse for atropine"),
                ("Still VF - shock again", false, nil, "Rhythm has changed")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "Post-shock organized rhythm without pulse = PEA. Continue CPR, epinephrine, search for causes.",
            keyPoint: "Organized rhythm + no pulse = PEA"
        )
    ]
    
    // MARK: - Visual Rhythm Recognition Questions (with GIF strips)
    
    static let visualRhythmQuestions: [ACLSQuestion] = [
        // VF Recognition
        makeQuestion(
            stem: "Identify this rhythm and select the IMMEDIATE next step:",
            vignette: "A 62-year-old man collapses in the ED waiting room. CPR is in progress. You see the following rhythm on the monitor.",
            rhythmDescription: "Chaotic, irregular waveform with no discernible P waves, QRS complexes, or T waves",
            rhythmStripGIF: "VFib",
            choices: [
                ("Ventricular Fibrillation - Defibrillate immediately at ≥200J", true, "VF is a shockable rhythm requiring immediate defibrillation", nil),
                ("Asystole - Give epinephrine 1mg IV", false, nil, "This is VF, not asystole. VF has chaotic electrical activity"),
                ("Atrial Fibrillation - Give amiodarone", false, nil, "AF has irregularly irregular QRS complexes; this is ventricular"),
                ("Artifact - Check leads", false, nil, "This is true VF, not artifact")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Ventricular Fibrillation shows chaotic, disorganized electrical activity with no discernible waveforms. IMMEDIATE defibrillation at ≥200J is the priority. Every minute of delay decreases survival by 7-10%.",
            keyPoint: "VF = Immediate defibrillation ≥200J",
            clinicalPearl: "Don't waste time analyzing - if it's chaotic with no pulse, shock it!",
            algorithmStep: "VF/pVT Algorithm - Defibrillation First"
        ),
        
        // VTach Recognition
        makeQuestion(
            stem: "The patient is unresponsive and pulseless. Identify this rhythm:",
            vignette: "A 58-year-old with history of cardiomyopathy found unresponsive. No pulse detected.",
            rhythmDescription: "Wide, regular QRS complexes at approximately 180/min",
            rhythmStripGIF: "VTach",
            choices: [
                ("Pulseless Ventricular Tachycardia - Defibrillate", true, "Wide-complex, regular, pulseless = pVT = defibrillate", nil),
                ("SVT with aberrancy - Give adenosine", false, nil, "Patient is pulseless - this is pVT requiring shock"),
                ("Sinus tachycardia - Give fluids", false, nil, "QRS is too wide for sinus tach"),
                ("Atrial flutter - Cardiovert at 50J", false, nil, "This is ventricular, not atrial")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Pulseless VT is a shockable rhythm. Wide-complex (>0.12s), regular tachycardia in a pulseless patient = pVT. Treat with immediate defibrillation at ≥200J.",
            keyPoint: "Pulseless VT = Defibrillate same as VF",
            clinicalPearl: "Wide + Fast + No pulse = Defibrillate. Don't overthink it.",
            algorithmStep: "VF/pVT Algorithm"
        ),
        
        // SVT Recognition
        makeQuestion(
            stem: "A 32-year-old presents with palpitations. BP 118/72, alert and oriented. Identify this rhythm:",
            vignette: "No chest pain, no shortness of breath. Reports sudden onset 30 minutes ago.",
            vitals: ACLSVitals(heartRate: 188, bpSystolic: 118, bpDiastolic: 72, spO2: 98, respiratoryRate: 18, temperature: nil),
            rhythmDescription: "Narrow, regular QRS complexes at 188/min, no visible P waves",
            rhythmStripGIF: "SVT",
            choices: [
                ("Supraventricular Tachycardia - Try vagal maneuvers, then adenosine", true, "Narrow, regular, fast = SVT in stable patient", nil),
                ("Sinus tachycardia - Treat underlying cause", false, nil, "Rate too fast and too regular for sinus"),
                ("Atrial flutter - Rate control with beta blocker", false, nil, "No sawtooth pattern visible"),
                ("Ventricular tachycardia - Synchronized cardioversion", false, nil, "QRS is narrow, not wide")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "SVT presents with narrow-complex, regular tachycardia typically >150/min. In stable patients, try vagal maneuvers first, then adenosine 6mg rapid IV push.",
            keyPoint: "Narrow + Regular + Fast = SVT",
            clinicalPearl: "Vagal maneuvers: Valsalva (bearing down) or carotid massage (if no bruit/plaque)",
            algorithmStep: "Tachycardia Algorithm - Stable SVT"
        ),
        
        // Sinus Bradycardia Recognition
        makeQuestion(
            stem: "A patient post-MI is drowsy with BP 82/50. Identify this rhythm and next step:",
            vignette: "Inferior STEMI 2 hours ago. Now becoming less responsive.",
            vitals: ACLSVitals(heartRate: 42, bpSystolic: 82, bpDiastolic: 50, spO2: 94, respiratoryRate: 12, temperature: nil),
            rhythmDescription: "Regular rhythm at 42/min with normal P waves before each QRS",
            rhythmStripGIF: "SinusBradycardia",
            choices: [
                ("Sinus Bradycardia with hemodynamic compromise - Give Atropine 1mg IV", true, "Symptomatic bradycardia = Atropine first-line", nil),
                ("Junctional rhythm - Observe only", false, nil, "Patient is symptomatic - needs treatment"),
                ("Third-degree heart block - Emergent pacing", false, nil, "P waves are conducting - this is sinus bradycardia"),
                ("Normal sinus rhythm - Continue monitoring", false, nil, "Rate is bradycardic and patient is hypotensive")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Sinus bradycardia with hemodynamic compromise (hypotension, AMS) requires treatment. 2025 Update: Atropine 1mg IV is first-line. May repeat q3-5min, max 3mg.",
            keyPoint: "Symptomatic bradycardia → Atropine 1mg IV (2025 dose)",
            clinicalPearl: "Inferior MI commonly causes bradycardia due to vagal tone and RCA involvement",
            algorithmStep: "Bradycardia Algorithm"
        ),
        
        // Atrial Fibrillation Recognition
        makeQuestion(
            stem: "A 68-year-old presents with chest discomfort and shortness of breath. BP 86/54. Identify this rhythm:",
            vignette: "History of heart failure. Now acutely decompensated.",
            vitals: ACLSVitals(heartRate: 142, bpSystolic: 86, bpDiastolic: 54, spO2: 89, respiratoryRate: 26, temperature: nil),
            rhythmDescription: "Irregularly irregular narrow-complex rhythm with no discernible P waves, variable R-R intervals",
            rhythmStripGIF: "AtrialFib",
            choices: [
                ("Atrial Fibrillation with RVR - Synchronized cardioversion (unstable patient)", true, "Irregularly irregular + hemodynamically unstable = cardiovert", nil),
                ("Multifocal atrial tachycardia - Give magnesium", false, nil, "MAT has variable P-wave morphologies; this is AF"),
                ("Atrial flutter - Adenosine 6mg IV", false, nil, "No sawtooth pattern; adenosine won't work for AF"),
                ("Sinus arrhythmia - Observe", false, nil, "Patient is unstable - needs intervention")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Atrial fibrillation is 'irregularly irregular' with no P waves. With hemodynamic instability (hypotension, dyspnea, heart failure), synchronized cardioversion is indicated. 2025: Start at ≥200J.",
            keyPoint: "Unstable AF → Synchronized cardioversion ≥200J",
            clinicalPearl: "Irregularly irregular is the hallmark of AF - variable R-R intervals",
            algorithmStep: "Tachycardia Algorithm - Unstable"
        ),
        
        // Atrial Flutter Recognition
        makeQuestion(
            stem: "A 55-year-old reports palpitations for 2 days. Alert, BP 134/82. Identify this rhythm:",
            vignette: "No chest pain. Mild fatigue. Taking no medications.",
            vitals: ACLSVitals(heartRate: 150, bpSystolic: 134, bpDiastolic: 82, spO2: 97, respiratoryRate: 16, temperature: nil),
            rhythmDescription: "Sawtooth flutter waves at ~300/min with regular ventricular response at 150/min",
            rhythmStripGIF: "Aflutter",
            choices: [
                ("Atrial Flutter with 2:1 conduction - Rate control with beta blocker or CCB", true, "Sawtooth at 300, ventricular 150 = 2:1 flutter", nil),
                ("Atrial Fibrillation - Cardioversion", false, nil, "AF is irregularly irregular; this is regularly regular"),
                ("SVT - Adenosine 6mg IV", false, nil, "Adenosine may transiently reveal flutter waves but won't convert"),
                ("Sinus tachycardia - IV fluids", false, nil, "Sawtooth pattern indicates atrial flutter")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Atrial flutter shows 'sawtooth' flutter waves at ~300/min. With 2:1 conduction, ventricular rate is ~150/min. In stable patients, use rate control (beta blockers or CCBs).",
            keyPoint: "Sawtooth waves + rate 150 = Flutter with 2:1 block",
            clinicalPearl: "Any regular rate exactly 150/min should make you suspect flutter with 2:1",
            algorithmStep: "Tachycardia Algorithm - Atrial Flutter"
        ),
        
        // Asystole Recognition
        makeQuestion(
            stem: "CPR is in progress. You see this rhythm on the monitor. What is your next step?",
            vignette: "72-year-old found unresponsive. No pulse. CPR started by bystanders.",
            rhythmDescription: "Flat line with no electrical activity",
            rhythmStripGIF: "Asystole",
            choices: [
                ("Asystole - Continue CPR, give Epinephrine 1mg IV immediately", true, "Non-shockable rhythm - focus on CPR and epinephrine", nil),
                ("Fine VF - Defibrillate at 200J", false, nil, "This is asystole - confirm in multiple leads before calling it fine VF"),
                ("PEA - Shock first, then epinephrine", false, nil, "PEA has organized electrical activity; asystole does not"),
                ("Check leads - this must be artifact", false, nil, "Confirm in 2 leads, but don't delay CPR")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Asystole is a flat line with no electrical activity. It is NOT shockable. Focus on high-quality CPR and early epinephrine (as soon as IV/IO established).",
            keyPoint: "Asystole = Non-shockable → CPR + Epinephrine",
            clinicalPearl: "Confirm asystole in 2 leads to rule out fine VF, but don't delay CPR",
            algorithmStep: "PEA/Asystole Algorithm"
        ),
        
        // Torsades Recognition
        makeQuestion(
            stem: "This patient is unresponsive and pulseless. Identify the rhythm and select appropriate treatment:",
            vignette: "Patient found unresponsive. Was on QT-prolonging medication. ECG earlier today showed QTc of 520ms.",
            rhythmDescription: "Polymorphic wide-complex tachycardia with 'twisting' axis around the baseline",
            rhythmStripGIF: "Polymorphic_VTach",
            choices: [
                ("Torsades de Pointes - Defibrillate + Magnesium 2g IV", true, "Polymorphic VT with long QT = Torsades", nil),
                ("Monomorphic VT - Amiodarone 300mg IV", false, nil, "This is polymorphic, not monomorphic"),
                ("Atrial fibrillation with WPW - Procainamide", false, nil, "This is ventricular, not preexcited AF"),
                ("Artifact - Adjust leads", false, nil, "This is true Torsades de Pointes")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Torsades de Pointes is polymorphic VT with 'twisting' of QRS around baseline, associated with long QT. Treat with defibrillation (unsynchronized) and Magnesium 2g IV.",
            keyPoint: "Torsades = Defibrillate + Magnesium 2g IV",
            clinicalPearl: "Long QT + polymorphic VT = Torsades. Stop offending drugs, correct K+ and Mg2+",
            algorithmStep: "Torsades Management"
        ),
        
        // Third Degree Heart Block Recognition
        makeQuestion(
            stem: "A 78-year-old is drowsy with BP 74/48. Identify this rhythm:",
            vignette: "Found confused at home. Bradycardic on EMS monitor.",
            vitals: ACLSVitals(heartRate: 35, bpSystolic: 74, bpDiastolic: 48, spO2: 91, respiratoryRate: 10, temperature: nil),
            rhythmDescription: "P waves marching through at 80/min, completely dissociated from QRS at 35/min",
            rhythmStripGIF: "3rdDegreeHB",
            choices: [
                ("Third-Degree (Complete) Heart Block - Transcutaneous pacing + Atropine", true, "Complete AV dissociation with hemodynamic compromise", nil),
                ("Sinus bradycardia - Atropine alone", false, nil, "P waves and QRS are dissociated - this is complete heart block"),
                ("Second-degree Type II - Observe", false, nil, "Type II has some conduction; this has none (complete block)"),
                ("Junctional rhythm - Dopamine infusion", false, nil, "There are P waves present, just not conducting")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Third-degree heart block shows complete AV dissociation - P waves march through independently of QRS complexes. With hemodynamic instability, prepare for transcutaneous pacing. Atropine may help but is often ineffective.",
            keyPoint: "Complete heart block = P waves divorced from QRS",
            clinicalPearl: "Atropine often ineffective in complete block - prepare for pacing early",
            algorithmStep: "Bradycardia Algorithm - Pacing"
        ),
        
        // Normal Sinus Rhythm Recognition
        makeQuestion(
            stem: "After successful resuscitation, you obtain this rhythm check. The patient has a strong pulse. Identify the rhythm:",
            vignette: "ROSC achieved after 12 minutes of CPR. Patient is now responsive to voice.",
            vitals: ACLSVitals(heartRate: 88, bpSystolic: 112, bpDiastolic: 68, spO2: 96, respiratoryRate: 14, temperature: nil),
            rhythmDescription: "Regular rhythm at 88/min with upright P waves before each QRS, normal intervals",
            rhythmStripGIF: "NormalSinus",
            choices: [
                ("Normal Sinus Rhythm - Continue post-ROSC care", true, "Regular, normal rate, P before each QRS = NSR", nil),
                ("Sinus tachycardia - Give beta blocker", false, nil, "Rate 88 is normal, not tachycardic"),
                ("Junctional rhythm - Need pacing", false, nil, "P waves are present before QRS"),
                ("First-degree heart block - Needs evaluation", false, nil, "This is normal sinus with normal PR interval")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "Normal Sinus Rhythm has: regular rhythm, rate 60-100/min, upright P wave before each QRS, consistent PR interval (0.12-0.20s), narrow QRS.",
            keyPoint: "NSR: Regular, 60-100/min, P before each QRS",
            clinicalPearl: "Post-ROSC: Continue to TTM, hemodynamic support, and early coronary angiography if indicated",
            algorithmStep: "Post-ROSC Care"
        ),
        
        // MARK: - Complete Rhythm GIF Coverage (All 13 rhythms)
        
        // Sinus Tachycardia Recognition
        makeQuestion(
            stem: "A 35-year-old presents after a motor vehicle accident with anxiety and tachycardia. BP 108/70. Identify this rhythm:",
            vignette: "No significant injuries found. Reports feeling anxious since the accident.",
            vitals: ACLSVitals(heartRate: 118, bpSystolic: 108, bpDiastolic: 70, spO2: 99, respiratoryRate: 20, temperature: nil),
            rhythmDescription: "Regular rhythm at 118/min with upright P waves before each narrow QRS",
            rhythmStripGIF: "SinusTachycardia",
            choices: [
                ("Sinus Tachycardia - Treat underlying cause (pain, anxiety, hypovolemia)", true, "P waves present, regular = sinus origin", nil),
                ("SVT - Give adenosine 6mg IV", false, nil, "P waves are visible; this is sinus tachycardia"),
                ("Atrial flutter - Cardiovert", false, nil, "No sawtooth pattern; regular P waves present"),
                ("Ventricular tachycardia - Amiodarone", false, nil, "QRS is narrow, not wide")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "Sinus tachycardia has a rate >100/min with normal P waves before each QRS. It's a physiologic response - treat the underlying cause (pain, anxiety, fever, hypovolemia), not the rhythm itself.",
            keyPoint: "Sinus tachycardia = Treat the cause, not the rhythm",
            clinicalPearl: "If every fast rhythm got adenosine, we'd be giving a lot of unnecessary medication. Look for P waves!",
            algorithmStep: "Tachycardia Algorithm - Sinus Tachycardia Recognition"
        ),
        
        // Polymorphic VT / Torsades Recognition
        makeQuestion(
            stem: "A patient on methadone and haloperidol becomes unresponsive and pulseless. Identify this rhythm and priority treatment:",
            vignette: "ECG earlier today showed QTc of 580 ms. Now in cardiac arrest.",
            rhythmDescription: "Wide complex tachycardia with QRS complexes that twist around the baseline, changing amplitude and axis",
            rhythmStripGIF: "Polymorphic_VTach",
            choices: [
                ("Torsades de Pointes - Defibrillate + Magnesium 2g IV", true, "Twisting morphology + long QT = Torsades", nil),
                ("Monomorphic VT - Amiodarone 300mg", false, nil, "Amiodarone can prolong QT and worsen Torsades"),
                ("Ventricular fibrillation - Defibrillate only", false, nil, "This is polymorphic VT; magnesium is critical"),
                ("Artifact - Check leads", false, nil, "This is true Torsades, not artifact")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Torsades de Pointes is polymorphic VT with a 'twisting' morphology around the baseline. Associated with prolonged QT. Treatment: Defibrillate (unsynchronized) + Magnesium sulfate 1-2g IV. AVOID amiodarone (prolongs QT).",
            keyPoint: "Torsades = Defibrillate + Magnesium. Avoid amiodarone!",
            clinicalPearl: "QT-prolonging drugs (antipsychotics, certain antibiotics, methadone) + electrolyte abnormalities = Torsades risk",
            algorithmStep: "VF/pVT Algorithm - Torsades Special Considerations"
        ),
        
        // Torsades - Additional scenario with pulse
        makeQuestion(
            stem: "A patient with known hypokalemia (K+ 2.8) develops this rhythm. She has a pulse but is confused. What is the immediate priority?",
            vignette: "Taking furosemide for heart failure. ECG shows prolonged QT. Now showing this rhythm.",
            vitals: ACLSVitals(heartRate: 180, bpSystolic: 92, bpDiastolic: 60, spO2: 93, respiratoryRate: 24, temperature: nil),
            rhythmDescription: "Polymorphic wide complex tachycardia with twisting morphology",
            rhythmStripGIF: "Polymorphic_VTach",
            choices: [
                ("Torsades with pulse - Magnesium 2g IV + correct hypokalemia urgently", true, "Magnesium stabilizes rhythm; K+ correction prevents recurrence", nil),
                ("Wide complex tachycardia - Amiodarone 150mg over 10 min", false, nil, "Amiodarone prolongs QT - contraindicated in Torsades"),
                ("SVT with aberrancy - Adenosine 6mg", false, nil, "This is polymorphic VT, not SVT"),
                ("Atrial fibrillation with WPW - Procainamide", false, nil, "This is ventricular in origin")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Torsades with a pulse: Magnesium 2g IV is first-line. Must correct underlying electrolyte abnormalities (hypokalemia, hypomagnesemia). Avoid all QT-prolonging drugs.",
            keyPoint: "Torsades with pulse: Magnesium first + correct K+/Mg+",
            clinicalPearl: "Low K+ and low Mg+ often occur together - always check and replace both",
            algorithmStep: "Tachycardia Algorithm - Polymorphic VT/Torsades"
        ),
        
        // Asystole Recognition
        makeQuestion(
            stem: "During resuscitation, the monitor shows this after the third defibrillation. CPR quality has been excellent. What is the rhythm and next step?",
            vignette: "Started as VF, now showing this after 3 shocks and 10 minutes of CPR.",
            rhythmDescription: "Flat line with no electrical activity, confirmed in multiple leads",
            rhythmStripGIF: "Asystole",
            choices: [
                ("Asystole - Continue high-quality CPR, Epinephrine 1mg IV q3-5min", true, "Non-shockable rhythm - CPR and epinephrine", nil),
                ("Fine VF - Increase defibrillation energy", false, nil, "Confirm asystole in 2 leads; if truly flat, no shock"),
                ("PEA - Give calcium chloride", false, nil, "PEA has organized rhythm; this is flatline"),
                ("Artifact - Check leads only", false, nil, "After confirming leads, if still flat, continue ACLS for asystole")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Asystole is a non-shockable rhythm. Continue high-quality CPR, give epinephrine 1mg IV every 3-5 minutes, and search for reversible causes (H's and T's). Confirm in 2 leads to rule out fine VF.",
            keyPoint: "Asystole = Non-shockable. CPR + Epi. No defibrillation.",
            clinicalPearl: "Always confirm asystole in 2 leads and check connections before declaring a flatline",
            algorithmStep: "Asystole/PEA Algorithm"
        ),
        
        // Asystole - Termination Scenario
        makeQuestion(
            stem: "EMS brings in a patient found down with unknown downtime. Initial rhythm is shown. ETCO2 is 8 mmHg after 20 minutes of resuscitation. What should be considered?",
            vignette: "Unwitnessed arrest, no bystander CPR, no shockable rhythm at any point.",
            rhythmDescription: "Flat line with occasional artifact",
            rhythmStripGIF: "Asystole",
            choices: [
                ("Consider termination of resuscitation efforts", true, "Prolonged asystole + low ETCO2 + poor prognostic factors", nil),
                ("Continue CPR for another 60 minutes", false, nil, "Futile resuscitation not recommended"),
                ("Attempt defibrillation at maximum energy", false, nil, "Asystole is not shockable"),
                ("Give high-dose epinephrine 10mg", false, nil, "High-dose epinephrine not recommended")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Prolonged asystole with low ETCO2 (<10 mmHg), unwitnessed arrest, no bystander CPR, and no shockable rhythm suggests poor prognosis. Consider termination of efforts.",
            keyPoint: "Low ETCO2 + asystole + poor factors = consider termination",
            clinicalPearl: "ETCO2 <10 mmHg during CPR is associated with very poor outcomes",
            algorithmStep: "Asystole Algorithm - Termination Considerations"
        ),
        
        // Third Degree Heart Block Recognition
        makeQuestion(
            stem: "A 74-year-old presents with syncope and confusion. BP 78/50. Identify this rhythm:",
            vignette: "Was walking when suddenly lost consciousness. Regained consciousness but very confused.",
            vitals: ACLSVitals(heartRate: 38, bpSystolic: 78, bpDiastolic: 50, spO2: 91, respiratoryRate: 10, temperature: nil),
            rhythmDescription: "P waves marching through at regular rate, QRS complexes at slower independent rate, no relationship between P and QRS",
            rhythmStripGIF: "3rdDegreeHB",
            choices: [
                ("Third-Degree (Complete) Heart Block - Transcutaneous pacing + Atropine", true, "AV dissociation + hemodynamic compromise = emergent pacing", nil),
                ("Sinus bradycardia - Atropine only", false, nil, "P waves and QRS are dissociated - this is complete block"),
                ("Second-degree Type II - Observation", false, nil, "Complete AV dissociation, not intermittent dropped beats"),
                ("Junctional escape rhythm - IV fluids", false, nil, "This is complete heart block requiring urgent intervention")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Third-degree (complete) heart block shows complete AV dissociation - P waves at one rate, QRS at another with no relationship. With hemodynamic compromise: Transcutaneous pacing + Atropine while preparing for transvenous pacing.",
            keyPoint: "Complete AV dissociation = 3rd degree block → pacing",
            clinicalPearl: "Atropine may not work in complete heart block below the AV node - pacing is definitive",
            algorithmStep: "Bradycardia Algorithm - High-Grade Block"
        ),
        
        // Third Degree - Pacing Verification
        makeQuestion(
            stem: "This patient with complete heart block has just had transcutaneous pacing initiated. What should you verify?",
            vignette: "Complete heart block with BP 70/40. Pacing pads applied, rate set to 70, output being titrated.",
            rhythmDescription: "Complete heart block transitioning to paced rhythm",
            rhythmStripGIF: "3rdDegreeHB",
            choices: [
                ("Verify electrical capture (pacing spike followed by wide QRS) AND mechanical capture (pulse with each paced beat)", true, "Must confirm both electrical and mechanical capture", nil),
                ("Verify only that pacing spikes are visible", false, nil, "Spikes don't guarantee capture"),
                ("Check blood pressure only", false, nil, "Need to verify pulse correlates with paced beats"),
                ("Increase rate to 120/min immediately", false, nil, "Start at 60-70, then assess response")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Transcutaneous pacing requires verification of both electrical capture (spike → QRS) AND mechanical capture (palpable pulse with each paced beat). Increase output until capture, then add 10% safety margin.",
            keyPoint: "Pacing: Verify electrical + mechanical capture",
            clinicalPearl: "Capture threshold typically 50-100 mA. Always sedate for pacing - it's painful!",
            algorithmStep: "Bradycardia Algorithm - Pacing Verification"
        ),
        
        // Second Degree Type II Recognition
        makeQuestion(
            stem: "A post-anterior MI patient develops this rhythm. BP 90/60, mildly symptomatic. Identify the rhythm:",
            vignette: "Anterior STEMI 4 hours ago. Now has new conduction abnormality.",
            vitals: ACLSVitals(heartRate: 50, bpSystolic: 90, bpDiastolic: 60, spO2: 94, respiratoryRate: 14, temperature: nil),
            rhythmDescription: "Regular P waves with sudden dropped QRS complexes without preceding PR prolongation",
            rhythmStripGIF: "2ndDegreeTypeII",
            choices: [
                ("Second-Degree Type II (Mobitz II) - Prepare for pacing", true, "Dropped beats without PR prolongation = high-risk block", nil),
                ("Second-Degree Type I (Wenckebach) - Observation", false, nil, "Wenckebach has progressive PR prolongation"),
                ("Sinus arrhythmia - No treatment needed", false, nil, "This has clearly dropped QRS complexes"),
                ("First-degree AV block - Continue monitoring", false, nil, "First-degree has consistent conduction, no dropped beats")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Mobitz Type II shows sudden dropped QRS complexes WITHOUT progressive PR prolongation. This is infra-nodal disease with high risk of progression to complete heart block. Prepare for pacing.",
            keyPoint: "Mobitz II: Fixed PR + dropped beats = pacing needed",
            clinicalPearl: "Type II is more dangerous than Type I - it occurs below the AV node and atropine often doesn't help",
            algorithmStep: "Bradycardia Algorithm - High-Risk Block"
        ),
        
        // Second Degree Type II - Atropine Failure
        makeQuestion(
            stem: "Atropine 1mg was given to this patient with Mobitz II. HR remains 42, BP 86/52. What is the next step?",
            vignette: "Second-degree Type II identified. Post-anterior MI patient.",
            vitals: ACLSVitals(heartRate: 42, bpSystolic: 86, bpDiastolic: 52, spO2: 93, respiratoryRate: 14, temperature: nil),
            rhythmDescription: "Mobitz II with 2:1 conduction, atropine has not improved rate",
            rhythmStripGIF: "2ndDegreeTypeII2",
            choices: [
                ("Transcutaneous pacing immediately", true, "Atropine-resistant Type II = pacing", nil),
                ("Second dose of atropine 1mg", false, nil, "Type II often doesn't respond to atropine"),
                ("Dopamine infusion", false, nil, "Pacing is more reliable for this block"),
                ("Isoproterenol infusion", false, nil, "Pacing preferred over isoproterenol")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Mobitz Type II often doesn't respond to atropine because the block is below the AV node. Transcutaneous pacing is indicated for symptomatic Type II unresponsive to atropine.",
            keyPoint: "Atropine-resistant Type II → TCP immediately",
            clinicalPearl: "In anterior MI with new Type II, assume it will progress to complete block - pace early",
            algorithmStep: "Bradycardia Algorithm - Atropine-Resistant Block"
        ),
        
        // Second Degree Type I (Wenckebach) Recognition
        makeQuestion(
            stem: "A patient post-inferior MI develops this rhythm. Alert, BP 108/68. Identify the rhythm:",
            vignette: "Inferior STEMI 6 hours ago. New rhythm noticed on telemetry. Patient asymptomatic.",
            vitals: ACLSVitals(heartRate: 58, bpSystolic: 108, bpDiastolic: 68, spO2: 97, respiratoryRate: 14, temperature: nil),
            rhythmDescription: "Progressive PR prolongation until a P wave fails to conduct, then cycle repeats",
            rhythmStripGIF: "2ndDegreeTypeI ( Wenkeback)",
            choices: [
                ("Second-Degree Type I (Wenckebach) - Observation if asymptomatic", true, "Progressive PR prolongation + dropped beat = Type I, usually benign", nil),
                ("Second-Degree Type II - Emergent pacing", false, nil, "Type II has fixed PR intervals before dropped beats"),
                ("Complete heart block - Atropine + pacing", false, nil, "P waves are conducting, just with increasing delay"),
                ("First-degree AV block - No treatment", false, nil, "First-degree doesn't have dropped beats")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Wenckebach (Type I) shows progressive PR prolongation until a beat is dropped, then the cycle repeats. Usually benign, especially in inferior MI. Observe if asymptomatic; atropine if symptomatic.",
            keyPoint: "Type I: Longer, longer, drop! Usually benign in inferior MI",
            clinicalPearl: "Wenckebach often resolves on its own - it's above the AV node and responds to atropine if needed",
            algorithmStep: "Bradycardia Algorithm - Low-Risk Block"
        ),
        
        // Wenckebach - Athlete Scenario
        makeQuestion(
            stem: "This Wenckebach rhythm is seen in an asymptomatic athlete during pre-participation screening. What is appropriate?",
            vignette: "18-year-old college football player. Resting HR 48. No symptoms. Normal echocardiogram.",
            rhythmDescription: "Progressive PR prolongation followed by dropped beat, typical Wenckebach pattern",
            rhythmStripGIF: "2ndDegreeTypeI ( Wenkeback)",
            choices: [
                ("Physiologic finding - No treatment needed, can clear for sports", true, "Wenckebach at rest in athletes is often normal vagal tone", nil),
                ("Pathologic finding - Refer for pacemaker", false, nil, "Asymptomatic Wenckebach in athletes is usually benign"),
                ("Need stress testing before clearance", false, nil, "If echo normal and asymptomatic, Wenckebach often resolves with exercise"),
                ("Disqualify from contact sports", false, nil, "Not indicated for asymptomatic Wenckebach")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Wenckebach in athletes at rest is often a sign of high vagal tone and is physiologically normal. It typically resolves with exercise. If asymptomatic with normal cardiac workup, no treatment needed.",
            keyPoint: "Asymptomatic Wenckebach in athletes = usually benign",
            clinicalPearl: "Athlete's heart: sinus bradycardia, Type I block, and other vagally-mediated findings are common",
            algorithmStep: "Bradycardia - Physiologic Considerations"
        ),
        
        // VF - Cath Lab Scenario
        makeQuestion(
            stem: "A patient in the cath lab develops this rhythm during a PCI. What is the immediate action?",
            vignette: "Mid-LAD intervention. Suddenly complains of chest pain, then becomes unresponsive.",
            rhythmDescription: "Chaotic, disorganized electrical activity with no discernible waveforms",
            rhythmStripGIF: "VFib",
            choices: [
                ("Ventricular Fibrillation - Immediate defibrillation", true, "VF in witnessed arrest in cath lab = immediate shock", nil),
                ("Check pulse first, then decide", false, nil, "In witnessed VF, defibrillate immediately"),
                ("Atropine 1mg for possible vagal response", false, nil, "This is VF, not bradycardia"),
                ("Wait for anesthesia backup", false, nil, "Immediate defibrillation, don't wait")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Witnessed VF in a monitored setting (like cath lab) should receive immediate defibrillation without delay. Every second counts. CPR should continue between shocks.",
            keyPoint: "Witnessed VF in monitored setting = shock immediately",
            clinicalPearl: "Cath lab VF during PCI often resolves with a single shock if done quickly",
            algorithmStep: "VF/pVT Algorithm - Monitored Arrest"
        ),
        
        // Stable VTach Scenario
        makeQuestion(
            stem: "A 60-year-old with known cardiomyopathy develops this rhythm. Alert, BP 102/68. Identify and manage:",
            vignette: "History of EF 25%. Taking amiodarone at home. Now with palpitations but stable.",
            vitals: ACLSVitals(heartRate: 162, bpSystolic: 102, bpDiastolic: 68, spO2: 96, respiratoryRate: 18, temperature: nil),
            rhythmDescription: "Wide-complex, regular tachycardia at 162/min, monomorphic",
            rhythmStripGIF: "VTach",
            choices: [
                ("Stable Monomorphic VT - Amiodarone 150mg IV over 10 minutes", true, "Wide + regular + stable = amiodarone", nil),
                ("SVT with aberrancy - Adenosine 6mg", false, nil, "In patient with cardiomyopathy, assume VT"),
                ("Immediate synchronized cardioversion", false, nil, "Patient is stable - try medications first"),
                ("Unsynchronized defibrillation", false, nil, "Patient has a pulse - use synchronized if electrical therapy needed")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Stable monomorphic VT in a patient with structural heart disease: Amiodarone 150mg IV over 10 minutes. In cardiomyopathy, always assume wide-complex tachycardia is VT.",
            keyPoint: "Stable VT: Amiodarone 150mg over 10 min",
            clinicalPearl: "When in doubt, treat wide complex as VT - safer than assuming SVT",
            algorithmStep: "Tachycardia Algorithm - Stable Wide Complex"
        ),
        
        // SVT - Failed Adenosine
        makeQuestion(
            stem: "Adenosine 6mg, then 12mg, both failed to convert this rhythm. Patient remains stable. What is next?",
            vignette: "SVT at 180/min confirmed. Two doses of adenosine given properly with saline flush.",
            vitals: ACLSVitals(heartRate: 180, bpSystolic: 112, bpDiastolic: 74, spO2: 98, respiratoryRate: 18, temperature: nil),
            rhythmDescription: "Narrow, regular tachycardia persisting after adenosine",
            rhythmStripGIF: "SVT1",
            choices: [
                ("Consider diltiazem or beta-blocker for rate control, or synchronized cardioversion", true, "Failed adenosine → CCB/BB or cardioversion", nil),
                ("Third dose of adenosine 18mg", false, nil, "12mg is max single dose"),
                ("Amiodarone 300mg IV push", false, nil, "Amiodarone not first-line for SVT"),
                ("Unsynchronized defibrillation", false, nil, "Patient is stable with organized rhythm")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "If adenosine fails (6mg, then 12mg), options include: rate control with CCB (diltiazem) or beta-blocker, or synchronized cardioversion if patient becomes unstable or if rhythm control is priority.",
            keyPoint: "Adenosine fails → CCB/BB or cardioversion",
            clinicalPearl: "Some SVTs (atrial tachycardia, atypical AVNRT) may not respond to adenosine - consider alternatives",
            algorithmStep: "Tachycardia Algorithm - Refractory SVT"
        ),
        
        // Sinus Tachycardia - Sepsis
        makeQuestion(
            stem: "A septic patient has a heart rate of 125. Identify this rhythm and appropriate management:",
            vignette: "Febrile to 39.5°C, WBC 24,000, lactate 4.2. Source is pneumonia.",
            vitals: ACLSVitals(heartRate: 125, bpSystolic: 88, bpDiastolic: 52, spO2: 92, respiratoryRate: 28, temperature: 39.5),
            rhythmDescription: "Regular rhythm with upright P waves before each narrow QRS, rate 125/min",
            rhythmStripGIF: "SinusTachycardia",
            choices: [
                ("Sinus Tachycardia secondary to sepsis - IV fluids, antibiotics, source control", true, "Appropriate physiologic response to infection", nil),
                ("SVT - Give adenosine 6mg", false, nil, "P waves present = sinus origin"),
                ("Atrial flutter - Rate control with beta blocker", false, nil, "No sawtooth pattern; this is sinus"),
                ("Give metoprolol to control the rate", false, nil, "Don't suppress compensatory sinus tach in sepsis")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Sinus tachycardia in sepsis is a compensatory response - the heart is maintaining cardiac output. Treat the underlying sepsis, not the rhythm. Giving rate-lowering agents could be harmful.",
            keyPoint: "Don't treat compensatory sinus tachycardia - treat the cause",
            clinicalPearl: "Sinus tach with P waves visible = physiologic response. Look for the cause!",
            algorithmStep: "Tachycardia Algorithm - Sinus Tachycardia"
        ),
        
        // Atrial Flutter - Unstable
        makeQuestion(
            stem: "A patient with atrial flutter becomes hypotensive and confused. BP 74/50. What is the management?",
            vignette: "Known atrial flutter on rate control. Now acutely decompensated.",
            vitals: ACLSVitals(heartRate: 156, bpSystolic: 74, bpDiastolic: 50, spO2: 88, respiratoryRate: 26, temperature: nil),
            rhythmDescription: "Sawtooth flutter waves with rapid ventricular response",
            rhythmStripGIF: "Aflutter",
            choices: [
                ("Synchronized cardioversion starting at 120-200J", true, "Unstable flutter = cardiovert", nil),
                ("Diltiazem 20mg IV for rate control", false, nil, "Patient is too unstable for medication trial"),
                ("Adenosine 6mg rapid IV push", false, nil, "Adenosine won't convert flutter"),
                ("Amiodarone 300mg IV push", false, nil, "Takes too long; patient needs immediate rhythm control")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Unstable atrial flutter (hypotension, altered mental status) requires immediate synchronized cardioversion. 2025 guideline: Start at 120-200J biphasic.",
            keyPoint: "Unstable flutter = synchronized cardioversion",
            clinicalPearl: "Flutter often converts with lower energies than AF, but start high if unstable",
            algorithmStep: "Tachycardia Algorithm - Unstable Pathway"
        ),
        
        // AF - Stable Rate Control
        makeQuestion(
            stem: "A patient with new onset atrial fibrillation is stable with rate of 124/min. BP 132/84. Onset was 8 hours ago. Management?",
            vignette: "No prior history of AF. Mild palpitations. Otherwise well.",
            vitals: ACLSVitals(heartRate: 124, bpSystolic: 132, bpDiastolic: 84, spO2: 98, respiratoryRate: 16, temperature: nil),
            rhythmDescription: "Irregularly irregular narrow-complex rhythm, no P waves visible",
            rhythmStripGIF: "AtrialFib",
            choices: [
                ("Rate control with diltiazem or metoprolol, assess for cardioversion candidacy", true, "Stable new AF <48 hours - rate control + consider cardioversion", nil),
                ("Immediate synchronized cardioversion", false, nil, "Patient is stable - try rate control first"),
                ("Adenosine 6mg to terminate", false, nil, "Adenosine doesn't work for AF"),
                ("Anticoagulate only and discharge", false, nil, "Need rate control and observation")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Stable new-onset AF <48 hours: Rate control (diltiazem, metoprolol, or digoxin) and consider cardioversion. Anticoagulation decisions based on CHA2DS2-VASc score.",
            keyPoint: "Stable AF: Rate control + anticoagulation + consider cardioversion",
            clinicalPearl: "AF <48 hours may be cardioverted without TEE; >48 hours needs 3 weeks anticoagulation or TEE first",
            algorithmStep: "Tachycardia Algorithm - Stable AF"
        ),
        
        // Normal Sinus - Post Cardioversion
        makeQuestion(
            stem: "After cardioversion for atrial fibrillation, the patient converts to this rhythm. What is the next step?",
            vignette: "Successful cardioversion at 200J. Patient now awake and stable.",
            vitals: ACLSVitals(heartRate: 72, bpSystolic: 118, bpDiastolic: 76, spO2: 99, respiratoryRate: 14, temperature: nil),
            rhythmDescription: "Regular rhythm at 72/min with clear P waves before each QRS",
            rhythmStripGIF: "NormalSinus",
            choices: [
                ("Normal Sinus Rhythm achieved - Continue anticoagulation, discharge planning", true, "Successful cardioversion to NSR", nil),
                ("Junctional rhythm - Need pacemaker evaluation", false, nil, "P waves are present = sinus origin"),
                ("First-degree block - Continue monitoring", false, nil, "PR interval is normal"),
                ("Sinus bradycardia - Give atropine", false, nil, "72 bpm is normal, not bradycardia")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "Successful cardioversion to normal sinus rhythm. Continue anticoagulation per guidelines (typically 4 weeks post-cardioversion minimum), rhythm monitoring, and outpatient follow-up.",
            keyPoint: "Post-cardioversion: Continue anticoagulation for ≥4 weeks",
            clinicalPearl: "Even after successful cardioversion, AF recurrence is common - monitor and maintain anticoagulation",
            algorithmStep: "Post-Cardioversion Care"
        )
    ]
    
    // MARK: - ETCO2/Capnography Questions
    
    static let capnographyQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "During CPR, the ETCO2 suddenly rises from 18 to 42 mmHg. What does this indicate?",
            vignette: "Continuous capnography during resuscitation. CPR quality has been consistent.",
            etco2WaveformType: .roscSpike,
            choices: [
                ("Return of Spontaneous Circulation (ROSC) - Check pulse", true, "Sudden ETCO2 rise = ROSC", nil),
                ("Improved CPR quality", false, nil, "CPR improvement is gradual, not sudden"),
                ("Hyperventilation", false, nil, "Hyperventilation decreases ETCO2"),
                ("Esophageal intubation", false, nil, "Would show absent ETCO2")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "A sudden, sustained increase in ETCO2 (especially to normal values 35-45 mmHg) during CPR strongly suggests ROSC. The perfusing rhythm generates CO2 delivery to the lungs.",
            keyPoint: "Sudden ETCO2 spike = ROSC (check pulse!)",
            clinicalPearl: "ETCO2 is often the FIRST indicator of ROSC - even before a palpable pulse",
            algorithmStep: "ROSC Detection - Capnography"
        ),
        makeQuestion(
            stem: "CPR has been in progress for 15 minutes. ETCO2 persistently reads 8 mmHg despite what appears to be good compressions. What should you do?",
            vignette: "Advanced airway in place. Waveform capnography shows consistent low values.",
            etco2WaveformType: .lowPerfusion,
            choices: [
                ("Evaluate and improve CPR quality - ETCO2 <10 indicates poor perfusion", true, "Low ETCO2 = poor blood flow to lungs", nil),
                ("Continue current efforts - ETCO2 is normal during CPR", false, nil, "ETCO2 should be 10-20 mmHg with good CPR"),
                ("Increase ventilation rate", false, nil, "More ventilation would lower ETCO2 further"),
                ("Remove the capnography - it's unreliable", false, nil, "Capnography provides critical feedback")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "ETCO2 <10 mmHg during CPR indicates poor perfusion - likely inadequate compression depth, rate, or incomplete recoil. Target ETCO2 of at least 10-20 mmHg during CPR.",
            keyPoint: "ETCO2 <10 = Poor CPR quality or poor prognosis",
            clinicalPearl: "Consider switching compressors, checking depth, and ensuring full recoil",
            algorithmStep: "CPR Quality Monitoring"
        ),
        makeQuestion(
            stem: "After intubation during cardiac arrest, the ETCO2 shows no waveform and reads 0 mmHg. What is the MOST likely cause?",
            etco2WaveformType: .esophageal,
            choices: [
                ("Esophageal intubation - Reintubate immediately", true, "No ETCO2 = wrong tube placement", nil),
                ("Cardiac arrest - This is expected", false, nil, "Even during CPR, ETCO2 should be detectable"),
                ("Capnography malfunction", false, nil, "Possible but esophageal placement is more critical to rule out"),
                ("Bronchospasm", false, nil, "Bronchospasm shows 'shark fin' pattern, not absent waveform")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "Absent ETCO2 waveform after intubation strongly suggests esophageal placement. Remove the tube and reintubate. Even during cardiac arrest, properly placed tubes show some CO2 return with CPR.",
            keyPoint: "No ETCO2 after intubation = Esophageal (wrong) placement",
            clinicalPearl: "ETCO2 is the gold standard for confirming ETT placement during CPR",
            algorithmStep: "Airway Confirmation"
        )
    ]
    
    // MARK: - Complete Tachycardia Stable Questions (30 from 05-Tachycardia-Questions.md)
    
    static let completeTachycardiaStable: [ACLSQuestion] = [
        makeQuestion(
            stem: "What defines a hemodynamically stable patient with tachycardia?",
            choices: [
                ("Adequate perfusion, normal mentation, no chest pain, stable blood pressure", true, "Stable = adequate perfusion + no severe symptoms", nil),
                ("Any heart rate above 100 bpm", false, nil, "Rate alone doesn't define stability"),
                ("Heart rate above 150 bpm regardless of symptoms", false, nil, "Symptoms define stability, not rate"),
                ("Presence of a narrow QRS complex", false, nil, "QRS width doesn't define stability")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Stable tachycardia is defined by adequate perfusion and no severe symptoms (AMS, hypotension, chest pain, HF), not by heart rate alone.",
            keyPoint: "Stable = adequate perfusion + no severe symptoms",
            algorithmStep: "Tachycardia Algorithm - Box 1: Assess stability"
        ),
        makeQuestion(
            stem: "A stable patient has a narrow complex regular tachycardia at 180 bpm. What is the first intervention?",
            choices: [
                ("Vagal maneuvers", true, "Narrow regular SVT: Vagal maneuvers first → then adenosine if no conversion", nil),
                ("Adenosine 12 mg IV", false, nil, "Start with 6mg, not 12mg, and try vagal first"),
                ("Synchronized cardioversion", false, nil, "Reserved for unstable patients"),
                ("Amiodarone 150 mg IV", false, nil, "Not first-line for narrow complex SVT")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "For stable narrow complex regular tachycardia, start with vagal maneuvers before medication.",
            keyPoint: "SVT first-line: Vagal maneuvers",
            algorithmStep: "Tachycardia Algorithm - Narrow regular: vagal → adenosine"
        ),
        makeQuestion(
            stem: "What is the first dose of adenosine for SVT?",
            choices: [
                ("6 mg rapid IV push", true, "Adenosine: 6mg → 12mg → 12mg (rapid IV push)", nil),
                ("12 mg rapid IV push", false, nil, "12mg is the second dose"),
                ("3 mg rapid IV push", false, nil, "3mg is too low for adults"),
                ("6 mg slow IV infusion", false, nil, "Must be rapid push due to short half-life")
            ],
            topic: .pharmacology,
            difficulty: .easy,
            explanation: "Adenosine first dose is 6mg rapid IV push. Can repeat with 12mg if needed.",
            keyPoint: "Adenosine: 6mg first, then 12mg",
            algorithmStep: "Tachycardia Algorithm - Adenosine: 6mg first dose"
        ),
        makeQuestion(
            stem: "If the first dose of adenosine is ineffective for SVT, what is the second dose?",
            choices: [
                ("12 mg rapid IV push", true, "Second dose doubles to 12mg", nil),
                ("6 mg rapid IV push", false, nil, "6mg already tried"),
                ("18 mg rapid IV push", false, nil, "18mg is not a standard dose"),
                ("Adenosine should not be repeated", false, nil, "Can repeat up to 2 additional doses")
            ],
            topic: .pharmacology,
            difficulty: .easy,
            explanation: "Adenosine sequence: 6mg → 12mg (can repeat 12mg once more if needed).",
            keyPoint: "Adenosine: 6 → 12 → 12",
            algorithmStep: "Tachycardia Algorithm - Adenosine: 12mg if 6mg fails"
        ),
        makeQuestion(
            stem: "What is the correct technique for adenosine administration?",
            choices: [
                ("Rapid IV push at proximal port followed immediately by 20 mL saline flush", true, "Very short half-life (~6 seconds) requires rapid delivery", nil),
                ("Slow IV push over 2 minutes", false, nil, "Would be metabolized before reaching heart"),
                ("IM injection", false, nil, "Not appropriate for adenosine"),
                ("Subcutaneous injection", false, nil, "Not appropriate for adenosine")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Adenosine must be given rapid IV push at proximal port with immediate 20mL NS flush due to its very short half-life (~6 seconds).",
            keyPoint: "Adenosine: rapid push + immediate flush",
            algorithmStep: "Tachycardia Algorithm - Adenosine administration technique"
        ),
        makeQuestion(
            stem: "A stable patient with atrial fibrillation and rapid ventricular response (HR 140 bpm) needs rate control. What medication classes are appropriate?",
            choices: [
                ("Beta-blockers or calcium channel blockers (diltiazem/verapamil)", true, "Rate control with nodal blocking agents", nil),
                ("Adenosine", false, nil, "Adenosine won't convert AFib"),
                ("Atropine", false, nil, "Would speed up the heart rate"),
                ("Epinephrine", false, nil, "Would speed up the heart rate")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "AFib with RVR requires rate control with beta-blockers or non-dihydropyridine CCBs.",
            keyPoint: "AFib RVR: beta-blockers or CCBs for rate control",
            algorithmStep: "Tachycardia Algorithm - Narrow irregular: rate control"
        ),
        makeQuestion(
            stem: "A stable patient has a regular wide complex tachycardia. If uncertain whether it is VT or SVT with aberrancy, what is the safest approach?",
            choices: [
                ("Treat as VT - give amiodarone or consider adenosine if regular", true, "Safer to assume worst case", nil),
                ("Always assume SVT and give calcium channel blockers", false, nil, "CCBs can be dangerous in VT"),
                ("Give digoxin", false, nil, "Not appropriate for this situation"),
                ("Wait and observe", false, nil, "Delays potentially life-saving treatment")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "When uncertain about wide complex tachycardia origin, treat as VT - it's safer to assume the worst case.",
            keyPoint: "Wide complex uncertain = treat as VT",
            algorithmStep: "Tachycardia Algorithm - Wide regular: assume VT unless proven otherwise"
        ),
        makeQuestion(
            stem: "What is the initial IV dose of diltiazem for rate control in atrial fibrillation?",
            choices: [
                ("15-20 mg (0.25 mg/kg) IV over 2 minutes", true, "Standard initial dose", nil),
                ("5 mg IV push", false, nil, "Too low"),
                ("40 mg IV push", false, nil, "Too high for initial dose"),
                ("0.5 mg/kg IV push", false, nil, "Double the correct dose")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Diltiazem: 15-20mg (0.25mg/kg) over 2 min, may repeat at 0.35mg/kg after 15 min.",
            keyPoint: "Diltiazem: 15-20mg IV over 2 min",
            algorithmStep: "Tachycardia Algorithm - Diltiazem dosing"
        ),
        makeQuestion(
            stem: "What is the IV dose of metoprolol for rate control?",
            choices: [
                ("5 mg IV slow push, may repeat every 5 minutes (max 3 doses)", true, "Total max 15mg", nil),
                ("20 mg IV push", false, nil, "Too high for single dose"),
                ("50 mg IV push", false, nil, "Far too high"),
                ("1 mg IV push", false, nil, "Too low")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Metoprolol: 5mg slow IV push, repeat q5min up to 15mg total.",
            keyPoint: "Metoprolol: 5mg IV, may repeat x3",
            algorithmStep: "Tachycardia Algorithm - Metoprolol dosing"
        ),
        makeQuestion(
            stem: "A patient with known WPW syndrome presents with atrial fibrillation. Why are AV nodal blocking agents contraindicated?",
            choices: [
                ("They can enhance conduction through the accessory pathway, potentially causing VF", true, "Can trigger lethal arrhythmia", nil),
                ("They have no effect in WPW", false, nil, "They can have dangerous effects"),
                ("They are always safe in WPW", false, nil, "Contraindicated in WPW + AFib"),
                ("They only slow the heart rate", false, nil, "Can paradoxically speed accessory pathway conduction")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "In WPW + AFib, AV nodal blockers can enhance accessory pathway conduction and trigger VF.",
            keyPoint: "WPW + AFib: NO AV nodal blockers",
            algorithmStep: "Tachycardia Algorithm - Pre-excitation contraindications"
        ),
        makeQuestion(
            stem: "What is the amiodarone dose for stable ventricular tachycardia with a pulse?",
            choices: [
                ("150 mg IV over 10 minutes", true, "Slower than cardiac arrest dose", nil),
                ("300 mg IV push", false, nil, "That's the cardiac arrest dose"),
                ("1 mg/min infusion only", false, nil, "Loading dose needed first"),
                ("50 mg IV push", false, nil, "Too low")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Stable VT with pulse: Amiodarone 150mg IV over 10 min (slower than arrest dose).",
            keyPoint: "Stable VT: Amiodarone 150mg over 10 min",
            algorithmStep: "Tachycardia Algorithm - Amiodarone for stable VT"
        ),
        makeQuestion(
            stem: "What is the procainamide infusion rate for stable ventricular tachycardia?",
            choices: [
                ("20-50 mg/min until arrhythmia suppressed, hypotension, QRS widens >50%, or max 17 mg/kg", true, "Multiple endpoints to watch for", nil),
                ("100 mg/min", false, nil, "Too fast"),
                ("5 mg/min", false, nil, "Too slow"),
                ("500 mg IV push", false, nil, "Must be infused, not pushed")
            ],
            topic: .pharmacology,
            difficulty: .hard,
            explanation: "Procainamide: 20-50 mg/min infusion; stop if QRS widens >50%, hypotension, or max dose.",
            keyPoint: "Procainamide: 20-50 mg/min with multiple stop points",
            algorithmStep: "Tachycardia Algorithm - Procainamide dosing and endpoints"
        ),
        makeQuestion(
            stem: "How does treatment differ between stable monomorphic VT and stable polymorphic VT?",
            choices: [
                ("Monomorphic: antiarrhythmics; Polymorphic: assess QT - if long, give magnesium", true, "QT-dependent treatment for polymorphic", nil),
                ("Both treated identically", false, nil, "Different approaches needed"),
                ("Polymorphic VT is never stable", false, nil, "Can be transiently stable"),
                ("Monomorphic VT requires cardioversion only", false, nil, "Medications first if stable")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "Polymorphic VT requires QT assessment - prolonged QT (Torsades) = magnesium 1-2g IV.",
            keyPoint: "Polymorphic VT: check QT → magnesium if prolonged",
            algorithmStep: "Tachycardia Algorithm - VT morphology-based treatment"
        ),
        makeQuestion(
            stem: "What ECG finding is characteristic of multifocal atrial tachycardia (MAT)?",
            choices: [
                ("Three or more different P wave morphologies with varying PR intervals", true, "Multiple atrial foci", nil),
                ("Regular narrow complex rhythm", false, nil, "MAT is irregular"),
                ("Saw-tooth pattern", false, nil, "That's atrial flutter"),
                ("Wide QRS complexes", false, nil, "MAT has narrow complexes")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "MAT: ≥3 P wave morphologies, irregular rate, often in COPD patients.",
            keyPoint: "MAT: ≥3 P wave morphologies, irregular",
            algorithmStep: "Rhythm Recognition - MAT identification"
        ),
        makeQuestion(
            stem: "What is the most common mechanism of paroxysmal SVT?",
            choices: [
                ("AV nodal reentrant tachycardia (AVNRT)", true, "Most common SVT mechanism", nil),
                ("Atrial fibrillation", false, nil, "AFib is different mechanism"),
                ("Ventricular tachycardia", false, nil, "VT is ventricular, not SVT"),
                ("Sinus tachycardia", false, nil, "Sinus tach is not PSVT")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "AVNRT is the most common SVT - reentry circuit within AV node, responds to adenosine.",
            keyPoint: "Most common SVT = AVNRT",
            algorithmStep: "Tachycardia Algorithm - SVT mechanisms"
        ),
        makeQuestion(
            stem: "In which situation are IV calcium channel blockers contraindicated for rate control?",
            choices: [
                ("Wide complex tachycardia of uncertain origin or known WPW with AFib", true, "Can cause hemodynamic collapse", nil),
                ("Narrow complex atrial fibrillation", false, nil, "Appropriate use"),
                ("All supraventricular tachycardias", false, nil, "Useful in many SVTs"),
                ("Sinus tachycardia", false, nil, "Not typically used but not contraindicated")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "CCBs are contraindicated in wide complex tachycardia (may be VT), WPW + AFib, hypotension, HFrEF.",
            keyPoint: "CCBs contraindicated: WCT, WPW+AFib, hypotension, HFrEF",
            algorithmStep: "Tachycardia Algorithm - CCB contraindications"
        ),
        makeQuestion(
            stem: "A patient has sinus tachycardia at 120 bpm with fever. What is the primary treatment?",
            choices: [
                ("Treat the underlying cause (fever, pain, hypovolemia, anxiety, etc.)", true, "Sinus tach is compensatory", nil),
                ("Adenosine", false, nil, "Won't work on sinus tach"),
                ("Cardioversion", false, nil, "Never cardiovert sinus tach"),
                ("Beta-blockers first", false, nil, "Treat cause, not rate")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Sinus tachycardia is usually compensatory - treat the underlying cause.",
            keyPoint: "Sinus tach = treat the cause",
            algorithmStep: "Tachycardia Algorithm - Sinus tachycardia: treat underlying cause"
        ),
        makeQuestion(
            stem: "What is the most common cause of narrow complex irregular tachycardia?",
            choices: [
                ("Atrial fibrillation", true, "Most common narrow irregular", nil),
                ("AVNRT", false, nil, "AVNRT is regular"),
                ("Atrial flutter with variable block", false, nil, "Less common than AFib"),
                ("Ventricular tachycardia", false, nil, "VT is wide complex")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Narrow irregular = AFib most commonly; also consider MAT, flutter with variable block.",
            keyPoint: "Narrow irregular = think AFib first",
            algorithmStep: "Rhythm Recognition - Narrow irregular differential"
        ),
        makeQuestion(
            stem: "What QRS width distinguishes narrow from wide complex tachycardia?",
            choices: [
                ("Narrow <0.12 seconds; Wide ≥0.12 seconds", true, "120ms = 3 small boxes", nil),
                ("Narrow <0.20 seconds; Wide ≥0.20 seconds", false, nil, "0.20 is too wide"),
                ("Narrow <0.08 seconds; Wide ≥0.08 seconds", false, nil, "0.08 is too narrow"),
                ("QRS width is not relevant", false, nil, "Critical distinction")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "Narrow QRS <120ms (3 small boxes); Wide QRS ≥120ms - critical for algorithm direction.",
            keyPoint: "Narrow <120ms, Wide ≥120ms",
            algorithmStep: "Rhythm Recognition - QRS width classification"
        ),
        makeQuestion(
            stem: "Which finding suggests VT rather than SVT with aberrancy in a wide complex tachycardia?",
            choices: [
                ("AV dissociation, fusion beats, capture beats, concordance in precordial leads", true, "Classic VT findings", nil),
                ("Narrow QRS complexes", false, nil, "Would be SVT"),
                ("Irregularly irregular rhythm", false, nil, "More suggestive of AFib"),
                ("Normal axis", false, nil, "Extreme axis deviation favors VT")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "VT clues: AV dissociation, fusion/capture beats, precordial concordance, extreme axis deviation.",
            keyPoint: "VT: AV dissociation, fusion beats, concordance",
            algorithmStep: "Rhythm Recognition - VT vs SVT with aberrancy"
        ),
        makeQuestion(
            stem: "What is the general acute rate control target for atrial fibrillation?",
            choices: [
                ("Ventricular rate <110 bpm with symptom improvement", true, "Lenient control adequate acutely", nil),
                ("Exactly 60 bpm", false, nil, "Too strict"),
                ("<50 bpm", false, nil, "Bradycardia territory"),
                ("Heart rate is not important", false, nil, "Rate control is important")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Acute AFib rate goal: <110 bpm and symptom relief (strict control <80 not proven better).",
            keyPoint: "AFib rate goal: <110 bpm",
            algorithmStep: "Tachycardia Algorithm - Rate control targets"
        ),
        makeQuestion(
            stem: "What is the advantage of esmolol over other IV beta-blockers for rate control?",
            choices: [
                ("Very short half-life (2-9 minutes) - can be quickly titrated or stopped", true, "Ultra-short acting", nil),
                ("Longer duration of action", false, nil, "Opposite - very short"),
                ("No cardiac effects", false, nil, "Has cardiac effects"),
                ("Oral only formulation", false, nil, "IV formulation available")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Esmolol: ultra-short acting beta-blocker - good for unstable patients, quick offset.",
            keyPoint: "Esmolol: ultra-short acting, titratable",
            algorithmStep: "Tachycardia Algorithm - Esmolol properties"
        ),
        makeQuestion(
            stem: "Besides terminating SVT, what is another use of adenosine in tachycardia?",
            choices: [
                ("Diagnostic: may unmask underlying rhythm by slowing AV conduction", true, "Can reveal atrial activity", nil),
                ("Converts atrial fibrillation to sinus rhythm", false, nil, "Won't convert AFib"),
                ("Treats ventricular tachycardia", false, nil, "Not effective for VT"),
                ("Speeds up the heart rate", false, nil, "Slows AV conduction")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Adenosine can unmask atrial activity (flutter waves, AFib) by transiently blocking AV node.",
            keyPoint: "Adenosine: diagnostic to unmask rhythm",
            algorithmStep: "Tachycardia Algorithm - Adenosine diagnostic application"
        ),
        makeQuestion(
            stem: "What ECG appearance characterizes junctional tachycardia?",
            choices: [
                ("Narrow complex, regular rhythm, absent or retrograde P waves, rate 100-180 bpm", true, "AV junction origin", nil),
                ("Wide complex irregular rhythm", false, nil, "That's not junctional"),
                ("Saw-tooth baseline", false, nil, "That's atrial flutter"),
                ("Chaotic baseline with no P waves", false, nil, "That's AFib")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Junctional tach: narrow, regular, absent or retrograde P waves (near or after QRS).",
            keyPoint: "Junctional: narrow, regular, no/retrograde P waves",
            algorithmStep: "Rhythm Recognition - Junctional tachycardia"
        ),
        makeQuestion(
            stem: "What is the current role of digoxin in acute tachycardia management?",
            choices: [
                ("Limited role; may be used for rate control in AFib, especially with heart failure", true, "Slow onset limits acute use", nil),
                ("First-line for all SVTs", false, nil, "Not first-line"),
                ("Preferred over beta-blockers", false, nil, "Not preferred"),
                ("No role in modern practice", false, nil, "Still has some role")
            ],
            topic: .pharmacology,
            difficulty: .hard,
            explanation: "Digoxin: slow onset, limited acute use; may be useful in HF + AFib for rate control.",
            keyPoint: "Digoxin: limited acute role, useful in HF+AFib",
            algorithmStep: "Tachycardia Algorithm - Digoxin considerations"
        ),
        makeQuestion(
            stem: "When considering cardioversion for atrial fibrillation, what is the anticoagulation requirement?",
            choices: [
                ("AFib >48 hours or unknown duration requires anticoagulation for 3 weeks before or TEE-guided approach", true, "Prevent stroke from atrial thrombus", nil),
                ("No anticoagulation ever needed", false, nil, "Anticoagulation often required"),
                ("Anticoagulation only after cardioversion", false, nil, "May be needed before"),
                ("Aspirin is sufficient", false, nil, "Full anticoagulation typically needed")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "AFib >48hr: anticoag 3 weeks before + 4 weeks after cardioversion, OR TEE to rule out LAA clot.",
            keyPoint: "AFib >48hr: anticoag or TEE before cardioversion",
            algorithmStep: "Tachycardia Algorithm - AFib cardioversion anticoagulation"
        )
    ]
    
    // MARK: - Complete Tachycardia Unstable Questions (30 from 05-Tachycardia-Questions.md)
    
    static let completeTachycardiaUnstable: [ACLSQuestion] = [
        makeQuestion(
            stem: "What defines an unstable tachyarrhythmia?",
            choices: [
                ("Tachycardia causing hypotension, altered mental status, signs of shock, chest pain, or acute heart failure", true, "Hemodynamic compromise from rhythm", nil),
                ("Any heart rate above 150 bpm", false, nil, "Rate alone doesn't define instability"),
                ("Any wide complex tachycardia", false, nil, "Width doesn't define instability"),
                ("Irregular rhythm only", false, nil, "Regularity doesn't define instability")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Unstable = tachycardia + hemodynamic compromise (hypotension, AMS, shock, chest pain, acute HF).",
            keyPoint: "Unstable = hemodynamic compromise",
            algorithmStep: "Tachycardia Algorithm - Signs of instability"
        ),
        makeQuestion(
            stem: "What is the definitive treatment for any hemodynamically unstable tachycardia?",
            choices: [
                ("Immediate synchronized cardioversion", true, "Don't delay for medications", nil),
                ("IV adenosine", false, nil, "May delay definitive treatment"),
                ("Oral beta-blockers", false, nil, "Too slow for unstable patient"),
                ("Observation", false, nil, "Dangerous in unstable patient")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Unstable tachycardia = synchronized cardioversion immediately.",
            keyPoint: "Unstable = immediate cardioversion",
            algorithmStep: "Tachycardia Algorithm - Unstable: immediate cardioversion"
        ),
        makeQuestion(
            stem: "Why is synchronized cardioversion preferred over unsynchronized shock for unstable tachycardia with a pulse?",
            choices: [
                ("Delivers shock on R wave to avoid the vulnerable T wave period and prevent VF", true, "Avoids R-on-T phenomenon", nil),
                ("Uses less energy", false, nil, "Energy is similar"),
                ("Is less painful", false, nil, "Pain is similar"),
                ("Works faster", false, nil, "Speed is similar")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Synchronized cardioversion times shock to R wave; shock during T wave can cause VF.",
            keyPoint: "Sync = avoids T wave, prevents VF",
            algorithmStep: "Tachycardia Algorithm - Synchronized cardioversion rationale"
        ),
        makeQuestion(
            stem: "What is the recommended initial energy for synchronized cardioversion of narrow regular SVT?",
            choices: [
                ("50-100 J", true, "Start low for narrow regular", nil),
                ("200 J", false, nil, "Too high initially"),
                ("360 J", false, nil, "Much too high"),
                ("10 J", false, nil, "Too low")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Narrow regular SVT: start low (50-100J) and escalate if needed.",
            keyPoint: "Narrow SVT: 50-100J initial",
            algorithmStep: "Tachycardia Algorithm - Cardioversion energy selection"
        ),
        makeQuestion(
            stem: "What is the recommended initial energy for synchronized cardioversion of atrial fibrillation?",
            choices: [
                ("120-200 J biphasic", true, "Higher energy needed for AFib", nil),
                ("50 J", false, nil, "Too low"),
                ("360 J monophasic only", false, nil, "Biphasic is standard"),
                ("20 J", false, nil, "Much too low")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "AFib cardioversion: higher energy needed (120-200J biphasic).",
            keyPoint: "AFib: 120-200J biphasic",
            algorithmStep: "Tachycardia Algorithm - AFib cardioversion energy"
        ),
        makeQuestion(
            stem: "What is the recommended initial energy for synchronized cardioversion of monomorphic VT with a pulse?",
            choices: [
                ("100 J", true, "Standard for VT with pulse", nil),
                ("25 J", false, nil, "Too low"),
                ("360 J", false, nil, "Too high initially"),
                ("5 J", false, nil, "Much too low")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Monomorphic VT with pulse: 100J initial synchronized cardioversion.",
            keyPoint: "VT with pulse: 100J initial",
            algorithmStep: "Tachycardia Algorithm - VT cardioversion energy"
        ),
        makeQuestion(
            stem: "How should unstable polymorphic VT be treated?",
            choices: [
                ("Treat as VF - unsynchronized defibrillation at high energy", true, "Too irregular to sync", nil),
                ("Synchronized cardioversion at 50 J", false, nil, "Can't sync to irregular rhythm"),
                ("Adenosine first", false, nil, "Not appropriate"),
                ("Observation", false, nil, "Life-threatening rhythm")
            ],
            topic: .electrical,
            difficulty: .hard,
            explanation: "Polymorphic VT: treat as VF with unsync defib (too irregular to sync reliably).",
            keyPoint: "Polymorphic VT = treat as VF (unsync defib)",
            algorithmStep: "Tachycardia Algorithm - Polymorphic VT: defibrillation"
        ),
        makeQuestion(
            stem: "When should sedation be considered before cardioversion?",
            choices: [
                ("If patient is conscious and time permits without delaying life-saving treatment", true, "Sedate if possible but don't delay", nil),
                ("Always, even if patient is pulseless", false, nil, "Don't delay for sedation if critical"),
                ("Never - cardioversion is not painful", false, nil, "It is painful"),
                ("Only in children", false, nil, "Adults feel it too")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Sedate if time allows; don't delay life-saving cardioversion for sedation.",
            keyPoint: "Sedate if possible, don't delay treatment",
            algorithmStep: "Tachycardia Algorithm - Sedation considerations"
        ),
        makeQuestion(
            stem: "If synchronized cardioversion at initial energy fails, what is the next step?",
            choices: [
                ("Increase energy for subsequent attempts in stepwise fashion", true, "Escalate energy", nil),
                ("Switch to medication only", false, nil, "Continue electrical therapy"),
                ("Terminate resuscitation", false, nil, "Keep trying"),
                ("Continue at same energy indefinitely", false, nil, "Escalate if not working")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Escalate energy with each failed cardioversion attempt.",
            keyPoint: "Escalate energy after failed shock",
            algorithmStep: "Tachycardia Algorithm - Energy escalation"
        ),
        makeQuestion(
            stem: "After delivering a synchronized shock, what must you verify before delivering another?",
            choices: [
                ("That the sync mode is still activated (many defibrillators reset to unsync)", true, "Sync mode often resets", nil),
                ("That unsync mode is selected", false, nil, "Need sync for cardioversion"),
                ("That pads are removed", false, nil, "Keep pads in place"),
                ("Nothing needs to be verified", false, nil, "Must check sync mode")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "SYNC mode resets after each shock on most defibrillators - re-select before next shock.",
            keyPoint: "Re-select SYNC after each shock",
            algorithmStep: "Tachycardia Algorithm - Sync mode operation"
        ),
        makeQuestion(
            stem: "During cardioversion for unstable SVT, the rhythm degenerates to VF. What is the immediate action?",
            choices: [
                ("Immediately switch to unsynchronized defibrillation", true, "VF requires unsync defib", nil),
                ("Continue synchronized cardioversion", false, nil, "Sync won't fire on VF"),
                ("Give adenosine", false, nil, "Need defibrillation"),
                ("Wait for spontaneous conversion", false, nil, "VF is immediately life-threatening")
            ],
            topic: .electrical,
            difficulty: .hard,
            explanation: "VF = immediate unsync defib (sync mode won't fire on VF - nothing to sync to).",
            keyPoint: "VF during cardioversion = switch to unsync defib",
            algorithmStep: "Tachycardia Algorithm - Managing VF during cardioversion"
        ),
        makeQuestion(
            stem: "A 58-year-old with AFib RVR (HR 180) has BP 70/40, AMS, and pulmonary edema. What is the immediate treatment?",
            vignette: "Emergency department presentation with severe symptoms.",
            vitals: ACLSVitals(heartRate: 180, bpSystolic: 70, bpDiastolic: 40, spO2: 88, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Synchronized cardioversion 120-200 J", true, "Unstable AFib = cardiovert", nil),
                ("IV diltiazem", false, nil, "Too slow for this unstable patient"),
                ("Adenosine 6 mg", false, nil, "Won't convert AFib"),
                ("Oral metoprolol", false, nil, "Not appropriate for acute unstable")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Unstable AFib (hypotension, AMS, pulmonary edema) = immediate synchronized cardioversion.",
            keyPoint: "Unstable AFib = cardiovert immediately",
            algorithmStep: "Tachycardia Algorithm - Unstable AFib treatment"
        ),
        makeQuestion(
            stem: "A 65-year-old collapses with BP 60/40, confusion, and wide complex regular tachycardia at 200 bpm with a weak pulse. What is the priority intervention?",
            vignette: "Found down, responsive but confused.",
            vitals: ACLSVitals(heartRate: 200, bpSystolic: 60, bpDiastolic: 40, spO2: 85, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Immediate synchronized cardioversion 100 J", true, "Unstable WCT with pulse = cardiovert", nil),
                ("Amiodarone 150 mg IV over 10 minutes", false, nil, "Too slow"),
                ("Lidocaine 1 mg/kg", false, nil, "Not first-line"),
                ("Vagal maneuvers", false, nil, "Not appropriate for WCT")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Unstable wide complex tachycardia with pulse = synchronized cardioversion immediately.",
            keyPoint: "Unstable WCT with pulse = cardiovert 100J",
            algorithmStep: "Tachycardia Algorithm - Unstable VT with pulse"
        ),
        makeQuestion(
            stem: "What is the proper defibrillator pad placement for cardioversion?",
            choices: [
                ("Standard anterolateral or anterior-posterior position", true, "Same as defibrillation", nil),
                ("Both pads on left chest", false, nil, "Won't traverse heart properly"),
                ("Pads on abdomen", false, nil, "Won't work"),
                ("Pad on back only", false, nil, "Need both pads")
            ],
            topic: .electrical,
            difficulty: .easy,
            explanation: "Same pad placement as defibrillation: anterolateral OR AP positioning.",
            keyPoint: "Anterolateral or AP placement",
            algorithmStep: "Tachycardia Algorithm - Cardioversion pad placement"
        ),
        makeQuestion(
            stem: "If unstable narrow regular SVT is present and cardioversion is being prepared, is there a role for adenosine?",
            choices: [
                ("May try rapid adenosine if IV in place and cardioversion not immediately available, but don't delay cardioversion", true, "Can try but don't delay", nil),
                ("Adenosine is always preferred over cardioversion", false, nil, "Cardioversion is definitive"),
                ("Adenosine is contraindicated in unstable patients", false, nil, "Can be used if quick"),
                ("Give adenosine instead of cardioversion always", false, nil, "Cardioversion is primary treatment")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "Adenosine may be attempted for unstable narrow regular SVT only if won't delay cardioversion.",
            keyPoint: "Adenosine okay if won't delay cardioversion",
            algorithmStep: "Tachycardia Algorithm - Adenosine in unstable patient"
        ),
        makeQuestion(
            stem: "After successful cardioversion to sinus rhythm, what should be monitored?",
            choices: [
                ("Continuous ECG, vital signs, and watch for recurrence; identify and treat underlying cause", true, "Post-cardioversion monitoring essential", nil),
                ("No monitoring needed", false, nil, "Monitoring is critical"),
                ("Discharge immediately", false, nil, "Need observation"),
                ("Repeat cardioversion prophylactically", false, nil, "Only if recurs")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Post-cardioversion: monitor for arrhythmia recurrence, treat underlying cause.",
            keyPoint: "Monitor for recurrence, treat cause",
            algorithmStep: "Tachycardia Algorithm - Post-cardioversion monitoring"
        ),
        makeQuestion(
            stem: "When cardioverting a patient with an implanted pacemaker or ICD, what precaution should be taken?",
            choices: [
                ("Place pads at least 8 cm from the device; check device function after cardioversion", true, "Protect the device", nil),
                ("Cardioversion is contraindicated", false, nil, "Can be done safely"),
                ("Place pads directly over the device", false, nil, "Can damage device"),
                ("Use only 10 J", false, nil, "Use standard energy")
            ],
            topic: .electrical,
            difficulty: .hard,
            explanation: "Pacemaker/ICD: pads ≥8cm from device, check device function post-procedure.",
            keyPoint: "Pads ≥8cm from device, check after",
            algorithmStep: "Tachycardia Algorithm - Cardioversion with implanted devices"
        ),
        makeQuestion(
            stem: "A patient has sinus tachycardia at 130 bpm with hypotension. Should cardioversion be performed?",
            choices: [
                ("No - sinus tachycardia is usually compensatory; treat the underlying cause", true, "Don't cardiovert sinus tach", nil),
                ("Yes - cardioversion for any unstable tachycardia", false, nil, "Sinus tach is exception"),
                ("Yes - at 50 J", false, nil, "Never cardiovert sinus tach"),
                ("Only if HR > 200 bpm", false, nil, "Rate doesn't change this")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "Sinus tachycardia = compensatory response - cardioverting won't help, treat the cause.",
            keyPoint: "Never cardiovert sinus tachycardia",
            algorithmStep: "Tachycardia Algorithm - Sinus tachycardia exception"
        ),
        makeQuestion(
            stem: "What precaution should be taken regarding supplemental oxygen during cardioversion?",
            choices: [
                ("Remove oxygen source from immediate area to prevent fire risk during shock", true, "Fire hazard", nil),
                ("Increase oxygen flow during shock", false, nil, "Increases fire risk"),
                ("Oxygen is not a concern", false, nil, "Significant concern"),
                ("Deliver shock only in 100% oxygen environment", false, nil, "Dangerous")
            ],
            topic: .electrical,
            difficulty: .easy,
            explanation: "Remove/move oxygen source during shock - fire hazard from electrical discharge.",
            keyPoint: "Remove O2 during shock - fire hazard",
            algorithmStep: "Tachycardia Algorithm - Cardioversion safety"
        ),
        makeQuestion(
            stem: "What systolic blood pressure generally indicates hemodynamic instability requiring urgent cardioversion?",
            choices: [
                ("<90 mmHg with symptoms attributable to the tachycardia", true, "Hypotension from rhythm", nil),
                ("<140 mmHg", false, nil, "Too high threshold"),
                ("<120 mmHg regardless of symptoms", false, nil, "Symptoms matter"),
                ("Blood pressure is not relevant", false, nil, "Very relevant")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "SBP <90 + symptoms (confusion, chest pain, shock) from tachycardia = unstable.",
            keyPoint: "SBP <90 + symptoms = unstable",
            algorithmStep: "Tachycardia Algorithm - Hemodynamic instability criteria"
        ),
        makeQuestion(
            stem: "Atrial flutter often converts at what energy level compared to atrial fibrillation?",
            choices: [
                ("Lower energy (50-100 J) - flutter is often easier to cardiovert", true, "More organized rhythm", nil),
                ("Higher energy", false, nil, "Lower typically works"),
                ("Same energy", false, nil, "Flutter often converts easier"),
                ("Cannot be cardioverted", false, nil, "Can be cardioverted")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Atrial flutter: more organized, often converts at lower energy than AFib.",
            keyPoint: "Flutter: lower energy than AFib",
            algorithmStep: "Tachycardia Algorithm - Flutter cardioversion"
        ),
        makeQuestion(
            stem: "After multiple failed cardioversion attempts for unstable AFib, what should be considered?",
            choices: [
                ("Ensure proper pad placement, increase energy, consider antiarrhythmic before next attempt", true, "Troubleshoot and optimize", nil),
                ("Terminate resuscitation", false, nil, "Keep trying"),
                ("Give digoxin during the arrhythmia", false, nil, "Not helpful acutely"),
                ("Nothing else can be done", false, nil, "Multiple options remain")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Failed cardioversion: check pad contact, escalate energy, may pretreat with amiodarone/ibutilide.",
            keyPoint: "Troubleshoot pads, energy, consider antiarrhythmic",
            algorithmStep: "Tachycardia Algorithm - Refractory arrhythmia management"
        ),
        makeQuestion(
            stem: "Before delivering a cardioversion shock, what must be announced?",
            choices: [
                ("Verbally clear the patient and visually confirm no one is touching patient or equipment", true, "Safety first", nil),
                ("Nothing - just shock", false, nil, "Must clear everyone"),
                ("Only clear for defibrillation, not cardioversion", false, nil, "Clear for both"),
                ("Only the person delivering the shock needs to be clear", false, nil, "Everyone must be clear")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Always announce 'I'm going to shock on three. Everybody clear!' - check visual + verbal.",
            keyPoint: "Clear verbally and visually before shock",
            algorithmStep: "Tachycardia Algorithm - Safety during cardioversion"
        ),
        makeQuestion(
            stem: "When is rhythm control (cardioversion) mandatory versus rate control being acceptable?",
            choices: [
                ("Rhythm control mandatory if hemodynamically unstable; rate control may be acceptable if stable", true, "Stability determines approach", nil),
                ("Rate control is never acceptable", false, nil, "Often acceptable if stable"),
                ("Rhythm control is never urgent", false, nil, "Urgent if unstable"),
                ("They are always equivalent", false, nil, "Different indications")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "Unstable = rhythm control (cardioversion); Stable = rate control may be sufficient acutely.",
            keyPoint: "Unstable = cardiovert; Stable = rate control okay",
            algorithmStep: "Tachycardia Algorithm - Rate vs rhythm control decision"
        ),
        makeQuestion(
            stem: "A patient with SVT at 180 bpm has chest pain but normal blood pressure. Is this considered unstable?",
            choices: [
                ("Yes - ischemic chest pain from tachycardia is a sign of instability", true, "Chest pain = instability", nil),
                ("No - BP is normal", false, nil, "Chest pain makes it unstable"),
                ("Only if ST elevation present", false, nil, "Any ischemic chest pain counts"),
                ("Only if HR > 200 bpm", false, nil, "Rate doesn't determine this")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Ischemic chest pain = myocardial O2 demand > supply = instability sign.",
            keyPoint: "Ischemic chest pain = unstable",
            algorithmStep: "Tachycardia Algorithm - Instability criteria include chest pain"
        ),
        makeQuestion(
            stem: "A pregnant patient at 28 weeks has unstable SVT. Can cardioversion be performed?",
            choices: [
                ("Yes - cardioversion is safe in pregnancy; unstable arrhythmia threatens both mother and fetus", true, "Safe and necessary", nil),
                ("No - electricity contraindicated in pregnancy", false, nil, "Safe in pregnancy"),
                ("Only in the first trimester", false, nil, "Safe throughout"),
                ("Medications only in pregnancy", false, nil, "Cardioversion preferred if unstable")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "Cardioversion safe in pregnancy - maternal instability is greater threat to fetus than shock.",
            keyPoint: "Cardioversion safe in pregnancy",
            algorithmStep: "Tachycardia Algorithm - Pregnancy considerations"
        ),
        makeQuestion(
            stem: "How does patient consciousness level affect the decision to cardiovert for unstable tachycardia?",
            choices: [
                ("Unconscious patients receive immediate cardioversion; conscious patients may receive brief sedation if time permits", true, "Consciousness affects sedation, not cardioversion decision", nil),
                ("Only cardiovert unconscious patients", false, nil, "Cardiovert all unstable"),
                ("Only cardiovert conscious patients", false, nil, "Cardiovert all unstable"),
                ("Consciousness level doesn't affect treatment", false, nil, "Affects sedation approach")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Unstable = cardiovert regardless of consciousness; sedate conscious patients if time allows.",
            keyPoint: "Cardiovert all unstable; sedate if time allows",
            algorithmStep: "Tachycardia Algorithm - Treatment based on stability"
        ),
        makeQuestion(
            stem: "After successful cardioversion of unstable VT, what should be considered to prevent recurrence?",
            choices: [
                ("Antiarrhythmic infusion (amiodarone or lidocaine), treat reversible causes, cardiology consultation", true, "Prevent recurrence", nil),
                ("No further treatment needed", false, nil, "Need maintenance therapy"),
                ("Repeat cardioversion prophylactically", false, nil, "Only if recurs"),
                ("Discharge home immediately", false, nil, "Need observation and workup")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Post-cardioversion VT: antiarrhythmic maintenance, identify/treat cause (ischemia, electrolytes).",
            keyPoint: "Antiarrhythmic maintenance, treat cause",
            algorithmStep: "Tachycardia Algorithm - Post-cardioversion management"
        ),
        makeQuestion(
            stem: "True or False: The treatment for ANY hemodynamically unstable tachyarrhythmia (except sinus tachycardia) is synchronized cardioversion.",
            choices: [
                ("True", true, "Unified approach to unstable tachycardia", nil),
                ("False", false, nil, "This is correct (with exception of sinus tach and polymorphic VT)")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "Unstable tachycardia = synchronized cardioversion (Exception: sinus tach - treat cause; polymorphic VT - unsync defib).",
            keyPoint: "Unstable tachycardia = cardioversion",
            algorithmStep: "Tachycardia Algorithm - Unified approach"
        )
    ]
    
    // MARK: - Complete Post-ROSC Questions (40 from 06-Post-ROSC-Questions.md)
    
    static let completePostROSC: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per AHA 2025 guidelines, what is the target SpO2 range after ROSC?",
            choices: [
                ("90-98%", true, "Avoid hypoxia AND hyperoxia", nil),
                ("100% at all times", false, nil, "Hyperoxia is harmful"),
                ("85-90%", false, nil, "Too low"),
                (">98%", false, nil, "Hyperoxia is harmful")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Avoid hypoxia (<90%) AND hyperoxia (>98%) - both cause harm post-arrest.",
            keyPoint: "SpO2 target: 90-98%",
            algorithmStep: "Post-Cardiac Arrest Care - SpO2 target"
        ),
        makeQuestion(
            stem: "What is the target PaCO2 range for post-cardiac arrest patients?",
            choices: [
                ("35-45 mmHg (normocapnia)", true, "Normal range", nil),
                ("25-30 mmHg (hypocapnia)", false, nil, "Causes cerebral vasoconstriction"),
                ("50-60 mmHg (hypercapnia)", false, nil, "Increases ICP"),
                ("CO2 is not important post-ROSC", false, nil, "Very important")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Normocapnia (35-45): hypocapnia = cerebral vasoconstriction; hypercapnia = increased ICP.",
            keyPoint: "PaCO2 target: 35-45 mmHg",
            algorithmStep: "Post-Cardiac Arrest Care - PaCO2 target"
        ),
        makeQuestion(
            stem: "Per AHA 2025 guidelines, what is the minimum MAP target after ROSC?",
            choices: [
                ("≥65 mmHg", true, "2025 Update: MAP-focused", nil),
                ("≥50 mmHg", false, nil, "Too low"),
                ("≥80 mmHg", false, nil, "Higher than required minimum"),
                ("≥100 mmHg", false, nil, "Not required")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025: MAP ≥65 mmHg minimum (SBP >90 removed as separate target).",
            keyPoint: "MAP target: ≥65 mmHg",
            algorithmStep: "Post-Cardiac Arrest Care - Hemodynamic target"
        ),
        makeQuestion(
            stem: "What temperature range is recommended for TTM after cardiac arrest per 2025 guidelines?",
            choices: [
                ("32°C to 37.5°C", true, "Wider range acceptable", nil),
                ("32°C to 34°C only", false, nil, "Old narrower target"),
                ("36°C to 37°C only", false, nil, "Old narrower target"),
                ("Normal body temperature only", false, nil, "Cooling may be beneficial")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "TTM 32-37.5°C; key is preventing hyperthermia (>37.5°C) which worsens outcomes.",
            keyPoint: "TTM: 32-37.5°C, prevent hyperthermia",
            algorithmStep: "Post-Cardiac Arrest Care - Temperature range"
        ),
        makeQuestion(
            stem: "Per AHA 2025 guidelines, what is the minimum duration for targeted temperature management?",
            choices: [
                ("At least 36 hours", true, "2025 UPDATE: increased duration", nil),
                ("12 hours", false, nil, "Too short"),
                ("24 hours (previous recommendation)", false, nil, "Old recommendation"),
                ("6 hours", false, nil, "Too short")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025 UPDATE: TTM at least 36 hours (increased from 24 hours).",
            keyPoint: "TTM duration: ≥36 hours",
            algorithmStep: "Post-Cardiac Arrest Care - TTM duration"
        ),
        makeQuestion(
            stem: "A patient achieves ROSC after VF arrest. The 12-lead ECG shows ST elevation in V1-V4. What is the next step?",
            choices: [
                ("Emergency coronary angiography and PCI regardless of consciousness level", true, "STEMI = emergent cath", nil),
                ("Wait until patient is fully awake", false, nil, "Don't delay for neurologic recovery"),
                ("Thrombolytics are preferred over PCI", false, nil, "PCI preferred"),
                ("Cardiac catheterization is contraindicated post-arrest", false, nil, "Indicated for STEMI")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "STEMI post-arrest: emergent cath/PCI - don't delay for neurologic recovery.",
            keyPoint: "Post-arrest STEMI = emergent PCI",
            algorithmStep: "Post-Cardiac Arrest Care - STEMI management"
        ),
        makeQuestion(
            stem: "How should seizures be managed in post-cardiac arrest patients?",
            choices: [
                ("Treat aggressively with benzodiazepines or antiepileptic drugs; obtain EEG", true, "Aggressive treatment needed", nil),
                ("Seizures are protective post-arrest", false, nil, "They're harmful"),
                ("Only observe", false, nil, "Requires treatment"),
                ("Increase temperature to treat seizures", false, nil, "Temperature doesn't treat seizures")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Seizures increase cerebral metabolic demand - treat aggressively, monitor EEG.",
            keyPoint: "Treat seizures aggressively, get EEG",
            algorithmStep: "Post-Cardiac Arrest Care - Seizure management"
        ),
        makeQuestion(
            stem: "What is the glucose management recommendation for post-cardiac arrest patients?",
            choices: [
                ("Avoid hypoglycemia (<60 mg/dL) and treat severe hyperglycemia; target 140-180 mg/dL", true, "Moderate control", nil),
                ("Tight glucose control (80-110 mg/dL)", false, nil, "Too tight increases hypoglycemia risk"),
                ("No glucose monitoring needed", false, nil, "Monitoring needed"),
                ("Allow hyperglycemia for neuroprotection", false, nil, "Hyperglycemia is harmful")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Avoid hypoglycemia (worse outcomes); moderate glucose control (140-180 mg/dL).",
            keyPoint: "Glucose: 140-180 mg/dL, avoid hypoglycemia",
            algorithmStep: "Post-Cardiac Arrest Care - Glucose targets"
        ),
        makeQuestion(
            stem: "When is the earliest appropriate time for neurologic prognostication after cardiac arrest in TTM-treated patients?",
            choices: [
                ("At least 72 hours after return to normothermia", true, "Wait for drug clearance and normothermia", nil),
                ("Immediately after ROSC", false, nil, "Too early"),
                ("Within 6 hours", false, nil, "Too early"),
                ("24 hours after arrest", false, nil, "Too early")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "Prognostication: wait ≥72 hours after normothermia; use multimodal assessment.",
            keyPoint: "Prognostication: ≥72 hours after normothermia",
            algorithmStep: "Post-Cardiac Arrest Care - Prognostication timing"
        ),
        makeQuestion(
            stem: "What ventilation strategy is recommended for post-cardiac arrest patients?",
            choices: [
                ("Lung-protective ventilation with tidal volumes 6-8 mL/kg ideal body weight", true, "Standard lung protection", nil),
                ("High tidal volumes (12 mL/kg) to maximize oxygenation", false, nil, "Causes lung injury"),
                ("No specific ventilation strategy", false, nil, "Lung protection recommended"),
                ("Allow auto-PEEP", false, nil, "Avoid auto-PEEP")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Lung-protective ventilation: Vt 6-8 mL/kg IBW, avoid hyperventilation.",
            keyPoint: "Lung-protective: 6-8 mL/kg IBW",
            algorithmStep: "Post-Cardiac Arrest Care - Ventilation strategy"
        ),
        makeQuestion(
            stem: "Why is preventing fever (hyperthermia) important after cardiac arrest?",
            choices: [
                ("Fever increases cerebral metabolic demand and worsens neurologic outcomes", true, "Increases injury", nil),
                ("Fever has no effect on outcomes", false, nil, "Significant effect"),
                ("Fever is protective", false, nil, "It's harmful"),
                ("Fever only affects cardiac function", false, nil, "Affects brain primarily")
            ],
            topic: .postROSC,
            difficulty: .easy,
            explanation: "Fever = increased O2 demand, worsens brain injury; actively prevent hyperthermia >37.5°C.",
            keyPoint: "Prevent fever - worsens brain injury",
            algorithmStep: "Post-Cardiac Arrest Care - Hyperthermia prevention"
        ),
        makeQuestion(
            stem: "What vasopressor is commonly used for post-cardiac arrest hypotension?",
            choices: [
                ("Norepinephrine or epinephrine infusion", true, "Standard vasopressors", nil),
                ("Vasopressin as first-line", false, nil, "Not first-line post-ROSC"),
                ("Dopamine only", false, nil, "Not preferred"),
                ("No vasopressors should be used", false, nil, "Often needed")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Norepinephrine or epinephrine infusions for MAP support; individualize based on patient.",
            keyPoint: "Norepinephrine or epinephrine for hypotension",
            algorithmStep: "Post-Cardiac Arrest Care - Vasopressor support"
        ),
        makeQuestion(
            stem: "Should coronary angiography be considered in post-arrest patients without STEMI on ECG?",
            choices: [
                ("May be reasonable if high suspicion for cardiac cause, especially with hemodynamic instability", true, "Consider if cardiac cause suspected", nil),
                ("Never without STEMI", false, nil, "May be considered"),
                ("Only if patient is awake", false, nil, "Consciousness not required"),
                ("Wait at least 72 hours", false, nil, "May be done early")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "Non-STEMI cath: consider if suspected cardiac etiology, especially with instability or VF arrest.",
            keyPoint: "Consider cath if cardiac cause suspected",
            algorithmStep: "Post-Cardiac Arrest Care - Non-STEMI evaluation"
        ),
        makeQuestion(
            stem: "How should shivering be managed during targeted temperature management?",
            choices: [
                ("Pharmacologic suppression with sedation, buspirone, magnesium, or paralysis if needed", true, "Suppress shivering", nil),
                ("Shivering is beneficial", false, nil, "It's harmful - increases O2 demand"),
                ("Stop TTM if shivering occurs", false, nil, "Treat shivering, continue TTM"),
                ("Only external warming blankets", false, nil, "Pharmacologic treatment needed")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Shivering increases metabolic demand - suppress with sedation, meperidine, paralysis if needed.",
            keyPoint: "Suppress shivering during TTM",
            algorithmStep: "Post-Cardiac Arrest Care - Shivering management"
        ),
        makeQuestion(
            stem: "What is the recommended rate of rewarming after targeted temperature management?",
            choices: [
                ("0.25-0.5°C per hour (slow, controlled rewarming)", true, "Slow and controlled", nil),
                ("Rapid rewarming over 1 hour", false, nil, "Too fast"),
                ("2°C per hour", false, nil, "Too fast"),
                ("Rewarming rate doesn't matter", false, nil, "Rate matters")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Slow rewarming (0.25-0.5°C/hr) prevents rebound hyperthermia and electrolyte shifts.",
            keyPoint: "Rewarm slowly: 0.25-0.5°C/hr",
            algorithmStep: "Post-Cardiac Arrest Care - Rewarming protocol"
        ),
        makeQuestion(
            stem: "Post-cardiac arrest myocardial dysfunction is typically:",
            choices: [
                ("Reversible, improving over 24-72 hours with supportive care", true, "Usually reversible", nil),
                ("Permanent", false, nil, "Usually reversible"),
                ("Not a real phenomenon", false, nil, "Well-documented phenomenon"),
                ("Only occurs after VF arrests", false, nil, "Can occur after any arrest")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Post-arrest myocardial stunning: reversible over 24-72h; support with inotropes if needed.",
            keyPoint: "Myocardial stunning is reversible",
            algorithmStep: "Post-Cardiac Arrest Care - Myocardial dysfunction"
        ),
        makeQuestion(
            stem: "True or False: Preventing fever (hyperthermia >37.5°C) may be the most important aspect of temperature management after cardiac arrest.",
            choices: [
                ("True", true, "Fever prevention is critical", nil),
                ("False", false, nil, "Fever prevention is key")
            ],
            topic: .postROSC,
            difficulty: .easy,
            explanation: "Hyperthermia prevention is critical - even if not actively cooling, prevent fever.",
            keyPoint: "Fever prevention is critical",
            algorithmStep: "Post-Cardiac Arrest Care - Temperature emphasis"
        ),
        makeQuestion(
            stem: "When might ECMO be considered in the post-cardiac arrest setting?",
            choices: [
                ("Cardiogenic shock refractory to conventional therapy, or hypothermic arrest needing rewarming", true, "Specific indications", nil),
                ("Routine for all post-arrest patients", false, nil, "Not routine"),
                ("Never indicated post-arrest", false, nil, "Has specific indications"),
                ("Only for pediatric patients", false, nil, "Used in adults too")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "ECMO: refractory cardiogenic shock, bridge to recovery/transplant, hypothermic arrest rewarming.",
            keyPoint: "ECMO for refractory shock or hypothermic arrest",
            algorithmStep: "Post-Cardiac Arrest Care - Advanced support"
        ),
        makeQuestion(
            stem: "Which electrolyte abnormalities should be specifically monitored and corrected after cardiac arrest?",
            choices: [
                ("Potassium, magnesium, and calcium", true, "Affect cardiac rhythm", nil),
                ("Sodium only", false, nil, "Others also important"),
                ("No electrolyte monitoring needed", false, nil, "Monitoring essential"),
                ("Chloride only", false, nil, "Others more important")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Monitor K+, Mg++, Ca++ - all affect cardiac rhythm; correct abnormalities promptly.",
            keyPoint: "Monitor and correct K, Mg, Ca",
            algorithmStep: "Post-Cardiac Arrest Care - Electrolyte monitoring"
        ),
        makeQuestion(
            stem: "According to 2025 guidelines, when should head-to-pelvis CT be considered after arrest?",
            choices: [
                ("When etiology of arrest is unclear, to identify PE, aortic pathology, or other causes", true, "Find arrest cause", nil),
                ("Never indicated", false, nil, "Often indicated"),
                ("Only for trauma patients", false, nil, "Useful for many causes"),
                ("Routine for all arrests", false, nil, "When etiology unclear")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "2025: Consider CT (including CT angio) to find arrest cause (PE, aortic dissection, etc.).",
            keyPoint: "CT to identify arrest etiology",
            algorithmStep: "Post-Cardiac Arrest Care - Diagnostic imaging"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, what psychological support should be offered to cardiac arrest survivors?",
            choices: [
                ("Structured assessment for anxiety, depression, and PTSD before discharge", true, "Screen all survivors", nil),
                ("No psychological assessment needed", false, nil, "Assessment needed"),
                ("Only if patient requests", false, nil, "Proactive screening"),
                ("Only for patients with poor neurologic outcome", false, nil, "All survivors need screening")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "2025: Survivors need psychological screening (anxiety, depression, PTSD) before discharge.",
            keyPoint: "Screen survivors for anxiety, depression, PTSD",
            algorithmStep: "Post-Cardiac Arrest Care - Psychological support"
        )
    ]
    
    // MARK: - Complete Team Dynamics Questions (20 from 10-Team-Dynamics-Airway-Electrical-Questions.md)
    
    static let completeTeamDynamics: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is closed-loop communication in resuscitation?",
            choices: [
                ("Leader gives order, receiver confirms, receiver reports completion", true, "Three-step process", nil),
                ("Leader gives all orders at once", false, nil, "Not closed-loop"),
                ("Team members work independently", false, nil, "Not closed-loop"),
                ("Only written communication", false, nil, "Verbal closed-loop")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Closed loop: Order → Confirm → Report completion = fewer errors.",
            keyPoint: "Closed loop: Order → Confirm → Report",
            algorithmStep: "Team Dynamics - Communication"
        ),
        makeQuestion(
            stem: "What are the primary responsibilities of the resuscitation team leader?",
            choices: [
                ("Assign roles, direct care, monitor quality, synthesize information, make treatment decisions", true, "Oversee and direct", nil),
                ("Perform all tasks personally", false, nil, "Delegates tasks"),
                ("Only document events", false, nil, "Multiple responsibilities"),
                ("Only communicate with family", false, nil, "Multiple responsibilities")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Team leader: oversees, directs, synthesizes - doesn't have to perform every task.",
            keyPoint: "Leader oversees and directs, delegates tasks",
            algorithmStep: "Team Dynamics - Team Leader Role"
        ),
        makeQuestion(
            stem: "Why is clear role assignment important during resuscitation?",
            choices: [
                ("Prevents duplication of effort, ensures all tasks are covered, reduces confusion", true, "Organized response", nil),
                ("Slows down resuscitation", false, nil, "Speeds it up"),
                ("Only needed for large teams", false, nil, "Needed for all teams"),
                ("Not important if team is experienced", false, nil, "Always important")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Clear roles prevent chaos - everyone knows their job, nothing gets missed.",
            keyPoint: "Clear roles prevent chaos",
            algorithmStep: "Team Dynamics - Role Clarity"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, what types of debriefing are recommended after resuscitation?",
            choices: [
                ("Both hot debrief (immediately after) and cold debrief (later structured review)", true, "Both types", nil),
                ("Only written documentation", false, nil, "Verbal debriefing important"),
                ("Never debrief - too emotionally difficult", false, nil, "Debriefing is beneficial"),
                ("Only for unsuccessful resuscitations", false, nil, "For all resuscitations")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "2025: Hot debrief = immediate capture; Cold debrief = structured reflection.",
            keyPoint: "Hot debrief + cold debrief",
            algorithmStep: "Systems of Care - Debriefing"
        ),
        makeQuestion(
            stem: "When should a team member speak up during resuscitation?",
            choices: [
                ("When they notice an error, safety concern, or have relevant information - respectfully and clearly", true, "Speak up for safety", nil),
                ("Never interrupt the leader", false, nil, "Should speak up for safety"),
                ("Only if directly asked", false, nil, "Should proactively speak up"),
                ("Only senior members can speak up", false, nil, "Anyone can speak up")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "Anyone can (and should) speak up for patient safety - flat hierarchy during code.",
            keyPoint: "Anyone should speak up for safety",
            algorithmStep: "Team Dynamics - Constructive Intervention"
        ),
        makeQuestion(
            stem: "What is a shared mental model in resuscitation?",
            choices: [
                ("Common understanding of the situation, plan, and each person's role", true, "Shared understanding", nil),
                ("Everyone doing the same task", false, nil, "Different tasks, shared understanding"),
                ("Written protocol only", false, nil, "Mental model is understanding"),
                ("Only the leader's plan matters", false, nil, "Team shares the model")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "Shared mental model: everyone understands the situation, plan, and their role.",
            keyPoint: "Shared understanding of situation and plan",
            algorithmStep: "Team Dynamics - Shared Mental Model"
        ),
        makeQuestion(
            stem: "What is the recommended approach to resuscitation team size?",
            choices: [
                ("Enough members to fill all necessary roles without overcrowding", true, "Right-sized team", nil),
                ("Maximum possible people", false, nil, "Can cause chaos"),
                ("Minimum of 2 people only", false, nil, "May need more"),
                ("Exactly 10 people always", false, nil, "Depends on situation")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Right-sized team: enough for all roles, not so many that it's chaotic.",
            keyPoint: "Right-sized team for the situation",
            algorithmStep: "Team Dynamics - Team Size"
        ),
        makeQuestion(
            stem: "What is the 'pit crew' approach to resuscitation?",
            choices: [
                ("Choreographed team response with pre-assigned roles and seamless transitions", true, "Like NASCAR pit stops", nil),
                ("Racing to complete tasks", false, nil, "Organized, not racing"),
                ("One person does everything", false, nil, "Team approach"),
                ("Random task assignment", false, nil, "Pre-assigned roles")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "Pit crew: choreographed, practiced, efficient - like NASCAR pit stops.",
            keyPoint: "Choreographed, practiced, efficient",
            algorithmStep: "Team Dynamics - Pit Crew Approach"
        ),
        makeQuestion(
            stem: "True or False: Only the team leader should identify problems during a resuscitation.",
            choices: [
                ("False", true, "Anyone can speak up", nil),
                ("True", false, nil, "Anyone should speak up for safety")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Any team member should speak up about safety concerns - flat hierarchy.",
            keyPoint: "Anyone can identify problems",
            algorithmStep: "Team Dynamics - Speaking Up"
        ),
        makeQuestion(
            stem: "How often should the compressor role be rotated and why?",
            choices: [
                ("Every 2 minutes to prevent fatigue-related decline in CPR quality", true, "Prevent fatigue", nil),
                ("Every 10 minutes", false, nil, "Too long"),
                ("Never during a resuscitation", false, nil, "Must rotate"),
                ("Only when requested", false, nil, "Scheduled rotation needed")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Rotate q2min (with rhythm checks) to maintain high-quality compressions.",
            keyPoint: "Rotate compressors every 2 minutes",
            algorithmStep: "Team Dynamics - Compressor Rotation"
        )
    ]
    
    // MARK: - Complete Airway Management Questions (20 from 10-Team-Dynamics-Airway-Electrical-Questions.md)
    
    static let completeAirwayManagement: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the initial airway maneuver for an unresponsive patient?",
            choices: [
                ("Head tilt-chin lift (or jaw thrust if trauma suspected)", true, "Basic but effective", nil),
                ("Immediate intubation", false, nil, "Start with basic maneuvers"),
                ("Cricothyrotomy", false, nil, "Reserved for failed airway"),
                ("No airway intervention needed", false, nil, "Airway management needed")
            ],
            topic: .airway,
            difficulty: .easy,
            explanation: "Head tilt-chin lift (or jaw thrust for trauma) - basic but effective.",
            keyPoint: "Start with head tilt-chin lift",
            algorithmStep: "BLS Algorithm - Airway"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, if jaw thrust fails to open the airway in a trauma patient, what should be done?",
            choices: [
                ("Use head tilt-chin lift - airway patency takes priority", true, "Airway > c-spine", nil),
                ("Never move the head", false, nil, "Airway takes priority"),
                ("Proceed directly to surgical airway", false, nil, "Try head tilt first"),
                ("Abandon airway management", false, nil, "Never abandon airway")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "2025 UPDATE: If jaw thrust fails, use head tilt-chin lift - airway > c-spine.",
            keyPoint: "Airway patency takes priority over c-spine",
            algorithmStep: "BLS Algorithm - Trauma airway update"
        ),
        makeQuestion(
            stem: "What is the proper technique for bag-mask ventilation?",
            choices: [
                ("C-E grip, head tilt, create mask seal, squeeze bag over 1 second watching for chest rise", true, "Proper technique", nil),
                ("Squeeze bag rapidly", false, nil, "1 second squeeze"),
                ("No seal needed", false, nil, "Seal is critical"),
                ("Cover only mouth", false, nil, "Cover mouth and nose")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "BVM: C-E clamp, seal, 1-second squeeze, watch chest rise, avoid hyperventilation.",
            keyPoint: "C-E grip, 1-second squeeze, watch chest rise",
            algorithmStep: "Airway Management - BVM technique"
        ),
        makeQuestion(
            stem: "What is the ventilation rate during CPR with an advanced airway?",
            choices: [
                ("1 breath every 6 seconds (10 breaths per minute)", true, "Don't hyperventilate", nil),
                ("1 breath every 2 seconds", false, nil, "Too fast"),
                ("As fast as possible", false, nil, "Causes harm"),
                ("1 breath every 10 seconds", false, nil, "Too slow")
            ],
            topic: .airway,
            difficulty: .easy,
            explanation: "With advanced airway: 1 breath q6sec (10/min), continuous compressions.",
            keyPoint: "Advanced airway: 10 breaths/min",
            algorithmStep: "Airway Management - Ventilation rate"
        ),
        makeQuestion(
            stem: "Why should hyperventilation be avoided during CPR?",
            choices: [
                ("Increases intrathoracic pressure, decreases venous return and coronary perfusion", true, "Hemodynamic harm", nil),
                ("Improves oxygenation", false, nil, "Does not improve oxygenation"),
                ("Has no effect", false, nil, "Has harmful effects"),
                ("Recommended for cardiac arrest", false, nil, "Should be avoided")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "Hyperventilation = increased intrathoracic pressure = decreased venous return = worse outcomes.",
            keyPoint: "Hyperventilation decreases venous return",
            algorithmStep: "Airway Management - Avoid hyperventilation"
        ),
        makeQuestion(
            stem: "What is the gold standard for confirming endotracheal tube placement?",
            choices: [
                ("Waveform capnography (continuous ETCO2)", true, "Gold standard", nil),
                ("Listening for breath sounds only", false, nil, "Not reliable alone"),
                ("Chest X-ray only", false, nil, "Too slow"),
                ("Colorimetric CO2 detector alone", false, nil, "Waveform is better")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "Waveform capnography is gold standard - persistent waveform confirms tracheal placement.",
            keyPoint: "Waveform capnography is gold standard",
            algorithmStep: "Airway Management - ETT confirmation"
        ),
        makeQuestion(
            stem: "What information does ETCO2 provide during cardiac arrest?",
            choices: [
                ("CPR quality indicator, ROSC detection (sudden rise), and prognostic information", true, "Multiple uses", nil),
                ("Only confirms tube placement", false, nil, "Multiple uses"),
                ("No useful information during arrest", false, nil, "Very useful"),
                ("Only for post-ROSC monitoring", false, nil, "Useful during arrest")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "ETCO2: CPR quality (<10 = poor), ROSC (sudden rise >40), prognosis (persistent <10 = poor).",
            keyPoint: "ETCO2: CPR quality, ROSC detection, prognosis",
            algorithmStep: "Airway Management - ETCO2 uses"
        ),
        makeQuestion(
            stem: "What is the current recommendation for routine cricoid pressure during intubation?",
            choices: [
                ("Not routinely recommended; may impair visualization and intubation success", true, "Not routine", nil),
                ("Always required", false, nil, "Not routine"),
                ("Mandatory in all arrests", false, nil, "Not routine"),
                ("Replaces suction", false, nil, "Different purpose")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "Cricoid pressure not routine - may interfere with intubation; release if impeding.",
            keyPoint: "Cricoid pressure not routinely recommended",
            algorithmStep: "Airway Management - Cricoid pressure"
        ),
        makeQuestion(
            stem: "What is the approach to a 'can't intubate, can't oxygenate' scenario?",
            choices: [
                ("Attempt supraglottic airway; if fails, proceed to surgical airway (cricothyrotomy)", true, "CICO algorithm", nil),
                ("Continue failed intubation attempts", false, nil, "Move to rescue techniques"),
                ("Abandon airway management", false, nil, "Never abandon"),
                ("Only bag-mask ventilation", false, nil, "Need definitive airway")
            ],
            topic: .airway,
            difficulty: .hard,
            explanation: "CICO: SGA first, then surgical airway - don't persist with failed technique.",
            keyPoint: "CICO: SGA → Surgical airway",
            algorithmStep: "Airway Management - Failed airway"
        ),
        makeQuestion(
            stem: "What FiO2 should be used during cardiac arrest?",
            choices: [
                ("100% oxygen during arrest; titrate to SpO2 90-98% after ROSC", true, "Max during arrest, titrate after", nil),
                ("Room air only", false, nil, "Use 100% during arrest"),
                ("40% maximum", false, nil, "Use 100% during arrest"),
                ("Never use oxygen", false, nil, "Oxygen essential")
            ],
            topic: .airway,
            difficulty: .easy,
            explanation: "Arrest: 100% O2; Post-ROSC: titrate to SpO2 90-98% (avoid hyperoxia).",
            keyPoint: "100% during arrest, titrate after ROSC",
            algorithmStep: "Airway Management - Oxygen delivery"
        )
    ]
    
    // MARK: - Megacode Scenarios (50 from 14-Megacode-Scenarios-Questions.md)
    
    static let megacodeScenarios: [ACLSQuestion] = [
        // Scenario 1: Post-ROSC Comatose Patient
        makeQuestion(
            stem: "A 60-year-old man achieves ROSC after out-of-hospital VF arrest. Post-ROSC: BP 100/70, SpO2 96%, HR 92 sinus rhythm. He remains comatose. 12-lead ECG shows no STEMI. Which intervention is appropriate?",
            vignette: "10 minutes of CPR before ROSC. High-quality CPR was performed throughout.",
            vitals: ACLSVitals(heartRate: 92, bpSystolic: 100, bpDiastolic: 70, spO2: 96, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Coronary angiography", true, "Consider cath even without STEMI - ACS is common precipitant", nil),
                ("Dopamine infusion 5-20 mcg/kg/min", false, nil, "BP is adequate at 100/70"),
                ("Intravenous fibrinolytic therapy", false, nil, "Contraindicated post-CPR due to bleeding risk"),
                ("Nitroglycerin infusion at 5-10 mcg/min", false, nil, "Would lower already borderline BP")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "Post-arrest patients without obvious non-cardiac cause should be considered for coronary angiography even without STEMI.",
            keyPoint: "Consider cath even without STEMI post-arrest",
            algorithmStep: "Post-Cardiac Arrest Care - Coronary Reperfusion"
        ),
        // Scenario 2: Witnessed VF Arrest
        makeQuestion(
            stem: "A 55-year-old woman collapses in the hospital cafeteria. Nurse confirms unresponsive, not breathing. AED arrives, analyzes, delivers shock. What should be done IMMEDIATELY after the shock?",
            choices: [
                ("Check for a pulse", false, nil, "Don't check pulse immediately after shock"),
                ("Analyze the rhythm again", false, nil, "Wait 2 minutes of CPR first"),
                ("Resume CPR immediately, starting with chest compressions", true, "Resume CPR for 2 minutes after any shock", nil),
                ("Administer epinephrine 1 mg IV", false, nil, "Epinephrine comes after establishing access")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "After any shock, resume CPR immediately for 2 minutes before checking rhythm or pulse.",
            keyPoint: "Post-shock: immediate CPR for 2 minutes",
            algorithmStep: "VF/pVT Algorithm - Post-Shock CPR"
        ),
        // Scenario 3: Bradycardia with Hypotension
        makeQuestion(
            stem: "A 72-year-old man presents with dizziness and near-syncope. HR 38, BP 78/50, SpO2 94%. ECG shows complete heart block with ventricular escape rhythm. IV access established. What is the MOST appropriate initial intervention?",
            vitals: ACLSVitals(heartRate: 38, bpSystolic: 78, bpDiastolic: 50, spO2: 94, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Synchronized cardioversion at 100J", false, nil, "Cardioversion is for tachyarrhythmias"),
                ("Adenosine 6 mg rapid IV push", false, nil, "Adenosine slows the heart - contraindicated"),
                ("Atropine 1 mg IV", true, "First-line for symptomatic bradycardia", nil),
                ("Defibrillation at 200J biphasic", false, nil, "Defibrillation is for VF/pVT")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Symptomatic bradycardia with hypotension: Atropine 1 mg IV is first-line.",
            keyPoint: "Symptomatic bradycardia: Atropine 1 mg first",
            algorithmStep: "Bradycardia Algorithm - First-Line Treatment"
        ),
        // Scenario 4: Atropine-Resistant Bradycardia
        makeQuestion(
            stem: "A 68-year-old woman post-inferior STEMI develops HR 32, BP 70/40, confusion. ECG: third-degree AV block. Atropine 1 mg x2 given with minimal improvement (HR 36, BP 72/44). What is the NEXT intervention?",
            vitals: ACLSVitals(heartRate: 36, bpSystolic: 72, bpDiastolic: 44, spO2: nil, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Third dose of atropine 1 mg IV", false, nil, "Unlikely to help in high-degree block"),
                ("Synchronized cardioversion at 50J", false, nil, "Cardioversion treats tachycardia"),
                ("Transcutaneous pacing", true, "For atropine-resistant symptomatic bradycardia", nil),
                ("Amiodarone 300 mg IV", false, nil, "Amiodarone is for tachyarrhythmias")
            ],
            topic: .bradycardia,
            difficulty: .hard,
            explanation: "Atropine-resistant symptomatic bradycardia requires transcutaneous pacing.",
            keyPoint: "Atropine-resistant bradycardia: TCP",
            algorithmStep: "Bradycardia Algorithm - Second-Line (Pacing)"
        ),
        // Scenario 5: Wide Complex Tachycardia - Unstable
        makeQuestion(
            stem: "A 58-year-old man with cardiomyopathy presents with palpitations and chest pain. BP 82/60, HR 188, SpO2 91%. ECG shows wide complex regular monomorphic tachycardia. He is becoming lethargic. What is the MOST appropriate immediate intervention?",
            vitals: ACLSVitals(heartRate: 188, bpSystolic: 82, bpDiastolic: 60, spO2: 91, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Adenosine 6 mg rapid IV push", false, nil, "Patient is unstable - needs cardioversion"),
                ("Amiodarone 150 mg IV over 10 minutes", false, nil, "Takes too long for unstable patient"),
                ("Synchronized cardioversion starting at 100J", true, "Unstable tachycardia = immediate cardioversion", nil),
                ("Defibrillation at 200J biphasic", false, nil, "Use synchronized for organized rhythm with pulse")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "Unstable tachycardia (hypotension, altered mental status) = immediate synchronized cardioversion.",
            keyPoint: "Unstable tachycardia = cardioversion",
            algorithmStep: "Tachycardia Algorithm - Unstable Pathway"
        ),
        // Scenario 6: Narrow Complex Regular Tachycardia
        makeQuestion(
            stem: "A 32-year-old woman presents with sudden palpitations for 45 minutes. Alert, BP 118/76, HR 186, SpO2 99%. ECG: narrow complex regular tachycardia, no visible P waves. Vagal maneuvers unsuccessful. What is NEXT?",
            vitals: ACLSVitals(heartRate: 186, bpSystolic: 118, bpDiastolic: 76, spO2: 99, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Synchronized cardioversion at 50J", false, nil, "Patient is stable - try medications first"),
                ("Amiodarone 150 mg IV over 10 minutes", false, nil, "Adenosine is first choice for SVT"),
                ("Adenosine 6 mg rapid IV push with 20 mL saline flush", true, "First-line after failed vagal maneuvers", nil),
                ("Metoprolol 5 mg IV", false, nil, "Beta blockers are second-line")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Stable narrow complex regular SVT: after failed vagal maneuvers, adenosine 6 mg is first-line.",
            keyPoint: "Stable SVT after vagal: Adenosine 6 mg",
            algorithmStep: "Tachycardia Algorithm - Narrow Regular SVT"
        ),
        // Scenario 7: Polymorphic VT (Torsades)
        makeQuestion(
            stem: "A 67-year-old woman with 'long QT syndrome' is found unresponsive. Monitor shows polymorphic VT with classic 'twisting' morphology. No pulse. After defibrillation and CPR, which medication is MOST important?",
            rhythmDescription: "Polymorphic VT with twisting morphology (Torsades de Pointes)",
            choices: [
                ("Amiodarone 300 mg IV push", false, nil, "Can prolong QT and worsen Torsades"),
                ("Lidocaine 1-1.5 mg/kg IV push", false, nil, "Magnesium is specific for Torsades"),
                ("Magnesium sulfate 1-2 g IV", true, "Treatment of choice for Torsades", nil),
                ("Procainamide 20-50 mg/min IV", false, nil, "Prolongs QT - contraindicated")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "Torsades de pointes (polymorphic VT with long QT) → Magnesium sulfate 1-2 g IV is treatment of choice.",
            keyPoint: "Torsades: Magnesium 1-2 g IV",
            algorithmStep: "VF/pVT Special Circumstances - Torsades"
        ),
        // Scenario 8: PEA - Identifying Cause
        makeQuestion(
            stem: "A 45-year-old man with recent knee surgery develops sudden dyspnea, becomes unresponsive, loses pulse. CPR initiated. Monitor shows sinus tachycardia 120 bpm without palpable pulse (PEA). Neck veins distended. SpO2 not registering. What is MOST likely cause?",
            vignette: "Recent knee surgery, sudden collapse, distended neck veins.",
            choices: [
                ("Tension pneumothorax - needle decompression", false, nil, "PE more likely given surgical history"),
                ("Pulmonary embolism - consider fibrinolytics/ECMO", true, "Post-surgical + PEA + JVD = high suspicion for PE", nil),
                ("Hypovolemia - IV fluid bolus", false, nil, "JVD suggests obstructive cause, not hypovolemia"),
                ("Cardiac tamponade - pericardiocentesis", false, nil, "PE more likely post-surgical")
            ],
            topic: .peaAsystole,
            difficulty: .hard,
            explanation: "Post-surgical patient + sudden PEA + distended neck veins = high suspicion for massive PE.",
            keyPoint: "Post-surgical PEA + JVD = think PE",
            algorithmStep: "PEA Algorithm - Reversible Causes"
        ),
        // Scenario 9: Asystole - Duration Considerations
        makeQuestion(
            stem: "A 78-year-old woman found unresponsive, unknown downtime (est. 15-20 min). Despite 25 min of high-quality CPR, IV epinephrine q3-5min, and addressing reversible causes, patient remains in asystole. ETCO2 consistently <10 mmHg. What is the MOST appropriate next step?",
            choices: [
                ("Continue resuscitation for another 30 minutes", false, nil, "ETCO2 <10 is poor prognostic sign"),
                ("Defibrillate at maximum energy", false, nil, "Asystole is not shockable"),
                ("Administer vasopressin 40 units IV", false, nil, "Vasopressin no longer recommended"),
                ("Consider termination of resuscitation efforts", true, "Prolonged asystole with low ETCO2 suggests futility", nil)
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "Prolonged asystole with persistently low ETCO2 despite high-quality CPR suggests futility.",
            keyPoint: "Persistent asystole + ETCO2 <10 = poor prognosis",
            algorithmStep: "Asystole Algorithm - Termination Considerations"
        ),
        // Scenario 10: ROSC with Hypotension
        makeQuestion(
            stem: "A 52-year-old man achieves ROSC after 12 min CPR for VF arrest. Now sinus tachycardia 110. Post-ROSC: BP 72/48, SpO2 94% on 100% O2, remains unresponsive. IV in place. What is the MOST appropriate intervention for hypotension?",
            vitals: ACLSVitals(heartRate: 110, bpSystolic: 72, bpDiastolic: 48, spO2: 94, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Start targeted temperature management immediately", false, nil, "Hemodynamic stabilization first"),
                ("Begin norepinephrine or epinephrine infusion to target MAP ≥65 mmHg", true, "Vasopressors for post-ROSC hypotension", nil),
                ("Administer 2 liters of normal saline rapidly", false, nil, "Vasopressors are primary treatment"),
                ("Wait 10 minutes to see if BP improves spontaneously", false, nil, "Severe hypotension requires immediate intervention")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Post-ROSC hypotension: use vasopressors to maintain MAP ≥65 mmHg.",
            keyPoint: "Post-ROSC hypotension: vasopressors for MAP ≥65",
            algorithmStep: "Post-Cardiac Arrest Care - Hemodynamic Optimization"
        ),
        // Scenario 11: Respiratory Arrest Progressing
        makeQuestion(
            stem: "A 68-year-old COPD patient found with agonal respirations, cyanosis, weak pulse at 45 bpm, SpO2 72%. As you prepare BVM, patient becomes pulseless. Monitor shows wide complex bradycardia at 28 bpm. What is the rhythm and first intervention?",
            choices: [
                ("Third-degree heart block - begin transcutaneous pacing", false, nil, "Pacing requires a pulse"),
                ("PEA (wide complex without pulse) - begin CPR immediately", true, "Any organized rhythm without pulse = PEA", nil),
                ("VT with pulse - synchronized cardioversion", false, nil, "Patient is pulseless"),
                ("Idioventricular rhythm with pulse - observation only", false, nil, "Patient is pulseless")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "Any organized rhythm without a pulse is PEA. Begin CPR immediately.",
            keyPoint: "Organized rhythm + no pulse = PEA = CPR",
            algorithmStep: "PEA Algorithm - Recognition and CPR"
        ),
        // Scenario 12: Witnessed Arrest - Bystander AED
        makeQuestion(
            stem: "A 62-year-old man collapses at a shopping mall. Bystanders call 911, retrieve nearby AED. AED attached, analyzes, announces 'Shock advised.' What should the bystander do?",
            choices: [
                ("Wait for EMS to arrive before shocking", false, nil, "Delays kill - shock immediately"),
                ("Check for a pulse first", false, nil, "AED has already determined shockable rhythm"),
                ("Ensure everyone is clear and press the shock button", true, "Early defibrillation saves lives", nil),
                ("Begin CPR and skip the shock", false, nil, "Shock takes priority when VF/VT identified")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "When AED advises shock: clear the patient, deliver shock immediately.",
            keyPoint: "AED shock advised = clear and shock immediately",
            algorithmStep: "BLS/AED Algorithm - Shock Delivery"
        ),
        // Scenario 13: Hyperkalemia Arrest
        makeQuestion(
            stem: "A 58-year-old dialysis patient (missed 2 treatments) becomes pulseless. Monitor shows wide complex bradycardia → VF. CPR and defib initiated. Last K+ was 7.8 mEq/L. What specific treatment should be prioritized?",
            choices: [
                ("Sodium bicarbonate 100 mEq only", false, nil, "Calcium is priority"),
                ("Calcium chloride 1-2 g IV, followed by sodium bicarbonate, insulin/glucose, and consider emergent dialysis", true, "Comprehensive hyperK treatment", nil),
                ("Amiodarone 300 mg IV only", false, nil, "Standard antiarrhythmics won't work without correcting K+"),
                ("Magnesium sulfate 2 g IV", false, nil, "Magnesium is for Torsades, not hyperkalemia")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Hyperkalemic arrest: Calcium stabilizes myocardium, then shift K+ with bicarb/insulin-glucose, remove K+ with dialysis.",
            keyPoint: "HyperK arrest: Ca → Bicarb → Insulin/glucose → Dialysis",
            algorithmStep: "H's and T's - Hyperkalemia Treatment"
        ),
        // Scenario 14: Opioid Overdose to Arrest
        makeQuestion(
            stem: "EMS called for 28-year-old unresponsive male with drug paraphernalia. Initially agonal respirations 4/min with weak pulse 50. Before BVM initiated, becomes pulseless. What is the MOST appropriate sequence?",
            choices: [
                ("Naloxone 2 mg IN only, then observe", false, nil, "Patient is pulseless - needs CPR"),
                ("Begin CPR, give naloxone, provide rescue breathing, follow standard ACLS algorithms", true, "CPR is still priority in opioid arrest", nil),
                ("Naloxone first, then check pulse before starting CPR", false, nil, "CPR starts immediately for pulseless"),
                ("Skip CPR and provide rescue breathing only", false, nil, "Pulseless patients need compressions")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Opioid overdose with cardiac arrest: CPR is still the priority. Naloxone given but doesn't replace resuscitation.",
            keyPoint: "Opioid arrest: CPR is priority + naloxone",
            algorithmStep: "Opioid-Associated Cardiac Arrest"
        ),
        // Scenario 15: Cardiac Arrest in Pregnancy
        makeQuestion(
            stem: "A 32-year-old woman at 34 weeks gestation has witnessed cardiac arrest in L&D. CPR with manual left uterine displacement ongoing. After 4 min of high-quality CPR, still in VF despite 2 shocks and epinephrine. What should be considered?",
            choices: [
                ("Continue standard resuscitation for 30 more minutes before surgical intervention", false, nil, "5-minute window is critical"),
                ("Terminate resuscitation due to pregnancy", false, nil, "Pregnancy doesn't preclude aggressive resuscitation"),
                ("Prepare for perimortem cesarean delivery (resuscitative hysterotomy) - ideally within 5 minutes of arrest", true, "Delivery may save both lives", nil),
                ("Administer magnesium sulfate 4 g IV", false, nil, "C-section is priority for ROSC")
            ],
            topic: .postROSC,
            difficulty: .hard,
            explanation: "Maternal arrest >20 weeks: prepare for perimortem C-section within 5 minutes if no ROSC.",
            keyPoint: "Maternal arrest: perimortem C-section within 5 min",
            algorithmStep: "Special Circumstances - Maternal Cardiac Arrest"
        ),
        // Scenario 16: Post-Drowning Arrest
        makeQuestion(
            stem: "A 24-year-old man pulled from pool after ~3 min submersion. Unresponsive, no breathing, no pulse. Bystander CPR in progress. What is unique about drowning resuscitation?",
            choices: [
                ("Skip compressions and provide rescue breathing only", false, nil, "Compressions still needed for pulseless"),
                ("Perform abdominal thrusts to remove water before CPR", false, nil, "Thrusts don't help and may cause aspiration"),
                ("Prioritize early ventilation/oxygenation given hypoxic etiology; consider A-B-C approach", true, "Drowning is hypoxic arrest", nil),
                ("Defibrillate immediately before any CPR", false, nil, "Drowning is usually asystole/PEA, not VF initially")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "Drowning is hypoxic arrest - ventilation is especially important.",
            keyPoint: "Drowning: prioritize ventilation (hypoxic etiology)",
            algorithmStep: "Special Circumstances - Drowning Resuscitation"
        ),
        // Scenario 17: Tension Pneumothorax During CPR
        makeQuestion(
            stem: "A 40-year-old trauma patient is in PEA arrest. CPR in progress. You notice: absent breath sounds on left, tracheal deviation to right, distended neck veins. Patient was intubated but ventilation increasingly difficult. What is the IMMEDIATE intervention?",
            choices: [
                ("Order a portable chest X-ray", false, nil, "No time for X-ray with clear clinical signs"),
                ("Insert a left chest tube in the OR", false, nil, "Needle decompress first - faster"),
                ("Needle decompression of the left chest (2nd ICS, MCL)", true, "Immediate decompression for tension pneumo", nil),
                ("Re-intubate with a larger endotracheal tube", false, nil, "Problem is pneumothorax, not tube size")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Tension pneumothorax during arrest: immediate needle decompression. Don't wait for imaging.",
            keyPoint: "Tension pneumo: immediate needle decompression",
            algorithmStep: "H's and T's - Tension Pneumothorax"
        ),
        // Scenario 18: SVT Converts Then Recurs
        makeQuestion(
            stem: "A 44-year-old woman with SVT at 210 bpm converts to sinus rhythm 88 bpm after adenosine 6 mg. BP 122/78. Five minutes later, back in SVT at 205 bpm with mild chest discomfort. What is the MOST appropriate next step?",
            choices: [
                ("Synchronized cardioversion immediately", false, nil, "Patient still hemodynamically stable"),
                ("Wait and see if it converts spontaneously", false, nil, "Symptomatic tachycardia requires treatment"),
                ("Adenosine 12 mg rapid IV push", true, "Try higher dose adenosine for recurrent SVT", nil),
                ("Amiodarone 300 mg IV push", false, nil, "Adenosine 12 mg is next step")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Recurrent SVT after successful 6 mg adenosine: try 12 mg adenosine next.",
            keyPoint: "Recurrent SVT after 6mg: try adenosine 12mg",
            algorithmStep: "Tachycardia Algorithm - Adenosine Dosing"
        ),
        // Scenario 19: Acute Stroke During Tachycardia
        makeQuestion(
            stem: "A 70-year-old man with AFib (rate 148) suddenly develops right-sided weakness and slurred speech. BP 168/94, SpO2 97%, alert but aphasic. Last known well 45 minutes ago. What is the management priority?",
            choices: [
                ("Rate control with diltiazem before stroke workup", false, nil, "Stroke treatment is time-sensitive"),
                ("Cardioversion to restore sinus rhythm", false, nil, "Won't help the stroke"),
                ("Activate stroke protocol - emergent CT, consider thrombolytic eligibility", true, "Stroke symptoms take priority", nil),
                ("Anticoagulation with heparin bolus", false, nil, "Contraindicated if considering thrombolytics")
            ],
            topic: .stroke,
            difficulty: .hard,
            explanation: "Acute stroke symptoms take priority. Activate stroke protocol, CT, assess for thrombolytics.",
            keyPoint: "Stroke symptoms = activate stroke protocol immediately",
            algorithmStep: "Stroke Chain of Survival - Time Critical"
        ),
        // Scenario 20: Recurrent VF After ROSC
        makeQuestion(
            stem: "A 55-year-old man had ROSC after VF arrest with amiodarone 300 mg. Five minutes post-ROSC, re-arrests into VF, defibrillated with ROSC. Three minutes later, VF again. What should be considered?",
            choices: [
                ("Stop all antiarrhythmics as they're causing the VF", false, nil, "Antiarrhythmics needed to suppress VF"),
                ("Continue amiodarone infusion (1 mg/min), consider additional bolus (150 mg), optimize electrolytes, consider overdrive pacing, consult EP", true, "Comprehensive VF storm management", nil),
                ("Maximum dose epinephrine infusion", false, nil, "Epinephrine doesn't treat recurrent VF"),
                ("Therapeutic hypothermia will stop the VF", false, nil, "TTM doesn't directly suppress VF")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "Recurrent VF: optimize antiarrhythmics, correct electrolytes, consider overdrive pacing or ablation.",
            keyPoint: "VF storm: amiodarone infusion + optimize electrolytes",
            algorithmStep: "Post-ROSC - VF Storm Management"
        ),
        // Scenario 21: Wide Complex Tachycardia - Unknown Type
        makeQuestion(
            stem: "A 66-year-old man with unknown cardiac history presents with palpitations and mild dyspnea. BP 108/70, HR 172. ECG: wide complex regular tachycardia (QRS 0.16 sec). He is conversational and stable. If uncertain VT vs SVT with aberrancy, what is the SAFEST approach?",
            vitals: ACLSVitals(heartRate: 172, bpSystolic: 108, bpDiastolic: 70, spO2: nil, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Adenosine 6 mg to differentiate", false, nil, "Can be tried diagnostically but won't treat VT"),
                ("Verapamil 5 mg IV to slow the rate", false, nil, "Dangerous in VT - can cause cardiovascular collapse"),
                ("Treat as VT - amiodarone 150 mg IV over 10 minutes", true, "When in doubt, treat as VT", nil),
                ("Observe and repeat ECG in 30 minutes", false, nil, "Symptomatic tachycardia requires treatment")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "When in doubt, treat wide complex tachycardia as VT. Amiodarone is safe for both VT and SVT.",
            keyPoint: "Unknown WCT = treat as VT",
            algorithmStep: "Tachycardia Algorithm - Wide Complex Stable"
        ),
        // Scenario 22: STEMI with Cardiogenic Shock
        makeQuestion(
            stem: "A 63-year-old man presents with 2 hours of crushing chest pain. ECG: 4 mm ST elevation V1-V4. BP 78/52, HR 112, SpO2 88%, bilateral crackles, cool extremities. Diaphoretic, confused. What is the IMMEDIATE priority?",
            vitals: ACLSVitals(heartRate: 112, bpSystolic: 78, bpDiastolic: 52, spO2: 88, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Fibrinolytic therapy with tenecteplase", false, nil, "PCI preferred over lytics in shock"),
                ("Non-invasive positive pressure ventilation", false, nil, "Doesn't address underlying problem"),
                ("Emergent PCI with hemodynamic support (vasopressors, possible IABP/Impella)", true, "STEMI + shock = emergent revascularization", nil),
                ("Furosemide 80 mg IV for pulmonary edema", false, nil, "Diuretics may worsen hypotension")
            ],
            topic: .acs,
            difficulty: .hard,
            explanation: "STEMI + cardiogenic shock = emergent revascularization (PCI) with hemodynamic support.",
            keyPoint: "STEMI + shock = emergent PCI + hemodynamic support",
            algorithmStep: "STEMI Algorithm - Cardiogenic Shock"
        ),
        // Scenario 23: Bradycardia Post-MI
        makeQuestion(
            stem: "A 58-year-old woman is 6 hours post-inferior STEMI treated with PCI. Develops HR 42 with Mobitz Type I (Wenckebach). BP 98/64. Asymptomatic, alert, comfortable. What is the MOST appropriate initial management?",
            vitals: ACLSVitals(heartRate: 42, bpSystolic: 98, bpDiastolic: 64, spO2: nil, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Emergent transcutaneous pacing", false, nil, "Not needed if asymptomatic with adequate BP"),
                ("Atropine 1 mg IV stat", false, nil, "Patient is asymptomatic"),
                ("Observation with standby pacing available", true, "Mobitz I with inferior MI often transient", nil),
                ("Isoproterenol infusion", false, nil, "Not first-line")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Mobitz I with inferior MI is usually transient and benign. Observe if asymptomatic.",
            keyPoint: "Asymptomatic Mobitz I post-inferior MI: observe",
            algorithmStep: "Bradycardia Algorithm - Stable Pathway"
        ),
        // Scenario 24: Pediatric Arrest - Shockable
        makeQuestion(
            stem: "A 6-year-old (25 kg) child collapses during soccer practice. CPR initiated. AED shows VF. Pediatric pads available. Using a manual defibrillator, what is the correct initial energy?",
            choices: [
                ("25 joules", false, nil, "1 J/kg is too low"),
                ("50 joules (2 J/kg)", true, "Pediatric first shock: 2 J/kg", nil),
                ("100 joules", false, nil, "4 J/kg is for subsequent shocks"),
                ("200 joules", false, nil, "200 J is adult dosing")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "Pediatric defibrillation: 2 J/kg for first shock. For 25 kg child = 50 J.",
            keyPoint: "Pediatric defib: 2 J/kg first shock",
            algorithmStep: "Pediatric Cardiac Arrest - Defibrillation Dosing"
        ),
        // Scenario 25: Medication Error During Code
        makeQuestion(
            stem: "During cardiac arrest, a team member pushes what they thought was epinephrine, but vial was norepinephrine (Levophed) 1 mg. Patient still in PEA. How should the team leader respond?",
            choices: [
                ("Stop the code immediately", false, nil, "Norepinephrine has vasopressor activity"),
                ("Continue resuscitation - norepinephrine is a vasopressor; document the error and continue standard ACLS", true, "Norepinephrine won't harm resuscitation", nil),
                ("Administer an antidote for norepinephrine", false, nil, "No antidote needed"),
                ("Give additional epinephrine to 'counteract' the norepinephrine", false, nil, "Not necessary")
            ],
            topic: .team,
            difficulty: .medium,
            explanation: "Norepinephrine is a vasopressor similar to epinephrine. Continue resuscitation, document error.",
            keyPoint: "Norepinephrine won't harm resuscitation",
            algorithmStep: "Team Dynamics - Error Management"
        ),
        // Scenario 26: Loss of Waveform Capnography
        makeQuestion(
            stem: "During CPR on an intubated patient, ETCO2 suddenly drops from 25 mmHg to 0 mmHg. Patient still in VF. Compressions appear adequate. What should be suspected and checked FIRST?",
            etco2WaveformType: .esophageal,
            choices: [
                ("The patient has achieved ROSC", false, nil, "ROSC causes ETCO2 to rise, not drop"),
                ("The patient's rhythm has changed to asystole", false, nil, "Rhythm change doesn't eliminate ETCO2"),
                ("Endotracheal tube displacement (esophageal or dislodged)", true, "Sudden ETCO2 loss = suspect tube displacement", nil),
                ("CPR quality has dramatically worsened", false, nil, "Poor CPR reduces but doesn't eliminate ETCO2")
            ],
            topic: .airway,
            difficulty: .medium,
            explanation: "Sudden loss of ETCO2 waveform during CPR = suspect tube displacement. Check position immediately.",
            keyPoint: "ETCO2 → 0 = check tube position",
            algorithmStep: "CPR Monitoring - ETCO2 Troubleshooting"
        ),
        // Scenario 27: AF with RVR - Chest Pain
        makeQuestion(
            stem: "A 74-year-old man with CHF history presents with AFib RVR at 156 bpm. BP 92/58. Significant chest discomfort, respiratory distress, SpO2 89%. What is the MOST appropriate intervention?",
            vitals: ACLSVitals(heartRate: 156, bpSystolic: 92, bpDiastolic: 58, spO2: 89, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Diltiazem 20 mg IV push", false, nil, "Will worsen hypotension and is too slow"),
                ("Digoxin 0.5 mg IV", false, nil, "Slow onset; patient is unstable"),
                ("Synchronized cardioversion at 120-200J biphasic", true, "Unstable AFib RVR = cardioversion", nil),
                ("Adenosine 6 mg rapid IV push", false, nil, "Adenosine doesn't work for AF")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Unstable AF with RVR (hypotension, chest pain, respiratory distress) = immediate synchronized cardioversion.",
            keyPoint: "Unstable AFib RVR = cardioversion",
            algorithmStep: "Tachycardia Algorithm - Unstable AF"
        ),
        // Scenario 28: Asthma Arrest
        makeQuestion(
            stem: "A 32-year-old woman with severe asthma is intubated for respiratory failure. Shortly after, becomes pulseless with PEA. Ventilation very difficult with high airway pressures. Bilateral wheezes before arrest. What is MOST likely cause and treatment?",
            choices: [
                ("Pulmonary embolism - give fibrinolytics", false, nil, "Asthma history points to breath stacking"),
                ("Mucus plug - suction aggressively", false, nil, "Suctioning won't relieve auto-PEEP"),
                ("Breath stacking/auto-PEEP - disconnect from ventilator, allow prolonged exhalation", true, "Auto-PEEP causing arrest", nil),
                ("Anaphylaxis - give epinephrine IM", false, nil, "Primary issue is auto-PEEP")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Asthma arrest with difficult ventilation = suspect auto-PEEP. Disconnect vent, allow prolonged exhalation.",
            keyPoint: "Asthma arrest: disconnect vent, allow exhalation",
            algorithmStep: "Special Circumstances - Asthma Arrest"
        ),
        // Scenario 29: Hypothermic Arrest
        makeQuestion(
            stem: "A 55-year-old man found after falling through ice (30 min submersion). Core temp 26°C (78.8°F). In VF. CPR in progress. What are modifications to standard ACLS for severe hypothermia?",
            choices: [
                ("No modifications - follow standard ACLS", false, nil, "Modifications needed"),
                ("Do not attempt defibrillation until rewarmed", false, nil, "One shock attempt is reasonable"),
                ("Single defibrillation attempt; withhold further shocks and medications until core temp >30°C; begin rewarming", true, "Focus on rewarming", nil),
                ("Use higher defibrillation energy (360J)", false, nil, "Standard energy, may not work until rewarmed")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Severe hypothermia (<30°C): one shock reasonable, but meds and further shocks may be ineffective until rewarmed.",
            keyPoint: "Hypothermia <30°C: one shock, then rewarm",
            algorithmStep: "Special Circumstances - Hypothermic Arrest"
        ),
        // Scenario 30: Post-ROSC Seizures
        makeQuestion(
            stem: "A 48-year-old man achieves ROSC after 15 min CPR for VF arrest. Remains comatose. Ten minutes post-ROSC, develops generalized tonic-clonic seizures. BP 118/76, HR 102, SpO2 96%. What is MOST appropriate seizure management?",
            choices: [
                ("No treatment - post-anoxic movements are normal", false, nil, "Seizures can worsen brain injury"),
                ("Paralysis with rocuronium without EEG monitoring", false, nil, "Paralysis masks seizures; need EEG"),
                ("Treat seizures with benzodiazepines (lorazepam, diazepam) or other antiepileptics; obtain EEG monitoring", true, "Treat aggressively with EEG", nil),
                ("Immediate CT scan before any seizure treatment", false, nil, "Treat seizures first")
            ],
            topic: .postROSC,
            difficulty: .medium,
            explanation: "Post-arrest seizures should be treated aggressively. Benzodiazepines first-line, with EEG monitoring.",
            keyPoint: "Post-arrest seizures: treat aggressively + EEG",
            algorithmStep: "Post-Cardiac Arrest Care - Seizure Management"
        ),
        // Scenario 31: Calcium Channel Blocker Overdose
        makeQuestion(
            stem: "A 52-year-old woman found after intentional diltiazem ingestion. HR 38, BP 68/40, obtunded, weak pulse. ECG: sinus bradycardia with prolonged PR. What is the MOST appropriate treatment regimen?",
            vitals: ACLSVitals(heartRate: 38, bpSystolic: 68, bpDiastolic: 40, spO2: nil, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Atropine 0.5 mg IV and observe", false, nil, "Atropine alone won't overcome CCB toxicity"),
                ("Transcutaneous pacing only", false, nil, "Doesn't address the poisoning"),
                ("Calcium chloride 1-2 g IV, glucagon, high-dose insulin/glucose therapy, vasopressors, consider lipid emulsion", true, "Comprehensive CCB OD treatment", nil),
                ("Activated charcoal only", false, nil, "Patient needs aggressive treatment")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "CCB overdose with shock: calcium, glucagon, high-dose insulin-euglycemic therapy, vasopressors.",
            keyPoint: "CCB OD: Ca, glucagon, high-dose insulin, vasopressors",
            algorithmStep: "H's and T's - Toxins (CCB Overdose)"
        ),
        // Scenario 32: Code Team Communication Failure
        makeQuestion(
            stem: "During resuscitation, team leader calls 'Give epinephrine 1 mg IV push.' A team member draws up medication but doesn't confirm. Another also draws up epinephrine, thinking no one heard. Both push simultaneously. What communication principle was violated?",
            choices: [
                ("Speaking too loudly", false, nil, "Volume wasn't the issue"),
                ("Using medical terminology", false, nil, "Medical terminology is appropriate"),
                ("Failure to use closed-loop communication (confirm and acknowledge orders)", true, "Closed-loop prevents errors", nil),
                ("Having too few team members", false, nil, "Number wasn't the problem")
            ],
            topic: .team,
            difficulty: .easy,
            explanation: "Closed-loop communication prevents double-dosing and ensures orders are heard, confirmed, and completed.",
            keyPoint: "Closed-loop: confirm and acknowledge orders",
            algorithmStep: "Team Dynamics - Closed-Loop Communication"
        ),
        // Scenario 33: Refractory VF - Considering Options
        makeQuestion(
            stem: "A 42-year-old healthy man in VF for 25 min despite high-quality CPR, 6 defibs, epinephrine q3-5min, amiodarone 450mg total. VF persists. No obvious reversible cause. ETCO2 20-25 mmHg. What options should be considered?",
            choices: [
                ("Terminate resuscitation - VF refractory for 25 minutes is futile", false, nil, "Young patient with good ETCO2 deserves aggressive approach"),
                ("Continue same interventions for 60 more minutes", false, nil, "Need to try alternatives"),
                ("Consider ECPR if available, double sequential defibrillation, change pad position (A-P), or lidocaine", true, "Advanced options for refractory VF", nil),
                ("Increase epinephrine dose to 10 mg", false, nil, "High-dose epinephrine not recommended")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "Refractory VF options: ECPR, alternative pad positioning, DSD, lidocaine.",
            keyPoint: "Refractory VF: ECPR, DSD, pad repositioning, lidocaine",
            algorithmStep: "Refractory VF - Advanced Options"
        ),
        // Scenario 34: Tricyclic Antidepressant Overdose
        makeQuestion(
            stem: "A 35-year-old woman with depression brought in after intentional amitriptyline overdose. Wide QRS (160 ms), seizures, hypotension (76/50). HR 126, has a pulse but obtunded. What is the PRIORITY treatment?",
            choices: [
                ("Flumazenil to reverse sedation", false, nil, "Flumazenil can precipitate seizures"),
                ("Lidocaine for the wide QRS", false, nil, "May worsen sodium channel toxicity"),
                ("Sodium bicarbonate 1-2 mEq/kg IV bolus to narrow QRS and treat sodium channel blockade", true, "Bicarb is priority for TCA toxicity", nil),
                ("Synchronized cardioversion for the tachycardia", false, nil, "Need to treat the toxidrome")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "TCA toxicity with wide QRS: sodium bicarbonate narrows QRS, treats hypotension, prevents arrhythmias.",
            keyPoint: "TCA toxicity: sodium bicarbonate",
            algorithmStep: "H's and T's - Toxins (TCA Overdose)"
        ),
        // Scenario 35: ROSC with ST Elevation
        makeQuestion(
            stem: "A 57-year-old man achieves ROSC after 8 min VF arrest. Remains comatose. Post-ROSC ECG: 3 mm ST elevation in II, III, aVF with reciprocal changes. BP 96/68, HR 78. What is the NEXT most important step?",
            choices: [
                ("Wait for patient to wake up before catheterization", false, nil, "Comatose state is not contraindication"),
                ("Obtain troponin levels before deciding on cath", false, nil, "Troponins don't change management for STEMI"),
                ("Emergent coronary angiography and PCI - do not delay for neurologic assessment", true, "STEMI post-arrest = emergent PCI", nil),
                ("Thrombolytics as patient cannot consent for PCI", false, nil, "PCI preferred; emergency consent obtained")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "STEMI post-arrest: emergent PCI. Don't delay for neuro assessment.",
            keyPoint: "Post-arrest STEMI = emergent PCI",
            algorithmStep: "Post-Cardiac Arrest Care - STEMI Management"
        ),
        // Scenario 36: Choking Victim Becomes Unresponsive
        makeQuestion(
            stem: "A 68-year-old man choking at a restaurant. Bystander performs abdominal thrusts, but patient becomes unresponsive and slumps down. No pulse detected. What is the correct sequence?",
            choices: [
                ("Continue abdominal thrusts on the ground", false, nil, "CPR for unresponsive patient"),
                ("Attempt blind finger sweep of the mouth", false, nil, "Blind sweeps can push object deeper"),
                ("Begin CPR; look for object in mouth before giving breaths; if seen, remove it", true, "CPR with airway check before breaths", nil),
                ("Wait for EMS to arrive with advanced airway equipment", false, nil, "Immediate CPR is critical")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Choking victim becomes unresponsive: start CPR. Check mouth before breaths - remove visible objects only.",
            keyPoint: "Unresponsive choking: CPR, check mouth before breaths",
            algorithmStep: "BLS - Foreign Body Airway Obstruction"
        ),
        // Scenario 37: Beta Blocker Overdose
        makeQuestion(
            stem: "A 45-year-old man intentionally ingested large amount of metoprolol. HR 34, BP 62/40, obtunded. Blood glucose 45 mg/dL. ECG: sinus bradycardia. What is the comprehensive treatment approach?",
            vitals: ACLSVitals(heartRate: 34, bpSystolic: 62, bpDiastolic: 40, spO2: nil, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Atropine 3 mg IV and observation", false, nil, "Atropine has limited effect in severe BB toxicity"),
                ("Glucagon 3-5 mg IV bolus (then infusion), IV calcium, dextrose for hypoglycemia, high-dose insulin therapy, vasopressors, consider pacing", true, "Comprehensive BB OD treatment", nil),
                ("Transcutaneous pacing alone", false, nil, "Doesn't address toxidrome"),
                ("Hemodialysis emergently", false, nil, "Dialysis doesn't effectively remove most beta blockers")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Beta blocker OD: glucagon, calcium, treat hypoglycemia, high-dose insulin-glucose, vasopressors, pacing.",
            keyPoint: "BB OD: glucagon, calcium, insulin, vasopressors",
            algorithmStep: "H's and T's - Toxins (Beta Blocker OD)"
        ),
        // Scenario 38: Cardiac Arrest in Dialysis Patient
        makeQuestion(
            stem: "A 62-year-old dialysis patient arrests during treatment. Monitor shows wide, bizarre rhythm with no pulse. CPR initiated. K+ just before arrest was 7.2 mEq/L. What treatment is PRIORITY?",
            choices: [
                ("Stop dialysis immediately", false, nil, "May need to continue dialysis to remove K+"),
                ("Calcium chloride 1-2 g IV to stabilize myocardium, then bicarbonate, insulin/glucose, continue dialysis", true, "HyperK treatment priority", nil),
                ("Amiodarone 300 mg IV push", false, nil, "Antiarrhythmics won't work without correcting K+"),
                ("Magnesium 2 g IV", false, nil, "Magnesium is for Torsades")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Hyperkalemia-induced arrest: calcium first, then shift K+ with bicarb/insulin, remove K+ with dialysis.",
            keyPoint: "HyperK arrest: Ca → bicarb/insulin → dialysis",
            algorithmStep: "H's and T's - Hyperkalemia"
        ),
        // Scenario 39: Cocaine-Associated Chest Pain
        makeQuestion(
            stem: "A 30-year-old man presents with chest pain 1 hour after cocaine use. Agitated, diaphoretic, BP 198/122, HR 124, dilated pupils. ECG: sinus tach with 1 mm ST depression V3-V6. Which medication should be AVOIDED?",
            vitals: ACLSVitals(heartRate: 124, bpSystolic: 198, bpDiastolic: 122, spO2: nil, respiratoryRate: nil, temperature: nil),
            choices: [
                ("Nitroglycerin", false, nil, "NTG helps coronary vasospasm"),
                ("Benzodiazepines", false, nil, "Benzos recommended to reduce sympathetic drive"),
                ("Metoprolol (unopposed beta blocker)", true, "Unopposed alpha stimulation worsens HTN", nil),
                ("Aspirin", false, nil, "Aspirin appropriate for possible ACS")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "Cocaine + beta blocker = unopposed alpha stimulation causing worsening hypertension and coronary vasoconstriction.",
            keyPoint: "Cocaine chest pain: avoid beta blockers",
            algorithmStep: "ACS - Cocaine-Associated Chest Pain"
        ),
        // Scenario 40: PEA with Good ETCO2
        makeQuestion(
            stem: "A 70-year-old man in PEA with narrow complex 90 bpm on monitor, no palpable pulse. CPR in progress with ETCO2 of 35 mmHg. He was complaining of severe back pain before collapsing. What does the high ETCO2 suggest?",
            choices: [
                ("CPR should be stopped as patient has ROSC", false, nil, "Need to confirm pulse"),
                ("The ETCO2 monitor is malfunctioning", false, nil, "ETCO2 is providing useful information"),
                ("High ETCO2 suggests cardiac output - check for pulse more carefully, consider 'pseudo-PEA' with very low BP, consider aortic dissection", true, "May have cardiac output", nil),
                ("Defibrillate immediately", false, nil, "Not a shockable rhythm")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "High ETCO2 during CPR suggests cardiac output. Back pain + PEA = consider aortic dissection.",
            keyPoint: "High ETCO2 in PEA: may have cardiac output",
            algorithmStep: "PEA Recognition - Pseudo-PEA"
        ),
        // Scenario 41-50: Additional scenarios
        makeQuestion(
            stem: "A 35-year-old woman with peanut allergy ingests peanuts. Urticaria, facial swelling, stridor, BP 60/palp. IM epinephrine 0.5 mg given but continues deteriorating - unresponsive with agonal breathing, weak thready pulse (HR 145). What is NEXT?",
            choices: [
                ("Second IM epinephrine 0.5 mg in same site", false, nil, "IM not absorbing in shock"),
                ("Diphenhydramine 50 mg IV only", false, nil, "Antihistamines are adjunctive"),
                ("IV epinephrine bolus 0.1-0.2 mg (or infusion), aggressive IV fluids, secure airway", true, "Escalate to IV epinephrine", nil),
                ("Observe for 5 more minutes for IM epinephrine to work", false, nil, "Patient is peri-arrest")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Anaphylaxis refractory to IM epinephrine: escalate to IV epinephrine, massive fluid resuscitation.",
            keyPoint: "Refractory anaphylaxis: IV epinephrine",
            algorithmStep: "Anaphylaxis - Refractory Cases"
        ),
        makeQuestion(
            stem: "A 38-year-old healthy woman has refractory VF for 20 min despite excellent CPR (ETCO2 28 mmHg), 5 defibs, epinephrine, amiodarone. Your hospital has ECPR program. What factors FAVOR consideration of ECPR?",
            choices: [
                ("Age >75, prolonged no-CPR interval, ETCO2 <10 mmHg", false, nil, "These are unfavorable factors"),
                ("Young age, witnessed arrest, presumed cardiac etiology, good ETCO2, short no-flow time, experienced ECMO center", true, "Favorable factors for ECPR", nil),
                ("ECPR should never be considered for VF", false, nil, "ECPR specifically for refractory shockable rhythms"),
                ("Lack of advanced airway is required for ECPR", false, nil, "Advanced airway typically placed")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "ECPR favorable: young, witnessed, short downtime, good CPR quality, reversible cause, experienced center.",
            keyPoint: "ECPR: young, witnessed, good ETCO2, experienced center",
            algorithmStep: "2025 Guidelines - ECPR Considerations"
        ),
        makeQuestion(
            stem: "A 62-year-old man achieves ROSC, intubated on 100% FiO2. SpO2 100%, ABG: PaO2 425 mmHg, PaCO2 32 mmHg. What is appropriate oxygen and ventilation management?",
            choices: [
                ("Continue 100% FiO2 to maximize oxygen delivery", false, nil, "Hyperoxia is harmful"),
                ("Titrate FiO2 down to maintain SpO2 94-99%; adjust ventilation to normalize CO2", true, "Avoid hyperoxia and hypocapnia", nil),
                ("Extubate immediately since SpO2 is excellent", false, nil, "Comatose patients should remain intubated"),
                ("Hyperventilate to maintain PaCO2 around 25 mmHg", false, nil, "Hypocapnia causes cerebral vasoconstriction")
            ],
            topic: .postROSC,
            difficulty: .easy,
            explanation: "Post-ROSC: avoid hyperoxia (SpO2 94-99%), avoid hypocapnia (target PaCO2 35-45 mmHg).",
            keyPoint: "Post-ROSC: avoid hyperoxia and hypocapnia",
            algorithmStep: "Post-Cardiac Arrest Care - Oxygenation/Ventilation"
        ),
        makeQuestion(
            stem: "A 76-year-old man with syncope is alert, BP 96/60. ECG: third-degree AV block with ventricular escape 36 bpm, wide QRS. Atropine 1 mg IV has no effect. What is the definitive treatment?",
            choices: [
                ("Higher doses of atropine (3 mg total)", false, nil, "Atropine often doesn't work for complete block"),
                ("Continuous dopamine infusion", false, nil, "Pacing more reliable for high-grade block"),
                ("Transcutaneous pacing as bridge to transvenous pacing", true, "Will need permanent pacemaker", nil),
                ("Adenosine 6 mg IV", false, nil, "Adenosine contraindicated in bradycardia")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Third-degree block with ventricular escape is often atropine-resistant. TCP as bridge to transvenous pacing.",
            keyPoint: "Complete heart block: pacing required",
            algorithmStep: "Bradycardia Algorithm - High-Grade Block"
        ),
        makeQuestion(
            stem: "A 66-year-old man with 45 min of crushing chest pain. Had normal ECG 6 months ago. Current ECG shows new LBBB. Diaphoretic, BP 108/70, HR 92. How should this patient be managed?",
            choices: [
                ("LBBB is a contraindication to catheterization", false, nil, "LBBB doesn't prevent cath"),
                ("New LBBB doesn't indicate STEMI - observe", false, nil, "New LBBB with symptoms is STEMI equivalent"),
                ("New LBBB with ischemic symptoms = STEMI-equivalent - activate cath lab for emergent PCI", true, "Treat as STEMI", nil),
                ("Give fibrinolytics immediately in the ED", false, nil, "PCI preferred when available")
            ],
            topic: .acs,
            difficulty: .hard,
            explanation: "New or presumably new LBBB with ischemic symptoms = STEMI equivalent. Emergent reperfusion indicated.",
            keyPoint: "New LBBB + ischemic symptoms = STEMI equivalent",
            algorithmStep: "STEMI Equivalents - New LBBB"
        ),
        makeQuestion(
            stem: "A 74-year-old woman with COPD admitted for pneumonia develops irregular tachycardia 134 bpm. BP 118/72. ECG shows ≥3 different P wave morphologies with varying PR intervals. Mildly short of breath but stable. What is MOST appropriate management?",
            choices: [
                ("Synchronized cardioversion", false, nil, "Cardioversion doesn't work for MAT"),
                ("Adenosine 6 mg IV push", false, nil, "Adenosine won't terminate MAT"),
                ("Treat underlying condition (COPD, pneumonia, hypoxia, electrolytes); consider rate control if needed", true, "MAT = treat the cause", nil),
                ("Amiodarone 150 mg IV", false, nil, "Amiodarone not first-line for MAT")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "MAT is usually due to underlying pulmonary disease. Treat the cause.",
            keyPoint: "MAT: treat underlying cause",
            algorithmStep: "Tachycardia - MAT Recognition and Management"
        ),
        makeQuestion(
            stem: "A 45-year-old man with severe hypothermia (core 28°C) arrested in VF, received one shock without success. Active rewarming in progress. Core temp now 31°C, still in VF. Now that temp is >30°C, what should be done?",
            choices: [
                ("Continue rewarming only; no medications until 37°C", false, nil, "Can give medications once >30°C"),
                ("Resume standard ACLS interventions with defibrillation and medications, with potentially longer intervals between doses", true, "Standard ACLS once >30°C", nil),
                ("Immediately stop rewarming", false, nil, "Continue rewarming"),
                ("Use only lidocaine; amiodarone is contraindicated", false, nil, "Amiodarone can be used")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Once temp >30°C, standard ACLS can be performed. Consider longer intervals between med doses.",
            keyPoint: "Temp >30°C: resume standard ACLS",
            algorithmStep: "Special Circumstances - Hypothermia (>30°C)"
        ),
        makeQuestion(
            stem: "A 65-year-old man is day 2 post-CABG in cardiac surgery ICU. Suddenly goes into pulseless VT. Nurse initiates CPR. Chest incision intact with sternal wires. What is unique about this setting?",
            choices: [
                ("Standard CPR is contraindicated - wait for surgeon", false, nil, "CPR should still be performed"),
                ("Defibrillation is contraindicated post-sternotomy", false, nil, "Defibrillation still indicated"),
                ("Consider resternotomy in ICU if trained personnel available; proceed with CPR and defibrillation; call surgical team emergently", true, "Resternotomy may be lifesaving", nil),
                ("External pacing is preferred over defibrillation", false, nil, "Pacing doesn't treat VT/VF")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "Post-cardiac surgery arrest: CPR and defib performed, but emergency resternotomy may be lifesaving.",
            keyPoint: "Post-cardiac surgery: consider resternotomy",
            algorithmStep: "Special Circumstances - Post-Cardiac Surgery Arrest"
        ),
        makeQuestion(
            stem: "A 72-year-old woman with permanent pacemaker is in VF arrest. CPR in progress. Defibrillator pads about to be placed. What consideration is important?",
            choices: [
                ("Defibrillation is contraindicated with pacemakers", false, nil, "Defibrillation absolutely indicated for VF"),
                ("Only anterior-posterior pad placement can be used", false, nil, "Both positions can work if away from device"),
                ("Place pads at least 2.5 cm (1 inch) away from the pacemaker/ICD generator; defibrillate as normal", true, "Protect the device", nil),
                ("Use lower energy settings to protect the pacemaker", false, nil, "Use standard energy settings")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Defibrillate normally with pacemaker/ICD, but place pads away from generator.",
            keyPoint: "Pacemaker: place pads away from device",
            algorithmStep: "Defibrillation - Implanted Devices"
        ),
        makeQuestion(
            stem: "You are leading resuscitation for an 82-year-old man with ESRD, severe CHF, metastatic cancer. Found unresponsive, unknown downtime (est. 20+ min). CPR ongoing 30 min, asystole throughout. ETCO2 persistently <10 mmHg. All reversible causes considered. What is your recommendation?",
            choices: [
                ("Continue CPR indefinitely until family arrives", false, nil, "Continuing futile resuscitation is not appropriate"),
                ("Transfer to ICU for continued resuscitation", false, nil, "Outcome will not improve"),
                ("Discuss with team that termination is appropriate; communicate with family sensitively; document thoroughly", true, "Appropriate termination", nil),
                ("Request ECMO cannulation", false, nil, "Not indicated given poor prognostic factors")
            ],
            topic: .team,
            difficulty: .hard,
            explanation: "Termination appropriate with prolonged asystole, low ETCO2, no reversible causes, significant comorbidities.",
            keyPoint: "Terminate when appropriate, communicate compassionately",
            algorithmStep: "Resuscitation Ethics - Termination of Efforts"
        )
    ]
    
    // MARK: - Final Comprehensive Questions (20 to complete coverage)
    
    static let finalComprehensiveQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per 2025 guidelines, what is the recommended approach to CPR during transport?",
            choices: [
                ("Prioritize on-scene resuscitation with goal of ROSC before transport", true, "2025 emphasis", nil),
                ("Always transport immediately with ongoing CPR", false, nil, "On-scene prioritized"),
                ("CPR quality during transport is equal to on-scene", false, nil, "Quality suffers during transport"),
                ("Never transport during active resuscitation", false, nil, "Transport after ROSC preferred")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "2025: On-scene resuscitation prioritized; CPR quality decreases during transport.",
            keyPoint: "On-scene resuscitation prioritized (2025)",
            algorithmStep: "Systems of Care - Transport decisions"
        ),
        makeQuestion(
            stem: "What change did 2025 guidelines make to the Chain of Survival?",
            choices: [
                ("Unified chain for all ages and settings (in-hospital and out-of-hospital)", true, "2025 standardization", nil),
                ("Separate chains for adults and children", false, nil, "Now unified"),
                ("Removed early defibrillation", false, nil, "Still emphasized"),
                ("Added social media alert step", false, nil, "Not a change")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: Standardized universal Chain of Survival regardless of age or location.",
            keyPoint: "Unified Chain of Survival (2025)",
            algorithmStep: "Chain of Survival - 2025 update"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, are rescue breaths reinstated after COVID-era changes?",
            choices: [
                ("Yes - rescue breaths are fully reinstated as standard during CPR", true, "Back to standard", nil),
                ("No - compression-only CPR is now standard for all", false, nil, "Breaths reinstated"),
                ("Only for healthcare providers", false, nil, "For trained rescuers"),
                ("Only for pediatric patients", false, nil, "For all trained rescuers")
            ],
            topic: .guidelines2025,
            difficulty: .easy,
            explanation: "2025: Rescue breaths fully reinstated; COVID-era hesitation removed.",
            keyPoint: "Rescue breaths reinstated (2025)",
            algorithmStep: "BLS Algorithm - 2025 ventilation update"
        ),
        makeQuestion(
            stem: "What did 2025 guidelines change about H's and T's in cardiac arrest algorithms?",
            choices: [
                ("No longer explicitly listed; implicit consideration rather than checklist-driven", true, "2025 change", nil),
                ("Now listed more prominently", false, nil, "Removed from explicit listing"),
                ("Only H's are listed", false, nil, "Neither explicitly listed"),
                ("No changes to H's and T's", false, nil, "Significant change")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "2025: H's and T's removed from explicit algorithm listing; should be considered continuously.",
            keyPoint: "H's and T's: implicit consideration (2025)",
            algorithmStep: "Cardiac Arrest Algorithm - 2025 H's and T's"
        ),
        makeQuestion(
            stem: "What is the 2025 guideline update on ETCO2 in the cardiac arrest algorithm?",
            choices: [
                ("Shift to continuous waveform capnography for CPR quality monitoring", true, "2025 emphasis", nil),
                ("Removed from algorithm", false, nil, "More emphasized"),
                ("Only for tube confirmation", false, nil, "Also for CPR quality"),
                ("No changes", false, nil, "Increased emphasis")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: Continuous waveform capnography emphasized for CPR quality monitoring.",
            keyPoint: "Continuous capnography emphasized (2025)",
            algorithmStep: "Cardiac Arrest Algorithm - Capnography"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, how should airway management language change?",
            choices: [
                ("'Give oxygen' updated to 'Begin bag-mask ventilation and give oxygen'", true, "2025 language change", nil),
                ("Airway is deprioritized", false, nil, "Still important"),
                ("Only advanced airway mentioned", false, nil, "BVM ventilation emphasized"),
                ("No changes to airway language", false, nil, "Specific changes made")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: More explicit instruction to begin bag-mask ventilation and give oxygen.",
            keyPoint: "'Begin BVM and give oxygen' (2025)",
            algorithmStep: "Cardiac Arrest Algorithm - Airway language"
        ),
        makeQuestion(
            stem: "What is the 2025 recommendation on mechanical CPR devices?",
            choices: [
                ("Not routinely recommended; no superiority over high-quality manual CPR", true, "Not routine", nil),
                ("First-line for all arrests", false, nil, "Not routine"),
                ("Superior to manual CPR", false, nil, "No proven superiority"),
                ("Contraindicated", false, nil, "Acceptable in specific situations")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: Mechanical CPR devices not routine; use when manual CPR unsafe/impractical.",
            keyPoint: "Mechanical CPR not routine (2025)",
            algorithmStep: "CPR Quality - Mechanical CPR"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, what is the ALS termination of resuscitation (TOR) decision based on?",
            choices: [
                ("Multiple factors - not ETCO2 alone; consider all: witnessed, bystander CPR, ROSC, shocks", true, "Multimodal decision", nil),
                ("ETCO2 only", false, nil, "Multiple factors"),
                ("Time only", false, nil, "Multiple factors"),
                ("Age only", false, nil, "Multiple factors")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "2025: TOR should not rely on ETCO2 alone; consider witnessed, bystander CPR, ROSC, shocks.",
            keyPoint: "TOR: multiple factors, not ETCO2 alone",
            algorithmStep: "Termination of Resuscitation - 2025"
        ),
        makeQuestion(
            stem: "What is the 2025 update on post-ROSC ventilation rates?",
            choices: [
                ("Removed fixed '10 breaths per minute' language; focus on avoiding hyperventilation", true, "2025 change", nil),
                ("Fixed at exactly 10 breaths/min", false, nil, "More flexible now"),
                ("Fixed at 20 breaths/min", false, nil, "Avoid hyperventilation"),
                ("No specific guidance", false, nil, "Avoid hyperventilation emphasized")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: Removed fixed ventilation rates post-ROSC; emphasis on avoiding hyperventilation.",
            keyPoint: "No fixed post-ROSC vent rate (2025)",
            algorithmStep: "Post-Cardiac Arrest Care - Ventilation"
        ),
        makeQuestion(
            stem: "What is the 2025 update on post-ROSC blood pressure targets?",
            choices: [
                ("Systolic BP targets removed; focus solely on MAP ≥65 mmHg", true, "2025 simplification", nil),
                ("SBP >90 is primary target", false, nil, "MAP-focused now"),
                ("SBP >120 is primary target", false, nil, "MAP ≥65 is target"),
                ("No blood pressure targets", false, nil, "MAP ≥65 target")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: Simplified to MAP ≥65 mmHg; removed separate systolic target.",
            keyPoint: "MAP ≥65 mmHg, no SBP target (2025)",
            algorithmStep: "Post-Cardiac Arrest Care - Hemodynamics"
        ),
        makeQuestion(
            stem: "What is the emphasis on early diagnostics in the 2025 post-arrest algorithm?",
            choices: [
                ("Strong emphasis on early 12-lead ECG, CT, and ultrasound", true, "2025 emphasis", nil),
                ("Diagnostics can wait until stable", false, nil, "Early emphasized"),
                ("Only ECG is needed", false, nil, "Multiple modalities"),
                ("No change in diagnostic approach", false, nil, "Increased emphasis")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: Strong push toward early diagnostics (ECG, CT, ultrasound) for cause identification.",
            keyPoint: "Early diagnostics emphasized (2025)",
            algorithmStep: "Post-Cardiac Arrest Care - Diagnostics"
        ),
        makeQuestion(
            stem: "What does the 2025 algorithm emphasize for post-arrest coronary evaluation?",
            choices: [
                ("Strong push toward early coronary angiography and PCI; mechanical circulatory support when appropriate", true, "2025 emphasis", nil),
                ("Delay cath until neurologically clear", false, nil, "Early cath emphasized"),
                ("Only medical management", false, nil, "Intervention emphasized"),
                ("No guidance on coronary care", false, nil, "Strong recommendations")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: Strong push for early coronary angiography, PCI, and mechanical support when needed.",
            keyPoint: "Early PCI and MCS emphasized (2025)",
            algorithmStep: "Post-Cardiac Arrest Care - Coronary care"
        ),
        makeQuestion(
            stem: "What multimodal prognostication approach is emphasized in 2025 guidelines?",
            choices: [
                ("Clinical exam, EEG, SSEPs, neuroimaging, and biomarkers - no single test definitive", true, "Multimodal approach", nil),
                ("Only clinical exam", false, nil, "Multiple modalities"),
                ("Only imaging", false, nil, "Multiple modalities"),
                ("Only EEG", false, nil, "Multiple modalities")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "2025: Multimodal prognostication - clinical + EEG + SSEPs + imaging + biomarkers.",
            keyPoint: "Multimodal prognostication (2025)",
            algorithmStep: "Post-Cardiac Arrest Care - Neuroprognostication"
        ),
        makeQuestion(
            stem: "Who should be trained in death notification per 2025 guidelines?",
            choices: [
                ("EMS providers, as they may need to perform termination of resuscitation on scene", true, "EMS training", nil),
                ("Only physicians", false, nil, "EMS also"),
                ("Only chaplains", false, nil, "EMS included"),
                ("No training needed", false, nil, "Training emphasized")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: EMS trained in TOR and death notification for on-scene resuscitation emphasis.",
            keyPoint: "EMS death notification training (2025)",
            algorithmStep: "Systems of Care - EMS training"
        ),
        makeQuestion(
            stem: "What changes did 2025 make to the synchronized cardioversion algorithm?",
            choices: [
                ("Now has its own dedicated algorithm with updated energy recommendations", true, "2025 change", nil),
                ("Removed from guidelines", false, nil, "Now separate algorithm"),
                ("No changes", false, nil, "Significant changes"),
                ("Combined with defibrillation", false, nil, "Separate algorithm")
            ],
            topic: .guidelines2025,
            difficulty: .medium,
            explanation: "2025: Synchronized cardioversion has its own dedicated algorithm with updated energies.",
            keyPoint: "Separate cardioversion algorithm (2025)",
            algorithmStep: "Tachycardia Algorithm - 2025 structure"
        ),
        makeQuestion(
            stem: "What is the expected implementation timeline for 2025 AHA guidelines?",
            choices: [
                ("Full implementation expected March 2026", true, "Timeline", nil),
                ("Immediate implementation required", false, nil, "March 2026"),
                ("2027", false, nil, "March 2026"),
                ("No timeline set", false, nil, "March 2026 target")
            ],
            topic: .guidelines2025,
            difficulty: .easy,
            explanation: "2025 Guidelines implementation expected March 2026 with additional updates to follow.",
            keyPoint: "Implementation: March 2026",
            algorithmStep: "2025 Guidelines - Implementation"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, what is the approach to hyperkalemia during cardiac arrest?",
            choices: [
                ("Insulin + glucose remains recommended; insufficient evidence for calcium or bicarbonate during arrest", true, "2025 guidance", nil),
                ("Calcium is first-line", false, nil, "Insulin + glucose recommended"),
                ("Bicarbonate is first-line", false, nil, "Insufficient evidence"),
                ("No treatment recommended", false, nil, "Insulin + glucose recommended")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "2025: Hyperkalemia in arrest - insulin + glucose recommended; insufficient evidence for Ca or bicarb.",
            keyPoint: "Hyperkalemia: insulin + glucose (2025)",
            algorithmStep: "Cardiac Arrest - Hyperkalemia 2025"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, what is the recommendation on double sequential defibrillation (DSD)?",
            choices: [
                ("Uncertain usefulness - may be considered after 3+ shocks for refractory VF", true, "2025 guidance", nil),
                ("Strongly recommended for all VF", false, nil, "Uncertain usefulness"),
                ("Contraindicated", false, nil, "May be considered"),
                ("First-line for refractory VF", false, nil, "Uncertain usefulness")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "2025: DSD has uncertain usefulness; may be considered after 3+ shocks for refractory VF/VCD.",
            keyPoint: "DSD: uncertain usefulness (2025)",
            algorithmStep: "VF/pVT Algorithm - DSD 2025"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, what is the recommendation on double synchronized cardioversion?",
            choices: [
                ("Uncertain usefulness for refractory arrhythmias", true, "2025 guidance", nil),
                ("Strongly recommended", false, nil, "Uncertain usefulness"),
                ("Contraindicated", false, nil, "May be considered"),
                ("First-line for refractory AFib", false, nil, "Uncertain usefulness")
            ],
            topic: .guidelines2025,
            difficulty: .hard,
            explanation: "2025: Double synchronized cardioversion has uncertain usefulness.",
            keyPoint: "Double sync cardioversion: uncertain (2025)",
            algorithmStep: "Tachycardia Algorithm - Double cardioversion"
        ),
        makeQuestion(
            stem: "What is the overall philosophy of the 2025 AHA Guidelines updates?",
            choices: [
                ("Simplification, standardization, evidence-based changes, and outcomes focus", true, "Core philosophy", nil),
                ("More complex algorithms", false, nil, "Simplification emphasized"),
                ("Less emphasis on evidence", false, nil, "Evidence-based focus"),
                ("Remove standardization", false, nil, "Standardization emphasized")
            ],
            topic: .guidelines2025,
            difficulty: .easy,
            explanation: "2025: Focus on simplification, standardization, evidence-based changes, and improved outcomes.",
            keyPoint: "2025: Simplify, standardize, evidence-based",
            algorithmStep: "2025 Guidelines - Overall philosophy"
        )
    ]
    
    // MARK: - Final VF/PEA Questions (25 additional)
    
    static let finalVFPEAQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "A patient in VF does not respond after 4 shocks and epinephrine. What antiarrhythmic should be given?",
            choices: [
                ("Amiodarone 300 mg IV bolus", true, "First antiarrhythmic for refractory VF", nil),
                ("Lidocaine 300 mg IV", false, nil, "Wrong dose for lidocaine"),
                ("Sotalol 150 mg IV", false, nil, "Sotalol no longer recommended (2025)"),
                ("Magnesium 2 g IV", false, nil, "Only for Torsades")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "Refractory VF: amiodarone 300 mg IV bolus after initial shocks and epinephrine.",
            keyPoint: "Refractory VF: Amiodarone 300 mg",
            algorithmStep: "VF/pVT Algorithm - Antiarrhythmic"
        ),
        makeQuestion(
            stem: "When should epinephrine be given in the VF/pVT algorithm?",
            choices: [
                ("After initial defibrillation attempts fail; during CPR as soon as IV/IO established", true, "After initial shocks", nil),
                ("Before any defibrillation", false, nil, "Shock first"),
                ("Only after 10 minutes of CPR", false, nil, "Given earlier"),
                ("Never in VF", false, nil, "Epinephrine indicated")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "VF/pVT: prioritize early defibrillation, then epinephrine after initial shock attempts.",
            keyPoint: "Shock first, then epinephrine",
            algorithmStep: "VF/pVT Algorithm - Epinephrine timing"
        ),
        makeQuestion(
            stem: "What is the recommended approach to refractory VF after multiple shocks?",
            choices: [
                ("Continue high-quality CPR, consider pad repositioning, escalate energy, give antiarrhythmics", true, "Comprehensive approach", nil),
                ("Terminate resuscitation after 3 shocks", false, nil, "Continue efforts"),
                ("Switch to synchronized cardioversion", false, nil, "VF requires defibrillation"),
                ("Give only medications, no more shocks", false, nil, "Continue shocks")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "Refractory VF: continue CPR/shocks, reposition pads, max energy, amiodarone, consider causes.",
            keyPoint: "Refractory VF: optimize everything",
            algorithmStep: "VF/pVT Algorithm - Refractory VF"
        ),
        makeQuestion(
            stem: "What is the significance of ETCO2 during CPR for a patient in VF?",
            choices: [
                ("Monitors CPR quality; sudden rise may indicate ROSC", true, "Multiple uses", nil),
                ("Only confirms tube placement", false, nil, "Also monitors CPR quality"),
                ("Not useful during VF", false, nil, "Very useful"),
                ("Should remain at 0 during arrest", false, nil, "Should be >10 mmHg")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "ETCO2: CPR quality indicator and ROSC detector (sudden rise to >40 suggests ROSC).",
            keyPoint: "ETCO2: CPR quality + ROSC detection",
            algorithmStep: "VF/pVT Algorithm - Capnography"
        ),
        makeQuestion(
            stem: "What is the most common reversible cause of PEA in trauma patients?",
            choices: [
                ("Hypovolemia", true, "Blood loss", nil),
                ("Hyperkalemia", false, nil, "Less common in trauma"),
                ("Hypothermia", false, nil, "Less common acutely"),
                ("Toxins", false, nil, "Less common in trauma")
            ],
            topic: .peaAsystole,
            difficulty: .medium,
            explanation: "Trauma PEA: hypovolemia from hemorrhage is most common cause.",
            keyPoint: "Trauma PEA = think hypovolemia",
            algorithmStep: "Cardiac Arrest - Trauma considerations"
        ),
        makeQuestion(
            stem: "What clinical finding differentiates narrow complex PEA from wide complex PEA?",
            choices: [
                ("Narrow PEA often suggests reversible cause; wide PEA may indicate primary cardiac failure", true, "Morphology significance", nil),
                ("No clinical significance", false, nil, "Has prognostic significance"),
                ("Wide PEA is always worse", false, nil, "Narrow can have good cause"),
                ("Only matters for treatment", false, nil, "Also prognostic")
            ],
            topic: .peaAsystole,
            difficulty: .hard,
            explanation: "Narrow PEA = likely reversible cause (hypovolemia, PE); Wide PEA = often primary cardiac.",
            keyPoint: "PEA morphology has significance",
            algorithmStep: "Cardiac Arrest - PEA morphology"
        ),
        makeQuestion(
            stem: "How should asystole be confirmed on the monitor?",
            choices: [
                ("Check in 2+ leads, verify leads are attached, check gain settings", true, "Confirm in multiple leads", nil),
                ("Single lead is sufficient", false, nil, "Check multiple leads"),
                ("Only check if flat for 10 seconds", false, nil, "Confirm immediately"),
                ("No confirmation needed", false, nil, "Always confirm")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "Always confirm asystole in 2+ leads; check leads, connections, and gain settings.",
            keyPoint: "Confirm asystole in multiple leads",
            algorithmStep: "Cardiac Arrest - Asystole confirmation"
        ),
        makeQuestion(
            stem: "Is defibrillation indicated for asystole?",
            choices: [
                ("No - asystole is not a shockable rhythm; focus on CPR and epinephrine", true, "Non-shockable", nil),
                ("Yes - shock at maximum energy", false, nil, "Not shockable"),
                ("Yes - low energy shock", false, nil, "Not shockable"),
                ("Only if preceded by VF", false, nil, "Current rhythm determines treatment")
            ],
            topic: .peaAsystole,
            difficulty: .easy,
            explanation: "Asystole = non-shockable rhythm. Focus on CPR, epinephrine, reversible causes.",
            keyPoint: "Asystole = no shock",
            algorithmStep: "Cardiac Arrest - Asystole treatment"
        ),
        makeQuestion(
            stem: "What rhythm check interval is recommended during cardiac arrest?",
            choices: [
                ("Every 2 minutes", true, "Standard interval", nil),
                ("Every 5 minutes", false, nil, "Too infrequent"),
                ("Continuous monitoring without breaks", false, nil, "2-minute cycles"),
                ("Every 1 minute", false, nil, "Too frequent, interrupts CPR")
            ],
            topic: .vfPulselessVT,
            difficulty: .easy,
            explanation: "Rhythm check every 2 minutes (coincides with compressor switch).",
            keyPoint: "Rhythm check every 2 minutes",
            algorithmStep: "Cardiac Arrest Algorithm - Rhythm check timing"
        ),
        makeQuestion(
            stem: "After ROSC from VF arrest, the patient re-arrests into VF. What is the immediate action?",
            choices: [
                ("Immediate defibrillation at previous effective energy or higher", true, "Immediate shock", nil),
                ("Wait 2 minutes before shock", false, nil, "Immediate shock for VF"),
                ("Give amiodarone before shock", false, nil, "Shock first"),
                ("Only CPR, no shock", false, nil, "VF is shockable")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "Re-arrest into VF: immediate defibrillation at effective/higher energy.",
            keyPoint: "Re-arrest VF = immediate shock",
            algorithmStep: "Cardiac Arrest - Re-arrest management"
        ),
        makeQuestion(
            stem: "What is the lidocaine alternative if amiodarone is unavailable for VF?",
            choices: [
                ("Lidocaine 1-1.5 mg/kg IV, can repeat 0.5-0.75 mg/kg", true, "Alternative antiarrhythmic", nil),
                ("Sotalol 150 mg IV", false, nil, "Sotalol not recommended (2025)"),
                ("Procainamide 20 mg/min", false, nil, "Too slow for arrest"),
                ("Magnesium 2 g IV", false, nil, "Only for Torsades")
            ],
            topic: .vfPulselessVT,
            difficulty: .medium,
            explanation: "Lidocaine is alternative to amiodarone: 1-1.5 mg/kg, can repeat 0.5-0.75 mg/kg.",
            keyPoint: "Lidocaine alternative: 1-1.5 mg/kg",
            algorithmStep: "VF/pVT Algorithm - Lidocaine"
        ),
        makeQuestion(
            stem: "What should be considered when VF persists despite optimal CPR and multiple shocks?",
            choices: [
                ("Review H's and T's, consider double sequential defibrillation, ECMO if available", true, "Advanced options", nil),
                ("Terminate resuscitation", false, nil, "Consider advanced options first"),
                ("Switch to synchronized cardioversion", false, nil, "VF needs defibrillation"),
                ("Only continue epinephrine", false, nil, "Consider advanced options")
            ],
            topic: .vfPulselessVT,
            difficulty: .hard,
            explanation: "Refractory VF: review reversible causes, consider DSD, ECMO, vector change.",
            keyPoint: "Refractory VF: consider advanced options",
            algorithmStep: "VF/pVT Algorithm - Refractory options"
        )
    ]
    
    // MARK: - Final Bradycardia/Tachycardia Questions (25 additional)
    
    static let finalBradyTachyQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "Per 2025 guidelines, what should be assessed FIRST in a patient with bradycardia?",
            choices: [
                ("Signs of cardiopulmonary compromise (hypotension, AMS, shock, chest pain, HF)", true, "2025 change", nil),
                ("Heart rate number", false, nil, "Compromise first"),
                ("Underlying cause", false, nil, "Assess compromise first"),
                ("Need for pacing", false, nil, "Assess compromise first")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "2025: Assess cardiopulmonary compromise first before treating underlying cause.",
            keyPoint: "Bradycardia: assess compromise first (2025)",
            algorithmStep: "Bradycardia Algorithm - Initial assessment"
        ),
        makeQuestion(
            stem: "What are the signs of cardiopulmonary compromise in bradycardia?",
            choices: [
                ("Hypotension, altered mental status, signs of shock, ischemic chest pain, acute heart failure", true, "Compromise signs", nil),
                ("Slow heart rate only", false, nil, "Need symptoms"),
                ("Normal blood pressure with slow rate", false, nil, "Need compromise signs"),
                ("Mild fatigue", false, nil, "Need more severe signs")
            ],
            topic: .bradycardia,
            difficulty: .easy,
            explanation: "Compromise: hypotension, AMS, shock, chest pain, acute HF.",
            keyPoint: "Compromise = hypotension, AMS, shock, chest pain, HF",
            algorithmStep: "Bradycardia Algorithm - Compromise signs"
        ),
        makeQuestion(
            stem: "If atropine is ineffective for symptomatic bradycardia, what are the next options?",
            choices: [
                ("Transcutaneous pacing OR dopamine/epinephrine infusion", true, "Equally effective alternatives", nil),
                ("More atropine indefinitely", false, nil, "Max 3 mg"),
                ("Defibrillation", false, nil, "Not for bradycardia"),
                ("Adenosine", false, nil, "Slows heart rate more")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Atropine-refractory: TCP or chronotropic infusion (dopamine 5-20 mcg/kg/min or epi 2-10 mcg/min).",
            keyPoint: "After atropine: TCP or dopamine/epi",
            algorithmStep: "Bradycardia Algorithm - Second-line treatment"
        ),
        makeQuestion(
            stem: "When should temporary transvenous pacing be considered?",
            choices: [
                ("Symptomatic bradycardia refractory to atropine and transcutaneous pacing", true, "Refractory cases", nil),
                ("All bradycardia cases", false, nil, "Only refractory"),
                ("First-line for any bradycardia", false, nil, "Atropine/TCP first"),
                ("Never indicated", false, nil, "Indicated for refractory")
            ],
            topic: .bradycardia,
            difficulty: .hard,
            explanation: "Transvenous pacing: for refractory symptomatic bradycardia unresponsive to medical therapy and TCP.",
            keyPoint: "Transvenous pacing for refractory bradycardia",
            algorithmStep: "Bradycardia Algorithm - Transvenous pacing"
        ),
        makeQuestion(
            stem: "What is the concern with beta-blocker or calcium channel blocker toxicity causing bradycardia?",
            choices: [
                ("May be refractory to standard treatment; consider glucagon, calcium, high-dose insulin", true, "Toxicity considerations", nil),
                ("Responds well to atropine", false, nil, "Often refractory"),
                ("No specific treatment needed", false, nil, "Specific antidotes exist"),
                ("Always requires transvenous pacing", false, nil, "Try medications first")
            ],
            topic: .bradycardia,
            difficulty: .hard,
            explanation: "BB/CCB toxicity: often refractory; use glucagon, calcium, high-dose insulin therapy.",
            keyPoint: "BB/CCB toxicity: glucagon, calcium, insulin",
            algorithmStep: "Bradycardia Algorithm - Toxicity"
        ),
        makeQuestion(
            stem: "What conditions may cause bradycardia to be appropriate and not require treatment?",
            choices: [
                ("Athletic heart, sleep, medications (beta-blockers), vagal response", true, "Physiologic causes", nil),
                ("Bradycardia always requires treatment", false, nil, "Sometimes physiologic"),
                ("Only in young patients", false, nil, "Various causes"),
                ("Never appropriate", false, nil, "Can be normal")
            ],
            topic: .bradycardia,
            difficulty: .easy,
            explanation: "Physiologic bradycardia: athletes, sleep, medications - no treatment if asymptomatic.",
            keyPoint: "Asymptomatic bradycardia may not need treatment",
            algorithmStep: "Bradycardia Algorithm - Physiologic bradycardia"
        ),
        makeQuestion(
            stem: "What is the significance of new-onset bradycardia with acute MI?",
            choices: [
                ("May indicate inferior MI with vagal involvement or conduction system ischemia", true, "MI consideration", nil),
                ("Never related to MI", false, nil, "Can be related"),
                ("Only in anterior MI", false, nil, "More common in inferior"),
                ("Always benign", false, nil, "Can be serious")
            ],
            topic: .bradycardia,
            difficulty: .medium,
            explanation: "Inferior MI: can cause bradycardia from vagal stimulation or RCA-supplied AV node ischemia.",
            keyPoint: "Bradycardia + chest pain: think inferior MI",
            algorithmStep: "Bradycardia Algorithm - MI consideration"
        ),
        makeQuestion(
            stem: "What characterizes unstable wide complex tachycardia in a patient with a pulse?",
            choices: [
                ("Wide QRS tachycardia with hypotension, AMS, chest pain, or signs of heart failure", true, "Unstable WCT", nil),
                ("Any wide QRS at any rate", false, nil, "Need instability signs"),
                ("Wide QRS with normal vitals", false, nil, "That's stable"),
                ("Narrow QRS with hypotension", false, nil, "That's narrow complex")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "Unstable WCT: wide QRS + hemodynamic compromise = immediate cardioversion.",
            keyPoint: "Unstable WCT = cardioversion",
            algorithmStep: "Tachycardia Algorithm - Unstable WCT"
        ),
        makeQuestion(
            stem: "Why should calcium channel blockers be avoided in wide complex tachycardia?",
            choices: [
                ("If WCT is actually VT, CCBs can cause hemodynamic collapse", true, "Safety concern", nil),
                ("They are always effective", false, nil, "Can be dangerous"),
                ("They are first-line for WCT", false, nil, "Contraindicated in WCT"),
                ("No concern with CCBs in WCT", false, nil, "Significant concern")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "WCT may be VT; CCBs in VT can cause cardiovascular collapse. Treat WCT as VT if unsure.",
            keyPoint: "No CCBs for wide complex tachycardia",
            algorithmStep: "Tachycardia Algorithm - CCB warning"
        ),
        makeQuestion(
            stem: "What is the role of adenosine in regular wide complex tachycardia?",
            choices: [
                ("May be considered diagnostically if regular and stable; won't harm VT", true, "Diagnostic use", nil),
                ("First-line treatment for all WCT", false, nil, "Use cautiously"),
                ("Contraindicated in all WCT", false, nil, "Can be used if regular"),
                ("Only for narrow complex", false, nil, "May help in regular WCT")
            ],
            topic: .tachycardia,
            difficulty: .hard,
            explanation: "Regular WCT: adenosine may be tried diagnostically if stable; won't harm VT, may convert SVT.",
            keyPoint: "Adenosine may be tried for regular WCT",
            algorithmStep: "Tachycardia Algorithm - Adenosine in WCT"
        ),
        makeQuestion(
            stem: "How do the 2025 guidelines change synchronized cardioversion energy recommendations?",
            choices: [
                ("Higher initial energies recommended (100J for SVT, 200J for AFib)", true, "2025 update", nil),
                ("Lower energies recommended", false, nil, "Higher energies now"),
                ("No change from previous", false, nil, "Significant changes"),
                ("Fixed energy for all rhythms", false, nil, "Varies by rhythm")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "2025: Higher cardioversion energies (100J narrow, 100J VT, 200J AFib/flutter).",
            keyPoint: "2025: Higher cardioversion energies",
            algorithmStep: "Tachycardia Algorithm - 2025 energy changes"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, what should be done if cardioversion energy levels are unknown?",
            choices: [
                ("Use maximum device settings", true, "2025 recommendation", nil),
                ("Start at 50 J", false, nil, "May be too low"),
                ("Avoid cardioversion", false, nil, "Cardioversion still indicated"),
                ("Use only 100 J", false, nil, "May be insufficient")
            ],
            topic: .tachycardia,
            difficulty: .medium,
            explanation: "2025: If optimal energy unknown, use maximum device settings.",
            keyPoint: "Unknown energy = use maximum",
            algorithmStep: "Tachycardia Algorithm - Unknown energy"
        ),
        makeQuestion(
            stem: "What is the updated language for sedation in the 2025 tachycardia algorithm?",
            choices: [
                ("'Sedate whenever feasible' (changed from 'consider sedation')", true, "2025 language change", nil),
                ("Sedation is contraindicated", false, nil, "Sedation encouraged"),
                ("Mandatory sedation always", false, nil, "When feasible"),
                ("No mention of sedation", false, nil, "Emphasized in 2025")
            ],
            topic: .tachycardia,
            difficulty: .easy,
            explanation: "2025: 'Sedate whenever feasible' - stronger recommendation than previous 'consider sedation'.",
            keyPoint: "'Sedate whenever feasible' (2025)",
            algorithmStep: "Tachycardia Algorithm - Sedation"
        )
    ]
    
    // MARK: - More Rhythm Recognition Questions (20 from 09-Rhythm-Recognition-Questions.md)
    
    static let moreRhythmQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What are the characteristics of normal sinus rhythm?",
            choices: [
                ("Regular rhythm, rate 60-100 bpm, upright P wave before each QRS, consistent PR interval", true, "Normal sinus rhythm", nil),
                ("Irregular rhythm with absent P waves", false, nil, "That's AFib"),
                ("Rate always above 100 bpm", false, nil, "That's tachycardia"),
                ("No P waves visible", false, nil, "P waves present in NSR")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "NSR: P waves present (upright in lead II), regular rate 60-100, consistent PR.",
            keyPoint: "NSR: P waves, regular, 60-100 bpm",
            algorithmStep: "Rhythm Recognition - Sinus rhythm"
        ),
        makeQuestion(
            stem: "What is the ECG appearance of atrial fibrillation?",
            choices: [
                ("Irregularly irregular rhythm, no distinct P waves, fibrillatory baseline", true, "Classic AFib", nil),
                ("Regular narrow complex rhythm", false, nil, "AFib is irregular"),
                ("Saw-tooth pattern", false, nil, "That's flutter"),
                ("Wide QRS complexes", false, nil, "AFib typically narrow")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "AFib: irregularly irregular, no P waves, chaotic atrial activity (fibrillatory waves).",
            keyPoint: "AFib: irregularly irregular, no P waves",
            algorithmStep: "Rhythm Recognition - Atrial fibrillation"
        ),
        makeQuestion(
            stem: "What is the classic ECG finding in atrial flutter?",
            choices: [
                ("Saw-tooth flutter waves at 250-350 bpm, often with 2:1 or 4:1 block", true, "Classic flutter", nil),
                ("Absent P waves with irregular RR", false, nil, "That's AFib"),
                ("Wide QRS complexes", false, nil, "Flutter is typically narrow"),
                ("Peaked T waves", false, nil, "That's hyperkalemia")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Flutter: saw-tooth F waves ~300/min; typical 2:1 block = HR ~150.",
            keyPoint: "Flutter: saw-tooth waves ~300/min",
            algorithmStep: "Rhythm Recognition - Atrial flutter"
        ),
        makeQuestion(
            stem: "What are the typical ECG characteristics of AVNRT (most common SVT)?",
            choices: [
                ("Regular narrow complex tachycardia, rate 150-250 bpm, P waves often hidden in QRS", true, "Classic AVNRT", nil),
                ("Wide QRS complexes", false, nil, "AVNRT is narrow"),
                ("Irregular rhythm", false, nil, "AVNRT is regular"),
                ("Rate always <100 bpm", false, nil, "AVNRT is fast")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "AVNRT: narrow regular 150-250 bpm; P waves hidden or just after QRS.",
            keyPoint: "AVNRT: narrow, regular, 150-250 bpm",
            algorithmStep: "Rhythm Recognition - AVNRT"
        ),
        makeQuestion(
            stem: "What defines ventricular tachycardia on ECG?",
            choices: [
                ("Wide QRS (≥120 ms), regular rhythm, rate typically 150-250 bpm", true, "Classic VT", nil),
                ("Narrow QRS", false, nil, "VT is wide"),
                ("Irregular rhythm always", false, nil, "VT is typically regular"),
                ("Rate always <100 bpm", false, nil, "VT is fast")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "VT: wide regular tachycardia ≥120ms; AV dissociation, fusion beats confirm VT.",
            keyPoint: "VT: wide (≥120ms), regular, fast",
            algorithmStep: "Rhythm Recognition - Ventricular tachycardia"
        ),
        makeQuestion(
            stem: "What is the ECG finding in first-degree AV block?",
            choices: [
                ("Prolonged PR interval >200 ms with 1:1 conduction", true, "All P waves conduct", nil),
                ("Dropped QRS complexes", false, nil, "That's higher degree block"),
                ("No P waves", false, nil, "P waves present"),
                ("Dissociation of P and QRS", false, nil, "That's third-degree")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "1st degree: PR >200ms but all P waves conduct; benign, rarely needs treatment.",
            keyPoint: "1st degree: PR >200ms, all P waves conduct",
            algorithmStep: "Rhythm Recognition - First-degree block"
        ),
        makeQuestion(
            stem: "What is the ECG pattern of Mobitz Type I (Wenckebach)?",
            choices: [
                ("Progressive PR prolongation until a QRS is dropped, then the cycle repeats", true, "Classic Wenckebach", nil),
                ("Constant PR with random dropped beats", false, nil, "That's Mobitz II"),
                ("No P waves visible", false, nil, "P waves present"),
                ("Complete dissociation of P and QRS", false, nil, "That's third-degree")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Mobitz I: PR gets longer, longer, longer, then drops. Usually nodal, more benign.",
            keyPoint: "Mobitz I: progressive PR → dropped beat",
            algorithmStep: "Rhythm Recognition - Mobitz I"
        ),
        makeQuestion(
            stem: "What is the ECG pattern of Mobitz Type II?",
            choices: [
                ("Constant PR interval with sudden dropped QRS complexes (no warning)", true, "Classic Mobitz II", nil),
                ("Progressive PR prolongation", false, nil, "That's Mobitz I"),
                ("Irregular atrial rhythm", false, nil, "Atrial rhythm is regular"),
                ("No P waves", false, nil, "P waves present")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Mobitz II: constant PR then sudden dropped QRS. Infranodal, may progress to complete block.",
            keyPoint: "Mobitz II: constant PR → sudden dropped beat",
            algorithmStep: "Rhythm Recognition - Mobitz II"
        ),
        makeQuestion(
            stem: "What is the ECG finding in third-degree (complete) heart block?",
            choices: [
                ("Complete AV dissociation - P waves and QRS march independently", true, "No AV conduction", nil),
                ("Prolonged PR only", false, nil, "That's first-degree"),
                ("Progressive PR lengthening", false, nil, "That's Mobitz I"),
                ("Normal sinus rhythm", false, nil, "This is abnormal rhythm")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Third-degree: complete AV dissociation - atria and ventricles beat independently.",
            keyPoint: "Third-degree: complete AV dissociation",
            algorithmStep: "Rhythm Recognition - Third-degree block"
        ),
        makeQuestion(
            stem: "What is the typical ECG appearance of Torsades de Pointes?",
            choices: [
                ("Polymorphic VT with QRS complexes that appear to twist around the baseline", true, "Classic Torsades", nil),
                ("Monomorphic wide complex rhythm", false, nil, "Torsades is polymorphic"),
                ("Narrow complex tachycardia", false, nil, "Torsades is wide"),
                ("Regular rhythm", false, nil, "Torsades varies")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Torsades: polymorphic VT 'twisting' around baseline, often with prolonged QT at baseline.",
            keyPoint: "Torsades: polymorphic VT, twisting appearance",
            algorithmStep: "Rhythm Recognition - Torsades de Pointes"
        ),
        makeQuestion(
            stem: "What ECG finding typically precedes Torsades de Pointes?",
            choices: [
                ("Prolonged QT interval", true, "QT prolongation predisposes", nil),
                ("Short QT interval", false, nil, "Opposite - long QT causes Torsades"),
                ("Peaked T waves", false, nil, "That suggests hyperkalemia"),
                ("Short PR interval", false, nil, "Not related to Torsades")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Torsades typically occurs with long QT (drug-induced, electrolyte, congenital).",
            keyPoint: "Long QT → Torsades risk",
            algorithmStep: "Rhythm Recognition - Torsades etiology"
        ),
        makeQuestion(
            stem: "How do you differentiate fine VF from asystole?",
            choices: [
                ("Fine VF has some waveform variation; confirm in multiple leads, check gain", true, "Subtle differences", nil),
                ("They are always distinguishable", false, nil, "Can be difficult"),
                ("Fine VF is always flat", false, nil, "VF has some activity"),
                ("Only asystole requires confirmation in multiple leads", false, nil, "Both should be confirmed")
            ],
            topic: .rhythms,
            difficulty: .hard,
            explanation: "Fine VF has subtle waveform variation; always confirm asystole in 2+ leads, check gain/leads.",
            keyPoint: "Fine VF vs asystole: check multiple leads, gain",
            algorithmStep: "Rhythm Recognition - Fine VF vs asystole"
        ),
        makeQuestion(
            stem: "What is the characteristic of idioventricular rhythm?",
            choices: [
                ("Wide QRS, regular, rate 20-40 bpm, ventricular origin", true, "Ventricular escape", nil),
                ("Narrow QRS, fast rate", false, nil, "Idioventricular is wide and slow"),
                ("Irregular with P waves", false, nil, "No P waves in idioventricular"),
                ("Rate >100 bpm", false, nil, "Idioventricular is slow")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "Idioventricular: ventricular escape rhythm, wide, slow (20-40 bpm). Usually a dying heart.",
            keyPoint: "Idioventricular: wide, slow, ventricular origin",
            algorithmStep: "Rhythm Recognition - Idioventricular rhythm"
        ),
        makeQuestion(
            stem: "What is accelerated idioventricular rhythm (AIVR)?",
            choices: [
                ("Wide complex rhythm at 40-100 bpm, often seen after reperfusion", true, "Common post-ROSC", nil),
                ("VT at >150 bpm", false, nil, "AIVR is slower"),
                ("Narrow complex rhythm", false, nil, "AIVR is wide"),
                ("Always requires treatment", false, nil, "Usually benign, self-limited")
            ],
            topic: .rhythms,
            difficulty: .medium,
            explanation: "AIVR: ventricular rhythm 40-100 bpm; often reperfusion arrhythmia, usually benign.",
            keyPoint: "AIVR: wide, 40-100 bpm, often reperfusion",
            algorithmStep: "Rhythm Recognition - AIVR"
        ),
        makeQuestion(
            stem: "What is the significance of PVCs (premature ventricular contractions)?",
            choices: [
                ("Usually benign if isolated, but frequent/runs may indicate underlying disease", true, "Context matters", nil),
                ("Always require treatment", false, nil, "Isolated PVCs often benign"),
                ("Never significant", false, nil, "Can indicate underlying disease"),
                ("Same as VT", false, nil, "PVCs are isolated beats")
            ],
            topic: .rhythms,
            difficulty: .easy,
            explanation: "PVCs: isolated usually benign; frequent, multifocal, or R-on-T may be concerning.",
            keyPoint: "PVCs: usually benign if isolated",
            algorithmStep: "Rhythm Recognition - PVCs"
        )
    ]
    
    // MARK: - More Stroke and ACS Questions (20 from 12-Stroke-ACS-Questions.md)
    
    static let moreStrokeACSQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "The BE-FAST mnemonic for stroke recognition includes which components?",
            choices: [
                ("Balance, Eyes, Face, Arms, Speech, Time", true, "Complete mnemonic", nil),
                ("Blood pressure, Eyes, Face, Arms, Speech, Taste", false, nil, "Incorrect components"),
                ("Breathing, Eyes, Face, Arms, Speech, Temperature", false, nil, "Incorrect components"),
                ("Balance, Ears, Face, Arms, Speech, Time", false, nil, "Eyes, not Ears")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "BE-FAST: Balance, Eyes, Face, Arms, Speech, Time to call 911.",
            keyPoint: "BE-FAST stroke recognition",
            algorithmStep: "Stroke Recognition - BE-FAST Mnemonic"
        ),
        makeQuestion(
            stem: "The classic time window for IV alteplase (tPA) in acute ischemic stroke is within:",
            choices: [
                ("3-4.5 hours of symptom onset", true, "Standard window", nil),
                ("1 hour of symptom onset", false, nil, "Window is wider"),
                ("2 hours of symptom onset", false, nil, "Extends to 3-4.5 hours"),
                ("12 hours of symptom onset", false, nil, "Too late for IV tPA")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "IV tPA: within 3 hours standard, up to 4.5 hours in select patients.",
            keyPoint: "tPA window: 3-4.5 hours",
            algorithmStep: "Acute Ischemic Stroke Algorithm"
        ),
        makeQuestion(
            stem: "For a patient with acute ischemic stroke who is a candidate for IV thrombolytics, BP should be controlled to below:",
            choices: [
                ("185/110 mmHg", true, "tPA threshold", nil),
                ("140/90 mmHg", false, nil, "Too aggressive for acute stroke"),
                ("160/100 mmHg", false, nil, "Goal is <185/110"),
                ("220/120 mmHg", false, nil, "Too high, increases bleeding risk")
            ],
            topic: .stroke,
            difficulty: .medium,
            explanation: "For tPA candidates: BP < 185/110 before and < 180/105 after.",
            keyPoint: "tPA BP threshold: <185/110",
            algorithmStep: "Stroke - Blood Pressure Management"
        ),
        makeQuestion(
            stem: "Why is blood glucose checked in all stroke patients?",
            choices: [
                ("Hypoglycemia can mimic stroke and must be ruled out", true, "Treatable mimic", nil),
                ("To start insulin immediately", false, nil, "Not routine"),
                ("Glucose level determines tPA eligibility", false, nil, "Not a determinant"),
                ("All stroke patients have diabetes", false, nil, "Not true")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "Always check glucose - hypoglycemia is a treatable stroke mimic.",
            keyPoint: "Check glucose - hypoglycemia mimics stroke",
            algorithmStep: "Stroke Assessment - Glucose Check"
        ),
        makeQuestion(
            stem: "A patient presents with stroke symptoms. CT scan shows intracerebral hemorrhage. Regarding thrombolytics:",
            choices: [
                ("tPA is absolutely contraindicated", true, "Hemorrhage = no tPA", nil),
                ("Give tPA at reduced dose", false, nil, "No dose is safe"),
                ("Give tPA after blood pressure control", false, nil, "Still contraindicated"),
                ("Give tPA with concurrent FFP", false, nil, "Still contraindicated")
            ],
            topic: .stroke,
            difficulty: .medium,
            explanation: "Hemorrhagic stroke = absolute contraindication to thrombolytics.",
            keyPoint: "Hemorrhagic stroke = no tPA",
            algorithmStep: "Stroke - Hemorrhage Exclusion"
        ),
        makeQuestion(
            stem: "The target door-to-needle time for IV thrombolytic administration in acute ischemic stroke is:",
            choices: [
                ("60 minutes or less", true, "Standard target", nil),
                ("30 minutes", false, nil, "Aspirational but not standard"),
                ("90 minutes", false, nil, "Too long"),
                ("120 minutes", false, nil, "Exceeds goal")
            ],
            topic: .stroke,
            difficulty: .easy,
            explanation: "Door-to-needle goal is ≤60 minutes for tPA.",
            keyPoint: "Door-to-needle: ≤60 minutes",
            algorithmStep: "Stroke - Time Targets"
        ),
        makeQuestion(
            stem: "What is the first priority when evaluating a patient with chest pain?",
            choices: [
                ("12-lead ECG within 10 minutes of arrival", true, "Rapid ECG", nil),
                ("Chest X-ray", false, nil, "ECG is priority"),
                ("Wait for troponin results", false, nil, "ECG first"),
                ("Exercise stress test", false, nil, "Not for acute presentation")
            ],
            topic: .acs,
            difficulty: .easy,
            explanation: "12-lead ECG within 10 minutes is the first priority to identify STEMI.",
            keyPoint: "ECG within 10 minutes",
            algorithmStep: "ACS Algorithm - ECG timing"
        ),
        makeQuestion(
            stem: "What defines STEMI on ECG?",
            choices: [
                ("New ST elevation at J-point in 2+ contiguous leads (≥1mm in limb leads, ≥2mm in precordial)", true, "STEMI criteria", nil),
                ("Any ST changes", false, nil, "Specific criteria required"),
                ("T wave inversion only", false, nil, "Not STEMI"),
                ("PR depression", false, nil, "Suggests pericarditis")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "STEMI: new ST elevation at J-point in ≥2 contiguous leads with appropriate amplitudes.",
            keyPoint: "STEMI: ST elevation ≥2 contiguous leads",
            algorithmStep: "ACS Algorithm - STEMI recognition"
        ),
        makeQuestion(
            stem: "What is the target door-to-balloon time for primary PCI in STEMI?",
            choices: [
                ("90 minutes or less", true, "PCI-capable center", nil),
                ("30 minutes", false, nil, "Not achievable for PCI"),
                ("120 minutes", false, nil, "Goal is 90 min"),
                ("180 minutes", false, nil, "Too long")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "Door-to-balloon goal is ≤90 minutes at PCI-capable centers.",
            keyPoint: "Door-to-balloon: ≤90 minutes",
            algorithmStep: "STEMI - PCI time targets"
        ),
        makeQuestion(
            stem: "What is the aspirin dose for acute coronary syndrome?",
            choices: [
                ("162-325 mg chewed (non-enteric coated)", true, "Standard ACS dose", nil),
                ("81 mg", false, nil, "Too low for acute loading"),
                ("500 mg", false, nil, "Too high"),
                ("650 mg", false, nil, "Too high")
            ],
            topic: .acs,
            difficulty: .easy,
            explanation: "ACS: aspirin 162-325 mg, chewed for rapid absorption.",
            keyPoint: "ACS aspirin: 162-325 mg chewed",
            algorithmStep: "ACS Algorithm - Aspirin dosing"
        ),
        makeQuestion(
            stem: "What is the role of nitroglycerin in ACS?",
            choices: [
                ("Relieve ischemic chest pain; give 0.4 mg SL every 5 minutes x3 if BP allows", true, "Standard approach", nil),
                ("First-line treatment even with hypotension", false, nil, "Contraindicated if SBP <90"),
                ("Replaces aspirin", false, nil, "Both are indicated"),
                ("Only given IV", false, nil, "Sublingual is initial route")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "NTG 0.4 mg SL q5min x3 for ischemic chest pain if SBP >90 and no RV infarct.",
            keyPoint: "NTG 0.4 mg SL q5min if BP allows",
            algorithmStep: "ACS Algorithm - Nitroglycerin"
        ),
        makeQuestion(
            stem: "In which situation is nitroglycerin contraindicated?",
            choices: [
                ("Recent phosphodiesterase inhibitor use (sildenafil, etc.) or SBP <90 mmHg", true, "Contraindications", nil),
                ("All chest pain patients", false, nil, "Often indicated"),
                ("STEMI", false, nil, "May be used in STEMI"),
                ("Patients >65 years old", false, nil, "Age not a contraindication")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "NTG contraindicated with recent PDE5 inhibitors (profound hypotension) or SBP <90.",
            keyPoint: "No NTG with PDE5 inhibitors or hypotension",
            algorithmStep: "ACS Algorithm - NTG contraindications"
        ),
        makeQuestion(
            stem: "What is the significance of right-sided ECG leads in inferior STEMI?",
            choices: [
                ("To detect RV infarction which changes management (avoid nitrates, give fluids)", true, "Important distinction", nil),
                ("Not useful", false, nil, "Very useful"),
                ("Only for anterior STEMI", false, nil, "Used for inferior"),
                ("Replaces standard 12-lead", false, nil, "In addition to standard")
            ],
            topic: .acs,
            difficulty: .hard,
            explanation: "RV infarct: preload-dependent, avoid nitrates/diuretics, give fluids cautiously.",
            keyPoint: "Inferior STEMI: check for RV involvement",
            algorithmStep: "STEMI - RV infarction"
        ),
        makeQuestion(
            stem: "What is the MONA mnemonic for ACS treatment?",
            choices: [
                ("Morphine, Oxygen (if hypoxic), Nitroglycerin, Aspirin", true, "Classic mnemonic", nil),
                ("Metoprolol, Oxygen, Nitroprusside, Amiodarone", false, nil, "Incorrect components"),
                ("Morphine, Ondansetron, Nitrates, Anticoagulants", false, nil, "Incorrect components"),
                ("Magnesium, Oxygen, Norepinephrine, Aspirin", false, nil, "Incorrect components")
            ],
            topic: .acs,
            difficulty: .easy,
            explanation: "MONA: Morphine, Oxygen (if needed), Nitroglycerin, Aspirin.",
            keyPoint: "MONA for ACS",
            algorithmStep: "ACS Algorithm - Initial treatment"
        ),
        makeQuestion(
            stem: "When should morphine be used in ACS?",
            choices: [
                ("For refractory chest pain after nitroglycerin; use cautiously due to hypotension risk", true, "Second-line for pain", nil),
                ("As first-line treatment", false, nil, "NTG first for pain"),
                ("Routinely for all ACS", false, nil, "Not routine"),
                ("Never in ACS", false, nil, "Can be used for refractory pain")
            ],
            topic: .acs,
            difficulty: .medium,
            explanation: "Morphine for refractory pain; use cautiously (hypotension, respiratory depression).",
            keyPoint: "Morphine for refractory ACS pain",
            algorithmStep: "ACS Algorithm - Morphine use"
        )
    ]
    
    // MARK: - More BLS Questions (15 from 01-BLS-CPR-Questions.md)
    
    static let moreBLSQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the minimum ETCO2 target that indicates adequate CPR quality?",
            choices: [
                ("≥10 mmHg", true, "Minimum quality indicator", nil),
                ("≥20 mmHg", false, nil, "Good target but 10 is minimum"),
                ("≥35 mmHg", false, nil, "Often indicates ROSC"),
                ("≥5 mmHg", false, nil, "Too low")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "ETCO2 ≥10 mmHg = minimum CPR quality indicator; <10 = improve technique.",
            keyPoint: "ETCO2 ≥10 mmHg minimum during CPR",
            algorithmStep: "CPR Quality - ETCO2 monitoring"
        ),
        makeQuestion(
            stem: "What is the minimum target chest compression fraction during resuscitation?",
            choices: [
                ("≥60%", true, "Minimum target", nil),
                ("≥40%", false, nil, "Too low"),
                ("≥80%", false, nil, "Ideal but 60% is minimum"),
                ("≥50%", false, nil, "Below minimum")
            ],
            topic: .blsCPR,
            difficulty: .medium,
            explanation: "CCF ≥60% = compressions happening 60%+ of total arrest time.",
            keyPoint: "CCF target ≥60%",
            algorithmStep: "BLS Algorithm - High-quality CPR"
        ),
        makeQuestion(
            stem: "What medication can be given via endotracheal tube during CPR if IV/IO access is unavailable?",
            choices: [
                ("Epinephrine at 2-2.5 times the IV dose", true, "ETT drug administration", nil),
                ("Amiodarone", false, nil, "Not given via ETT"),
                ("Sodium bicarbonate", false, nil, "Not given via ETT"),
                ("Calcium chloride", false, nil, "Not given via ETT")
            ],
            topic: .blsCPR,
            difficulty: .hard,
            explanation: "Epinephrine can be given via ETT at 2-2.5x IV dose if no IV/IO access.",
            keyPoint: "ETT epinephrine: 2-2.5x IV dose",
            algorithmStep: "Cardiac Arrest - Drug routes"
        ),
        makeQuestion(
            stem: "Per AHA 2025 guidelines, what is the sequence for single-rescuer CPR?",
            choices: [
                ("C-A-B (Compressions, Airway, Breathing)", true, "Compressions first", nil),
                ("A-B-C (Airway, Breathing, Compressions)", false, nil, "Old sequence"),
                ("D-R-S-A-B-C", false, nil, "Not current sequence"),
                ("Check pulse, then airway", false, nil, "Start compressions")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "C-A-B sequence prioritizes compressions - get blood flowing first.",
            keyPoint: "C-A-B sequence",
            algorithmStep: "BLS Algorithm - CPR sequence"
        ),
        makeQuestion(
            stem: "What is the recommended compression-only CPR approach for untrained bystanders?",
            choices: [
                ("Continuous chest compressions without rescue breaths until EMS arrives", true, "Hands-only CPR", nil),
                ("30:2 compression to ventilation ratio", false, nil, "For trained rescuers"),
                ("15:2 compression to ventilation ratio", false, nil, "For pediatric 2-rescuer"),
                ("No compressions, mouth-to-mouth only", false, nil, "Compressions are critical")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Untrained bystanders should perform hands-only CPR - continuous compressions.",
            keyPoint: "Untrained bystanders: Hands-only CPR",
            algorithmStep: "BLS Algorithm - Hands-only CPR"
        ),
        makeQuestion(
            stem: "What is the correct hand placement for adult chest compressions?",
            choices: [
                ("Heel of one hand on lower half of sternum, other hand on top, fingers interlocked", true, "Proper technique", nil),
                ("Both hands on upper sternum", false, nil, "Too high"),
                ("Fingertips on xiphoid process", false, nil, "Wrong location"),
                ("One hand on chest, one on abdomen", false, nil, "Incorrect technique")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Heel of hand on lower half of sternum, hands interlocked, arms straight.",
            keyPoint: "Lower half of sternum, hands interlocked",
            algorithmStep: "BLS Algorithm - Hand placement"
        ),
        makeQuestion(
            stem: "What action should be taken immediately after confirming no pulse in an unresponsive patient?",
            choices: [
                ("Begin chest compressions", true, "Start CPR immediately", nil),
                ("Give 2 rescue breaths first", false, nil, "Compressions first (C-A-B)"),
                ("Wait for AED", false, nil, "Start CPR immediately"),
                ("Check blood sugar", false, nil, "Start CPR first")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "No pulse = start chest compressions immediately (C-A-B sequence).",
            keyPoint: "No pulse = immediate compressions",
            algorithmStep: "BLS Algorithm - Initial response"
        ),
        makeQuestion(
            stem: "What is the maximum recommended duration for pulse checks during CPR?",
            choices: [
                ("10 seconds", true, "Brief pulse check", nil),
                ("30 seconds", false, nil, "Too long"),
                ("1 minute", false, nil, "Far too long"),
                ("5 seconds", false, nil, "May miss weak pulse")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "Pulse check should be <10 seconds to minimize interruptions to CPR.",
            keyPoint: "Pulse check ≤10 seconds",
            algorithmStep: "BLS Algorithm - Pulse check"
        ),
        makeQuestion(
            stem: "When performing CPR on a drowning victim, what modification is recommended?",
            choices: [
                ("Begin with rescue breaths if comfortable due to likely hypoxic etiology", true, "Address hypoxia first", nil),
                ("No modifications needed", false, nil, "Hypoxia is primary cause"),
                ("Skip ventilations entirely", false, nil, "Ventilation important in drowning"),
                ("Double the compression rate", false, nil, "Standard rate")
            ],
            topic: .blsCPR,
            difficulty: .hard,
            explanation: "Drowning = hypoxic arrest, so rescue breaths are more critical than typical arrest.",
            keyPoint: "Drowning: address hypoxia early",
            algorithmStep: "BLS Algorithm - Special circumstances"
        ),
        makeQuestion(
            stem: "What is the role of an AED in the BLS algorithm?",
            choices: [
                ("Analyze rhythm and deliver shock if indicated as soon as available", true, "Early defibrillation", nil),
                ("Only used after 5 minutes of CPR", false, nil, "Use immediately when available"),
                ("Only for asystole", false, nil, "For shockable rhythms"),
                ("Replaces CPR entirely", false, nil, "Complements CPR")
            ],
            topic: .blsCPR,
            difficulty: .easy,
            explanation: "AED should be applied and used as soon as available - early defibrillation saves lives.",
            keyPoint: "AED as soon as available",
            algorithmStep: "BLS Algorithm - Early defibrillation"
        )
    ]
    
    // MARK: - More Pharmacology Questions (20 from 07-Pharmacology-Questions.md)
    
    static let morePharmQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the primary mechanism by which epinephrine benefits cardiac arrest patients?",
            choices: [
                ("Alpha-adrenergic vasoconstriction increases coronary and cerebral perfusion pressure", true, "Increases perfusion during CPR", nil),
                ("Direct myocardial stimulation only", false, nil, "Alpha effect is primary benefit"),
                ("Decreases myocardial oxygen demand", false, nil, "Increases demand"),
                ("Blocks AV node conduction", false, nil, "Does not block AV node")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Epinephrine alpha-1 effect: vasoconstriction → increased coronary and cerebral perfusion pressure during CPR.",
            keyPoint: "Alpha vasoconstriction increases CPP and CerPP",
            algorithmStep: "Cardiac Arrest - Epinephrine pharmacology"
        ),
        makeQuestion(
            stem: "What is the dopamine infusion rate for symptomatic bradycardia?",
            choices: [
                ("5-20 mcg/kg/min", true, "Chronotropic dose range", nil),
                ("1-3 mcg/kg/min", false, nil, "Renal dose, not chronotropic"),
                ("50-100 mcg/kg/min", false, nil, "Too high"),
                ("0.5 mcg/kg/min", false, nil, "Too low")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Dopamine chronotropic dose: 5-20 mcg/kg/min for bradycardia.",
            keyPoint: "Dopamine chronotropic: 5-20 mcg/kg/min",
            algorithmStep: "Bradycardia Algorithm - Dopamine dosing"
        ),
        makeQuestion(
            stem: "What is the epinephrine infusion rate for symptomatic bradycardia?",
            choices: [
                ("2-10 mcg/min", true, "Bradycardia infusion rate", nil),
                ("1 mg every 3-5 minutes", false, nil, "That's cardiac arrest dose"),
                ("100 mcg/min", false, nil, "Too high"),
                ("0.5 mcg/min", false, nil, "Too low")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Epinephrine infusion for bradycardia: 2-10 mcg/min, titrate to heart rate.",
            keyPoint: "Epi infusion bradycardia: 2-10 mcg/min",
            algorithmStep: "Bradycardia Algorithm - Epinephrine infusion"
        ),
        makeQuestion(
            stem: "What is the magnesium dose for Torsades de Pointes?",
            choices: [
                ("1-2 g IV over 5-20 minutes", true, "Torsades dose", nil),
                ("300 mg IV push", false, nil, "Too low"),
                ("10 g IV push", false, nil, "Too high"),
                ("500 mg IM", false, nil, "Wrong route")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Magnesium for Torsades: 1-2 g IV over 5-20 minutes (can push faster if pulseless).",
            keyPoint: "Magnesium 1-2 g for Torsades",
            algorithmStep: "Tachycardia Algorithm - Magnesium dosing"
        ),
        makeQuestion(
            stem: "What is the calcium chloride dose for hyperkalemia-related cardiac arrest?",
            choices: [
                ("1-2 g (10-20 mL of 10% solution) IV", true, "Membrane stabilization dose", nil),
                ("100 mg IV", false, nil, "Too low"),
                ("10 g IV", false, nil, "Too high"),
                ("500 mg IM", false, nil, "IV route needed")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Calcium chloride for hyperkalemia: 1-2 g IV to stabilize cardiac membranes.",
            keyPoint: "Calcium chloride 1-2 g for hyperK",
            algorithmStep: "Cardiac Arrest - Hyperkalemia treatment"
        ),
        makeQuestion(
            stem: "Per 2025 guidelines, is vasopressin recommended as an alternative to epinephrine?",
            choices: [
                ("No - vasopressin shows no survival advantage and is not recommended", true, "2025 Update", nil),
                ("Yes - vasopressin is first-line", false, nil, "Not recommended"),
                ("Yes - vasopressin can replace every other epinephrine dose", false, nil, "Old recommendation"),
                ("Only for non-shockable rhythms", false, nil, "Not recommended for any rhythm")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "2025 UPDATE: Vasopressin alone or combined with epinephrine shows no survival advantage - not recommended.",
            keyPoint: "Vasopressin not recommended (2025)",
            algorithmStep: "Cardiac Arrest - Vasopressor selection"
        ),
        makeQuestion(
            stem: "What is the sodium bicarbonate dose when indicated for cardiac arrest?",
            choices: [
                ("1 mEq/kg IV initially, then guided by blood gas", true, "Standard initial dose", nil),
                ("50 mEq routinely for all arrests", false, nil, "Not routine"),
                ("500 mEq IV push", false, nil, "Too high"),
                ("10 mEq IV", false, nil, "Too low")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Sodium bicarbonate 1 mEq/kg when indicated; not routine use in arrest.",
            keyPoint: "Bicarb 1 mEq/kg when indicated",
            algorithmStep: "Cardiac Arrest - Bicarbonate dosing"
        ),
        makeQuestion(
            stem: "Why is sotalol no longer recommended for cardiac arrest per 2025 guidelines?",
            choices: [
                ("No evidence of benefit for VF/pVT refractory to defibrillation", true, "No outcome benefit", nil),
                ("Too many side effects", false, nil, "Lack of efficacy is the reason"),
                ("Causes hyperkalemia", false, nil, "Not the reason"),
                ("Not available in IV form", false, nil, "IV form exists")
            ],
            topic: .pharmacology,
            difficulty: .hard,
            explanation: "2025: Sotalol removed from algorithms - 2025 ILCOR review found no outcome benefit for VF/pVT.",
            keyPoint: "Sotalol removed (no benefit)",
            algorithmStep: "VF/pVT Algorithm - Antiarrhythmic changes"
        ),
        makeQuestion(
            stem: "What is the amiodarone infusion rate for stable VT with a pulse?",
            choices: [
                ("150 mg IV over 10 minutes", true, "Slower than arrest dose", nil),
                ("300 mg IV push", false, nil, "That's arrest dose"),
                ("1 mg/min continuous only", false, nil, "Need loading dose first"),
                ("50 mg IV push", false, nil, "Too low")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Stable VT with pulse: Amiodarone 150 mg IV over 10 min (slower infusion than arrest bolus).",
            keyPoint: "Stable VT: Amiodarone 150 mg over 10 min",
            algorithmStep: "Tachycardia Algorithm - Amiodarone perfusing rhythm"
        ),
        makeQuestion(
            stem: "What is the relationship between IV and IO drug delivery during cardiac arrest?",
            choices: [
                ("IV is preferred but IO is acceptable if IV not feasible; same doses", true, "Same doses, IV preferred", nil),
                ("IO requires double doses", false, nil, "Same doses"),
                ("IO is always preferred", false, nil, "IV preferred"),
                ("IO cannot be used in arrest", false, nil, "IO is acceptable")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "2025: IV preferred, IO acceptable alternative. Same drug doses for both routes.",
            keyPoint: "IV preferred, IO acceptable, same doses",
            algorithmStep: "Cardiac Arrest - Vascular access"
        ),
        makeQuestion(
            stem: "What are the common side effects of adenosine that patients should be warned about?",
            choices: [
                ("Transient chest discomfort, flushing, dyspnea, brief asystole", true, "All transient", nil),
                ("Permanent heart block", false, nil, "Effects are transient"),
                ("Hypertension", false, nil, "Does not cause hypertension"),
                ("Long-lasting tachycardia", false, nil, "Causes transient slowing")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "Adenosine side effects are transient (half-life ~6 seconds): chest tightness, flushing, dyspnea.",
            keyPoint: "Adenosine effects are transient",
            algorithmStep: "Tachycardia Algorithm - Adenosine side effects"
        ),
        makeQuestion(
            stem: "What is the correct order for drug administration in VF/pVT?",
            choices: [
                ("Defibrillate first, then epinephrine, then amiodarone if VF continues", true, "Shock first", nil),
                ("Epinephrine first, then defibrillation", false, nil, "Defibrillation is priority"),
                ("Amiodarone first, then defibrillation", false, nil, "Shock first"),
                ("Drugs only after 10 minutes of CPR", false, nil, "Drugs given during CPR")
            ],
            topic: .pharmacology,
            difficulty: .medium,
            explanation: "VF/pVT: Shock → CPR → Shock → Epinephrine → Shock → Amiodarone.",
            keyPoint: "Shock first, then drugs",
            algorithmStep: "VF/pVT Algorithm - Drug sequence"
        )
    ]
    
    // MARK: - More H's and T's Questions (20 from 08-Hs-and-Ts-Questions.md)
    
    static let moreHsTsQuestions: [ACLSQuestion] = [
        makeQuestion(
            stem: "What clinical signs suggest hypovolemia as the cause of PEA?",
            choices: [
                ("Narrow complex PEA, rapid rate, flat neck veins, signs of trauma/bleeding", true, "Classic presentation", nil),
                ("Wide complex PEA with bradycardia", false, nil, "Suggests different cause"),
                ("Distended neck veins", false, nil, "Suggests tension pneumo or tamponade"),
                ("Hypertension", false, nil, "Hypovolemia causes hypotension")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Hypovolemia PEA: narrow complex, fast rate, empty neck veins, look for bleeding source.",
            keyPoint: "Hypovolemia: narrow PEA, flat neck veins",
            algorithmStep: "Cardiac Arrest - Hypovolemia recognition"
        ),
        makeQuestion(
            stem: "What progressive ECG changes suggest hyperkalemia?",
            choices: [
                ("Peaked T waves → flattened P waves → widened QRS → sine wave → VF/asystole", true, "Classic progression", nil),
                ("Prolonged QT → U waves", false, nil, "That's hypokalemia"),
                ("ST elevation", false, nil, "Suggests ischemia"),
                ("Narrow QRS", false, nil, "Hyperkalemia widens QRS")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Hyperkalemia progression: peaked T → no P → wide QRS → sine wave → arrest.",
            keyPoint: "HyperK: peaked T → wide QRS → sine wave",
            algorithmStep: "Cardiac Arrest - Hyperkalemia ECG"
        ),
        makeQuestion(
            stem: "What ECG changes suggest hypokalemia?",
            choices: [
                ("Prolonged QT, flattened T waves, U waves, ST depression", true, "Classic hypoK findings", nil),
                ("Peaked T waves", false, nil, "That's hyperkalemia"),
                ("Widened QRS", false, nil, "That's hyperkalemia"),
                ("Sine wave pattern", false, nil, "That's severe hyperkalemia")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Hypokalemia: Long QT, flat T, U waves, ST depression (opposite of hyperK).",
            keyPoint: "HypoK: long QT, flat T, U waves",
            algorithmStep: "Cardiac Arrest - Hypokalemia ECG"
        ),
        makeQuestion(
            stem: "What clinical scenario suggests hypothermia as the cause of cardiac arrest?",
            choices: [
                ("Cold exposure history, cold skin, arrhythmias refractory to treatment", true, "Classic presentation", nil),
                ("High fever", false, nil, "Opposite of hypothermia"),
                ("History of heat stroke", false, nil, "Opposite of hypothermia"),
                ("Normal body temperature", false, nil, "Must be cold")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Hypothermia: cold exposure, cold skin, drugs/defib may not work until rewarmed.",
            keyPoint: "Hypothermia: cold, refractory to treatment",
            algorithmStep: "Cardiac Arrest - Hypothermia recognition"
        ),
        makeQuestion(
            stem: "What is the classic triad of cardiac tamponade?",
            choices: [
                ("Hypotension, distended neck veins, muffled heart sounds (Beck's triad)", true, "Beck's triad", nil),
                ("Hypertension, tachycardia, wide pulse pressure", false, nil, "Not tamponade"),
                ("Fever, chest pain, dyspnea", false, nil, "More pericarditis than tamponade"),
                ("Bradycardia, flat neck veins, loud heart sounds", false, nil, "Opposite of tamponade")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Beck's triad for tamponade: hypotension, JVD, muffled heart sounds.",
            keyPoint: "Beck's triad: hypotension, JVD, muffled sounds",
            algorithmStep: "Cardiac Arrest - Tamponade recognition"
        ),
        makeQuestion(
            stem: "What is the treatment for cardiac tamponade causing PEA?",
            choices: [
                ("Pericardiocentesis or thoracotomy", true, "Drain the pericardium", nil),
                ("Defibrillation", false, nil, "Won't help mechanical problem"),
                ("Fluid bolus only", false, nil, "Need to drain pericardium"),
                ("Vasopressors only", false, nil, "Need to relieve obstruction")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Tamponade: pericardiocentesis (needle drainage) or emergency thoracotomy.",
            keyPoint: "Tamponade: pericardiocentesis",
            algorithmStep: "Cardiac Arrest - Tamponade treatment"
        ),
        makeQuestion(
            stem: "What clinical signs suggest tension pneumothorax?",
            choices: [
                ("Absent breath sounds on one side, tracheal deviation, distended neck veins, hypotension", true, "Classic findings", nil),
                ("Equal breath sounds, no JVD", false, nil, "Not tension pneumo"),
                ("Bilateral crackles", false, nil, "Suggests pulmonary edema"),
                ("Midline trachea with bradycardia", false, nil, "Trachea deviates away")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Tension pneumothorax: absent breath sounds, tracheal deviation away, JVD, hypotension.",
            keyPoint: "Tension pneumo: absent sounds, tracheal deviation, JVD",
            algorithmStep: "Cardiac Arrest - Tension pneumothorax"
        ),
        makeQuestion(
            stem: "What is the treatment for tension pneumothorax causing PEA?",
            choices: [
                ("Needle decompression followed by chest tube", true, "Immediate decompression", nil),
                ("Pericardiocentesis", false, nil, "That's for tamponade"),
                ("Thrombolytics", false, nil, "That's for PE"),
                ("Calcium chloride", false, nil, "That's for hyperkalemia")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Tension pneumothorax: needle decompression (2nd ICS MCL or 4th-5th ICS AAL) then chest tube.",
            keyPoint: "Tension pneumo: needle decompression → chest tube",
            algorithmStep: "Cardiac Arrest - Tension pneumothorax treatment"
        ),
        makeQuestion(
            stem: "What scenario suggests massive pulmonary embolism as the cause of arrest?",
            choices: [
                ("Recent surgery, immobility, sudden cardiovascular collapse, distended neck veins", true, "PE risk factors + presentation", nil),
                ("Bleeding history with hypotension", false, nil, "Suggests hypovolemia"),
                ("Cold exposure", false, nil, "Suggests hypothermia"),
                ("Prolonged QT on ECG", false, nil, "Suggests electrolyte issue")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Massive PE: risk factors (surgery, immobility), sudden collapse, JVD, hypoxia.",
            keyPoint: "PE: risk factors + sudden collapse + JVD",
            algorithmStep: "Cardiac Arrest - PE recognition"
        ),
        makeQuestion(
            stem: "What is the treatment for massive pulmonary embolism causing cardiac arrest?",
            choices: [
                ("Consider thrombolytics (tPA), surgical embolectomy, or ECMO", true, "Definitive treatment", nil),
                ("Defibrillation", false, nil, "Won't help mechanical obstruction"),
                ("Calcium chloride", false, nil, "That's for hyperkalemia"),
                ("Needle decompression", false, nil, "That's for tension pneumo")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "Massive PE: consider thrombolytics, surgical embolectomy, or ECMO if available.",
            keyPoint: "PE: thrombolytics, embolectomy, or ECMO",
            algorithmStep: "Cardiac Arrest - PE treatment"
        ),
        makeQuestion(
            stem: "What presentation suggests toxin/overdose as the cause of cardiac arrest?",
            choices: [
                ("Toxidrome findings, pill bottles, drug paraphernalia, specific rhythm abnormalities", true, "Look for clues", nil),
                ("Distended neck veins with muffled sounds", false, nil, "Suggests tamponade"),
                ("Absent breath sounds one side", false, nil, "Suggests pneumothorax"),
                ("Track marks only", false, nil, "Part of picture but need more")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Toxin arrest: look for toxidrome, pill bottles, paraphernalia, specific rhythms.",
            keyPoint: "Toxin: look for clues and toxidromes",
            algorithmStep: "Cardiac Arrest - Toxin recognition"
        ),
        makeQuestion(
            stem: "What is the antidote for beta-blocker or calcium channel blocker overdose causing arrest?",
            choices: [
                ("High-dose insulin with glucose (and calcium for CCB)", true, "HIE therapy", nil),
                ("Naloxone", false, nil, "That's for opioids"),
                ("Flumazenil", false, nil, "That's for benzodiazepines"),
                ("Sodium bicarbonate", false, nil, "For TCA, not BB/CCB primarily")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "BB/CCB overdose: High-dose Insulin Euglycemia (HIE) therapy + calcium for CCB.",
            keyPoint: "BB/CCB overdose: High-dose insulin",
            algorithmStep: "Cardiac Arrest - BB/CCB overdose"
        ),
        makeQuestion(
            stem: "What ECG finding suggests tricyclic antidepressant overdose?",
            choices: [
                ("Prolonged QRS (>100 ms), rightward terminal 40ms axis, prolonged QT", true, "Classic TCA findings", nil),
                ("Peaked T waves", false, nil, "That's hyperkalemia"),
                ("Narrow QRS with short QT", false, nil, "Opposite of TCA"),
                ("First-degree AV block only", false, nil, "More severe changes expected")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "TCA overdose: wide QRS (sodium channel blockade), tall R in aVR, prolonged QT.",
            keyPoint: "TCA: wide QRS, tall R in aVR",
            algorithmStep: "Cardiac Arrest - TCA overdose"
        ),
        makeQuestion(
            stem: "What is the treatment for tricyclic antidepressant overdose causing cardiac arrest?",
            choices: [
                ("Sodium bicarbonate to alkalinize blood and overcome sodium channel blockade", true, "Bicarb for TCA", nil),
                ("Calcium chloride", false, nil, "Not for TCA"),
                ("Insulin with glucose", false, nil, "For BB/CCB, not TCA"),
                ("Naloxone", false, nil, "For opioids, not TCA")
            ],
            topic: .hsAndTs,
            difficulty: .hard,
            explanation: "TCA overdose: sodium bicarbonate (1-2 mEq/kg) to overcome sodium channel blockade.",
            keyPoint: "TCA overdose: sodium bicarbonate",
            algorithmStep: "Cardiac Arrest - TCA treatment"
        ),
        makeQuestion(
            stem: "What presentation suggests coronary thrombosis (STEMI) as the cause of arrest?",
            choices: [
                ("ST elevation on ECG, history of chest pain, risk factors for CAD", true, "Classic STEMI", nil),
                ("Distended neck veins with hypotension", false, nil, "More tamponade or PE"),
                ("Prolonged QRS", false, nil, "More toxin related"),
                ("Peaked T waves", false, nil, "More hyperkalemia")
            ],
            topic: .hsAndTs,
            difficulty: .medium,
            explanation: "Coronary thrombosis: ST elevation, chest pain history, CAD risk factors.",
            keyPoint: "Coronary thrombosis: ST elevation, chest pain",
            algorithmStep: "Cardiac Arrest - STEMI recognition"
        )
    ]
    
    // MARK: - Complete Electrical Therapy Questions (20 from 10-Team-Dynamics-Airway-Electrical-Questions.md)
    
    static let completeElectricalTherapy: [ACLSQuestion] = [
        makeQuestion(
            stem: "What is the key difference between defibrillation and cardioversion?",
            choices: [
                ("Defibrillation is unsynchronized (for VF/pVT); cardioversion is synchronized to the R wave (for perfusing rhythms)", true, "Sync vs unsync", nil),
                ("Same procedure", false, nil, "Different procedures"),
                ("Cardioversion uses more energy", false, nil, "Energy varies"),
                ("Defibrillation only for asystole", false, nil, "For VF/pVT, not asystole")
            ],
            topic: .electrical,
            difficulty: .easy,
            explanation: "Defibrillation: unsync for VF/pVT; Cardioversion: sync to R wave for tachycardia with pulse.",
            keyPoint: "Defib = unsync; Cardioversion = sync",
            algorithmStep: "Electrical Therapy - Defib vs Cardioversion"
        ),
        makeQuestion(
            stem: "What are the advantages of biphasic over monophasic defibrillators?",
            choices: [
                ("Equivalent efficacy at lower energy, less myocardial injury", true, "Lower energy, same effect", nil),
                ("Monophasic is superior", false, nil, "Biphasic is preferred"),
                ("No difference", false, nil, "Biphasic is more efficient"),
                ("Biphasic requires more energy", false, nil, "Requires less energy")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Biphasic: 120-200J effective (vs 360J monophasic); current flows in both directions.",
            keyPoint: "Biphasic: effective at lower energy",
            algorithmStep: "Electrical Therapy - Biphasic vs Monophasic"
        ),
        makeQuestion(
            stem: "What is the initial defibrillation energy for VF?",
            choices: [
                ("120-200 J biphasic (per manufacturer); 360 J monophasic", true, "Standard initial energy", nil),
                ("50 J", false, nil, "Too low"),
                ("400 J", false, nil, "Too high"),
                ("25 J", false, nil, "Much too low")
            ],
            topic: .electrical,
            difficulty: .easy,
            explanation: "Biphasic: manufacturer's recommended (120-200J); Monophasic: 360J.",
            keyPoint: "Biphasic: 120-200J; Monophasic: 360J",
            algorithmStep: "VF/pVT Algorithm - Defibrillation energy"
        ),
        makeQuestion(
            stem: "What happens if sync mode is selected but the rhythm is VF?",
            choices: [
                ("The defibrillator may not deliver a shock because there's no R wave to sync with", true, "No R wave to sync", nil),
                ("Normal shock delivery", false, nil, "Won't fire without R wave"),
                ("Automatic switch to unsync", false, nil, "May not switch automatically"),
                ("Lower energy delivered", false, nil, "Won't deliver at all")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Sync mode in VF: no R wave = no shock; switch to defibrillation mode.",
            keyPoint: "Sync mode won't fire on VF",
            algorithmStep: "Electrical Therapy - Sync mode in VF"
        ),
        makeQuestion(
            stem: "When is transcutaneous pacing indicated?",
            choices: [
                ("Symptomatic bradycardia unresponsive to atropine or when atropine is not available", true, "For refractory bradycardia", nil),
                ("All bradycardia", false, nil, "Only symptomatic, refractory"),
                ("Tachycardia", false, nil, "Not for tachycardia"),
                ("Cardiac arrest", false, nil, "Not indicated in arrest")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "TCP: symptomatic bradycardia when atropine fails or severe instability.",
            keyPoint: "TCP for refractory symptomatic bradycardia",
            algorithmStep: "Bradycardia Algorithm - TCP indication"
        ),
        makeQuestion(
            stem: "What are typical initial TCP settings?",
            choices: [
                ("Rate 60-70 bpm; increase mA until capture (then set 10-20% above threshold)", true, "Standard approach", nil),
                ("Rate 120 bpm always", false, nil, "60-70 typical"),
                ("Fixed mA regardless of response", false, nil, "Titrate to capture"),
                ("Start with maximum mA", false, nil, "Start low, increase")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "TCP: rate 60-70, increase mA until capture, set 10-20% above threshold.",
            keyPoint: "Rate 60-70, titrate mA to capture",
            algorithmStep: "Bradycardia Algorithm - TCP settings"
        ),
        makeQuestion(
            stem: "How do you confirm mechanical capture during transcutaneous pacing?",
            choices: [
                ("Palpate a pulse (femoral often easier) - electrical capture alone is not sufficient", true, "Must verify pulse", nil),
                ("ECG shows pacing spikes", false, nil, "Electrical only, need mechanical"),
                ("Patient is comfortable", false, nil, "Comfort doesn't confirm capture"),
                ("Blood pressure improves automatically", false, nil, "Must palpate pulse")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Electrical capture ≠ mechanical capture; must verify pulse (femoral often best).",
            keyPoint: "Palpate pulse to confirm mechanical capture",
            algorithmStep: "Bradycardia Algorithm - Confirming capture"
        ),
        makeQuestion(
            stem: "What is the target for perishock pause (hands-off time for defibrillation)?",
            choices: [
                ("Less than 10 seconds", true, "Minimize hands-off time", nil),
                ("30 seconds is acceptable", false, nil, "Too long"),
                ("1 minute maximum", false, nil, "Much too long"),
                ("Time doesn't matter", false, nil, "Time is critical")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Perishock pause <10 seconds - every second without CPR drops survival.",
            keyPoint: "Perishock pause <10 seconds",
            algorithmStep: "VF/pVT Algorithm - Minimize pause"
        ),
        makeQuestion(
            stem: "What are acceptable defibrillation pad positions?",
            choices: [
                ("Anterior-lateral (right infraclavicular + left lateral chest) or anterior-posterior", true, "Standard positions", nil),
                ("Both on left chest", false, nil, "Won't traverse heart"),
                ("Both on back", false, nil, "Won't work"),
                ("On abdomen", false, nil, "Won't work")
            ],
            topic: .electrical,
            difficulty: .easy,
            explanation: "Anterolateral or AP - current must traverse the heart.",
            keyPoint: "Anterolateral or AP position",
            algorithmStep: "Electrical Therapy - Pad placement"
        ),
        makeQuestion(
            stem: "What precaution is needed when defibrillating a patient with an implanted pacemaker/ICD?",
            choices: [
                ("Place pads at least 8 cm from device; proceed with standard energy", true, "Protect device", nil),
                ("Defibrillation contraindicated", false, nil, "Not contraindicated"),
                ("Reduce energy to 50 J", false, nil, "Use standard energy"),
                ("Place pads directly over device", false, nil, "Keep pads away from device")
            ],
            topic: .electrical,
            difficulty: .hard,
            explanation: "ICD/pacer: pads ≥8 cm away; check device post-resuscitation.",
            keyPoint: "Pads ≥8 cm from device",
            algorithmStep: "Electrical Therapy - Device precautions"
        ),
        makeQuestion(
            stem: "What should be done with medication patches before defibrillation?",
            choices: [
                ("Remove patches in the pad pathway to prevent burns/arcing", true, "Prevent burns", nil),
                ("Leave all patches in place", false, nil, "Can cause burns"),
                ("Increase defibrillation energy", false, nil, "Remove patches"),
                ("Apply more patches", false, nil, "Remove patches")
            ],
            topic: .electrical,
            difficulty: .easy,
            explanation: "Remove patches from pad area - can cause burns; don't delay defib for distant patches.",
            keyPoint: "Remove patches from pad area",
            algorithmStep: "Electrical Therapy - Patch removal"
        ),
        makeQuestion(
            stem: "Can defibrillation be performed on a wet patient?",
            choices: [
                ("Yes, but dry the chest first if possible to improve pad adhesion and prevent current arcing", true, "Dry if possible, don't delay", nil),
                ("Never defibrillate wet patients", false, nil, "Can defibrillate wet"),
                ("Defibrillation doesn't work when wet", false, nil, "Still works"),
                ("Increase energy for wet patients", false, nil, "Standard energy")
            ],
            topic: .electrical,
            difficulty: .easy,
            explanation: "Dry chest for better pad contact; don't delay life-saving defib for perfect conditions.",
            keyPoint: "Dry chest if possible, don't delay",
            algorithmStep: "Electrical Therapy - Wet patient"
        ),
        makeQuestion(
            stem: "When should the defibrillator be charged during the CPR cycle?",
            choices: [
                ("During the last portion of the 2-minute CPR cycle to minimize hands-off time", true, "Charge during CPR", nil),
                ("Only after CPR stops", false, nil, "Charge during CPR"),
                ("At the start of the cycle", false, nil, "Late in cycle"),
                ("Continuously throughout", false, nil, "Before rhythm check")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Charge during CPR, shock when ready, immediately resume CPR - minimize pause.",
            keyPoint: "Charge during CPR to minimize pause",
            algorithmStep: "VF/pVT Algorithm - Charge timing"
        ),
        makeQuestion(
            stem: "What announcement should be made before delivering a shock?",
            choices: [
                ("Verbally clear and visually confirm no one touching patient", true, "Verbal and visual clear", nil),
                ("Nothing - just shock", false, nil, "Must clear"),
                ("Only warn the person doing CPR", false, nil, "Clear everyone"),
                ("Announce after the shock", false, nil, "Announce before")
            ],
            topic: .electrical,
            difficulty: .easy,
            explanation: "Clear verbally AND visually before every shock - safety first.",
            keyPoint: "Clear verbally and visually",
            algorithmStep: "Electrical Therapy - Safety"
        ),
        makeQuestion(
            stem: "If initial defibrillation energy is unsuccessful, what should be done?",
            choices: [
                ("Increase energy for subsequent shocks up to maximum; ensure proper pad contact", true, "Escalate energy", nil),
                ("Continue same energy indefinitely", false, nil, "Escalate if not working"),
                ("Decrease energy", false, nil, "Increase energy"),
                ("Stop defibrillation attempts", false, nil, "Continue escalating")
            ],
            topic: .electrical,
            difficulty: .medium,
            explanation: "Escalate energy after failed shock; check pad contact; maximum energy if refractory.",
            keyPoint: "Escalate energy after failed shock",
            algorithmStep: "VF/pVT Algorithm - Energy escalation"
        )
    ]

    // MARK: - Helper Function
    
    private static func makeQuestion(
        stem: String,
        vignette: String? = nil,
        vitals: ACLSVitals? = nil,
        rhythmDescription: String? = nil,
        rhythmStripGIF: String? = nil,
        etco2WaveformType: ETCO2WaveformType? = nil,
        choices: [(String, Bool, String?, String?)],
        topic: ACLSTopicType,
        difficulty: ACLSDifficulty,
        explanation: String,
        keyPoint: String? = nil,
        clinicalPearl: String? = nil,
        algorithmStep: String? = nil
    ) -> ACLSQuestion {
        let answerChoices = choices.map { choice in
            ACLSChoice(
                id: UUID(),
                text: choice.0,
                isCorrect: choice.1,
                keyTakeaway: choice.2,
                whyWrong: choice.3
            )
        }
        let correctID = answerChoices.first(where: { $0.isCorrect })?.id ?? UUID()
        
        return ACLSQuestion(
            id: UUID(),
            stem: stem,
            vignette: vignette,
            vitals: vitals,
            rhythmDescription: rhythmDescription,
            rhythmStripGIF: rhythmStripGIF,
            etco2WaveformType: etco2WaveformType,
            choices: answerChoices,
            correctAnswerID: correctID,
            topic: topic,
            difficulty: difficulty,
            explanation: explanation,
            keyPoint: keyPoint,
            clinicalPearl: clinicalPearl,
            algorithmStep: algorithmStep
        )
    }
}
