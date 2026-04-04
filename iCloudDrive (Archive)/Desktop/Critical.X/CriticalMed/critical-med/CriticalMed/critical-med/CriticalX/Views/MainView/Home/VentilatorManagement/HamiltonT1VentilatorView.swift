//
//  HamiltonT1VentilatorView.swift
//  CriticalX
//
//  Hamilton T1 Ventilator - Complete Guide
//  Comprehensive reference for EMS, Flight Medicine, and Critical Care
//

import SwiftUI

// MARK: - Data Models

struct HamiltonMode: Identifiable {
    var id: String { abbreviation } // Use stable ID based on abbreviation
    let name: String
    let abbreviation: String
    let conventionalEquivalent: String
    let category: HamiltonModeCategory
    let tagline: String
    let description: String
    let safetyFeatures: String?
    let keyParameters: [String]
    let clinicalPearl: String?
}

enum HamiltonModeCategory: String, CaseIterable {
    case volumeTargeted = "Volume-Targeted"
    case volumeControlled = "Volume-Controlled"
    case pressureControlled = "Pressure-Controlled"
    case spontaneous = "Spontaneous Breathing"
    case intelligent = "Adaptive Support"
    case noninvasive = "Non-Invasive"
    
    var icon: String {
        switch self {
        case .volumeTargeted: return "arrow.up.arrow.down.circle.fill"
        case .volumeControlled: return "waveform.path"
        case .pressureControlled: return "gauge.with.dots.needle.bottom.50percent"
        case .spontaneous: return "lungs.fill"
        case .intelligent: return "brain.head.profile"
        case .noninvasive: return "face.dashed"
        }
    }
    
    var color: Color {
        switch self {
        case .volumeTargeted: return CriticalDesign.Colors.accentBlue
        case .volumeControlled: return CriticalDesign.Colors.accentGreen
        case .pressureControlled: return CriticalDesign.Colors.accentOrange
        case .spontaneous: return CriticalDesign.Colors.accentTeal
        case .intelligent: return Color(red: 0.0, green: 0.55, blue: 0.65) // Deep teal for AI/intelligent modes
        case .noninvasive: return Color(red: 0.45, green: 0.55, blue: 0.70) // Soft steel blue
        }
    }
}

enum HamiltonSection: String, CaseIterable {
    case philosophy = "Philosophy"
    case modes = "Modes"
    case diseaseStrategies = "Disease Strategies"
    case transportSpecs = "T1 Specs"
    case alarms = "Alarms"
    case quickRef = "Quick Reference"
}

// MARK: - Main View

