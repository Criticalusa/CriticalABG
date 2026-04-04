//
//  AclsUpdateView.swift
//  CriticalX
//
//  Created by Macbook 4 on 24/11/2021.
//  Updated: Premium Light Mode with Glass Cards
//

import SwiftUI

struct AclsUpdateView: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var showAllPearls = false
    @State private var showTrainingGuide = false
    @State private var showPediatricGuide = false
    @State private var showPostArrestGuide = false
    @State private var showQuizPrep = false

    // Critical Pearls content - Updated for 2025 AHA Guidelines
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "IV over IO:", content: "IV access is preferred first-line. IO only if IV fails or is delayed."),
        CriticalPearlItem(header: "Epinephrine timing:", content: "Shockable rhythms: give after initial defib fails. Non-shockable: give ASAP."),
        CriticalPearlItem(header: "Sotalol removed:", content: "Sotalol is no longer recommended for VF/pVT or stable wide-complex tachycardia."),
        CriticalPearlItem(header: "Bicarb not routine:", content: "Sodium bicarbonate shows no benefit for ROSC or survival. Use only in special circumstances."),
        CriticalPearlItem(header: "Temp target widened:", content: "TTM target now 32°C–37.5°C (changed from strict ≤36°C). Avoid hyperthermia."),
        CriticalPearlItem(header: "H's & T's implicit:", content: "No longer explicitly listed in algorithms—consider reversible causes continuously."),
        CriticalPearlItem(header: "Post-ROSC targets:", content: "MAP ≥65 mmHg (SBP removed), SpO2 targets widened. FiO2 100% until SpO2 measurable.")
    ]

    // MARK: - Formatted Content (2025 Guidelines)
    private var defibrillationContent: AttributedString {
        ContentFormatter.format("""
        VF/pVT Management:
        Immediate defibrillation remains first-line for VF/pVT. First shock energy ≥200J preferred. After 3 or more shocks, DSD and VCD have uncertain usefulness.

        Synchronized Cardioversion (2025 Energy Updates):
        • Atrial fibrillation/flutter: ≥200J biphasic
        • Narrow complex tachycardia (SVT): 100J
        • Monomorphic VT: 100J
        • Polymorphic VT: Unsynchronized high-energy defibrillation
        If energy unknown → use maximum device settings. Sedate whenever feasible (changed from "consider sedation").
        """, headings: ["VF/pVT Management:", "Synchronized Cardioversion (2025 Energy Updates):"])
    }

    private var vascularAccessContent: AttributedString {
        ContentFormatter.format("""
        IV First-Line:
        Intravenous (IV) access is the preferred first-line route for medication administration during cardiac arrest.

        IO if IV Fails:
        If IV access is unsuccessful or delayed, intraosseous (IO) access is recommended as an alternative.
        """, headings: ["IV First-Line:", "IO if IV Fails:"])
    }

    private var medicationContent: AttributedString {
        ContentFormatter.format("""
        Epinephrine Timing:
        For shockable rhythms (VF/pVT), give epinephrine after initial defibrillation attempts fail. For non-shockable rhythms, give epinephrine as soon as possible. Standard dose: 1 mg IV/IO q3-5 min.

        Vasopressin (2025 Change):
        Vasopressin alone or combined with epinephrine shows NO survival advantage. Not recommended as a substitute for epinephrine.

        Antiarrhythmics (2025 Change):
        Amiodarone or lidocaine may be considered for shock-refractory VF/pVT. SOTALOL REMOVED from algorithms—no evidence of benefit in VF/pVT.

        Buffering Agents (2025 Change):
        Routine sodium bicarbonate NOT recommended during cardiac arrest. RCTs show no improvement in ROSC, survival to discharge, or neurological outcomes. Use only in special circumstances (e.g., hyperkalemia, TCA overdose).
        """, headings: ["Epinephrine Timing:", "Vasopressin (2025 Change):", "Antiarrhythmics (2025 Change):", "Buffering Agents (2025 Change):"])
    }

    private var cprAdjunctsContent: AttributedString {
        ContentFormatter.format("""
        Mechanical CPR (2025):
        Trials show NO superiority over high-quality manual CPR. Routine use NOT recommended. Acceptable only when manual CPR is unsafe or ineffective (e.g., transport, limited manpower).

        Chain of Survival (2025):
        NOW STANDARDIZED—one universal chain regardless of age (adult/pediatric) or location (in-hospital/out-of-hospital).

        ALS Termination of Resuscitation (2025):
        Do NOT rely on EtCO₂ alone. Consider ALL: arrest not witnessed, no bystander CPR, no ROSC before transport, no shocks delivered. If all criteria met, termination may be appropriate.
        """, headings: ["Mechanical CPR (2025):", "Chain of Survival (2025):", "ALS Termination of Resuscitation (2025):"])
    }

    private var airwayContent: AttributedString {
        ContentFormatter.format("""
        Ventilation (2025 Language Update):
        "Give oxygen" updated to: "Begin bag-mask ventilation and give oxygen." Rescue breaths fully reinstated (COVID-era hesitation removed).

        Advanced Airway (2025 Change):
        Advanced airway moved earlier in algorithm. ETI should be performed by experienced providers. SGAs are acceptable alternatives to ETI.

        Capnography (2025 Change):
        Shift from quantitative to CONTINUOUS waveform capnography. Emphasizes CPR quality monitoring, not just ETI confirmation.
        """, headings: ["Ventilation (2025 Language Update):", "Advanced Airway (2025 Change):", "Capnography (2025 Change):"])
    }

    private var postROSCContent: AttributedString {
        ContentFormatter.format("""
        ROSC Now Has Own Algorithm (2025):
        ROSC removed from side panel of arrest algorithm—now has a dedicated post-cardiac arrest algorithm.

        Hemodynamics (2025 Change):
        Target MAP ≥65 mmHg. Systolic BP targets REMOVED. Focus solely on MAP.

        Oxygenation (2025 Change):
        Maintain FiO₂ 100% until SpO₂ or PaO₂ reliably measurable. SpO₂ targets slightly widened. Removed fixed "10 breaths per minute" language—focus on avoiding hyperventilation.

        Temperature Management (2025 Change):
        Target range updated: 32°C–37.5°C (broadened from ≤36°C). TTM for at least 36 hours. Avoid hyperthermia.

        Diagnostics & Intervention:
        Strong push toward early 12-lead ECG, CT, ultrasound. Early coronary angiography and PCI. Consider mechanical circulatory support when appropriate.

        Neurologic Prognostication:
        Assessment off sedation and neuromuscular blockade. Multimodal prognostication emphasized.
        """, headings: ["ROSC Now Has Own Algorithm (2025):", "Hemodynamics (2025 Change):", "Oxygenation (2025 Change):", "Temperature Management (2025 Change):", "Diagnostics & Intervention:", "Neurologic Prognostication:"])
    }
    
    private var bradycardiaContent: AttributedString {
        ContentFormatter.format("""
        Assessment First (2025 Change):
        Cardiopulmonary compromise now assessed FIRST. Check for: hypotension, altered mental status, shock, ischemic chest discomfort, acute heart failure.
        
        Treatment Priority:
        Treat compromise BEFORE addressing underlying cause. IV access now assumed (removed from explicit steps).
        
        Medications (Unchanged):
        Atropine 1 mg IV (may repeat q3-5 min, max 3 mg). If refractory: Dopamine 2-20 mcg/kg/min or Epinephrine 2-10 mcg/min. Consider transcutaneous then transvenous pacing.
        """, headings: ["Assessment First (2025 Change):", "Treatment Priority:", "Medications (Unchanged):"])
    }
    
    private var tachycardiaContent: AttributedString {
        ContentFormatter.format("""
        Synchronized Cardioversion (2025):
        Now has its own dedicated algorithm. If energy unknown → use maximum device settings. Language changed from "consider sedation" to "sedate whenever feasible."
        
        Antiarrhythmic Changes (2025):
        SOTALOL REMOVED for stable wide-QRS tachycardia—no demonstrated outcome benefit.
        
        Energy Updates (2025):
        • Atrial fibrillation/flutter: ≥200J biphasic
        • Narrow complex tachycardia: 100J
        • Monomorphic VT: 100J
        • Polymorphic VT: Unsynchronized high-energy defibrillation (treat as VF)
        """, headings: ["Synchronized Cardioversion (2025):", "Antiarrhythmic Changes (2025):", "Energy Updates (2025):"])
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
                        PremiumLightCloseButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }

                    // MARK: - Title Section
                    VStack(spacing: 16) {
                        // Heart icon with glass effect
                        ZStack {
                            if colorScheme == .dark {
                                Circle()
                                    .fill(CriticalDesign.Colors.cardBlue)
                                    .frame(width: 80, height: 80)
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [CriticalDesign.Colors.gold.opacity(0.6), CriticalDesign.Colors.gold.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                                    .frame(width: 80, height: 80)
                            } else {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 80, height: 80)
                                Circle()
                                    .fill(Color.white.opacity(0.5))
                                    .frame(width: 80, height: 80)
                                Circle()
                                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                    .frame(width: 80, height: 80)
                            }

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
                        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.1), radius: 10, y: 4)

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
                        title: "CPR Adjuncts",
                        icon: "waveform.path.ecg",
                        content: cprAdjunctsContent
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
                        title: "Bradycardia",
                        icon: "heart.slash.fill",
                        content: bradycardiaContent
                    )
                    
                    PremiumLightGlassCard(
                        title: "Tachycardia",
                        icon: "bolt.heart.fill",
                        content: tachycardiaContent
                    )

                    // MARK: - Critical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
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

struct AclsUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        AclsUpdateView()
    }
}
