//
//  LabValueMainView.swift
//  CriticalX
//
//  Created by Macbook 7 on 22/12/2021.
//  Updated with search functionality
//

import SwiftUI

// MARK: - Searchable Lab Item
/// Flattened structure for searching across all lab panels
struct SearchableLabItem: Identifiable {
    let id = UUID()
    let labTitle: String           // e.g., "Sodium"
    let labSubtitle: String        // e.g., "Na+"
    let range: String              // e.g., "135-145"
    let unit: String               // e.g., "mEq/L"
    let panelTitle: String         // e.g., "BMP"
    let panelSubtitle: String      // e.g., "Basic Metabolic Panel"
    let panelImage: String         // e.g., "Tubes"
    let panelIndex: Int            // Index in LabValueDataModel.labValueData
    let labIndex: Int              // Index in panel's btnData array
    let btnData: BtnDataModel      // The actual button data for navigation
    
    /// Combined searchable text
    var searchableText: String {
        "\(labTitle) \(labSubtitle) \(panelTitle) \(panelSubtitle)".lowercased()
    }
}

// MARK: - Lab Search Index
/// Static index of all searchable labs
struct LabSearchIndex {
    static let shared = LabSearchIndex()
    
    let items: [SearchableLabItem]
    
    private init() {
        var allItems: [SearchableLabItem] = []
        
        for (panelIndex, panel) in LabValueDataModel.labValueData.enumerated() {
            for (labIndex, btnData) in panel.labValueDetail.btnData.enumerated() {
                let item = SearchableLabItem(
                    labTitle: btnData.title,
                    labSubtitle: btnData.subTitle,
                    range: btnData.range,
                    unit: btnData.potiency,
                    panelTitle: panel.title,
                    panelSubtitle: panel.subTitle,
                    panelImage: panel.image,
                    panelIndex: panelIndex,
                    labIndex: labIndex,
                    btnData: btnData
                )
                allItems.append(item)
            }
        }
        
        self.items = allItems
    }
    
    /// Search labs by query text
    func search(_ query: String) -> [SearchableLabItem] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }
        
        let lowercaseQuery = query.lowercased()
        let queryWords = lowercaseQuery.split(separator: " ").map(String.init)
        
        return items.filter { item in
            // Match if all query words are found in searchable text
            queryWords.allSatisfy { word in
                item.searchableText.contains(word)
            }
        }.sorted { a, b in
            // Prioritize exact title matches
            let aExact = a.labTitle.lowercased().hasPrefix(lowercaseQuery)
            let bExact = b.labTitle.lowercased().hasPrefix(lowercaseQuery)
            if aExact != bExact { return aExact }
            return a.labTitle < b.labTitle
        }
    }
}

