//
//  PFRatioTextFieldsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 10/12/2021.
//  Redesigned: Using shared CriticalDesign system
//

import SwiftUI

struct PFRatioTextFieldsView: View {
    @Environment(\.colorScheme) var colorScheme

    // MARK: - State
    @State private var paCOTextField: String = ""
    @State private var fiOTextField: String = ""
    @State private var result = 0.0
    @State private var pac = 0.0
    @State private var fio = 0.0
    @State var isHidden: Bool = false
    @State private var showAlert: Bool = false
    @State private var showingPopup: Bool = false
    @State private var isButtonPressed = false
    
    var data: clinicalCalculatorData
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    // Info sections data
    private var infoSections: [(title: String, icon: String, content: String)] {
        [
            ("When to Use", "questionmark.circle", data.whatToKnow),
            ("Key Points", "lightbulb.fill", data.pearls),
            ("Why Use It", "lightbulb.fill", data.whyUse)
        ]
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: CriticalDesign.Spacing.lg) {
            
            // MARK: - Info Section (Using Icon Tabs)
            // 🔄 SWAP OPTIONS: Replace IconTabBar with any of these:
            //    - AccordionInfoSection(sections: infoSections)
            //    - FloatingInfoCards(sections: infoSections)
            //    - SegmentedPillBar(sections: infoSections.map { ($0.title, $0.content) })
            
            IconTabBar(sections: infoSections)
            
            // MARK: - Input Card
            VStack(spacing: CriticalDesign.Spacing.lg) {
                HStack(spacing: CriticalDesign.Spacing.md) {
                    // PaO2
                    CriticalInputField(
                        title: "PaO₂",
                        placeholder: "280",
                        unit: "mmHg",
                        text: $paCOTextField,
                        accentColor: CriticalDesign.Colors.accentBlue
                    )
                    
                    // Divider
                    VStack {
                        Spacer()
                        Text("÷")
                            .font(.system(size: 28, weight: .light, design: .rounded))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        Spacer()
                    }
                    .frame(height: 100)
                    
                    // FiO2
                    CriticalInputField(
                        title: "FiO₂",
                        placeholder: "50",
                        unit: "%",
                        text: $fiOTextField,
                        accentColor: CriticalDesign.Colors.accentGreen
                    )
                }
                
                // Info text
                Text("Arterial oxygen partial pressure to fractional inspired oxygen ratio")
                    .font(CriticalDesign.Typography.footnote())
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .multilineTextAlignment(.center)
            }
            .padding(CriticalDesign.Spacing.lg)
            .deepNeumorphicCard(cornerRadius: CriticalDesign.Radius.xxl)
            
            // MARK: - Analyze Button
            Button(action: {
                haptic.impactOccurred()
                withAnimation(.easeInOut(duration: 0.15)) {
                    isButtonPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isButtonPressed = false
                    validation()
                    hideKeyboard()
                }
            }) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Text("Analyze")
                    Image(systemName: "arrow.right")
                }
            }
            .buttonStyle(CriticalPrimaryButtonStyle(color: CriticalDesign.Colors.buttonBlue))
            .scaleEffect(isButtonPressed ? 0.97 : 1)
            .padding(.horizontal, CriticalDesign.Spacing.sm)
            
            // MARK: - Result
            if isHidden {
                PFRatioResultView(result: result, pac: pac, fio: fio)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .bottom)),
                        removal: .opacity
                    ))
            }
        }
        .fullScreenCover(isPresented: $showAlert) {
            HoldOnPopupView(title: "Error!", message: "Enter a PaO2 and FiO2 to calculate.")
                .background(BackgroundClearView())
        }
        .sheet(isPresented: $showingPopup) {
            EmptyTextFieldPopUp()
                .background(BackgroundClearView())
        }
    }
    
    // MARK: - Functions
    func CalCulation() {
        pac = Double(paCOTextField) ?? 0
        fio = Double(fiOTextField) ?? 0
        result = (pac / fio) * 100
        result.round()
    }
    
    func validation() {
        if !paCOTextField.isEmpty && !fiOTextField.isEmpty {
            CalCulation()
            withAnimation(.easeOut(duration: 0.35)) {
                isHidden = true
            }
            showAlert = false
        } else {
            isHidden = false
            showingPopup = true
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

// MARK: - Preview
struct PFRatioTextFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CriticalDesign.Colors.canvas.edgesIgnoringSafeArea(.all)
            ScrollView {
                PFRatioTextFieldsView(data: clinicalCalculatorData.pFRatioSegmentDetails)
                    .padding()
            }
        }
    }
}
