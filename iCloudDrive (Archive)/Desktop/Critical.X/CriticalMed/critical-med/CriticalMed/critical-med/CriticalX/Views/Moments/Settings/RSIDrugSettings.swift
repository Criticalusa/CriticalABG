//
//  RSIDrugSettings.swift
//  CriticalX
//
//  Customizable RSI Drug Doses - Premium Light Redesign
//

import SwiftUI

// MARK: - RSI Drug Configuration
struct RSIDrugConfig: Codable, Identifiable {
    let id: UUID
    var name: String
    var category: RSIDrugCategory
    var defaultDose: Double
    var minDose: Double
    var maxDose: Double
    var unit: String
    var concentration: Double
    var concentrationUnit: String
    var isEnabled: Bool
    var notes: String

    init(
        id: UUID = UUID(),
        name: String,
        category: RSIDrugCategory,
        defaultDose: Double,
        minDose: Double,
        maxDose: Double,
        unit: String,
        concentration: Double = 0,
        concentrationUnit: String = "mg/mL",
        isEnabled: Bool = true,
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.defaultDose = defaultDose
        self.minDose = minDose
        self.maxDose = maxDose
        self.unit = unit
        self.concentration = concentration
        self.concentrationUnit = concentrationUnit
        self.isEnabled = isEnabled
        self.notes = notes
    }

    func volumeToPush(dose: Double) -> Double? {
        guard concentration > 0 else { return nil }
        return dose / concentration
    }
}

enum RSIDrugCategory: String, Codable, CaseIterable {
    case induction = "Induction"
    case paralytic = "Paralytic"
    case adjunct = "Adjunct"
    case pushDose = "Push-Dose Pressor"

    var icon: String {
        switch self {
        case .induction: return "syringe.fill"
        case .paralytic: return "bolt.fill"
        case .adjunct: return "pills.fill"
        case .pushDose: return "heart.fill"
        }
    }

    var color: Color {
        switch self {
        case .induction: return Color(red: 0.20, green: 0.65, blue: 0.50)
        case .paralytic: return Color(red: 0.80, green: 0.30, blue: 0.35)
        case .adjunct: return Color(red: 0.25, green: 0.50, blue: 0.80)
        case .pushDose: return Color(red: 0.85, green: 0.34, blue: 0.17)
        }
    }
}

// MARK: - RSI Settings Manager
class RSISettingsManager: ObservableObject {
    @Published var drugs: [RSIDrugConfig] = []
    @Published var institutionName: String = ""

    private let userDefaultsKey = "RSIDrugSettings"
    private let institutionKey = "RSIInstitutionName"

    static let shared = RSISettingsManager()

    init() {
        loadSettings()
    }

    static var defaultDrugs: [RSIDrugConfig] {
        [
            RSIDrugConfig(name: "Ketamine", category: .induction, defaultDose: 1.5, minDose: 1.0, maxDose: 2.0, unit: "mg/kg", concentration: 50, concentrationUnit: "mg/mL", notes: "Hemodynamically stable"),
            RSIDrugConfig(name: "Etomidate", category: .induction, defaultDose: 0.3, minDose: 0.2, maxDose: 0.4, unit: "mg/kg", concentration: 2, concentrationUnit: "mg/mL", notes: "Adrenal suppression concern"),
            RSIDrugConfig(name: "Propofol", category: .induction, defaultDose: 1.5, minDose: 1.0, maxDose: 2.5, unit: "mg/kg", concentration: 10, concentrationUnit: "mg/mL", notes: "Caution in hypotension"),
            RSIDrugConfig(name: "Midazolam", category: .induction, defaultDose: 0.2, minDose: 0.1, maxDose: 0.3, unit: "mg/kg", concentration: 5, concentrationUnit: "mg/mL", notes: "For hemodynamically unstable"),

            RSIDrugConfig(name: "Rocuronium", category: .paralytic, defaultDose: 1.2, minDose: 0.6, maxDose: 1.2, unit: "mg/kg", concentration: 10, concentrationUnit: "mg/mL", notes: "0.6-1.2 mg/kg. Higher dose (1.2) for RSI, faster onset."),
            RSIDrugConfig(name: "Succinylcholine", category: .paralytic, defaultDose: 1.5, minDose: 1.0, maxDose: 2.0, unit: "mg/kg", concentration: 20, concentrationUnit: "mg/mL", notes: "Avoid in hyperK, burns, crush"),
            RSIDrugConfig(name: "Vecuronium", category: .paralytic, defaultDose: 0.15, minDose: 0.1, maxDose: 0.2, unit: "mg/kg", concentration: 1, concentrationUnit: "mg/mL", notes: "Slower onset"),

            RSIDrugConfig(name: "Fentanyl", category: .adjunct, defaultDose: 2.0, minDose: 1.0, maxDose: 3.0, unit: "mcg/kg", concentration: 50, concentrationUnit: "mcg/mL", notes: "Blunts sympathetic response"),
            RSIDrugConfig(name: "Lidocaine", category: .adjunct, defaultDose: 1.5, minDose: 1.0, maxDose: 2.0, unit: "mg/kg", concentration: 20, concentrationUnit: "mg/mL", notes: "For ICP concerns"),
            RSIDrugConfig(name: "Atropine", category: .adjunct, defaultDose: 0.02, minDose: 0.01, maxDose: 0.02, unit: "mg/kg", concentration: 0.4, concentrationUnit: "mg/mL", notes: "Peds to prevent bradycardia"),

            RSIDrugConfig(name: "Push-Dose Epinephrine", category: .pushDose, defaultDose: 10.0, minDose: 5.0, maxDose: 20.0, unit: "mcg", concentration: 10, concentrationUnit: "mcg/mL", notes: "Dilute 1mg in 100mL NS"),
            RSIDrugConfig(name: "Push-Dose Phenylephrine", category: .pushDose, defaultDose: 100.0, minDose: 50.0, maxDose: 200.0, unit: "mcg", concentration: 100, concentrationUnit: "mcg/mL", notes: "Dilute 1mg in 10mL NS"),
        ]
    }

