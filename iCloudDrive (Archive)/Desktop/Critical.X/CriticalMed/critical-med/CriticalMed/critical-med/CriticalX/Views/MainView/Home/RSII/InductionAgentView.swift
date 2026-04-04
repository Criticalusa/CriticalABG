//
//  InductionAgentView.swift
//  CriticalX
//
//  Redesigned with CriticalDesign System
//

import SwiftUI

struct InductionAgentView: View {
    @ObservedObject var values: RSIIValue
    
    var body: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Header
            RSISectionHeader(title: "Induction Agents", icon: "syringe.fill")
            
            // Medication Cards Grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: CriticalDesign.Spacing.md),
                GridItem(.flexible(), spacing: CriticalDesign.Spacing.md)
            ], spacing: CriticalDesign.Spacing.md) {
                MedicationCard(
                    title: "Etomidate",
                    dosage: values.etomidateLabel,
                    concentration: values.unitEtomidateLabel,
                    mlDosage: values.etomidateMLsLabel,
                    type: .induction
                )
                
                MedicationCard(
                    title: "Ketamine",
                    dosage: values.ketamineLabel,
                    concentration: values.unitKetamineLabel,
                    mlDosage: values.ketamineMLsLabel,
                    type: .induction
                )
                
                MedicationCard(
                    title: "Propofol",
                    dosage: values.propofolLabel,
                    concentration: values.unitPropofolLabel,
                    mlDosage: values.propofolMLsLabel,
                    type: .induction
                )
                
                MedicationCard(
                    title: "Versed",
                    dosage: values.versedLabel,
                    concentration: values.unitVersedLabel,
                    mlDosage: values.versedMLsLabel,
                    type: .induction
                )
            }
            .padding(.horizontal, CriticalDesign.Spacing.md)
        }
        .padding(.vertical, CriticalDesign.Spacing.md)
        .simultaneousGesture(
            DragGesture().onChanged { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                              to: nil, from: nil, for: nil)
            }
        )
    }
}

// MARK: - Preview
struct InductionAgentView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            InductionAgentView(values: RSIIValue())
        }
        .preferredColorScheme(.dark)
    }
}
