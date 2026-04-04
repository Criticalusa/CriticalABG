//
//  GlobalPatientContext.swift
//  CriticalX
//
//  Global Patient Context Manager
//  Stores patient weight and basic info for use across all moments
//  Weight is entered once and inferred throughout the app
//  PHI stored in Keychain; auto-clear timer optional (1h / 4h / 12h / manual).
//

import SwiftUI
import Combine
import UIKit

// MARK: - Persisted Patient Context (Keychain)
/// Codable payload for Keychain storage (PHI). Never log or send to analytics.
private struct PatientContextPayload: Codable {
    var weight: Double?
    var weightUnit: String
    var patientInitials: String
    var gender: String
    var heightCm: Double?
    var lastWeightUpdateISO: String?
}

// MARK: - Devine formula constants (IBW)
/// Named constants for Ideal Body Weight (Devine formula).
/// Males: 50 + 2.3×(height in - 60); Females: 45.5 + 2.3×(height in - 60)
private enum DevineIBW {
    static let maleBaseKg = 50.0
    static let femaleBaseKg = 45.5
    static let inchesFactor = 2.3
    static let maleMinKg = 45.0
    static let femaleMinKg = 40.0
    static let unspecifiedMinKg = 42.0
}

// MARK: - Auto-clear interval
/// User preference (non-PHI): 0 = manual, else seconds until context is auto-cleared.
enum PatientContextAutoClear: Int, CaseIterable {
    case manual = 0
    case oneHour = 3600
    case fourHours = 14400
    case twelveHours = 43200
    
    var displayName: String {
        switch self {
        case .manual: return "Never"
        case .oneHour: return "1 hour"
        case .fourHours: return "4 hours"
        case .twelveHours: return "12 hours"
        }
    }
}

// MARK: - Global Patient Context Manager
/// Singleton that manages patient context across the entire app
/// Weight entered once is used for all drug calculations until cleared or changed
/// Named GlobalPatientContext to avoid conflict with PatientContext struct in MomentModel
/// PHI stored in Keychain; auto-clear checked on launch and app become-active.
class GlobalPatientContext: ObservableObject {
    static let shared = GlobalPatientContext()
    
    private static let autoClearUserDefaultsKey = "PatientContext.autoClearInterval"
    private var isLoadingFromKeychain = false
    
    // MARK: - Published Properties
    @Published var weight: Double? = nil {
        didSet {
            guard !isLoadingFromKeychain else { return }
            if weight != nil { lastWeightUpdate = Date() }
            persistToKeychain()
        }
    }
    
    @Published var weightUnit: WeightUnit = .kg {
        didSet { if !isLoadingFromKeychain { persistToKeychain() } }
    }
    
    @Published var patientInitials: String = "" {
        didSet { if !isLoadingFromKeychain { persistToKeychain() } }
    }
    
    @Published var gender: Gender = .notSpecified {
        didSet { if !isLoadingFromKeychain { persistToKeychain() } }
    }
    
    @Published var heightCm: Double? = nil {
        didSet { if !isLoadingFromKeychain { persistToKeychain() } }
    }
    
    @Published var isActive: Bool = false // Whether we have an active patient
    
    /// User preference: when to auto-clear context (stored in UserDefaults, not PHI). Synced to iCloud.
    @Published var autoClearInterval: PatientContextAutoClear = .manual {
        didSet {
            UserDefaults.standard.set(autoClearInterval.rawValue, forKey: Self.autoClearUserDefaultsKey)
            ICloudSettingsSync.shared.set(key: Self.autoClearUserDefaultsKey, value: autoClearInterval.rawValue)
        }
    }
    
    private(set) var lastWeightUpdate: Date?
    
    // MARK: - Weight Units
    enum WeightUnit: String, CaseIterable {
        case kg = "kg"
        case lbs = "lbs"
        
        var conversionToKg: Double {
            switch self {
            case .kg: return 1.0
            case .lbs: return 0.453592
            }
        }
    }
    