// MARK: - Lab Value Main View
struct LabValueMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var searchText = ""
    @State private var isSearchFocused = false
    @FocusState private var searchFieldFocused: Bool
    
    private let haptic = UIImpactFeedbackGenerator(style: .light)
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    /// Computed search results
    private var searchResults: [SearchableLabItem] {
        LabSearchIndex.shared.search(searchText)
    }
    
    private var isSearching: Bool {
        !searchText.isEmpty
    }
    
    var body: some View {
        ZStack {
            // Neumorphic background
            CriticalDesign.Colors.canvas
                .ignoresSafeArea()
         
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                    
                    // Search Bar
                    searchBar
                        .padding(.horizontal, 20)
                    
                    if isSearching {
                        // Search Results
                        searchResultsSection
                    } else {
                        // Grid of lab panels
                        labPanelsGrid
                    }
                }
                .padding(.bottom, 30)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                LiquidGlassBackButton()
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Icon with gradient fade
            GradientEdgeFadeImage(imageName: "icon-labvalue", size: 100)
            
            // Title
            Text("Lab Values")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Colors.cardBlue)
            
            Text("Reference Ranges & Interpretation")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.top, 20)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
        .animation(.easeOut(duration: 0.4), value: isAppearing)
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(isSearchFocused ? CriticalDesign.Colors.cardBlue : CriticalDesign.Colors.secondary)
            
            TextField("Search labs... (e.g., sodium, troponin)", text: $searchText)
                .focused($searchFieldFocused)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .submitLabel(.search)
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button(action: {
                    haptic.impactOccurred()
                    searchText = ""
                    searchFieldFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
            }
        }
        .padding(CriticalDesign.Spacing.md + 2)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.canvas)
                .shadow(
                    color: isSearchFocused ? CriticalDesign.Colors.cardBlue.opacity(0.15) : Color.black.opacity(0.08),
                    radius: isSearchFocused ? 12 : 8,
                    x: 4, y: 4
                )
                .shadow(color: Color.white.opacity(0.9), radius: 8, x: -4, y: -4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    isSearchFocused ? CriticalDesign.Colors.cardBlue.opacity(0.4) : Color.clear,
                    lineWidth: 2
                )
        )
        .onChange(of: searchFieldFocused) { focused in
            withAnimation(.easeInOut(duration: 0.2)) {
                isSearchFocused = focused
            }
        }
    }
    
    // MARK: - Search Results Section
    private var searchResultsSection: some View {
        VStack(spacing: 16) {
            // Results count
            HStack {
                Text("\(searchResults.count) \(searchResults.count == 1 ? "result" : "results")")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                
                Spacer()
                
                if !searchResults.isEmpty {
                    Text("LAB SEARCH")
                        .font(.custom("Poppins-Bold", size: 10))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(CriticalDesign.Colors.cardBlue)
                        )
                }
            }
            .padding(.horizontal, 20)
            
            if searchResults.isEmpty {
                noResultsView
            } else {
                // Results list
                ForEach(searchResults) { item in
                    NavigationLink(
                        destination: BtnDetailView(
                            item: item.labIndex,
                            data: item.btnData
                        )
                        .navigationBarBackground { CriticalDesign.Colors.cardBlue }
                    ) {
                        LabSearchResultCard(item: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    // MARK: - No Results View
    private var noResultsView: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            
            VStack(spacing: 4) {
                Text("No labs found")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text("Try a different search term")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    // MARK: - Lab Panels Grid
    private var labPanelsGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(Array(LabValueDataModel.labValueData.enumerated()), id: \.offset) { index, item in
                NavigationLink(destination: cellDetaillView(data: item).navigationBarBackground { CriticalDesign.Colors.cardBlue }) {
                    LabValueCellView(item: index)
                }
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 20)
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.8).delay(0.1 + Double(index) * 0.03),
                    value: isAppearing
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Lab Search Result Card (Moment Style)
/// A moment-style card for lab search results
struct LabSearchResultCard: View {
    @Environment(\.colorScheme) var colorScheme
    let item: SearchableLabItem

    var body: some View {
        HStack(spacing: 0) {
            // Accent bar
            RoundedRectangle(cornerRadius: 2)
                .fill(CriticalDesign.Colors.cardBlue)
                .frame(width: 4)
            
            HStack(spacing: 14) {
                // Panel icon
                ZStack {
                    Circle()
                        .fill(CriticalDesign.Colors.cardBlue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(item.panelImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    // Lab title
                    Text(item.labTitle)
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .lineLimit(1)
                    
                    // Subtitle & Panel
                    HStack(spacing: 6) {
                        if !item.labSubtitle.isEmpty {
                            Text(item.labSubtitle)
                                .font(.custom("Poppins-Medium", size: 12))
                                .foregroundColor(CriticalDesign.Colors.accentOrange)
                        }
                        
                        Text("•")
                            .font(.system(size: 8))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        
                        Text(item.panelTitle)
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                }
                
                Spacer()
                
                // Range badge
                VStack(alignment: .trailing, spacing: 2) {
                    Text(item.range)
                        .font(.custom("Poppins-Bold", size: 15))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                    
                    if !item.unit.isEmpty {
                        Text(item.unit)
                            .font(.custom("Poppins-Medium", size: 10))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .padding(.leading, 8)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 4, y: 4)
                .shadow(color: Color.white, radius: 8, x: -4, y: -4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    colorScheme == .dark
                        ? Color(red: 0.96, green: 0.71, blue: 0.0) // Gold stroke in dark mode
                        : CriticalDesign.Colors.cardBlue.opacity(0.15),
                    lineWidth: colorScheme == .dark ? 2 : 1
                )
        )
    }
}

// MARK: - Preview
struct LabValueMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LabValueMainView()
        }
    }
}