    func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([RSIDrugConfig].self, from: data) {
            drugs = decoded
        } else {
            drugs = RSISettingsManager.defaultDrugs
        }
        institutionName = UserDefaults.standard.string(forKey: institutionKey) ?? ""
    }

    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(drugs) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
        UserDefaults.standard.set(institutionName, forKey: institutionKey)
    }

    func resetToDefaults() {
        drugs = RSISettingsManager.defaultDrugs
        saveSettings()
    }

    func getDrug(named name: String) -> RSIDrugConfig? {
        drugs.first { $0.name == name }
    }

    func getEnabledDrugs(for category: RSIDrugCategory) -> [RSIDrugConfig] {
        drugs.filter { $0.category == category && $0.isEnabled }
    }

    func updateDrug(_ drug: RSIDrugConfig) {
        if let index = drugs.firstIndex(where: { $0.id == drug.id }) {
            drugs[index] = drug
            saveSettings()
        }
    }

    func addCustomDrug(_ drug: RSIDrugConfig) {
        drugs.append(drug)
        saveSettings()
    }

    func deleteDrug(_ drug: RSIDrugConfig) {
        drugs.removeAll { $0.id == drug.id }
        saveSettings()
    }
}

// MARK: - Design Colors (Premium Light)
private struct SettingsColors {
    static let textPrimary = Color(red: 0.04, green: 0.09, blue: 0.16)
    static let textSecondary = Color(red: 0.24, green: 0.35, blue: 0.50)
    static let textMuted = Color(red: 0.50, green: 0.55, blue: 0.60)
    static let accentBlue = Color(red: 0.06, green: 0.60, blue: 0.97)
    static let navyAccent = Color(red: 0.18, green: 0.25, blue: 0.34)
}

// MARK: - Adaptive Background
private struct SettingsLightBackground: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.07, green: 0.10, blue: 0.16),
                        Color(red: 0.05, green: 0.08, blue: 0.13),
                        Color(red: 0.07, green: 0.10, blue: 0.16)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.96, green: 0.97, blue: 0.98),
                        Color(red: 0.93, green: 0.94, blue: 0.98),
                        Color(red: 0.96, green: 0.97, blue: 0.98)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Section Divider
