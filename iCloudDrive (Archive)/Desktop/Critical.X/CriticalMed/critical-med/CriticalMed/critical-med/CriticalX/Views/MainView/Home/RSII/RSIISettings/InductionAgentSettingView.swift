//
//  InductionAgentSettingView.swift
//  CriticalX
//
//  Premium Redesign with CriticalDesign System
//

import SwiftUI

// MARK: - Main View
struct InductionAgentSettingView: View {
    @ObservedObject var settings: SettingValue
    
    // Expansion states
    @State private var expandedCard: String? = nil
    
    private let accentColor = CriticalDesign.Colors.accentGreen
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: CriticalDesign.Spacing.md) {
                // Etomidate
                ExpandableMedicationCard(
                    name: "Etomidate",
                    icon: "syringe.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "etomidate" },
                        set: { if $0 { expandedCard = "etomidate" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            PremiumValueStepper(
                                title: "Dose",
                                unit: "mg/kg",
                                value: $settings.etomidateTxtFieldmgkG,
                                accentColor: accentColor,
                                step: 0.1,
                                range: 0.1...0.5
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.etomidateTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 0.5,
                                range: 1.0...4.0
                            )
                        }
                    )
                )
                
                // Ketamine
                ExpandableMedicationCard(
                    name: "Ketamine",
                    icon: "cross.vial.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "ketamine" },
                        set: { if $0 { expandedCard = "ketamine" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            DoseRangeStepper(
                                title: "Dose Range",
                                unit: "mg/kg",
                                minValue: $settings.ketamineTxtFieldmgkG1,
                                maxValue: $settings.ketamineTxtFieldmgkG2,
                                accentColor: accentColor,
                                step: 0.5,
                                range: 0.5...4.0
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.ketamineTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 10,
                                range: 50...200
                            )
                        }
                    )
                )
                
                // Versed (Midazolam)
                ExpandableMedicationCard(
                    name: "Versed (Midazolam)",
                    icon: "moon.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "versed" },
                        set: { if $0 { expandedCard = "versed" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            DoseRangeStepper(
                                title: "Dose Range",
                                unit: "mg/kg",
                                minValue: $settings.versedTxtFieldmgkG1,
                                maxValue: $settings.versedTxtFieldmgkG2,
                                accentColor: accentColor,
                                step: 0.05,
                                range: 0.05...0.5
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.versedTxtFieldmgmL,
                                accentColor: accentColor,
                                step: 1,
                                range: 1...10
                            )
                        }
                    )
                )
                
                // Propofol
                ExpandableMedicationCard(
                    name: "Propofol",
                    icon: "drop.fill",
                    accentColor: accentColor,
                    isExpanded: Binding(
                        get: { expandedCard == "propofol" },
                        set: { if $0 { expandedCard = "propofol" } else { expandedCard = nil } }
                    ),
                    content: AnyView(
                        VStack(spacing: CriticalDesign.Spacing.md) {
                            DoseRangeStepper(
                                title: "Dose Range",
                                unit: "mg/kg",
                                minValue: $settings.propofolTxtFieldmgkG1,
                                maxValue: $settings.propofolTxtFieldmgkG2,
                                accentColor: accentColor,
                                step: 0.5,
                                range: 0.5...3.0
                            )
                            
                            PremiumValueStepper(
                                title: "Concentration",
                                unit: "mg/mL",
                                value: $settings.propofolTxtFieldmgmL,
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
struct InductionAgentSettingView_Previews: PreviewProvider {
    static var previews: some View {
        InductionAgentSettingView(settings: SettingValue())
    }
}
