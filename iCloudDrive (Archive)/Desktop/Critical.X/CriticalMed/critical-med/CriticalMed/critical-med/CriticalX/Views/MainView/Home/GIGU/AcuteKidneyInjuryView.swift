//
//  AcuteKidneyInjuryView.swift
//  CriticalX
//
//  Premium Light Theme - Acute Kidney Injury Education
//  Following ECMOView design patterns
//

import SwiftUI

// MARK: - AKI Stage Model
struct AKIStage: Identifiable {
    let id = UUID()
    let stage: String
    let creatinine: String
    let urineOutput: String
    let color: Color
}

// MARK: - Acute Kidney Injury View
struct AcuteKidneyInjuryView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var showAllPearls = false
    
    // Accent color
    private let accentColor = Color(red: 0.70, green: 0.45, blue: 0.55) // Dusty rose
    
    // KDIGO AKI Stages
    private let akiStages: [AKIStage] = [
        AKIStage(stage: "Stage 1", creatinine: "1.5-1.9x baseline OR ≥0.3 mg/dL increase", urineOutput: "<0.5 mL/kg/h for 6-12h", color: Color(red: 0.85, green: 0.65, blue: 0.15)),
        AKIStage(stage: "Stage 2", creatinine: "2.0-2.9x baseline", urineOutput: "<0.5 mL/kg/h for ≥12h", color: Color(red: 0.85, green: 0.50, blue: 0.20)),
        AKIStage(stage: "Stage 3", creatinine: "≥3.0x baseline OR ≥4.0 mg/dL OR RRT initiation", urineOutput: "<0.3 mL/kg/h for ≥24h OR anuria ≥12h", color: Color(red: 0.75, green: 0.30, blue: 0.30))
    ]
    
    // MARK: - Formatted Content
    private var overviewContent: AttributedString {
        ContentFormatter.format("""
        This Is Common:
        You'll see AKI in about half your ICU patients. The good news: most cases are fixable if you catch them early and stop doing harm.

        The Simple Framework:
        Pre-renal (not enough blood flow), intrinsic (kidney damage), or post-renal (obstruction). Figure out which one, and the treatment follows.

        How You Know It's AKI:
        Creatinine rises ≥0.3 in 48 hours, or ≥1.5x baseline in a week, or urine output drops below 0.5 mL/kg/hr for 6 hours. That's it.
        """, headings: ["This Is Common:", "The Simple Framework:", "How You Know It's AKI:"], isDarkMode: colorScheme == .dark)
    }

    private var etiologyContent: AttributedString {
        ContentFormatter.format("""
        Pre-Renal (Most Common):
        The kidneys are fine—they're just not getting enough blood. Dehydration, heart failure, sepsis, or drugs that cut renal blood flow (NSAIDs, ACE-I/ARBs). Urine Na usually <20 mEq/L.

        ATN (Acute Tubular Necrosis):
        Prolonged hypotension, sepsis, aminoglycosides, contrast, rhabdomyolysis, vancomycin at high doses. Urine Na usually >40 mEq/L. Muddy brown casts on microscopy.

        AIN (Acute Interstitial Nephritis):
        Think drugs: PPIs and β-lactams are the most common culprits. The classic triad (fever, rash, eosinophilia) is present in <30% of cases—don't wait for it. May need steroids.

        Post-Renal (Obstruction):
        Something's blocking urine flow. BPH in older men, kidney stones, malignancy. Get an ultrasound—this is the easy one to fix.
        """, headings: ["Pre-Renal (Most Common):", "ATN (Acute Tubular Necrosis):", "AIN (Acute Interstitial Nephritis):", "Post-Renal (Obstruction):"], isDarkMode: colorScheme == .dark)
    }

    private var workupContent: AttributedString {
        ContentFormatter.format("""
        Start With The History:
        What's their volume status? What drugs are they on? Did they get contrast? Recent surgery or hypotension?

        Basic Labs:
        BMP (watch the potassium), urinalysis with microscopy, urine lytes if you need them. CK if rhabdo is on your radar.

        FENa—When It Helps:
        FENa <1% suggests pre-renal, >2% suggests ATN. On diuretics? Use FEUrea instead (<35% = pre-renal).

        When FENa/FEUrea Is Unreliable:
        Don't trust it in: CKD stage 4-5, contrast-induced AKI, rhabdomyolysis, or early sepsis. In these cases, clinical context matters more.

        Get An Ultrasound:
        Rule out obstruction. Takes 5 minutes and changes management completely if you find hydronephrosis.

        Look At The Urine:
        Muddy brown casts = ATN. RBC casts = glomerulonephritis. WBC casts or eosinophils = think AIN. The sediment tells you a lot.
        """, headings: ["Start With The History:", "Basic Labs:", "FENa—When It Helps:", "When FENa/FEUrea Is Unreliable:", "Get An Ultrasound:", "Look At The Urine:"], isDarkMode: colorScheme == .dark)
    }

    private var managementContent: AttributedString {
        ContentFormatter.format("""
        Fluid Strategy:
        Use balanced crystalloids (LR, Plasmalyte)—avoid large NS boluses. Give 250-500 mL, reassess, repeat. Stop if no response or signs of overload. No colloids for AKI.

        When NOT To Give Fluids:
        Cardiogenic shock, pulmonary edema, post-resuscitation fluid overload, oliguric despite adequate CVP/PCWP, RV failure, or severe sepsis already resuscitated.

        Stop The Nephrotoxins:
        This is half the battle. Hold NSAIDs, aminoglycosides, ACE-I/ARBs (temporarily), contrast. Review the med list.

        Treat The Cause:
        Obstruction? Relieve it. Sepsis? Source control and antibiotics. Heart failure? Optimize. The kidney usually recovers if you remove the insult.

        When To Dialyze (AEIOU):
        • Acidosis: pH <7.1 refractory to bicarb
        • Electrolytes: K+ ≥6.5 or ECG changes despite medical therapy
        • Intoxication: Toxic alcohols, lithium, metformin
        • Overload: Diuretic-resistant volume overload
        • Uremia: Encephalopathy, pericarditis, bleeding
        """, headings: ["Fluid Strategy:", "When NOT To Give Fluids:", "Stop The Nephrotoxins:", "Treat The Cause:", "When To Dialyze (AEIOU):"], isDarkMode: colorScheme == .dark)
    }

    private var preventionContent: AttributedString {
        ContentFormatter.format("""
        Know Your High-Risk Patients:
        CKD, diabetes, heart failure, elderly, sepsis, post-op, contrast exposure. These patients need extra vigilance.

        Before Contrast:
        Hydrate with saline before and after (1 mL/kg/hr x 6-12 hours). Minimize contrast volume. Hold metformin for 48 hours after.

        In The OR:
        Keep MAP >65. Avoid big fluid swings. Limit nephrotoxin exposure. Goal-directed therapy works.

        In Sepsis:
        Early antibiotics and source control. Don't keep pushing fluids once they're resuscitated—fluid overload is also bad for kidneys.

        Watch Your Drugs:
        Adjust renally-cleared medications. Monitor levels for aminoglycosides and vancomycin. Don't stack nephrotoxins.
        """, headings: ["Know Your High-Risk Patients:", "Before Contrast:", "In The OR:", "In Sepsis:", "Watch Your Drugs:"], isDarkMode: colorScheme == .dark)
    }

    // Clinical Pearls
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(
            header: "FENa Has Limits:",
            content: "FENa is unreliable with diuretics (use FEUrea <35%), CKD stage 4-5, contrast-induced AKI, rhabdo, and early sepsis. Clinical context wins."
        ),
        CriticalPearlItem(
            header: "Creatinine Lags Behind:",
            content: "Cr rises 24-48 hours AFTER the injury. A normal creatinine doesn't mean the kidneys are fine. Watch urine output."
        ),
        CriticalPearlItem(
            header: "Fluids Aren't Always The Answer:",
            content: "Don't give fluids in cardiogenic shock, pulmonary edema, RV failure, or sepsis already resuscitated. Assess first, then treat."
        ),
        CriticalPearlItem(
            header: "AIN Hides Well:",
            content: "The classic triad (fever, rash, eosinophilia) is present in <30% of AIN. PPIs and β-lactams are the most common causes. Think of it early."
        ),
        CriticalPearlItem(
            header: "AEIOU Thresholds:",
            content: "Dialyze for pH <7.1, K+ ≥6.5 (or ECG changes), toxic alcohols/lithium/metformin, refractory overload, or uremic symptoms."
        )
    ]
    
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
                    
                    // MARK: - Hero Header
                    heroHeader
                    
                    // MARK: - Overview Card
                    PremiumLightGlassCard(
                        title: "Overview",
                        icon: "doc.text.fill",
                        content: overviewContent
                    )
                    
                    // MARK: - KDIGO Staging Card
                    stagingCard
                    
                    // MARK: - Etiology Card
                    etiologyCard
                    
                    // MARK: - Workup Card
                    PremiumLightGlassCard(
                        title: "Diagnostic Workup",
                        icon: "magnifyingglass",
                        content: workupContent
                    )
                    
                    // MARK: - Management Card
                    PremiumLightGlassCard(
                        title: "Management",
                        icon: "cross.case.fill",
                        content: managementContent
                    )
                    
                    // MARK: - Prevention Card
                    preventionCard
                    
                    // MARK: - RRT Link Card
                    rrtLinkCard
                    
                    // MARK: - Clinical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .padding(.bottom, 40)
                }
            }
        }
    }
    
    // MARK: - Hero Header
    private var heroHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                if colorScheme == .dark {
                    Circle()
                        .fill(CriticalDesign.Colors.cardBlue)
                        .frame(width: 140, height: 140)
                } else {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 140, height: 140)
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 140, height: 140)
                }

                Circle()
                    .stroke(accentColor.opacity(0.5), lineWidth: 2)
                    .frame(width: 140, height: 140)

                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(accentColor)
            }
            .shadow(color: colorScheme == .dark ? Color.clear : accentColor.opacity(0.2), radius: 10, y: 4)
            
            Text("AKI")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
            
            Text("Acute Kidney Injury")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(accentColor)
                .multilineTextAlignment(.center)
            
            // Quick stats
            HStack(spacing: 24) {
                quickStat(icon: "chart.bar.fill", value: "50%", label: "ICU Incidence")
                quickStat(icon: "exclamationmark.triangle.fill", value: "High", label: "Mortality Risk")
            }
            .padding(.top, 8)
        }
        .padding(.bottom, 12)
    }
    
    private func quickStat(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(accentColor)

            Text(value)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))

            Text(label)
                .font(.custom("Poppins-Regular", size: 11))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : Color(red: 0.4, green: 0.4, blue: 0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(accentColor.opacity(colorScheme == .dark ? 0.4 : 0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Staging Card
    private var stagingCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: "chart.bar.doc.horizontal.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [accentColor.opacity(0.9), accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: accentColor.opacity(0.3), radius: 4, y: 2)
                
                Text("KDIGO Staging")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            // Stages
            VStack(spacing: 12) {
                ForEach(akiStages) { stage in
                    stageRow(stage: stage)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            accentColor.opacity(0.4),
                            colorScheme == .dark ? accentColor.opacity(0.15) : Color.white.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : accentColor.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    private func stageRow(stage: AKIStage) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(stage.stage)
                .font(.custom("Poppins-Bold", size: 13))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(stage.color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Cr: \(stage.creatinine)")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Text("UO: \(stage.urineOutput)")
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.35, green: 0.35, blue: 0.4))
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(stage.color.opacity(colorScheme == .dark ? 0.12 : 0.08))
        )
    }
    
    // MARK: - Etiology Card (Accent)
    private var etiologyCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Etiology")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(accentColor)
                    
                    Text("Pre-renal • Intrinsic • Post-renal")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : Color(red: 0.4, green: 0.4, blue: 0.5))
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "arrow.triangle.branch")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(accentColor)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            Text(etiologyContent)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.15), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.1), Color.white.opacity(0.3), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            accentColor.opacity(0.4),
                            colorScheme == .dark ? accentColor.opacity(0.15) : Color.white.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : accentColor.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Prevention Card (Warning style - orange)
    private var preventionCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [Color.green.opacity(0.9), Color.green.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.green.opacity(0.3), radius: 4, y: 2)
                
                Text("Prevention Strategies")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            Text(preventionContent)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.green.opacity(0.08))
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.green.opacity(0.05))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : Color.green.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - RRT Link Card
    private var rrtLinkCard: some View {
        NavigationLink(destination: RenalReplacementTherapyView()) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.15))
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: "drop.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Renal Replacement Therapy")
                        .font(.custom("Poppins-Bold", size: 17))
                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
                    
                    Text("When medical management fails")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.25, green: 0.25, blue: 0.3))
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.12))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
            }
            .padding(18)
            .background(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.ultraThinMaterial)
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.white.opacity(0.5))
                        }
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.4),
                                colorScheme == .dark
                                    ? Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.15)
                                    : Color.white.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
            .shadow(color: colorScheme == .dark ? Color.clear : Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    AcuteKidneyInjuryView()
}