private struct SettingsSectionDivider: View {
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.5), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            Text(title)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(color)
                .textCase(.uppercase)
                .tracking(1.5)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, color.opacity(0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Main Settings View
struct RSIDrugSettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var settings = RSISettingsManager.shared
    @State private var showAddDrug = false
    @State private var editingDrug: RSIDrugConfig?
    @State private var showResetConfirm = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            SettingsLightBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Hero Header
                    heroHeader

                    // Institution Card
                    institutionCard

                    // Drug Categories
                    ForEach(RSIDrugCategory.allCases, id: \.self) { category in
                        categorySection(category)
                    }

                    // Reset Button
                    resetButton

                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddDrug = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                        Text("Add")
                            .font(.custom("Poppins-SemiBold", size: 13))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(SettingsColors.navyAccent)
                    )
                }
            }
        }
        .sheet(isPresented: $showAddDrug) {
            DrugConfigEditor(drug: nil) { newDrug in
                settings.addCustomDrug(newDrug)
            }
        }
        .sheet(item: $editingDrug) { drug in
            DrugConfigEditor(drug: drug) { updatedDrug in
                settings.updateDrug(updatedDrug)
            }
        }
        .alert("Reset to Defaults?", isPresented: $showResetConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                settings.resetToDefaults()
            }
        } message: {
            Text("This will restore all drug doses to their original values.")
        }
    }

    // MARK: - Hero Header
    private var heroHeader: some View {
        VStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [SettingsColors.accentBlue.opacity(0.15), SettingsColors.navyAccent.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)

                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [SettingsColors.accentBlue, SettingsColors.navyAccent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(spacing: 6) {
                Text("RSI Drug Settings")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(colorScheme == .dark ? .white : SettingsColors.textPrimary)

                Text("Customize doses for your protocols")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(colorScheme == .dark ? Color(white: 0.70) : SettingsColors.textSecondary)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Institution Card
    private var institutionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(SettingsColors.accentBlue)

                Text("Institution Name")
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .foregroundColor(colorScheme == .dark ? Color(white: 0.70) : SettingsColors.textSecondary)

                Spacer()

                if !settings.institutionName.isEmpty {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.40, green: 0.84, blue: 0.72))
                }
            }

            TextField("Your Hospital or Service (optional)", text: $settings.institutionName)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(colorScheme == .dark ? .white : SettingsColors.textPrimary)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(SettingsColors.accentBlue.opacity(0.2), lineWidth: 1)
                )
                .onChange(of: settings.institutionName) { _ in
                    settings.saveSettings()
                }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(SettingsColors.accentBlue.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }

    // MARK: - Category Section
    private func categorySection(_ category: RSIDrugCategory) -> some View {
        let categoryDrugs = settings.drugs.filter { $0.category == category }
        let enabledCount = categoryDrugs.filter { $0.isEnabled }.count

        return VStack(spacing: 12) {
            // Section Divider with Category Info
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(category.color.opacity(0.15))
                        .frame(width: 36, height: 36)

                    Image(systemName: category.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(category.color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(category.rawValue)
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(colorScheme == .dark ? .white : SettingsColors.textPrimary)

                    Text("\(enabledCount) of \(categoryDrugs.count) active")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(colorScheme == .dark ? Color(white: 0.55) : SettingsColors.textMuted)
                }

                Spacer()
            }
            .padding(.top, 8)

            // Drug Cards
            VStack(spacing: 10) {
                ForEach(categoryDrugs) { drug in
                    DrugSettingsCard(
                        drug: drug,
                        accentColor: category.color
                    ) {
                        editingDrug = drug
                    }
                }
            }
        }
    }

    // MARK: - Reset Button
    private var resetButton: some View {
        Button(action: { showResetConfirm = true }) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 14, weight: .semibold))

                Text("Reset to Default Doses")
                    .font(.custom("Poppins-SemiBold", size: 14))
            }
            .foregroundColor(Color(red: 0.75, green: 0.25, blue: 0.25))
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .fill(Color(red: 0.75, green: 0.25, blue: 0.25).opacity(0.1))
            )
            .overlay(
                Capsule()
                    .stroke(Color(red: 0.75, green: 0.25, blue: 0.25).opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.top, 16)
    }
}

// MARK: - Drug Settings Card
struct DrugSettingsCard: View {
    @Environment(\.colorScheme) var colorScheme
    let drug: RSIDrugConfig
    let accentColor: Color
    let onEdit: () -> Void

    private var textPrimary: Color { colorScheme == .dark ? .white : Color(red: 0.04, green: 0.09, blue: 0.16) }
    private var textMuted: Color { colorScheme == .dark ? Color(white: 0.55) : Color(red: 0.50, green: 0.55, blue: 0.60) }

