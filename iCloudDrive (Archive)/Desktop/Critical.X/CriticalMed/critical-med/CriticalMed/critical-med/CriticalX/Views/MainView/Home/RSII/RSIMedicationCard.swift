//
//  RSIMedicationCard.swift
//  CriticalX
//
//  Redesigned with CriticalDesign System
//

import SwiftUI

// MARK: - Medication Type
enum MedicationType {
    case induction
    case paralytic
    case pretreatment
    
    var accentColor: Color {
        switch self {
        case .induction:
            return CriticalDesign.Colors.accentGreen
        case .paralytic:
            return CriticalDesign.Colors.accentRed
        case .pretreatment:
            return CriticalDesign.Colors.accentBlue
        }
    }
    
    var icon: String {
        switch self {
        case .induction:
            return "syringe.fill"
        case .paralytic:
            return "bolt.fill"
        case .pretreatment:
            return "pills.fill"
        }
    }
}

// MARK: - Medication Card
struct MedicationCard: View {
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Properties
    let title: String
    let dosage: String
    let concentration: String
    let mlDosage: String
    let type: MedicationType
    
    // Card dimensions
    private let cardWidth: CGFloat = (UIScreen.main.bounds.width - 48) / 2
    private let cardHeight: CGFloat = 180
    
    // MARK: - Computed Properties
    private var unit: String {
        let firstPart = concentration.components(separatedBy: "|").first ?? ""
        if firstPart.contains("mcg") {
            return "mcg"
        } else if firstPart.contains("mg") {
            return "mg"
        }
        return ""
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Icon
            HStack(alignment: .center) {
                Image(systemName: type.icon)
                    .foregroundColor(type.accentColor)
                    .font(.system(size: 16, weight: .medium))
                
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer()
            }
            .padding(.bottom, CriticalDesign.Spacing.sm)
            
            // Dosage section
            VStack(alignment: .leading, spacing: 4) {
                Text(dosage)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(type.accentColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Text(unit)
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, CriticalDesign.Spacing.sm)
            
            Spacer()
            
            // Divider
            Rectangle()
                .fill(CriticalDesign.Colors.muted.opacity(0.4))
                .frame(height: 1)
                .padding(.vertical, CriticalDesign.Spacing.xs)
            
            // Concentration and ML dosage
            VStack(alignment: .leading, spacing: 4) {
                Text(concentration)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Text(mlDosage)
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(CriticalDesign.Spacing.md)
        .frame(width: cardWidth, height: cardHeight)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(
                    LinearGradient(
                        colors: [Color.white, CriticalDesign.Colors.canvas],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white, radius: 10, x: -5, y: -5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    LinearGradient(
                        colors: [
                            type.accentColor.opacity(0.3),
                            type.accentColor.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
    }
}

// MARK: - Preview
struct MedicationCard_Previews: PreviewProvider {
    static var sampleData: [(String, String, String, String, MedicationType)] = [
        ("Etomidate", "15", "0.3 mg/kg | 2.0 mg/mL", "7.5 mL's", .induction),
        ("Succinylcholine", "100-150", "1.5 mg/kg | 20 mg/mL", "5.0-7.5 mL's", .paralytic),
        ("Lidocaine", "70", "1.0 mg/kg | 20 mg/mL", "3.5 mL's", .pretreatment),
        ("Ketamine", "50-100", "1.0-2.0 mg/kg | 100 mg/mL", "0.5-1.0 mL's", .induction)
    ]
    
    static var previews: some View {
        ZStack {
            CriticalDesign.Colors.canvas
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(sampleData, id: \.0) { data in
                        MedicationCard(
                            title: data.0,
                            dosage: data.1,
                            concentration: data.2,
                            mlDosage: data.3,
                            type: data.4
                        )
                    }
                }
                .padding()
            }
        }
    }
}
