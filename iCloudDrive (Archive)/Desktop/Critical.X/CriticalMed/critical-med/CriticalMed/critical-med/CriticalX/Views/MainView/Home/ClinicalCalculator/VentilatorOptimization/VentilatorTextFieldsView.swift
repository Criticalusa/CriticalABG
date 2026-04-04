//
//  VentilatorTextFieldsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 09/12/2021.
//  Redesigned with Luxurious Neumorphic UI
//
//  Note: This file is kept for backward compatibility.
//  The main VentilatorOptimizationView.swift now includes integrated inputs.
//

import SwiftUI

struct VentilatorTextFieldsView: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var respRateField: String = ""
    @State private var tidalVolumeField: String = ""
    @State private var currentPacField: String = ""
    @State private var targetPacField: String = ""
    @State private var respRate = 0.0
    @State private var tidalVolume = 0.0
    @State private var currentPac = 0.0
    @State private var targetPac = 0.0
    @State private var MV = 0.0
    @State private var targetMV = 0.0
    @State private var adjustMV = 0.0
    @State private var newRR = 0.0
    @State private var newTv = 0.0
    
    @State var showingPopup = false
    @State var isHidden: Bool = false
    
    var data: clinicalCalculatorData
    
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Info Sections
    private let infoSections: [(title: String, icon: String, content: String)] = [
        (
            title: "When to Use",
            icon: "lungs.fill",
            content: """
            Use this calculator to **optimize ventilator settings** based on PaCO₂ levels.

            Ideal for adjusting **minute ventilation** for CO₂ management, respiratory rate, or tidal volume optimization.
            """
        ),
        (
            title: "Key Points",
            icon: "lightbulb.fill",
            content: """
            **Key Formulas:**
            • **Minute Volume (MV)** = RR × Tidal Volume
            • **Target MV** = Current MV × (Current PaCO₂ ÷ Target PaCO₂)
            • **Normal PaCO₂:** 35-45 mmHg
            """
        ),
        (
            title: "Clinical Use",
            icon: "stethoscope",
            content: """
            **Clinical applications include:**
            • **ARDS** management
            • **Hypercapnia** correction
            • **Lung-protective** ventilation strategies
            """
        )
    ]
    
    var body: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            
            // MARK: - Info Section
            IconTabBar(sections: infoSections)
            
            // MARK: - Input Cards
            inputSection
            
            // MARK: - Calculate Button
            calculateButton
            
            // MARK: - Result
            if isHidden {
                VStack(spacing: CriticalDesign.Spacing.md) {
                    Text("Result")
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(colorScheme == .dark ? Color.white : CriticalDesign.Colors.cardBlue)
                    
                    VentilatorResultView(
                        respRate: respRate,
                        tidalVolume: tidalVolume,
                        currentPac: currentPac,
                        targetPac: targetPac,
                        MV: MV,
                        targetMV: targetMV,
                        adjustMV: adjustMV,
                        newRR: newRR,
                        newTv: newTv
                    )
                }
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
        .fullScreenCover(isPresented: $showingPopup) {
            HoldOnPopupView(title: "Hold On!!", message: "Enter all fields to calculate.")
                .background(BackgroundClearView())
        }
    }
    
    // MARK: - Input Section
    private var inputSection: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            // Ventilator Settings Card
            VStack(spacing: CriticalDesign.Spacing.md) {
                HStack {
                    Image(systemName: "waveform.path")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                    
                    Text("Ventilator Settings")
                        .font(CriticalDesign.Typography.headline())
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Spacer()
                }
                
                // Respiratory Rate
                inputRow(
                    title: "Respiratory Rate",
                    subtitle: "12-20/min",
                    placeholder: "16",
                    value: $respRateField,
                    color: CriticalDesign.Colors.accentBlue
                )
                
                Rectangle()
                    .fill(colorScheme == .dark ? Color.white.opacity(0.1) : CriticalDesign.Colors.muted.opacity(0.3))
                    .frame(height: 1)

                // Tidal Volume
                inputRow(
                    title: "Tidal Volume",
                    subtitle: "6-8 mL/kg",
                    placeholder: "650",
                    value: $tidalVolumeField,
                    color: CriticalDesign.Colors.accentTeal,
                    unit: "mL"
                )
            }
            .padding(CriticalDesign.Spacing.lg)
            .deepNeumorphicCard(cornerRadius: CriticalDesign.Radius.xl)
            
            // PaCO2 Card
            VStack(spacing: CriticalDesign.Spacing.md) {
                HStack {
                    Image(systemName: "lungs.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(CriticalDesign.Colors.accentOrange)
                    
                    Text("PaCO₂ Values")
                        .font(CriticalDesign.Typography.headline())
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Spacer()
                }
                
                // Current PaCO2
                inputRow(
                    title: "Current PaCO₂",
                    subtitle: "From ABG",
                    placeholder: "51",
                    value: $currentPacField,
                    color: CriticalDesign.Colors.accentRed
                )
                
                Rectangle()
                    .fill(colorScheme == .dark ? Color.white.opacity(0.1) : CriticalDesign.Colors.muted.opacity(0.3))
                    .frame(height: 1)

                // Target PaCO2
                inputRow(
                    title: "Target PaCO₂",
                    subtitle: "35-45 mmHg",
                    placeholder: "40",
                    value: $targetPacField,
                    color: CriticalDesign.Colors.accentGreen
                )
            }
            .padding(CriticalDesign.Spacing.lg)
            .deepNeumorphicCard(cornerRadius: CriticalDesign.Radius.xl)
        }
    }
    
    // MARK: - Input Row
    private func inputRow(title: String, subtitle: String, placeholder: String, value: Binding<String>, color: Color, unit: String? = nil) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(CriticalDesign.Typography.callout())
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text(subtitle)
                    .font(CriticalDesign.Typography.caption())
                    .foregroundColor(color)
            }

            Spacer()

            HStack(spacing: CriticalDesign.Spacing.xs) {
                TextField(placeholder, text: value)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(color)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .frame(width: 80)

                if let unit = unit {
                    Text(unit)
                        .font(CriticalDesign.Typography.caption())
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
            }
        }
    }
    
    // MARK: - Calculate Button
    private var calculateButton: some View {
        Button(action: {
            haptic.impactOccurred()
            hideKeyboard()
            validation()
        }) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Text("Analyze")
                    .font(.custom("Poppins-Bold", size: 22))
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 22))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, CriticalDesign.Spacing.md)
        }
        .buttonStyle(CriticalPrimaryButtonStyle(color: CriticalDesign.Colors.buttonBlue))
    }
    
    // MARK: - Calculations
    func Calculationss() {
        respRate = Double(respRateField) ?? 0.0
        tidalVolume = Double(tidalVolumeField) ?? 0.0
        currentPac = Double(currentPacField) ?? 0.0
        targetPac = Double(targetPacField) ?? 0.0
        
        MV = respRate * tidalVolume / 1000
        targetMV = (MV * currentPac) / targetPac
        adjustMV = targetMV - MV
        newRR = (targetMV / 500 * 1000)
        newTv = (targetMV / respRate * 1000)
    }
    
    func validation() {
        if !respRateField.isEmpty && !tidalVolumeField.isEmpty && !currentPacField.isEmpty && !targetPacField.isEmpty {
            Calculationss()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isHidden = true
            }
            showingPopup = false
        } else {
            showingPopup = true
        }
    }
}

struct VentilatorTextFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CriticalDesign.Colors.canvas
                .ignoresSafeArea()
            
            ScrollView {
                VentilatorTextFieldsView(data: clinicalCalculatorData.ventilatorOptimizationSegmentDetails)
            }
        }
    }
}