    // MARK: - Gender
    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case notSpecified = "Not Specified"
    }
    
    // Convenience typealias for shorter access
    typealias Unit = WeightUnit
    
    // MARK: - Computed Properties
    
    /// Weight in kg (converts from lbs if needed)
    var weightInKg: Double? {
        guard let weight = weight else { return nil }
        return weight * weightUnit.conversionToKg
    }
    
    /// Formatted weight string
    var weightString: String {
        guard let weight = weight else { return "Not set" }
        return String(format: "%.1f %@", weight, weightUnit.rawValue)
    }
    
    /// Ideal Body Weight (IBW) for ventilator calculations.
    /// Uses Devine formula with named constants (DevineIBW).
    var idealBodyWeight: Double? {
        guard let heightCm = heightCm else {
            guard let kg = weightInKg else { return nil }
            return kg * 0.85
        }
        let heightInches = heightCm / 2.54
        switch gender {
        case .male:
            return max(DevineIBW.maleBaseKg + DevineIBW.inchesFactor * (heightInches - 60), DevineIBW.maleMinKg)
        case .female:
            return max(DevineIBW.femaleBaseKg + DevineIBW.inchesFactor * (heightInches - 60), DevineIBW.femaleMinKg)
        case .notSpecified:
            let male = DevineIBW.maleBaseKg + DevineIBW.inchesFactor * (heightInches - 60)
            let female = DevineIBW.femaleBaseKg + DevineIBW.inchesFactor * (heightInches - 60)
            return max((male + female) / 2, DevineIBW.unspecifiedMinKg)
        }
    }
    
    /// IBW string for display
    var ibwString: String {
        guard let ibw = idealBodyWeight else { return "Not set" }
        return String(format: "%.1f kg", ibw)
    }
    
    /// Height in feet and inches for display
    var heightString: String {
        guard let cm = heightCm else { return "Not set" }
        let totalInches = cm / 2.54
        let feet = Int(totalInches / 12)
        let inches = Int(totalInches.truncatingRemainder(dividingBy: 12))
        return "\(feet)'\(inches)\" (\(Int(cm)) cm)"
    }
    
    /// Check if weight was set recently (within 12 hours)
    var isWeightRecent: Bool {
        guard let lastUpdate = lastWeightUpdate else { return false }
        return Date().timeIntervalSince(lastUpdate) < 43200
    }
    
    // MARK: - Initialization
    private init() {
        let raw = UserDefaults.standard.integer(forKey: Self.autoClearUserDefaultsKey)
        self.autoClearInterval = PatientContextAutoClear(rawValue: raw) ?? .manual
        loadFromKeychain()
        checkAutoClear()
        setupAppActiveObserver()
    }
    
    // MARK: - Keychain persistence (PHI)
    private func persistToKeychain() {
        let payload = PatientContextPayload(
            weight: weight,
            weightUnit: weightUnit.rawValue,
            patientInitials: patientInitials,
            gender: gender.rawValue,
            heightCm: heightCm,
            lastWeightUpdateISO: lastWeightUpdate.flatMap { ISO8601DateFormatter().string(from: $0) }
        )
        guard let data = try? JSONEncoder().encode(payload),
              let json = String(data: data, encoding: .utf8) else { return }
        KeychainHelper.save(json, for: .patientContext)
    }
    
    private func loadFromKeychain() {
        guard let json = KeychainHelper.get(.patientContext),
              let data = json.data(using: .utf8),
              let payload = try? JSONDecoder().decode(PatientContextPayload.self, from: data) else {
            migrateFromUserDefaultsIfNeeded()
            return
        }
        isLoadingFromKeychain = true
        defer { isLoadingFromKeychain = false }
        weight = payload.weight
        weightUnit = WeightUnit(rawValue: payload.weightUnit) ?? .kg
        patientInitials = payload.patientInitials
        gender = Gender(rawValue: payload.gender) ?? .notSpecified
        heightCm = payload.heightCm
        lastWeightUpdate = payload.lastWeightUpdateISO.flatMap { ISO8601DateFormatter().date(from: $0) }
        isActive = weight != nil
    }
    
    /// One-time migration from UserDefaults to Keychain, then remove old keys.
    private func migrateFromUserDefaultsIfNeeded() {
        let ud = UserDefaults.standard
        if let savedWeight = ud.object(forKey: "PatientContext.weight") as? Double { weight = savedWeight }
        if let savedUnit = ud.string(forKey: "PatientContext.weightUnit"), let unit = WeightUnit(rawValue: savedUnit) { weightUnit = unit }
        if let s = ud.string(forKey: "PatientContext.initials") { patientInitials = s }
        if let s = ud.string(forKey: "PatientContext.gender"), let g = Gender(rawValue: s) { gender = g }
        if let h = ud.object(forKey: "PatientContext.heightCm") as? Double { heightCm = h }
        isActive = weight != nil
        persistToKeychain()
        ud.removeObject(forKey: "PatientContext.weight")
        ud.removeObject(forKey: "PatientContext.weightUnit")
        ud.removeObject(forKey: "PatientContext.initials")
        ud.removeObject(forKey: "PatientContext.gender")
        ud.removeObject(forKey: "PatientContext.heightCm")
    }
    
    /// If auto-clear is enabled and interval has passed, clear context.
    func checkAutoClear() {
        guard autoClearInterval != .manual,
              let last = lastWeightUpdate else { return }
        if Date().timeIntervalSince(last) >= TimeInterval(autoClearInterval.rawValue) {
            clearContext()
        }
    }
    
    private func setupAppActiveObserver() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.checkAutoClear()
        }
    }
    
    /// Set weight with unit
    func setWeight(_ value: Double, unit: WeightUnit = .kg) {
        self.weightUnit = unit
        self.weight = value
        self.isActive = true
    }
    
    /// Set weight from string input
    func setWeight(from string: String, unit: WeightUnit = .kg) {
        if let value = Double(string.trimmingCharacters(in: .whitespaces)) {
            setWeight(value, unit: unit)
        }
    }
    
    /// Clear patient context (new patient). Removes PHI from Keychain.
    func clearContext() {
        weight = nil
        patientInitials = ""
        gender = .notSpecified
        heightCm = nil
        isActive = false
        lastWeightUpdate = nil
        KeychainHelper.delete(.patientContext)
    }
    
    /// Start new patient session
    func startNewPatient(initials: String = "", weight: Double? = nil, unit: WeightUnit = .kg) {
        clearContext()
        if let w = weight {
            setWeight(w, unit: unit)
        }
        patientInitials = initials
        isActive = true
    }
}

