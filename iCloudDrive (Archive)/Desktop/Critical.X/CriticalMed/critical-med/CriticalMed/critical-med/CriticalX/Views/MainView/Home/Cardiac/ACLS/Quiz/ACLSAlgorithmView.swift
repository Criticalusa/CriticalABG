//
//  ACLSAlgorithmView.swift
//  CriticalX
//
//  Interactive ACLS Algorithm Step-Through
//  Learn by doing - work through algorithms with decision points
//
//  Created: January 2026
//

import SwiftUI

// MARK: - Algorithm Selection View

struct ACLSAlgorithmSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedAlgorithm: ACLSAlgorithmType? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: CriticalDesign.Spacing.lg) {
                        headerSection
                        
                        ForEach(ACLSAlgorithmType.allCases, id: \.self) { algorithm in
                            AlgorithmCard(algorithm: algorithm) {
                                selectedAlgorithm = algorithm
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding()
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("ACLS Algorithms")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(item: $selectedAlgorithm) { algorithm in
                ACLSAlgorithmStepView(algorithm: algorithm)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "arrow.triangle.branch")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Interactive Algorithms")
                .font(.custom("Poppins-Bold", size: 24))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("Step through each algorithm with decision points")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }
}

// MARK: - Algorithm Card

struct AlgorithmCard: View {
    let algorithm: ACLSAlgorithmType
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(algorithm.color.opacity(0.15))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: algorithm.icon)
                        .font(.system(size: 24))
                        .foregroundColor(algorithm.color)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(algorithm.title)
                        .font(.custom("Poppins-SemiBold", size: 17))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Text(algorithm.subtitle)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .lineLimit(2)
                    
