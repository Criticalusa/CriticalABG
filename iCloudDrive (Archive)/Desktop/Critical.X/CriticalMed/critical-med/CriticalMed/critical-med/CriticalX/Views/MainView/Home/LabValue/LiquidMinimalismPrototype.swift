//
//  LiquidMinimalismPrototype.swift
//  CriticalX
//
//  Liquid Minimalism 2030: Ive + Rams + Dye
//  Frosted glass materials, subtle color tints, clean geometry
//

import SwiftUI

// MARK: - Liquid Minimalism Lab Prototype
struct LiquidMinimalismPrototype: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var unitPreference = LabUnitPreference.shared
    @State private var selectedPanel: LiquidLabPanel? = nil
    @State private var isAppearing = false
    
    var body: some View {
        ZStack {
            // Adaptive background with subtle gradient
            adaptiveBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if selectedPanel == nil {
                    headerSection
                    panelGridSection
                } else {
                    detailView
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if selectedPanel != nil {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            selectedPanel = nil
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .regular))
                            Text("Labs")
                                .font(.custom("Poppins-Regular", size: 15))
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                } else {
                    LiquidGlassBackButton()
                }
            }
        }
    }
    
    // MARK: - Adaptive Background (Extra Bold Jony Ive Mix)
    private var adaptiveBackground: some View {
        ZStack {
            // Bold base gradient - dramatic diagonal sweep
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.12, blue: 0.18),  // Deep navy
                        Color(red: 0.02, green: 0.02, blue: 0.03),  // Almost black
                        Color(red: 0.12, green: 0.08, blue: 0.02)   // Deep gold undertone
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.88, green: 0.91, blue: 0.96),  // Bold blue tint
                        Color(red: 0.93, green: 0.93, blue: 0.94),  // Neutral
                        Color(red: 0.96, green: 0.93, blue: 0.88)   // Bold gold tint
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            
            // ULTRA BOLD - Navy Blue bloom (top-left) 
            RadialGradient(
                colors: [
                    CriticalDesign.Colors.cardBlue.opacity(colorScheme == .dark ? 0.45 : 0.32),
                    CriticalDesign.Colors.cardBlue.opacity(colorScheme == .dark ? 0.26 : 0.20),
                    CriticalDesign.Colors.cardBlue.opacity(colorScheme == .dark ? 0.10 : 0.08),
                    Color.clear
                ],
                center: UnitPoint(x: 0.1, y: 0.15),
                startRadius: 5,
                endRadius: 240
            )
            
            // ULTRA BOLD - Gold bloom (bottom-right)
            RadialGradient(
                colors: [
                    Color(red: 0.96, green: 0.71, blue: 0.0).opacity(colorScheme == .dark ? 0.40 : 0.30),
                    Color(red: 0.96, green: 0.71, blue: 0.0).opacity(colorScheme == .dark ? 0.22 : 0.18),
                    Color(red: 0.96, green: 0.71, blue: 0.0).opacity(colorScheme == .dark ? 0.08 : 0.06),
                    Color.clear
                ],
                center: UnitPoint(x: 0.9, y: 0.85),
                startRadius: 5,
                endRadius: 260
            )
            
            // EXTRA BOLD - Dark OD Green accent (center) 
            RadialGradient(
                colors: [
                    Color(red: 0.30, green: 0.38, blue: 0.28).opacity(colorScheme == .dark ? 0.30 : 0.22),  // Darker solid OD green - BOLDER
                    Color(red: 0.30, green: 0.38, blue: 0.28).opacity(colorScheme == .dark ? 0.12 : 0.08),
                    Color.clear
                ],
                center: UnitPoint(x: 0.5, y: 0.5),
                startRadius: 20,
                endRadius: 200
            )
            
            // Strong vignette for dramatic depth
            RadialGradient(
                colors: [
                    Color.clear,
                    (colorScheme == .dark ? Color.black : Color(white: 0.75)).opacity(colorScheme == .dark ? 0.5 : 0.25)
                ],
                center: .center,
                startRadius: 80,
                endRadius: 450
            )
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Icon with subtle glow
            Image("icon-labvalue")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .opacity(0.9)
            
            VStack(spacing: 8) {
                Text("Lab Values")
                    .font(.custom("Poppins-Light", size: 34))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text("Reference Ranges & Interpretation")
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.4))
                    .kerning(1.2)
                    .textCase(.uppercase)
            }
            
            // Unit picker
            liquidUnitPicker
        }
        .padding(.top, 30)
        .padding(.bottom, 20)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -20)
    }
    
    // MARK: - Liquid Unit Picker
    private var liquidUnitPicker: some View {
        HStack(spacing: 0) {
            ForEach(LabUnitSystem.allCases, id: \.self) { system in
                unitButton(for: system)
            }
        }
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .strokeBorder((colorScheme == .dark ? Color.white : Color.black).opacity(0.1), lineWidth: 0.5)
                )
        )
    }
    
    private func unitButton(for system: LabUnitSystem) -> some View {
        let isSelected = unitPreference.unitSystem == system
        let textColor = isSelected 
            ? Color.white
            : (colorScheme == .dark ? Color.white : Color.black).opacity(0.5)
        let bgColor = CriticalDesign.Colors.cardBlue
        
        return Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                unitPreference.unitSystem = system
            }
        }) {
            Text(system.displayName)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(textColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Group {
                        if isSelected {
                            Capsule().fill(bgColor)
                        }
                    }
                )
        }
    }
    
    // MARK: - Panel Grid Section
    private var panelGridSection: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(Array(mockPanels.enumerated()), id: \.offset) { index, panel in
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            selectedPanel = panel
                        }
                    }) {
                        LiquidPanelCard(panel: panel)
                    }
                    .buttonStyle(LiquidScaleButtonStyle())
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 30)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.04), value: isAppearing)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Detail View
    private var detailView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                if let panel = selectedPanel {
                    // Header card with glass
                    LiquidDetailHeader(panel: panel)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    // Lab values
                    ForEach(mockLabValues(for: panel), id: \.name) { lab in
                        LiquidLabValueRow(lab: lab)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Liquid Panel Card
struct LiquidPanelCard: View {
    @Environment(\.colorScheme) var colorScheme
    let panel: LiquidLabPanel
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon with subtle tint
            Image(panel.image)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .opacity(0.85)
            
            VStack(spacing: 6) {
                Text(panel.abbreviation)
                    .font(.custom("Poppins-Medium", size: 18))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text(panel.fullName)
                    .font(.custom("Poppins-Regular", size: 10))
                    .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.4))
                    .kerning(0.8)
                    .multilineTextAlignment(.center)
            }
            
            // Test count badge
            Text("\(panel.testCount) tests")
                .font(.custom("Poppins-Regular", size: 9))
                .foregroundColor(panel.tintColor.opacity(0.7))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(panel.tintColor.opacity(0.08))
                )
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                // White/black base for more opacity
                RoundedRectangle(cornerRadius: 20)
                    .fill((colorScheme == .dark ? Color.white : Color.white).opacity(colorScheme == .dark ? 0.08 : 0.5))
                
                // Glass material on top
                RoundedRectangle(cornerRadius: 20)
                    .fill(.regularMaterial)
                
                // Subtle border for definition
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder((colorScheme == .dark ? Color.white : Color.white).opacity(colorScheme == .dark ? 0.15 : 0.4), lineWidth: 1)
            }
        )
    }
}

