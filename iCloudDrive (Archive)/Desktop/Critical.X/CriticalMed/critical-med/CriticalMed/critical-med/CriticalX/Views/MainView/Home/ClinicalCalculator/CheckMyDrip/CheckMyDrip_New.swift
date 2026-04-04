//
//  CheckMyDrip.swift
//  Critical Testing App
//
//  Created by Jadie Barringer III on 3/11/24.
//  Redesigned with Neumorphic Aesthetic & Enhanced Calculations
//

import SwiftUI

struct CheckMyDrip_New: View {

    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var isImageLoaded = false
    @State private var showPickerSheet = false
    @State private var showResult = false
    @State private var showDoseUnitPicker = false
    
    // Focus states for managing keyboard focus
    @FocusState private var focusedField: Field?
    
    var data: clinicalCalculatorData
    
    enum Field: Hashable {
        case weight, dose, bagVolume, flowRate
    }
    
    // Info sections for IconTabBar
    private var infoSections: [(title: String, icon: String, content: String)] {
        [
            ("When to Use", "clock.fill", clinicalCalculatorData.checkmyDripSegmentDetails.whatToKnow),
            ("Key Points", "lightbulb.fill", clinicalCalculatorData.checkmyDripSegmentDetails.pearls),
            ("Why Use It", "questionmark.circle.fill", clinicalCalculatorData.checkmyDripSegmentDetails.whyUse)
        ]
    }
    
