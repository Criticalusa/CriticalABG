//
//  NeuromuscularSettingView.swift
//  CriticalX
//
//  Premium Redesign with CriticalDesign System
//

import SwiftUI

// MARK: - Main View
struct NeuromuscularSettingView: View {
    @ObservedObject var settings: SettingValue
    
    // Expansion states
    @State private var expandedCard: String? = nil
    
    private let accentColor = CriticalDesign.Colors.accentRed
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: CriticalDesign.Spacing.md) {
                // Succinylcholine
                ExpandableMedicationCard(
                    name: "Succinylcholine",
                    icon: "bolt.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "succinylcholine" },
                        set: { if $0 { expandedCard = "succinylcholine" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            DoseRangeStepper(
                                title: "Dose Range",
                                unit: "mg/kg",
                                minValue: $settings.succinylcholineTxtFieldmgkG1,
                                maxValue: $settings.succinylcholineTxtFieldmgkG2,
                                accentColor: accentColor,
                                step: 0.5,
                                range: 0.5...2.5
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.succinylcholineTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 5,
                                range: 10...50
                            )
                        }
                    )
                )
                
                // Vecuronium
                ExpandableMedicationCard(
                    name: "Vecuronium",
                    icon: "waveform.path",
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
                                value: $settings.vecuroniumTxtFieldmgkG1,
                                accentColor: accentColor,
                                step: 0.02,
                                range: 0.05...0.2
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.vecuroniumTxtFieldmgmL1,
                                accentColor: accentColor,
                                step: 0.5,
                                range: 0.5...5.0
                            )
                        }
                    )
                )
                
                // Cisatracurium
                ExpandableMedicationCard(
                    name: "Cisatracurium",
                    icon: "staroflife.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "cisatracurium" },
                        set: { if $0 { expandedCard = "cisatracurium" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            PremiumValueStepper(
                                title: "Dose",
                                unit: "mg/kg",
                                value: $settings.cisatracuriumTxtFieldmgkG,
                                accentColor: accentColor,
                                step: 0.05,
                                range: 0.1...0.4
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.cisatracuriumTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 2,
                                range: 2...20
                            )
                        }
                    )
                )
                
                // Rocuronium
                ExpandableMedicationCard(
                    name: "Rocuronium",
                    icon: "timer",
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
                                minValue: $settings.rocuroniumTxtFieldmgkG1_1,
                                maxValue: $settings.rocuroniumTxtFieldmgkG2_2,
                                accentColor: accentColor,
                                step: 0.1,
                                range: 0.3...1.5
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.rocuroniumTxtFieldmgmL1,
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
        .background(CriticalDesign.Colors.canvas.ignoresSafeArea())
        .simultaneousGesture(
            DragGesture().onChanged { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                              to: nil, from: nil, for: nil)
            }
        )
    }
}

// MARK: - Preview
struct NeuromuscularSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NeuromuscularSettingView(settings: SettingValue())
    }
}
