//
//  NeuromuscularView.swift
//  CriticalX
//
//  Redesigned with CriticalDesign System
//

import SwiftUI

struct NeuromuscularView: View {
    @ObservedObject var values: RSIIValue
    @State private var isActive = false
    
    var body: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Header
            RSISectionHeader(title: "Paralytics", icon: "bolt.fill")
            
            // Medication Cards Grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: CriticalDesign.Spacing.md),
                GridItem(.flexible(), spacing: CriticalDesign.Spacing.md)
            ], spacing: CriticalDesign.Spacing.md) {
                MedicationCard(
                    title: "Succinylcholine",
                    dosage: values.succsLabel,
                    concentration: values.unitSuccinylcholineLabel,
                    mlDosage: values.succsMLsLabel,
                    type: .paralytic
                )
                
                MedicationCard(
                    title: "Vecuronium",
                    dosage: values.vecuroniumLabel,
                    concentration: values.unitVecuroniumLabel,
                    mlDosage: values.vecuroniumMLsLabel,
                    type: .paralytic
                )
                
                MedicationCard(
                    title: "Rocuronium",
                    dosage: values.rocuroniumLabel,
                    concentration: values.unitRocuroniumLabel,
                    mlDosage: values.rocuroniumMLsLabel,
                    type: .paralytic
                )
                
                MedicationCard(
                    title: "Cisatracurium",
                    dosage: values.cisatricuriumLabel,
                    concentration: values.unitCisatricuriumLabel,
                    mlDosage: values.cisatricuriumMLsLabel,
                    type: .paralytic
                )
            }
            .padding(.horizontal, CriticalDesign.Spacing.md)
            
            // 7P's Button
            Button(action: { isActive = true }) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: "list.number")
                        .font(.system(size: 20, weight: .bold))

                    Text("7P's of RSI")
                        .font(.custom("Poppins-Bold", size: 18))
                }
                .foregroundColor(.white)
                .padding(.horizontal, CriticalDesign.Spacing.xl)
                .padding(.vertical, CriticalDesign.Spacing.md)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    CriticalDesign.Colors.accentOrange,
                                    CriticalDesign.Colors.accentOrange.opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: CriticalDesign.Colors.accentOrange.opacity(0.4), radius: 12, x: 0, y: 6)
                )
            }
            .navigationDestination(isPresented: $isActive) {
                SevenPsbtnView()
            }
            .padding(.top, CriticalDesign.Spacing.lg)
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
struct NeuromuscularView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            NeuromuscularView(values: RSIIValue())
        }
        .preferredColorScheme(.dark)
    }
}
