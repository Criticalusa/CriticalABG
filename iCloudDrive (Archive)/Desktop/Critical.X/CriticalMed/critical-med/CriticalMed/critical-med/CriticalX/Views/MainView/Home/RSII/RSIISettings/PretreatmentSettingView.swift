//
//  PretreatmentSettingView.swift
//  CriticalX
//
//  Premium Redesign with CriticalDesign System
//

import SwiftUI

// MARK: - Expandable Medication Card
struct ExpandableMedicationCard: View {
    @Environment(\.colorScheme) var colorScheme

    let name: String
    let icon: String
    let accentColor: Color
    @Binding var isExpanded: Bool
    let content: AnyView
    
    var body: some View {
        VStack(spacing: 0) {
            // Header - Always visible
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: CriticalDesign.Spacing.md) {
                    // Icon Badge
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [accentColor, accentColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(color: accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    // Name
                    Text(name)
                        .font(.custom("Poppins-SemiBold", size: 17))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Spacer()
                    
                    // Expand indicator
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(CriticalDesign.Spacing.md)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expandable Content
            if isExpanded {
                VStack(spacing: CriticalDesign.Spacing.md) {
                    Divider()
                        .background(accentColor.opacity(0.2))
                    
                    content
                }
                .padding(.horizontal, CriticalDesign.Spacing.md)
                .padding(.bottom, CriticalDesign.Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.06), radius: 12, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(isExpanded ? accentColor.opacity(0.3) : Color.clear, lineWidth: 1.5)
        )
    }
}

// MARK: - Premium Value Stepper
struct PremiumValueStepper: View {
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let unit: String
    @Binding var value: String
    let accentColor: Color
    let step: Double
    let range: ClosedRange<Double>
    
    private var numericValue: Double {
        Double(value) ?? range.lowerBound
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            
            HStack(spacing: 0) {
                // Decrease Button
                Button(action: {
                    let newValue = max(numericValue - step, range.lowerBound)
                    value = formatValue(newValue)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.sm)
                            .fill(accentColor.opacity(0.1))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "minus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(accentColor)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Value Display
                VStack(spacing: 2) {
                    Text(formatValue(numericValue))
                        .font(.custom("Poppins-Bold", size: 22))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .frame(minWidth: 80)
                    
                    Text(unit)
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)
                
                // Increase Button
                Button(action: {
                    let newValue = min(numericValue + step, range.upperBound)
                    value = formatValue(newValue)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.sm)
                            .fill(accentColor.opacity(0.1))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(accentColor)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(CriticalDesign.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : CriticalDesign.Colors.canvas)
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 4, x: 2, y: 2)
            )
        }
    }
    
    private func formatValue(_ val: Double) -> String {
        if val == floor(val) {
            return String(format: "%.0f", val)
        } else if val * 10 == floor(val * 10) {
            return String(format: "%.1f", val)
        } else {
            return String(format: "%.2f", val)
        }
    }
}

// MARK: - Dose Range Stepper (for min/max)
struct DoseRangeStepper: View {
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let unit: String
    @Binding var minValue: String
    @Binding var maxValue: String
    let accentColor: Color
    let step: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            
            HStack(spacing: CriticalDesign.Spacing.md) {
                // Min Value
                CompactStepper(
                    label: "Min",
                    value: $minValue,
                    unit: unit,
                    accentColor: accentColor,
                    step: step,
                    range: range
                )
                
                // Range indicator
                Image(systemName: "arrow.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(CriticalDesign.Colors.muted)
                
                // Max Value
                CompactStepper(
                    label: "Max",
                    value: $maxValue,
                    unit: unit,
                    accentColor: accentColor,
                    step: step,
                    range: range
                )
            }
        }
    }
}

// MARK: - Compact Stepper
struct CompactStepper: View {
    @Environment(\.colorScheme) var colorScheme

    let label: String
    @Binding var value: String
    let unit: String
    let accentColor: Color
    let step: Double
    let range: ClosedRange<Double>
    
    private var numericValue: Double {
        Double(value) ?? range.lowerBound
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            
            HStack(spacing: 8) {
                Button(action: {
                    let newValue = max(numericValue - step, range.lowerBound)
                    value = formatValue(newValue)
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(accentColor.opacity(0.7))
                }
                .buttonStyle(PlainButtonStyle())
                
                Text(formatValue(numericValue))
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .frame(minWidth: 45)
                
                Button(action: {
                    let newValue = min(numericValue + step, range.upperBound)
                    value = formatValue(newValue)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(accentColor)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : CriticalDesign.Colors.canvas)
            )
        }
    }
    
    private func formatValue(_ val: Double) -> String {
        if val == floor(val) {
            return String(format: "%.0f", val)
        } else if val * 10 == floor(val * 10) {
            return String(format: "%.1f", val)
        } else {
            return String(format: "%.2f", val)
        }
    }
}

// MARK: - Main View
struct PretreatmentSettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var settings: SettingValue
    
    // Expansion states
    @State private var expandedCard: String? = nil
    
    private let accentColor = CriticalDesign.Colors.accentBlue
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: CriticalDesign.Spacing.md) {
                // Lidocaine
                ExpandableMedicationCard(
                    name: "Lidocaine",
                    icon: "cross.vial.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "lidocaine" },
                        set: { if $0 { expandedCard = "lidocaine" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            PremiumValueStepper(
                                title: "Dose",
                                unit: "mg/kg",
                                value: $settings.lidocineTxtFieldmgkG,
                                accentColor: accentColor,
                                step: 0.5,
                                range: 0.5...3.0
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.lidocineTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 5,
                                range: 10...40
                            )
                        }
                    )
                )
                
                // Atropine
                ExpandableMedicationCard(
                    name: "Atropine",
                    icon: "heart.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "atropine" },
                        set: { if $0 { expandedCard = "atropine" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            PremiumValueStepper(
                                title: "Dose",
                                unit: "mg/kg",
                                value: $settings.atrophineTxtFieldmgkG,
                                accentColor: accentColor,
                                step: 0.01,
                                range: 0.01...0.1
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.atrophineTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 0.1,
                                range: 0.1...1.0
                            )
                        }
                    )
                )
                
                // Fentanyl
                ExpandableMedicationCard(
                    name: "Fentanyl",
                    icon: "pills.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "fentanyl" },
                        set: { if $0 { expandedCard = "fentanyl" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            DoseRangeStepper(
                                title: "Dose Range",
                                unit: "mcg/kg",
                                minValue: $settings.fentaylTxtFieldmgkG1,
                                maxValue: $settings.fentaylTxtFieldmgkG2,
                                accentColor: accentColor,
                                step: 0.5,
                                range: 0.5...5.0
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mcg/mL",
                                value: $settings.fentanylTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 10,
                                range: 10...100
                            )
                        }
                    )
                )
                
                // Vecuronium (Defasciculating)
                ExpandableMedicationCard(
                    name: "Vecuronium",
                    icon: "bolt.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "vecuronium" },
                        set: { if $0 { expandedCard = "vecuronium" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            PremiumValueStepper(
                                title: "Dose",
                                unit: "mg/kg",
                                value: $settings.vecuroniumTxtFieldmgkG,
                                accentColor: accentColor,
                                step: 0.01,
                                range: 0.01...0.1
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.vecuroniumTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 0.5,
                                range: 0.5...5.0
                            )
                        }
                    )
                )
                
                // Glycopyrrolate
                ExpandableMedicationCard(
                    name: "Glycopyrrolate",
                    icon: "drop.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "glycopyrrolate" },
                        set: { if $0 { expandedCard = "glycopyrrolate" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            DoseRangeStepper(
                                title: "Dose Range",
                                unit: "mg/kg",
                                minValue: $settings.glycopyrrolateTxtFieldmgkG1,
                                maxValue: $settings.glycopyrrolateTxtFieldmgkG2,
                                accentColor: accentColor,
                                step: 0.05,
                                range: 0.05...0.5
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.glycopyrrolateTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 0.1,
                                range: 0.1...1.0
                            )
                        }
                    )
                )
                
                // Rocuronium (Defasciculating)
                ExpandableMedicationCard(
                    name: "Rocuronium",
                    icon: "waveform.path",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "rocuronium" },
                        set: { if $0 { expandedCard = "rocuronium" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            DoseRangeStepper(
                                title: "Dose Range",
                                unit: "mg/kg",
                                minValue: $settings.rocuroniumTxtFieldmgkG1,
                                maxValue: $settings.rocuroniumTxtFieldmgkG2,
                                accentColor: accentColor,
                                step: 0.02,
                                range: 0.02...0.2
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.rocuroniumTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 5,
                                range: 5...20
                            )
                        }
                    )
                )
            }
            .padding(CriticalDesign.Spacing.md)
            .padding(.bottom, 100)
        }
        .background(CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea())
        .simultaneousGesture(
            DragGesture().onChanged { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                              to: nil, from: nil, for: nil)
            }
        )
    }
}

// MARK: - Preview
struct PretreatmentSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PretreatmentSettingView(settings: SettingValue())
    }
}
