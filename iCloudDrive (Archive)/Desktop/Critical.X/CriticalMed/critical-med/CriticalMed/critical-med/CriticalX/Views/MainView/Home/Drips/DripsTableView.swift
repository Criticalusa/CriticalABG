//
//  DripsTableView.swift
//  CriticalX
//
//  Created by Macbook 4 on 16/12/2021.
//

import SwiftUI

class DripValue: ObservableObject {

    @Published var value: DripsModel = DripsModel(
        title: "",
        brandName: "",
        category: .pressors,
        doseRange: "",
        minDose: "0",
        maxDose: "0",
        unit: "",
        increment: "1",
        totalDose: "0",
        bagVolume: "0",
        standardConcentration: "",
        drugClass: "",
        indications: "",
        criticalInfo: ""
    )
}

struct DripsTableView: View {
    @Environment(\.colorScheme) var colorScheme
    private let externalSelectedCategory: Binding<String?>?
    @State private var internalSelectedCategory: String? = nil

    init(selectedCategory: Binding<String?>? = nil) {
        self.externalSelectedCategory = selectedCategory
    }

    private var selectedCategory: Binding<String?> {
        if let external = externalSelectedCategory {
            return external
        } else {
            return Binding(
                get: { internalSelectedCategory },
                set: { internalSelectedCategory = $0 }
            )
        }
    }

    @State private var isActive = false
    @State private var dripslist : [Any] = []
    @State private var arrDrips : [DripsModel] = []
    @State private var change = false
    @State private var searchText = ""
    @State private var showUpgradePrompt = false
    @ObservedObject var selectedDrip: DripValue = DripValue()
    @ObservedObject private var patientContext = GlobalPatientContext.shared
    @ObservedObject private var accessManager = ContentAccessManager.shared

