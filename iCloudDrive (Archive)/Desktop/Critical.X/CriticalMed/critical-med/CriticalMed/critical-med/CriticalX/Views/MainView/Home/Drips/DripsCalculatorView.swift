//
//  DripsCalculatorView.swift
//  CriticalX
//
//  New clean Drips Calculator with modular design.
//  Follows PFRatioView pattern for consistency.
//

import SwiftUI
// import Lottie  // Uncomment when Lottie package is resolved

// MARK: - Drips Calculator View

struct DripsCalculatorView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Drug Data
    let dripsDetail: DripsModel
    
    // MARK: - Customization Manager
    @ObservedObject private var customizationManager = DripsCustomizationManager.shared
    @State private var showDoseEditor = false
    
    // MARK: - State
    @State private var isAppearing = false
    @State private var showResult = false
    
    // MARK: - Scroll & Ticker Animation State
    @State private var scrollViewContentOffset: CGFloat = 0
    @State private var viewportHeight: CGFloat = 600
    @State private var displayedInfusionRate: Double = 0
    @State private var hasAnimatedInfusionRateForCurrentResult: Bool = false
    @State private var infusionRateBlockFrame: CGRect = .zero
    
    // MARK: - Scroll Animation State
    @State private var heroTitleVisible: Bool = true
    
    /// Progress from 0 (title in hero) to 1 (title in navbar)
    private var collapseProgress: CGFloat {
        heroTitleVisible ? 0 : 1
    }
    
    // Concentration inputs
    @State private var totalDoseField: String = ""
    @State private var bagVolumeField: String = ""
    
    // Dose/Rate inputs
    @State private var weightField: String = ""
    @State private var doseField: String = ""
    @State private var selectedWeightUnit: WeightUnit = .kg
    @State private var showWeightSavedConfirmation: Bool = false
    
    /// The weight in kg for calculations (always converts to kg)
    /// SAFETY: Returns nil if no valid weight - prevents silent defaults causing dosing errors
    private var weightInKg: Double? {
        if let value = Double(weightField), value > 0 {
            return selectedWeightUnit == .kg ? value : value / 2.20462
        }
        // Return patient context weight if available, otherwise nil (no silent default)
        return patientContext.weightKg
    }
    
    // Calculation result
    @State private var calculationResult: DripCalculationResult?
    
    // Validation
    @State private var showingPopup = false
    @State private var showErrorReport = false
    @State private var showDripShareSheet = false
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case totalDose, bagVolume, weight, dose
    }
    
    // Global patient context for weight sync
    @ObservedObject private var patientContext = GlobalPatientContext.shared
    
    /// Check if this drip has been customized
    private var isCustomized: Bool {
        customizationManager.isModified(dripName: dripsDetail.title)
    }
    
    /// Get display values (custom if modified, otherwise original)
    private var displayTotalDose: String {
        customizationManager.getDisplayTotalDose(for: dripsDetail.title, originalTotalDose: dripsDetail.totalDose)
    }
    
    private var displayBagVolume: String {
        customizationManager.getDisplayBagVolume(for: dripsDetail.title, originalBagVolume: dripsDetail.bagVolume)
    }
    
    private var displayMinDose: String {
        customizationManager.getDisplayMinDose(for: dripsDetail.title, originalMinDose: dripsDetail.minDose)
    }
    
    private var displayMaxDose: String {
        customizationManager.getDisplayMaxDose(for: dripsDetail.title, originalMaxDose: dripsDetail.maxDose)
    }
    
    private var displayUnit: String {
        customizationManager.getDisplayUnit(for: dripsDetail.title, originalUnit: dripsDetail.unit)
    }
    
    // MARK: - Adaptive Colors
    // Using DarkModeHelpers and CriticalDesign for theme-aware colors
    private var textPrimary: Color { CriticalDesign.Adaptive.textPrimary(for: colorScheme) }
    private var textSecondary: Color { CriticalDesign.Adaptive.textSecondary(for: colorScheme) }
    private var textTertiary: Color { CriticalDesign.Adaptive.textTertiary(for: colorScheme) }
    private var textMuted: Color { colorScheme == .dark ? .white.opacity(0.3) : Color(red: 0.42, green: 0.49, blue: 0.54) }
    private var navyPrimary: Color { CriticalDesign.Adaptive.textPrimary(for: colorScheme) }
    private var navyAccent: Color { colorScheme == .dark ? Color.white.opacity(0.85) : CriticalDesign.Colors.cardBlue }
    // White/silver accent — clean clinical look that stays readable on dark cards
    private var accentTeal: Color { colorScheme == .dark ? Color.white.opacity(0.85) : CriticalDesign.Colors.cardBlue }
    private let accentGold = CriticalDesign.Colors.gold
    private let accentRed = CriticalDesign.Colors.accentRed

    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    /// Adaptive gradient overlay for cards (subtle in both modes)
    private var profileCardBlueGradient: LinearGradient {
        if colorScheme == .dark {
            // Subtle white overlay in dark mode
            return LinearGradient(
                colors: [Color.white.opacity(0.03), Color.clear, Color.black.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            // Light mode overlay
            return LinearGradient(
                colors: [Color.white.opacity(0.04), Color.clear, Color.black.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    /// Adaptive card background
    private var cardBackground: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.cardBlue
            : Color.white.opacity(0.8)
    }

    /// Adaptive card stroke
    private var cardStroke: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.goldMid.opacity(0.3)
            : navyAccent.opacity(0.08)
    }

    /// Adaptive shadow color
    private func cardShadow(opacity: Double = 0.04) -> Color {
        Color.black.opacity(colorScheme == .dark ? opacity * 3 : opacity)
    }
    
    // MARK: - Info Sections for IconTabBar
    private var infoSections: [(title: String, icon: String, content: String)] {
        [
            ("Drug Class", "pills.fill", dripsDetail.drugClass),
            ("Indications", "list.bullet.clipboard.fill", dripsDetail.indications),
            ("What to Know", "lightbulb.fill", dripsDetail.criticalInfo)
        ]
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Adaptive background
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            GeometryReader { viewportGeo in
                TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                VStack(spacing: 20) {
                    // MARK: - Hero Section (Refresh moved to Dose & Rate card; Feedback/Heart in toolbar)
                    heroSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)
                    
                    // MARK: - Drug Info Tabs
                    IconTabBar(sections: infoSections)
                        .padding(.horizontal, 20)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)
                    
                    // MARK: - Dose Range Reference
                    doseRangeCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)
                    
                    DripsCalculatorSectionDivider(title: "Concentration")
                        .padding(.horizontal, 20)
                        .opacity(isAppearing ? 1 : 0)
                    
                    // MARK: - Concentration Card
                    concentrationCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)
                    
                    DripsCalculatorSectionDivider(title: "Infusion Rate")
                        .padding(.horizontal, 20)
                        .opacity(isAppearing ? 1 : 0)
                    
                    // MARK: - Dose & Rate Card
                    doseRateCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)
                    
                    // MARK: - Calculate Button
                    calculateButton
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)
                    
                    // MARK: - Result Section
                    if showResult, let result = calculationResult {
                        DripsCalculatorSectionDivider(title: "Results")
                            .padding(.horizontal, 20)
                        
                        resultCard(result: result)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.95).combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
                }
                .onAppear { viewportHeight = viewportGeo.size.height }
                .onChange(of: viewportGeo.size.height) { viewportHeight = $0 }
                .onTapGesture {
                    focusedField = nil
                }
                .dismissKeyboardOnScroll()
                .onPreferenceChange(InfusionRateBlockFrameKey.self) { frame in
                    infusionRateBlockFrame = frame
                    guard let result = calculationResult else { return }
                    // Visible when infusion rate block is in the scroll viewport (scrollView space: 0..<viewportHeight)
                    let visible = frame.minY < viewportHeight && frame.maxY > 0
                    if visible && !hasAnimatedInfusionRateForCurrentResult {
                        hasAnimatedInfusionRateForCurrentResult = true
                        withAnimation(.easeIn(duration: 1.4)) {
                            displayedInfusionRate = result.infusionRate
                        }
                    }
                }
            }
            
            // Floating weight popover button (only for weight-based drips)
            if dripsDetail.requiresWeight {
                FloatingPatientContextButton(alignment: .bottomTrailing, padding: 20)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                // Navigation arrows
                Button(action: { moveToPreviousField() }) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(navyAccent)
                
                Button(action: { moveToNextField() }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(navyAccent)
                
                Spacer()
                
                // Show Save Weight button when weight field is focused
                if focusedField == .weight {
                    Button(action: saveWeightWithConfirmation) {
                        Text("Save")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(CriticalDesign.Colors.cardBlue)
                            )
                    }
                }
                
                // Done button - always visible
                Button(action: dismissKeyboard) {
                    Text("Done")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(navyAccent)
                }
            }
        }
        .onAppear {
            initializeFields()
            withAnimation(.easeOut(duration: 0.6).delay(0.1)) {
                isAppearing = true
            }
        }
        // Sync weight when GlobalPatientContext changes externally
        .onChange(of: patientContext.weightKg) { newWeight in
            if let w = newWeight {
                // Display in user's selected unit
                let displayValue = selectedWeightUnit == .kg ? w : w * 2.20462
                let newWeightStr = String(format: "%.1f", displayValue)
                // Only update if different to avoid loops
                if weightField != newWeightStr {
                    weightField = newWeightStr
                }
            }
        }
        // Sync weight unit when GlobalPatientContext unit changes
        .onChange(of: patientContext.weightUnit) { newUnit in
            if newUnit != selectedWeightUnit {
                // Convert current weight to new unit
                if let currentValue = Double(weightField), currentValue > 0 {
                    if newUnit == .kg && selectedWeightUnit == .lbs {
                        weightField = String(format: "%.1f", currentValue / 2.20462)
                    } else if newUnit == .lbs && selectedWeightUnit == .kg {
                        weightField = String(format: "%.1f", currentValue * 2.20462)
                    }
                }
                selectedWeightUnit = newUnit
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                LiquidGlassBackButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    if showResult {
                        Button(action: { showDripShareSheet = true }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.85) : CriticalDesign.Colors.cardBlue)
                                .frame(width: 44, height: 44)
                        }
                        .accessibilityLabel("Send calculation to a colleague")
                    }
                    Button(action: {
                        haptic.impactOccurred()
                        showErrorReport = true
                    }) {
                        Image(systemName: "exclamationmark.bubble")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.85) : CriticalDesign.Colors.cardBlue)
                            .frame(width: 44, height: 44)
                    }
                    CriticalFavoriteButton(title: dripsDetail.title, type: "Drip")
                }
            }
            ToolbarItem(placement: .principal) {
                // Animated title that fades in when hero title scrolls off
                Text(dripsDetail.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : CriticalDesign.Colors.cardBlue)
                    .opacity(heroTitleVisible ? 0 : 1)
                    .scaleEffect(heroTitleVisible ? 0.8 : 1.0)
                    .animation(.easeOut(duration: 0.25), value: heroTitleVisible)
            }
        }
        .fullScreenCover(isPresented: $showingPopup) {
            HoldOnPopupView(title: "Missing Values", message: "Please enter all required fields to calculate.")
                .background(BackgroundClearView())
        }
        .sheet(isPresented: $showDoseEditor) {
            DripsEditorSheet(dripsDetail: dripsDetail) {
                // Reload fields with updated values
                initializeFields()
            }
        }
        .sheet(isPresented: $showErrorReport) {
            ErrorReportView.forDrip(name: dripsDetail.title)
        }
        .sheet(isPresented: $showDripShareSheet) {
            if let result = calculationResult {
                ActivityViewController(items: [
                    ClinicalShareHelper.dripResultMessage(
                        drugName: dripsDetail.title,
                        infusionRate: formatInfusionRateForDisplay(result.infusionRate),
                        concentration: "\(result.concentration) \(result.concentrationUnit)",
                        dose: doseField + " " + dripsDetail.unit,
                        weight: weightInKg.map { String(format: "%.1f", $0) } ?? ""
                    )
                ])
            }
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            // Icon with drip animation (no circle background)
            ZStack {
                Image("IV Bag 3D")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)
                
                // Drip animation positioned at bottom of IV bag icon
                DripDropAnimation(color: Color(red: 0.2, green: 0.6, blue: 0.95))
                    .frame(width: 18, height: 40)
                    .offset(y: 55)
            }
            
            VStack(spacing: 6) {
                // Title with visibility tracking
                Text(dripsDetail.title)
                    .font(Font.custom("Poppins-Bold", size: 32))
                    .foregroundColor(textPrimary)
                    .opacity(heroTitleVisible ? 1 : 0)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.frame(in: .global).minY) { newValue in
                                    // When title scrolls above safe area (approx 100pt from top), show navbar title
                                    let threshold: CGFloat = 120
                                    let isVisible = newValue > threshold
                                    if isVisible != heroTitleVisible {
                                        withAnimation(.easeOut(duration: 0.25)) {
                                            heroTitleVisible = isVisible
                                        }
                                    }
                                }
                        }
                    )
                
                Text(dripsDetail.brandName)
                    .font(Font.custom("Poppins-Medium", size: 15))
                    .foregroundColor(accentRed)
                    .opacity(heroTitleVisible ? 1 : 0.3)
            }
            
            // Customized indicator banner (informational only; edit is on Dosing Range card)
            if isCustomized {
                HStack(spacing: 6) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 12))
                    Text("Customized for your protocol")
                        .font(.custom("Poppins-Medium", size: 11))
                    Spacer()
                }
                .foregroundColor(navyAccent)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(navyAccent.opacity(0.1))
                )
                .padding(.horizontal, 20)
            }
            
            // Clinical Pearl Card
            HStack(alignment: .top, spacing: 12) {
                Image("LogoMonogram")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)

                Text("Calculate precise infusion rates based on concentration and desired dose. Always verify calculations before administration.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isCustomized ? navyAccent.opacity(0.3) : cardStroke, lineWidth: 1)
            )
            .shadow(color: cardShadow(opacity: 0.04), radius: colorScheme == .dark ? 8 : 10, x: 0, y: colorScheme == .dark ? 4 : 5)
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Dose Range Card
    private var doseRangeCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(navyAccent)
                
                Text("Dosing Range")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                if isCustomized {
                    Text("(Custom)")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(navyAccent)
                }
                
                Spacer()
                
                // Edit button
                Button(action: {
                    haptic.impactOccurred()
                    showDoseEditor = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(isCustomized ? navyAccent : navyAccent.opacity(0.5))
                }
            }
            
            HStack(spacing: 0) {
                // Min column
                VStack(spacing: 4) {
                    Text("Min")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(textTertiary)
                    Text(displayMinDose)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(accentRed)
                    
                    // Show original if different (or placeholder for alignment)
                    if isCustomized && displayMinDose != dripsDetail.minDose {
                        Text("was \(dripsDetail.minDose)")
                            .font(.custom("Poppins-Regular", size: 10))
                            .foregroundColor(textMuted)
                    } else if isCustomized {
                        Text(" ")
                            .font(.custom("Poppins-Regular", size: 10))
                    }
                }
                .frame(maxWidth: .infinity)
                
                Rectangle()
                    .fill(textMuted.opacity(0.3))
                    .frame(width: 1, height: 50)
                
                // Max column
                VStack(spacing: 4) {
                    Text("Max")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(textTertiary)
                    Text(displayMaxDose)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(accentRed)
                    
                    // Show original if different (or placeholder for alignment)
                    if isCustomized && displayMaxDose != dripsDetail.maxDose {
                        Text("was \(dripsDetail.maxDose)")
                            .font(.custom("Poppins-Regular", size: 10))
                            .foregroundColor(textMuted)
                    } else if isCustomized {
                        Text(" ")
                            .font(.custom("Poppins-Regular", size: 10))
                    }
                }
                .frame(maxWidth: .infinity)
                
                Rectangle()
                    .fill(textMuted.opacity(0.3))
                    .frame(width: 1, height: 50)
                
                // Unit column
                VStack(spacing: 4) {
                    Text("Unit")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(textTertiary)
                    Text(displayUnit)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(textSecondary)
                    
                    // Placeholder for alignment when customized
                    if isCustomized {
                        Text(" ")
                            .font(.custom("Poppins-Regular", size: 10))
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            if !dripsDetail.standardConcentration.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(navyAccent)
                    
                    Text("Standard: \(dripsDetail.standardConcentration)")
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(textSecondary)
                    
                    Spacer()
                }
                .padding(.top, 8)
            }
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
        .shadow(color: cardShadow(opacity: 0.04), radius: colorScheme == .dark ? 10 : 12, x: 0, y: colorScheme == .dark ? 5 : 6)
        .padding(.horizontal, 20)
    }

    // MARK: - Concentration Card
    private var concentrationCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(navyAccent)
                
                Text("Drug Concentration")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                Spacer()
                
                // Drip animation in concentration card
                DripDropAnimation(color: Color(red: 0.2, green: 0.6, blue: 0.95))
                    .frame(width: 20, height: 40)
            }
            
            // Total Dose Input
            inputRow(
                title: "Total Dose",
                subtitle: "Amount of drug in bag",
                placeholder: dripsDetail.totalDose.isEmpty ? "0" : dripsDetail.totalDose,
                value: $totalDoseField,
                unit: totalDoseUnitLabel,
                accentColor: navyAccent,
                field: .totalDose
            )
            
            // Divider with "into"
            HStack {
                Spacer()
                Text("into")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textMuted)
                Spacer()
            }
            .padding(.vertical, 4)
            
            // Bag Volume Input
            inputRow(
                title: "IV Bag Volume",
                subtitle: "Total fluid volume",
                placeholder: dripsDetail.bagVolume.isEmpty ? "250" : dripsDetail.bagVolume,
                value: $bagVolumeField,
                unit: "mL",
                accentColor: navyAccent,
                field: .bagVolume
            )
            
            // Concentration result preview
            if let conc = liveConcentration {
                HStack {
                    Text("Yields")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(textSecondary)
                    
                    Spacer()
                    
                    Text(conc.formatted)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(accentTeal)
                    
                    Text(conc.unit)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(textSecondary)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(accentTeal.opacity(colorScheme == .dark ? 0.15 : 0.08))
                )
            }
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
        .shadow(color: cardShadow(opacity: 0.04), radius: colorScheme == .dark ? 10 : 12, x: 0, y: colorScheme == .dark ? 5 : 6)
        .padding(.horizontal, 20)
    }

    // MARK: - Dose & Rate Card
    private var doseRateCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                
                Text("Dose & Rate")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                Spacer()
                
                // Reset (refresh) — convenient here next to dose inputs
                Button(action: {
                    haptic.impactOccurred()
                    resetFields()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.cardBlue)
                        .frame(width: 36, height: 36)
                }
            }
            
            // Weight Input (if required)
            if dripsDetail.requiresWeight {
                weightInputRow
                
                Divider()
                    .padding(.vertical, 4)
            }
            
            // Dose Input
            inputRow(
                title: "Desired Dose",
                subtitle: "Target infusion rate",
                placeholder: dripsDetail.minDose,
                value: $doseField,
                unit: dripsDetail.unit,
                accentColor: navyAccent,
                field: .dose
            )
            
            // Quick dose buttons
            quickDoseButtons
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
        .shadow(color: cardShadow(opacity: 0.04), radius: colorScheme == .dark ? 10 : 12, x: 0, y: colorScheme == .dark ? 5 : 6)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Quick Dose Buttons
    private var quickDoseButtons: some View {
        VStack(spacing: 8) {
            Text("Quick Select")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(textTertiary)
            
            HStack(spacing: 12) {
                quickDoseButton(label: "Min", value: dripsDetail.minDose)
                quickDoseButton(label: "Mid", value: midDose)
                quickDoseButton(label: "Max", value: dripsDetail.maxDose)
            }
        }
        .padding(.top, 8)
    }
    
    private func quickDoseButton(label: String, value: String) -> some View {
        let isSelected = doseField == value

        return Button(action: {
            haptic.impactOccurred()
            doseField = value
        }) {
            VStack(spacing: 2) {
                Text(label)
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor(isSelected ? (colorScheme == .dark ? CriticalDesign.Colors.cardBlue : .white.opacity(0.8)) : textTertiary)
                Text(value)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? (colorScheme == .dark ? CriticalDesign.Colors.cardBlue : .white) : navyAccent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSelected {
                        if colorScheme == .dark {
                            // Gold gradient background in dark mode
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [CriticalDesign.Colors.goldLight, CriticalDesign.Colors.goldMid, CriticalDesign.Colors.goldDeep],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        } else {
                            // Blue background in light mode
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(CriticalDesign.Colors.cardBlue)
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(profileCardBlueGradient)
                            }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.white.opacity(0.6))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(
                        isSelected
                            ? LinearGradient(
                                colors: colorScheme == .dark
                                    ? [CriticalDesign.Colors.goldLight.opacity(0.7), CriticalDesign.Colors.gold.opacity(0.5)]
                                    : [Color(hex: "F5E6A3").opacity(0.5), Color(hex: "C9A227").opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [cardStroke],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }
    
    private var midDose: String {
        guard let min = Double(dripsDetail.minDose),
              let max = Double(dripsDetail.maxDose) else {
            return dripsDetail.minDose
        }
        let mid = (min + max) / 2
        if mid == floor(mid) {
            return String(format: "%.0f", mid)
        } else if mid * 10 == floor(mid * 10) {
            return String(format: "%.1f", mid)
        } else {
            return String(format: "%.2f", mid)
        }
    }
    
    // MARK: - Calculate Button
    private var calculateButton: some View {
        Button(action: {
            haptic.impactOccurred()
            focusedField = nil
            performCalculation()
        }) {
            HStack(spacing: 10) {
                Text("Calculate Rate")
                    .font(.custom("Poppins-SemiBold", size: 18))
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : .white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                Group {
                    if colorScheme == .dark {
                        // Gold gradient in dark mode
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [CriticalDesign.Colors.goldLight, CriticalDesign.Colors.goldMid, CriticalDesign.Colors.goldDeep],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    } else {
                        // Blue in light mode
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(CriticalDesign.Colors.cardBlue)
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(profileCardBlueGradient)
                        }
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: colorScheme == .dark
                                ? [CriticalDesign.Colors.goldLight.opacity(0.8), CriticalDesign.Colors.gold.opacity(0.6)]
                                : [Color(hex: "F5E6A3").opacity(0.6), Color(hex: "C9A227").opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(
                color: colorScheme == .dark
                    ? CriticalDesign.Colors.gold.opacity(0.3)
                    : CriticalDesign.Colors.cardBlue.opacity(0.3),
                radius: 12,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(PressableButtonStyle())
        .padding(.horizontal, 20)
    }
    
    /// Format infusion rate for display (matches DripCalculationResult.infusionRateFormatted).
    private func formatInfusionRateForDisplay(_ value: Double) -> String {
        if value < 1 {
            return String(format: "%.2f", value)
        } else if value < 10 {
            return String(format: "%.1f", value)
        } else {
            return String(format: "%.0f", value)
        }
    }

    // MARK: - Result Card
    private func resultCard(result: DripCalculationResult) -> some View {
        VStack(spacing: 20) {
            // Header with red accent dot and drip animation
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(accentRed.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "drop.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(accentRed)
                }
                
                Text("Infusion Results")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(textPrimary)
                
                Spacer()
                
                // Native SwiftUI drip animation - water blue (moved to far right)
                DripDropAnimation(color: Color(red: 0.2, green: 0.6, blue: 0.95))
                    .frame(width: 24, height: 45)
                    .padding(.trailing, 4)
            }
            
            // Main Rate Display (count-up ticker when visible)
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    // Native pulsing dot animation
                    PulsingDot(color: accentRed, size: 8, delay: 0)
                    
                    Text("INFUSION RATE")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(textTertiary)
                        .tracking(1)
                    
                    // Native pulsing dot animation (delayed)
                    PulsingDot(color: accentRed, size: 8, delay: 0.3)
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(formatInfusionRateForDisplay(displayedInfusionRate))
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(accentTeal)
                        .contentTransition(.numericText())
                    
                    Text("mL/hr")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(textSecondary)
                }
                
                if result.estimatedTimeHours > 0 {
                    Text("Est. time: \(result.estimatedTimeFormatted)")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(textSecondary)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: InfusionRateBlockFrameKey.self,
                        value: geo.frame(in: .named("scrollView"))
                    )
                }
            )
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(accentTeal.opacity(colorScheme == .dark ? 0.15 : 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(accentTeal.opacity(0.25), lineWidth: 1)
            )
            
            // Details Grid
            HStack(spacing: 16) {
                detailBox(title: "Concentration", value: result.concentrationFormatted, unit: result.concentrationUnit)
                detailBox(title: "Dose", value: doseField, unit: dripsDetail.unit)
            }
            
            if dripsDetail.requiresWeight {
                HStack(spacing: 16) {
                    // Always show weight in kg for clinical accuracy
                    // Display the actual kg value used in calculation
                    if let weight = weightInKg {
                        detailBox(
                            title: "Weight",
                            value: String(format: "%.1f", weight),
                            unit: "kg"
                        )
                    }
                    
                    // If user entered in lbs, show the original entry for reference
                    if selectedWeightUnit == .lbs {
                        detailBox(
                            title: "Entered",
                            value: weightField,
                            unit: "lbs"
                        )
                    } else {
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: colorScheme == .dark
                            ? [CriticalDesign.Colors.goldMid.opacity(0.6), CriticalDesign.Colors.goldDeep.opacity(0.3), CriticalDesign.Colors.accentTeal.opacity(0.2)]
                            : [accentRed.opacity(0.6), accentRed.opacity(0.2), navyAccent.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(
            color: colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.15) : accentRed.opacity(0.08),
            radius: colorScheme == .dark ? 12 : 16,
            x: 0,
            y: colorScheme == .dark ? 6 : 8
        )
        .padding(.horizontal, 20)
    }
    
    private func detailBox(title: String, value: String, unit: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(textTertiary)

            HStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(textPrimary)

                Text(unit)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color.white.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.goldDeep.opacity(0.3)
                        : accentRed.opacity(0.15),
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - Input Row Builder
    @ViewBuilder
    private func inputRow(
        title: String,
        subtitle: String,
        placeholder: String,
        value: Binding<String>,
        unit: String,
        accentColor: Color,
        field: Field
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(textSecondary)
                    
                    Text(subtitle)
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(accentColor)
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    TextField(placeholder, text: value)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(accentColor)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                        .focused($focusedField, equals: field)
                        .onChange(of: value.wrappedValue) { newValue in
                            // Sync weight to GlobalPatientContext when changed
                            if field == .weight && !newValue.isEmpty {
                                patientContext.setWeight(from: newValue, unit: .kg)
                            }
                        }
                    
                    Text(unit)
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(textMuted)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .frame(maxWidth: 90, alignment: .leading)
                }
            }
        }
    }
    
    // MARK: - Weight Input Row with Unit Toggle
    
    private var weightInputRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Patient Weight")
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundColor(textSecondary)
                        
                        // Saved confirmation
                        if showWeightSavedConfirmation {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12, weight: .bold))
                                Text("Saved!")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            .foregroundColor(CriticalDesign.Colors.gold)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    
                    // Show conversion to kg when using lbs
                    if selectedWeightUnit == .lbs, let value = Double(weightField), value > 0 {
                        Text("= \(String(format: "%.1f", value / 2.20462)) kg for calc")
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(accentTeal)
                    } else if !showWeightSavedConfirmation {
                        Text("Shared for all weight-based drips")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(navyAccent)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    TextField(selectedWeightUnit == .kg ? "80" : "176", text: $weightField)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(navyAccent)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .frame(width: 80)
                        .focused($focusedField, equals: .weight)
                        .onChange(of: weightField) { newValue in
                            // Sync weight to GlobalPatientContext with proper unit
                            if !newValue.isEmpty {
                                patientContext.setWeight(from: newValue, unit: selectedWeightUnit)
                            }
                        }
                    
                    // Unit toggle (kg/lbs) — adaptive colors
                    Button(action: toggleWeightUnit) {
                        Text(selectedWeightUnit.abbreviation)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(colorScheme == .dark && !showWeightSavedConfirmation ? CriticalDesign.Colors.cardBlue : .white)
                            .frame(width: 36, height: 32)
                            .background(
                                Group {
                                    if showWeightSavedConfirmation {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(CriticalDesign.Colors.gold)
                                    } else {
                                        if colorScheme == .dark {
                                            // Gold in dark mode
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [CriticalDesign.Colors.goldLight, CriticalDesign.Colors.goldMid, CriticalDesign.Colors.goldDeep],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                        } else {
                                            // Blue in light mode
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .fill(CriticalDesign.Colors.cardBlue)
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .fill(profileCardBlueGradient)
                                            }
                                        }
                                    }
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: colorScheme == .dark
                                                ? [CriticalDesign.Colors.goldLight.opacity(0.7), CriticalDesign.Colors.gold.opacity(0.5)]
                                                : [Color(hex: "F5E6A3").opacity(0.5), Color(hex: "C9A227").opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                                    .opacity(showWeightSavedConfirmation ? 0 : 1)
                            )
                    }
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showWeightSavedConfirmation)
    }
    
    private func toggleWeightUnit() {
        haptic.impactOccurred()
        
        // Convert current input to the other unit
        if let currentValue = Double(weightField), currentValue > 0 {
            if selectedWeightUnit == .kg {
                // Converting from kg to lbs
                selectedWeightUnit = .lbs
                weightField = String(format: "%.1f", currentValue * 2.20462)
            } else {
                // Converting from lbs to kg
                selectedWeightUnit = .kg
                weightField = String(format: "%.1f", currentValue / 2.20462)
            }
        } else {
            // Just toggle the unit
            selectedWeightUnit = selectedWeightUnit == .kg ? .lbs : .kg
        }
        
        // Update global preference
        patientContext.weightUnit = selectedWeightUnit
    }
    
    private func dismissKeyboard() {
        focusedField = nil
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func saveWeightWithConfirmation() {
        // Save to GlobalPatientContext with proper unit conversion
        patientContext.setWeight(from: weightField, unit: selectedWeightUnit)
        
        // Dismiss keyboard
        dismissKeyboard()
        
        // Haptic feedback
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
        
        // Show confirmation animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            showWeightSavedConfirmation = true
        }
        
        // Hide confirmation after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                showWeightSavedConfirmation = false
            }
        }
    }
    
    // MARK: - Helpers
    
    private var totalDoseUnitLabel: String {
        DripCalculationEngine.totalDoseUnitLabel(for: dripsDetail.unit, drugName: dripsDetail.title)
    }
    
    private var liveConcentration: (formatted: String, unit: String)? {
        guard let totalDose = Double(totalDoseField.isEmpty ? dripsDetail.totalDose : totalDoseField),
              let bagVolume = Double(bagVolumeField.isEmpty ? dripsDetail.bagVolume : bagVolumeField),
              totalDose > 0, bagVolume > 0 else {
            return nil
        }
        
        let result = DripCalculationEngine.calculate(
            drugName: dripsDetail.title,
            unit: dripsDetail.unit,
            dose: 0,
            weight: 0,
            totalDose: totalDose,
            bagVolume: bagVolume
        )
        
        return (result.concentrationFormatted, result.concentrationUnit)
    }
    
    private var currentFieldLabel: String {
        switch focusedField {
        case .totalDose: return "Total Dose"
        case .bagVolume: return "Bag Volume"
        case .weight: return "Weight"
        case .dose: return "Dose"
        case .none: return ""
        }
    }
    
    private func moveToNextField() {
        switch focusedField {
        case .totalDose: focusedField = .bagVolume
        case .bagVolume: focusedField = dripsDetail.requiresWeight ? .weight : .dose
        case .weight: focusedField = .dose
        case .dose, .none: break
        }
    }
    
    private func moveToPreviousField() {
        switch focusedField {
        case .dose: focusedField = dripsDetail.requiresWeight ? .weight : .bagVolume
        case .weight: focusedField = .bagVolume
        case .bagVolume: focusedField = .totalDose
        case .totalDose, .none: break
        }
    }
    
    private func initializeFields() {
        // Use customized values if modified, otherwise use original
        totalDoseField = displayTotalDose.isEmpty ? "" : displayTotalDose
        bagVolumeField = displayBagVolume.isEmpty ? "" : displayBagVolume
        
        // Load weight unit preference from global context
        selectedWeightUnit = patientContext.weightUnit
        
        // Load weight from global patient context in user's preferred unit
        // SAFETY: No default weight - require explicit user entry for safety
        if let w = patientContext.weightKg {
            let displayValue = selectedWeightUnit == .kg ? w : w * 2.20462
            weightField = String(format: "%.1f", displayValue)
        } else {
            weightField = ""  // Leave empty - require user to enter weight explicitly
        }
        doseField = displayMinDose
    }
    
    private func resetFields() {
        // Reset to customized values (or original if not customized)
        totalDoseField = displayTotalDose.isEmpty ? "" : displayTotalDose
        bagVolumeField = displayBagVolume.isEmpty ? "" : displayBagVolume
        doseField = displayMinDose
        showResult = false
        calculationResult = nil
        focusedField = nil
    }
    
    /// Parse a numeric value from a string, stripping units (e.g. "50 mg" or "100 mL") so we never get 0 due to formatting.
    private func parseNumeric(from field: String, fallback: String) -> Double {
        let raw = field.isEmpty ? fallback : field
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        // Allow digits, one decimal point, optional leading minus
        let numericPart = trimmed.prefix(while: { $0.isNumber || $0 == "." || $0 == "-" })
        return Double(String(numericPart)) ?? 0
    }
    
    private func performCalculation() {
        // Validate inputs - use display values as defaults; parse robustly so "50 mg" / "100 mL" work
        let totalDose = parseNumeric(from: totalDoseField, fallback: displayTotalDose)
        let bagVolume = parseNumeric(from: bagVolumeField, fallback: displayBagVolume)
        let dose = parseNumeric(from: doseField, fallback: displayMinDose)
        
        guard totalDose > 0, bagVolume > 0, dose > 0 else {
            showingPopup = true
            return
        }
        
        // SAFETY: Validate weight for weight-based calculations (no silent default)
        guard let weight = weightInKg, weight > 0 else {
            if dripsDetail.requiresWeight {
                showingPopup = true
                return
            }
            // For non-weight-based calcs, use 0 as it won't affect calculation
            performCalculationWithWeight(totalDose: totalDose, bagVolume: bagVolume, dose: dose, weight: 0)
            return
        }
        
        performCalculationWithWeight(totalDose: totalDose, bagVolume: bagVolume, dose: dose, weight: weight)
    }
    
    private func performCalculationWithWeight(totalDose: Double, bagVolume: Double, dose: Double, weight: Double) {
        
        // Perform calculation - weight is always in kg
        let result = DripCalculationEngine.calculate(
            drugName: dripsDetail.title,
            unit: dripsDetail.unit,
            dose: dose,
            weight: weight,
            totalDose: totalDose,
            bagVolume: bagVolume
        )
        
        hasAnimatedInfusionRateForCurrentResult = false
        // Show correct infusion rate immediately so it's never stuck at zero (animation can still run for effect)
        displayedInfusionRate = result.infusionRate
        calculationResult = result

        // Save weight to GlobalPatientContext with proper unit conversion
        if dripsDetail.requiresWeight && !weightField.isEmpty {
            patientContext.setWeight(from: weightField, unit: selectedWeightUnit)
        }

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            showResult = true
        }

        // Count-up animation is optional; displayedInfusionRate already set above so result is never zero
    }
}

// MARK: - Section Divider
struct DripsCalculatorSectionDivider: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String

    private var dividerColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.3)
            : Color(red: 0.7, green: 0.7, blue: 0.75)
    }

    private var textColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.5)
            : Color(red: 0.5, green: 0.5, blue: 0.55)
    }

    var body: some View {
        HStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [dividerColor, Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            Text(title)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(textColor)
                .textCase(.uppercase)
                .tracking(2)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, dividerColor],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Drips Editor Sheet

struct DripsEditorSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    let dripsDetail: DripsModel
    let onSave: () -> Void
    
    @ObservedObject private var customizationManager = DripsCustomizationManager.shared
    
    // Editing state
    @State private var totalDoseField: String = ""
    @State private var bagVolumeField: String = ""
    @State private var minDoseField: String = ""
    @State private var maxDoseField: String = ""
    @State private var startingDoseField: String = ""
    @State private var selectedUnit: String = ""
    @State private var showResetConfirmation = false
    
    private let unitOptions = ["mcg/min", "mg/min", "mcg/hr", "mg/hr", "g/hr", "units/hr", "units/min", "mUnits/min", "mcg/kg/min", "mcg/kg/hr", "mg/kg/hr", "units/kg/hr", "mEq/kg/hr", "ng/kg/min"]
    
    /// Check if current values differ from original
    private var hasChanges: Bool {
        return totalDoseField != dripsDetail.totalDose ||
               bagVolumeField != dripsDetail.bagVolume ||
               minDoseField != dripsDetail.minDose ||
               maxDoseField != dripsDetail.maxDose ||
               selectedUnit != dripsDetail.unit
    }
    
    /// Check if there's an existing customization
    private var hasExistingCustomization: Bool {
        customizationManager.isModified(dripName: dripsDetail.title)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: CriticalDesign.Spacing.lg) {
                        // Header
                        headerSection
                        
                        // Original values reference
                        originalValuesCard
                        
                        // Concentration section
                        concentrationSection
                        
                        // Dosing section
                        dosingSection
                        
                        // Unit selector
                        unitSection
                        
                        // Reset button
                        if hasExistingCustomization {
                            resetButton
                        }
                        
                        Spacer(minLength: CriticalDesign.Spacing.xl)
                    }
                    .padding(.vertical, CriticalDesign.Spacing.lg)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Customize Drip")
                        .font(.custom("Poppins-Bold", size: 17))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCustomization()
                    }
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(hasChanges ? CriticalDesign.Colors.cardBlue : .secondary)
                    .disabled(!hasChanges)
                }
            }
            .alert("Reset to Default?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetToDefault()
                }
            } message: {
                Text("This will restore the original values for \(dripsDetail.title).")
            }
        }
        .onAppear {
            loadCurrentValues()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.sm) {
            Image("IV Bag 3D")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
            
            Text(dripsDetail.title)
                .font(.custom("Poppins-Bold", size: 24))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text(dripsDetail.brandName)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Colors.goldDeep)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Original Values Card
    private var originalValuesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(CriticalDesign.Colors.accentTeal)
                Text("Original Values")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            
            HStack(spacing: 16) {
                originalValueBadge(label: "Dose", value: "\(dripsDetail.totalDose) mg")
                originalValueBadge(label: "Vol", value: "\(dripsDetail.bagVolume) mL")
                originalValueBadge(label: "Range", value: "\(dripsDetail.minDose)-\(dripsDetail.maxDose)")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(CriticalDesign.Colors.accentTeal.opacity(colorScheme == .dark ? 0.15 : 0.08))
        )
        .padding(.horizontal, 20)
    }
    
    private func originalValueBadge(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(CriticalDesign.Colors.accentTeal)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color.white.opacity(0.6))
        )
    }
    
    // MARK: - Concentration Section
    private var concentrationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Concentration")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            HStack(spacing: 16) {
                editorField(label: "Total Dose", value: $totalDoseField, unit: "mg")
                editorField(label: "IV Bag", value: $bagVolumeField, unit: "mL")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(CriticalDesign.Colors.cardBlue.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Dosing Section
    private var dosingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dosing Range")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            HStack(spacing: 16) {
                editorField(label: "Min Dose", value: $minDoseField, unit: selectedUnit)
                editorField(label: "Max Dose", value: $maxDoseField, unit: selectedUnit)
            }
            
            editorField(label: "Starting Dose", value: $startingDoseField, unit: selectedUnit)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(CriticalDesign.Colors.cardBlue.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Unit Section
    private var unitSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Unit")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Menu {
                ForEach(unitOptions, id: \.self) { unit in
                    Button(action: {
                        selectedUnit = unit
                    }) {
                        HStack {
                            Text(unit)
                            if unit == selectedUnit {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedUnit)
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.8))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(CriticalDesign.Colors.cardBlue.opacity(0.1), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Reset Button
    private var resetButton: some View {
        Button(action: {
            showResetConfirmation = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 14, weight: .medium))
                Text("Reset to Default")
                    .font(.custom("Poppins-Medium", size: 14))
            }
            .foregroundColor(.red)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    // MARK: - Editor Field
    private func editorField(label: String, value: Binding<String>, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            
            HStack {
                TextField("0", text: value)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                
                Text(unit)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(CriticalDesign.Colors.cardBlue.opacity(0.05))
            )
        }
    }
    
    // MARK: - Actions
    
    private func loadCurrentValues() {
        // Load from customization if exists, otherwise use original
        if let custom = customizationManager.getCustomDose(for: dripsDetail.title) {
            totalDoseField = custom.totalDose
            bagVolumeField = custom.bagVolume
            minDoseField = custom.minDose
            maxDoseField = custom.maxDose
            startingDoseField = custom.startingDose
            selectedUnit = custom.unit
        } else {
            totalDoseField = dripsDetail.totalDose
            bagVolumeField = dripsDetail.bagVolume
            minDoseField = dripsDetail.minDose
            maxDoseField = dripsDetail.maxDose
            startingDoseField = dripsDetail.minDose
            selectedUnit = dripsDetail.unit
        }
    }
    
    private func saveCustomization() {
        let customDose = CustomDripDose(
            dripName: dripsDetail.title,
            totalDose: totalDoseField,
            bagVolume: bagVolumeField,
            minDose: minDoseField,
            maxDose: maxDoseField,
            startingDose: startingDoseField,
            unit: selectedUnit,
            originalTotalDose: dripsDetail.totalDose,
            originalBagVolume: dripsDetail.bagVolume,
            originalMinDose: dripsDetail.minDose,
            originalMaxDose: dripsDetail.maxDose,
            originalUnit: dripsDetail.unit
        )
        
        customizationManager.saveCustomDose(customDose)
        onSave()
        dismiss()
    }
    
    private func resetToDefault() {
        customizationManager.resetToDefault(dripName: dripsDetail.title)
        loadCurrentValues()
        onSave()
        dismiss()
    }
}

// MARK: - Preview
struct DripsCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DripsCalculatorView(dripsDetail: DripsModel(
                title: "Norepinephrine",
                brandName: "Levophed",
                category: .pressors,
                doseRange: "0.1-30",
                minDose: "0.1",
                maxDose: "30",
                unit: "mcg/kg/min",
                increment: "0.1",
                totalDose: "4",
                bagVolume: "250",
                standardConcentration: "16 mcg/mL",
                drugClass: "Vasopressor / Alpha-1 agonist with some beta-1 activity",
                indications: "Septic shock, cardiogenic shock, hypotension refractory to fluids",
                criticalInfo: "Preferred first-line vasopressor in septic shock per Surviving Sepsis Campaign guidelines"
            ))
        }
    }
}