struct HamiltonT1VentilatorView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedSection: HamiltonSection = .philosophy
    @State private var expandedModes: Set<String> = []
    @State private var selectedModeCategory: HamiltonModeCategory? = nil

    
    var body: some View {
        ZStack {
            // Premium Light Background
            HamiltonBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    headerSection
                    sectionPicker
                    
                    switch selectedSection {
                    case .philosophy:
                        philosophySection
                    case .modes:
                        modesSection
                    case .diseaseStrategies:
                        diseaseStrategiesSection
                    case .transportSpecs:
                        transportSpecsSection
                    case .alarms:
                        alarmsSection
                    case .quickRef:
                        quickReferenceSection
                    }
                    
                    Spacer(minLength: CriticalDesign.Spacing.xl)
                }
                .padding(.vertical, CriticalDesign.Spacing.lg)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CriticalFavoriteButton(title: "Hamilton T1", type: "Ventilator")
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            
            // Icon
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.accentTeal.opacity(0.15))
                    .frame(width: 140, height: 140)
                    .blur(radius: 25)
                
                ZStack {
                    if colorScheme == .dark {
                        Circle()
                            .fill(CriticalDesign.Colors.cardBlue)
                            .frame(width: 100, height: 100)
                        Circle()
                            .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1.5)
                            .frame(width: 100, height: 100)
                    } else {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 100, height: 100)
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 100, height: 100)
                        Circle()
                            .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
                            .frame(width: 100, height: 100)
                    }

                    Image(systemName: "lungs.fill")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [CriticalDesign.Colors.accentTeal, CriticalDesign.Colors.accentBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 4) {
                Text("Hamilton T1")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text("Complete Ventilator Guide")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
        }
    }
    
    // MARK: - Section Picker
    
    private var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                ForEach(HamiltonSection.allCases, id: \.self) { section in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedSection = section
                        }
                    }) {
                        Text(section.rawValue)
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(selectedSection == section ? .white : CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(selectedSection == section ? CriticalDesign.Colors.cardBlue : (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.6) : Color.white.opacity(0.8)))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(selectedSection == section ? Color.clear : (colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.2)), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, CriticalDesign.Spacing.lg)
        }
    }
    
    // MARK: - Philosophy Section
    
    private var philosophySection: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            // Key Concept Card
            HamiltonGlassCard(
                title: "The Key Concept",
                icon: "lightbulb.fill",
                accentColor: CriticalDesign.Colors.goldMid
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Hamilton is a pressure-driven ventilator.")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Text(HamiltonFormatter.format(
                        """
                        Unlike older models, no matter what mode of ventilation you're in, you are technically delivering a pressure breath.
                        
                        Why This Matters:
                        • Flow delivery is more physiologic—high flow at breath initiation, tapering as lungs fill
                        • There is NO true volume mode—only pressure-targeted or pressure-regulated volume-targeted modes
                        • If you're familiar with PRVC (Pressure-Regulated Volume Control), you already understand how Hamilton's adaptive modes work
                        """,
                        headings: ["Why This Matters:"]
                    ))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Terminology Translator
            HamiltonGlassCard(
                title: "Terminology Translator",
                icon: "arrow.left.arrow.right",
                accentColor: CriticalDesign.Colors.accentBlue
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hamilton uses proprietary names that differ from conventional terminology:")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .padding(.bottom, 8)
                    
                    ForEach(terminologyData, id: \.hamilton) { term in
                        HStack {
                            Text(term.hamilton)
                                .font(.custom("Poppins-SemiBold", size: 13))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                                .frame(width: 120, alignment: .leading)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 10))
                                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                            
                            Text(term.conventional)
                                .font(.custom("Poppins-Regular", size: 13))
                                .foregroundColor(CriticalDesign.Colors.accentBlue)
                            
                            Spacer()
                        }
                        .padding(.vertical, 6)
                        
                        if term.hamilton != terminologyData.last?.hamilton {
                            Divider()
                        }
                    }
                }
            }
            
            // Clinical Takeaway
            signatureCard(text: "Think of Hamilton as \"PRVC by default.\" The ventilator automatically adjusts pressure to deliver your target volume. You get the precision of volume control with the lung-protective flow pattern of pressure control.")
        }
    }
    
    // MARK: - Modes Section
    
    private var modesSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    categoryChip(title: "All", isSelected: selectedModeCategory == nil) {
                        selectedModeCategory = nil
                    }
                    
                    ForEach(HamiltonModeCategory.allCases, id: \.self) { category in
                        categoryChip(
                            title: category.rawValue,
                            color: category.color,
                            isSelected: selectedModeCategory == category
                        ) {
                            selectedModeCategory = category
                        }
                    }
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
            }
            
            // Mode Cards
            let filteredModes = selectedModeCategory == nil ? hamiltonModes : hamiltonModes.filter { $0.category == selectedModeCategory }
            
            ForEach(HamiltonModeCategory.allCases, id: \.self) { category in
                let categoryModes = filteredModes.filter { $0.category == category }
                
                if !categoryModes.isEmpty {
                    VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                        // Category Header
                        HStack(spacing: CriticalDesign.Spacing.sm) {
                            Image(systemName: category.icon)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(category.color)
                            
                            Text(category.rawValue)
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        }
                        .padding(.horizontal, CriticalDesign.Spacing.lg)
                        .padding(.top, CriticalDesign.Spacing.sm)
                        
                        ForEach(categoryModes) { mode in
                            modeCard(mode: mode)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Disease Strategies Section
    
    private var diseaseStrategiesSection: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            // ARDS
            HamiltonGlassCard(
                title: "ARDS",
                icon: "waveform.path.ecg",
                accentColor: CriticalDesign.Colors.accentRed
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    diseaseRow(param: "Tidal Volume", value: "4-6 mL/kg IBW")
                    diseaseRow(param: "PEEP", value: "Adequate—approximately weight ÷ 10")
                    diseaseRow(param: "Peak Pressure", value: "< 30 cmH₂O")
                    diseaseRow(param: "Strategy", value: "Lung-protective ventilation")
                }
            }
            
            // Asthma
            HamiltonGlassCard(
                title: "Asthma (Acute Bronchospasm)",
                icon: "wind",
                accentColor: CriticalDesign.Colors.accentOrange
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    diseaseRow(param: "Minute Ventilation", value: "Minimize")
                    diseaseRow(param: "Respiratory Rate", value: "Reduced")
                    diseaseRow(param: "I:E Ratio", value: "Extended expiration (approaching 1:5)")
                    diseaseRow(param: "CO₂", value: "Permissive hypercapnia acceptable")
                    
                    Text("Pressure alarms may need adjustment during acute phase")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(CriticalDesign.Colors.accentOrange)
                        .italic()
                        .padding(.top, 4)
                }
            }
            
            // COPD
            HamiltonGlassCard(
                title: "COPD",
                icon: "bubble.left.and.bubble.right.fill",
                accentColor: CriticalDesign.Colors.accentTeal
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    diseaseRow(param: "Tidal Volume", value: "6-8 mL/kg IBW")
                    diseaseRow(param: "PEEP", value: "5-10 cmH₂O (normal)")
                    diseaseRow(param: "Expiratory Time", value: "Longer (prevent air trapping)")
                    diseaseRow(param: "Peak Pressure", value: "< 30 cmH₂O")
                }
            }
            
            // Standard Initial Settings
            HamiltonGlassCard(
                title: "Standard Initial Settings",
                icon: "slider.horizontal.3",
                accentColor: CriticalDesign.Colors.accentBlue
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    diseaseRow(param: "Tidal Volume", value: "6-8 mL/kg IBW")
                    diseaseRow(param: "PEEP", value: "5 cmH₂O")
                    diseaseRow(param: "I:E Ratio", value: "1:2")
                    
                    Text("Individualize based on clinical presentation")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .italic()
                        .padding(.top, 4)
                }
            }
            
            signatureCard(text: "Start with lung-protective settings, then adjust based on your patient's response. Watch the waveforms—they tell the story.")
        }
    }
    
    // MARK: - Transport Specs Section
    
    private var transportSpecsSection: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            // Device Specs
            HamiltonGlassCard(
                title: "Device Specifications",
                icon: "cpu",
                accentColor: CriticalDesign.Colors.cardBlue
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    specRow(param: "Weight", value: "7 kg")
                    specRow(param: "Tidal Volume Range", value: "2-2000 mL")
                    specRow(param: "Patient Range", value: "Neonates to bariatric adults")
                    specRow(param: "Battery Life", value: "Up to 9 hours")
                    specRow(param: "PEEP Range", value: "0-35 cmH₂O")
                    specRow(param: "Peak Inspiratory Flow", value: "Up to 260 L/min")
                    specRow(param: "FiO₂ Range", value: "21-100%")
                }
            }
            
            // Independence
            HamiltonGlassCard(
                title: "No Compressed Air Needed",
                icon: "bolt.fill",
                accentColor: CriticalDesign.Colors.accentGreen
            ) {
                Text(HamiltonFormatter.format(
                    """
                    The integrated high-performance turbine enables complete independence from compressed air:
                    
                    Benefits:
                    • No gas cylinders needed
                    • No compressor required
                    • Reduces weight and saves space
                    • Enables NIV transport over greater distances
                    
                    The system tab displays current oxygen consumption in L/min—useful for long transfers and high FiO₂ patients.
                    """,
                    headings: ["Benefits:"]
                ))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
            }
            
            // Certifications
            HamiltonGlassCard(
                title: "Certifications",
                icon: "checkmark.seal.fill",
                accentColor: CriticalDesign.Colors.accentBlue
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    certRow(standard: "EN 794-3", desc: "Emergency and transport ventilators")
                    certRow(standard: "ISO 10651-3", desc: "Transport ventilator standard")
                    certRow(standard: "EN 1789", desc: "Ambulances")
                    certRow(standard: "EN 13718-1", desc: "Medical transport")
                    certRow(standard: "RTCA/DO-160G", desc: "Aircraft equipment")
                    
                    Text("Approved for ground, maritime, and aircraft environments")
                        .font(.custom("Poppins-SemiBold", size: 12))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                        .padding(.top, 8)
                }
            }
        }
    }
    
    // MARK: - Alarms Section
    
    private var alarmsSection: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            // High Priority
            HamiltonGlassCard(
                title: "High Priority",
                icon: "exclamationmark.triangle.fill",
                accentColor: CriticalDesign.Colors.accentRed
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Circle().fill(Color.red).frame(width: 12, height: 12)
                        Text("Red Light • 5 Repeating Beeps")
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .foregroundColor(CriticalDesign.Colors.accentRed)
                    }
                    .padding(.bottom, 8)
                    
                    alarmRow("Apnea")
                    alarmRow("Circuit disconnection")
                    alarmRow("Oxygen supply failure")
                    alarmRow("Critical device malfunction")
                }
            }
            
            // Medium Priority
            HamiltonGlassCard(
                title: "Medium Priority",
                icon: "exclamationmark.circle.fill",
                accentColor: CriticalDesign.Colors.accentOrange
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Circle().fill(Color.yellow).frame(width: 12, height: 12)
                        Text("Yellow Light • 3 Beeps")
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .foregroundColor(CriticalDesign.Colors.accentOrange)
                    }
                    .padding(.bottom, 8)
                    
                    alarmRow("High pressure alarm")
                    alarmRow("Low pressure alarm")
                    alarmRow("Volume delivery issues")
                    alarmRow("Rate abnormalities")
                }
            }
            
            // Low Priority
            HamiltonGlassCard(
                title: "Low Priority",
                icon: "info.circle.fill",
                accentColor: CriticalDesign.Colors.accentBlue
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Circle().fill(Color.blue).frame(width: 12, height: 12)
                        Text("2 Beeps")
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .foregroundColor(CriticalDesign.Colors.accentBlue)
                    }
                    .padding(.bottom, 8)
                    
                    alarmRow("External power disconnection")
                    alarmRow("Advisory messages")
                }
            }
        }
    }
    
    // MARK: - Quick Reference Section
    
    private var quickReferenceSection: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            // Mode Selection Guide
            HamiltonGlassCard(
                title: "Mode Selection Guide",
                icon: "list.bullet.rectangle",
                accentColor: CriticalDesign.Colors.accentBlue
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    modeGuideRow(scenario: "Full ventilatory support", modes: "APVcmv, (S)CMV, PCV+")
                    modeGuideRow(scenario: "Weaning from ventilator", modes: "APVsimv, VS, SPONT")
                    modeGuideRow(scenario: "ARDS with spontaneous effort", modes: "APRV, DuoPAP")
                    modeGuideRow(scenario: "NIV for respiratory failure", modes: "NIV, NIV-ST")
                    modeGuideRow(scenario: "High flow oxygen therapy", modes: "HiFlowO₂")
                    modeGuideRow(scenario: "\"Hands-off\" closed-loop", modes: "ASV, INTELLiVENT-ASV")
                    modeGuideRow(scenario: "Transport with variable conditions", modes: "ASV, APVcmv")
                }
            }
            
            // BiPAP Tip
            warningCard(
                title: "BiPAP Settings Tip",
                content: "When creating BiPAP settings, your Pinsp is ADDITIVE to your PEEP.\n\nExample: If you want IPAP of 15 and PEEP of 5:\n• Set PEEP = 5\n• Set ΔPinsp = 10 (because 5 + 10 = 15)"
            )
            
            // APRV Settings Table
            HamiltonGlassCard(
                title: "APRV Initial Settings by Weight",
                icon: "scalemass.fill",
                accentColor: CriticalDesign.Colors.accentTeal
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Initial P high/P low: 20/5 cmH₂O for all weights")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .padding(.bottom, 8)
                    
                    aprvRow(weight: "0.2-3 kg", thigh: "1.4s", tlow: "0.2s")
                    aprvRow(weight: "3-6 kg", thigh: "1.7s", tlow: "0.3s")
                    aprvRow(weight: "6-9 kg", thigh: "2.1s", tlow: "0.3s")
                    aprvRow(weight: "9-21 kg", thigh: "2.6s", tlow: "0.4s")
                    aprvRow(weight: "21-39 kg", thigh: "3.5s", tlow: "0.5s")
                    aprvRow(weight: "40-59 kg", thigh: "4.4s", tlow: "0.6s")
                    aprvRow(weight: "≥60 kg", thigh: "5.4s", tlow: "0.6s")
                }
            }
            
            signatureCard(text: "ASV works as a first-line mode for most intubated patients. It reduces cognitive load during stressful transport situations and adapts automatically to changing patient conditions.")
        }
    }
    
    // MARK: - Helper Views
    
    private func categoryChip(title: String, color: Color = CriticalDesign.Colors.accentBlue, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: { withAnimation { action() } }) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 11))
                .foregroundColor(isSelected ? .white : CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(isSelected ? color : (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.6) : Color.white.opacity(0.8))))
                .overlay(Capsule().stroke(isSelected ? Color.clear : (colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.2)), lineWidth: 1))
        }
    }
    
    private func modeCard(mode: HamiltonMode) -> some View {
        let isExpanded = expandedModes.contains(mode.id)
        
        return VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    if isExpanded {
                        expandedModes.remove(mode.id)
                    } else {
                        expandedModes.insert(mode.id)
                    }
                }
            }) {
                HStack(spacing: CriticalDesign.Spacing.md) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(mode.category.color)
                        .frame(width: 4, height: 50)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(mode.name)
                                .font(.custom("Poppins-Bold", size: 15))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            
                            Text(mode.conventionalEquivalent)
                                .font(.custom("Poppins-Medium", size: 10))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(mode.category.color))
                        }
                        
                        Text(mode.tagline)
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            .lineLimit(isExpanded ? nil : 2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
                .padding(CriticalDesign.Spacing.lg)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                    Divider().padding(.horizontal, CriticalDesign.Spacing.lg)
                    
                    // Description
                    Text(HamiltonFormatter.format(mode.description, headings: [
                        "Full Name:",
                        "How It Works:",
                        "Safety Features:",
                        "The Mental Model:",
                        "Why Use It:",
                        "Key Feature:",
                        "Breath Cycle:",
                        "Breath Cycle Structure:",
                        "The Philosophy:",
                        "Timing Structure:",
                        "Key Concept:",
                        "When No Spontaneous Breathing:",
                        "Important Note:",
                        "Weight-Based Initial Settings:",
                        "The Concept:",
                        "Seamless Transitions:",
                        "Automatic Protection:",
                        "The Target:",
                        "The Evolution:",
                        "Automatic Control Of:",
                        "Quick Wean Feature:",
                        "Evidence:",
                        "Regional Availability:",
                        "Clinical Considerations:",
                        "Key Features:",
                        "Settings:",
                        "Clinical Applications:",
                        "Important BiPAP Translation:",
                        "Example:",
                        "Mechanisms of Benefit:",
                        "Requirements:",
                        "Delivery Options:",
                        "For Mandatory Breaths:",
                        "For Spontaneous Breaths:",
                        "Mode Behavior Based on Settings:",
                        "Pressure Support:",
                        "The Smart Adjustment:",
                        "Key Settings:",
                        "Key Point:",
                        "Important:",
                        "Options:"
                    ]))
                        .lineSpacing(6)
                        .padding(.horizontal, CriticalDesign.Spacing.lg)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Safety Features
                    if let safety = mode.safetyFeatures {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "shield.checkered")
                                .foregroundColor(CriticalDesign.Colors.accentGreen)
                            Text(safety)
                                .font(.custom("Poppins-Regular", size: 13))
                                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 12).fill(CriticalDesign.Colors.accentGreen.opacity(0.08)))
                        .padding(.horizontal, CriticalDesign.Spacing.lg)
                    }
                    
                    // Key Parameters
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Key Parameters")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        
                        FlowLayout(spacing: 8) {
                            ForEach(mode.keyParameters, id: \.self) { param in
                                Text(param)
                                    .font(.custom("Poppins-Medium", size: 11))
                                    .foregroundColor(mode.category.color)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(mode.category.color.opacity(0.12)))
                            }
                        }
                    }
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                    
                    // Clinical Pearl
                    if let pearl = mode.clinicalPearl {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(CriticalDesign.Colors.goldMid)
                            Text(pearl)
                                .font(.custom("Poppins-Regular", size: 13))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                                .italic()
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 12).fill(CriticalDesign.Colors.goldMid.opacity(0.08)))
                        .padding(.horizontal, CriticalDesign.Spacing.lg)
                    }
                }
                .padding(.bottom, CriticalDesign.Spacing.lg)
            }
        }
        .background(hamiltonCardBackground)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    private func diseaseRow(param: String, value: String) -> some View {
        HStack {
            Text(param)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            Spacer()
            Text(value)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .multilineTextAlignment(.trailing)
        }
    }
    
    private func specRow(param: String, value: String) -> some View {
        HStack {
            Text(param)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            Spacer()
            Text(value)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
    }
    
    private func certRow(standard: String, desc: String) -> some View {
        HStack(alignment: .top) {
            Text(standard)
                .font(.custom("Poppins-SemiBold", size: 12))
                .foregroundColor(CriticalDesign.Colors.accentBlue)
                .frame(width: 100, alignment: .leading)
            Text(desc)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            Spacer()
        }
    }
    
    private func alarmRow(_ text: String) -> some View {
        HStack(spacing: 8) {
            Text("•")
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            CriticalDesign.autoBoldText(text, fontSize: 13)
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
    }
    
    private func modeGuideRow(scenario: String, modes: String) -> some View {
        HStack(alignment: .top) {
            Text(scenario)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(modes)
                .font(.custom("Poppins-SemiBold", size: 12))
                .foregroundColor(CriticalDesign.Colors.accentBlue)
                .multilineTextAlignment(.trailing)
        }
    }
    
    private func aprvRow(weight: String, thigh: String, tlow: String) -> some View {
        HStack {
            Text(weight)
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .frame(width: 80, alignment: .leading)
            Spacer()
            Text("T high: \(thigh)")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            Spacer()
            Text("T low: \(tlow)")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
    }
    
    private func signatureCard(text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(CriticalDesign.Colors.goldMid)
                Text("Clinical Takeaway")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(.white)
            }
            CriticalDesign.autoBoldText(text)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(CriticalDesign.Colors.cardBlue))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(LinearGradient(colors: [CriticalDesign.Colors.goldMid, CriticalDesign.Colors.goldMid.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
        )
        .shadow(color: CriticalDesign.Colors.goldMid.opacity(0.2), radius: 8, y: 4)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    private func warningCard(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(CriticalDesign.Colors.accentBlue)
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            CriticalDesign.autoBoldText(content)
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 20).fill(CriticalDesign.Colors.accentBlue.opacity(0.05))
                    }
                }
            }
        )
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(CriticalDesign.Colors.accentBlue.opacity(colorScheme == .dark ? 0.2 : 0.3), lineWidth: 1))
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    private var hamiltonCardBackground: some View {
        Group {
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.cardBlue)
            } else {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 10)
                    .overlay(RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg).stroke(Color.white.opacity(0.8), lineWidth: 1))
            }
        }
    }
    
    // MARK: - Data
    
    private var terminologyData: [(hamilton: String, conventional: String)] {
        [
            ("APVcmv / (S)CMV+", "PRVC"),
            ("APVsimv / SIMV+", "PRVC-SIMV"),
            ("VS", "Volume Support"),
            ("(S)CMV", "Volume Control CMV"),
            ("PCV+ / P-CMV", "Pressure Control CMV"),
            ("DuoPAP", "BiLevel/BiVent"),
            ("APRV", "Airway Pressure Release"),
            ("ASV", "Adaptive Support"),
            ("INTELLiVENT-ASV", "Closed-Loop Intelligent")
        ]
    }
    
    private var hamiltonModes: [HamiltonMode] {
        [
            // Volume-Targeted
            HamiltonMode(
                name: "APVcmv / (S)CMV+",
                abbreviation: "APVcmv",
                conventionalEquivalent: "PRVC",
                category: .volumeTargeted,
                tagline: "Volume-targeted, pressure-controlled. The vent adjusts pressure to hit your target Vt.",
                description: """
                Full Name:
                Adaptive Pressure Ventilation with Controlled Mandatory Ventilation. Also called (S)CMV+ (Synchronized Controlled Mandatory Ventilation Plus).
                
                How It Works:
                APVcmv is a volume-targeted, pressure-controlled mode. It functions like traditional volume control, but uses pressure as the control variable instead of flow.
                
                1. Pressure is adjusted between breaths to achieve the target tidal volume
                2. The breath can be triggered by the ventilator or by the patient
                3. If the breath is triggered by the patient, the inspiratory rate may increase
                4. Breaths are volume-targeted and mandatory, delivered at the lowest possible pressure depending on lung conditions
                
                The Mental Model:
                Think of it as "smart volume control." You set the tidal volume you want, and the vent figures out what pressure is needed to deliver it. If the lungs get stiffer, pressure goes up. If compliance improves, pressure drops.
                
                The operator sets the target tidal volume (Vt). The ventilator delivers the set target volume at a preset rate. The patient can trigger mandatory breaths between preset rate breaths.
                """,
                safetyFeatures: "The ventilator uses the high Pressure alarm limit minus 10 cmH₂O as a safety ceiling for its inspiratory pressure adjustment, and does not exceed this value. Exception: Sigh breaths, when the ventilator may apply inspiratory pressures 3 cmH₂O below the high Pressure alarm limit.",
                keyParameters: ["Vt (target)", "Rate", "I:E", "PEEP/CPAP", "Oxygen", "Trigger", "P-ramp", "Sigh"],
                clinicalPearl: "APVcmv is most similar to PRVC (Pressure Regulated Volume Control). Ideal for patients requiring guaranteed minute ventilation. Automatically compensates for changes in lung compliance. Reduces risk of barotrauma compared to pure volume control. Particularly useful in transport when patient conditions may fluctuate."
            ),
            HamiltonMode(
                name: "APVsimv / SIMV+",
                abbreviation: "APVsimv",
                conventionalEquivalent: "PRVC-SIMV",
                category: .volumeTargeted,
                tagline: "Volume-targeted mandatory breaths + pressure-supported spontaneous breaths.",
                description: """
                Full Name:
                Adaptive Pressure Ventilation with Synchronized Intermittent Mandatory Ventilation. Also called SIMV+ (Synchronized Intermittent Mandatory Ventilation Plus).
                
                How It Works:
                The APVsimv mode combines attributes of the APVcmv and SPONT modes, delivering volume-targeted mandatory breaths OR pressure-supported spontaneous (patient-triggered) breaths.
                
                APVsimv mode ensures that the set target volume is delivered during the mandatory breaths. After the mandatory breath is delivered, the patient is free to take any number of spontaneous breaths for the remainder of the APV breath interval.
                
                Breath Cycle Structure:
                Each breath interval includes mandatory time (Tmand) and spontaneous time (Tspont):
                
                • If patient triggers during Tmand → Ventilator immediately delivers a mandatory breath
                • If patient triggers during Tspont → Ventilator delivers a spontaneous pressure-supported breath
                • If no patient trigger during Tspont → Ventilator automatically delivers a mandatory breath at end of Tmand
                
                For Mandatory Breaths:
                The tidal volume (Vt) setting defines the delivered volume. Rate and I:E define the timing of the breath cycle.
                
                For Spontaneous Breaths:
                Psupport defines the pressure support above PEEP. ETS defines the inspiratory timing. TI max can limit inspiratory time.
                """,
                safetyFeatures: "The ventilator uses the Plimit setting (high Pressure alarm limit minus 10 cmH₂O) as a safety boundary for its inspiratory pressure adjustment. Exception: Sigh breaths may apply inspiratory pressures 3 cmH₂O below the high Pressure alarm limit.",
                keyParameters: ["Vt", "Rate", "I:E", "PEEP/CPAP", "Psupport", "ETS", "TI max", "Oxygen", "Trigger", "P-ramp", "Sigh"],
                clinicalPearl: "Great weaning mode. As the patient gets stronger, they take more spontaneous breaths. You can gradually reduce the mandatory rate. The mandatory breaths guarantee ventilation; the spontaneous breaths let them do some work."
            ),
            HamiltonMode(
                name: "VS (Volume Support)",
                abbreviation: "VS",
                conventionalEquivalent: "Volume Support",
                category: .volumeTargeted,
                tagline: "All spontaneous, volume-targeted. Automatically adjusts based on patient effort.",
                description: """
                Full Name:
                Volume Support Ventilation
                
                How It Works:
                Breaths in VS mode are volume-targeted and spontaneous. Pressure is adjusted between breaths to achieve the target tidal volume. The patient initiates ALL breaths—there are no mandatory breaths.
                
                The Smart Adjustment:
                To achieve the set tidal volume, the device:
                • DECREASES support when the patient's breathing activity increases
                • INCREASES support when the patient's inspiratory efforts decrease
                
                This creates a natural weaning mechanism. As the patient gets stronger, the vent backs off automatically.
                
                Key Settings:
                • The tidal volume (Vt) setting defines the delivered volume
                • The P-ramp setting controls the speed with which the ventilator arrives at the desired pressure
                • ETS defines the inspiratory timing of the breaths
                • The inspiratory time can also be limited by TI max
                
                Requirements:
                The patient must have a reliable respiratory drive. This mode won't work if they're not triggering.
                """,
                safetyFeatures: "Backup ventilation activates if apnea occurs. The ventilator uses the Plimit setting (high Pressure alarm limit minus 10 cmH₂O) as a safety boundary for its inspiratory pressure adjustment.",
                keyParameters: ["Vt (target)", "P-ramp", "PEEP/CPAP", "ETS", "Flow/P-trigger"],
                clinicalPearl: "Excellent for weaning protocols. Requires reliable spontaneous respiratory drive. Provides automatic adaptation to changing patient effort. It's like having an RT constantly adjusting the pressure support—but the vent does it breath-by-breath."
            ),
            
            // Volume-Controlled
            HamiltonMode(
                name: "(S)CMV",
                abbreviation: "(S)CMV",
                conventionalEquivalent: "VC-CMV",
                category: .volumeControlled,
                tagline: "Traditional volume control. Set Vt and rate; pressure varies.",
                description: """
                Full Name:
                Synchronized Controlled Mandatory Ventilation
                
                How It Works:
                Breaths in (S)CMV mode are volume-controlled and mandatory. The breath can be triggered by the ventilator or by the patient. If the breath is spontaneous (triggered by the patient), the inspiratory rate may increase.
                
                If a breath is not triggered by patient effort within a preset time, the ventilator delivers a set tidal volume with a constant flow or operator-selected flow pattern for a set inspiratory time at a set respiratory rate.
                
                Key Concept:
                The ventilator ALWAYS delivers the set tidal volume. Pressure in the airway can increase or decrease depending on the resistance and compliance of the patient's lungs.
                
                Important:
                To protect the patient's lungs it is important to carefully set an upper pressure limit. If compliance worsens, pressures will rise to deliver the set volume.
                
                Clinical Considerations:
                • Useful when precise volume delivery is critical
                • Monitor peak pressures closely—may rise with worsening compliance
                • Less commonly used in modern practice due to advantages of pressure-targeted modes
                """,
                safetyFeatures: nil,
                keyParameters: ["Vt", "Rate", "Pause", "I:E", "Flow pattern", "PEEP/CPAP", "Oxygen", "Trigger", "Sigh"],
                clinicalPearl: "Classic volume control. You know exactly what volume you're delivering. Just watch those pressures—they tell you how the lungs are doing. Monitor peak pressures closely—they may rise with worsening compliance."
            ),
            HamiltonMode(
                name: "SIMV",
                abbreviation: "SIMV",
                conventionalEquivalent: "VC-SIMV",
                category: .volumeControlled,
                tagline: "Mandatory volume-controlled breaths + spontaneous breaths between.",
                description: """
                Full Name:
                Synchronized Intermittent Mandatory Ventilation
                
                How It Works:
                The SIMV mode combines attributes of the (S)CMV and SPONT modes, delivering volume-controlled mandatory breaths or pressure-supported spontaneous (patient-triggered) breaths.
                
                SIMV mode ensures that the set target volume is delivered during the mandatory breaths. After the mandatory breath is delivered, the patient is free to take any number of spontaneous breaths for the remainder of the SIMV breath interval.
                
                Breath Cycle Structure:
                Each SIMV breath interval includes mandatory time (Tmand) and spontaneous time (Tspont):
                
                • If patient triggers during Tmand → Ventilator immediately delivers a mandatory breath
                • If patient triggers during Tspont → Ventilator delivers a spontaneous, pressure-supported breath
                • If no patient trigger during Tspont → Ventilator automatically delivers a mandatory breath at end of Tmand
                
                For Mandatory Breaths:
                The tidal volume (Vt) setting defines the delivered volume. Rate and I:E define the timing of the breath cycle.
                
                For Spontaneous Breaths:
                Psupport defines the pressure support above PEEP. The ETS setting defines the percentage of peak flow that cycles the ventilator into exhalation.
                """,
                safetyFeatures: nil,
                keyParameters: ["Vt", "Rate", "I:E", "Psupport", "ETS", "TI max", "Flow pattern", "Pause", "PEEP/CPAP", "Oxygen", "Trigger", "P-ramp", "Sigh"],
                clinicalPearl: "Classic weaning mode. SIMV lets you gradually hand control back to the patient. Decrease the rate as they get stronger. If they're taking all spontaneous breaths, you're probably ready to try a spontaneous breathing trial."
            ),
            
            // Pressure-Controlled
            HamiltonMode(
                name: "PCV+ / P-CMV",
                abbreviation: "PCV+",
                conventionalEquivalent: "PC-CMV",
                category: .pressureControlled,
                tagline: "Fixed pressure delivery. Volume depends on compliance.",
                description: """
                Full Name:
                Pressure-Controlled Ventilation Plus / Pressure-Controlled Mandatory Ventilation
                
                How It Works:
                Breaths in PCV+ mode are pressure-controlled and mandatory. The ventilator delivers a constant level of pressure, so the volume depends on:
                
                • The pressure settings (Pcontrol)
                • The inspiration time
                • The resistance and compliance of the patient's lungs
                
                In PCV+ mode, parameters are set only for mandatory breaths.
                
                Features:
                • Constant pressure delivery throughout inspiration
                • Variable tidal volume based on patient lung mechanics
                • Speaking valve compatible on supported devices
                
                The Tradeoff:
                You get consistent, lung-protective pressures. But tidal volume varies—it's dependent on how the lungs respond to that pressure.
                """,
                safetyFeatures: "Speaking valve compatible on supported devices. Constant pressure prevents barotrauma from sudden pressure spikes.",
                keyParameters: ["Pcontrol (ΔPcontrol)", "Rate", "I:E", "PEEP/CPAP", "Oxygen", "Trigger", "P-ramp", "Sigh"],
                clinicalPearl: "PCV gives you direct control over airway pressures—great for lung protection. Just keep an eye on delivered volumes. If compliance drops, your volumes drop too."
            ),
            HamiltonMode(
                name: "PSIMV+ / P-SIMV",
                abbreviation: "PSIMV+",
                conventionalEquivalent: "PC-SIMV",
                category: .pressureControlled,
                tagline: "Pressure-controlled mandatory + pressure-supported spontaneous.",
                description: """
                Full Name:
                Pressure-Controlled Synchronized Intermittent Mandatory Ventilation Plus
                
                Options:
                Available with and without PSync (pressure synchronization).
                
                How It Works:
                In PSIMV+ mode, the mandatory breaths are PCV+ breaths. These can be alternated with spontaneous breaths. Each SIMV breath interval includes mandatory time (Tmand) and spontaneous time (Tspont).
                
                Breath Cycle Structure:
                • If patient triggers during Tmand → Ventilator immediately delivers a mandatory breath
                • If patient triggers during Tspont → Ventilator delivers a spontaneous, pressure-supported breath
                • If no patient trigger during Tspont → Ventilator automatically delivers a mandatory breath at end of Tmand
                
                For Mandatory Breaths:
                The Pcontrol setting defines the applied pressure above PEEP. Rate and I:E define the timing.
                
                For Spontaneous Breaths:
                Psupport defines the pressure support above PEEP. ETS defines the inspiratory timing. TI max can limit inspiratory time on some devices.
                """,
                safetyFeatures: "Speaking valve compatible. Both mandatory and spontaneous breaths are pressure-controlled for lung protection.",
                keyParameters: ["Pcontrol (ΔPcontrol)", "Rate", "I:E", "Psupport", "ETS", "TI max", "PEEP", "Oxygen", "Trigger", "P-ramp", "Sigh"],
                clinicalPearl: "Pressure-controlled mandatory breaths with the flexibility of spontaneous breathing. Good for patients who need guaranteed ventilation but also benefit from some spontaneous work."
            ),
            
            // Spontaneous Breathing
            HamiltonMode(
                name: "SPONT",
                abbreviation: "SPONT",
                conventionalEquivalent: "PSV/CPAP",
                category: .spontaneous,
                tagline: "Pure spontaneous breathing. Patient controls everything.",
                description: """
                Full Name:
                Spontaneous Mode
                
                How It Works:
                SPONT delivers spontaneous breaths and operator-initiated manual, mandatory breaths. When pressure support is set to zero, the ventilator functions like a conventional CPAP system.
                
                Key Settings:
                • The pressure support (Psupport) setting defines the applied pressure during inspiration
                • The PEEP setting defines the PEEP applied during expiration
                • ETS defines the inspiratory timing of the breaths
                • The inspiratory time can also be limited by TI max
                
                Clinical Applications:
                • Spontaneously breathing patients requiring minimal support
                • CPAP therapy (Psupport = 0)
                • Pre-extubation assessment
                • Patients on speaking valves
                """,
                safetyFeatures: "Speaking valve compatible on supported devices. Inspiratory time can be limited by TI max to prevent prolonged inspiration.",
                keyParameters: ["Psupport (ΔPsupport)", "PEEP/CPAP", "ETS", "Oxygen", "Trigger", "P-ramp", "Sigh"],
                clinicalPearl: "SPONT with zero pressure support = CPAP. Add pressure support and you're augmenting their effort. This is essentially a spontaneous breathing trial with backup CPAP. Good for pre-extubation assessment and patients on speaking valves."
            ),
            HamiltonMode(
                name: "DuoPAP",
                abbreviation: "DuoPAP",
                conventionalEquivalent: "BiLevel/BiVent",
                category: .spontaneous,
                tagline: "Two alternating CPAP levels. Versatile pressure mode.",
                description: """
                Full Name:
                Duo Positive Airway Pressure (also known as BiLevel or BiVent on other ventilators)
                
                How It Works:
                DuoPAP is a type of pressure ventilation designed to support spontaneous breathing on two alternating levels of CPAP. The ventilator switches automatically and regularly between two operator-selected levels of positive airway pressure or CPAP.
                
                Cycling between the levels is triggered by:
                • DuoPAP timing settings, OR
                • Patient effort
                
                The switch-over between the two levels is defined by:
                • Pressure settings: P high and PEEP/CPAP
                • Time settings: T high and Rate
                
                Mode Behavior Based on Settings:
                • Conventional settings, no spontaneous breathing → resembles PCV+
                • Decreased rate, short T high relative to time at lower level → looks like PSIMV+ with spontaneous breaths following mandatory breaths
                • T high set to almost the breath cycle time with just enough time at low level for full exhalation → looks like APRV
                
                Pressure Support:
                Psupport is set relative to (above) PEEP/CPAP. This means spontaneous breaths at the P high level are supported only when the Psupport target pressure is greater than P high.
                """,
                safetyFeatures: "Pressure support is additive to PEEP/CPAP. Spontaneous breathing encouraged at both pressure levels.",
                keyParameters: ["P high", "T high", "Rate", "PEEP/CPAP", "Psupport", "Oxygen", "P-ramp", "Trigger", "ETS"],
                clinicalPearl: "DuoPAP is a chameleon mode. With the right settings, it can mimic PCV, PSIMV, or APRV. Understanding the timing parameters is key. If you're struggling with APRV settings, DuoPAP can be an alternative approach."
            ),
            HamiltonMode(
                name: "APRV",
                abbreviation: "APRV",
                conventionalEquivalent: "APRV",
                category: .spontaneous,
                tagline: "Sustained high pressure with brief releases. Spontaneous breathing throughout.",
                description: """
                Full Name:
                Airway Pressure Release Ventilation
                
                How It Works:
                APRV maintains the lung at an elevated pressure (P high) for a prolonged period, then briefly releases to a lower pressure (P low) to allow CO₂ clearance, then quickly restores P high.
                
                The Philosophy:
                Keep the lung OPEN. The extended time at P high recruits and maintains alveolar units. The brief release to P low allows exhalation without complete derecruitment.
                
                Timing Structure:
                • T high: Time spent at high pressure (typically 4-6 seconds)
                • T low: Time spent at low pressure (typically 0.5-0.8 seconds)
                • Set so exhalation terminates at 75% of peak expiratory flow
                
                Key Concept:
                Spontaneous breathing is encouraged at BOTH pressure levels. This improves V/Q matching and reduces sedation requirements.
                
                When No Spontaneous Breathing:
                For patients with no spontaneous effort, APRV resembles pressure-controlled inverse ratio ventilation.
                
                Important Note:
                APRV is an INDEPENDENT mode—settings from other modes do NOT transfer in or out of APRV.
                
                Weight-Based Initial Settings:
                See the APRV Settings Table for initial T high and T low based on patient weight. All patients start with P high/P low of 20/5 cmH₂O.
                """,
                safetyFeatures: "Initial settings based on IBW (ideal body weight). T low should be set to terminate exhalation at 75% of peak expiratory flow to prevent derecruitment.",
                keyParameters: ["P high", "T high", "P low", "T low", "P-ramp", "Trigger", "IBW"],
                clinicalPearl: "APRV keeps the lung open. Long T high maintains recruitment; brief T low allows CO₂ clearance. If they're not breathing spontaneously, reconsider the mode—you may be doing expensive PCV. Watch the expiratory flow waveform to optimize T low."
            ),
            
            // Intelligent
            HamiltonMode(
                name: "ASV",
                abbreviation: "ASV",
                conventionalEquivalent: "Closed-loop",
                category: .intelligent,
                tagline: "Hamilton's signature closed-loop mode. Automatic breath-by-breath optimization.",
                description: """
                Full Name:
                Adaptive Support Ventilation
                
                The Concept:
                ASV is Hamilton's proprietary closed-loop ventilation mode. It continuously measures lung mechanics and adjusts ventilator settings breath-by-breath to deliver optimal ventilation.
                
                How It Works:
                The ventilator automatically and continuously adjusts:
                • Respiratory rate
                • Tidal volume
                • Inspiratory time
                • Inspiratory pressure (within safety limits)
                
                Based on:
                • Patient's lung mechanics (compliance, resistance)
                • Spontaneous breathing effort
                • Target minute ventilation (%MinVol)
                
                Seamless Transitions:
                ASV provides smooth transition from:
                Controlled ventilation (apneic patient) → Assisted breaths → Complete spontaneous breathing
                
                All without operator intervention. Works 24/7, from intubation to extubation.
                
                Automatic Protection:
                The algorithm automatically employs strategies to minimize:
                • AutoPEEP (intrinsic PEEP from air trapping)
                • Volutrauma (injury from overdistension)
                • Barotrauma (injury from high pressures)
                
                The Target:
                Instead of setting tidal volume or rate, you set %MinVol—the percentage of predicted minute ventilation for the patient's ideal body weight. The vent figures out the best way to deliver it.
                """,
                safetyFeatures: "Uses %MinVol (percentage of predicted minute ventilation) for target setting. Automatic lung-protective strategies prevent overdistension and barotrauma. Pasvlimit provides an upper pressure safety boundary.",
                keyParameters: ["Pasvlimit", "%MinVol", "PEEP/CPAP", "Oxygen", "P-ramp", "Trigger", "ETS", "Sigh"],
                clinicalPearl: "ASV works well as a first-line mode for most intubated patients. It reduces cognitive load during stressful transport situations and adapts automatically to changing patient conditions. Great for transport—set it and monitor, but you don't need to constantly tweak settings."
            ),
            HamiltonMode(
                name: "INTELLiVENT-ASV",
                abbreviation: "iVENT",
                conventionalEquivalent: "Advanced closed-loop",
                category: .intelligent,
                tagline: "Most advanced closed-loop. Auto-adjusts ventilation AND oxygenation.",
                description: """
                Full Name:
                Intelligent Ventilation with Adaptive Support Ventilation
                
                The Evolution:
                INTELLiVENT-ASV builds on ASV by adding automatic control of oxygenation. It's the most advanced closed-loop ventilation mode available.
                
                Automatic Control Of:
                • Minute ventilation (%MinVol) — based on PetCO₂
                • PEEP — based on oxygenation targets
                • Oxygen (FiO₂) — based on SpO₂
                
                How It Works:
                Clinician sets target ranges for SpO₂ and PetCO₂. The ventilator continuously adjusts settings to keep the patient within those targets.
                
                Quick Wean Feature:
                Includes automated assessment of weaning readiness and can initiate spontaneous breathing trials when criteria are met.
                
                Evidence:
                Studies show INTELLiVENT delivers lower driving pressure and mechanical power compared to P-SIMV, suggesting better lung protection.
                
                Regional Availability:
                Note: INTELLiVENT-ASV is NOT available in the United States. Available as an option on T1, C1, C3, C6, G5, and S1 ventilators in other markets.
                
                Clinical Considerations:
                • Best for stable patients with reliable SpO₂ and PetCO₂ monitoring
                • Less ideal for rapidly changing conditions where manual control may be preferred
                • Still requires clinical oversight—verify the vent's decisions make sense
                """,
                safetyFeatures: "Carefully selects appropriate driving pressure, mechanical power, and protective tidal volume. Studies show lower driving pressure and mechanical power vs P-SIMV. Automatic adjustments stay within clinician-set safety limits.",
                keyParameters: ["Pasvlimit", "%MinVol", "PEEP/CPAP", "Oxygen", "P-ramp", "Trigger", "ETS", "Sigh"],
                clinicalPearl: "More automation doesn't mean less vigilance. Always verify the vent's decisions make clinical sense. The vent optimizes based on numbers—you optimize based on the whole patient."
            ),
            
            // Non-Invasive
            HamiltonMode(
                name: "NIV",
                abbreviation: "NIV",
                conventionalEquivalent: "NIV",
                category: .noninvasive,
                tagline: "Non-invasive pressure support via mask. Zero Psupport = CPAP.",
                description: """
                Full Name:
                Non-Invasive Ventilation
                
                How It Works:
                NIV delivers spontaneous breaths via mask or other non-invasive interface (nasal mask, full face mask, helmet).
                
                When pressure support (Psupport) is set to zero, the ventilator functions like a conventional CPAP system.
                
                Key Features:
                • High peak flow rates for optimal performance with large leaks
                • Leak compensation algorithms maintain effective ventilation
                • Specific target FiO₂ for precise oxygen delivery
                • Same monitoring and alarm capabilities as invasive ventilation
                
                Settings:
                • The Psupport setting defines the applied pressure during inspiration
                • The PEEP setting defines the CPAP pressure during expiration
                • ETS defines the inspiratory timing
                • TI max can limit inspiratory time
                
                Clinical Applications:
                • COPD exacerbation
                • Cardiogenic pulmonary edema
                • Post-extubation respiratory failure
                • Sleep apnea
                • Neuromuscular disease
                """,
                safetyFeatures: "Leak compensation maintains effective ventilation despite interface leaks. Specific target FiO₂ for precise oxygen delivery. Full alarm capabilities.",
                keyParameters: ["Psupport (ΔPsupport)", "PEEP/CPAP", "ETS", "TI max", "Oxygen", "Trigger", "P-ramp", "Sigh"],
                clinicalPearl: "NIV through Hamilton gives you the same monitoring and alarm capabilities as invasive ventilation. Better leak compensation than many standalone NIV machines. Remember: NIV requires a cooperative patient who can protect their airway."
            ),
            HamiltonMode(
                name: "NIV-ST",
                abbreviation: "NIV-ST",
                conventionalEquivalent: "BiPAP S/T",
                category: .noninvasive,
                tagline: "Spontaneous + Timed backup. Safety net for unreliable respiratory drive.",
                description: """
                Full Name:
                Non-Invasive Ventilation with Spontaneous/Timed Mode
                
                How It Works:
                NIV-ST combines spontaneous breathing support with a timed backup rate:
                
                • When patient triggers → Delivers a flow-cycled, pressure-supported breath
                • If patient rate falls below set Rate → Ventilator delivers time-cycled backup breaths
                
                This provides a safety net for patients with unreliable respiratory drive.
                
                When Psupport is set to zero, functions as CPAP with a backup rate.
                
                Important BiPAP Translation:
                On Hamilton, Pinsp is ADDITIVE to PEEP (this is different from some BiPAP machines).
                
                Example:
                If you want IPAP 15 and EPAP 5:
                • Set PEEP = 5 cmH₂O
                • Set ΔPinsp = 10 cmH₂O (because 5 + 10 = 15)
                
                Clinical Applications:
                • Sleep apnea with central component
                • COPD with CO₂ retention
                • Post-extubation support for patients with variable respiratory drive
                • Neuromuscular disease with nocturnal hypoventilation
                • Obesity hypoventilation syndrome
                """,
                safetyFeatures: "Time-cycled backup if patient rate drops below the set Rate. Provides safety net for variable respiratory drive. Leak compensation maintains effective ventilation.",
                keyParameters: ["Pinsp (ΔPinsp)", "Rate", "TI", "PEEP/CPAP", "ETS", "TI max", "Oxygen", "P-ramp", "Trigger"],
                clinicalPearl: "Great for patients with variable respiratory drive—the backup rate is your safety net. Remember: Pinsp is ADDITIVE to PEEP on Hamilton. If coming from a standalone BiPAP, you'll need to recalculate your pressure settings."
            ),
            HamiltonMode(
                name: "HiFlowO₂",
                abbreviation: "HFNC",
                conventionalEquivalent: "HFNC",
                category: .noninvasive,
                tagline: "High-flow nasal cannula. Heated, humidified, high flow.",
                description: """
                Full Name:
                High-Flow Oxygen Therapy (also called HFNC - High Flow Nasal Cannula)
                
                How It Works:
                Delivers continuous heated and humidified respiratory gases at high flow rates (up to 60 L/min typically) via nasal cannula.
                
                For spontaneously breathing patients only—no mandatory breaths are delivered.
                
                Mechanisms of Benefit:
                • High flow rate delivers precise FiO₂ (dilution from room air is minimal)
                • Heated humidification improves comfort and mucociliary function
                • High flow creates small amount of positive airway pressure (flow-dependent PEEP effect)
                • Washes out dead space, improving CO₂ clearance
                
                Requirements:
                • Operating humidifier REQUIRED
                • Operator sets oxygen concentration and flow rate
                
                Delivery Options:
                Can be delivered via:
                • Single or double limb circuits
                • High-flow nasal cannula
                • Tracheal adapter (for tracheostomy patients)
                
                Clinical Applications:
                • Hypoxemic respiratory failure
                • Post-extubation support
                • Pre-oxygenation before intubation
                • Comfort care
                • Bronchiolitis (pediatric)
                """,
                safetyFeatures: "⚠️ IMPORTANT: Disconnection and apnea alarms are INACTIVE during high flow oxygen therapy. Keep eyes on your patient—the vent will NOT alert you if they stop breathing. This is purely supportive therapy with no safety net.",
                keyParameters: ["Oxygen (FiO₂)", "Flow (L/min)"],
                clinicalPearl: "HFOT through the vent gives you precise FiO₂ control and integrated monitoring. BUT remember: apnea and disconnect alarms don't work. If your patient is at high risk for respiratory failure, this isn't the right mode. Always have intubation equipment ready."
            )
        ]
    }
}