    // Computed property for filtered drips
    private var filteredDrips: [DripsModel] {
        var drips = arrDrips

        // Filter by category (drugClass)
        if let category = selectedCategory.wrappedValue {
            drips = drips.filter { drip in
                let drugClass = drip.drugClass.lowercased()
                switch category {
                case "Vasoactive":
                    return drugClass.contains("vasoactive") || drugClass.contains("vasopressor") || drugClass.contains("inotrope")
                case "Antiarrhythmic":
                    return drugClass.contains("antiarrhythmic") || drugClass.contains("arrhythmia")
                case "Sedation":
                    return drugClass.contains("sedation") || drugClass.contains("sedative") || drugClass.contains("anesthetic")
                case "Neuromuscular Blockers":
                    return drugClass.contains("neuromuscular") || drugClass.contains("blocker") || drugClass.contains("paralytic")
                case "Diuretics":
                    return drugClass.contains("diuretic") || drugClass.contains("loop")
                case "Other":
                    return !drugClass.contains("vasoactive") && !drugClass.contains("antiarrhythmic") && !drugClass.contains("sedation") && !drugClass.contains("sedative") && !drugClass.contains("neuromuscular") && !drugClass.contains("diuretic")
                default:
                    return true
                }
            }
        }

        // Filter by search text
        if !searchText.isEmpty {
            drips = drips.filter {
                $0.title.lowercased().hasPrefix(searchText.lowercased()) ||
                $0.brandName.lowercased().hasPrefix(searchText.lowercased()) ||
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.brandName.localizedCaseInsensitiveContains(searchText)
            }
        }

        return drips
    }

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Search Bar with refresh
                HStack(spacing: 8) {
                    SearchBarView(searchText: $searchText)
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.Name("ResetDripsValues"), object: nil)
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(.systemGray))
                            .frame(width: 36, height: 36)
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 8)
                .padding(.vertical, -10)
                .padding(.bottom, -10)
                .background(CriticalDesign.Adaptive.canvas(for: colorScheme))
                .zIndex(100)

                // Category Scroll Bar — fixed padding so "All" isn't clipped
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        Button(action: {
                            withAnimation {
                                selectedCategory.wrappedValue = nil
                            }
                        }) {
                            CriticalHomePage.NavigationButton(
                                title: "All",
                                icon: "square.grid.2x2",
                                isSelected: selectedCategory.wrappedValue == nil
                            )
                        }
                        .buttonStyle(.plain)

                        Button(action: {
                            withAnimation {
                                selectedCategory.wrappedValue = "Vasoactive"
                            }
                        }) {
                            CriticalHomePage.NavigationButton(
                                title: "Vasoactive",
                                icon: "heart.circle",
                                isSelected: selectedCategory.wrappedValue == "Vasoactive"
                            )
                        }
                        .buttonStyle(.plain)

                        Button(action: {
                            withAnimation {
                                selectedCategory.wrappedValue = "Antiarrhythmic"
                            }
                        }) {
                            CriticalHomePage.NavigationButton(
                                title: "Antiarrhythmic",
                                icon: "waveform.path.ecg",
                                isSelected: selectedCategory.wrappedValue == "Antiarrhythmic"
                            )
                        }
                        .buttonStyle(.plain)

                        Button(action: {
                            withAnimation {
                                selectedCategory.wrappedValue = "Sedation"
                            }
                        }) {
                            CriticalHomePage.NavigationButton(
                                title: "Sedation",
                                icon: "moon.zzz",
                                isSelected: selectedCategory.wrappedValue == "Sedation"
                            )
                        }
                        .buttonStyle(.plain)

                        Button(action: {
                            withAnimation {
                                selectedCategory.wrappedValue = "Neuromuscular Blockers"
                            }
                        }) {
                            CriticalHomePage.NavigationButton(
                                title: "NMB",
                                icon: "figure.stand",
                                isSelected: selectedCategory.wrappedValue == "Neuromuscular Blockers"
                            )
                        }
                        .buttonStyle(.plain)

                        Button(action: {
                            withAnimation {
                                selectedCategory.wrappedValue = "Diuretics"
                            }
                        }) {
                            CriticalHomePage.NavigationButton(
                                title: "Diuretics",
                                icon: "drop.triangle",
                                isSelected: selectedCategory.wrappedValue == "Diuretics"
                            )
                        }
                        .buttonStyle(.plain)

                        Button(action: {
                            withAnimation {
                                selectedCategory.wrappedValue = "Other"
                            }
                        }) {
                            CriticalHomePage.NavigationButton(
                                title: "Other",
                                icon: "ellipsis.circle",
                                isSelected: selectedCategory.wrappedValue == "Other"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                }
                .zIndex(1)
                .background(CriticalDesign.Adaptive.canvas(for: colorScheme))

                // Patient weight bar
                DripsWeightBar(drips: arrDrips)

                if arrDrips.count > 0 {

                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredDrips) { drip in
                                let isAccessible = accessManager.canAccessDrip(drip.title)

                                if isAccessible {
                                    NavigationLink(destination: DripsCalculatorView(dripsDetail: drip)) {
                                        DripsListItemView(dripsDetail: drip)
                                    }
                                    .buttonStyle(.plain)
                                    .contextMenu {
                                        Button {
                                            let isFavorite = getIsFavorite(title: drip.title, type: "Drip")
                                            togleFavorites(title: drip.title, type: "Drip", isFavorite: !isFavorite)
                                        } label: {
                                            Label(
                                                getIsFavorite(title: drip.title, type: "Drip") ? "Remove from Favorites" : "Add to Favorites",
                                                systemImage: getIsFavorite(title: drip.title, type: "Drip") ? "star.slash.fill" : "star.fill"
                                            )
                                        }

                                        Button {
                                            self.selectedDrip.value = drip
                                            isActive = true
                                        } label: {
                                            Label("Update Dosages", systemImage: "slider.horizontal.3")
                                        }
                                    }
                                } else {
                                    Button {
                                        showUpgradePrompt = true
                                    } label: {
                                        DripsListItemView(dripsDetail: drip, isLocked: true)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(colorScheme == .dark
                                    ? Color(red: 22/255, green: 29/255, blue: 46/255)
                                    : .white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(colorScheme == .dark
                                    ? Color.white.opacity(0.06)
                                    : Color(red: 0.11, green: 0.21, blue: 0.34).opacity(0.08),
                                    lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 100) // Space for tab bar
                    }
                }
            }
        }

        .onAppear {
            loadDripsData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetDripsValues"))) { _ in
            reset()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $isActive) {
            UpdateDosageView(dripsModel: selectedDrip)
                .navigationBarBackground { Color.logoBlue.shadow(radius: 1) }
        }
        .sheet(isPresented: $showUpgradePrompt) {
            UpgradePromptView()
        }
    }

    // MARK: - Data Loading

    /// Load drips: DrugRepository (primary) → UserDefaults (customizations) → Calculator.plist (legacy fallback).
    private func loadDripsData() {
        dripslist.removeAll()
        arrDrips.removeAll()

        // 1. Primary: DrugRepository (synced/bundled JSON)
        let repoDrips = DrugRepository.shared.allDrips().map { $0.toDripsModel() }

        if !repoDrips.isEmpty {
            // Load customized user values from UserDefaults (if any)
            let savedDrips: [DripsModel]
            if let saved = UserDefaults.standard.array(forKey: "drip_list") {
                savedDrips = saved.map { DripsModel(drip: $0 as AnyObject) }
            } else {
                savedDrips = []
            }

            for var drip in repoDrips {
                // Overlay user-customized dose if they modified it in UpdateDosageView
                if let custom = savedDrips.first(where: { $0 == drip }), !custom.dose.isEmpty {
                    drip.dose = custom.dose
                }
                applyDynamicIncrement(&drip)
                arrDrips.append(drip)
            }
            return
        }

        // 2. Fallback: UserDefaults (existing customizations)
        if let ndripslist = UserDefaults.standard.object(forKey: "drip_list") as? [Any] {
            ndripslist.forEach { item in
                var drip = DripsModel(drip: item as AnyObject)
                var mItem = item as! [String : Any]
                applyDynamicIncrement(&drip)
                mItem["increment"] = drip.increment
                dripslist.append(mItem)
                arrDrips.append(drip)
            }

            // Merge any new drips from Calculator.plist not yet in UserDefaults
            if let url = Bundle.main.url(forResource: "Calculator", withExtension: "plist"),
               let plistDrips = NSArray(contentsOf: url) as? [Any] {
                plistDrips.forEach { item in
                    var drip = DripsModel(drip: item as AnyObject)
                    if !arrDrips.contains(where: { $0 == drip }) {
                        var mItem = item as! [String : Any]
                        applyDynamicIncrement(&drip)
                        mItem["increment"] = drip.increment
                        arrDrips.append(drip)
                        dripslist.append(mItem)
                    }
                }
                UserDefaults.standard.set(dripslist, forKey: "drip_list")
            }
            return
        }

        // 3. Fallback: Calculator.plist (fresh install, no repo data)
        if let url = Bundle.main.url(forResource: "Calculator", withExtension: "plist"),
           let plistDrips = NSArray(contentsOf: url) as? [Any] {
            plistDrips.forEach { item in
                var drip = DripsModel(drip: item as AnyObject)
                var mItem = item as! [String : Any]
                applyDynamicIncrement(&drip)
                mItem["increment"] = drip.increment
                dripslist.append(mItem)
                arrDrips.append(drip)
            }
            UserDefaults.standard.set(dripslist, forKey: "drip_list")
        }
    }

    /// Apply dynamic increment adjustment based on current dose value.
    private func applyDynamicIncrement(_ drip: inout DripsModel) {
        let doseVal = Float(drip.dose.isEmpty ? drip.minDose : drip.dose) ?? 0
        if doseVal < 0.1 { drip.increment = "0.01" }
        if doseVal >= 0.5 { drip.increment = "0.1" }
        if doseVal >= 1 { drip.increment = "0.5" }
        if doseVal >= 10 { drip.increment = "1" }
    }

    /// Reset drips to defaults: DrugRepository (primary) → Calculator.plist (fallback).
    /// Clears any user customizations in UserDefaults.
    func reset() {
        dripslist.removeAll()
        arrDrips.removeAll()
        UserDefaults.standard.removeObject(forKey: "drip_list")

        // Reload from DrugRepository or plist
        let repoDrips = DrugRepository.shared.allDrips().map { $0.toDripsModel() }
        if !repoDrips.isEmpty {
            arrDrips = repoDrips.map { var d = $0; applyDynamicIncrement(&d); return d }
            return
        }

        if let url = Bundle.main.url(forResource: "Calculator", withExtension: "plist"),
           let plistDrips = NSArray(contentsOf: url) as? [Any] {
            plistDrips.forEach { item in
                let drip = DripsModel(drip: item as AnyObject)
                dripslist.append(item)
                arrDrips.append(drip)
            }
            UserDefaults.standard.set(plistDrips, forKey: "drip_list")
        }
    }
}

