//
//  FavoriteMainView.swift
//  CriticalX
//
//  Created by Dev Expert on 2022/7/25.
//

import SwiftUI

struct FavoriteMainView: View {
    @Binding var searchText: String
    @Binding var selectedCategory: String?
    var embedded: Bool = false

    @State private var arrFavorites: [FavoriteModel] = []
    @State private var arrDrips: [DripsModel] = []
    @State private var isActive = false
    @ObservedObject var selectedDrip: DripValue = DripValue()
    @ObservedObject private var drugRepo = DrugRepository.shared
    
    /// All medications from DrugRepository (with static fallback).
    private var allMedications: [ClinicalPharmacologyDataModel] {
        let repoMeds = drugRepo.medications.map { $0.toClinicalPharmacologyDataModel() }
        return repoMeds.isEmpty ? ClinicalPharmacologyDataModel.pharmacologyData : repoMeds
    }

    // Computed property for filtered favorites
    private var filteredFavorites: [FavoriteModel] {
        var favorites = arrFavorites
        
        // Filter by category
        if let category = selectedCategory {
            favorites = favorites.filter { $0.type == category }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            favorites = favorites.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return favorites
    }

    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // MARK: - List of Favorites
                if arrFavorites.isEmpty {
                    VStack(spacing: 12) {
                        if !embedded { Spacer() }

                        Image(systemName: "star")
                            .font(.system(size: embedded ? 32 : 64, weight: .light))
                            .foregroundColor(.secondary.opacity(0.6))

                        VStack(spacing: 4) {
                            Text("No favorites yet")
                                .font(.system(size: embedded ? 15 : 20, weight: .semibold))
                                .foregroundColor(.primary)

                            Text("Swipe right on items in Meds or Drips to add them")
                                .font(.system(size: embedded ? 13 : 15))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }

                        if !embedded { Spacer() }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: embedded ? nil : .infinity)
                    .padding(.vertical, embedded ? 16 : 0)
                } else {
                    let dripsFavorites = filteredFavorites.filter { $0.type == "Drip" }
                    let medsFavorites = filteredFavorites.filter { $0.type == "Med" }
                    let calcFavorites = filteredFavorites.filter { ["Cal", "Ventilator", "VentMode", "Learn"].contains($0.type) }
                    
                    if embedded {
                        // MARK: - Embedded mode: LazyVStack (works inside a parent ScrollView)
                        LazyVStack(alignment: .leading, spacing: 0) {
                            if dripsFavorites.isEmpty && medsFavorites.isEmpty && calcFavorites.isEmpty {
                                VStack(spacing: 16) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 48, weight: .light))
                                        .foregroundColor(.secondary.opacity(0.6))

                                    Text("No results found")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.primary)

                                    Text("Try adjusting your search or category filter")
                                        .font(.system(size: 15))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                            } else {
                                if !dripsFavorites.isEmpty {
                                    Text("Drips")
                                        .font(.custom(AssetConstants.fontSFProDisplayBold, size: 18))
                                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                        .padding(.vertical, 8)

                                    ForEach(dripsFavorites) { item in
                                        ForEach(arrDrips.filter { $0.title == item.title && item.type == "Drip" }, id: \.id) { drip in
                                            NavigationLink(destination: UpdateDosageView(dripsModel: selectedDrip)) {
                                                DripsListItemView(dripsDetail: drip)
                                            }
                                        }
                                    }
                                }

                                if !medsFavorites.isEmpty {
                                    Text("Meds")
                                        .font(.custom(AssetConstants.fontSFProDisplayBold, size: 18))
                                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                        .padding(.vertical, 8)

                                    ForEach(medsFavorites) { item in
                                        if item.type == "Med" {
                                            ForEach(allMedications.filter { $0.title == item.title }) { med in
                                                NavigationLink(destination: PharamacologyDetailsView(data: med)) {
                                                    PharmacologyListView(item: med)
                                                }
                                            }
                                        }
                                    }
                                }

                                if !calcFavorites.isEmpty {
                                    Text("Calculators")
                                        .font(.custom(AssetConstants.fontSFProDisplayBold, size: 18))
                                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                        .padding(.vertical, 8)

                                    ForEach(calcFavorites) { item in
                                        NavigationLink(destination: destinationView(for: item.title)) {
                                            CalculatorFavoriteRow(title: item.title)
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        // MARK: - Standalone mode: List (default, used in FavoritesView)
                        List {
                            if dripsFavorites.isEmpty && medsFavorites.isEmpty && calcFavorites.isEmpty {
                                VStack(spacing: 16) {
                                    Spacer()

                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 48, weight: .light))
                                        .foregroundColor(.secondary.opacity(0.6))

                                    Text("No results found")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.primary)

                                    Text("Try adjusting your search or category filter")
                                        .font(.system(size: 15))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)

                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                if !dripsFavorites.isEmpty {
                                    Section {
                                        ForEach(dripsFavorites) { item in
                                            ForEach(arrDrips.filter { $0.title == item.title && item.type == "Drip" }, id: \.id) { drip in
                                                ZStack {
                                                    NavigationLink(destination: UpdateDosageView(dripsModel: selectedDrip)) { EmptyView() }
                                                        .opacity(0)

                                                    DripsListItemView(dripsDetail: drip)
                                                        .swipeActions(edge: .trailing) {
                                                            Button(action: {
                                                                selectedDrip.value = drip
                                                                isActive = true
                                                            }) {
                                                                Text("Update Dosages")
                                                            }
                                                            .tint(.yellowColor)
                                                        }
                                                        .swipeActions(edge: .leading) {
                                                            Button(role: .destructive) {
                                                                removeFavorite(title: item.title, type: item.type)
                                                            } label: {
                                                                Label("Remove", systemImage: "heart.slash.fill")
                                                            }
                                                        }
                                                }
                                            }
                                        }
                                    } header: {
                                        Text("Drips")
                                            .font(.custom(AssetConstants.fontSFProDisplayBold, size: 18))
                                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                    }
                                }

                                if !medsFavorites.isEmpty {
                                    Section {
                                        ForEach(medsFavorites) { item in
                                            if item.type == "Med" {
                                                ForEach(allMedications.filter { $0.title == item.title }) { med in
                                                    ZStack {
                                                        NavigationLink(destination: PharamacologyDetailsView(data: med)) { EmptyView() }
                                                            .opacity(0)

                                                        PharmacologyListView(item: med)
                                                            .swipeActions(edge: .leading) {
                                                                Button(role: .destructive) {
                                                                    removeFavorite(title: item.title, type: item.type)
                                                                } label: {
                                                                    Label("Remove", systemImage: "heart.slash.fill")
                                                                }
                                                            }
                                                    }
                                                    .padding(.horizontal, -16)
                                                    .listRowBackground(Color.clear)
                                                    .listRowSeparator(.hidden)
                                                }
                                            }
                                        }
                                    } header: {
                                        Text("Meds")
                                            .font(.custom(AssetConstants.fontSFProDisplayBold, size: 18))
                                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                    }
                                }

                                // MARK: - Calculator Favorites
                                if !calcFavorites.isEmpty {
                                    Section {
                                        ForEach(calcFavorites) { item in
                                            NavigationLink(destination: destinationView(for: item.title)) {
                                                CalculatorFavoriteRow(title: item.title)
                                            }
                                            .swipeActions(edge: .leading) {
                                                Button(role: .destructive) {
                                                    removeFavorite(title: item.title, type: item.type)
                                                } label: {
                                                    Label("Remove", systemImage: "heart.slash.fill")
                                                }
                                            }
                                            .listRowBackground(Color.clear)
                                        }
                                    } header: {
                                        Text("Calculators")
                                            .font(.custom(AssetConstants.fontSFProDisplayBold, size: 18))
                                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                    }
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .background(Color(.systemGroupedBackground))
                    }
                }
            }
        }
        .onAppear {
            loadDripData()
            loadFavoriteData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesCleared"))) { _ in
            loadFavoriteData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesChanged"))) { _ in
            loadFavoriteData()
        }
    }

