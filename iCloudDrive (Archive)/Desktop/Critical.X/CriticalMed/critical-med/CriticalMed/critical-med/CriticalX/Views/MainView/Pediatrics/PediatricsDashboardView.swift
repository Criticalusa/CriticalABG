//
//  PediatricsDashboardView.swift
//  CriticalX
//
//  Modern pediatric dosing dashboard with clean design.
//

import SwiftUI

struct PediatricsDashboardView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var patientContext = GlobalPatientContext.shared
    @ObservedObject private var accessManager = ContentAccessManager.shared
    @StateObject private var viewModel = PedsViewModel()

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

    @State private var weightText = ""
    @State private var showingPopup = false
    @State private var showingPopup1 = false
    @State private var showUpgradePrompt = false
    @State private var isActive = false

    // Age-weight reference data - Broselow color coding
    // Gray: 3-5kg, Pink: 6-7kg, Red: 8-9kg, Purple: 10-11kg, Yellow: 12-14kg
    // White: 15-18kg, Blue: 19-23kg, Orange: 24-29kg, Green: 30-36kg
    private static let ageWeightData: [(age: String, weight: String, color: Color)] = [
        ("Premature", "2", Color(hex: "9E9E9E")),      // Gray (under 3kg)
        ("Newborn", "4", Color(hex: "78909C")),        // Gray
        ("4-6 Months", "6", Color(hex: "F48FB1")),     // Pink
        ("6-8 Months", "8", Color(hex: "EF5350")),     // Red
        ("1 Year", "10", Color(hex: "AB47BC")),        // Purple
        ("18 Mo - 2 Yr", "12", Color(hex: "FFEB3B")),  // Yellow
        ("3 Years", "15", Color(hex: "BDBDBD")),       // White/Light gray
        ("4 Years", "17", Color(hex: "E0E0E0")),       // White
        ("5-6 Years", "20", Color(hex: "42A5F5")),     // Blue
        ("7 Years", "22", Color(hex: "2196F3")),       // Blue
        ("8 Years", "25", Color(hex: "FF9800")),       // Orange
        ("9 Years", "27", Color(hex: "FB8C00")),       // Orange
        ("10 Years", "30", Color(hex: "66BB6A")),      // Green
        ("11-12 Years", "35", Color(hex: "4CAF50")),   // Green
        ("13 Years", "40", Color(hex: "43A047")),      // Green (max Broselow)
        ("14-15 Years", "50", Color(hex: "5C6BC0")),   // Indigo (beyond tape)
        ("16 Years", "60", Color(hex: "7E57C2")),      // Deep purple
        ("17 Years", "75", Color(hex: "26A69A")),      // Teal
        ("Adult", "100", Color(hex: "546E7A")),        // Blue gray
    ]

    // MARK: - Helper Properties (Dark Mode Standard)
    
    private var cardBackground: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.cardBlue
            : Color.white
    }
    
    private var cardStroke: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.goldMid.opacity(0.3)
            : CriticalDesign.Colors.navyAccent.opacity(0.08)
    }
    
    private func cardShadow(opacity: Double = 0.04) -> Color {
        Color.black.opacity(colorScheme == .dark ? opacity * 3 : opacity)
    }
    
    private var textPrimary: Color {
        CriticalDesign.Adaptive.textPrimary(for: colorScheme)
    }
    
    private var textSecondary: Color {
        CriticalDesign.Adaptive.textSecondary(for: colorScheme)
    }
    
    private var textTertiary: Color {
        CriticalDesign.Adaptive.textTertiary(for: colorScheme)
    }

    var body: some View {
        ZStack {
            // Background
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: - Hero Header
                    heroHeader
                    
                    // MARK: - Weight Calculator Card
                    weightCalculatorCard
                        .padding(.horizontal, 20)
                        .padding(.top, -40) // Overlap with header
                    
                    // MARK: - Quick Actions
                    quickActionsRow
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    // MARK: - Age-Weight Reference
                    ageWeightSection
                        .padding(.top, 24)
                    
                    Spacer(minLength: 120)
                }
            }

        }
        .background(
            NavigationLink(
                destination: PedsDetailView(viewModel: viewModel, selectedCategory: selectedCategory.wrappedValue)
                    .navigationBarBackground { Color.logoBlue.shadow(radius: 1) },
                isActive: $isActive
            ) { EmptyView() }
                .hidden()
        )
        .sheet(isPresented: $showUpgradePrompt) {
            UpgradePromptView()
        }
        .fullScreenCover(isPresented: $showingPopup) {
            WarningPopupView(title: "Wait!", message: "Enter a valid weight first.")
                .background(BackgroundClearView())
        }
        .fullScreenCover(isPresented: $showingPopup1) {
            ThanksPopupView(title: "Saved!", message: "Your doses have been updated.")
                .background(BackgroundClearView())
        }
        .onAppear {
            if let w = patientContext.weightKg, weightText.isEmpty {
                weightText = String(format: "%.1f", w)
            }
        }
        .onChange(of: weightText) { newValue in
            if !newValue.isEmpty {
                patientContext.setWeight(from: newValue, unit: .kg)
            }
        }
        .onChange(of: patientContext.weightKg) { newWeight in
            // Sync from external weight changes (e.g., popover, floating button)
            if let w = newWeight {
                let newText = String(format: "%.1f", w)
                if newText != weightText {
                    weightText = newText
                }
            }
        }
    }
    
    // MARK: - Hero Header
    
    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            // Background gradient
            LinearGradient(
                colors: [
                    CriticalDesign.Colors.cardBlue,
                    CriticalDesign.Colors.cardBlue.opacity(0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)
            
            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 150, height: 150)
                .offset(x: -40, y: -60)
            
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 100, height: 100)
                .offset(x: 280, y: -20)
            
            // Content
            HStack(spacing: 16) {
                // 3D Peds icon
                CatalogThumbnailImage(name: "icon-peds", size: 70, cornerRadius: 14)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pediatric Dosing")
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(.white)
                    
                    Text("Weight-based medication calculator")
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
        }
    }
    
    // MARK: - Weight Calculator Card
    
    private var weightCalculatorCard: some View {
        VStack(spacing: 20) {
            // Input row
            HStack(spacing: 16) {
                // Weight input
                VStack(alignment: .leading, spacing: 6) {
                    Text("Patient Weight")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    
                    HStack(spacing: 8) {
                        TextField("0", text: $weightText)
                            .font(.custom("Poppins-Bold", size: 32))
                            .foregroundColor(
                                colorScheme == .dark
                                    ? CriticalDesign.Colors.accentTeal
                                    : CriticalDesign.Colors.cardBlue
                            )
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: .infinity)
                        
                        Text("kg")
                            .font(.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? Color(white: 0.2) : Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(CriticalDesign.Colors.navyAccent.opacity(colorScheme == .dark ? 0.2 : 0.12), lineWidth: 1)
                    )
                }
                
                // Calculate button — solid fill, no opacity
                Button(action: calculateAndNavigate) {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 32))
                        Text("Calculate")
                            .font(.custom("Poppins-SemiBold", size: 12))
                    }
                    .foregroundColor(.white)
                    .frame(width: 90, height: 90)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : CriticalDesign.Colors.navyAccent.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(
                        color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.1),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                }
                
                // Clear weight — new button
                Button(action: {
                    weightText = ""
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                        Text("Clear")
                            .font(.custom("Poppins-SemiBold", size: 11))
                    }
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .frame(width: 70, height: 90)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(colorScheme == .dark ? Color(white: 0.22) : Color(white: 0.96))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(CriticalDesign.Colors.navyAccent.opacity(colorScheme == .dark ? 0.2 : 0.08), lineWidth: 1)
                    )
                }
            }
            
            // Info text
            Text("Enter weight to calculate medications, equipment sizes, and ventilator settings")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(cardStroke, lineWidth: 1)
        )
        .shadow(
            color: cardShadow(opacity: 0.04),
            radius: colorScheme == .dark ? 10 : 12,
            x: 0,
            y: colorScheme == .dark ? 5 : 6
        )
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsRow: some View {
        HStack(spacing: 12) {
            // Customize Doses
            NavigationLink(destination:
                PedsSettingsViewModern(showingPopup: $showingPopup1)
                    .navigationBarBackground { Color.logoBlue.shadow(radius: 1) }
            ) {
                quickActionButton(
                    icon: "slider.horizontal.3",
                    title: "Customize",
                    subtitle: "Doses",
                    color: CriticalDesign.Colors.accentTeal
                )
            }
            
            // Guidelines
            NavigationLink(destination:
                Pediatric2025GuidelinesView()
                    .navigationBarBackground { Color.logoBlue.shadow(radius: 1) }
            ) {
                quickActionButton(
                    icon: "book.fill",
                    title: "2025",
                    subtitle: "Guidelines",
                    color: CriticalDesign.Colors.accentOrange
                )
            }
        }
    }
    
    private func quickActionButton(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(cardStroke, lineWidth: 1)
        )
        .shadow(
            color: cardShadow(opacity: 0.03),
            radius: 8,
            x: 0,
            y: 4
        )
    }
    
    // MARK: - Age-Weight Reference Section
    
    // Group data into pages of 6 (2 rows × 3 columns)
    private var ageWeightPages: [[(age: String, weight: String, color: Color)]] {
        stride(from: 0, to: Self.ageWeightData.count, by: 6).map { startIndex in
            Array(Self.ageWeightData[startIndex..<min(startIndex + 6, Self.ageWeightData.count)])
        }
    }
    
    @State private var currentPage: Int = 0
    
    private var ageWeightSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack(spacing: 10) {
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.gold
                            : CriticalDesign.Colors.cardBlue
                    )
                    .frame(width: 28, height: 28)
                    .background(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.gold.opacity(0.15)
                            : CriticalDesign.Colors.cardBlue.opacity(0.12)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                Text("Age-Weight Reference")
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Spacer()
                
                // Page indicator
                HStack(spacing: 6) {
                    ForEach(0..<ageWeightPages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index 
                                ? (colorScheme == .dark 
                                    ? CriticalDesign.Colors.gold 
                                    : CriticalDesign.Colors.cardBlue)
                                : (colorScheme == .dark 
                                    ? CriticalDesign.Colors.gold.opacity(0.3) 
                                    : CriticalDesign.Colors.cardBlue.opacity(0.3)))
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Horizontal scrolling pages
            TabView(selection: $currentPage) {
                ForEach(0..<ageWeightPages.count, id: \.self) { pageIndex in
                    ageWeightPage(items: ageWeightPages[pageIndex])
                        .tag(pageIndex)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 200)
        }
    }
    
    private func ageWeightPage(items: [(age: String, weight: String, color: Color)]) -> some View {
        // 2 rows × 3 columns grid
        let rows = stride(from: 0, to: items.count, by: 3).map { startIndex in
            Array(items[startIndex..<min(startIndex + 3, items.count)])
        }
        
        return VStack(spacing: 12) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack(spacing: 12) {
                    ForEach(0..<rows[rowIndex].count, id: \.self) { colIndex in
                        let item = rows[rowIndex][colIndex]
                        ageWeightCard(age: item.age, weight: item.weight, bgColor: item.color)
                            .onTapGesture {
                                weightText = item.weight
                                calculateAndNavigate()
                            }
                    }
                    // Fill remaining space if row has less than 3 items
                    if rows[rowIndex].count < 3 {
                        ForEach(0..<(3 - rows[rowIndex].count), id: \.self) { _ in
                            Color.clear.frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            // Fill second row if only one row of items
            if rows.count < 2 {
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        Color.clear.frame(maxWidth: .infinity).frame(height: 88)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func ageWeightCard(age: String, weight: String, bgColor: Color) -> some View {
        VStack(spacing: 6) {
            Text(age)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(colorScheme == .dark ? .white : CriticalDesign.Colors.cardBlue)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(weight)
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(colorScheme == .dark ? .white : CriticalDesign.Colors.cardBlue)
                
                Text("kg")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : CriticalDesign.Colors.cardBlue.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            colors: [Color.white.opacity(0.9), CriticalDesign.Colors.canvas],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 3, y: 3)
                        .shadow(color: Color.white.opacity(0.9), radius: 6, x: -3, y: -3)
                }
            }
        )
        .overlay(
            // Broselow colored border
            RoundedRectangle(cornerRadius: 12)
                .stroke(bgColor, lineWidth: 1)
        )
    }

    // MARK: - Actions

    private func calculateAndNavigate() {
        guard let weightKg = Double(weightText), weightKg > 0 else {
            showingPopup = true
            return
        }
        viewModel.calculate(weightKg: weightKg)
        hideKeyboard()
        isActive = true
    }
}