    var body: some View {
        Button(action: onEdit) {
            HStack(spacing: 14) {
                // Status indicator
                Circle()
                    .fill(drug.isEnabled ? accentColor : Color.gray.opacity(0.3))
                    .frame(width: 10, height: 10)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(drug.name)
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(drug.isEnabled ? textPrimary : textMuted)

                        if !drug.isEnabled {
                            Text("DISABLED")
                                .font(.custom("Poppins-Bold", size: 9))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(Color.gray)
                                )
                        }
                    }

                    HStack(spacing: 10) {
                        // Dose pill
                        HStack(spacing: 4) {
                            Text("\(String(format: "%.2g", drug.defaultDose))")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(accentColor)

                            Text(drug.unit)
                                .font(.custom("Poppins-Medium", size: 12))
                                .foregroundColor(textMuted)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(accentColor.opacity(0.1))
                        )

                        if drug.concentration > 0 {
                            Text("\(String(format: "%.2g", drug.concentration)) \(drug.concentrationUnit)")
                                .font(.custom("Poppins-Regular", size: 12))
                                .foregroundColor(textMuted)
                        }
                    }

                    if !drug.notes.isEmpty {
                        Text(drug.notes)
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(textMuted)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(textMuted)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(accentColor.opacity(drug.isEnabled ? 0.2 : 0.08), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(drug.isEnabled ? 1 : 0.7)
    }
}

// MARK: - Modern Dose Input Component
private struct DoseInputField: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    let accentColor: Color

    private var textPrimary: Color { colorScheme == .dark ? .white : Color(red: 0.04, green: 0.09, blue: 0.16) }
    private var textMuted: Color { colorScheme == .dark ? Color(white: 0.55) : Color(red: 0.50, green: 0.55, blue: 0.60) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Label
            Text(label)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(textMuted)

            // Value display with +/- buttons
            HStack(spacing: 0) {
                // Minus button
                Button(action: {
                    let newValue = value - step
                    if newValue >= range.lowerBound {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                            value = newValue
                        }
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(value <= range.lowerBound ? textMuted.opacity(0.5) : accentColor)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(accentColor.opacity(0.1))
                        )
                }
                .disabled(value <= range.lowerBound)

                Spacer()

                // Value display
                VStack(spacing: 2) {
                    Text(String(format: step < 0.1 ? "%.2f" : "%.1f", value))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(textPrimary)
                        .contentTransition(.numericText())

                    Text(unit)
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(textMuted)
                }

                Spacer()

                // Plus button
                Button(action: {
                    let newValue = value + step
                    if newValue <= range.upperBound {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                            value = newValue
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(value >= range.upperBound ? textMuted.opacity(0.5) : accentColor)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(accentColor.opacity(0.1))
                        )
                }
                .disabled(value >= range.upperBound)
            }
            .padding(.horizontal, 8)

            // Slider
            VStack(spacing: 6) {
                Slider(value: $value, in: range, step: step)
                    .tint(accentColor)

                // Min/Max labels
                HStack {
                    Text(String(format: step < 0.1 ? "%.2f" : "%.1f", range.lowerBound))
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundColor(textMuted)

                    Spacer()

                    Text(String(format: step < 0.1 ? "%.2f" : "%.1f", range.upperBound))
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundColor(textMuted)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.systemGray6).opacity(0.7))
        )
    }
}

// MARK: - Compact Number Input
private struct CompactNumberInput: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    @Binding var value: Double
    let accentColor: Color

    private var textPrimary: Color { colorScheme == .dark ? .white : Color(red: 0.04, green: 0.09, blue: 0.16) }
    private var textMuted: Color { colorScheme == .dark ? Color(white: 0.55) : Color(red: 0.50, green: 0.55, blue: 0.60) }

    @State private var textValue: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(textMuted)

            TextField("0", text: $textValue)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(accentColor)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .focused($isFocused)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(isFocused ? accentColor : Color(UIColor.systemGray4), lineWidth: isFocused ? 2 : 1)
                        )
                )
                .onChange(of: textValue) { newValue in
                    if let doubleValue = Double(newValue) {
                        value = doubleValue
                    }
                }
                .onAppear {
                    textValue = value > 0 ? String(format: "%.2g", value) : ""
                }
        }
    }
}

// MARK: - Drug Config Editor
struct DrugConfigEditor: View {
    @Environment(\.colorScheme) var colorScheme
    let drug: RSIDrugConfig?
    let onSave: (RSIDrugConfig) -> Void

    @State private var name: String = ""
    @State private var category: RSIDrugCategory = .induction
    @State private var defaultDose: Double = 0
    @State private var minDose: Double = 0
    @State private var maxDose: Double = 10
    @State private var unit: String = "mg/kg"
    @State private var concentration: Double = 0
    @State private var concentrationUnit: String = "mg/mL"
    @State private var isEnabled: Bool = true
    @State private var notes: String = ""

    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?