    // MARK: - Load Drip Data
    private func loadDripData() {
        // Primary: DrugRepository (synced/bundled JSON)
        let repoDrips = drugRepo.drips.map { $0.toDripsModel() }
        if !repoDrips.isEmpty {
            arrDrips = repoDrips
            return
        }
        // Fallback: UserDefaults or Calculator.plist (legacy)
        if let savedDrips = UserDefaults.standard.array(forKey: "drip_list") as? [Any] {
            arrDrips = savedDrips.map { DripsModel(drip: $0 as AnyObject) }
        } else if let url = Bundle.main.url(forResource: "Calculator", withExtension: "plist"),
                  let defaultDrips = NSArray(contentsOf: url) as? [Any] {
            arrDrips = defaultDrips.map { DripsModel(drip: $0 as AnyObject) }
        }
    }

    // MARK: - Load Favorites Data
    private func loadFavoriteData() {
        if let savedFavorites = UserDefaults.standard.array(forKey: "favorites_list") as? [Any] {
            var allFavorites = savedFavorites.map { FavoriteModel(favorite: $0 as AnyObject) }
            allFavorites.reverse()
            
            // Remove duplicates - keep first occurrence (most recent after reverse)
            var seen = Set<String>()
            arrFavorites = allFavorites.filter { favorite in
                let key = "\(favorite.title)-\(favorite.type)"
                if seen.contains(key) {
                    return false
                }
                seen.insert(key)
                return true
            }
        }
    }
    
