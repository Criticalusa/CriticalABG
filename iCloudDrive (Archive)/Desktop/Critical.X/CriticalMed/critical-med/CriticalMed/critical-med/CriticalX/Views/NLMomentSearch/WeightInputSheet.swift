//
//  WeightInputSheet.swift
//  CriticalX
//
//  Natural Language Moment Search - Weight Input Sheet
//  Quick weight entry for moment calculations.
//  Pediatric presets first, then adult. Flat card style (no neumorphic).
//

import SwiftUI

// MARK: - WeightInputSheet
/// Sheet for quick patient weight input
struct WeightInputSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @ObservedObject var globalPatientContext = GlobalPatientContext.shared
    
    @State private var weightText: String
    @State private var selectedUnit: WeightUnit
    @FocusState private var isWeightFieldFocused: Bool
    
    let onSave: (Double) -> Void
    
    // Quick weight presets
    private let adultPresets: [(label: String, kg: Double)] = [
        ("50 kg", 50), ("60 kg", 60), ("70 kg", 70), ("80 kg", 80), ("90 kg", 90), ("100 kg", 100)
    ]
    
    private let pediatricPresets: [(label: String, kg: Double)] = [
        ("5 kg", 5), ("10 kg", 10), ("15 kg", 15), ("20 kg", 20), ("30 kg", 30), ("40 kg", 40)
    ]
    
    init(initialWeightKg: Double?, onSave: @escaping (Double) -> Void) {
        _weightText = State(initialValue: initialWeightKg.map { String(format: "%.1f", $0) } ?? "")
        _selectedUnit = State(initialValue: WeightUnit.kg)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                CriticalDesign.Colors.canvas.ignoresSafeArea()
                
                VStack(spacing: CriticalDesign.Spacing.xl) {
                    // Header icon
                    ZStack {
                        Circle()
                            .fill(CriticalDesign.Colors.cardBlue.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "scalemass.fill")
                            .font(.system(size: 36, weight: .medium))
                            .foregroundColor(CriticalDesign.Colors.cardBlue)
                    }
                    .padding(.top, CriticalDesign.Spacing.lg)
                    
                    // Title
                    VStack(spacing: 4) {
                        Text("PATIENT WEIGHT")
                            .font(.custom("Poppins-Bold", size: 10))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            .tracking(1.5)
                        
                        Text("Enter or Select")
                            .font(.custom("Poppins-Bold", size: 24))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    }
                    
                    // Weight input field
                    HStack(spacing: CriticalDesign.Spacing.md) {
                        // Text field
                        TextField("0", text: $weightText)
                            .keyboardType(.decimalPad)
                            .font(.custom("Poppins-Bold", size: 48))
                            .foregroundColor(CriticalDesign.Colors.cardBlue)
                            .multilineTextAlignment(.center)
                            .focused($isWeightFieldFocused)
                            .frame(height: 80)
                        
                        // Unit picker
                        Picker("Unit", selection: $selectedUnit) {
                            ForEach(WeightUnit.allCases) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 100)
                    }
                    .padding(CriticalDesign.Spacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.secondarySystemGroupedBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                                    .stroke(colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.06), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                    
                    // Quick presets: Pediatric first, then Adult (clear distinction)
                    VStack(alignment: .leading, spacing: CriticalDesign.Spacing.lg) {
                        // Pediatric presets first (typical peds range)
                        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                            HStack(spacing: 6) {
                                Image(systemName: "figure.child")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("Pediatric")
                                    .font(.custom("Poppins-Bold", size: 12))
                                    .tracking(0.5)
                            }
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                ForEach(pediatricPresets, id: \.kg) { preset in
                                    WeightPresetButton(
                                        label: preset.label,
                                        isSelected: Double(weightText) == preset.kg && selectedUnit == .kg
                                    ) {
                                        isWeightFieldFocused = false
                                        weightText = "\(Int(preset.kg))"
                                        selectedUnit = .kg
                                    }
                                }
                            }
                        }
                        .padding(CriticalDesign.Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color(UIColor.tertiarySystemGroupedBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                                .stroke(CriticalDesign.Colors.cardBlue.opacity(colorScheme == .dark ? 0.3 : 0.2), lineWidth: 1)
                        )
                        
                        // Adult presets second
                        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                            HStack(spacing: 6) {
                                Image(systemName: "figure.stand")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("Adult")
                                    .font(.custom("Poppins-Bold", size: 12))
                                    .tracking(0.5)
                            }
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                ForEach(adultPresets, id: \.kg) { preset in
                                    WeightPresetButton(
                                        label: preset.label,
                                        isSelected: Double(weightText) == preset.kg && selectedUnit == .kg
                                    ) {
                                        isWeightFieldFocused = false
                                        weightText = "\(Int(preset.kg))"
                                        selectedUnit = .kg
                                    }
                                }
                            }
                        }
                        .padding(CriticalDesign.Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color(UIColor.tertiarySystemGroupedBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                                .stroke(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06), lineWidth: 1)
                        )
                    }
                    .padding(CriticalDesign.Spacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.secondarySystemGroupedBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                                    .stroke(colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.06), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                    
                    Spacer()
                    
                    // Save button
                    Button(action: saveWeight) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text("Use This Weight")
                                .font(.custom("Poppins-Bold", size: 18))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                                .fill(
                                    isValidWeight
                                        ? CriticalDesign.Colors.cardBlue
                                        : CriticalDesign.Colors.tertiary
                                )
                        )
                    }
                    .disabled(!isValidWeight)
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                    .padding(.bottom, CriticalDesign.Spacing.lg)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(CriticalDesign.Colors.accentRed)
                }
                
                // Keyboard toolbar with Done button
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isWeightFieldFocused = false
                    }
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                }
            }
            .onAppear {
                // Auto-focus the weight field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isWeightFieldFocused = true
                }
            }
            .onTapGesture {
                // Dismiss keyboard when tapping outside
                isWeightFieldFocused = false
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var isValidWeight: Bool {
        guard let weight = Double(weightText), weight > 0, weight < 500 else {
            return false
        }
        return true
    }
    
    // MARK: - Actions
    
    private func saveWeight() {
        guard let weight = Double(weightText), weight > 0 else { return }
        
        let weightInKg = selectedUnit == WeightUnit.lbs ? weight * 0.453592 : weight
        
        // Update global patient context
        globalPatientContext.setWeight(from: String(weightInKg), unit: .kg)
        
        // Callback
        onSave(weightInKg)
        
        dismiss()
    }
}

// MARK: - Weight Preset Button (flat style, no neumorphic shadow)
private struct WeightPresetButton: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let isSelected: Bool
    let action: () -> Void

    private let haptic = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        Button(action: {
            haptic.impactOccurred()
            action()
        }) {
            Text(label)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(isSelected ? .white : CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .fill(isSelected ? CriticalDesign.Colors.cardBlue : (colorScheme == .dark ? Color.white.opacity(0.08) : Color(UIColor.tertiarySystemGroupedBackground)))
                        .overlay(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                                .stroke(isSelected ? CriticalDesign.Colors.cardBlue : Color.clear, lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    WeightInputSheet(initialWeightKg: nil) { weight in
        print("Selected weight: \(weight) kg")
    }
}
