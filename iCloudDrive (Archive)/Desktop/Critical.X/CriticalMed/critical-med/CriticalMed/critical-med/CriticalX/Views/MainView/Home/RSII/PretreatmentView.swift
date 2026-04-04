//
//  PretreatmentView.swift
//  CriticalX
//
//  Redesigned with CriticalDesign System
//

import SwiftUI

struct PretreatmentView: View {
    @ObservedObject var values: RSIIValue
    
    var body: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Header
            RSISectionHeader(title: "Pre-Treatment", icon: "pills.fill")
            
            // Medication Cards Grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: CriticalDesign.Spacing.md),
                GridItem(.flexible(), spacing: CriticalDesign.Spacing.md)
            ], spacing: CriticalDesign.Spacing.md) {
                MedicationCard(
                    title: "Lidocaine",
                    dosage: values.lidocineLabel,
                    concentration: values.unitLidocaineLabel,
                    mlDosage: values.lidocaineMLsLabel,
                    type: .pretreatment
                )
                
                MedicationCard(
                    title: "Atropine",
                    dosage: values.atropineLabel,
                    concentration: values.unitAtropineLabel,
                    mlDosage: values.atropineMLsLabel,
                    type: .pretreatment
                )
                
                MedicationCard(
                    title: "Fentanyl",
                    dosage: values.fentanylLabel,
                    concentration: values.unitFentanylLabel,
                    mlDosage: values.fentanylMLsLabel,
                    type: .pretreatment
                )
                
                MedicationCard(
                    title: "Vecuronium",
                    dosage: values.vecDefasiculatingLabel,
                    concentration: values.unitVecDefascLabel,
                    mlDosage: values.vecDefasiculatingMLsLabel,
                    type: .pretreatment
                )
                
                MedicationCard(
                    title: "Glycopyrrolate",
                    dosage: values.glycopyrolateLabel,
                    concentration: values.unitGlycopyrolateLabel,
                    mlDosage: values.glycopyrolateMLsLabel,
                    type: .pretreatment
                )
                
                MedicationCard(
                    title: "Rocuronium",
                    dosage: values.rocDefasiculatingLabel,
                    concentration: values.unitRocDefascLabel,
                    mlDosage: values.rocDefasiculatingMLsLabel,
                    type: .pretreatment
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
struct PretreatmentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CriticalDesign.Colors.darkCanvas
                .ignoresSafeArea()
            
            ScrollView {
                PretreatmentView(values: RSIIValue())
            }
        }
        .preferredColorScheme(.dark)
    }
}
