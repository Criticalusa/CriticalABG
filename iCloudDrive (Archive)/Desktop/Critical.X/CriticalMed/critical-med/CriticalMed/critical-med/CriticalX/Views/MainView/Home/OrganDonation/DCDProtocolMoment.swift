//
//  DCDProtocolMoment.swift
//  CriticalX
//
//  Donation after Circulatory Death (DCD) Protocol
//  Interactive 4-phase moment for DCD workflow
//
//  Distinct from brain death pathway - patient has cardiac death
//  after withdrawal of life-sustaining therapy
//

import SwiftUI

// MARK: - DCD Category
enum DCDCategory: String, CaseIterable, Identifiable {
    case categoryI = "Category I"
    case categoryII = "Category II"
    case categoryIII = "Category III"
    case categoryIV = "Category IV"
    case categoryV = "Category V"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .categoryI: return "Dead on arrival (uncontrolled)"
        case .categoryII: return "Unsuccessful resuscitation (uncontrolled)"
        case .categoryIII: return "Awaiting cardiac arrest (controlled)"
        case .categoryIV: return "Cardiac arrest in brain-dead donor"
        case .categoryV: return "Unexpected arrest in ICU patient"
        }
    }

    var isControlled: Bool {
        self == .categoryIII || self == .categoryIV
    }
}

// MARK: - Withdrawal Location
enum WithdrawalLocation: String, CaseIterable, Identifiable {
    case icu = "ICU"
    case or = "Operating Room"
    case preOp = "Pre-Op Area"

    var id: String { rawValue }
}