// MARK: - Patient Weight Bar View
/// Small bar that shows current patient weight - can be placed at top of moments
struct PatientWeightBar: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var context = GlobalPatientContext.shared
    @State private var showWeightEditor = false
    
    var body: some View {
        Button(action: { showWeightEditor = true }) {
            HStack(spacing: 8) {
                Image(systemName: "scalemass.fill")
                    .font(.caption)
                    .foregroundColor(context.weight != nil ? .green : .orange)
                
                if let weight = context.weight {
                    Text(String(format: "%.0f %@", weight, context.weightUnit.rawValue))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                } else {
                    Text("Set Weight")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                Image(systemName: "pencil")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .accessibilityLabel(context.weight.map { "Patient weight: \(String(format: "%.0f", $0)) \(context.weightUnit.rawValue)" } ?? "Set patient weight")
        .accessibilityHint("Opens weight editor")
        .sheet(isPresented: $showWeightEditor) {
            QuickWeightEditor()
        }
    }
}

// MARK: - Quick Weight Editor
struct QuickWeightEditor: View {
    @ObservedObject var context = GlobalPatientContext.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var weightText: String = ""
    @State private var selectedUnit: GlobalPatientContext.WeightUnit = .kg
    @State private var initialsText: String = ""
    @State private var selectedGender: GlobalPatientContext.Gender = .notSpecified
    @State private var heightText: String = ""
    
    // Calculated IBW preview
    private var previewIBW: Double? {
        guard let height = Double(heightText), height > 0 else { return nil }
        let heightInches = height / 2.54
        switch selectedGender {
        case .male:
            return max(50 + 2.3 * (heightInches - 60), 45)
        case .female:
            return max(45.5 + 2.3 * (heightInches - 60), 40)
        case .notSpecified:
            let male = 50 + 2.3 * (heightInches - 60)
            let female = 45.5 + 2.3 * (heightInches - 60)
            return max((male + female) / 2, 42)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.cardBlue)
                        
                        Text("Patient Info")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("For accurate drug dosing & vent settings")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 16)
                    
                    // Weight Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("WEIGHT")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            TextField("Weight", text: $weightText)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 28, weight: .bold))
                                .multilineTextAlignment(.center)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                )
                            
                            Picker("Unit", selection: $selectedUnit) {
                                ForEach(GlobalPatientContext.WeightUnit.allCases, id: \.self) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 100)
                        }
                        
                        // Quick weight buttons
                        HStack(spacing: 8) {
                            ForEach([50, 70, 80, 100], id: \.self) { weight in
                                Button(action: { weightText = "\(weight)" }) {
                                    Text("\(weight)")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.cardBlue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.cardBlue, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Gender & Height Section (for IBW)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("FOR IDEAL BODY WEIGHT (IBW)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if let ibw = previewIBW {
                                Text("IBW: \(String(format: "%.1f", ibw)) kg")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        // Gender Picker
                        Picker("Gender", selection: $selectedGender) {
                            ForEach(GlobalPatientContext.Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue).tag(gender)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        // Height Input
                        HStack {
                            Text("Height (cm)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            TextField("170", text: $heightText)
                                .keyboardType(.decimalPad)
                                .font(.headline)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray6))
                                )
                            
                            Text("cm")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Quick height buttons
                        HStack(spacing: 8) {
                            ForEach([155, 165, 175, 185], id: \.self) { height in
                                Button(action: { heightText = "\(height)" }) {
                                    Text("\(height)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        
                        // IBW Formula info
                        Text("Devine formula: ♂ 50 + 2.3×(in-60) | ♀ 45.5 + 2.3×(in-60)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6).opacity(0.5))
                    )
                    .padding(.horizontal)
                    
                    // Initials (optional)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("INITIALS (Optional)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        TextField("e.g., J.D.", text: $initialsText)
                            .font(.subheadline)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.horizontal)
                    
                    // Auto-clear (user preference: when to clear context)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AUTO-CLEAR CONTEXT")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Text("Clear patient info after a period to avoid using the wrong patient.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Picker("Auto-clear", selection: Binding(
                            get: { context.autoClearInterval },
                            set: { context.autoClearInterval = $0 }
                        )) {
                            ForEach(PatientContextAutoClear.allCases, id: \.rawValue) { option in
                                Text(option.displayName).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                    
                    // Buttons
                    VStack(spacing: 12) {
                        Button(action: savePatient) {
                            Text("Save Patient Info")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBlue)
                                )
                        }
                        .disabled(weightText.isEmpty)
                        
                        if context.weight != nil {
                            Button(action: clearPatient) {
                                Text("Clear (New Patient)")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                if let weight = context.weight {
                    weightText = String(format: "%.0f", weight)
                }
                selectedUnit = context.weightUnit
                initialsText = context.patientInitials
                selectedGender = context.gender
                if let height = context.heightCm {
                    heightText = String(format: "%.0f", height)
                }
            }
        }
    }
    
    private func savePatient() {
        context.setWeight(from: weightText, unit: selectedUnit)
        context.patientInitials = initialsText
        context.gender = selectedGender
        if let height = Double(heightText) {
            context.heightCm = height
        }
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        dismiss()
    }
    
    private func clearPatient() {
        context.clearContext()
        weightText = ""
        initialsText = ""
        selectedGender = .notSpecified
        heightText = ""
    }
}

// MARK: - Preview
#Preview {
    VStack {
        PatientWeightBar()
        Spacer()
    }
    .padding()
}