// MARK: - Pulsing Dot Animation
/// A small dot that pulses with a heartbeat-like animation
struct PulsingDot: View {
    let color: Color
    let size: CGFloat
    var delay: Double = 0
    
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            // Outer pulse ring
            Circle()
                .fill(color.opacity(0.3))
                .frame(width: size * 2, height: size * 2)
                .scaleEffect(isPulsing ? 1.5 : 0.8)
                .opacity(isPulsing ? 0 : 0.6)
            
            // Inner solid dot
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(isPulsing ? 1.1 : 0.9)
        }
        .onAppear {
            withAnimation(
                Animation
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
            ) {
                isPulsing = true
            }
        }
    }
}

// MARK: - Drip Drop Animation
/// An animated drip/drop visual that simulates IV drip falling
struct DripDropAnimation: View {
    let color: Color
    @State private var dropOffset: CGFloat = -20
    @State private var dropOpacity: Double = 1.0
    @State private var dropScale: CGFloat = 0.3
    
    var body: some View {
        ZStack {
            // Drop shape
            Circle()
                .fill(
                    RadialGradient(
                        colors: [color, color.opacity(0.6)],
                        center: .top,
                        startRadius: 0,
                        endRadius: 8
                    )
                )
                .frame(width: 12, height: 12)
                .scaleEffect(dropScale)
                .offset(y: dropOffset)
                .opacity(dropOpacity)
            
            // Splash at bottom
            Ellipse()
                .fill(color.opacity(0.2))
                .frame(width: 20, height: 6)
                .offset(y: 25)
                .scaleEffect(x: dropOpacity < 0.3 ? 1.5 : 0.5)
                .opacity(dropOpacity < 0.3 ? 1 : 0)
        }
        .onAppear {
            startDripAnimation()
        }
    }
    
    private func startDripAnimation() {
        // Reset
        dropOffset = -20
        dropOpacity = 1.0
        dropScale = 0.3
        
        // Animate drop forming
        withAnimation(.easeIn(duration: 0.4)) {
            dropScale = 1.0
        }
        
        // Animate drop falling
        withAnimation(.easeIn(duration: 0.6).delay(0.4)) {
            dropOffset = 25
            dropOpacity = 0
        }
        
        // Repeat
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            startDripAnimation()
        }
    }
}

// MARK: - Infusion Rate Shimmer
/// A shimmer effect that runs across text/content
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.5)
                    .offset(x: phase * geo.size.width * 1.5 - geo.size.width * 0.25)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    Animation
                        .linear(duration: 2)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}