// MARK: - DCD Protocol Moment
struct DCDProtocolMoment: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var currentPhase: MomentPhase = .recognition
    @Environment(\.dismiss) var dismiss

    // Phase 1: Patient Info
    @State private var patientAge: String = ""
    @State private var patientDiagnosis: String = ""
    @State private var selectedCategory: DCDCategory = .categoryIII
    @State private var familyConsentObtained = false
    @State private var opoNotified = false
    @State private var opoCoordinatorName: String = ""

    // Phase 2: Authorization
    @State private var firstPersonConsent = false
    @State private var nextOfKinConsent = false
    @State private var medicalExaminerCleared = false
    @State private var organSelectionComplete = false
    @State private var selectedOrgans: Set<OrganType> = []

    // Phase 3: Withdrawal
    @State private var withdrawalLocation: WithdrawalLocation = .or
    @State private var withdrawalTime: Date?
    @State private var asystoleTime: Date?
    @State private var observationPeriodComplete = false
    @State private var deathDeclaredTime: Date?
    @State private var timerRunning = false
    @State private var elapsedSeconds: Int = 0
    @State private var timer: Timer?

    // Phase 4: Procurement
    @State private var incisionTime: Date?
    @State private var procurementStarted = false

    @State private var isAppearing = false

    var body: some View {
        NavigationView {
            MomentContainer(
                title: momentTitle,
                subtitle: "DCD PROTOCOL",
                accentColor: .orange,
                recognition: { recognitionPhase },
                orientation: { orientationPhase },
                action: { actionPhase },
                resolution: { resolutionPhase },
                currentPhase: $currentPhase
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: handleBack) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text(currentPhase == .recognition ? "Close" : "Back")
                        }
                        .font(.body)
                        .foregroundColor(.orange)
                    }
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private var momentTitle: String {
        switch currentPhase {
        case .recognition: return "Patient Eligibility"
        case .orientation: return "Authorization"
        case .action: return "Withdrawal & Timing"
        case .resolution: return "Procurement"
        }
    }

    private func handleBack() {
        switch currentPhase {
        case .recognition:
            dismiss()
        case .orientation:
            withAnimation { currentPhase = .recognition }
        case .action:
            withAnimation { currentPhase = .orientation }
        case .resolution:
            withAnimation { currentPhase = .action }
        }
    }

    // MARK: - Recognition Phase
    // "Is this patient a DCD candidate?"
    private var recognitionPhase: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("DCD Eligibility Assessment")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("Evaluate patient for Donation after Circulatory Death.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Patient Info
            MomentCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.cardBlue)
                        Text("Patient Information")
                            .font(.headline)
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Age")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField("--", text: $patientAge)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                        }

                        VStack(alignment: .leading) {
                            Text("Primary Diagnosis")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField("e.g., Severe TBI", text: $patientDiagnosis)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                }
            }

            // DCD Category Selection
            MomentCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard")
                            .foregroundColor(.orange)
                        Text("DCD Category (Maastricht)")
                            .font(.headline)
                    }

                    ForEach(DCDCategory.allCases) { category in
                        DCDCategoryRow(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }

                    if selectedCategory.isControlled {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text("Controlled DCD - Most common in US. Proceeds after planned withdrawal of life-sustaining therapy.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            // Prerequisites
            MomentCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "checklist")
                            .foregroundColor(.green)
                        Text("Prerequisites")
                            .font(.headline)
                    }

                    ChecklistItem(
                        title: "Family decision to withdraw life-sustaining therapy",
                        subtitle: "Independent of donation discussion",
                        isChecked: $familyConsentObtained
                    )

                    ChecklistItem(
                        title: "OPO notified and coordinator assigned",
                        subtitle: "Required before proceeding",
                        isChecked: $opoNotified
                    )

                    if opoNotified {
                        TextField("OPO Coordinator Name", text: $opoCoordinatorName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading, 32)
                    }
                }
            }

            // Key DCD vs DBD Distinction
            MomentCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text("DCD vs Brain Death Donation")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        DCDComparisonRow(label: "Death determination", dcd: "Circulatory (cardiac)", dbd: "Neurologic (brain)")
                        DCDComparisonRow(label: "Timing", dcd: "After WLST", dbd: "After brain death testing")
                        DCDComparisonRow(label: "Warm ischemia", dcd: "Critical concern", dbd: "Minimal")
                        DCDComparisonRow(label: "Organs typically", dcd: "Kidneys, liver, lungs", dbd: "All organs")
                    }
                }
            }

            MomentNavigationButton(
                title: "Continue to Authorization",
                isEnabled: familyConsentObtained && opoNotified,
                style: .primary
            ) {
                withAnimation { currentPhase = .orientation }
            }
        }
    }

    // MARK: - Orientation Phase
    // "Authorization and organ selection"
    private var orientationPhase: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Authorization & Planning")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("Complete authorization and coordinate logistics.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Authorization Checklist
            MomentCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "signature")
                            .foregroundColor(.purple)
                        Text("Authorization")
                            .font(.headline)
                    }

                    ChecklistItem(
                        title: "First-person authorization (donor registry)",
                        subtitle: "Check state donor registry",
                        isChecked: $firstPersonConsent
                    )

                    ChecklistItem(
                        title: "Next-of-kin authorization obtained",
                        subtitle: "If no first-person consent",
                        isChecked: $nextOfKinConsent
                    )

                    ChecklistItem(
                        title: "Medical examiner clearance (if applicable)",
                        subtitle: "Required for deaths under ME jurisdiction",
                        isChecked: $medicalExaminerCleared
                    )
                }
            }

            // Organ Selection
            MomentCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "heart.circle")
                            .foregroundColor(.red)
                        Text("Organs Under Consideration")
                            .font(.headline)
                    }

                    Text("Select organs being evaluated (subject to warm ischemia limits):")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(OrganType.allCases) { organ in
                            OrganSelectionButton(
                                organ: organ,
                                isSelected: selectedOrgans.contains(organ)
                            ) {
                                if selectedOrgans.contains(organ) {
                                    selectedOrgans.remove(organ)
                                } else {
                                    selectedOrgans.insert(organ)
                                }
                            }
                        }
                    }

                    // Warm Ischemia Limits
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Warm Ischemia Time Limits:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)

                        WarmIschemiaRow(organ: "Kidneys", limit: "60 min", notes: "Most tolerant")
                        WarmIschemiaRow(organ: "Liver", limit: "30 min", notes: "Moderate tolerance")
                        WarmIschemiaRow(organ: "Lungs", limit: "60 min", notes: "With EVLP option")
                        WarmIschemiaRow(organ: "Heart", limit: "Rarely DCD", notes: "Emerging protocols")
                    }
                    .padding(.top, 8)
                }
            }

            // Withdrawal Location
            MomentCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.blue)
                        Text("Withdrawal Location")
                            .font(.headline)
                    }

                    Picker("Location", selection: $withdrawalLocation) {
                        ForEach(WithdrawalLocation.allCases) { location in
                            Text(location.rawValue).tag(location)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(withdrawalLocationNote)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            MomentNavigationButton(
                title: "Proceed to Withdrawal",
                isEnabled: (firstPersonConsent || nextOfKinConsent) && !selectedOrgans.isEmpty,
                style: .primary
            ) {
                withAnimation { currentPhase = .action }
            }
        }
    }

    private var withdrawalLocationNote: String {
        switch withdrawalLocation {
        case .icu:
            return "Transport to OR after death declaration. Longer transport time affects warm ischemia."
        case .or:
            return "Recommended. Minimizes warm ischemia time. Family may visit pre-withdrawal."
        case .preOp:
            return "Compromise option. Quick transfer to OR after death."
        }
    }

    // MARK: - Action Phase
    // "Withdrawal and timing - CRITICAL"
    private var actionPhase: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Withdrawal & Timing")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("Document times precisely. Warm ischemia is critical.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Warm Ischemia Timer
            WarmIschemiaTimerCard(
                elapsedSeconds: elapsedSeconds,
                isRunning: timerRunning,
                onStart: startTimer,
                onStop: stopTimer,
                onReset: resetTimer
            )

            // Timeline Events
            MomentCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.orange)
                        Text("Critical Timeline")
                            .font(.headline)
                    }

                    // Withdrawal Time
                    TimelineEventRow(
                        title: "Withdrawal of Life Support",
                        time: $withdrawalTime,
                        icon: "xmark.circle.fill",
                        color: .red,
                        hint: "Extubation / vasopressor cessation"
                    )

                    // Asystole Time
                    TimelineEventRow(
                        title: "Asystole / Pulselessness",
                        time: $asystoleTime,
                        icon: "waveform.path.ecg",
                        color: .orange,
                        hint: "Start warm ischemia timer"
                    )

                    // Observation Period
                    VStack(alignment: .leading, spacing: 8) {
                        ChecklistItem(
                            title: "5-minute observation period complete",
                            subtitle: "Required 'hands-off' period per UNOS policy",
                            isChecked: $observationPeriodComplete
                        )

                        if !observationPeriodComplete {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Text("Do NOT touch patient during 5-minute observation. No interventions until death declared.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.1))
                            )
                        }
                    }

                    // Death Declaration
                    TimelineEventRow(
                        title: "Death Declared",
                        time: $deathDeclaredTime,
                        icon: "checkmark.seal.fill",
                        color: .purple,
                        hint: "By attending physician"
                    )
                }
            }

            // Functional Warm Ischemia Calculation
            if let withdrawal = withdrawalTime, let asystole = asystoleTime {
                MomentCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.orange)
                            Text("Warm Ischemia Metrics")
                                .font(.headline)
                        }

                        let agonalPhase = asystole.timeIntervalSince(withdrawal)
                        let agonalMinutes = Int(agonalPhase / 60)

                        HStack {
                            Text("Agonal Phase:")
                                .font(.subheadline)
                            Spacer()
                            Text("\(agonalMinutes) minutes")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(agonalMinutes > 60 ? .red : .green)
                        }

                        if agonalMinutes > 60 {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text("Agonal phase >60 min may exclude some organs. Consult OPO.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }

            MomentNavigationButton(
                title: "Proceed to Procurement",
                isEnabled: observationPeriodComplete && deathDeclaredTime != nil,
                style: .primary
            ) {
                withAnimation { currentPhase = .resolution }
            }
        }
    }

    // MARK: - Resolution Phase
    // "Procurement"
    private var resolutionPhase: some View {
        VStack(spacing: 24) {
            // Success Indicator
            DCDCompletionView(organCount: selectedOrgans.count)

            // Final Times
            MomentCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "clock.badge.checkmark")
                            .foregroundColor(.green)
                        Text("Procurement Timeline")
                            .font(.headline)
                    }

                    TimelineEventRow(
                        title: "Incision Time",
                        time: $incisionTime,
                        icon: "scissors",
                        color: .blue,
                        hint: "Start of procurement surgery"
                    )

                    if let death = deathDeclaredTime, let incision = incisionTime {
                        let interval = incision.timeIntervalSince(death)
                        let minutes = Int(interval / 60)

                        HStack {
                            Text("Death to Incision:")
                                .font(.subheadline)
                            Spacer()
                            Text("\(minutes) minutes")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(minutes < 10 ? .green : .orange)
                        }
                    }
                }
            }

            // Summary
            MomentCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.cardBlue)
                        Text("DCD Summary")
                            .font(.headline)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("**Category:** \(selectedCategory.rawValue)")
                        Text("**Organs:** \(selectedOrgans.map { $0.displayName }.joined(separator: ", "))")
                        Text("**Location:** \(withdrawalLocation.rawValue)")
                        if let withdrawal = withdrawalTime {
                            Text("**WLST:** \(withdrawal, style: .time)")
                        }
                        if let death = deathDeclaredTime {
                            Text("**Death Declared:** \(death, style: .time)")
                        }
                        Text("**Total Warm Ischemia:** \(elapsedSeconds / 60) minutes")
                    }
                    .font(.caption)
                }
            }

            // Actions
            VStack(spacing: 12) {
                MomentNavigationButton(title: "New DCD Case", isEnabled: true, style: .secondary) {
                    resetForm()
                    withAnimation { currentPhase = .recognition }
                }

                MomentNavigationButton(title: "Done", isEnabled: true, style: .primary) {
                    dismiss()
                }
            }
        }
        .padding(.top, 20)
    }

    // MARK: - Timer Functions
    private func startTimer() {
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }

    private func stopTimer() {
        timerRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func resetTimer() {
        stopTimer()
        elapsedSeconds = 0
    }

    private func resetForm() {
        patientAge = ""
        patientDiagnosis = ""
        selectedCategory = .categoryIII
        familyConsentObtained = false
        opoNotified = false
        opoCoordinatorName = ""
        firstPersonConsent = false
        nextOfKinConsent = false
        medicalExaminerCleared = false
        organSelectionComplete = false
        selectedOrgans = []
        withdrawalLocation = .or
        withdrawalTime = nil
        asystoleTime = nil
        observationPeriodComplete = false
        deathDeclaredTime = nil
        incisionTime = nil
        procurementStarted = false
        resetTimer()
    }
}