    private enum Field {
        case name, notes
    }

    private var textPrimary: Color { colorScheme == .dark ? .white : Color(red: 0.04, green: 0.09, blue: 0.16) }
    private var textSecondary: Color { colorScheme == .dark ? Color(white: 0.70) : Color(red: 0.24, green: 0.35, blue: 0.50) }
    private var textMuted: Color { colorScheme == .dark ? Color(white: 0.55) : Color(red: 0.50, green: 0.55, blue: 0.60) }
    private let accentBlue = Color(red: 0.06, green: 0.60, blue: 0.97)
    private let navyAccent = Color(red: 0.18, green: 0.25, blue: 0.34)
    private let accentGreen = Color(red: 0.40, green: 0.84, blue: 0.72)

    private var exampleVolume: String {
        guard concentration > 0, defaultDose > 0 else { return "" }
        let totalDose = defaultDose * 70
        let volume = totalDose / concentration
        return String(format: "%.1f mL for 70kg patient", volume)
    }

    private var doseRange: ClosedRange<Double> {
        let lower = max(0.01, minDose)
        let upper = max(lower + 0.1, maxDose)
        return lower...upper
    }

    private var doseStep: Double {
        if maxDose <= 0.5 { return 0.01 }
        if maxDose <= 2 { return 0.1 }
        if maxDose <= 10 { return 0.5 }
        return 1.0
    }

