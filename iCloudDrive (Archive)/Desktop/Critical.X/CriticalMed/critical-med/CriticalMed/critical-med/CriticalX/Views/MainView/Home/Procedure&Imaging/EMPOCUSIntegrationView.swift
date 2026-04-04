//
//  EMPOCUSIntegrationView.swift
//  CriticalX
//
//  EM & Prehospital POCUS Integration + Educational Foundations
//  Ties all ultrasound protocols together with clinical workflows
//  CriticalDesign system
//

import SwiftUI

struct EMPOCUSIntegrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false

    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "The right probe for the right question:", content: "Phased array is the universal emergency probe — cardiac, lung, abdominal, FAST. Linear for vascular access, DVT, soft tissue, ocular. Curvilinear for aorta and deep abdominal. If you only have one probe in the field, make it a phased array."),
        CriticalPearlItem(header: "10-second rule for cardiac arrest:", content: "During pulse checks (every 2 minutes), you have exactly 10 seconds. Pre-load the subxiphoid view. When compressions pause, look for organized cardiac activity. If you see standstill, prognosis is grim."),
        CriticalPearlItem(header: "Prehospital FAST changes transport decisions:", content: "Positive FAST in the field = direct to trauma center, bypass community hospital. This single finding can shave 30-60 minutes off definitive care. Time is blood."),
        CriticalPearlItem(header: "Depth and gain are your two knobs:", content: "If you can only learn two controls, learn depth (how deep you're looking) and gain (how bright the image is). Everything else is refinement. Start with the default preset and adjust these two."),
        CriticalPearlItem(header: "Artifacts aren't errors — they're information:", content: "A-lines, B-lines, shadowing, enhancement — these artifacts tell you about tissue properties. Learning what artifacts mean is more valuable than learning anatomy for POCUS.")
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Colors.canvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    headerSection
                    prehospitalSection
                    traumaWorkflowSection
                    undifferentiatedHypotensionSection
                    cardiacArrestSection
                    probeSelectionGuide
                    knobologySection
                    artifactsSection

                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)

                    clinicalTakeawayCard

                    Spacer(minLength: CriticalDesign.Spacing.xxl)
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
                .padding(.vertical, CriticalDesign.Spacing.lg)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CriticalFavoriteButton(title: "POCUS Integration", type: "Ultrasound")
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) { isAppearing = true }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.goldDeep.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)

                ZStack {
                    Circle()
                        .fill(colorScheme == .dark
                            ? CriticalDesign.Colors.cardBlue.opacity(0.85)
                            : Color.white.opacity(0.9))
                        .frame(width: 80, height: 80)

                    Circle()
                        .stroke(colorScheme == .dark
                            ? Color.white.opacity(0.12)
                            : Color.white.opacity(0.8), lineWidth: 1)
                        .frame(width: 80, height: 80)

                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [CriticalDesign.Colors.goldDeep, CriticalDesign.Colors.accentRed],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("POCUS Integration")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("EM, Prehospital & Educational Foundations")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.top, CriticalDesign.Spacing.md)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Prehospital POCUS
    private var prehospitalSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Prehospital POCUS", icon: "cross.case.fill", color: CriticalDesign.Colors.accentRed)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.lg) {
                // Single-Probe Approach
                subsectionCard(
                    title: "The Single-Probe Approach",
                    icon: "antenna.radiowaves.left.and.right",
                    color: CriticalDesign.Colors.accentRed,
                    body: "In the field, you often have one probe and limited time. The **phased array** is your universal prehospital probe — it does cardiac, lung, abdominal, and FAST views."
                )

                // Modified 2-View FAST
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("Modified 2-View Prehospital FAST", subtitle: "90 seconds")

                    numberedFindingRow(
                        number: "1",
                        title: "Subxiphoid",
                        detail: "Pericardial effusion, gross cardiac activity, RV/LV comparison. Answers: is there fluid around the heart? Is the heart moving?",
                        color: CriticalDesign.Colors.accentRed
                    )

                    numberedFindingRow(
                        number: "2",
                        title: "RUQ (Morrison's Pouch)",
                        detail: "The most sensitive single view for hemoperitoneum. Free fluid here in a trauma patient = direct to trauma center.",
                        color: CriticalDesign.Colors.accentOrange
                    )

                    calloutBox(
                        text: "Why just 2 views? Time. In the prehospital setting, you need answers in 60-90 seconds. These two views have the highest yield.",
                        icon: "clock.fill",
                        color: CriticalDesign.Colors.accentBlue
                    )
                }

                // Pneumothorax Detection
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("Prehospital Pneumothorax Detection", subtitle: nil)

                    bulletRow(text: "**Absent lung sliding** + trauma = pneumothorax", color: CriticalDesign.Colors.accentRed)
                    bulletRow(text: "This finding supports **needle decompression** in a decompensating patient", color: CriticalDesign.Colors.accentOrange)
                    bulletRow(text: "If you see B-lines or lung sliding, pneumothorax is **ruled out** at that point", color: CriticalDesign.Colors.accentGreen)
                }

                // Cardiac Standstill
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("Cardiac Standstill in the Field", subtitle: nil)

                    findingActionRow(
                        finding: "Organized cardiac activity",
                        action: "Continue resuscitation, identify and treat reversible causes",
                        color: CriticalDesign.Colors.accentGreen
                    )
                    findingActionRow(
                        finding: "True standstill (no wall motion)",
                        action: "Poor prognosis (survival <2%). Consider termination per protocol.",
                        color: CriticalDesign.Colors.accentRed
                    )
                    findingActionRow(
                        finding: "PEA",
                        action: "Look for reversible causes — tamponade, massive PE with dilated RV",
                        color: CriticalDesign.Colors.accentOrange
                    )
                }
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.accentRed.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(CriticalDesign.Colors.accentRed.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.05), value: isAppearing)
    }

    // MARK: - Trauma Workflow
    private var traumaWorkflowSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Trauma Resuscitation Workflow", icon: "figure.fall", color: CriticalDesign.Colors.accentOrange)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                subsectionCard(
                    title: "When to Scan",
                    icon: "clock.badge.checkmark",
                    color: CriticalDesign.Colors.accentOrange,
                    body: "**eFAST happens during \"C\" (Circulation)** — after securing the airway and ensuring breathing, while the team is establishing IV access and starting fluids."
                )

                calloutBox(
                    text: "The 3-minute rule: The entire eFAST should take <3 minutes. If you're spending longer, you're overthinking it. The goal is triage, not diagnosis.",
                    icon: "timer",
                    color: CriticalDesign.Colors.accentOrange
                )

                workflowRow(step: "1", title: "Positive FAST + Unstable", action: "Immediate OR. Do not pass CT.", color: CriticalDesign.Colors.accentRed)
                workflowRow(step: "2", title: "Positive FAST + Stable", action: "CT abdomen/pelvis for characterization. Surgery on standby.", color: CriticalDesign.Colors.accentOrange)
                workflowRow(step: "3", title: "Negative FAST + High mechanism", action: "CT regardless. FAST sensitivity is 73-88%. Retroperitoneal and solid organ injuries can be missed.", color: CriticalDesign.Colors.accentBlue)
                workflowRow(step: "4", title: "Negative FAST + Low mechanism", action: "Serial FAST at 30 min, 1 hr, 4 hr. Observe. Fluid accumulates over time.", color: CriticalDesign.Colors.accentGreen)
                workflowRow(step: "5", title: "Absent lung sliding", action: "Pneumothorax. If tension physiology (hypotension, JVD), needle decompression then chest tube.", color: CriticalDesign.Colors.accentPurple)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - Undifferentiated Hypotension
    private var undifferentiatedHypotensionSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Undifferentiated Hypotension", icon: "waveform.path.ecg", color: CriticalDesign.Colors.accentPurple)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                subsectionCard(
                    title: "The RUSH Exam Is Your Algorithm",
                    icon: "list.number",
                    color: CriticalDesign.Colors.accentPurple,
                    body: "When a patient presents with undifferentiated hypotension, RUSH organizes your ultrasound evaluation into three steps."
                )

                // RUSH Steps
                numberedFindingRow(
                    number: "1",
                    title: "PUMP",
                    detail: "Is the heart squeezing? Hyperdynamic vs hypodynamic, pericardial effusion, RV dilation.",
                    color: CriticalDesign.Colors.accentRed
                )
                numberedFindingRow(
                    number: "2",
                    title: "TANK",
                    detail: "Is the tank full or empty? IVC size/collapsibility, free fluid, B-lines for pulmonary edema.",
                    color: CriticalDesign.Colors.accentBlue
                )
                numberedFindingRow(
                    number: "3",
                    title: "PIPES",
                    detail: "Are the pipes intact? Aorta measurement, DVT compression.",
                    color: CriticalDesign.Colors.accentGreen
                )

                // Shock Type Matrix
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("Shock Type Matrix", subtitle: nil)

                    shockRow(type: "Hypovolemic", pump: "Hyperdynamic", tank: "Small IVC, ± free fluid", pipes: "Normal", action: "Volume resuscitation", color: CriticalDesign.Colors.accentOrange)
                    shockRow(type: "Cardiogenic", pump: "Hypodynamic", tank: "Plethoric IVC, B-lines", pipes: "Normal", action: "Pressors, NOT fluids", color: CriticalDesign.Colors.accentRed)
                    shockRow(type: "Obstructive (PE)", pump: "Dilated RV", tank: "Plethoric IVC", pipes: "DVT+", action: "Thrombolytics / anticoagulation", color: CriticalDesign.Colors.accentPurple)
                    shockRow(type: "Obstructive (Tamponade)", pump: "Effusion, RV collapse", tank: "Plethoric IVC", pipes: "Normal", action: "Pericardiocentesis", color: CriticalDesign.Colors.accentBlue)
                    shockRow(type: "Distributive (Sepsis)", pump: "Hyperdynamic", tank: "Variable IVC", pipes: "Normal", action: "Fluids, vasopressors, source control", color: CriticalDesign.Colors.accentGreen)
                }
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.accentPurple.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(CriticalDesign.Colors.accentPurple.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - Cardiac Arrest Sonography
    private var cardiacArrestSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Cardiac Arrest Sonography", icon: "bolt.heart", color: CriticalDesign.Colors.accentRed)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.lg) {
                subsectionCard(
                    title: "The 10-Second Scan Protocol",
                    icon: "timer",
                    color: CriticalDesign.Colors.accentRed,
                    body: "During CPR, pre-position the phased array probe in the subxiphoid position. When compressions pause for a pulse check (every 2 minutes), you have **exactly 10 seconds** to assess."
                )

                // Question 1
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("Is There Organized Cardiac Activity?", subtitle: nil)

                    findingActionRow(
                        finding: "Wall motion present",
                        action: "Continue CPR, identify and treat reversible causes",
                        color: CriticalDesign.Colors.accentGreen
                    )
                    findingActionRow(
                        finding: "Cardiac standstill",
                        action: "Poor prognosis (survival <2%). Consider termination per protocol.",
                        color: CriticalDesign.Colors.accentRed
                    )
                }

                // Question 2
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("Is There a Reversible Cause?", subtitle: nil)

                    findingActionRow(
                        finding: "Pericardial effusion",
                        action: "Tamponade — pericardiocentesis",
                        color: CriticalDesign.Colors.accentPurple
                    )
                    findingActionRow(
                        finding: "Dilated RV",
                        action: "Massive PE — thrombolytics",
                        color: CriticalDesign.Colors.accentBlue
                    )
                    findingActionRow(
                        finding: "Empty, hyperdynamic heart",
                        action: "Hypovolemia — volume resuscitation",
                        color: CriticalDesign.Colors.accentOrange
                    )
                    findingActionRow(
                        finding: "Normal-appearing heart in PEA",
                        action: "Consider tension PTX (absent lung sliding), hyperkalemia, toxicologic causes",
                        color: CriticalDesign.Colors.accentTeal
                    )
                }

                // IVC Bonus
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("IVC Assessment", subtitle: "bonus if time allows")

                    findingActionRow(
                        finding: "Plethoric IVC",
                        action: "Obstructive cause — tamponade, PE, tension PTX",
                        color: CriticalDesign.Colors.accentRed
                    )
                    findingActionRow(
                        finding: "Flat IVC",
                        action: "Hypovolemia",
                        color: CriticalDesign.Colors.accentOrange
                    )
                }

                // Rules
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("Rules", subtitle: nil)

                    bulletRow(text: "Do **NOT** interrupt compressions for more than 10 seconds", color: CriticalDesign.Colors.accentRed)
                    bulletRow(text: "**Pre-load** the probe position BEFORE the pulse check", color: CriticalDesign.Colors.accentOrange)
                    bulletRow(text: "**Designate one person** as the ultrasound operator", color: CriticalDesign.Colors.accentBlue)
                    bulletRow(text: "**Communicate findings** immediately to the team leader", color: CriticalDesign.Colors.accentGreen)
                }
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Probe Selection Guide
    private var probeSelectionGuide: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Probe Selection Guide", icon: "sensor.tag.radiowaves.forward", color: CriticalDesign.Colors.accentTeal)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                probeRow(
                    name: "Phased Array",
                    frequency: "1-5 MHz",
                    footprint: "Small",
                    uses: "Cardiac, lung, abdominal (eFAST), RUSH. The universal emergency probe. Fits between ribs.",
                    color: CriticalDesign.Colors.accentRed
                )

                probeRow(
                    name: "Curvilinear",
                    frequency: "2-5 MHz",
                    footprint: "Large",
                    uses: "Aorta, renal, gallbladder, eFAST (RUQ/LUQ/pelvis), OB. Best penetration for deep structures.",
                    color: CriticalDesign.Colors.accentBlue
                )

                probeRow(
                    name: "Linear",
                    frequency: "7.5-15 MHz",
                    footprint: "Large, flat",
                    uses: "Vascular access, DVT, soft tissue, ocular, MSK, pneumothorax. Best resolution for superficial structures.",
                    color: CriticalDesign.Colors.accentGreen
                )

                probeRow(
                    name: "Endocavitary",
                    frequency: "5-10 MHz",
                    footprint: "Cylindrical",
                    uses: "Pelvic (transvaginal), peritonsillar abscess, transrectal. Not commonly used in emergency POCUS.",
                    color: CriticalDesign.Colors.accentPurple
                )
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.25), value: isAppearing)
    }

    // MARK: - Knobology
    private var knobologySection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Knobology Basics", icon: "dial.low", color: CriticalDesign.Colors.accentBlue)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.lg) {
                // Controls
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("Five Essential Controls", subtitle: nil)

                    knobRow(
                        number: "1",
                        name: "Depth",
                        description: "How deep you're looking. Start deeper than you think, then decrease until your target fills most of the screen.",
                        values: "Cardiac: 15-20cm  |  Lung: 6-10cm  |  Vascular: 3-5cm",
                        color: CriticalDesign.Colors.accentRed
                    )

                    knobRow(
                        number: "2",
                        name: "Gain",
                        description: "Overall image brightness. Too bright = everything washes out. Too dark = you miss pathology.",
                        values: "Adjust until fluid is black and tissue has good contrast",
                        color: CriticalDesign.Colors.accentOrange
                    )

                    knobRow(
                        number: "3",
                        name: "TGC (Time-Gain Compensation)",
                        description: "Individual gain adjustments for different depths. Deep structures naturally appear darker due to attenuation.",
                        values: "Push bottom sliders right to brighten deep structures",
                        color: CriticalDesign.Colors.accentBlue
                    )

                    knobRow(
                        number: "4",
                        name: "Frequency",
                        description: "Higher frequency = better resolution but less penetration. Lower frequency = more penetration but less resolution.",
                        values: "If the image is grainy, try lowering frequency",
                        color: CriticalDesign.Colors.accentGreen
                    )

                    knobRow(
                        number: "5",
                        name: "Focus",
                        description: "The depth at which the image is sharpest. Set focus at the level of your target structure.",
                        values: "Multiple focus zones slow frame rate",
                        color: CriticalDesign.Colors.accentPurple
                    )
                }

                // Modes
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    subsectionTitle("Imaging Modes", subtitle: nil)

                    modeRow(
                        name: "B-mode",
                        description: "Standard 2D grayscale. Your default for everything.",
                        color: CriticalDesign.Colors.accentBlue
                    )

                    modeRow(
                        name: "M-mode",
                        description: "Motion over time. Single line displayed as a scrolling graph. Used for IVC respiratory variation, lung sliding (seashore/barcode), TAPSE, diaphragm excursion.",
                        color: CriticalDesign.Colors.accentTeal
                    )

                    modeRow(
                        name: "Color Doppler",
                        description: "Shows blood flow direction (red toward probe, blue away). Used for vascular assessment, valvular regurgitation, confirming vessel identity.",
                        color: CriticalDesign.Colors.accentRed
                    )
                }
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.3), value: isAppearing)
    }

    // MARK: - Common Artifacts
    private var artifactsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Common Artifacts Guide", icon: "waveform", color: CriticalDesign.Colors.accentOrange)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                artifactRow(
                    name: "Posterior Acoustic Enhancement",
                    description: "Increased brightness deep to a fluid-filled structure. Sound passes through fluid with less attenuation.",
                    clinical: "Confirms fluid collection (abscess, cyst, effusion). Key sign for abscess ID.",
                    color: CriticalDesign.Colors.accentBlue
                )

                artifactRow(
                    name: "Posterior Acoustic Shadowing",
                    description: "Dark stripe behind a dense structure. Sound is reflected or absorbed, creating a shadow.",
                    clinical: "Seen behind gallstones, renal stones, bone, calcifications, foreign bodies.",
                    color: CriticalDesign.Colors.accentPurple
                )

                artifactRow(
                    name: "Reverberation (A-lines)",
                    description: "Horizontal lines that repeat at regular intervals below a strong reflector.",
                    clinical: "A-lines in lung = normal aerated lung (or pneumothorax if no sliding).",
                    color: CriticalDesign.Colors.accentGreen
                )

                artifactRow(
                    name: "Comet-Tail / B-lines",
                    description: "Vertical hyperechoic lines from the pleural surface to the bottom of the screen.",
                    clinical: "B-lines = interstitial fluid (pulmonary edema, pneumonia). 3+ per space is pathologic.",
                    color: CriticalDesign.Colors.accentTeal
                )

                artifactRow(
                    name: "Mirror Artifact",
                    description: "A structure appears duplicated on the other side of a strong reflector (usually the diaphragm).",
                    clinical: "The liver can appear to be \"above\" the diaphragm. This is normal — don't mistake for a mass.",
                    color: CriticalDesign.Colors.accentOrange
                )

                artifactRow(
                    name: "Edge (Side Lobe) Artifact",
                    description: "Echoes appear within an anechoic structure (bladder or gallbladder) from off-axis sound beams.",
                    clinical: "Can mimic sludge or debris. Change probe angle — true pathology persists, artifacts disappear.",
                    color: CriticalDesign.Colors.accentRed
                )
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.35), value: isAppearing)
    }

    // MARK: - Clinical Takeaway
    private var clinicalTakeawayCard: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            Image("LogoMonogram")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)

            VStack(alignment: .leading, spacing: 4) {
                Text("The Clinical Takeaway")
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text("POCUS isn't a separate skill — it's how you practice medicine. It connects trauma assessment, shock resuscitation, respiratory failure workup, and cardiac arrest management into a unified visual language. Master the protocols, learn the artifacts, and the probe becomes an extension of your clinical thinking.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(CriticalDesign.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.4), value: isAppearing)
    }

    // MARK: - Reusable Component Helpers

    private func sectionHeader(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            Text(title)
                .font(.custom("Poppins-Bold", size: 18))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
    }

    /// Bold subsection title with optional subtitle tag
    private func subsectionTitle(_ title: String, subtitle: String?) -> some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Text(title)
                .font(.custom("Poppins-Bold", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color.gray.opacity(0.12)))
            }
        }
    }

    /// Small card with icon, bold title, and body text
    private func subsectionCard(title: String, icon: String, color: Color, body: String) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
                Text(title)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(color)
            }

            Text(CriticalDesign.markdownToAttributedString(body))
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(4)
        }
    }

    /// Numbered row: circle number + bold title + detail text
    private func numberedFindingRow(number: String, title: String, detail: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Text(number)
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(detail)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
            }
        }
    }

    /// Finding → Action row with colored indicator
    private func findingActionRow(finding: String, action: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: "arrow.right.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(finding)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(color)
                Text(action)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
            }
        }
    }

    /// Colored bullet point row with bold markdown support
    private func bulletRow(text: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            Text(CriticalDesign.markdownToAttributedString(text))
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(4)
        }
    }

    /// Highlighted callout box with icon
    private func calloutBox(text: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
                .padding(.top, 2)

            Text(CriticalDesign.markdownToAttributedString(text))
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(4)
        }
        .padding(CriticalDesign.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(color.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(color.opacity(0.15), lineWidth: 1)
                )
        )
    }

    /// Workflow step row (numbered circle + title + action)
    private func workflowRow(step: String, title: String, action: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Text(step)
                .font(.custom("Poppins-Bold", size: 13))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(action)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
            }
        }
    }

    /// Shock type row with Pump/Tank/Pipes/Action layout
    private func shockRow(type: String, pump: String, tank: String, pipes: String, action: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(type)
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 4) {
                labelValue("Pump", pump)
                labelValue("Tank", tank)
                labelValue("Pipes", pipes)
                labelValue("Action", action)
            }
        }
        .padding(CriticalDesign.Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(color.opacity(0.04))
        )
    }

    private func labelValue(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(label):")
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .frame(width: 50, alignment: .leading)
            Text(value)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    /// Probe type row
    private func probeRow(name: String, frequency: String, footprint: String, uses: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(color)
                    .frame(width: 4, height: 20)
                Text(name)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            HStack(spacing: CriticalDesign.Spacing.md) {
                specBadge(label: "Frequency", value: frequency, color: color)
                specBadge(label: "Footprint", value: footprint, color: color)
            }
            .padding(.leading, 16)

            Text(uses)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(4)
                .padding(.leading, 16)
        }
        .padding(.bottom, CriticalDesign.Spacing.sm)
    }

    /// Small spec badge (e.g. "Frequency: 1-5 MHz")
    private func specBadge(label: String, value: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Text(label + ":")
                .font(.custom("Poppins-SemiBold", size: 10))
                .foregroundColor(color.opacity(0.8))
            Text(value)
                .font(.custom("Poppins-Medium", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(Capsule().fill(color.opacity(0.08)))
    }

    /// Knobology control row
    private func knobRow(number: String, name: String, description: String, values: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Text(number)
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text(description)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)

                Text(values)
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(color.opacity(0.08))
                    )
            }
        }
    }

    /// Imaging mode row
    private func modeRow(name: String, description: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 4, height: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(color)
                Text(description)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
            }
        }
    }

    /// Artifact row with name, description, clinical significance
    private func artifactRow(name: String, description: String, clinical: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "waveform.path")
                    .font(.system(size: 12))
                    .foregroundColor(color)
                Text(name)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(color)
            }

            Text(description)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(4)
                .padding(.leading, 24)

            HStack(alignment: .top, spacing: 4) {
                Text("Clinical:")
                    .font(.custom("Poppins-Bold", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(clinical)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineSpacing(4)
            }
            .padding(.leading, 24)
        }
        .padding(.bottom, CriticalDesign.Spacing.sm)
    }

    private var neumorphicCardBackground: some View {
        Group {
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.cardBlue)
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            } else {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(LinearGradient(
                        colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            }
        }
    }
}

#Preview {
    NavigationView { EMPOCUSIntegrationView() }
}