// MARK: - Liquid Detail Header
struct LiquidDetailHeader: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var unitPreference = LabUnitPreference.shared
    let panel: LiquidLabPanel
    
    var body: some View {
        VStack(spacing: 0) {
            // Top section with icon and title
            HStack(spacing: 20) {
                // Icon with glow
                ZStack {
                    // Subtle glow
                    Circle()
                        .fill(panel.tintColor.opacity(0.15))
                        .frame(width: 70, height: 70)
                        .blur(radius: 12)
                    
                    Image(panel.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                        .opacity(0.9)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(panel.abbreviation)
                        .font(.system(size: 32, weight: .thin, design: .default))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Text(panel.fullName)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.4))
                        .kerning(1.0)
                        .textCase(.uppercase)
                }
                
                Spacer()
            }
            .padding(24)
            
            // Elegant divider with gradient
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color(red: 0.96, green: 0.71, blue: 0.0).opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            
            // Stats bar
            HStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("\(panel.testCount)")
                        .font(.custom("Poppins-ExtraLight", size: 36))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Text("Tests")
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.4))
                        .kerning(1.0)
                        .textCase(.uppercase)
                }
                .frame(maxWidth: .infinity)
                
                Rectangle()
                    .fill((colorScheme == .dark ? Color.white : Color.black).opacity(0.08))
                    .frame(width: 1, height: 50)
                
                VStack(spacing: 8) {
                    Text(unitPreference.unitSystem == .si ? "SI" : "Conv")
                        .font(.custom("Poppins-Light", size: 16))
                        .foregroundColor(panel.tintColor)
                    
                    Text("Units")
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.4))
                        .kerning(1.0)
                        .textCase(.uppercase)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 20)
        }
        .background(
            ZStack {
                // Pure glass material - iOS hard press style
                RoundedRectangle(cornerRadius: 24)
                    .fill(.regularMaterial)
                
                // Subtle gold accent on border only
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(
                        Color(red: 0.96, green: 0.71, blue: 0.0).opacity(0.4),
                        lineWidth: 1
                    )
            }
        )
    }
}

