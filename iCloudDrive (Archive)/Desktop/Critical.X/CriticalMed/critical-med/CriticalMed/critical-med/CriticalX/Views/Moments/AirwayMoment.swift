//
//  AirwayMoment.swift
//  CriticalX
//
//  Airway Management Moment
//  Recognition → Orientation → Action → Resolution
//
//  "What airway intervention do you need?"
//

import SwiftUI

// MARK: - Airway Scenario
enum AirwayScenario: String, CaseIterable, Identifiable {
    case rsi
    case failedAirway
    case difficultAirway
    case cricothyrotomy
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .rsi: return "RSI"
        case .failedAirway: return "Failed Airway"
        case .difficultAirway: return "Difficult Airway"
        case .cricothyrotomy: return "Cricothyrotomy"
        }
    }
    
    var subtitle: String {
        switch self {
        case .rsi: return "Rapid Sequence Intubation"
        case .failedAirway: return "Can't intubate, can't oxygenate"
        case .difficultAirway: return "Predicted difficulty"
        case .cricothyrotomy: return "Surgical airway"
        }
    }
    
    var icon: String {
        switch self {
        case .rsi: return "bolt.fill"
        case .failedAirway: return "exclamationmark.triangle.fill"
        case .difficultAirway: return "questionmark.circle.fill"
        case .cricothyrotomy: return "scissors"
        }
    }
    
    var color: Color {
        switch self {
        case .rsi: return .blue
        case .failedAirway: return .red
        case .difficultAirway: return .orange
        case .cricothyrotomy: return .purple
        }
    }
}

// MARK: - RSI Drug
struct RSIDrug: Identifiable {
    let id = UUID()
    let name: String
    let dose: String
    let unit: String
    let notes: String?
    let concentration: Double  // mg/mL or mcg/mL
    let concentrationUnit: String
    
    init(name: String, dose: String, unit: String, notes: String? = nil, concentration: Double = 0, concentrationUnit: String = "mg/mL") {
        self.name = name
        self.dose = dose
        self.unit = unit
        self.notes = notes
        self.concentration = concentration
        self.concentrationUnit = concentrationUnit
    }
    
    func calculatedDose(for weight: Double) -> String {
        // Extract numeric dose and calculate
        if let doseValue = Double(dose.replacingOccurrences(of: "-", with: "").components(separatedBy: " ").first ?? "") {
            let calculated = doseValue * weight
            return String(format: "%.0f", calculated)
        }
        return dose
    }
    
    /// Calculate volume to draw based on weight and concentration
    func volumeToPush(for weight: Double) -> String? {
        guard concentration > 0 else { return nil }
        if let doseValue = Double(dose.replacingOccurrences(of: "-", with: "").components(separatedBy: " ").first ?? "") {
            let totalDose = doseValue * weight
            let volume = totalDose / concentration
            return String(format: "%.1f mL", volume)
        }
        return nil
    }
}

