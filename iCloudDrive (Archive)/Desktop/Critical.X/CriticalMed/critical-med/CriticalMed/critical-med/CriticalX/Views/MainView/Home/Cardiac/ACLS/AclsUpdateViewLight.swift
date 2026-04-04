//
//  AclsUpdateViewLight.swift
//  CriticalX
//
//  Light Mode Prototype - Premium Glass Aesthetic
//  Inspired by VADs glass effect, translated to light mode
//  Uses shared components from PremiumLightComponents.swift
//

import SwiftUI

// MARK: - Main View
struct AclsUpdateViewLight: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var showTrainingGuide = false
    @State private var showPediatricGuide = false
    @State private var showPostArrestGuide = false
    @State private var showQuizPrep = false

    // MARK: - Helper to bold headings (text before colons)
    // Note: Using UIFont for AttributedString because .custom() fonts don't always
    // apply correctly in AttributedString. UIFont ensures the weight is respected.
    private func formatContent(_ text: String, headings: [String]) -> AttributedString {
        var result = AttributedString(text)

        // Set base style using UIFont (more reliable in AttributedString)
        let baseFont = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        result.font = Font(baseFont)
        result.foregroundColor = Color(red: 0.25, green: 0.25, blue: 0.3)

        // Bold each heading using UIFont
        let boldFont = UIFont(name: "Poppins-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        for heading in headings {
            if let range = result.range(of: heading) {
                result[range].font = Font(boldFont)
                result[range].foregroundColor = Color(red: 0.1, green: 0.1, blue: 0.15)
            }
        }

        return result
    }

    // MARK: - Formatted Content (2025 AHA Guidelines)
    private var defibrillationContent: AttributedString {
        formatContent("""
        VF/pVT Management:
        Immediate defibrillation remains first-line. First shock energy ≥200J preferred. After 3+ shocks, DSD and VCD have uncertain usefulness.

        Synchronized Cardioversion (2025 Update):
        • AFib/AFlutter: ≥200J biphasic
        • Narrow complex (SVT): 100J
        • Monomorphic VT: 100J
        • Polymorphic VT: Unsynchronized high-energy (treat as VF)
        If energy unknown → use maximum device settings. Sedate whenever feasible.
        """, headings: ["VF/pVT Management:", "Synchronized Cardioversion (2025 Update):"])
    }

    private var vascularAccessContent: AttributedString {
        formatContent("""
        IV First-Line:
        Intravenous (IV) access is the preferred first-line route for medication administration during cardiac arrest.

        IO if IV Fails:
        If IV access is unsuccessful or delayed, intraosseous (IO) access is recommended as an alternative.
        """, headings: ["IV First-Line:", "IO if IV Fails:"])
    }

    private var medicationContent: AttributedString {
        formatContent("""
        Epinephrine Timing:
        Shockable (VF/pVT): Give after initial defibrillation fails. Non-shockable: Give ASAP. Dose: 1 mg IV/IO q3-5 min.

        Vasopressin (2025):
        NOT recommended. Vasopressin alone or combined with epinephrine shows NO survival advantage.

        Antiarrhythmics (2025):
        Amiodarone or lidocaine for shock-refractory VF/pVT. SOTALOL REMOVED from algorithms—no benefit.

        Buffering Agents (2025):
        Routine sodium bicarbonate NOT recommended. RCTs show no benefit for ROSC or survival. Use only in special circumstances.

        Wide Complex Tachycardia:
        Adenosine may be considered diagnostically for stable, regular, monomorphic WCT. Do NOT give CCBs—risk of hemodynamic collapse.
        """, headings: ["Epinephrine Timing:", "Vasopressin (2025):", "Antiarrhythmics (2025):", "Buffering Agents (2025):", "Wide Complex Tachycardia:"])
    }

    private var airwayContent: AttributedString {
        formatContent("""
        Ventilation (2025 Update):
        "Give oxygen" updated to: "Begin bag-mask ventilation and give oxygen." Rescue breaths fully reinstated post-COVID.

        Advanced Airway (2025):
        Moved earlier in algorithm. ETI by experienced providers. SGAs are acceptable alternatives.

        Capnography (2025):
        Shift to CONTINUOUS waveform capnography—emphasizes CPR quality monitoring, not just ETI confirmation.
        """, headings: ["Ventilation (2025 Update):", "Advanced Airway (2025):", "Capnography (2025):"])
    }

    private var postROSCContent: AttributedString {
        formatContent("""
        ROSC Algorithm (2025):
        Now has its OWN dedicated algorithm—removed from side panel of arrest algorithm.

        Hemodynamics (2025):
        Target MAP ≥65 mmHg. SBP targets REMOVED—focus solely on MAP.

        Oxygenation (2025):
        FiO₂ 100% until SpO₂/PaO₂ reliably measurable. SpO₂ targets widened. Removed "10 breaths/min"—avoid hyperventilation.

        Temperature (2025):
        Target 32°C–37.5°C (broadened from ≤36°C). TTM for ≥36 hours. Avoid hyperthermia.

        Early Intervention:
        Early 12-lead ECG, CT, ultrasound. Push for early angiography and PCI. Consider mechanical circulatory support.

        Neurologic Prognostication:
        Assessment off sedation/NMB. Multimodal approach emphasized.
        """, headings: ["ROSC Algorithm (2025):", "Hemodynamics (2025):", "Oxygenation (2025):", "Temperature (2025):", "Early Intervention:", "Neurologic Prognostication:"])
    }
    
    private var cprAdjunctsContent: AttributedString {
        formatContent("""
        Mechanical CPR (2025):
        NOT recommended for routine use—trials show no superiority over manual CPR. Use only when manual CPR unsafe or not feasible.

        Chain of Survival (2025):
        NOW STANDARDIZED—one universal chain for all ages and locations.

        H's and T's (2025):
        No longer explicitly listed in algorithms—consider reversible causes continuously.

        Termination of Resuscitation (2025):
        Do NOT rely on EtCO₂ alone. Consider: arrest not witnessed, no bystander CPR, no ROSC before transport, no shocks delivered.
        """, headings: ["Mechanical CPR (2025):", "Chain of Survival (2025):", "H's and T's (2025):", "Termination of Resuscitation (2025):"])
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // MARK: - Close Button
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                                .frame(width: 32, height: 32)
                                .background(
                                    ZStack {
                                        Circle()
                                            .fill(.ultraThinMaterial)
                                        Circle()
                                            .fill(Color.white.opacity(0.6))
                                    }
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 4, y: 2)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }

                    // MARK: - Title Section
                    VStack(spacing: 16) {
                        // Heart icon with glass effect
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 80, height: 80)

                            Circle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 80, height: 80)

                            Circle()
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                .frame(width: 80, height: 80)

                            Image(systemName: "heart.fill")
                                .font(.system(size: 36, weight: .medium))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.9, green: 0.25, blue: 0.3),
                                            Color(red: 0.8, green: 0.2, blue: 0.25)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color.red.opacity(0.3), radius: 4, y: 2)
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 4)

                        Text("2025 AHA ACLS")
                            .font(.custom("Poppins-Bold", size: 32))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                        Text("Guidelines Update")
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        
                        // Full Training Guide Button
                        Button(action: { showTrainingGuide = true }) {
                            HStack {
                                Image(systemName: "book.fill")
                                Text("Full Training Guide")
                                    .font(.subheadline.weight(.semibold))
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [Color.cardBlue, Color.cardBlue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                        }
                        
                        // Additional Guides
                        HStack(spacing: 12) {
                            Button(action: { showPediatricGuide = true }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "figure.and.child.holdinghands")
                                    Text("Pediatric")
                                        .font(.caption.weight(.semibold))
                                }
                                .foregroundColor(.pink)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.pink.opacity(0.1))
                                .cornerRadius(20)
                            }
                            
                            Button(action: { showPostArrestGuide = true }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "heart.text.square.fill")
                                    Text("Post-Arrest")
                                        .font(.caption.weight(.semibold))
                                }
                                .foregroundColor(.purple)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(20)
                            }
                        }
                        
                        // Quiz Prep Button - Pro Feature
                        Button(action: { showQuizPrep = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                Text("ACLS Test Prep")
                                    .font(.subheadline.weight(.semibold))
                                Text("PRO")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(CriticalDesign.Colors.gold)
                                    .cornerRadius(4)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [Color.red, Color.red.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: Color.red.opacity(0.3), radius: 8, y: 4)
                        }
                    }
                    .padding(.bottom, 12)

                    // MARK: - Cards
                    PremiumLightGlassCard(
                        title: "Defibrillation",
                        icon: "bolt.heart.fill",
                        content: defibrillationContent
                    )

                    PremiumLightGlassCard(
                        title: "Vascular Access",
                        icon: "syringe.fill",
                        content: vascularAccessContent
                    )

                    PremiumLightGlassCard(
                        title: "Medications",
                        icon: "pills.fill",
                        content: medicationContent
                    )

                    PremiumLightGlassCard(
                        title: "Airway Management",
                        icon: "lungs.fill",
                        content: airwayContent
                    )

                    PremiumLightGlassCard(
                        title: "Post-ROSC Care",
                        icon: "heart.text.square.fill",
                        content: postROSCContent
                    )
                    
                    PremiumLightGlassCard(
                        title: "CPR & Algorithm Changes",
                        icon: "waveform.path.ecg",
                        content: cprAdjunctsContent
                    )

                    // MARK: - Citation (Signature Card Style)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(Color(red: 0.79, green: 0.64, blue: 0.15))  // Gold #C9A227
                            Text("Citation")
                                .font(.custom("Poppins-SemiBold", size: 14))
                                .foregroundColor(.white)
                        }

                        Text("Del Rios M, Bartos JA, Panchal AR, et al. Part 1: executive summary: 2025 American Heart Association Guidelines for Cardiopulmonary Resuscitation and Emergency Cardiovascular Care. Circulation. 2025;152(suppl 2).")
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(.white.opacity(0.85))
                            .italic()
                            .lineSpacing(3)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(red: 0.09, green: 0.15, blue: 0.24))  // #17263C cardBlue
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.85, green: 0.65, blue: 0.15),  // #D9A625
                                        Color(red: 0.75, green: 0.55, blue: 0.12)   // #BF8C1F
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color(red: 0.79, green: 0.64, blue: 0.15).opacity(0.25), radius: 8, y: 4)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(isPresented: $showTrainingGuide) {
            ACLS2025TrainingGuideView()
        }
        .sheet(isPresented: $showPediatricGuide) {
            Pediatric2025GuidelinesView()
        }
        .sheet(isPresented: $showPostArrestGuide) {
            PostArrestCare2025View()
        }
        .sheet(isPresented: $showQuizPrep) {
            NavigationView {
                ACLSQuizMainView()
            }
        }
    }
}

// MARK: - Preview
struct AclsUpdateViewLight_Previews: PreviewProvider {
    static var previews: some View {
        AclsUpdateViewLight()
    }
}
