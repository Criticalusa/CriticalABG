//
//  JonyIveLabPrototype.swift
//  CriticalX
//
//  Jony Ive 2030 Design Prototype for Lab Values
//  Philosophy: "Let the numbers be the design"
//

import SwiftUI

// MARK: - Jony Ive Lab Prototype Main View
struct JonyIveLabPrototype: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var unitPreference = LabUnitPreference.shared
    @Namespace private var animation
    @State private var selectedPanel: JonyLabPanel? = nil
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Pure background
            (colorScheme == .dark ? Color.black : Color.white)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                header
                
                // Lab Strip (Horizontal scroll)
                if selectedPanel == nil {
                    labStrip
                        .transition(.move(edge: .top).combined(with: .opacity))
                } else {
                    panelDetailView
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if selectedPanel != nil {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            selectedPanel = nil
                        }
                    }
                }) {
                    Image(systemName: selectedPanel == nil ? "chevron.left" : "chevron.left")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                unitToggle
            }
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 4) {
            Text("Lab Values")
                .font(.system(size: 13, weight: .medium, design: .default))
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.5))
                .kerning(2)
                .textCase(.uppercase)
            
            if selectedPanel == nil {
                Text("Reference Ranges")
                    .font(.system(size: 11, weight: .regular, design: .default))
                    .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.4))
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
        .padding(.bottom, 24)
    }
    
    // MARK: - Unit Toggle (Minimal)
    private var unitToggle: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                unitPreference.unitSystem = unitPreference.unitSystem == .conventional ? .si : .conventional
            }
        }) {
            Text(unitPreference.unitSystem == .si ? "SI" : "CONV")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .strokeBorder(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 0.5)
                )
        }
    }
    
    // MARK: - Lab Strip (Horizontal Scroll)
    private var labStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(JonyLabPanel.allPanels) { panel in
                    labPanelCard(panel)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                selectedPanel = panel
                            }
                        }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
    }
    
    // MARK: - Lab Panel Card (Typography First)
    private func labPanelCard(_ panel: JonyLabPanel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Panel name
            Text(panel.abbreviation)
                .font(.system(size: 48, weight: .ultraLight, design: .default))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            // Full name
            Text(panel.fullName)
                .font(.system(size: 11, weight: .regular, design: .default))
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
                .kerning(0.5)
            
            Spacer()
            
            // Value count
            HStack(spacing: 4) {
                Text("\(panel.labCount)")
                    .font(.system(size: 14, weight: .medium, design: .default))
                Text("values")
                    .font(.system(size: 11, weight: .regular, design: .default))
                    .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
            }
        }
        .frame(width: 200, height: 240)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.06), lineWidth: 0.5)
        )
    }
    
    // MARK: - Panel Detail View
    private var panelDetailView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                if let panel = selectedPanel {
                    // Panel header
                    VStack(spacing: 8) {
                        Text(panel.abbreviation)
                            .font(.system(size: 36, weight: .ultraLight, design: .default))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Text(panel.fullName)
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
                            .kerning(1)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    
                    // Lab values list
                    ForEach(panel.sampleLabs) { lab in
                        NavigationLink(destination: 
                            BtnDetailView(data: lab.btnData)
                                .navigationBarBackground { colorScheme == .dark ? Color.black : Color.white }
                        ) {
                            labValueRow(lab)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 20)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                            .background(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
                    }
                }
            }
        }
    }
    
    // MARK: - Lab Value Row (Number First)
    private func labValueRow(_ lab: JonyLabValue) -> some View {
        let displayValues = lab.btnData.displayValue(for: unitPreference.unitSystem)
        
        return HStack(alignment: .firstTextBaseline, spacing: 0) {
            // Lab abbreviation
            Text(lab.abbreviation)
                .font(.system(size: 17, weight: .regular, design: .default))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(width: 60, alignment: .leading)
            
            Spacer()
            
            // Range
            VStack(alignment: .trailing, spacing: 2) {
                Text(displayValues.range)
                    .font(.system(size: 28, weight: .thin, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Text(displayValues.unit)
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
                    .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Lab Panel Model
struct JonyLabPanel: Identifiable {
    let id = UUID()
    let abbreviation: String
    let fullName: String
    let labCount: Int
    let sampleLabs: [JonyLabValue]
    
    static let allPanels: [JonyLabPanel] = [
        JonyLabPanel(
            abbreviation: "BMP",
            fullName: "Basic Metabolic Panel",
            labCount: 7,
            sampleLabs: [
                JonyLabValue(abbreviation: "Na+", btnData: BtnDataModel.basicMetabolicData[0]),
                JonyLabValue(abbreviation: "K+", btnData: BtnDataModel.basicMetabolicData[1]),
                JonyLabValue(abbreviation: "Cl-", btnData: BtnDataModel.basicMetabolicData[2]),
                JonyLabValue(abbreviation: "CO2", btnData: BtnDataModel.basicMetabolicData[3]),
                JonyLabValue(abbreviation: "BUN", btnData: BtnDataModel.basicMetabolicData[4]),
                JonyLabValue(abbreviation: "Cr", btnData: BtnDataModel.basicMetabolicData[5]),
                JonyLabValue(abbreviation: "Glu", btnData: BtnDataModel.basicMetabolicData[6])
            ]
        ),
        JonyLabPanel(
            abbreviation: "CBC",
            fullName: "Complete Blood Count",
            labCount: 17,
            sampleLabs: [
                JonyLabValue(abbreviation: "WBC", btnData: BtnDataModel.bloodCountData[16]),
                JonyLabValue(abbreviation: "Hgb ♂", btnData: BtnDataModel.bloodCountData[4]),
                JonyLabValue(abbreviation: "Hgb ♀", btnData: BtnDataModel.bloodCountData[5]),
                JonyLabValue(abbreviation: "Hct ♂", btnData: BtnDataModel.bloodCountData[2]),
                JonyLabValue(abbreviation: "Hct ♀", btnData: BtnDataModel.bloodCountData[3]),
                JonyLabValue(abbreviation: "Plt", btnData: BtnDataModel.bloodCountData[12])
            ]
        ),
        JonyLabPanel(
            abbreviation: "CMP",
            fullName: "Complete Metabolic Panel",
            labCount: 16,
            sampleLabs: [
                JonyLabValue(abbreviation: "Na+", btnData: BtnDataModel.metabolicPanelData[0]),
                JonyLabValue(abbreviation: "K+", btnData: BtnDataModel.metabolicPanelData[1]),
                JonyLabValue(abbreviation: "Ca2+", btnData: BtnDataModel.metabolicPanelData[7]),
                JonyLabValue(abbreviation: "Alb", btnData: BtnDataModel.metabolicPanelData[10]),
                JonyLabValue(abbreviation: "ALT", btnData: BtnDataModel.metabolicPanelData[12])
            ]
        ),
        JonyLabPanel(
            abbreviation: "CARDIAC",
            fullName: "Cardiac Panel",
            labCount: 9,
            sampleLabs: [
                JonyLabValue(abbreviation: "TnI", btnData: BtnDataModel.cardicData[7]),
                JonyLabValue(abbreviation: "CK-MB", btnData: BtnDataModel.cardicData[2]),
                JonyLabValue(abbreviation: "BNP", btnData: BtnDataModel.cardicData[0]),
                JonyLabValue(abbreviation: "Myo", btnData: BtnDataModel.cardicData[8])
            ]
        ),
        JonyLabPanel(
            abbreviation: "COAGS",
            fullName: "Coagulation Panel",
            labCount: 6,
            sampleLabs: [
                JonyLabValue(abbreviation: "PT", btnData: BtnDataModel.coagsData[3]),
                JonyLabValue(abbreviation: "PTT", btnData: BtnDataModel.coagsData[4]),
                JonyLabValue(abbreviation: "INR", btnData: BtnDataModel.coagsData[2]),
                JonyLabValue(abbreviation: "D-Di", btnData: BtnDataModel.coagsData[1])
            ]
        )
    ]
}

// MARK: - Lab Value Model
struct JonyLabValue: Identifiable {
    let id = UUID()
    let abbreviation: String
    let btnData: BtnDataModel
}

// MARK: - Preview
struct JonyIveLabPrototype_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            JonyIveLabPrototype()
        }
        .preferredColorScheme(.light)
        
        NavigationView {
            JonyIveLabPrototype()
        }
        .preferredColorScheme(.dark)
    }
}