// MARK: - Compact patient weight bar
private struct DripsWeightBar: View {
    let drips: [DripsModel]
    @ObservedObject private var patientContext = GlobalPatientContext.shared
    @Environment(\.colorScheme) var colorScheme
    @State private var weightInput: String = ""
    @State private var selectedUnit: WeightUnit = .kg
    @State private var showSavedConfirmation: Bool = false
    @State private var hasUnsavedChanges: Bool = false
    @FocusState private var isWeightFocused: Bool

    private var weightBasedCount: Int {
        drips.filter { $0.requiresWeight }.count
    }

    private var convertedWeightDisplay: String? {
        guard selectedUnit == .lbs,
              let value = Double(weightInput),
              value > 0 else { return nil }
        let kgValue = value / 2.20462
        return String(format: "%.1f kg", kgValue)
    }

    private var navyAccent: Color {
        colorScheme == .dark ? .white : Color(red: 0.11, green: 0.21, blue: 0.34)
    }
    private let successGreen = Color(red: 0.2, green: 0.7, blue: 0.4)

    private var subtitleText: String? {
        if showSavedConfirmation { return nil }
        if let converted = convertedWeightDisplay { return converted }
        if weightBasedCount > 0 { return "\(weightBasedCount) weight-based drips" }
        return nil
    }