// MARK: - Airway Moment
struct AirwayMoment: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var patientContext = GlobalPatientContext.shared
    @State private var currentPhase: MomentPhase = .recognition
    @State private var selectedScenario: AirwayScenario?
    @State private var patientWeight: String = ""
    @State private var selectedInductionAgent: String?
    @State private var selectedParalytic: String?
    @State private var completedSteps: Set<String> = []
    @State private var isAppearing = false
    @State private var showVentilatorMoment = false
    @Environment(\.dismiss) var dismiss
    
    // RSI Drugs - Uses customizable settings when available
    // Note: RSISettingsManager must be added to Xcode target for custom doses
    private var activeInductionAgents: [RSIDrug] {
        // Try to load from settings if available
        if let settings = loadRSISettings() {
            let customDrugs = settings.filter { $0.category == "Induction" && $0.isEnabled }
            if !customDrugs.isEmpty {
                return customDrugs.map { config in
                    RSIDrug(
                        name: config.name,
                        dose: String(format: "%.2g", config.defaultDose),
                        unit: config.unit,
                        notes: config.notes.isEmpty ? nil : config.notes,
                        concentration: config.concentration,
                        concentrationUnit: config.concentrationUnit
                    )
                }
            }
        }
        // Default drugs with common concentrations
        return [
            RSIDrug(name: "Ketamine", dose: "1.5", unit: "mg/kg", notes: "Hemodynamically stable", concentration: 50, concentrationUnit: "mg/mL"),
            RSIDrug(name: "Etomidate", dose: "0.3", unit: "mg/kg", notes: "Minimal cardiac depression", concentration: 2, concentrationUnit: "mg/mL"),
            RSIDrug(name: "Propofol", dose: "1.5", unit: "mg/kg", notes: "Hypotension risk", concentration: 10, concentrationUnit: "mg/mL"),
            RSIDrug(name: "Midazolam", dose: "0.2", unit: "mg/kg", notes: "Slower onset", concentration: 5, concentrationUnit: "mg/mL")
        ]
    }
    
    private var activeParalytics: [RSIDrug] {
        // Try to load from settings if available
        if let settings = loadRSISettings() {
            let customDrugs = settings.filter { $0.category == "Paralytic" && $0.isEnabled }
            if !customDrugs.isEmpty {
                return customDrugs.map { config in
                    RSIDrug(
                        name: config.name,
                        dose: String(format: "%.2g", config.defaultDose),
                        unit: config.unit,
                        notes: config.notes.isEmpty ? nil : config.notes,
                        concentration: config.concentration,
                        concentrationUnit: config.concentrationUnit
                    )
                }
            }
        }
        // Default drugs with common concentrations
        return [
            RSIDrug(name: "Succinylcholine", dose: "1.5", unit: "mg/kg", notes: "Fastest onset (45-60 sec)", concentration: 20, concentrationUnit: "mg/mL"),
            RSIDrug(name: "Rocuronium", dose: "1.2", unit: "mg/kg", notes: "Reversible with Sugammadex", concentration: 10, concentrationUnit: "mg/mL")
        ]
    }
    
    // Helper to load RSI settings from UserDefaults
    private func loadRSISettings() -> [RSIDrugConfigSimple]? {
        guard let data = UserDefaults.standard.data(forKey: "RSIDrugSettings"),
              let decoded = try? JSONDecoder().decode([RSIDrugConfigSimple].self, from: data) else {
            return nil
        }
        return decoded
    }
    
    var body: some View {
        NavigationView {
            MomentContainer(
                title: momentTitle,
                subtitle: "AIRWAY",
                accentColor: selectedScenario?.color ?? .blue,
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
                            Text(backButtonTitle)
                        }
                        .font(.body)
                        .foregroundColor(.cardBlue)
                    }
                }
                
                // Patient weight bar - shows current weight, tap to edit
                ToolbarItem(placement: .navigationBarTrailing) {
                    PatientContextBar()
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                isAppearing = true
            }
            // Load weight from global patient context
            if let weight = patientContext.weightKg {
                patientWeight = String(format: "%.0f", weight)
            }
        }
        .fullScreenCover(isPresented: $showVentilatorMoment) {
            VentilatorMoment()
        }
    }
    
    // MARK: - Dynamic Title
    private var momentTitle: String {
        if let scenario = selectedScenario {
            return scenario.title
        }
        return "Airway Management"
    }
    
    private var backButtonTitle: String {
        switch currentPhase {
        case .recognition: return "Close"
        case .orientation: return "Back"
        case .action: return "Back"
        case .resolution: return "Back"
        }
    }
    
    // MARK: - Back Handler
    private func handleBack() {
        switch currentPhase {
        case .recognition:
            dismiss()
        case .orientation:
            withAnimation(.easeOut(duration: 0.3)) {
                selectedScenario = nil
                currentPhase = .recognition
            }
        case .action:
            withAnimation(.easeOut(duration: 0.3)) {
                currentPhase = .orientation
            }
        case .resolution:
            withAnimation(.easeOut(duration: 0.3)) {
                currentPhase = .action
            }
        }
    }
    
    // MARK: - Recognition Phase
    private var recognitionPhase: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What airway intervention?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ForEach(AirwayScenario.allCases) { scenario in
                    MomentOptionButton(
                        title: scenario.title,
                        subtitle: scenario.subtitle,
                        icon: scenario.icon,
                        isSelected: selectedScenario == scenario
                    ) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            selectedScenario = scenario
                        }
                    }
                }
            }
            
            if selectedScenario != nil {
                MomentNavigationButton(
                    title: "Continue",
                    isEnabled: true,
                    style: .primary
                ) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        currentPhase = .orientation
                    }
                }
                .padding(.top, 8)
            }
        }
    }
    
    // MARK: - Orientation Phase
    private var orientationPhase: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Context Card
            if let scenario = selectedScenario {
                MomentCard {
                    HStack {
                        Image(systemName: scenario.icon)
                            .font(.title2)
                            .foregroundColor(scenario.color)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(scenario.title.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(scenario.color)
                            Text(scenario.subtitle)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Weight Input
            VStack(alignment: .leading, spacing: 12) {
                Text("Patient weight")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                HStack {
                    TextField("70", text: $patientWeight)
                        .keyboardType(.decimalPad)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(width: 80)
                        .multilineTextAlignment(.center)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    Text("kg")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if !patientWeight.isEmpty {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            
            // Drug Selection (for RSI)
            if selectedScenario == .rsi {
                // Induction Agent
                VStack(alignment: .leading, spacing: 12) {
                    Text("Induction agent")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(activeInductionAgents) { drug in
                        DrugSelectionRow(
                            drug: drug,
                            weight: Double(patientWeight) ?? 70,
                            isSelected: selectedInductionAgent == drug.name
                        ) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                selectedInductionAgent = drug.name
                            }
                        }
                    }
                }
                
                // Paralytic
                VStack(alignment: .leading, spacing: 12) {
                    Text("Paralytic")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(activeParalytics) { drug in
                        DrugSelectionRow(
                            drug: drug,
                            weight: Double(patientWeight) ?? 70,
                            isSelected: selectedParalytic == drug.name
                        ) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                selectedParalytic = drug.name
                            }
                        }
                    }
                }
            }
            
            // Continue Button
            MomentNavigationButton(
                title: "Continue",
                isEnabled: canProceedFromOrientation,
                style: .primary
            ) {
                withAnimation(.easeOut(duration: 0.3)) {
                    currentPhase = .action
                }
            }
            .padding(.top, 8)
        }
    }
    
    private var canProceedFromOrientation: Bool {
        if selectedScenario == .rsi {
            return !patientWeight.isEmpty && selectedInductionAgent != nil && selectedParalytic != nil
        }
        return !patientWeight.isEmpty
    }
    
    // MARK: - Action Phase
    private var actionPhase: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Drug Summary (for RSI)
            if selectedScenario == .rsi, let weight = Double(patientWeight) {
                MomentCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("MEDICATION DOSES")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.cardBlue)
                        
                        if let inductionName = selectedInductionAgent,
                           let induction = activeInductionAgents.first(where: { $0.name == inductionName }) {
                            DrugDoseRow(
                                name: induction.name,
                                dose: induction.calculatedDose(for: weight),
                                unit: "mg"
                            )
                        }
                        
                        if let paralyticName = selectedParalytic,
                           let paralytic = activeParalytics.first(where: { $0.name == paralyticName }) {
                            DrugDoseRow(
                                name: paralytic.name,
                                dose: paralytic.calculatedDose(for: weight),
                                unit: "mg"
                            )
                        }
                    }
                }
            }
            
            // RSI Steps
            VStack(alignment: .leading, spacing: 8) {
                Text("RSI CHECKLIST")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .tracking(1)
                
                ForEach(rsiSteps, id: \.self) { step in
                    ActionChecklistItem(
                        text: step,
                        isCompleted: completedSteps.contains(step)
                    ) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            if completedSteps.contains(step) {
                                completedSteps.remove(step)
                            } else {
                                completedSteps.insert(step)
                            }
                        }
                    }
                }
            }
            
            // Red Flag
            MomentCard {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("If can't intubate")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        Text("→ Supraglottic airway → BVM → Cric")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
            
            // Complete Button
            MomentNavigationButton(
                title: "Airway Secured",
                isEnabled: completedSteps.count >= rsiSteps.count - 2,
                style: .primary
            ) {
                withAnimation(.easeOut(duration: 0.3)) {
                    currentPhase = .resolution
                }
            }
            .padding(.top, 8)
        }
    }
    
    private var rsiSteps: [String] {
        [
            "Preoxygenation (3 min if stable)",
            "Positioning (ear to sternal notch)",
            "Equipment check (ETT, suction, backup)",
            "Push induction agent",
            "Push paralytic",
            "Wait 45-60 seconds",
            "Direct laryngoscopy / Video",
            "Pass ETT, confirm placement",
            "Secure tube, post-intubation care"
        ]
    }
    
    // MARK: - Resolution Phase
    private var resolutionPhase: some View {
        VStack(spacing: 24) {
            ResolutionCheckmark(
                message: "Airway secured.",
                submessage: "Confirm placement: ETCO2, bilateral breath sounds, CXR"
            )
            
            // Post-intubation checklist
            VStack(alignment: .leading, spacing: 12) {
                Text("POST-INTUBATION")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .tracking(1)
                
                VStack(alignment: .leading, spacing: 8) {
                    PostIntubationRow(text: "Confirm ETCO2 waveform")
                    PostIntubationRow(text: "Sedation (Propofol, Fentanyl)")
                    PostIntubationRow(text: "Vent settings: TV 6-8 mL/kg IBW")
                    PostIntubationRow(text: "Order CXR")
                    PostIntubationRow(text: "Document ETT depth (cm at teeth)")
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            
            // Navigation
            VStack(spacing: 12) {
                MomentNavigationButton(
                    title: "Start Ventilator Setup",
                    isEnabled: true,
                    style: .primary
                ) {
                    // Save weight to context before navigating
                    if !patientWeight.isEmpty {
                        patientContext.setWeight(from: patientWeight, unit: .kg)
                    }
                    showVentilatorMoment = true
                }
                
                MomentNavigationButton(
                    title: "Return to Emergency Mode",
                    isEnabled: true,
                    style: .secondary
                ) {
                    dismiss()
                }
            }
        }
        .padding(.top, 20)
    }
}

// MARK: - Drug Selection Row
struct DrugSelectionRow: View {
    @Environment(\.colorScheme) var colorScheme
    let drug: RSIDrug
    let weight: Double
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(drug.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(drug.dose) \(drug.unit)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Show concentration if available
                    if drug.concentration > 0 {
                        Text("\(String(format: "%.0f", drug.concentration)) \(drug.concentrationUnit)")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                    
                    if let notes = drug.notes {
                        Text(notes)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(drug.calculatedDose(for: weight)) mg")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .cardBlue : .primary)
                    
                    // Show volume to push if concentration is set
                    if let volume = drug.volumeToPush(for: weight) {
                        Text("Draw: \(volume)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.cardBlue)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? Color.cardBlue : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Drug Dose Row
struct DrugDoseRow: View {
    @Environment(\.colorScheme) var colorScheme
    let name: String
    let dose: String
    let unit: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
            Spacer()
            Text("\(dose) \(unit)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.cardBlue)
        }
    }
}

// MARK: - Post Intubation Row
struct PostIntubationRow: View {
    @Environment(\.colorScheme) var colorScheme
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "circle")
                .font(.system(size: 8))
                .foregroundColor(.secondary)
            Text(text)
                .font(.caption)
        }
    }
}

// MARK: - RSI Drug Config (Simple)
// Used to decode settings from UserDefaults without requiring RSISettingsManager
private struct RSIDrugConfigSimple: Codable {
    let name: String
    let category: String
    let defaultDose: Double
    let unit: String
    let concentration: Double
    let concentrationUnit: String
    let isEnabled: Bool
    let notes: String
    
    // Handle optional concentration for backwards compatibility
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        defaultDose = try container.decode(Double.self, forKey: .defaultDose)
        unit = try container.decode(String.self, forKey: .unit)
        concentration = try container.decodeIfPresent(Double.self, forKey: .concentration) ?? 0
        concentrationUnit = try container.decodeIfPresent(String.self, forKey: .concentrationUnit) ?? "mg/mL"
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        notes = try container.decode(String.self, forKey: .notes)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, category, defaultDose, unit, concentration, concentrationUnit, isEnabled, notes
    }
}

// MARK: - Preview
#Preview {
    AirwayMoment()
}