// MARK: - Supporting Views

struct DCDCategoryRow: View {
    let category: DCDCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .orange : .gray)

                VStack(alignment: .leading, spacing: 2) {
                    Text(category.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(category.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if category.isControlled {
                    Text("Controlled")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.green.opacity(0.15)))
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct DCDComparisonRow: View {
    let label: String
    let dcd: String
    let dbd: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)

            Text(dcd)
                .font(.caption)
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity)

            Text(dbd)
                .font(.caption)
                .foregroundColor(.purple)
                .frame(maxWidth: .infinity)
        }
    }
}

struct WarmIschemiaRow: View {
    let organ: String
    let limit: String
    let notes: String

    var body: some View {
        HStack {
            Text(organ)
                .font(.caption)
                .frame(width: 60, alignment: .leading)
            Text(limit)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
                .frame(width: 50)
            Text(notes)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct TimelineEventRow: View {
    let title: String
    @Binding var time: Date?
    let icon: String
    let color: Color
    let hint: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Spacer()

                if time != nil {
                    Button(action: { time = Date() }) {
                        Text("Update")
                            .font(.caption2)
                            .foregroundColor(color)
                    }
                } else {
                    Button(action: { time = Date() }) {
                        Text("Record Now")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(color))
                    }
                }
            }

            if let recorded = time {
                Text("Recorded: \(recorded, style: .time)")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(.leading, 32)
            } else {
                Text(hint)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, 32)
            }
        }
        .padding(.vertical, 4)
    }
}

