//
//  ImpellaDetailView.swift
//  CriticalX
//
//  Tabbed detail view for Impella content — reduces scrolling
//  by splitting the dense clinical content into 5 focused tabs.
//  Updated: Adaptive dark/light mode using CriticalDesign system
//

import SwiftUI

// MARK: - Impella Tab Enum
enum ImpellaTab: String, CaseIterable {
    case overview = "Overview"
    case waveforms = "Waveforms"
    case monitoring = "Monitoring"
    case complications = "Complications"
    case protocols = "Protocols"

    var icon: String {
        switch self {
        case .overview: return "info.circle.fill"
        case .waveforms: return "waveform.path.ecg"
        case .monitoring: return "heart.text.square"
        case .complications: return "exclamationmark.triangle.fill"
        case .protocols: return "list.clipboard"
        }
    }
}

// MARK: - Impella Detail View
struct ImpellaDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: ImpellaTab = .overview

    var body: some View {
        ZStack {
            VADAdaptiveBackground()

            VStack(spacing: 0) {
                // MARK: - Header (compact)
                VStack(spacing: 12) {
                    Capsule()
                        .fill(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)

                    HStack(spacing: 16) {
                        if UIImage(named: "Impella") != nil {
                            Image("Impella")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.2) : Color.black.opacity(0.1), radius: 8)
                        } else {
                            Image(systemName: "heart.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Impella")
                                .font(.custom("Poppins-Bold", size: 28))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                            Text("Temporary Mechanical Circulatory Support")
                                .font(.custom("Poppins-Regular", size: 12))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)

                // MARK: - Tab Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ImpellaTab.allCases, id: \.self) { tab in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedTab = tab
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: tab.icon)
                                        .font(.system(size: 11, weight: .semibold))
                                    Text(tab.rawValue)
                                        .font(.custom("Poppins-Medium", size: 12))
                                }
                                .foregroundColor(selectedTab == tab
                                    ? (colorScheme == .dark ? .white : CriticalDesign.Colors.cardBlue)
                                    : CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(
                                    Group {
                                        if selectedTab == tab {
                                            Capsule()
                                                .fill(CriticalDesign.Colors.gold)
                                        } else if colorScheme == .dark {
                                            Capsule()
                                                .fill(Color.white.opacity(0.08))
                                        } else {
                                            Capsule()
                                                .fill(Color.black.opacity(0.05))
                                        }
                                    }
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            selectedTab == tab
                                                ? CriticalDesign.Colors.gold.opacity(0.8)
                                                : (colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.08)),
                                            lineWidth: 1
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }

                // MARK: - Tab Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        switch selectedTab {
                        case .overview:
                            overviewContent
                        case .waveforms:
                            waveformsContent
                        case .monitoring:
                            monitoringContent
                        case .complications:
                            complicationsContent
                        case .protocols:
                            protocolsContent
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
        }
    }

    // MARK: - Overview Tab
    private var overviewContent: some View {
        Group {
            VADAdaptiveInfoCard(
                title: "What Is the Impella?",
                content: "The Impella is a temporary, catheter-based micro-axial pump for short-term mechanical circulatory support. It is the most commonly used percutaneous ventricular assist device in cardiogenic shock and high-risk PCI.\n\nIt sits across the aortic valve\u{2014}pulling blood from the LV and ejecting it into the ascending aorta. This actively unloads the left ventricle, reduces myocardial oxygen demand, and improves end-organ perfusion.",
                accentColor: CriticalDesign.Colors.accentTeal
            )

            VADAdaptiveInfoCard(
                title: "Indications",
                content: "\u{2022} Cardiogenic shock (most common)\n\u{2022} High-risk PCI (hemodynamic support during intervention)\n\u{2022} Acute decompensated heart failure\n\u{2022} Post-cardiotomy shock\n\u{2022} Bridge to decision or recovery"
            )

            VADAdaptiveInfoCard(
                title: "Device Sizes",
                content: "Impella 2.5: up to 2.5 L/min \u{2014} percutaneous via femoral artery (13 Fr). Smallest profile. Primarily for high-risk PCI. Approved \u{2264} 6 hours (HRPCI) or \u{2264} 4 days (shock).\n\nImpella CP (SmartAssist): up to ~4 L/min \u{2014} percutaneous via femoral artery (14 Fr). Most commonly placed in cardiogenic shock. Optical sensor for real-time positioning.\n\nImpella 5.0: up to 5.0 L/min \u{2014} surgical cutdown via axillary or femoral artery (21 Fr). For more severe shock. Approved up to 14 days.\n\nImpella 5.5 (SmartAssist): up to 5.5 L/min \u{2014} surgical via axillary artery (preferred). 19 Fr pump. Allows patient mobilization. Approved up to 14 days.\n\nImpella RP: up to 4.4 L/min \u{2014} right-sided support. Percutaneous via femoral vein. Crosses tricuspid and pulmonic valves. Used for RV failure. Approved up to 14 days."
            )

            VADAdaptiveInfoCard(
                title: "Positioning",
                content: "Correct inlet positioning by device:\n\u{2022} Impella CP / 2.5 / 5.0: inlet sits 3.5 cm (\u{00B1} 0.5 cm) below the aortic annulus in the LV\n\u{2022} Impella 5.5: inlet sits 4.5 cm (\u{00B1} 0.5 cm) below the aortic annulus in the LV\n\nThe outlet must remain in the ascending aorta above the aortic valve. If both inlet and outlet end up on the same side of the valve, the device will not generate forward flow.\n\nPositioning is confirmed by:\n1. Fluoroscopy (gold standard during placement)\n2. Bedside echocardiography (TTE or TEE)\n3. Impella controller waveforms (motor current should be pulsatile)"
            )
        }
    }

    // MARK: - Waveforms Tab
    private var waveformsContent: some View {
        Group {
            VADAdaptiveInfoCard(
                title: "\u{1F7E2} Motor Current (Green)",
                content: "Measures resistance to blood flow through the pump.\n\nShould be PULSATILE\u{2014}peaks when the aortic valve opens (more flow), valleys when it closes (less flow).\n\nA flat (non-pulsatile) motor current means the inlet and outlet are on the same side of the aortic valve \u{2192} the device has migrated.\n\nThis is your fastest bedside clue that the Impella is out of position.",
                accentColor: CriticalDesign.Colors.accentGreen
            )

            VADAdaptiveInfoCard(
                title: "\u{1F534} Placement Signal (Red)",
                content: "Estimated pressure near the Impella outlet (in the aorta).\n\nShould resemble an aortic pressure waveform.\n\nThis is NOT an accurate arterial pressure\u{2014}do not use it for hemodynamic decisions.",
                accentColor: CriticalDesign.Colors.accentRed
            )

            VADAdaptiveInfoCard(
                title: "\u{26AA} LV Pressure (White)",
                content: "Estimated pressure near the Impella inlet (in the LV).\n\nDerived from the optical sensor and motor current (SmartAssist devices).\n\nShould show LV pressure pattern with negative diastolic dip. Normal diastolic LV pressure may reach -10 mmHg on Impella support.\n\nDiastolic pressure < -40 mmHg triggers suction alarm."
            )

            VADAdaptiveWarningCard(
                title: "Position Alarms",
                content: "\"Position in Ventricle\": BOTH signals show ventricular morphology + flat motor current. Device slipped too deep. Response: reduce to P-2, carefully retract until aortic signal appears, then pull back additional 4 cm.\n\n\"Position Wrong\" (in aorta): Placement signal shows aortic waveform + flat motor current. Device pulled back too far. Response: reduce to P-2, reposition under fluoroscopy or echo.\n\n\"Position Unknown\": Native heart pulsatility too low for controller to determine position. Common in severe shock. Confirm with bedside echo."
            )
        }
    }

    // MARK: - Monitoring Tab
    private var monitoringContent: some View {
        Group {
            VADAdaptiveInfoCard(
                title: "Hemodynamic Targets",
                content: "\u{2022} MAP > 60 mmHg (avoid excessive\u{2014}increases afterload)\n\u{2022} CVP < 15 mmHg\n\u{2022} Cardiac index > 2.0 L/min/m\u{00B2}\n\u{2022} SvO\u{2082} > 50\u{2013}60%\n\u{2022} Cardiac power output (CPO) > 0.6 Watts\n\u{2022} PAPi > 1.0 (screens for RV failure)\n\u{2022} Lactate trending down toward < 2.0 mmol/L",
                accentColor: CriticalDesign.Colors.accentTeal
            )

            VADAdaptiveInfoCard(
                title: "A-Line Interpretation",
                content: "Use an A-line for continuous BP monitoring.\n\n\u{2022} If the ventricle is contracting, you'll see pulsatile A-line waveforms\n\u{2022} If the ventricle is too weak, the A-line may show a dampened or flat waveform (constant Impella-generated pressure)\n\u{2022} As the heart recovers, pulsatility returns\u{2014}this is a sign of myocardial recovery"
            )

            VADAdaptiveInfoCard(
                title: "P-Level Management",
                content: "P-level (P-2 through P-9) controls how hard the device pulls blood.\n\n\u{2022} Higher P = more flow, but increased risk of suction\n\u{2022} P-2 is the lowest operating level (used during CPR and weaning)\n\u{2022} Never turn the Impella completely off while still in the patient\u{2014}stagnant blood will clot on the rotor\n\nGoal: Maximize flow (cardiac output) without triggering suction."
            )
        }
    }

    // MARK: - Complications Tab
    private var complicationsContent: some View {
        Group {
            VADAdaptiveWarningCard(
                title: "Suction Alarm Management",
                content: "The Impella is a preload-dependent device. Suction alarms almost always mean the LV doesn't have enough volume."
            )

            VADAdaptiveInfoCard(
                title: "Step 1 \u{2014} Verify Position",
                content: "Use bedside echo (TTE/TEE) to confirm inlet is in the LV at proper depth. If fluoroscopy is available, use it.\n\nMalpositioning will cause persistent suction regardless of volume status.\n\nCheck the controller: a flat motor current = device has migrated.",
                accentColor: CriticalDesign.Colors.accentTeal
            )

            VADAdaptiveInfoCard(
                title: "Step 2 \u{2014} Volume Resuscitate",
                content: "Give 500 mL crystalloid bolus (LR or NS). Most alarms resolve after one or two boluses.\n\nReassess after each bolus. Check CVP/PCWP: if < 10 mmHg, the patient likely needs more volume."
            )

            VADAdaptiveInfoCard(
                title: "Step 3 \u{2014} Reduce P-Level",
                content: "Reduce P-level by 1\u{2013}2 (do not drop below P-2). Once alarm clears and volume is optimized, increase back toward goal."
            )

            VADAdaptiveInfoCard(
                title: "Step 4 \u{2014} Consider Other Causes",
                content: "\u{2022} Catheter migration \u{2192} needs repositioning under fluoroscopy\n\u{2022} RV failure \u{2192} consider inotropes or Impella RP\n\u{2022} Tamponade or tension pneumothorax\n\u{2022} LV recovery \u{2192} LV may be too small for current flow (good sign\u{2014}reduce P-level)"
            )

            VADAdaptiveWarningCard(
                title: "Hemolysis Monitoring",
                content: "Labs q6\u{2013}12h: plasma-free hemoglobin (most specific), LDH, haptoglobin, indirect bilirubin, urine hemoglobin.\n\nSeverity (pfHgb):\n\u{2022} < 10 mg/dL \u{2192} normal\n\u{2022} 10\u{2013}40 mg/dL \u{2192} mild, monitor\n\u{2022} > 40 mg/dL \u{2192} clinically significant\n\u{2022} > 100 mg/dL \u{2192} severe \u{2014} risk of AKI\n\nIf detected: check position, reduce P-level, check purge flow. If refractory, device may need removal."
            )

            VADAdaptiveWarningCard(
                title: "Limb Ischemia",
                content: "Occurs in ~10% of patients. Assess the access limb every 1\u{2013}2 hours:\n\n\u{2022} Distal pulses (DP, PT) \u{2014} palpation and Doppler\n\u{2022} Skin color, temperature, capillary refill\n\u{2022} Sensation and motor function\n\u{2022} Compare to contralateral limb\n\nIf suspected: notify interventional/surgical team immediately. A distal perfusion catheter may be placed."
            )
        }
    }

    // MARK: - Protocols Tab
    private var protocolsContent: some View {
        Group {
            VADAdaptiveInfoCard(
                title: "Anticoagulation",
                content: "Systemic:\n\u{2022} Target ACT: 160\u{2013}180 seconds\n\u{2022} Heparin preferred (short half-life, reversible)\n\u{2022} Initial bolus: 50\u{2013}70 units/kg\n\u{2022} Maintenance: 5\u{2013}10 units/kg/hour\n\u{2022} In active bleeding: heparin may be held\u{2014}maximize P-level to maintain flow\n\nPurge system:\n\u{2022} Rate: 3\u{2013}30 mL/hour (auto-regulated)\n\u{2022} Solution: D5W with 25 units/mL heparin\n\u{2022} Replace purge bag every 24 hours\n\u{2022} HIGH purge pressure \u{2192} kink or obstruction\n\u{2022} LOW purge pressure \u{2192} leak or disconnection\n\u{2022} Rising motor current + dropping purge flow = impending device failure",
                accentColor: CriticalDesign.Colors.accentTeal
            )

            VADAdaptiveWarningCard(
                title: "Critical Safety Rules",
                content: "\u{2022} Don't raise HOB > 30 degrees (catheter can migrate)\n\u{2022} Never manually reposition\u{2014}requires fluoroscopy\n\u{2022} CPR: Reduce to P-2 first (high speeds cause hemolysis)\n\u{2022} Never turn device off while in patient (blood will clot)\n\u{2022} Aortic regurgitation: Impella can worsen AR\u{2014}monitor closely"
            )

            VADAdaptiveInfoCard(
                title: "Weaning Protocol",
                content: "Prerequisites:\n\u{2022} Patient on \u{2264} 2 inotropes at reduced doses\n\u{2022} Hemodynamically stable \u{2265} 48 hours\n\u{2022} Lactate normalizing\n\u{2022} End-organ function improving\n\nSteps:\n1. Reduce flow by 0.5 L/min per hour (decrease P-level incrementally)\n2. Monitor at each step: CI > 2.0, SvO\u{2082} > 55%, lactate < 2.5, pH > 7.30\n3. If deterioration at any step, go back up one level\n4. Goal: reach P-2 with stable hemodynamics\n5. At P-2, reverse anticoagulation and remove\n6. Hold manual pressure or use closure device"
            )

            VADAdaptiveInfoCard(
                title: "Transport Checklist",
                content: "\u{2713} Confirm catheter position via echo before moving\n\u{2713} Controller secured and red plug at heart level\n\u{2713} Backup battery fully charged\n\u{2713} Purge bag adequate volume remaining\n\u{2713} ACT within target range\n\u{2713} Distal pulses confirmed in access limb\n\u{2713} A-line functioning and transduced\n\u{2713} Emergency contact for VAD/interventional team available"
            )

            VADAdaptiveInfoCard(
                title: "Troubleshooting Low Flow",
                content: "Systematic approach:\n1. Catheter position \u{2014} check waveforms and confirm with echo. Is motor current pulsatile?\n2. Volume status \u{2014} is the patient hypovolemic? Give a fluid challenge.\n3. RV failure \u{2014} check CVP, PAPi, consider RV support.\n4. Purge flow \u{2014} is pressure normal? Is bag empty or kinked?\n5. Device malfunction \u{2014} is motor current rising unexpectedly? Could indicate thrombus.\n6. Afterload \u{2014} is MAP too high? Elevated afterload reduces forward flow.",
                accentColor: CriticalDesign.Colors.accentRed
            )
        }
    }
}

// MARK: - Preview
#Preview {
    ImpellaDetailView()
}