    var body: some View {
        ZStack {
            // Adaptive background for dark mode
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    
                    // Header with back button and favorite
                    headerSection
                    
                    // Icon and Title
                    iconTitleSection
                    
                    // Branding card
                    brandingCard
                    
                    // Info sections
                    IconTabBar(sections: infoSections)
                        .padding(.horizontal, CriticalDesign.Spacing.md)
                    
                    // Dose Unit Selector
                    doseUnitSelector
                    
                    // Input sections
                    inputSection
                    
                    // Calculation picker
                    calculationPickerSection
                    
                    // Concentration display
                    if !viewModel.concentrationResult.isEmpty && viewModel.concentrationResult != "Waiting..." {
                        concentrationCard
                    }
                    
                    // Calculate button
                    calculateButton
                    
                    // Results
                    if showResult && !viewModel.isResultsViewHidden {
                        resultCard
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                    
                    // Quick reference card
                    quickReferenceCard
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, CriticalDesign.Spacing.md)
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            focusedField = nil
        }
        .dismissKeyboardOnScroll()
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isImageLoaded = true
            }
            // Pre-fill weight from global patient context
            if let w = GlobalPatientContext.shared.weightKg, viewModel.weight.isEmpty {
                viewModel.weight = String(format: "%.1f", w)
            }
        }
        .onChange(of: viewModel.weight) { newValue in
            // Sync weight to GlobalPatientContext when changed
            if !newValue.isEmpty {
                GlobalPatientContext.shared.setWeight(from: newValue, unit: .kg)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            // Reset button
            Button(action: {
                let haptic = UIImpactFeedbackGenerator(style: .light)
                haptic.impactOccurred()
                withAnimation {
                    viewModel.reset()
                    showResult = false
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Reset")
                        .font(.custom("Poppins-Medium", size: 14))
                }
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
                        .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.12), radius: 8, x: 4, y: 4)
                        .shadow(color: colorScheme == .dark ? Color.clear : Color.white, radius: 8, x: -4, y: -4)
                )
                .overlay(
                    Capsule()
                        .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
                )
            }
            
            Spacer()
            
            CriticalFavoriteButton(
                title: "Check My Drip",
                type: "Cal"
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.md)
    }
    
    // MARK: - Icon & Title Section
    private var iconTitleSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Icon
            GradientEdgeFadeImage(imageName: "icon-IV", size: 180)
                .scaleEffect(isImageLoaded ? 1 : 0.85)
                .opacity(isImageLoaded ? 1 : 0)
            
            // Title
            VStack(spacing: 8) {
                Text("Check My Drip")
                    .font(.custom("Poppins-Bold", size: 32))
                    .foregroundColor(colorScheme == .dark ? Color.white : CriticalDesign.Colors.cardBlue)

                Text("IV Infusion Calculator")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)
                    .tracking(0.5)
            }
        }
    }
    
    // MARK: - Branding Card
    private var brandingCard: some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.md) {
            Image("logo_bw")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Clinical Reference")
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text("This calculator should not be a substitute for clinical judgment. Always verify calculations.")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(enhancedCardBackground)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    // MARK: - Enhanced Card Background
    private var enhancedCardBackground: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
            .shadow(color: colorScheme == .dark ? Color.clear : Color.white, radius: 12, x: -6, y: -6)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
            )
    }
    
    // MARK: - Dose Unit Selector
    private var doseUnitSelector: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack {
                Image(systemName: "pills.fill")
                    .foregroundColor(CriticalDesign.Colors.accentOrange)

                Text("Dose Input Unit")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()

                Text("Select what you're entering")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            .padding(.horizontal, CriticalDesign.Spacing.md)
            
            // Unit pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    ForEach(DoseUnit.allCases) { unit in
                        doseUnitPill(unit)
                    }
                }
                .padding(.horizontal, CriticalDesign.Spacing.md)
            }
        }
    }
    
    private func doseUnitPill(_ unit: DoseUnit) -> some View {
        let isSelected = viewModel.selectedDoseUnit == unit
        
        return Button(action: {
            let haptic = UIImpactFeedbackGenerator(style: .light)
            haptic.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.selectedDoseUnit = unit
                viewModel.calculateConcentration()
                // Reset output if incompatible
                resetOutputIfNeeded()
            }
        }) {
            VStack(spacing: 4) {
                Text(unit.displayName)
                    .font(.custom("Poppins-Bold", size: 16))

                Text(unitDescription(unit))
                    .font(.custom("Poppins-Medium", size: 10))
                    .opacity(0.8)
            }
            .foregroundColor(isSelected ? .white : CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(unitColor(unit))
                            .shadow(color: unitColor(unit).opacity(0.5), radius: 10, x: 0, y: 5)
                    } else {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
                            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.12), radius: 8, x: 4, y: 4)
                            .shadow(color: colorScheme == .dark ? Color.clear : Color.white, radius: 8, x: -4, y: -4)
                    }
                }
            )
            .overlay(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.clear, lineWidth: 0)
                    } else {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
                    }
                }
            )
        }
    }
    
    private func unitDescription(_ unit: DoseUnit) -> String {
        switch unit {
        case .mg: return "milligrams"
        case .mcg: return "micrograms"
        case .g: return "grams"
        case .units: return "insulin/heparin"
        case .mEq: return "electrolytes"
        }
    }
    
    private func unitColor(_ unit: DoseUnit) -> Color {
        switch unit {
        case .mg: return CriticalDesign.Colors.accentBlue
        case .mcg: return CriticalDesign.Colors.accentPurple
        case .g: return CriticalDesign.Colors.accentGreen
        case .units: return CriticalDesign.Colors.accentOrange
        case .mEq: return CriticalDesign.Colors.accentTeal
        }
    }
    
    private func resetOutputIfNeeded() {
        // Reset to appropriate default based on dose unit
        let currentOption = viewModel.selectedOption
        
        switch viewModel.selectedDoseUnit {
        case .units:
            if !currentOption.contains("units") {
                viewModel.selectedOption = "units/kg/hr"
            }
        case .mEq:
            if !currentOption.contains("mEq") {
                viewModel.selectedOption = "mEq/kg/hr"
            }
        case .mg, .mcg, .g:
            if currentOption.contains("units") || currentOption.contains("mEq") {
                viewModel.selectedOption = "mcg/kg/min"
            }
        }
    }
    
    // MARK: - Input Section
    private var inputSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Weight Input (Optional)
            inputRow(
                title: "Weight",
                subtitle: "Required for weight-based calculations",
                value: $viewModel.weight,
                unit: "kg",
                placeholder: "70",
                accentColor: CriticalDesign.Colors.accentPurple,
                field: .weight,
                isOptional: true
            )
            
            // Dose Input - NOW WITH DYNAMIC UNIT
            inputRow(
                title: "Total Dose in Solution",
                subtitle: "Amount of drug in the IV bag",
                value: $viewModel.doseTextField,
                unit: viewModel.selectedDoseUnit.displayName,
                placeholder: doseInputPlaceholder,
                accentColor: CriticalDesign.Colors.accentOrange,
                field: .dose,
                onChange: { viewModel.calculateConcentration() }
            )
            
            // Bag Volume Input
            inputRow(
                title: "Bag Volume",
                subtitle: "Total volume of IV bag",
                value: $viewModel.bagTextField,
                unit: "mL",
                placeholder: "250",
                accentColor: CriticalDesign.Colors.accentGreen,
                field: .bagVolume,
                onChange: { viewModel.calculateConcentration() }
            )
            
            // Flow Rate Input
            inputRow(
                title: "Flow Rate",
                subtitle: "Infusion rate (from pump)",
                value: $viewModel.flowRateTextField,
                unit: "mL/hr",
                placeholder: "15",
                accentColor: CriticalDesign.Colors.accentBlue,
                field: .flowRate
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.md)
    }
    
    private var doseInputPlaceholder: String {
        switch viewModel.selectedDoseUnit {
        case .mg: return "400"
        case .mcg: return "200"
        case .g: return "2"
        case .units: return "25000"
        case .mEq: return "40"
        }
    }
    
    // MARK: - Input Row Component
    private func inputRow(
        title: String,
        subtitle: String,
        value: Binding<String>,
        unit: String,
        placeholder: String,
        accentColor: Color,
        field: Field,
        isOptional: Bool = false,
        onChange: (() -> Void)? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(width: 4, height: 50)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(title)
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                        if isOptional {
                            Text("(optional)")
                                .font(.custom("Poppins-Medium", size: 11))
                                .foregroundColor(CriticalDesign.Colors.accentOrange)
                        }
                    }

                    Text(subtitle)
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
                
                Spacer()
                
                // Input field
                HStack(spacing: 8) {
                    TextField(placeholder, text: value)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .foregroundColor(accentColor)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .focused($focusedField, equals: field)
                        .onChange(of: value.wrappedValue) { _ in
                            onChange?()
                        }
                    
                    Text(unit)
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(accentColor.opacity(0.7))
                        .frame(width: 50, alignment: .leading)
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
                    .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white, radius: 12, x: -6, y: -6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
    }

    // MARK: - Calculation Picker Section
    private var calculationPickerSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack {
                Image(systemName: "function")
                    .foregroundColor(CriticalDesign.Colors.accentTeal)

                Text("Output Unit")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            .padding(.horizontal, CriticalDesign.Spacing.md)

            Button(action: {
                showPickerSheet = true
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.selectedOption == "Select an option" ? "Choose calculation" : viewModel.selectedOption)
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(viewModel.selectedOption == "Select an option" ? CriticalDesign.Adaptive.textSecondary(for: colorScheme) : CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        
                        if viewModel.selectedOption.contains("kg") {
                            Text("Weight-based calculation")
                                .font(.custom("Poppins-Medium", size: 12))
                                .foregroundColor(CriticalDesign.Colors.accentPurple)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(CriticalDesign.Colors.accentTeal)
                }
                .padding(CriticalDesign.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
                        .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
                        .shadow(color: colorScheme == .dark ? Color.clear : Color.white, radius: 12, x: -6, y: -6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
                )
            }
            .padding(.horizontal, CriticalDesign.Spacing.md)
        }
        .sheet(isPresented: $showPickerSheet) {
            pickerSheetView
        }
    }
    
    // MARK: - Picker Sheet View
    private var pickerSheetView: some View {
        NavigationView {
            List {
                // Filter options based on dose unit
                let filteredOptions = getFilteredOptions()
                
                ForEach(filteredOptions, id: \.self) { option in
                    Button(action: {
                        viewModel.selectedOption = option
                        showPickerSheet = false
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(option)
                                    .font(.custom("Poppins-Medium", size: 18))
                                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                                
                                Text(optionDescription(option))
                                    .font(.custom("Poppins-Medium", size: 12))
                                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            }
                            
                            Spacer()
                            
                            if viewModel.selectedOption == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(CriticalDesign.Colors.accentGreen)
                            }
                            
                            if option.contains("kg") {
                                Image(systemName: "person.fill")
                                    .foregroundColor(CriticalDesign.Colors.accentPurple)
                                    .font(.system(size: 14))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Select Output Unit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showPickerSheet = false
                    }
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private func getFilteredOptions() -> [String] {
        switch viewModel.selectedDoseUnit {
        case .mg, .mcg, .g:
            return ["g/hr", "g/min", "mg/hr", "mg/min", "mcg/hr", "mcg/min",
                    "mg/kg/hr", "mg/kg/min", "mcg/kg/hr", "mcg/kg/min"]
        case .units:
            return ["units/hr", "units/kg/hr"]
        case .mEq:
            return ["mEq/hr", "mEq/kg/hr"]
        }
    }
    
    private func optionDescription(_ option: String) -> String {
        switch option {
        case "mcg/kg/min": return "Common for vasopressors (dopamine, etc.)"
        case "mcg/kg/hr": return "Micrograms per kg per hour"
        case "mcg/min": return "Non-weight-based mcg/min"
        case "mcg/hr": return "Micrograms per hour"
        case "mg/kg/min": return "Milligrams per kg per minute"
        case "mg/kg/hr": return "Common for sedatives"
        case "mg/min": return "Milligrams per minute"
        case "mg/hr": return "Milligrams per hour"
        case "g/min": return "Grams per minute"
        case "g/hr": return "Grams per hour (e.g., magnesium)"
        case "units/hr": return "Units per hour"
        case "units/kg/hr": return "Weight-based (heparin, insulin)"
        case "mEq/hr": return "Milliequivalents per hour"
        case "mEq/kg/hr": return "Weight-based electrolytes"
        default: return ""
        }
    }
    
    // MARK: - Concentration Card
    private var concentrationCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Concentration")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(viewModel.concentrationResult)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)

                    Text(viewModel.concentrationUnit)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }
            
            Spacer()
            
            Image(systemName: "drop.fill")
                .font(.system(size: 32))
                .foregroundColor(CriticalDesign.Colors.accentBlue.opacity(0.3))
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
                .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
                .shadow(color: colorScheme == .dark ? Color.clear : Color.white, radius: 12, x: -6, y: -6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal, CriticalDesign.Spacing.md)
    }

    // MARK: - Calculate Button
    private var calculateButton: some View {
        Button(action: {
            focusedField = nil
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            haptic.impactOccurred()
            
            viewModel.validation()
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showResult = true
            }
        }) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Text("Calculate")
                    .font(.custom("Poppins-Bold", size: 20))
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 22))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, CriticalDesign.Spacing.md)
        }
        .buttonStyle(CriticalPrimaryButtonStyle(color: CriticalDesign.Colors.buttonBlue))
        .padding(.horizontal, CriticalDesign.Spacing.md)
    }
    
    // MARK: - Result Card
    private var resultCard: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Result header
            HStack {
                Image(systemName: viewModel.isError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(viewModel.isError ? CriticalDesign.Colors.accentOrange : CriticalDesign.Colors.accentGreen)

                Text(viewModel.isError ? "Error" : "Infusion Rate")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()
            }

            Divider()
                .background(colorScheme == .dark ? Color.white.opacity(0.1) : CriticalDesign.Colors.secondary.opacity(0.3))

            // Result value
            VStack(spacing: 4) {
                Text(viewModel.result)
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(viewModel.isError ? CriticalDesign.Colors.accentOrange : CriticalDesign.Colors.accentGreen)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                if !viewModel.resultLabel.isEmpty {
                    Text(viewModel.resultLabel)
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundColor(colorScheme == .dark ? Color.white : CriticalDesign.Colors.cardBlue)
                }
            }
            .padding(.vertical, CriticalDesign.Spacing.sm)
            
            // Input summary
            if !viewModel.isError {
                inputSummarySection
                
                // AI Explain Button
                HStack {
                    Spacer()
                    ExplainButton.forCalculator(
                        name: "Drip Rate",
                        result: "\(viewModel.result) \(viewModel.resultLabel)",
                        inputs: "\(viewModel.doseTextField) \(viewModel.selectedDoseUnit.displayName) in \(viewModel.bagVolumeTextField)mL at \(viewModel.flowRateTextField) mL/hr"
                    )
                    Spacer()
                }
                .padding(.top, 8)
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
                .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.18), radius: 16, x: 8, y: 8)
                .shadow(color: colorScheme == .dark ? Color.clear : Color.white, radius: 16, x: -8, y: -8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal, CriticalDesign.Spacing.md)
    }

    // MARK: - Input Summary Section
    private var inputSummarySection: some View {
        VStack(spacing: CriticalDesign.Spacing.sm) {
            Divider()
                .background(colorScheme == .dark ? Color.white.opacity(0.1) : CriticalDesign.Colors.secondary.opacity(0.3))

            Text("Calculation Summary")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            // Formula display
            HStack(spacing: 4) {
                Text("(\(viewModel.doseTextField) \(viewModel.selectedDoseUnit.displayName)")
                    .font(.custom("Poppins-Medium", size: 12))
                Text("÷")
                Text("\(viewModel.bagTextField) mL)")
                    .font(.custom("Poppins-Medium", size: 12))
                Text("×")
                Text("\(viewModel.flowRateTextField) mL/hr")
                    .font(.custom("Poppins-Medium", size: 12))
            }
            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            
            HStack(spacing: CriticalDesign.Spacing.md) {
                if !viewModel.weight.isEmpty {
                    summaryPill(label: "Wt", value: viewModel.weight, unit: "kg", color: CriticalDesign.Colors.accentPurple)
                }
                summaryPill(label: "Dose", value: viewModel.doseTextField, unit: viewModel.selectedDoseUnit.displayName, color: CriticalDesign.Colors.accentOrange)
                summaryPill(label: "Vol", value: viewModel.bagTextField, unit: "mL", color: CriticalDesign.Colors.accentGreen)
                summaryPill(label: "Rate", value: viewModel.flowRateTextField, unit: "mL/hr", color: CriticalDesign.Colors.accentBlue)
            }
        }
    }
    
    // MARK: - Summary Pill
    private func summaryPill(label: String, value: String, unit: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.custom("Poppins-Medium", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            HStack(spacing: 2) {
                Text(value)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(color)

                Text(unit)
                    .font(.custom("Poppins-Medium", size: 9))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(color.opacity(colorScheme == .dark ? 0.15 : 0.1))
        )
    }
    
    // MARK: - Quick Reference Card
    private var quickReferenceCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(CriticalDesign.Colors.accentTeal)

                Text("Common Drip Ranges")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                referenceRow(drug: "Dopamine", range: "2-20 mcg/kg/min")
                referenceRow(drug: "Norepinephrine", range: "0.1-0.5 mcg/kg/min")
                referenceRow(drug: "Epinephrine", range: "0.01-0.5 mcg/kg/min")
                referenceRow(drug: "Vasopressin", range: "0.01-0.04 units/min")
                referenceRow(drug: "Heparin", range: "12-15 units/kg/hr")
                referenceRow(drug: "Potassium", range: "10-20 mEq/hr")
                referenceRow(drug: "Propofol", range: "25-75 mcg/kg/min")
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
                .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
                .shadow(color: colorScheme == .dark ? Color.clear : Color.white, radius: 12, x: -6, y: -6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal, CriticalDesign.Spacing.md)
    }

    private func referenceRow(drug: String, range: String) -> some View {
        HStack {
            Text(drug)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Spacer()

            Text(range)
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(CriticalDesign.Colors.accentBlue)
        }
    }
}

// MARK: - Preview
struct CheckMyDrip_New_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckMyDrip_New(data: clinicalCalculatorData.checkmyDripSegmentDetails)
        }
        .previewDisplayName("Check My Drip")
    }
}