struct WarmIschemiaTimerCard: View {
    let elapsedSeconds: Int
    let isRunning: Bool
    let onStart: () -> Void
    let onStop: () -> Void
    let onReset: () -> Void

    var body: some View {
        MomentCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(timerColor)
                    Text("WARM ISCHEMIA TIMER")
                        .font(.headline)
                        .foregroundColor(timerColor)
                    Spacer()
                }

                // Timer Display
                Text(formatTime(elapsedSeconds))
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(timerColor)

                // Status
                Text(timerStatus)
                    .font(.caption)
                    .foregroundColor(timerColor.opacity(0.8))

                // Controls
                HStack(spacing: 20) {
                    if isRunning {
                        Button(action: onStop) {
                            Label("Stop", systemImage: "stop.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(Color.red))
                        }
                    } else {
                        Button(action: onStart) {
                            Label("Start", systemImage: "play.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(Color.green))
                        }

                        if elapsedSeconds > 0 {
                            Button(action: onReset) {
                                Label("Reset", systemImage: "arrow.counterclockwise")
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
        }
    }

    private var timerBackgroundColor: Color {
        if elapsedSeconds > 3600 { return Color.red.opacity(0.2) } // >60 min
        if elapsedSeconds > 1800 { return Color.orange.opacity(0.15) } // >30 min
        return Color.green.opacity(0.1)
    }

    private var timerColor: Color {
        if elapsedSeconds > 3600 { return .red }
        if elapsedSeconds > 1800 { return .orange }
        return .green
    }

    private var timerStatus: String {
        let minutes = elapsedSeconds / 60
        if minutes > 60 {
            return "CRITICAL - Exceeds most organ limits"
        } else if minutes > 30 {
            return "Warning - Liver limit approaching"
        } else if minutes > 0 {
            return "Within acceptable range"
        }
        return "Timer not started"
    }

    private func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        }
        return String(format: "%02d:%02d", minutes, secs)
    }
}

struct DCDCompletionView: View {
    let organCount: Int
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .scaleEffect(isAnimating ? 1 : 0.8)

                Circle()
                    .fill(Color.orange.opacity(0.3))
                    .frame(width: 70, height: 70)
                    .scaleEffect(isAnimating ? 1 : 0.8)

                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.orange)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .opacity(isAnimating ? 1 : 0)
            }
            .animation(.easeOut(duration: 0.5), value: isAnimating)

            VStack(spacing: 4) {
                Text("DCD Procurement Initiated")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("\(organCount) organ\(organCount == 1 ? "" : "s") for recovery.")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 10)
            .animation(.easeOut(duration: 0.4).delay(0.2), value: isAnimating)
        }
        .onAppear {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            withAnimation {
                isAnimating = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    DCDProtocolMoment()
}