// MARK: - Liquid Lab Value Row
struct LiquidLabValueRow: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var unitPreference = LabUnitPreference.shared
    let lab: MockLabValue
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(lab.name)
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text(lab.subtitle)
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.4))
                    .kerning(0.6)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(lab.range)
                    .font(.custom("Poppins-Light", size: 16))
                    .foregroundColor(Color(red: 0.38, green: 0.50, blue: 0.40))  // Olive/forest green
                
                Text(lab.unit)
                    .font(.custom("Poppins-Regular", size: 10))
                    .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.4))
                    .kerning(0.6)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.2))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            ZStack {
                // White/black base for more opacity
                RoundedRectangle(cornerRadius: 16)
                    .fill((colorScheme == .dark ? Color.white : Color.white).opacity(colorScheme == .dark ? 0.06 : 0.45))
                
                // Glass material on top
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                
                // Subtle border
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder((colorScheme == .dark ? Color.white : Color.white).opacity(colorScheme == .dark ? 0.12 : 0.35), lineWidth: 0.5)
            }
        )
    }
}

// MARK: - Liquid Scale Button Style
struct LiquidScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Models
struct LiquidLabPanel: Identifiable {
    let id = UUID()
    let abbreviation: String
    let fullName: String
    let testCount: Int
    let image: String
    let tintColor: Color
}

struct MockLabValue {
    let name: String
    let subtitle: String
    let range: String
    let unit: String
}

// MARK: - Mock Data
private let mockPanels = [
    LiquidLabPanel(abbreviation: "BMP", fullName: "Basic Metabolic Panel", testCount: 8, image: "Tubes", tintColor: CriticalDesign.Colors.cardBlue),
    LiquidLabPanel(abbreviation: "CBC", fullName: "Complete Blood Count", testCount: 12, image: "Tubes", tintColor: Color(red: 0.30, green: 0.38, blue: 0.28)),  // Dark OD green
    LiquidLabPanel(abbreviation: "CMP", fullName: "Comprehensive Metabolic", testCount: 14, image: "Tubes", tintColor: CriticalDesign.Colors.accentBlue),
    LiquidLabPanel(abbreviation: "Lipid", fullName: "Lipid Panel", testCount: 6, image: "Tubes", tintColor: CriticalDesign.Colors.cardBlue),  // Navy blue instead of purple
    LiquidLabPanel(abbreviation: "Cardiac", fullName: "Cardiac Markers", testCount: 9, image: "Tubes", tintColor: Color(red: 0.85, green: 0.35, blue: 0.4)),
    LiquidLabPanel(abbreviation: "Liver", fullName: "Liver Function", testCount: 7, image: "Tubes", tintColor: CriticalDesign.Colors.accentOrange)
]

private func mockLabValues(for panel: LiquidLabPanel) -> [MockLabValue] {
    switch panel.abbreviation {
    case "BMP":
        return [
            MockLabValue(name: "Sodium", subtitle: "Na+", range: "135-145", unit: "mEq/L"),
            MockLabValue(name: "Potassium", subtitle: "K+", range: "3.5-5.0", unit: "mEq/L"),
            MockLabValue(name: "Glucose", subtitle: "Glu", range: "70-100", unit: "mg/dL"),
            MockLabValue(name: "Creatinine", subtitle: "Cr", range: "0.7-1.3", unit: "mg/dL")
        ]
    default:
        return [
            MockLabValue(name: "Sample Test", subtitle: "TST", range: "10-20", unit: "units")
        ]
    }
}

// MARK: - Preview
struct LiquidMinimalismPrototype_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LiquidMinimalismPrototype()
        }
    }
}
