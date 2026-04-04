//
//  ParsedChipRow.swift
//  CriticalX
//
//  Natural Language Moment Search - Parsed Chip Row
//  Displays extracted entities as minimal ghost chips
//  Jony Ive 2030: Semantic colors, no gold, spatial elevation
//

import SwiftUI

// MARK: - ParsedChipRow
/// Displays parsed query entities as chips
struct ParsedChipRow: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: NLMomentSearchVM
    @State private var showWeightInputSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Section label if there are chips
            if hasAnyChips {
                Text("PARSED ENTITIES")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary.opacity(0.6))
                    .textCase(.uppercase)
                    .tracking(1.2)
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // Age chip
                    if let age = viewModel.parsed.ageYears {
                        EntityChip(
                            icon: "person.fill",
                            label: formatAge(age),
                            color: CriticalDesign.Colors.accentTeal
                        )
                    }
                    
                    // Weight chip (tappable to edit) - using semantic green
                    if let weight = viewModel.parsed.weightKg {
                        EntityChip(
                            icon: "scalemass.fill",
                            label: formatWeight(weight),
                            color: CriticalDesign.Colors.accentGreen,
                            isTappable: true
                        ) {
                            showWeightInputSheet = true
                        }
                    } else if viewModel.parsed.drug != nil || viewModel.parsed.scenario != nil {
                        // Prompt for weight if drug/scenario detected but weight missing
                        EntityChip(
                            icon: "plus.circle.fill",
                            label: "Add Weight",
                            color: CriticalDesign.Colors.accentGreen,
                            isTappable: true,
                            isPulsing: true
                        ) {
                            showWeightInputSheet = true
                        }
                    }
                    
                    // Drug chip
                    if let drug = viewModel.parsed.drug {
                        EntityChip(
                            icon: "pill.fill",
                            label: drug.capitalized,
                            color: CriticalDesign.Colors.cardBlue
                        )
                    }
                    
                    // Scenario chip
                    if let scenario = viewModel.parsed.scenario {
                        EntityChip(
                            icon: "waveform.path.ecg",
                            label: formatScenario(scenario),
                            color: CriticalDesign.Colors.accentRed
                        )
                    }
                    
                    // Route chip
                    if let route = viewModel.parsed.route {
                        EntityChip(
                            icon: "syringe.fill",
                            label: route,
                            color: CriticalDesign.Colors.accentPurple
                        )
                    }
                    
                    // Concentration chip
                    if let conc = viewModel.parsed.concentration {
                        EntityChip(
                            icon: "drop.fill",
                            label: "\(Int(conc.mg))mg/\(Int(conc.mL))mL",
                            color: CriticalDesign.Colors.accentOrange
                        )
                    }
                    
                    // Population chip (pediatric vs adult)
                    if let age = viewModel.parsed.ageYears {
                        EntityChip(
                            icon: age < 18 ? "figure.child" : "figure.stand",
                            label: age < 18 ? "Pediatric" : "Adult",
                            color: age < 18 ? CriticalDesign.Colors.accentPurple : CriticalDesign.Colors.secondary
                        )
                    }
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
            }
        }
        .sheet(isPresented: $showWeightInputSheet) {
            WeightInputSheet(
                initialWeightKg: viewModel.parsed.weightKg,
                onSave: { newWeightKg in
                    viewModel.updateWeight(kg: newWeightKg)
                }
            )
        }
    }
    
    // MARK: - Helpers
    
    private var hasAnyChips: Bool {
        viewModel.parsed.ageYears != nil ||
        viewModel.parsed.weightKg != nil ||
        viewModel.parsed.drug != nil ||
        viewModel.parsed.scenario != nil ||
        viewModel.parsed.route != nil ||
        viewModel.parsed.concentration != nil
    }
    
    private func formatAge(_ age: Double) -> String {
        if age < 1 {
            let months = Int(age * 12)
            return "\(months) mo"
        } else if age == floor(age) {
            return "\(Int(age)) yrs"
        } else {
            return String(format: "%.1f yrs", age)
        }
    }
    
    private func formatWeight(_ kg: Double) -> String {
        if kg == floor(kg) {
            return "\(Int(kg)) kg"
        } else {
            return String(format: "%.1f kg", kg)
        }
    }
    
    private func formatScenario(_ scenario: String) -> String {
        let formatted = scenario
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "vf pvt", with: "VF/pVT")
            .replacingOccurrences(of: "post rosc", with: "Post-ROSC")
            .replacingOccurrences(of: "cardiac arrest", with: "Cardiac Arrest")
            .replacingOccurrences(of: "anaphylaxis", with: "Anaphylaxis")
            .replacingOccurrences(of: "svt", with: "SVT")
            .replacingOccurrences(of: "bradycardia", with: "Bradycardia")
            .replacingOccurrences(of: "sepsis", with: "Sepsis")
            .replacingOccurrences(of: "shock", with: "Shock")
            .replacingOccurrences(of: "rsi", with: "RSI")
            .replacingOccurrences(of: "intubation", with: "Intubation")
        
        // Capitalize first letter of each word if not already formatted
        if formatted == scenario.replacingOccurrences(of: "_", with: " ") {
            return formatted.capitalized
        }
        return formatted
    }
}