// MARK: - Supporting Views

struct HamiltonBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false

    var body: some View {
        ZStack {
            if colorScheme == .dark {
                CriticalDesign.Adaptive.canvas(for: colorScheme)
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.98, blue: 0.99),
                        Color(red: 0.94, green: 0.96, blue: 0.98),
                        Color(red: 0.96, green: 0.97, blue: 0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }

            GeometryReader { geo in
                // Teal/cyan orb - medical/respiratory feel
                Circle()
                    .fill(CriticalDesign.Colors.accentTeal.opacity(colorScheme == .dark ? 0.09 : 0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                        y: animate ? geo.size.height * 0.2 : geo.size.height * 0.4
                    )

                // Soft blue orb
                Circle()
                    .fill(CriticalDesign.Colors.accentBlue.opacity(colorScheme == .dark ? 0.08 : 0.04))
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                    .offset(
                        x: animate ? geo.size.width * 0.1 : geo.size.width * 0.5,
                        y: animate ? geo.size.height * 0.6 : geo.size.height * 0.3
                    )

                // Subtle green accent - respiratory theme
                Circle()
                    .fill(CriticalDesign.Colors.accentGreen.opacity(colorScheme == .dark ? 0.06 : 0.03))
                    .frame(width: 200, height: 200)
                    .blur(radius: 70)
                    .offset(
                        x: animate ? geo.size.width * 0.3 : geo.size.width * 0.7,
                        y: animate ? geo.size.height * 0.7 : geo.size.height * 0.5
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

struct HamiltonGlassCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let icon: String
    var accentColor: Color = CriticalDesign.Colors.accentBlue
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(accentColor)
                }
                
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            content
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.7))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
}

struct HamiltonFormatter {
    static let textPrimary = Color(red: 0.04, green: 0.09, blue: 0.16)
    static let textTertiary = Color(red: 0.24, green: 0.35, blue: 0.50)
    
    static func format(_ text: String, headings: [String]) -> AttributedString {
        var result = AttributedString(text)
        let baseFont = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        result.font = Font(baseFont)
        result.foregroundColor = textTertiary
        
        let boldFont = UIFont(name: "Poppins-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
        for heading in headings {
            if let range = result.range(of: heading) {
                result[range].font = Font(boldFont)
                result[range].foregroundColor = textPrimary
            }
        }
        return result
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: .unspecified)
        }
    }
    
    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        var frames: [CGRect] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
        return (CGSize(width: maxWidth, height: currentY + lineHeight), frames)
    }
}

// MARK: - Preview

struct HamiltonT1VentilatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HamiltonT1VentilatorView()
        }
    }
}
