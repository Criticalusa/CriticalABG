//
//  LungUltrasoundView.swift
//  CriticalX
//
//  Lung Ultrasound & BLUE Protocol Hub View
//  CriticalDesign system with 5-section teaching flow
//

import SwiftUI

// MARK: - Lung US Sign Data Model
struct LungUSSign: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

// MARK: - Lung Ultrasound View
struct LungUltrasoundView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false

    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Lung sliding rules out pneumothorax at that point:", content: "If you see lung sliding, there is no pneumothorax at that interspace. But pneumothorax can exist elsewhere — always scan multiple zones."),
        CriticalPearlItem(header: "B-lines rule out pneumothorax too:", content: "B-lines originate from the visceral pleura. If you see B-lines, the lung is against the chest wall at that point. No pneumothorax there."),
        CriticalPearlItem(header: "Count B-lines per zone:", content: "0-2 per intercostal space is normal. ≥3 in a single zone is pathological. Bilateral diffuse B-lines = pulmonary edema until proven otherwise."),
        CriticalPearlItem(header: "Lung point is 100% specific:", content: "The lung point — where sliding meets non-sliding — is pathognomonic for pneumothorax. If you find it, the diagnosis is certain."),
        CriticalPearlItem(header: "The BLUE protocol takes 3 minutes:", content: "With practice, you can differentiate the major causes of acute dyspnea in under 3 minutes. It's faster and more accurate than a chest X-ray for most diagnoses.")
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Colors.canvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    headerSection
                    orientationCard
                    fundamentalSignsSection
                    blueProtocolSection
                    clinicalPatternsSection
                    probePositioningSection
                    diaphragmAssessmentSection

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
                CriticalFavoriteButton(title: "Lung Ultrasound", type: "Ultrasound")
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.accentTeal.opacity(0.15))
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

                    Image(systemName: "lungs.fill")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [CriticalDesign.Colors.accentTeal, CriticalDesign.Colors.accentBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("Lung Ultrasound")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("BLUE Protocol & Lung Assessment")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.top, CriticalDesign.Spacing.md)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Orientation Card
    private var orientationCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Orientation", icon: "scope", color: CriticalDesign.Colors.accentTeal)

            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Circle()
                    .fill(CriticalDesign.Colors.accentTeal)
                    .frame(width: 6, height: 6)
                    .padding(.top, 5)
                Text("Lung ultrasound is the ")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                + Text("most accurate bedside tool")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                + Text(" for diagnosing the cause of acute respiratory failure. It's more sensitive than chest X-ray for pneumothorax, pleural effusion, pulmonary edema, and consolidation.")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            .lineSpacing(6)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
                Text("The BLUE Protocol")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text("Bedside Lung Ultrasound in Emergency — provides a decision tree that diagnoses the cause of acute dyspnea in under 3 minutes. Validated in 301 ICU patients with 90.5% diagnostic accuracy.")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineSpacing(6)
            }

            Text("You're learning a language of artifacts. Each sign tells you something specific about what's happening at the pleural interface. Master six signs and you can diagnose almost anything at the bedside.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.05), value: isAppearing)
    }

    // MARK: - Fundamental Signs Section
    private var fundamentalSignsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Fundamental Signs", icon: "waveform.path.ecg", color: CriticalDesign.Colors.accentBlue)

            // A-Lines
            signCard(
                title: "A-Lines",
                tagline: "\"Dry Lung\"",
                tagColor: CriticalDesign.Colors.accentGreen,
                content: """
                **What they are:** Horizontal, hyperechoic lines that repeat at regular intervals below the pleural line. They are reverberation artifacts of the pleura itself.

                **What they mean:** The lung is aerated. Air is present at the pleural surface. This is normal — but it's also what you see in COPD, asthma, and PE (where the lung is aerated but gas exchange is impaired).

                **Key point:** A-lines + lung sliding = normal lung. A-lines + absent lung sliding = consider pneumothorax or apnea.
                """
            )

            // B-Lines
            signCard(
                title: "B-Lines",
                tagline: "\"Wet Lung\"",
                tagColor: CriticalDesign.Colors.accentBlue,
                content: """
                **What they are:** Vertical, hyperechoic lines that originate from the pleural line and extend to the bottom of the screen without fading. They move with lung sliding and erase A-lines.

                **What they mean:** Interstitial fluid. The alveolar-interstitial space is thickened, usually by fluid.

                **Counting matters:**
                - **0-2 per intercostal space** — Normal. Everyone has a few, especially at the bases.
                - **≥3 per space (B+ lines)** — Pathological. Interstitial syndrome.
                - **Confluent B-lines (white-out)** — Severe interstitial syndrome or alveolar edema.

                **Bilateral diffuse B-lines** = pulmonary edema (cardiogenic or ARDS). **Focal B-lines** = pneumonia, contusion, or atelectasis.
                """
            )

            imageNeededNote("B-lines bilateral (pulmonary edema) GIF needed here")

            // Lung Sliding
            signCard(
                title: "Lung Sliding",
                tagline: "Pleural Movement",
                tagColor: CriticalDesign.Colors.accentTeal,
                content: """
                **What it is:** A shimmering, to-and-fro movement at the pleural line. The visceral pleura glides against the parietal pleura during respiration.

                **Seashore Sign (M-mode):** Place M-mode over the pleural line. Above the pleural line: parallel lines (motionless chest wall). Below: granular, sandy pattern (moving lung). This is the seashore sign — normal.

                **Barcode/Stratosphere Sign (M-mode):** If lung sliding is absent, M-mode shows parallel lines both above AND below the pleural line. This is the barcode or stratosphere sign — abnormal. Consider pneumothorax.

                **Lung sliding present → no pneumothorax at that point.** This has a negative predictive value of nearly 100%.
                """
            )

            imageNeededNote("Lung sliding seashore sign (M-mode) GIF needed here")
            imageNeededNote("Absent lung sliding barcode sign (M-mode) GIF needed here")

            // Lung Pulse
            signCard(
                title: "Lung Pulse",
                tagline: "Cardiac Transmitted Motion",
                tagColor: CriticalDesign.Colors.accentPurple,
                content: """
                **What it is:** Subtle rhythmic movement at the pleural line that corresponds to the heartbeat — NOT respiration.

                **Why it matters:** Lung pulse differentiates two causes of absent lung sliding:
                - **Pneumothorax** — No lung pulse (air separates the pleurae entirely)
                - **Atelectasis / mainstem intubation** — Lung pulse present (lung is against the chest wall but not ventilating)

                **Clinical pearl:** If you see absent lung sliding but lung pulse is present, check ETT position before reaching for a needle.
                """
            )

            // Lung Point
            signCard(
                title: "Lung Point",
                tagline: "100% Specific",
                tagColor: CriticalDesign.Colors.accentRed,
                content: """
                **What it is:** The transition point where lung sliding meets absent lung sliding. In real-time, you see the pleural line alternate between sliding and non-sliding with each breath.

                **What it means:** This is where the edge of the pneumothorax meets normal lung. It is **100% specific** for pneumothorax — if you see it, the diagnosis is certain.

                **How to find it:** Start anteriorly (where pneumothorax collects in supine patients). If no sliding, move the probe laterally along the same intercostal space until you find the transition point.

                **Limitation:** A massive pneumothorax may not have a lung point because the entire hemithorax is involved.
                """
            )
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - BLUE Protocol Section
    private var blueProtocolSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "BLUE Protocol Decision Tree", icon: "arrow.triangle.branch", color: CriticalDesign.Colors.accentPurple)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                    Text("The BLUE Protocol uses ")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    + Text("three signs")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    + Text(" — lung sliding, A-lines vs B-lines, and venous thrombosis — to classify acute dyspnea into profiles. Each profile maps to a diagnosis.")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                }
                .lineSpacing(6)

                // Decision Pathway
                blueProfileRow(
                    profile: "A-Profile",
                    signs: "Lung sliding + A-lines (bilateral) + No DVT",
                    diagnosis: "COPD or Asthma exacerbation",
                    color: CriticalDesign.Colors.accentGreen
                )

                blueProfileRow(
                    profile: "A-Profile + DVT",
                    signs: "Lung sliding + A-lines + DVT positive",
                    diagnosis: "Pulmonary Embolism",
                    color: CriticalDesign.Colors.accentRed
                )

                blueProfileRow(
                    profile: "B-Profile",
                    signs: "Lung sliding + Bilateral diffuse B-lines",
                    diagnosis: "Pulmonary Edema (cardiogenic)",
                    color: CriticalDesign.Colors.accentBlue
                )

                blueProfileRow(
                    profile: "B'-Profile",
                    signs: "Absent lung sliding + B-lines",
                    diagnosis: "Pneumonia",
                    color: CriticalDesign.Colors.accentOrange
                )

                blueProfileRow(
                    profile: "A'-Profile",
                    signs: "Absent lung sliding + A-lines + Lung point",
                    diagnosis: "Pneumothorax",
                    color: CriticalDesign.Colors.accentRed
                )

                blueProfileRow(
                    profile: "C-Profile",
                    signs: "Anterior lung consolidation",
                    diagnosis: "Pneumonia (consolidation pattern)",
                    color: CriticalDesign.Colors.accentOrange
                )

                blueProfileRow(
                    profile: "PLAPS Positive",
                    signs: "Posterior/lateral consolidation ± effusion",
                    diagnosis: "Pneumonia (posterior pattern)",
                    color: CriticalDesign.Colors.accentOrange
                )
            }
            .padding(CriticalDesign.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.accentPurple.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(CriticalDesign.Colors.accentPurple.opacity(0.2), lineWidth: 1)
                    )
            )

            imageNeededNote("BLUE protocol decision tree diagram needed here")
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - Clinical Patterns Section
    private var clinicalPatternsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Clinical Patterns", icon: "stethoscope", color: CriticalDesign.Colors.accentOrange)

            // Pleural Effusion
            patternCard(
                title: "Pleural Effusion",
                color: CriticalDesign.Colors.accentBlue,
                content: """
                **Quad Sign:** Anechoic (dark) fluid bounded by the chest wall above, diaphragm below, and lung tissue on either side. This creates a quadrilateral shape.

                **Sinusoid Sign (M-mode):** The lung moves toward and away from the chest wall with breathing, creating a sinusoidal pattern. This confirms the fluid is free-flowing (simple effusion).

                **Jellyfish Sign:** The atelectatic lung tip floats in the effusion and undulates like a jellyfish. Seen in moderate-to-large effusions.

                **Volume estimation:** Measure the maximal effusion depth in cm at the posterior axillary line. Depth in mm × 20 ≈ volume in mL. A depth >5cm typically suggests >500mL.
                """
            )

            imageNeededNote("Pleural effusion (quad sign) GIF needed here")

            // Consolidation
            patternCard(
                title: "Lung Consolidation",
                color: CriticalDesign.Colors.accentOrange,
                content: """
                **Hepatization:** Consolidated lung looks like liver tissue — a solid, echogenic structure where you normally see aerated lung. The lung has lost its air and filled with fluid/pus/cells.

                **Air Bronchograms:** Bright, punctate or linear echoes within the consolidated lung representing air-filled bronchi surrounded by fluid-filled alveoli.
                - **Static air bronchograms** — Don't move with breathing. Seen in atelectasis and some pneumonias.
                - **Dynamic air bronchograms** — Move with breathing. Highly specific for pneumonia (rules out simple atelectasis).

                **Shred Sign:** Irregular, shredded border between consolidated and aerated lung. Helps identify partial consolidation.
                """
            )

            imageNeededNote("Lung consolidation with air bronchograms GIF needed here")

            // Pulmonary Edema
            patternCard(
                title: "Pulmonary Edema",
                color: CriticalDesign.Colors.accentTeal,
                content: """
                **Pattern:** Bilateral, diffuse B-lines in ≥3 zones per hemithorax. B-lines are symmetric and widespread.

                **Cardiogenic vs ARDS:**
                - **Cardiogenic edema** — Smooth pleural line, homogeneous B-lines, bilateral pleural effusions, responsive to diuresis. The B-lines will decrease as you diurese.
                - **ARDS** — Thickened/irregular pleural line, inhomogeneous B-lines with spared areas, subpleural consolidations, fewer effusions.

                **Monitoring diuresis:** Lung ultrasound is excellent for tracking response to treatment. Scan the same zones before and after diuretics. Fewer B-lines = your treatment is working.
                """
            )
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Probe Positioning Section
    private var probePositioningSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Probe Positioning", icon: "hand.point.up.left.fill", color: CriticalDesign.Colors.accentTeal)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                    Circle()
                        .fill(CriticalDesign.Colors.accentTeal)
                        .frame(width: 6, height: 6)
                        .padding(.top, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Probe:")
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        Text("Linear (for pneumothorax, detailed pleural assessment) or curvilinear/phased array (for effusions, consolidation, deeper structures).")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .lineSpacing(6)
                    }
                }

                Text("3-Zone Approach per hemithorax (6 zones total):")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                zoneRow(
                    zone: "1",
                    name: "Upper BLUE Point",
                    location: "Anterior chest, 3rd-4th ICS, midclavicular line",
                    finds: "Pneumothorax (air rises anteriorly in supine), A-lines vs B-lines",
                    color: CriticalDesign.Colors.accentGreen
                )

                zoneRow(
                    zone: "2",
                    name: "Lower BLUE Point",
                    location: "Anterior chest, 5th-6th ICS, anterior axillary line",
                    finds: "B-lines (earliest in dependent areas), lung sliding assessment",
                    color: CriticalDesign.Colors.accentBlue
                )

                zoneRow(
                    zone: "3",
                    name: "PLAPS Point",
                    location: "Posterior-lateral, intersection of posterior axillary line and a horizontal line from lower BLUE point",
                    finds: "Consolidation, effusion (fluid collects posteriorly in supine)",
                    color: CriticalDesign.Colors.accentPurple
                )

                HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                    Circle()
                        .fill(CriticalDesign.Colors.accentTeal)
                        .frame(width: 6, height: 6)
                        .padding(.top, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Scan both sides.")
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        Text("Always compare right to left. Asymmetry is often more informative than isolated findings.")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .lineSpacing(6)
                    }
                }

                HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                    Circle()
                        .fill(CriticalDesign.Colors.accentTeal)
                        .frame(width: 6, height: 6)
                        .padding(.top, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Orientation:")
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        (Text("Place the probe longitudinally (indicator cephalad) between two ribs. You should see two ribs with their shadows, and the bright pleural line between them — the ")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        + Text("bat sign")
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        + Text(". This is your landmark for every lung scan.")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme)))
                        .lineSpacing(6)
                    }
                }
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)

            imageNeededNote("Thorax zones body diagram needed here")
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.25), value: isAppearing)
    }

    // MARK: - Diaphragm Assessment Section
    private var diaphragmAssessmentSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Diaphragm Assessment", icon: "arrow.up.and.down.circle", color: CriticalDesign.Colors.accentGreen)

            // Excursion
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                    Text("Diaphragm Excursion (M-mode)")
                        .font(.custom("Poppins-Bold", size: 15))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                }

                Text("Place the curvilinear probe subcostally, angled cephalad, using the liver (right) or spleen (left) as an acoustic window. Apply M-mode to capture diaphragm movement over time.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)

                diaphragmRow(finding: "Normal excursion", value: ">2cm quiet breathing, >4cm deep inspiration", color: CriticalDesign.Colors.accentGreen)
                diaphragmRow(finding: "Reduced excursion", value: "<2cm suggests diaphragm weakness", color: CriticalDesign.Colors.accentOrange)
                diaphragmRow(finding: "Paradoxical movement", value: "Diaphragm moves cephalad during inspiration — suggests paralysis", color: CriticalDesign.Colors.accentRed)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)

            // Thickening Fraction
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: "ruler")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                    Text("Thickening Fraction (B-mode)")
                        .font(.custom("Poppins-Bold", size: 15))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                }

                Text("Measure diaphragm thickness in the zone of apposition (8th-9th ICS, anterior axillary line) at end-inspiration and end-expiration.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)

                // Formula
                Text("TF = (Insp thickness - Exp thickness) / Exp thickness × 100")
                    .font(.custom("Poppins-SemiBold", size: 12))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)
                    .padding(CriticalDesign.Spacing.sm)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                            .fill(CriticalDesign.Colors.accentBlue.opacity(0.06))
                    )

                diaphragmRow(finding: ">30-36%", value: "Normal, adequate diaphragm function", color: CriticalDesign.Colors.accentGreen)
                diaphragmRow(finding: "<20%", value: "Diaphragm dysfunction, predict extubation failure", color: CriticalDesign.Colors.accentRed)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)

            // Clinical relevance callout
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "stethoscope")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentGreen)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Clinical relevance:")
                        .font(.custom("Poppins-SemiBold", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    Text("Diaphragm US predicts extubation success better than many traditional weaning parameters. If you're deciding whether to extubate, this scan takes 2 minutes and adds real data.")
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .lineSpacing(4)
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.accentGreen.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                            .stroke(CriticalDesign.Colors.accentGreen.opacity(0.15), lineWidth: 1)
                    )
            )

            imageNeededNote("Diaphragm excursion M-mode GIF needed here")
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.3), value: isAppearing)
    }

    // MARK: - Clinical Takeaway Card
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

                Text("Lung ultrasound tells you what the chest X-ray can't — in real time, at the bedside, in under 3 minutes. Six signs. Six diagnoses. Sliding, A-lines, B-lines, lung point, consolidation, effusion. Learn the language of artifacts and you'll never wait for a portable chest X-ray again.")
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
        .animation(.easeOut(duration: 0.4).delay(0.35), value: isAppearing)
    }

    // MARK: - Helper Views
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

    private func signCard(title: String, tagline: String, tagColor: Color, content: String) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Text(title)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text(tagline)
                    .font(.custom("Poppins-SemiBold", size: 11))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(tagColor))
            }

            Text(CriticalDesign.markdownToAttributedString(content))
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
    }

    private func patternCard(title: String, color: Color, content: String) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(title)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text(CriticalDesign.markdownToAttributedString(content))
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
    }

    private func blueProfileRow(profile: String, signs: String, diagnosis: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(color)
                Text(profile)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(color)
            }
            Text(signs)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .padding(.leading, 26)
            HStack(spacing: 4) {
                Text("→")
                    .font(.custom("Poppins-Bold", size: 13))
                    .foregroundColor(color)
                Text(diagnosis)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            .padding(.leading, 26)
        }
    }

    private func zoneRow(zone: String, name: String, location: String, finds: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Text(zone)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(.white)
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(color))

                Text(name)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            Text(location)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .padding(.leading, 38)
            Text("Finds: \(finds)")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .padding(.leading, 38)
        }
    }

    private func diaphragmRow(finding: String, value: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .padding(.top, 5)

            VStack(alignment: .leading, spacing: 2) {
                Text(finding)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(color)
                Text(value)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
        }
    }

    private func imageNeededNote(_ text: String) -> some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 14))
                .foregroundColor(CriticalDesign.Colors.accentOrange)
            Text(text)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .italic()
        }
        .padding(CriticalDesign.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(CriticalDesign.Colors.accentOrange.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(CriticalDesign.Colors.accentOrange.opacity(0.15), style: StrokeStyle(lineWidth: 1, dash: [5]))
                )
        )
    }

    // MARK: - Neumorphic Card Background
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
                ZStack {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(
                            LinearGradient(
                                colors: [Color.white, Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(Color.clear)
                        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
                        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 10, y: 10)
                        .shadow(color: Color.white, radius: 12, x: -6, y: -6)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        LungUltrasoundView()
    }
}
