//
//  PFRatioResultView.swift
//  CriticalX
//
//  Created by Macbook 4 on 10/12/2021.
//  Redesigned: Using shared CriticalDesign system
//

import SwiftUI

struct PFRatioResultView: View {
    @Environment(\.colorScheme) var colorScheme

    var result: Double?
    var pac: Double?
    var fio: Double?
    
    private var resultValue: Double { result ?? 0 }
    
    private var classification: PFARDSClassification {
        if resultValue < 100 { return .severe }
        else if resultValue <= 200 { return .moderate }
        else if resultValue <= 300 { return .mild }
        else { return .normal }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Input Summary
            HStack(spacing: CriticalDesign.Spacing.xs) {
                Text("PaO₂")
                    .font(CriticalDesign.Typography.footnote())
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

                Text("\(Int(pac ?? 0))")
                    .font(CriticalDesign.Typography.footnote())
                    .fontWeight(.semibold)
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("÷")
                    .font(CriticalDesign.Typography.footnote())
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))

                Text("FiO₂")
                    .font(CriticalDesign.Typography.footnote())
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                
                Text("\(Int(fio ?? 0))%")
                    .font(CriticalDesign.Typography.footnote())
                    .fontWeight(.semibold)
                    .foregroundColor(CriticalDesign.Colors.accentGreen)
            }
            .padding(.horizontal, CriticalDesign.Spacing.md)
            .padding(.vertical, CriticalDesign.Spacing.sm)
            .background(
                Capsule()
                    .fill(CriticalDesign.Adaptive.canvas(for: colorScheme))
                    .shadow(color: CriticalDesign.Colors.shadowDark.opacity(colorScheme == .dark ? 0 : 0.12), radius: 4, x: 2, y: 2)
                    .shadow(color: CriticalDesign.Colors.shadowLight.opacity(colorScheme == .dark ? 0 : 0.9), radius: 4, x: -2, y: -2)
            )
            .padding(.top, CriticalDesign.Spacing.lg)
            
            // MARK: - Large Result
            VStack(spacing: CriticalDesign.Spacing.xs) {
                Text("\(Int(resultValue))")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(classification.color)
                
                Text("mmHg")
                    .font(CriticalDesign.Typography.caption())
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .tracking(1.5)
            }
            .padding(.vertical, CriticalDesign.Spacing.lg)
            
            // MARK: - Divider
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, colorScheme == .dark ? Color.white.opacity(0.2) : CriticalDesign.Colors.muted, Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .padding(.horizontal, CriticalDesign.Spacing.xxl)
            
            // MARK: - Classification
            VStack(spacing: CriticalDesign.Spacing.md) {
                // Status Icon
                ZStack {
                    Circle()
                        .fill(classification.color.opacity(0.12))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: classification.icon)
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(classification.color)
                }
                
                VStack(spacing: CriticalDesign.Spacing.xs) {
                    Text(classification.title)
                        .font(CriticalDesign.Typography.headline())
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Text(classification.classificationDescription)
                        .font(CriticalDesign.Typography.footnote())
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
                
                // MARK: - Severity Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Track
                        RoundedRectangle(cornerRadius: 4)
                            .fill(CriticalDesign.Adaptive.canvas(for: colorScheme))
                            .criticalInsetField(cornerRadius: 4)
                        
                        // Gradient fill
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        CriticalDesign.Colors.accentRed,
                                        CriticalDesign.Colors.accentOrange,
                                        CriticalDesign.Colors.accentGreen
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                HStack {
                                    Rectangle()
                                        .frame(width: indicatorPosition(width: geometry.size.width))
                                    Spacer(minLength: 0)
                                }
                            )
                        
                        // Indicator dot
                        Circle()
                            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                            .frame(width: 14, height: 14)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                            .offset(x: indicatorPosition(width: geometry.size.width) - 7)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, CriticalDesign.Spacing.lg)
                .padding(.top, CriticalDesign.Spacing.sm)
                
                // Scale labels
                HStack {
                    Text("Critical")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                    Spacer()
                    Text("Normal")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
            }
            .padding(.vertical, CriticalDesign.Spacing.lg)
        }
        .frame(maxWidth: .infinity)
        .deepNeumorphicCard(cornerRadius: CriticalDesign.Radius.xxl)
        .padding(.horizontal, CriticalDesign.Spacing.sm)
    }
    
    private func indicatorPosition(width: CGFloat) -> CGFloat {
        let maxValue: Double = 400
        let normalized = min(resultValue / maxValue, 1.0)
        return width * CGFloat(normalized)
    }
}

// MARK: - ARDS Classification
enum PFARDSClassification {
    case severe, moderate, mild, normal
    
    var title: String {
        switch self {
        case .severe: return "Severe Hypoxemia"
        case .moderate: return "Moderate Hypoxemia"
        case .mild: return "Mild Hypoxemia"
        case .normal: return "Normal Oxygenation"
        }
    }
    
    var classificationDescription: String {
        switch self {
        case .severe: return "ARDS criteria met • P/F < 100"
        case .moderate: return "ARDS criteria met • P/F 100-200"
        case .mild: return "ARDS criteria met • P/F 200-300"
        case .normal: return "Adequate oxygenation • P/F > 300"
        }
    }
    
    var color: Color {
        switch self {
        case .severe: return CriticalDesign.Colors.accentRed
        case .moderate: return CriticalDesign.Colors.accentOrange
        case .mild: return CriticalDesign.Colors.accentYellow
        case .normal: return CriticalDesign.Colors.accentGreen
        }
    }
    
    var icon: String {
        switch self {
        case .severe: return "exclamationmark.triangle.fill"
        case .moderate: return "exclamationmark.circle.fill"
        case .mild: return "info.circle.fill"
        case .normal: return "checkmark.circle.fill"
        }
    }
}

// MARK: - Preview
struct PFRatioResultView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CriticalDesign.Colors.canvas.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 20) {
                    PFRatioResultView(result: 85, pac: 60, fio: 70)
                    PFRatioResultView(result: 150, pac: 75, fio: 50)
                    PFRatioResultView(result: 250, pac: 100, fio: 40)
                    PFRatioResultView(result: 380, pac: 95, fio: 25)
                }
                .padding()
            }
        }
    }
}