    // MARK: - Remove Individual Favorite
    private func removeFavorite(title: String, type: String) {
        togleFavorites(title: title, type: type, isFavorite: false)
        loadFavoriteData()
    }

    // MARK: - Calculator Destination View
    @ViewBuilder
    private func destinationView(for title: String) -> some View {
        switch title {
        // Neumorphic redesigned calculators
        case "P/F Ratio":
            PFRatioView()
        case "Estimated Allowable Blood Loss (ABL)":
            AllowableBloodLossView(data: clinicalCalculatorData.estimatedAllowableBloodLossDetails)
        case "RSBI":
            RSBIView(data: clinicalCalculatorData.RSBISegmentDetails)
        case "Pregnancy Calculator":
            PregnencyCalculatorView()
        case "Ventilator Optimization":
            VentilatorOptimizationView()
        case "O2 Cylinder Calculator":
            TwoTankCalculatorView()
        case "Check My Drip":
            CheckMyDrip_New(data: clinicalCalculatorData.checkmyDripSegmentDetails)
        case "Free Water Deficit":
            FreeWaterDeficitView()
            
        // Other calculators
        case "Body Mass Index":
            BMIView()
        case "Ideal Body Weight":
            IdealBodyWeightView()
        case "Anion Gap Calculator":
            AnionGapview(data: clinicalCalculatorData.AnionGapSegmentDetails)
        case "Bicarbonate Deficit":
            BicarbonateView(data: clinicalCalculatorData.BicarbDeficitSegmentDetails)
        case "FeNa":
            FenaView()
        case "CRRT Calculator":
            CRRTDosingView()
        case "Consensus Formula":
            ConsensusView()
        case "IV Rate Calculator":
            IVDripRateView()
        case "ABG Calculator":
            ABGCalculatorStandalone()
        case "MAP | CPP":
            MAP_ICPView()
        case "LOX Calculator":
            LoxcalculatorView()
        case "Parkland Formula":
            ParkLandFormulaView()
        case "Shock Index":
            ShockIndexView()
        case "tPA Dose Calculator":
            TPADosingView(data: clinicalCalculatorData.tPADoseSegmentDetails)
        case "Winters Formula":
            WinterFormulaView(data: clinicalCalculatorData.WintersSegmentDetails)
        case "Urine Output":
            UrineOutputView(data: clinicalCalculatorData.UrineOutputSegmentDetails)
            
        // RSI Calculator
        case "RSI":
            RSIIMainView()

        // Hamilton T1
        case "Hamilton T1":
            HamiltonT1VentilatorView()

        // Vent mode favorites
        case "Assist-Control":
            AssistControlDetailView()
        case "SIMV":
            SynchronizedIntermittentDetailView()
        case "Pressure Support":
            PressureSupportVenDetailView()
        case "Pressure Control":
            PressureControlVenDetailView()
        case "APRV":
            AirwayPressureDeatilView()
        case "BiLevel":
            BilevelPositiveDetailView()
        case "CPAP":
            ContinousPositiveDetailView()
        case "IRV":
            InverseRatioDetailView()
        case "PRVC":
            PressureRegulatedVolDetailView()
        case "ASV":
            HamiltonVent()
        case "IMV":
            IntermittentDetailView()

        // Clinical section favorites
        case "Ventilator Management":
            VentManagemnetTableView()

        default:
            // Fallback for unrecognized calculators
            Text("Calculator not found: \(title)")
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Calculator Favorite Row
struct CalculatorFavoriteRow: View {
    let title: String
    
    private var iconName: String {
        switch title {
        case "P/F Ratio": return "lungs.fill"
        case "Estimated Allowable Blood Loss (ABL)": return "drop.fill"
        case "RSBI": return "waveform.path.ecg"
        case "Pregnancy Calculator": return "figure.stand.dress"
        case "Ventilator Optimization": return "wind"
        case "O2 Cylinder Calculator": return "cylinder.fill"
        case "Check My Drip": return "iv.bag"
        case "Free Water Deficit": return "drop.triangle.fill"
        case "Body Mass Index": return "scalemass.fill"
        case "Ideal Body Weight": return "figure.stand"
        case "Anion Gap Calculator": return "atom"
        case "Bicarbonate Deficit": return "testtube.2"
        case "FeNa": return "drop.degreesign.fill"
        case "CRRT Calculator": return "arrow.triangle.2.circlepath"
        case "Consensus Formula": return "flame.fill"
        case "IV Rate Calculator": return "drop.fill"
        case "ABG Calculator": return "waveform.path.ecg.rectangle"
        case "MAP | CPP": return "heart.fill"
        case "LOX Calculator": return "cylinder"
        case "Parkland Formula": return "flame.fill"
        case "Shock Index": return "bolt.heart.fill"
        case "tPA Dose Calculator": return "syringe.fill"
        case "Winters Formula": return "chart.line.uptrend.xyaxis"
        case "Urine Output": return "drop.degreesign.fill"
        case "RSI": return "syringe.fill"
        case _ where title.hasPrefix("Hamilton T1"): return "lungs.fill"
        case "Ventilator Management": return "waveform.path"
        case "Assist-Control", "SIMV", "PRVC", "IMV": return "waveform.path"
        case "Pressure Support", "Pressure Control": return "gauge.with.dots.needle.33percent"
        case "APRV", "BiLevel", "CPAP": return "wind"
        case "IRV": return "arrow.left.arrow.right"
        case "ASV": return "gearshape.2.fill"
        default: return "function"
        }
    }

    private var iconColor: Color {
        switch title {
        case "P/F Ratio": return .blue
        case "Estimated Allowable Blood Loss (ABL)": return .red
        case "RSBI": return .green
        case "Pregnancy Calculator": return .purple
        case "Ventilator Optimization": return .cyan
        case "O2 Cylinder Calculator": return .teal
        case "Check My Drip": return .orange
        case "Free Water Deficit": return .blue
        case "ABG Calculator": return .indigo
        case "MAP | CPP": return .pink
        case "LOX Calculator": return .mint
        case "Parkland Formula": return .orange
        case "Shock Index": return .red
        case "tPA Dose Calculator": return .purple
        case "Winters Formula": return .teal
        case "Body Mass Index": return .green
        case "Ideal Body Weight": return .cyan
        case "Anion Gap Calculator": return .orange
        case "Bicarbonate Deficit": return .blue
        case "FeNa": return .purple
        case "Urine Output": return .yellow
        case "CRRT Calculator": return .indigo
        case "Consensus Formula": return .orange
        case "IV Rate Calculator": return .teal
        case "RSI": return .red
        case _ where title.hasPrefix("Hamilton T1"): return .teal
        case "Ventilator Management": return .blue
        case "Assist-Control", "SIMV", "PRVC", "IMV": return .blue
        case "Pressure Support", "Pressure Control": return .orange
        case "APRV", "BiLevel", "CPAP": return .purple
        case "IRV": return .red
        case "ASV": return .purple
        default: return .accentColor
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Clinical Calculator")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            // NavigationLink already provides a chevron, so we don't need one here
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
struct FavoriteMainView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMainView(searchText: .constant(""), selectedCategory: .constant(nil))
    }
}
