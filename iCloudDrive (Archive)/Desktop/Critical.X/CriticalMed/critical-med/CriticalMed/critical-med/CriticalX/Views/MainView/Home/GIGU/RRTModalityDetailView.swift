//
//  RRTModalityDetailView.swift
//  CriticalX
//
//  Premium Light Theme - RRT Modality Detail View
//  Following ECMOView design patterns
//

import SwiftUI

// MARK: - RRT Modality Detail View
struct RRTModalityDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    let modality: RRTModality
    @State private var showAllPearls = false
    @State private var selectedImage = ""
    @State private var showImageViewer = false
    
    // MARK: - Formatted Content
    private var overviewContent: AttributedString {
        ContentFormatter.format(
            modality.overview,
            headings: [],
            isDarkMode: colorScheme == .dark
        )
    }
    
    private var mechanismContent: AttributedString {
        ContentFormatter.format("""
        Mechanism:
        \(modality.mechanism)
        
        Details:
        \(modality.mechanismDetail)
        """, headings: ["Mechanism:", "Details:"], isDarkMode: colorScheme == .dark)
    }
    
    private var accessContent: AttributedString {
        ContentFormatter.format("""
        Access Requirements:
        \(modality.accessRequirements)
        
        Typical Settings:
        \(modality.typicalSettings)
        """, headings: ["Access Requirements:", "Typical Settings:"], isDarkMode: colorScheme == .dark)
    }
    
    private var indicationsContent: AttributedString {
        let indicationsList = modality.indications.map { "• \($0)" }.joined(separator: "\n")
        return ContentFormatter.format("""
        Clinical Indications:
        \(indicationsList)
        """, headings: ["Clinical Indications:"], isDarkMode: colorScheme == .dark)
    }
    
    private var contraindicationsContent: AttributedString {
        let list = modality.contraindications.map { "• \($0)" }.joined(separator: "\n")
        return ContentFormatter.format("""
        Relative Contraindications:
        \(list)
        """, headings: ["Relative Contraindications:"], isDarkMode: colorScheme == .dark)
    }
    
    // Clinical Pearls content
    private var pearlItems: [CriticalPearlItem] {
        modality.clinicalPearls.enumerated().map { index, pearl in
            CriticalPearlItem(
                header: "Pearl \(index + 1)",
                content: pearl
            )
        }
    }
    
    var body: some View {
        ZStack {
            // Premium light background
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    HStack {
                        Spacer()
                        PremiumLightCloseButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }
                    
                    // MARK: - Title Section (Hero Header)
                    VStack(spacing: 16) {
                        // Icon with glass effect
                        ZStack {
                            if colorScheme == .dark {
                                Circle()
                                    .fill(CriticalDesign.Colors.cardBlue)
                                    .frame(width: 140, height: 140)
                            } else {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 140, height: 140)
                                Circle()
                                    .fill(Color.white.opacity(0.5))
                                    .frame(width: 140, height: 140)
                            }

                            Circle()
                                .stroke(modality.type.color.opacity(0.5), lineWidth: 2)
                                .frame(width: 140, height: 140)

                            Image(systemName: modality.icon)
                                .font(.system(size: 60, weight: .medium))
                                .foregroundColor(modality.type.color)
                        }
                        .shadow(color: colorScheme == .dark ? Color.clear : modality.type.color.opacity(0.2), radius: 10, y: 4)
                        
                        // Type badge
                        Text(modality.type.rawValue)
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(modality.type.color)
                            )
                        
                        // Title
                        Text(modality.abbreviation)
                            .font(.custom("Poppins-Bold", size: 32))
                            .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
                        
                        Text(modality.name)
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundColor(modality.type.color)
                            .multilineTextAlignment(.center)
                        
                        // Quick stats row
                        HStack(spacing: 24) {
                            quickStat(icon: "clock", value: modality.duration, label: "Duration")
                            quickStat(icon: "arrow.left.arrow.right", value: modality.mechanism, label: "Mechanism")
                        }
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 12)
                    
                    // MARK: - Overview Card
                    PremiumLightGlassCard(
                        title: "Overview",
                        icon: "doc.text.fill",
                        content: overviewContent
                    )
                    
                    // MARK: - Mechanism Card (Accent Style)
                    modalityTypeCard(
                        title: "Mechanism",
                        subtitle: modality.mechanism,
                        content: mechanismContent,
                        accentColor: modality.type.color
                    )
                    
                    // MARK: - Access & Settings Card
                    PremiumLightGlassCard(
                        title: "Access & Settings",
                        icon: "slider.horizontal.3",
                        content: accessContent
                    )
                    
                    // MARK: - Indications Card
                    PremiumLightGlassCard(
                        title: "Indications",
                        icon: "checkmark.circle.fill",
                        content: indicationsContent
                    )
                    
                    // MARK: - Contraindications Card (Warning Style)
                    if !modality.contraindications.isEmpty {
                        warningCard
                    }
                    
                    // MARK: - Advantages/Disadvantages Card
                    prosConsCard
                    
                    // MARK: - Clinical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .padding(.bottom, 40)
                }
            }
        }
        .fullScreenCover(isPresented: $showImageViewer) {
            PhotoView(image: selectedImage)
        }
    }
    
    // MARK: - Quick Stat View
    private func quickStat(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(modality.type.color)
            
            Text(value)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
            
            Text(label)
                .font(.custom("Poppins-Regular", size: 11))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : Color(red: 0.4, green: 0.4, blue: 0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(modality.type.color.opacity(colorScheme == .dark ? 0.4 : 0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Modality Type Card (Accent Glass Card)
    private func modalityTypeCard(title: String, subtitle: String, content: AttributedString, accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with type badge
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundColor(accentColor)
                    
                    Text(subtitle)
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : Color(red: 0.4, green: 0.4, blue: 0.5))
                }
                
                Spacer()
                
                // Icon badge
                Image(systemName: "gearshape.2.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(accentColor)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(accentColor.opacity(0.15))
                    )
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            // Content
            Text(content)
                .lineSpacing(6)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.15), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.1), Color.white.opacity(0.3), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            accentColor.opacity(0.4),
                            colorScheme == .dark ? accentColor.opacity(0.15) : Color.white.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : accentColor.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Warning Card (Contraindications)
    private var warningCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with warning icon
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.red.opacity(0.9),
                                Color.red.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.red.opacity(0.3), radius: 4, y: 2)
                
                Text("Contraindications")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(Color.red)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            // Content
            Text(contraindicationsContent)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.red.opacity(0.08))
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.red.opacity(0.05))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : Color.red.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Pros/Cons Card
    private var prosConsCard: some View {
        let mutedPositive = Color(red: 0.2, green: 0.6, blue: 0.4)
        let mutedNegative = Color(red: 0.7, green: 0.4, blue: 0.3)
        
        return VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: "scale.3d")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.3, green: 0.5, blue: 0.7),
                                Color(red: 0.4, green: 0.6, blue: 0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.blue.opacity(0.3), radius: 4, y: 2)
                
                Text("Advantages & Disadvantages")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            // Advantages Section
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 14))
                        .foregroundColor(mutedPositive)
                    Text("Advantages")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(mutedPositive)
                }
                
                ForEach(modality.advantages, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(mutedPositive)
                            .offset(y: 2)
                        
                        Text(item)
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.25, green: 0.25, blue: 0.3))
                    }
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(mutedPositive.opacity(colorScheme == .dark ? 0.12 : 0.08))
            )
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 12)
            
            // Disadvantages Section
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.system(size: 14))
                        .foregroundColor(mutedNegative)
                    Text("Disadvantages")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(mutedNegative)
                }
                
                ForEach(modality.disadvantages, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(mutedNegative)
                            .offset(y: 2)
                        
                        Text(item)
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.25, green: 0.25, blue: 0.3))
                    }
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(mutedNegative.opacity(colorScheme == .dark ? 0.12 : 0.08))
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [CriticalDesign.Colors.gold.opacity(0.1), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.8),
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? LinearGradient(
                            colors: [CriticalDesign.Colors.gold.opacity(0.5), CriticalDesign.Colors.gold.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [Color.white.opacity(0.9), Color.white.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.05) : Color.blue.opacity(0.08), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

// MARK: - RRT Comparison View
struct RRTComparisonView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    private let cardBlue = CriticalDesign.Colors.cardBlue
    private let gold = Color(red: 0.96, green: 0.71, blue: 0.0)
    
    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15)
    }
    private var textTertiary: Color {
        colorScheme == .dark ? Color.white.opacity(0.7) : Color(red: 0.25, green: 0.25, blue: 0.3)
    }
    private var textMuted: Color {
        colorScheme == .dark ? Color.white.opacity(0.5) : Color(red: 0.4, green: 0.4, blue: 0.5)
    }
    
    // Comparison data - verified against clinical references
    private let comparisonRows: [(feature: String, ihd: String, crrt: String, sled: String)] = [
        ("Duration", "3-4 h, 3x/week", "24h/filter", "6-12 h daily"),
        ("Blood Flow", "300-400 mL/min", "150-200 mL/min", "100-150 mL/min"),
        ("Dialysate Flow", "500 mL/min (30 L/h)", "CVVHDF: ~1 L/h", "100-200 mL/min (6-12 L/h)"),
        ("Efficiency", "High", "Low", "Moderate"),
        ("Urea Clearance", "~150 mL/min", "~30 mL/min", "~80 mL/min"),
        ("Hemodynamic Stability", "⚠️ Poor", "✅ Good", "✅ Good"),
        ("Anticoagulation", "Not needed", "Important", "Usually not needed"),
        ("Access", "Fistula or vascath", "Vascath only", "Fistula or vascath"),
        ("DDS Risk", "Yes (if high BUN)", "N/A", "N/A"),
        ("Toxicology", "Better for low VD", "Slower removal", "Unclear PK effects"),
        ("Best For", "Stable, hyperkalemia", "Critically ill, unstable", "Critically ill, hyperkalemia")
    ]
    
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("RRT Comparison")
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(textPrimary)
                    
                    Spacer()
                    
                    PremiumLightCloseButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Column headers
                        HStack(spacing: 0) {
                            Text("Feature")
                                .font(.custom("Poppins-SemiBold", size: 12))
                                .foregroundColor(textMuted)
                                .frame(width: 100, alignment: .leading)
                            
                            ForEach(["IHD", "CRRT", "SLED"], id: \.self) { header in
                                Text(header)
                                    .font(.custom("Poppins-Bold", size: 13))
                                    .foregroundColor(textPrimary)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(gold.opacity(0.15))
                        )
                        .padding(.horizontal, 16)
                        
                        // Comparison rows
                        ForEach(comparisonRows, id: \.feature) { row in
                            HStack(spacing: 0) {
                                Text(row.feature)
                                    .font(.custom("Poppins-Medium", size: 12))
                                    .foregroundColor(textPrimary)
                                    .frame(width: 100, alignment: .leading)
                                
                                Text(row.ihd)
                                    .font(.custom("Poppins-Regular", size: 11))
                                    .foregroundColor(textTertiary)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                
                                Text(row.crrt)
                                    .font(.custom("Poppins-Regular", size: 11))
                                    .foregroundColor(textTertiary)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                
                                Text(row.sled)
                                    .font(.custom("Poppins-Regular", size: 11))
                                    .foregroundColor(textTertiary)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                Group {
                                    if colorScheme == .dark {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(CriticalDesign.Colors.cardBlue)
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(.ultraThinMaterial)
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(Color.white.opacity(0.6))
                                        }
                                    }
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.5), lineWidth: 1)
                            )
                            .padding(.horizontal, 16)
                        }
                        
                        // Key takeaway
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(gold)
                                Text("Key Takeaway")
                                    .font(.custom("Poppins-SemiBold", size: 14))
                                    .foregroundColor(.white)
                            }
                            
                            Text("IHD: High efficiency but poor hemodynamics (ambulatory/stable patients). CRRT: Low efficiency but good hemodynamics (critically ill, non-ambulatory). SLED: Middle ground—moderate efficiency with good hemodynamics. Anticoagulation needed for CRRT; usually NOT needed for IHD/SLED.")
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(CriticalDesign.Colors.cardBlue)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [gold, gold.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: gold.opacity(0.15), radius: 8, y: 4)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    RRTModalityDetailView(modality: RRTModality.allModalities[0])
}
