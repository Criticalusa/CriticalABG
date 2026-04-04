//
// MedsCalculatorsView.swift
// CriticalX
//
// Redesigned to match Clinical Moments UI
//

import SwiftUI

// MARK: - Calculator Category
enum CalculatorCategory: String, CaseIterable {
    case respiratory = "Respiratory"
    case fluidsElectrolytes = "Fluids & Electrolytes"
    case cardiovascular = "Cardiovascular"
    case renal = "Renal"
    case medications = "Medications"
    case burns = "Burns"
    case obstetrics = "Obstetrics"
    case misc = "Miscellaneous"
    case conversions = "Conversions"
    case clinicalScales = "Clinical Scales"

    var icon: String {
        switch self {
        case .respiratory: return "lungs.fill"
        case .fluidsElectrolytes: return "drop.fill"
        case .cardiovascular: return "heart.fill"
        case .renal: return "cross.vial.fill"
        case .medications: return "pills.fill"
        case .burns: return "flame.fill"
        case .obstetrics: return "figure.2.and.child.holdinghands"
        case .misc: return "square.grid.2x2.fill"
        case .conversions: return "arrow.left.arrow.right"
        case .clinicalScales: return "list.clipboard"
        }
    }

    var color: Color {
        switch self {
        case .respiratory: return .green
        case .fluidsElectrolytes: return .blue
        case .cardiovascular: return .red
        case .renal: return .orange
        case .medications: return .purple
        case .burns: return .orange
        case .obstetrics: return .pink
        case .misc: return .gray
        case .conversions: return .teal
        case .clinicalScales: return .indigo
        }
    }
}

// MARK: - Enhanced Calculator Data
struct CalculatorItem: Identifiable {
    let id = UUID()
    let index: Int
    let title: String
    let subtitle: String
    let imageName: String
    let category: CalculatorCategory
    let systemIcon: String?
    
    init(index: Int, title: String, subtitle: String, imageName: String, category: CalculatorCategory, systemIcon: String? = nil) {
        self.index = index
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.category = category
        self.systemIcon = systemIcon
    }
}