// MARK: - EntityChip
/// Individual entity chip with icon and label - Ghost pill design
struct EntityChip: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let label: String
    let color: Color
    var isTappable: Bool = false
    var isPulsing: Bool = false
    var action: (() -> Void)? = nil
    
    @State private var pulseAnimation = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .medium, design: .rounded))

                Text(label)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
            }
            .foregroundColor(isTappable ? color : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(colorScheme == .dark 
                        ? (isTappable ? color.opacity(0.15) : Color.white.opacity(0.08))
                        : (isTappable ? color.opacity(0.08) : Color.black.opacity(0.04)))
            )
            .overlay(
                Capsule()
                    .strokeBorder(
                        isTappable ? color.opacity(0.3) : Color.clear,
                        lineWidth: 0.5
                    )
            )
            // Elevation on tap
            .shadow(
                color: isTappable && isPressed ? color.opacity(0.3) : Color.clear,
                radius: isPressed ? 8 : 0,
                y: isPressed ? 4 : 0
            )
            .scaleEffect(isPulsing && pulseAnimation ? 1.03 : (isPressed ? 0.97 : 1.0))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isTappable)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onAppear {
            if isPulsing {
                withAnimation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true)
                ) {
                    pulseAnimation = true
                }
            }
        }
    }
}

// MARK: - MissingInputChip
/// Chip prompting user to add missing input - Semantic green for data entry
struct MissingInputChip: View {
    @Environment(\.colorScheme) var colorScheme
    let inputKey: InputKey
    var action: (() -> Void)? = nil
    
    @State private var pulseAnimation = false
    private let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        Button(action: {
            haptic.impactOccurred()
            action?()
        }) {
            HStack(spacing: 8) {
                Image(systemName: iconForInput)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("TAP TO ADD")
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .tracking(1.0)
                    
                    Text(labelForInput)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
            }
            .foregroundColor(CriticalDesign.Colors.accentGreen)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(colorScheme == .dark 
                        ? CriticalDesign.Colors.accentGreen.opacity(0.15)
                        : CriticalDesign.Colors.accentGreen.opacity(0.08))
            )
            .overlay(
                Capsule()
                    .strokeBorder(CriticalDesign.Colors.accentGreen.opacity(0.4), lineWidth: 1)
            )
            .shadow(
                color: CriticalDesign.Colors.accentGreen.opacity(pulseAnimation ? 0.3 : 0.15),
                radius: pulseAnimation ? 12 : 8,
                y: 4
            )
            .scaleEffect(pulseAnimation ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }
    
    private var iconForInput: String {
        switch inputKey {
        case .weightKg: return "scalemass.fill"
        case .weightConfirmation: return "exclamationmark.triangle.fill"
        case .ageYears: return "person.fill"
        case .concentration: return "drop.fill"
        case .route: return "syringe.fill"
        case .scenario: return "waveform.path.ecg"
        case .drug: return "pill.fill"
        }
    }

    private var labelForInput: String {
        switch inputKey {
        case .weightKg: return "Patient Weight"
        case .weightConfirmation: return "Confirm Weight"
        case .ageYears: return "Patient Age"
        case .concentration: return "Concentration"
        case .route: return "Route"
        case .scenario: return "Scenario"
        case .drug: return "Drug"
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        ParsedChipRow(viewModel: {
            let vm = NLMomentSearchVM()
            vm.query = "5 yo 18kg vf epi IV"
            return vm
        }())
        
        MissingInputChip(inputKey: .weightKg)
    }
    .padding()
    .background(CriticalDesign.Colors.canvas)
}