                    HStack(spacing: 8) {
                        Label("\(algorithm.steps.count) steps", systemImage: "list.number")
                        Label(algorithm.difficulty, systemImage: "chart.bar.fill")
                    }
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(algorithm.color)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                    .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.06), radius: 8, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        colorScheme == .dark
                            ? LinearGradient(colors: [CriticalDesign.Colors.gold.opacity(0.5), CriticalDesign.Colors.gold.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [algorithm.color.opacity(0.2), algorithm.color.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Algorithm Step-Through View

struct ACLSAlgorithmStepView: View {
    let algorithm: ACLSAlgorithmType
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var currentStepIndex: Int = 0
    @State private var completedSteps: Set<Int> = []
    @State private var showDecisionPoint: Bool = false
    @State private var selectedDecision: String? = nil
    
    private var currentStep: AlgorithmStep {
        algorithm.steps[currentStepIndex]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress indicator
                    progressBar
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            stepCard
                            
                            if let decisionPoint = currentStep.decisionPoint {
                                decisionCard(decisionPoint)
                            }
                            
                            clinicalTip
                            
                            Spacer(minLength: 100)
                        }
                        .padding()
                    }
                    .scrollContentBackground(.hidden)
                    
                    // Navigation buttons
                    navigationBar
                }
            }
            .navigationTitle(algorithm.shortTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Exit") { dismiss() }
                }
            }
        }
    }
    
    // MARK: - Progress Bar

    /// Computed completion percentage to help compiler
    private var completionPercent: Int {
        guard algorithm.steps.count > 0 else { return 0 }
        return Int(Double(completedSteps.count) / Double(algorithm.steps.count) * 100)
    }

    /// Computed progress fraction to help compiler
    private var progressFraction: CGFloat {
        guard algorithm.steps.count > 0 else { return 0 }
        return CGFloat(currentStepIndex + 1) / CGFloat(algorithm.steps.count)
    }

    private var progressBar: some View {
        VStack(spacing: 8) {
            progressBarHeader
            progressBarTrack
        }
        .padding()
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.9))
    }

    private var progressBarHeader: some View {
        HStack {
            Text("Step \(currentStepIndex + 1) of \(algorithm.steps.count)")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            Spacer()

            Text("\(completionPercent)% Complete")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(algorithm.color)
        }
    }

    private var progressBarTrack: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.6) : Color(.systemGray5))
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 4)
                    .fill(algorithm.color)
                    .frame(width: geometry.size.width * progressFraction, height: 8)
            }
        }
        .frame(height: 8)
    }
    
    // MARK: - Step Card
    
    private var stepCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Step header
            HStack {
                ZStack {
                    Circle()
                        .fill(algorithm.color)
                        .frame(width: 40, height: 40)
                    
                    Text("\(currentStepIndex + 1)")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(currentStep.title)
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Text(currentStep.phase)
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(algorithm.color)
                }
                
                Spacer()
                
                if currentStep.isCritical {
                    Label("Critical", systemImage: "exclamationmark.triangle.fill")
                        .font(.custom("Poppins-SemiBold", size: 11))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
            
            Divider()
            
            // Step content
            Text(currentStep.content)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(6)
            
            // Key actions
            if !currentStep.keyActions.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Actions:")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    ForEach(currentStep.keyActions, id: \.self) { action in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text(action)
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        }
                    }
                }
                .padding()
                .background(Color.green.opacity(colorScheme == .dark ? 0.15 : 0.08))
                .cornerRadius(12)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.08), radius: 10, y: 4)
        )
        .overlay(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(colors: [CriticalDesign.Colors.gold.opacity(0.5), CriticalDesign.Colors.gold.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 1
                        )
                }
            }
        )
    }
    
    // MARK: - Decision Card
    
    private func decisionCard(_ decision: DecisionPoint) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "arrow.triangle.branch")
                    .foregroundColor(.orange)
                Text("Decision Point")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(.orange)
            }
            
            Text(decision.question)
                .font(.custom("Poppins-SemiBold", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            ForEach(decision.options, id: \.self) { option in
                Button(action: {
                    selectedDecision = option
                }) {
                    HStack {
                        Image(systemName: selectedDecision == option ? "circle.inset.filled" : "circle")
                            .foregroundColor(selectedDecision == option ? algorithm.color : CriticalDesign.Colors.tertiary)
                        
                        Text(option)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedDecision == option ? algorithm.color.opacity(0.15) : (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color(.systemGray6)))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedDecision == option ? algorithm.color : Color.clear, lineWidth: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(colorScheme == .dark ? 0.15 : 0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Clinical Tip
    
    private var clinicalTip: some View {
        Group {
            if let tip = currentStep.clinicalTip {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Clinical Pearl")
                            .font(.custom("Poppins-SemiBold", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        
                        Text(tip)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.yellow.opacity(colorScheme == .dark ? 0.18 : 0.1))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Navigation Bar
    
    private var navigationBar: some View {
        HStack(spacing: 16) {
            // Previous button
            Button(action: previousStep) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Previous")
                }
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(currentStepIndex > 0 ? algorithm.color : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(currentStepIndex > 0 ? algorithm.color : Color.gray, lineWidth: 2)
                )
            }
            .disabled(currentStepIndex == 0)
            
            // Next/Complete button
            Button(action: nextStep) {
                HStack {
                    Text(isLastStep ? "Complete" : "Next")
                    Image(systemName: isLastStep ? "checkmark" : "chevron.right")
                }
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(algorithm.color)
                )
            }
        }
        .padding()
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
    }
    
    private var isLastStep: Bool {
        currentStepIndex >= algorithm.steps.count - 1
    }
    
    private func nextStep() {
        completedSteps.insert(currentStepIndex)
        
        if isLastStep {
            dismiss()
        } else {
            withAnimation {
                currentStepIndex += 1
                selectedDecision = nil
            }
        }
    }
    
    private func previousStep() {
        guard currentStepIndex > 0 else { return }
        withAnimation {
            currentStepIndex -= 1
            selectedDecision = nil
        }
    }
}

// MARK: - Algorithm Types

enum ACLSAlgorithmType: String, CaseIterable, Identifiable {
    case cardiacArrest = "cardiac_arrest"
    case bradycardia = "bradycardia"
    case tachycardia = "tachycardia"
    case postROSC = "post_rosc"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .cardiacArrest: return "Cardiac Arrest Algorithm"
        case .bradycardia: return "Bradycardia Algorithm"
        case .tachycardia: return "Tachycardia Algorithm"
        case .postROSC: return "Post-Cardiac Arrest Care"
        }
    }
    
    var shortTitle: String {
        switch self {
        case .cardiacArrest: return "Cardiac Arrest"
        case .bradycardia: return "Bradycardia"
        case .tachycardia: return "Tachycardia"
        case .postROSC: return "Post-ROSC"
        }
    }
    
    var subtitle: String {
        switch self {
        case .cardiacArrest: return "VF/pVT vs PEA/Asystole pathways"
        case .bradycardia: return "Symptomatic bradycardia management"
        case .tachycardia: return "Stable vs unstable, narrow vs wide"
        case .postROSC: return "Post-arrest optimization and TTM"
        }
    }
    
    var icon: String {
        switch self {
        case .cardiacArrest: return "bolt.heart.fill"
        case .bradycardia: return "heart.slash"
        case .tachycardia: return "bolt.fill"
        case .postROSC: return "heart.text.square.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .cardiacArrest: return .red
        case .bradycardia: return .purple
        case .tachycardia: return .orange
        case .postROSC: return .teal
        }
    }
    
    var difficulty: String {
        switch self {
        case .cardiacArrest: return "Core"
        case .bradycardia: return "Core"
        case .tachycardia: return "Advanced"
        case .postROSC: return "Advanced"
        }
    }
    
    var steps: [AlgorithmStep] {
        switch self {
        case .cardiacArrest:
            return cardiacArrestSteps
        case .bradycardia:
            return bradycardiaSteps
        case .tachycardia:
            return tachycardiaSteps
        case .postROSC:
            return postROSCSteps
        }
    }
}

// MARK: - Algorithm Step Model

struct AlgorithmStep: Identifiable {
    let id = UUID()
    let title: String
    let phase: String
    let content: String
    let keyActions: [String]
    var isCritical: Bool = false
    var clinicalTip: String? = nil
    var decisionPoint: DecisionPoint? = nil
}

struct DecisionPoint {
    let question: String
    let options: [String]
}

// MARK: - Algorithm Steps Data

private let cardiacArrestSteps: [AlgorithmStep] = [
    AlgorithmStep(
        title: "Recognize Cardiac Arrest",
        phase: "Initial Assessment",
        content: "Check for responsiveness and breathing. If unresponsive with no breathing or only gasping, assume cardiac arrest. Do not delay CPR to check for a pulse for more than 10 seconds.",
        keyActions: ["Shout for help", "Activate emergency response", "Get AED/defibrillator"],
        isCritical: true,
        clinicalTip: "Gasping is NOT normal breathing. Start CPR immediately if patient is unresponsive with agonal respirations."
    ),
    AlgorithmStep(
        title: "Start High-Quality CPR",
        phase: "BLS Foundation",
        content: "Begin chest compressions immediately. Push hard (at least 2 inches) and fast (100-120/min). Allow complete chest recoil. Minimize interruptions (<10 seconds).",
        keyActions: ["Compress 100-120/min", "Depth 2-2.4 inches", "Allow full recoil", "Minimize pauses"],
        isCritical: true,
        clinicalTip: "Compression fraction should be >60%, ideally 80%. The quality of CPR directly impacts survival."
    ),
    AlgorithmStep(
        title: "Analyze Rhythm",
        phase: "Rhythm Check",
        content: "When the AED/monitor is ready, pause briefly to analyze the rhythm. Is this a shockable rhythm (VF/pVT) or non-shockable (PEA/Asystole)?",
        keyActions: ["Pause CPR briefly for rhythm check", "Identify shockable vs non-shockable"],
        clinicalTip: "Keep rhythm checks brief (<10 seconds). Resume CPR immediately after the shock or if non-shockable.",
        decisionPoint: DecisionPoint(
            question: "What rhythm do you see?",
            options: ["VF/Pulseless VT (Shockable)", "PEA/Asystole (Non-shockable)"]
        )
    ),
    AlgorithmStep(
        title: "Defibrillate (if shockable)",
        phase: "Electrical Therapy",
        content: "For VF/pVT, defibrillate immediately at ≥200J biphasic. Resume CPR immediately after the shock without pausing to recheck rhythm.",
        keyActions: ["Shock at ≥200J biphasic", "Resume CPR immediately", "2 minutes of CPR before next rhythm check"],
        isCritical: true,
        clinicalTip: "Every minute delay in defibrillation reduces survival by 7-10%. Shock VF fast!"
    ),
    AlgorithmStep(
        title: "Vascular Access & Epinephrine",
        phase: "ACLS Interventions",
        content: "Establish IV/IO access. For shockable rhythms, give epinephrine after the 2nd shock. For non-shockable rhythms, give epinephrine as early as possible.",
        keyActions: ["IV preferred over IO", "Epinephrine 1mg every 3-5 min", "Consider advanced airway"],
        clinicalTip: "2025 Update: IV is first-line. IO is backup if IV fails. For PEA/Asystole, give epinephrine ASAP."
    ),
    AlgorithmStep(
        title: "Antiarrhythmics (if refractory VF/pVT)",
        phase: "Medication",
        content: "After 3+ shocks for persistent VF/pVT, consider amiodarone 300mg IV/IO first dose, then 150mg for second dose. Lidocaine is an alternative.",
        keyActions: ["Amiodarone 300mg IV/IO (1st dose)", "Amiodarone 150mg IV/IO (2nd dose)", "Lidocaine alternative: 1-1.5mg/kg"],
        clinicalTip: "2025 Update: Sotalol is NO LONGER recommended for VF/pVT."
    ),
    AlgorithmStep(
        title: "Treat Reversible Causes",
        phase: "H's and T's",
        content: "Consider and treat reversible causes continuously throughout resuscitation. The H's and T's are not explicitly listed in 2025 algorithms but should be considered.",
        keyActions: ["Hypovolemia - Fluid bolus", "Hypoxia - Optimize oxygenation", "Hyperkalemia - Calcium, bicarb, insulin", "Tension pneumo - Needle decompression"],
        clinicalTip: "In PEA/Asystole, the ONLY chance of survival is finding and fixing a reversible cause."
    ),
    AlgorithmStep(
        title: "ROSC or Termination",
        phase: "Outcome",
        content: "Continue CPR cycles with rhythm checks every 2 minutes. If ROSC is achieved, proceed to post-cardiac arrest care. If no ROSC after prolonged resuscitation, consider termination.",
        keyActions: ["Monitor for ROSC signs", "Check pulse with organized rhythm", "Consider termination criteria"],
        clinicalTip: "Signs of ROSC: sudden sustained increase in ETCO2 (typically ≥40 mmHg), spontaneous arterial pressure waves, return of pulse."
    )
]

private let bradycardiaSteps: [AlgorithmStep] = [
    AlgorithmStep(
        title: "Identify Bradycardia",
        phase: "Recognition",
        content: "Heart rate <60 bpm. Before treating the rhythm, assess for signs of hemodynamic compromise.",
        keyActions: ["Check HR <60 bpm", "Assess mental status", "Check blood pressure"],
        clinicalTip: "Not all bradycardia needs treatment. Assess if the patient is symptomatic."
    ),
    AlgorithmStep(
        title: "Assess for Compromise",
        phase: "2025 Update",
        content: "Cardiopulmonary compromise is now assessed FIRST. Look for: hypotension, altered mental status, signs of shock, ischemic chest discomfort, acute heart failure.",
        keyActions: ["Hypotension?", "Altered mental status?", "Signs of shock?", "Chest pain?"],
        isCritical: true,
        clinicalTip: "2025 Update: Treat compromise before underlying cause.",
        decisionPoint: DecisionPoint(
            question: "Is the patient hemodynamically compromised?",
            options: ["Yes - Proceed with treatment", "No - Monitor and identify cause"]
        )
    ),
    AlgorithmStep(
        title: "Atropine",
        phase: "First-Line Treatment",
        content: "For symptomatic bradycardia, give Atropine 1mg IV. May repeat every 3-5 minutes. Maximum total dose: 3mg.",
        keyActions: ["Atropine 1mg IV", "Repeat every 3-5 minutes", "Maximum 3mg total"],
        clinicalTip: "2025 Update: Atropine dose is now 1mg (previously 0.5-1mg)."
    ),
    AlgorithmStep(
        title: "Second-Line: Pacing or Infusion",
        phase: "If Atropine Fails",
        content: "If atropine is ineffective, use transcutaneous pacing OR start a vasopressor infusion. Dopamine and epinephrine are equally effective alternatives.",
        keyActions: ["Transcutaneous pacing", "Dopamine 2-20 mcg/kg/min", "Epinephrine 2-10 mcg/min"],
        clinicalTip: "TCP can be uncomfortable. Consider sedation if patient is conscious."
    ),
    AlgorithmStep(
        title: "Consider Transvenous Pacing",
        phase: "Refractory Cases",
        content: "For refractory symptomatic bradycardia unresponsive to atropine and TCP, temporary transvenous pacing may be considered.",
        keyActions: ["Consult cardiology", "Prepare for transvenous pacer"],
        clinicalTip: "Expert consultation is needed for transvenous pacing placement."
    )
]

private let tachycardiaSteps: [AlgorithmStep] = [
    AlgorithmStep(
        title: "Identify Tachycardia",
        phase: "Recognition",
        content: "Heart rate >100 bpm. Obtain 12-lead ECG if possible. Determine if the QRS is narrow (<120ms) or wide (≥120ms).",
        keyActions: ["Confirm HR >100 bpm", "Get 12-lead ECG", "Measure QRS width"],
        clinicalTip: "A rhythm strip is essential. QRS width determines your algorithm pathway."
    ),
    AlgorithmStep(
        title: "Assess Stability",
        phase: "Critical Assessment",
        content: "Is the patient UNSTABLE? Signs of instability: hypotension, altered mental status, signs of shock, ischemic chest pain, acute heart failure.",
        keyActions: ["Check blood pressure", "Assess mental status", "Look for chest pain", "Check for heart failure signs"],
        isCritical: true,
        clinicalTip: "If unstable, don't delay treatment for additional workup. Cardiovert immediately.",
        decisionPoint: DecisionPoint(
            question: "Is the patient hemodynamically stable?",
            options: ["UNSTABLE - Needs immediate cardioversion", "STABLE - Can pursue pharmacologic options"]
        )
    ),
    AlgorithmStep(
        title: "Unstable: Synchronized Cardioversion",
        phase: "Immediate Treatment",
        content: "For UNSTABLE tachycardia, perform synchronized cardioversion. Energy: AFib/Flutter ≥200J, Narrow complex 100J, Wide monomorphic 100J. Sedate whenever feasible.",
        keyActions: ["Sedate if possible", "Synchronized cardioversion", "Use appropriate energy"],
        isCritical: true,
        clinicalTip: "2025 Update: Energy levels increased. Use max settings if unsure. Polymorphic VT = unsynchronized shock."
    ),
    AlgorithmStep(
        title: "Stable Narrow Complex: Vagal & Adenosine",
        phase: "Stable SVT Treatment",
        content: "For stable, regular, narrow-complex tachycardia (SVT): Try vagal maneuvers first. If ineffective, give adenosine 6mg rapid IV push, may repeat at 12mg.",
        keyActions: ["Vagal maneuvers (Valsalva, carotid massage)", "Adenosine 6mg rapid IV push", "May repeat adenosine 12mg"],
        clinicalTip: "Give adenosine as close to the heart as possible. Follow with 20mL saline flush."
    ),
    AlgorithmStep(
        title: "Stable Wide Complex",
        phase: "Wide QRS Treatment",
        content: "For stable, wide-complex tachycardia: Consider adenosine if regular and monomorphic (diagnostic use). Consider amiodarone 150mg IV over 10 minutes.",
        keyActions: ["Consider adenosine if regular monomorphic", "Amiodarone 150mg IV over 10 min", "Avoid calcium channel blockers"],
        clinicalTip: "2025 Update: Sotalol is NO LONGER recommended. Do NOT give verapamil/diltiazem for wide-complex tachycardia."
    )
]

private let postROSCSteps: [AlgorithmStep] = [
    AlgorithmStep(
        title: "Confirm ROSC",
        phase: "Immediate",
        content: "Verify return of spontaneous circulation: check pulse, blood pressure, ETCO2 (should increase to ≥40 mmHg with ROSC).",
        keyActions: ["Confirm pulse", "Check blood pressure", "Monitor ETCO2"],
        clinicalTip: "ETCO2 >40 mmHg is a good sign of ROSC. Continue monitoring closely."
    ),
    AlgorithmStep(
        title: "Optimize Airway",
        phase: "Airway Management",
        content: "Assess, place, or exchange advanced airway. Confirm placement with continuous waveform capnography. Maintain oxygenation and ventilation.",
        keyActions: ["Confirm ETT placement", "Use waveform capnography", "Target SpO2 90-98%"],
        isCritical: true,
        clinicalTip: "2025 Update: Target SpO2 90-98%. Avoid hyperoxia. Start at 100% FiO2 until SpO2 measurable."
    ),
    AlgorithmStep(
        title: "Optimize Ventilation",
        phase: "Respiratory",
        content: "Target PaCO2 35-45 mmHg. Avoid hyperventilation which can decrease cerebral blood flow.",
        keyActions: ["Target PaCO2 35-45 mmHg", "Avoid hyperventilation", "Monitor with capnography"],
        clinicalTip: "2025 Update: Fixed '10 breaths/min' language removed. Focus on PaCO2 targets."
    ),
    AlgorithmStep(
        title: "Hemodynamic Optimization",
        phase: "Circulation",
        content: "Target MAP ≥65 mmHg. Use vasopressors and/or fluid resuscitation as needed.",
        keyActions: ["Target MAP ≥65 mmHg", "Norepinephrine first-line", "Fluid bolus if hypovolemia suspected"],
        isCritical: true,
        clinicalTip: "2025 Update: Systolic BP target REMOVED. Focus solely on MAP ≥65 mmHg."
    ),
    AlgorithmStep(
        title: "Early Diagnostics",
        phase: "Workup",
        content: "Obtain 12-lead ECG immediately. Consider head-to-pelvis CT and echocardiography. Identify and treat underlying cause.",
        keyActions: ["12-lead ECG immediately", "Consider CT scan", "Echocardiography/POCUS", "Labs: ABG, lactate, troponin"],
        clinicalTip: "Early PCI for STEMI or high suspicion of coronary occlusion."
    ),
    AlgorithmStep(
        title: "Temperature Management",
        phase: "Neuroprotection",
        content: "For comatose patients, initiate targeted temperature management. Target 32-37.5°C for at least 36 hours. At minimum, prevent fever.",
        keyActions: ["Target 32-37.5°C", "Maintain for ≥36 hours", "Rewarm slowly: 0.25°C/hr", "PREVENT FEVER"],
        isCritical: true,
        clinicalTip: "2025 Update: Wider temp range (32-37.5°C), longer duration (≥36 hrs). Fever is the enemy!"
    ),
    AlgorithmStep(
        title: "Neurologic Prognostication",
        phase: "Assessment",
        content: "Wait ≥72 hours before prognostication. Use multimodal assessment. Ensure patient is off sedation and neuromuscular blockade.",
        keyActions: ["Wait ≥72 hours", "Multimodal assessment", "Off sedation for neuro exam", "Consider EEG, SSEP, MRI"],
        clinicalTip: "2025 Update: Assessment must be performed OFF sedation and NMB. No single test determines prognosis."
    )
]

// MARK: - Preview

#Preview {
    ACLSAlgorithmSelectionView()
}