    var body: some View {
        NavigationView {
            ZStack {
                SettingsLightBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Drug Info Section
                        settingsCard {
                            VStack(spacing: 16) {
                                cardHeader(title: "Drug Information", icon: "pills.fill", color: accentBlue)

                                // Name input
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Drug Name")
                                        .font(.custom("Poppins-Medium", size: 12))
                                        .foregroundColor(textMuted)

                                    TextField("Enter drug name", text: $name)
                                        .font(.custom("Poppins-SemiBold", size: 16))
                                        .foregroundColor(textPrimary)
                                        .focused($focusedField, equals: .name)
                                        .padding(14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                        .stroke(focusedField == .name ? accentBlue : Color(UIColor.systemGray4), lineWidth: focusedField == .name ? 2 : 1)
                                                )
                                        )
                                }

                                Divider()

                                // Category picker
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Category")
                                        .font(.custom("Poppins-Medium", size: 12))
                                        .foregroundColor(textMuted)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 10) {
                                            ForEach(RSIDrugCategory.allCases, id: \.self) { cat in
                                                Button(action: { category = cat }) {
                                                    HStack(spacing: 6) {
                                                        Image(systemName: cat.icon)
                                                            .font(.system(size: 12, weight: .semibold))
                                                        Text(cat.rawValue)
                                                            .font(.custom("Poppins-Medium", size: 12))
                                                    }
                                                    .foregroundColor(category == cat ? .white : cat.color)
                                                    .padding(.horizontal, 14)
                                                    .padding(.vertical, 10)
                                                    .background(
                                                        Capsule()
                                                            .fill(category == cat ? cat.color : cat.color.opacity(0.1))
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }

                                Divider()

                                // Enable toggle
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Enable Drug")
                                            .font(.custom("Poppins-Medium", size: 14))
                                            .foregroundColor(textPrimary)
                                        Text("Show in RSI calculations")
                                            .font(.custom("Poppins-Regular", size: 11))
                                            .foregroundColor(textMuted)
                                    }
                                    Spacer()
                                    Toggle("", isOn: $isEnabled)
                                        .tint(accentGreen)
                                }
                            }
                        }

                        // Dosing Section - Modern Slider
                        settingsCard {
                            VStack(spacing: 16) {
                                cardHeader(title: "Default Dose", icon: "syringe.fill", color: category.color)

                                DoseInputField(
                                    label: "Dose per kg",
                                    value: $defaultDose,
                                    range: doseRange,
                                    step: doseStep,
                                    unit: unit,
                                    accentColor: category.color
                                )
                            }
                        }

                        // Range Section
                        settingsCard {
                            VStack(spacing: 16) {
                                cardHeader(title: "Dose Range", icon: "arrow.left.arrow.right", color: navyAccent)

                                HStack(spacing: 16) {
                                    CompactNumberInput(label: "Minimum", value: $minDose, accentColor: navyAccent)
                                    CompactNumberInput(label: "Maximum", value: $maxDose, accentColor: navyAccent)
                                }

                                // Unit picker
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Unit")
                                        .font(.custom("Poppins-Medium", size: 12))
                                        .foregroundColor(textMuted)

                                    HStack(spacing: 10) {
                                        ForEach(["mg/kg", "mcg/kg", "mg", "mcg"], id: \.self) { u in
                                            Button(action: { unit = u }) {
                                                Text(u)
                                                    .font(.custom("Poppins-Medium", size: 12))
                                                    .foregroundColor(unit == u ? .white : navyAccent)
                                                    .padding(.horizontal, 14)
                                                    .padding(.vertical, 10)
                                                    .background(
                                                        Capsule()
                                                            .fill(unit == u ? navyAccent : navyAccent.opacity(0.1))
                                                    )
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Concentration Section
                        settingsCard {
                            VStack(spacing: 16) {
                                cardHeader(title: "Concentration", icon: "drop.fill", color: Color(red: 0.55, green: 0.35, blue: 0.75))

                                CompactNumberInput(label: "Vial Concentration", value: $concentration, accentColor: Color(red: 0.55, green: 0.35, blue: 0.75))

                                // Concentration unit picker
                                HStack(spacing: 10) {
                                    ForEach(["mg/mL", "mcg/mL"], id: \.self) { u in
                                        Button(action: { concentrationUnit = u }) {
                                            Text(u)
                                                .font(.custom("Poppins-Medium", size: 13))
                                                .foregroundColor(concentrationUnit == u ? .white : Color(red: 0.55, green: 0.35, blue: 0.75))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .background(
                                                    Capsule()
                                                        .fill(concentrationUnit == u ? Color(red: 0.55, green: 0.35, blue: 0.75) : Color(red: 0.55, green: 0.35, blue: 0.75).opacity(0.1))
                                                )
                                        }
                                    }
                                    Spacer()
                                }

                                if !exampleVolume.isEmpty {
                                    HStack {
                                        Image(systemName: "info.circle.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(accentGreen)
                                        Text(exampleVolume)
                                            .font(.custom("Poppins-Medium", size: 13))
                                            .foregroundColor(accentGreen)
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(accentGreen.opacity(0.1))
                                    )
                                }
                            }
                        }

                        // Notes Section
                        settingsCard {
                            VStack(spacing: 12) {
                                cardHeader(title: "Clinical Notes", icon: "note.text", color: textSecondary)

                                TextEditor(text: $notes)
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(textPrimary)
                                    .frame(minHeight: 80)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                                            )
                                    )
                                    .scrollContentBackground(.hidden)
                            }
                        }

                        // Delete Button
                        if drug != nil {
                            Button(action: {
                                RSISettingsManager.shared.deleteDrug(drug!)
                                dismiss()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "trash.fill")
                                    Text("Delete Drug")
                                }
                                .font(.custom("Poppins-SemiBold", size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 14)
                                .background(
                                    Capsule()
                                        .fill(Color.red)
                                )
                                .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.top, 8)
                        }

                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(drug == nil ? "Add Drug" : "Edit Drug")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.custom("Poppins-Medium", size: 15))
                        .foregroundColor(textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let config = RSIDrugConfig(
                            id: drug?.id ?? UUID(),
                            name: name,
                            category: category,
                            defaultDose: defaultDose,
                            minDose: minDose,
                            maxDose: maxDose,
                            unit: unit,
                            concentration: concentration,
                            concentrationUnit: concentrationUnit,
                            isEnabled: isEnabled,
                            notes: notes
                        )
                        onSave(config)
                        dismiss()
                    }
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(name.isEmpty ? .gray : accentBlue)
                    .disabled(name.isEmpty || defaultDose <= 0)
                }
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(accentBlue)
                    }
                }
            }
            .onAppear {
                if let drug = drug {
                    name = drug.name
                    category = drug.category
                    defaultDose = drug.defaultDose
                    minDose = drug.minDose
                    maxDose = drug.maxDose
                    unit = drug.unit
                    concentration = drug.concentration
                    concentrationUnit = drug.concentrationUnit
                    isEnabled = drug.isEnabled
                    notes = drug.notes
                }
            }
        }
    }

    // MARK: - Card Components
    private func settingsCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color(UIColor.systemGray4).opacity(0.4), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
    }

    private func cardHeader(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 32, height: 32)

                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
            }

            Text(title)
                .font(.custom("Poppins-SemiBold", size: 15))
                .foregroundColor(textPrimary)

            Spacer()
        }
        .padding(.bottom, 12)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        RSIDrugSettingsView()
    }
}