// MARK: - Calculator Data
extension CalculatorItem {
    static let allCalculators: [CalculatorItem] = [
        // Respiratory
        CalculatorItem(index: 0, title: "ABG Calculator", subtitle: "Analyze and interpret blood gases", imageName: "NanoBanana/calc/calc_abg_calculator", category: .respiratory, systemIcon: "syringe.fill"),
        CalculatorItem(index: 16, title: "P/F Ratio", subtitle: "Identify respiratory failure via PaO₂/FiO₂", imageName: "NanoBanana/calc/calc_p_f_ratio", category: .respiratory, systemIcon: "lungs.fill"),
        CalculatorItem(index: 18, title: "RSBI", subtitle: "Rapid shallow breathing index", imageName: "NanoBanana/calc/calc_rsbi_rapid_shallow_breathing_index", category: .respiratory, systemIcon: "waveform.path.ecg"),
        CalculatorItem(index: 23, title: "Ventilator Optimization", subtitle: "Optimize ventilator settings", imageName: "NanoBanana/calc/calc_ventilator_optimization", category: .respiratory, systemIcon: "lungs.fill"),
        CalculatorItem(index: 11, title: "LOX Calculator", subtitle: "Liquid oxygen calculator", imageName: "NanoBanana/calc/calc_lox_calculator", category: .respiratory, systemIcon: "drop.circle.fill"),
        CalculatorItem(index: 14, title: "O₂ Cylinder Calculator", subtitle: "Flow time remaining", imageName: "NanoBanana/calc/calc_o2_cylinder_calculator", category: .respiratory, systemIcon: "gauge.with.dots.needle.33percent"),

        // Fluids & Electrolytes
        CalculatorItem(index: 1, title: "Anion Gap", subtitle: "Calculate the anion gap", imageName: "NanoBanana/calc/calc_anion_gap", category: .fluidsElectrolytes, systemIcon: "function"),
        CalculatorItem(index: 2, title: "Bicarbonate Deficit", subtitle: "Calculate bicarbonate deficit", imageName: "NanoBanana/calc/calc_bicarbonate_deficit", category: .fluidsElectrolytes, systemIcon: "drop.triangle.fill"),
        CalculatorItem(index: 8, title: "Free Water Deficit", subtitle: "Calculate deficit of free water", imageName: "NanoBanana/calc/calc_free_water_deficit", category: .fluidsElectrolytes, systemIcon: "drop.fill"),
        CalculatorItem(index: 25, title: "Hypo/Hypernatremia", subtitle: "Normalize sodium levels", imageName: "NanoBanana/calc/calc_hypo_hypernatremia", category: .fluidsElectrolytes, systemIcon: "atom"),
        CalculatorItem(index: 24, title: "Winter's Formula", subtitle: "Expected CO₂ compensation", imageName: "NanoBanana/calc/calc_winters_formula", category: .fluidsElectrolytes, systemIcon: "thermometer.snowflake"),

        // Cardiovascular
        CalculatorItem(index: 13, title: "MAP | CPP", subtitle: "Mean arterial & cerebral perfusion pressure", imageName: "NanoBanana/calc/calc_map_cpp", category: .cardiovascular, systemIcon: "heart.text.square.fill"),
        CalculatorItem(index: 20, title: "Shock Index", subtitle: "Assess hemodynamic stability", imageName: "NanoBanana/calc/calc_shock_index", category: .cardiovascular, systemIcon: "waveform.path.ecg.rectangle.fill"),
        CalculatorItem(index: 4, title: "Check My Drip", subtitle: "Confirm IV flow rates", imageName: "NanoBanana/calc/calc_check_my_drip", category: .cardiovascular, systemIcon: "ivfluid.bag.fill"),
        CalculatorItem(index: 10, title: "IV Rate Calculator", subtitle: "Calculate IV flow rate", imageName: "NanoBanana/calc/calc_iv_rate_calculator", category: .cardiovascular, systemIcon: "drop.halffull"),
        CalculatorItem(index: 28, title: "SIRS Criteria", subtitle: "Systemic inflammatory response", imageName: "NanoBanana/calc/calc_sirs_criteria", category: .cardiovascular, systemIcon: "waveform.path.ecg"),
        CalculatorItem(index: 29, title: "qSOFA", subtitle: "Quick sepsis assessment", imageName: "NanoBanana/calc/calc_qsofa", category: .cardiovascular, systemIcon: "staroflife.fill"),

        // Renal
        CalculatorItem(index: 6, title: "CRRT Calculator", subtitle: "Calculate dose of dialysate", imageName: "NanoBanana/calc/calc_crrt_calculator", category: .renal, systemIcon: "arrow.triangle.2.circlepath.circle.fill"),
        CalculatorItem(index: 7, title: "FeNa", subtitle: "Fractional excretion of sodium", imageName: "NanoBanana/calc/calc_fena_fractional_excretion_of_sodium", category: .renal, systemIcon: "percent"),
        CalculatorItem(index: 22, title: "Urine Output", subtitle: "Calculate U/O in mL/kg/hr", imageName: "NanoBanana/calc/calc_urine_output", category: .renal, systemIcon: "drop.degreesign.fill"),
        CalculatorItem(index: 27, title: "BUN/Creat", subtitle: "BUN and creatinine ratio", imageName: "NanoBanana/calc/calc_bun_creatinine", category: .renal, systemIcon: "chart.bar.fill"),

        // Medications
        CalculatorItem(index: 19, title: "RSI", subtitle: "Rapid sequence intubation", imageName: "NanoBanana/calc/calc_rsi_rapid_sequence_intubation", category: .medications, systemIcon: "medical.thermometer.fill"),
        CalculatorItem(index: 21, title: "tPA Dose Calculator", subtitle: "Initial bolus and drip", imageName: "NanoBanana/calc/calc_tpa_dose_calculator", category: .medications, systemIcon: "syringe.fill"),

        // Burns
        CalculatorItem(index: 5, title: "Consensus Formula", subtitle: "Post-burn fluid replacement", imageName: "NanoBanana/calc/calc_consensus_formula_parkland_formula_burns", category: .burns, systemIcon: "flame.fill"),
        CalculatorItem(index: 15, title: "Parkland Formula", subtitle: "Burn fluid replacement", imageName: "NanoBanana/calc/calc_consensus_formula_parkland_formula_burns", category: .burns, systemIcon: "flame.circle.fill"),
        CalculatorItem(index: 26, title: "Allowable Blood Loss", subtitle: "Minimize surgical blood loss", imageName: "NanoBanana/calc/calc_allowable_blood_loss", category: .burns, systemIcon: "cross.vial.fill"),

        // Obstetrics
        CalculatorItem(index: 17, title: "Pregnancy Calculator", subtitle: "Expected due date", imageName: "NanoBanana/calc/calc_pregnancy_calculator", category: .obstetrics, systemIcon: "calendar"),
        CalculatorItem(index: 30, title: "APGAR Score", subtitle: "Neonatal assessment at birth", imageName: "NanoBanana/calc/calc_apgar_score", category: .obstetrics, systemIcon: "figure.2.and.child.holdinghands"),

        // Misc
        CalculatorItem(index: 3, title: "Body Mass Index", subtitle: "Calculate BMI and BSA", imageName: "NanoBanana/calc/calc_body_mass_index", category: .misc, systemIcon: "figure.stand"),
        CalculatorItem(index: 9, title: "Ideal Body Weight", subtitle: "Tidal volume & ideal weight", imageName: "NanoBanana/calc/calc_ideal_body_weight", category: .misc, systemIcon: "scalemass.fill"),
        CalculatorItem(index: 12, title: "Medical Spanish", subtitle: "Medical Spanish with audio", imageName: "NanoBanana/calc/calc_medical_spanish", category: .misc, systemIcon: "text.bubble.fill"),

        // Conversions
        CalculatorItem(index: 31, title: "Unit Converter", subtitle: "Medical unit conversions", imageName: "NanoBanana/calc/calc_unit_converter", category: .conversions, systemIcon: "arrow.left.arrow.right"),

        // Clinical Scales
        CalculatorItem(index: 32, title: "RASS Scale", subtitle: "Richmond Agitation-Sedation", imageName: "NanoBanana/scales/scales_rass_richmond_agitation_sedation_scale", category: .clinicalScales, systemIcon: "moon.zzz.fill"),
        CalculatorItem(index: 33, title: "CAM-ICU", subtitle: "Delirium Screening", imageName: "NanoBanana/scales/scales_cam_icu_delirium_screening", category: .clinicalScales, systemIcon: "brain.head.profile"),
        CalculatorItem(index: 34, title: "Braden Scale", subtitle: "Pressure Injury Risk", imageName: "NanoBanana/scales/scales_braden_scale_pressure_injury_risk", category: .clinicalScales, systemIcon: "hand.raised.fill"),
        CalculatorItem(index: 35, title: "Morse Fall Scale", subtitle: "Fall Risk Assessment", imageName: "NanoBanana/scales/scales_morse_fall_scale", category: .clinicalScales, systemIcon: "figure.fall"),
        CalculatorItem(index: 36, title: "Pain Scales", subtitle: "NRS, CPOT, Wong-Baker", imageName: "NanoBanana/scales/scales_pain_scales_nrs_cpot_wong_baker", category: .clinicalScales, systemIcon: "waveform.path.ecg"),
    ]
    