    var body: some View {
        HStack(spacing: 10) {
            // Icon — small, no circle background
            Image(systemName: showSavedConfirmation ? "checkmark" : "scalemass")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(showSavedConfirmation ? successGreen : (colorScheme == .dark ? .white.opacity(0.5) : navyAccent.opacity(0.5)))
                .frame(width: 20)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showSavedConfirmation)

            // Label
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    Text("Weight")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : navyAccent.opacity(0.6))

                    if showSavedConfirmation {
                        Text("Saved")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(successGreen)
                            .transition(.opacity)
                    }
                }

                if let subtitle = subtitleText {
                    Text(subtitle)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                }
            }

            Spacer()

            // Inline weight input + unit toggle
            HStack(spacing: 3) {
                TextField("80", text: $weightInput)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : navyAccent)
                    .frame(width: 56)
                    .focused($isWeightFocused)
                    .onChange(of: weightInput) { _ in
                        hasUnsavedChanges = true
                    }

                Button(action: toggleUnit) {
                    Text(selectedUnit.abbreviation)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(colorScheme == .dark ? CriticalDesign.Colors.gold : navyAccent)
                        )
                }
            }
            .padding(.vertical, 6)
            .padding(.leading, 8)
            .padding(.trailing, 5)
            .background(
                Capsule()
                    .fill(colorScheme == .dark ? Color.white.opacity(0.06) : navyAccent.opacity(0.04))
            )
            .overlay(
                Capsule()
                    .stroke(
                        showSavedConfirmation ? successGreen.opacity(0.6) :
                            (hasUnsavedChanges ? Color.red.opacity(0.5) :
                                (colorScheme == .dark ? Color.white.opacity(0.1) : navyAccent.opacity(0.1))),
                        lineWidth: 1
                    )
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(CriticalDesign.Adaptive.canvas(for: colorScheme))
        // Keyboard toolbar
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                if isWeightFocused && hasUnsavedChanges {
                    Button(action: saveWeight) {
                        Text("Save")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(CriticalDesign.Colors.cardBlue))
                    }
                }

                Button(action: {
                    isWeightFocused = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Done")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(navyAccent)
                }
            }
        }
        .onChange(of: patientContext.weightKg) { newWeight in
            if let w = newWeight, !isWeightFocused {
                let displayValue = selectedUnit == .kg ? w : w * 2.20462
                let newWeightStr = String(format: "%.1f", displayValue)
                if weightInput != newWeightStr {
                    weightInput = newWeightStr
                    hasUnsavedChanges = false
                }
            }
        }
        .onChange(of: patientContext.weightUnit) { newUnit in
            selectedUnit = newUnit
        }
        .onAppear {
            selectedUnit = patientContext.weightUnit
            if let w = patientContext.weightKg {
                let displayValue = selectedUnit == .kg ? w : w * 2.20462
                weightInput = String(format: "%.1f", displayValue)
            } else {
                weightInput = selectedUnit == .kg ? "80" : "176"
            }
            hasUnsavedChanges = false
        }
    }

    // MARK: - Toggle Unit

    private func toggleUnit() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()

        // Convert current input to the other unit
        if let currentValue = Double(weightInput), currentValue > 0 {
            if selectedUnit == .kg {
                // Converting from kg to lbs
                selectedUnit = .lbs
                weightInput = String(format: "%.1f", currentValue * 2.20462)
            } else {
                // Converting from lbs to kg
                selectedUnit = .kg
                weightInput = String(format: "%.1f", currentValue / 2.20462)
            }
        } else {
            // Just toggle the unit
            selectedUnit = selectedUnit == .kg ? .lbs : .kg
        }

        // Update global preference
        patientContext.weightUnit = selectedUnit
        hasUnsavedChanges = true
    }

    // MARK: - Save Weight Action

    private func saveWeight() {
        // Save to GlobalPatientContext with proper unit conversion
        // The setWeight method will convert lbs to kg automatically
        patientContext.setWeight(from: weightInput, unit: selectedUnit)
        hasUnsavedChanges = false

        // Dismiss keyboard
        isWeightFocused = false

        // Haptic feedback
        let haptic = UINotificationFeedbackGenerator()
        haptic.notificationOccurred(.success)

        // Show confirmation animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            showSavedConfirmation = true
        }

        // Hide confirmation after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                showSavedConfirmation = false
            }
        }
    }
}

struct DripsTableView_Previews: PreviewProvider {
    static var previews: some View {
        DripsTableView()
    }
}