    static func calculators(for category: CalculatorCategory) -> [CalculatorItem] {
        allCalculators.filter { $0.category == category }
    }
}

// MARK: - Main View
struct MedsCalculatorsView: View {
    /// When true, hides the modal header (X button) since nav bar provides back button
    var isPushed: Bool = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var accessManager = ContentAccessManager.shared
    @State private var isAppearing = false
    @State private var selectedCalculatorIndex: Int?
    @State private var presentingModal = false
    @State private var showUpgradePrompt = false
    @State private var searchText = ""
    
    private var filteredCalculators: [CalculatorItem] {
        if searchText.isEmpty {
            return CalculatorItem.allCalculators
        }
        return CalculatorItem.allCalculators.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var groupedCalculators: [(CalculatorCategory, [CalculatorItem])] {
        if !searchText.isEmpty {
            // When searching, show flat list grouped by category
            let grouped = Dictionary(grouping: filteredCalculators, by: { $0.category })
            return CalculatorCategory.allCases.compactMap { category in
                if let items = grouped[category], !items.isEmpty {
                    return (category, items)
                }
                return nil
            }
        }
        return CalculatorCategory.allCases.compactMap { category in
            let items = CalculatorItem.calculators(for: category)
            return items.isEmpty ? nil : (category, items)
        }
    }
    
    var body: some View {
        ZStack {
            // Background - adaptive
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Modal Header with Title and Close Button (hidden when pushed via NavigationLink)
                if !isPushed {
                    modalHeader
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                }
                
                // Search Bar
                searchBar
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                
                // Calculator List organized by sections
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        ForEach(Array(groupedCalculators.enumerated()), id: \.element.0) { sectionIndex, group in
                            calculatorSection(category: group.0, calculators: group.1, sectionIndex: sectionIndex)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                isAppearing = true
            }
        }
        .sheet(isPresented: $presentingModal) {
            if let index = selectedCalculatorIndex {
                CalculatorDetailView(index: index)
            }
        }
        .sheet(isPresented: $showUpgradePrompt) {
            UpgradePromptView()
        }
    }
    
    // MARK: - Modal Header
    private var modalHeader: some View {
        HStack {
            Spacer()
            
            Text("Clinical Calculators")
                .font(.custom("Poppins-Bold", size: 20))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Close Button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                    )
            }
        }
        .padding(.horizontal, 24)
        .opacity(isAppearing ? 1 : 0)
        .animation(.easeOut(duration: 0.3), value: isAppearing)
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
            
            TextField("Search calculators...", text: $searchText)
                .font(.custom("Poppins-Regular", size: 15))
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            CriticalDesign.Colors.accentTeal.opacity(colorScheme == .dark ? 0.4 : 0.2),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        )
        .opacity(isAppearing ? 1 : 0)
        .animation(.easeOut(duration: 0.3).delay(0.1), value: isAppearing)
    }
    
    // MARK: - Calculator Section
    private func calculatorSection(category: CalculatorCategory, calculators: [CalculatorItem], sectionIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section Header
            HStack(spacing: 10) {
                // Category Icon
                ZStack {
                    Circle()
                        .fill(category.color.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(category.color)
                }
                
                Text(category.rawValue.uppercased())
                    .font(.custom("Poppins-Bold", size: 12))
                    .foregroundColor(.secondary)
                    .tracking(1)
                
                Spacer()
                
                // Count Badge
                Text("\(calculators.count)")
                    .font(.custom("Poppins-Bold", size: 11))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(category.color)
                    )
            }
            .padding(.horizontal, 4)
            .opacity(isAppearing ? 1 : 0)
            .animation(.easeOut(duration: 0.3).delay(Double(sectionIndex) * 0.05 + 0.15), value: isAppearing)
            
            // Calculator Cards
            VStack(spacing: 10) {
                ForEach(Array(calculators.enumerated()), id: \.element.id) { itemIndex, calculator in
                    let isAccessible = accessManager.canAccessCalculator(calculator.title.slugified)
                    
                    CalculatorRowButton(
                        calculator: calculator,
                        color: category.color,
                        isAppearing: isAppearing,
                        delay: Double(sectionIndex) * 0.04 + Double(itemIndex) * 0.02 + 0.2,
                        isLocked: !isAccessible
                    ) {
                        if isAccessible {
                            selectedCalculatorIndex = calculator.index
                            presentingModal = true
                        } else {
                            showUpgradePrompt = true
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Calculator Row Button
struct CalculatorRowButton: View {
    @Environment(\.colorScheme) var colorScheme
    let calculator: CalculatorItem
    let color: Color
    let isAppearing: Bool
    let delay: Double
    var isLocked: Bool = false
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 16) {
                if calculator.imageName.isEmpty, let systemIcon = calculator.systemIcon {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: systemIcon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(color)
                    }
                    .opacity(isLocked ? 0.5 : 1.0)
                } else {
                    Image(calculator.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .opacity(isLocked ? 0.5 : 1.0)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(calculator.title)
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(.primary)
                        
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 10))
                                .foregroundColor(CriticalDesign.Colors.gold)
                        }
                    }

                    Text(calculator.subtitle)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                if isLocked {
                    // Premium badge
                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10))
                        Text("PRO")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(CriticalDesign.Colors.gold)
                    )
                } else {
                    ZStack {
                        Circle()
                            .fill(color.opacity(colorScheme == .dark ? 0.15 : 0.1))
                            .frame(width: 32, height: 32)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(color)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : .white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                color.opacity(colorScheme == .dark ? 0.6 : 0.3),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 8)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.98 : 1)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 12)
        .animation(.easeOut(duration: 0.35).delay(delay), value: isAppearing)
    }
}

// MARK: - Calculator Detail View (Wrapper)
struct CalculatorDetailView: View {
    let index: Int
    @State private var showingDetail: Bool = true

    var body: some View {
        NavigationView {
            calculatorView
                .navigationBarTitleDisplayMode(.inline)
                // No onAppear tracking here — individual calculators track
                // their own results with detail via trackCalculation()
                // after the user presses Calculate
        }
    }
    
    @ViewBuilder
    private var calculatorView: some View {
        switch index {
        case 0:
            ABGCalculatorStandalone()
        case 1:
            AnionGapview(data: clinicalCalculatorData.AnionGapSegmentDetails)
        case 2:
            BicarbonateView(data: clinicalCalculatorData.BicarbDeficitSegmentDetails)
        case 3:
            BMIView()
        case 4:
            CheckMyDrip_New(data: clinicalCalculatorData.checkmyDripSegmentDetails)
        case 5:
            ConsensusView()
        case 6:
            CRRTDosingView()
        case 7:
            FenaView()
        case 8:
            FreeWaterDeficitView()
        case 9:
            IdealBodyWeightView()
        case 10:
            IVDripRateView()
        case 11:
            LoxcalculatorView()
        case 12:
            MedSpanishView()
        case 13:
            MAP_ICPView()
        case 14:
            TwoTankCalculatorView()
        case 15:
            ParkLandFormulaView()
        case 16:
            PFRatioView()
        case 17:
            PregnencyCalculatorView()
        case 18:
            RSBIView(data: clinicalCalculatorData.RSBISegmentDetails)
        case 19:
            RSIIMainView()
        case 20:
            ShockIndexView()
        case 21:
            TPADosingView(data: clinicalCalculatorData.tPADoseSegmentDetails)
        case 22:
            UrineOutputView(data: clinicalCalculatorData.UrineOutputSegmentDetails)
        case 23:
            VentilatorOptimizationView()
        case 24:
            WinterFormulaView(data: clinicalCalculatorData.WintersSegmentDetails)
        case 25:
            HypoHypernatremiaCorrectionView(data: clinicalCalculatorData.hyponatremiaDetails)
        case 26:
            AllowableBloodLossView(data: clinicalCalculatorData.estimatedAllowableBloodLossDetails)
        case 27:
            BUNCreat_View(data: clinicalCalculatorData.BUNCreat)
        case 28:
            SIRSView()
        case 29:
            qSOFAView()
        case 30:
            APGARView()
        case 31:
            ConversionCalculatorHubView()
        case 32:
            RASSScaleView()
        case 33:
            CAMICUView()
        case 34:
            BradenScaleView()
        case 35:
            MorseFallScaleView()
        case 36:
            PainScalesView()
        default:
            BicarbonateView(data: clinicalCalculatorData.BicarbDeficitSegmentDetails)
        }
    }
}

// MARK: - Preview
struct MedsCalculatorsView_Previews: PreviewProvider {
    static var previews: some View {
        MedsCalculatorsView()
    }
}

// MARK: - Legacy Support (keep for backward compatibility)
struct MedsCountView: View {
    @Binding var count: Int
    @State private var showingDetail: Bool = true
    
    var body: some View {
        CalculatorDetailView(index: count)
    }
}

struct MedCountView: View {
    var count: Int
    @State private var showingDetail: Bool = true
    
    var body: some View {
        CalculatorDetailView(index: count)
    }
}
