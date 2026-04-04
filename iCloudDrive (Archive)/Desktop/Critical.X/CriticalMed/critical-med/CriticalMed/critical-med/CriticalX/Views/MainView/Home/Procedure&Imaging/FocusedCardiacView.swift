//
//  FocusedCardiacView.swift
//  CriticalX
//
//  Focused Cardiac Ultrasound Hub View
//  4 Standard Windows + Clinical Assessment Skills
//  CriticalDesign system with 5-section teaching flow
//

import SwiftUI

// MARK: - Focused Cardiac View
struct FocusedCardiacView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false

    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Get any view you can:", content: "In a crashing patient, don't chase the perfect window. Any view that shows you the heart is better than no view. If subxiphoid fails, try parasternal. If parasternal fails, try apical."),
        CriticalPearlItem(header: "RV bigger than LV = PE until proven otherwise:", content: "In the apical 4-chamber view, the RV should be about 60% the size of the LV. If the RV is equal to or larger than the LV, think massive PE. This is an actionable finding."),
        CriticalPearlItem(header: "EPSS >7mm = reduced EF:", content: "In PLAX, measure from the anterior mitral leaflet at maximum opening to the septum. EPSS >7mm correlates with reduced ejection fraction. >10mm suggests EF <30%. Quick, reproducible, objective."),
        CriticalPearlItem(header: "Dark fluid around the heart is not always tamponade:", content: "Pericardial effusion ≠ tamponade. Tamponade is a clinical diagnosis supported by echo findings: RV diastolic collapse, RA systolic collapse, plethoric IVC. A chronic effusion can be large without tamponade."),
        CriticalPearlItem(header: "This view connects to everything:", content: "RUSH Pump evaluation uses these same windows. eFAST subxiphoid is your entry point. Lung US connects through B-lines and effusions. Master these four views and you've unlocked the entire cardiac POCUS toolkit.")
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Colors.canvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    headerSection
                    orientationCard
                    windowsSection
                    lvFunctionSection
                    rvStrainSection
                    pericardialEffusionSection
                    wallMotionSection

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
                CriticalFavoriteButton(title: "Focused Cardiac", type: "Ultrasound")
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
                    .fill(CriticalDesign.Colors.accentBlue.opacity(0.15))
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

                    Image(systemName: "heart.fill")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [CriticalDesign.Colors.accentRed, CriticalDesign.Colors.accentBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("Focused Cardiac")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("Basic Echocardiography Views")
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
            sectionHeader(title: "Orientation", icon: "scope", color: CriticalDesign.Colors.accentRed)

            Text("Focused cardiac ultrasound gives you real-time answers to questions that used to require a cardiology consult and a formal echo. You're not doing a comprehensive echocardiogram. You're asking four bedside questions:")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(6)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                orientationQuestionRow(number: "1", question: "Is the heart squeezing well?", detail: "LV function")
                orientationQuestionRow(number: "2", question: "Is the right heart under strain?", detail: "RV dilation, septal bowing")
                orientationQuestionRow(number: "3", question: "Is there fluid around the heart?", detail: "Pericardial effusion / tamponade")
                orientationQuestionRow(number: "4", question: "Are there obvious wall motion abnormalities?", detail: "Regional vs global")
            }

            Text("Four windows give you the answer to all four questions. You already know the subxiphoid view from eFAST. Now you're adding three more views that make you dangerous at the bedside.")
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

    // MARK: - Four Standard Windows
    private var windowsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "The Four Standard Windows", icon: "rectangle.grid.2x2", color: CriticalDesign.Colors.accentBlue)

            // PLAX
            windowCard(
                number: "1",
                title: "Parasternal Long Axis (PLAX)",
                tagline: "Your Swiss Army Knife View",
                color: CriticalDesign.Colors.accentRed,
                content: """
                **Probe position:** Left parasternal border, 3rd-4th intercostal space. Indicator to the patient's right shoulder. Phased array probe.

                **What you see (right to left on screen):** RV → interventricular septum → LV cavity → anterior mitral valve leaflet → posterior mitral valve leaflet → LA → descending aorta (circular, posterior to LA).

                **What you're assessing:**
                - **LV contractility** — Watch the walls squeeze. Are they moving vigorously or barely at all?
                - **Pericardial effusion** — Dark stripe between the heart and the bright pericardium. Anterior effusion collects in front of the RV. Posterior effusion collects behind the LA (distinguish from descending aorta — the aorta is round and above the effusion).
                - **Aortic root** — Measure at the sinuses. Normal <3.7cm. Dilation suggests ascending aortic pathology.
                - **EPSS** — E-Point Septal Separation. In PLAX, watch the anterior mitral leaflet open. Measure the gap between its maximum opening and the septum. >7mm = reduced EF. >10mm = EF likely <30%.

                **Clinical pearl:** This is your go-to view for a quick "is the heart working?" assessment. If you only get one cardiac view in a resuscitation, make it this one.
                """
            )

            GifImage("Heart_Parasternal")
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: CriticalDesign.Radius.md, style: .continuous))
                .padding(.horizontal, CriticalDesign.Spacing.lg)

            // PSAX
            windowCard(
                number: "2",
                title: "Parasternal Short Axis (PSAX)",
                tagline: "The Donut View",
                color: CriticalDesign.Colors.accentBlue,
                content: """
                **Probe position:** Same location as PLAX, then rotate the probe 90 degrees clockwise. Indicator to the patient's left shoulder.

                **Three levels (tilt probe to scan through):**
                - **Aortic valve level** — Mercedes-Benz sign (3 aortic leaflets). See the "fish mouth" mitral valve below.
                - **Mitral valve level** — Fish mouth opening of the mitral valve leaflets.
                - **Papillary muscle level** — **This is the money view.** The LV looks like a donut. Two papillary muscles protrude into the cavity like eyes.

                **What you're assessing:**
                - **Global LV function** — The donut should squeeze symmetrically inward. All walls move equally.
                - **Regional wall motion** — If one segment doesn't squeeze while others do, that's a regional wall motion abnormality (think acute MI in that coronary territory).
                - **D-sign (RV overload)** — Normally the septum bows into the RV (round LV). With RV pressure overload (massive PE), the septum flattens or bows into the LV, making the LV look like a "D" instead of an "O". This confirms RV strain.

                **Clinical pearl:** The D-sign on PSAX is one of the most reproducible findings for massive PE. If you saw a dilated RV on A4C and now see the D-sign, you have two independent confirmations.
                """
            )

            Image("Heart_D")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: CriticalDesign.Radius.md, style: .continuous))
                .padding(.horizontal, CriticalDesign.Spacing.lg)

            // A4C
            windowCard(
                number: "3",
                title: "Apical 4-Chamber (A4C)",
                tagline: "The Comparison View",
                color: CriticalDesign.Colors.accentPurple,
                content: """
                **Probe position:** Apex of the heart (PMI — point of maximal impulse), usually 5th ICS, midclavicular line. Indicator to the patient's left. Tilt probe to aim at the right shoulder.

                **What you see:** All four chambers simultaneously. The LV is on the right side of the screen (patient's left), the RV is on the left side (patient's right). Atria below, ventricles above (when probe is at apex).

                **What you're assessing:**
                - **RV vs LV size** — This is THE view for comparing chambers side by side. Normal RV is about 60% of LV size. If RV ≥ LV, that's RV dilation. Think PE.
                - **McConnell's sign** — RV free wall is akinetic (not moving), but the RV apex is still contracting. This is highly specific for acute PE.
                - **Global LV function** — Watch all walls contract over several cycles.
                - **Pericardial effusion** — Visible circumferentially in large effusions.
                - **TAPSE** — Tricuspid Annular Plane Systolic Excursion. Place M-mode cursor on the lateral tricuspid annulus. Normal >17mm. <17mm suggests RV dysfunction.

                **Clinical pearl:** If you see RV > LV on A4C, that patient needs CT pulmonary angiography (if stable) or consideration for thrombolytics (if crashing). This single finding changes management.
                """
            )

            imageNeededNote("A4C annotated GIF — coming soon")

            // Subxiphoid
            windowCard(
                number: "4",
                title: "Subxiphoid 4-Chamber",
                tagline: "Your eFAST Gateway",
                color: CriticalDesign.Colors.accentTeal,
                content: """
                **Probe position:** Just below the xiphoid process, probe nearly flat against the abdomen, aiming toward the left shoulder. Use the liver as an acoustic window.

                **What you see:** All four chambers with the liver in the near field. The RV is closest to the probe (anterior). The LV is farthest.

                **You already know this view from eFAST.** In trauma, you were looking for pericardial effusion. Now go deeper:

                - **Pericardial effusion** — Dark fluid surrounding the heart. Remember: pericardial fat can mimic effusion. Fat is echogenic (bright) with irregular edges. Effusion is anechoic (dark) with smooth edges.
                - **RV diastolic collapse** — If the RV free wall collapses inward during diastole, that's early tamponade physiology.
                - **Global cardiac function** — Quick gestalt of contractility.
                - **IVC transition** — From subxiphoid, rotate the probe to view the IVC entering the right atrium. This connects directly to your RUSH Tank evaluation.

                **When it fails:** Intubated patients with high PEEP, obese patients, surgical abdomen — subxiphoid may not work. Move to parasternal views.

                **Cross-reference:** This view connects to your RUSH Pump evaluation and your eFAST cardiac window. Same view, deeper interpretation.
                """
            )

            GifImage("Cardiac-SubxiphoidGIF_ANNOTATED copy")
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: CriticalDesign.Radius.md, style: .continuous))
                .padding(.horizontal, CriticalDesign.Spacing.lg)
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - LV Function Assessment
    private var lvFunctionSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "LV Function Estimation", icon: "heart.text.square", color: CriticalDesign.Colors.accentRed)

            // Eyeball EF
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: "eye.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                    Text("\"Eyeball EF\" — Qualitative Assessment")
                        .font(.custom("Poppins-Bold", size: 15))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                }

                Text("Watch the LV walls contract over 3-4 cardiac cycles. Classify into one of four categories:")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)

                efGradeRow(grade: "Hyperdynamic", ef: "EF >70%", description: "Walls nearly obliterate the cavity. Small end-systolic volume.", clinical: "Hypovolemia, early sepsis, high-output states", color: CriticalDesign.Colors.accentGreen)
                efGradeRow(grade: "Normal", ef: "EF 50-70%", description: "Walls move inward symmetrically, good excursion.", clinical: "Reassuring but doesn't rule out early shock", color: CriticalDesign.Colors.accentBlue)
                efGradeRow(grade: "Mildly Reduced", ef: "EF 30-50%", description: "Walls move but without vigor. Cavity doesn't shrink as much.", clinical: "Needs further workup", color: CriticalDesign.Colors.accentOrange)
                efGradeRow(grade: "Severely Reduced", ef: "EF <30%", description: "Walls barely move. Dilated cavity.", clinical: "Cardiogenic shock, end-stage cardiomyopathy, massive MI", color: CriticalDesign.Colors.accentRed)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)

            // EPSS
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: "ruler")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                    Text("EPSS — Quantitative Backup")
                        .font(.custom("Poppins-Bold", size: 15))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                }

                Text("In PLAX, use M-mode through the tip of the anterior mitral valve leaflet. Measure the distance between the E-point (maximum MV opening) and the septum.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)

                epssRow(range: "<7mm", interpretation: "Normal EF (likely >50%)", color: CriticalDesign.Colors.accentGreen)
                epssRow(range: "7-10mm", interpretation: "Moderately reduced EF", color: CriticalDesign.Colors.accentOrange)
                epssRow(range: ">10mm", interpretation: "Severely reduced EF (likely <30%)", color: CriticalDesign.Colors.accentRed)

                Text("EPSS is quick, reproducible, and less subjective than eyeball EF. Use it when you need to communicate a number to a consultant.")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .lineSpacing(4)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)

            imageNeededNote("LV dysfunction & EPSS clips — coming soon")
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - RV Strain Section
    private var rvStrainSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "RV Strain Signs", icon: "arrow.up.right.circle", color: CriticalDesign.Colors.accentPurple)

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text("Signs of Right Ventricular Overload:")
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                rvSignRow(
                    sign: "RV Dilation (RV > LV)",
                    view: "A4C",
                    detail: "RV:LV ratio >1:1 at end-diastole. The most intuitive sign — the right heart is bigger than the left.",
                    color: CriticalDesign.Colors.accentRed
                )

                rvSignRow(
                    sign: "D-Sign (Septal Bowing)",
                    view: "PSAX",
                    detail: "The interventricular septum flattens or bows into the LV, making it look like a \"D\" instead of an \"O\". Confirms RV pressure overload.",
                    color: CriticalDesign.Colors.accentPurple
                )

                rvSignRow(
                    sign: "McConnell's Sign",
                    view: "A4C",
                    detail: "RV free wall akinesis with preserved apical contraction. Highly specific for acute PE (77% specific, 96% PPV).",
                    color: CriticalDesign.Colors.accentBlue
                )

                rvSignRow(
                    sign: "TAPSE <17mm",
                    view: "A4C (M-mode)",
                    detail: "Tricuspid annular plane systolic excursion. M-mode at lateral tricuspid annulus. <17mm = RV systolic dysfunction.",
                    color: CriticalDesign.Colors.accentOrange
                )

                rvSignRow(
                    sign: "Plethoric IVC",
                    view: "Subcostal",
                    detail: "Dilated IVC (>2cm) with <50% collapse. The backup from RV failure transmits to the venous system. Cross-reference with RUSH Tank.",
                    color: CriticalDesign.Colors.accentTeal
                )

                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    Text("Putting it together:")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    Text("If you see RV dilation + D-sign + McConnell's sign + plethoric IVC in a hypotensive patient, you have overwhelming evidence for massive PE. This combination should trigger immediate consideration of thrombolytics or catheter-directed therapy.")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .lineSpacing(6)
                }
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

            imageNeededNote("McConnell's sign clip — coming soon")
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Pericardial Effusion Section
    private var pericardialEffusionSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Pericardial Effusion & Tamponade", icon: "drop.circle", color: CriticalDesign.Colors.accentOrange)

            // Grading
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text("Grading Effusion Size")
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                effusionGradeRow(grade: "Trace / Small", size: "<1cm", description: "Thin rim, often only posterior. Usually not hemodynamically significant.", color: CriticalDesign.Colors.accentGreen)
                effusionGradeRow(grade: "Moderate", size: "1-2cm", description: "Circumferential or predominantly posterior. May cause symptoms.", color: CriticalDesign.Colors.accentOrange)
                effusionGradeRow(grade: "Large", size: ">2cm", description: "Surrounds the heart. Watch for tamponade physiology.", color: CriticalDesign.Colors.accentRed)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)

            // Tamponade callout
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentOrange)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Tamponade is NOT just a big effusion.")
                        .font(.custom("Poppins-SemiBold", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    Text("It's a clinical diagnosis supported by echo findings. A chronic large effusion can be well-tolerated. A small acute effusion (penetrating trauma) can cause tamponade.")
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .lineSpacing(4)
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.accentOrange.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                            .stroke(CriticalDesign.Colors.accentOrange.opacity(0.15), lineWidth: 1)
                    )
            )

            // Tamponade Signs
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text("Echo Signs of Tamponade Physiology")
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                tamponadeSignRow(number: "1", title: "RV Diastolic Collapse", detail: "RV free wall collapses inward during diastole. Early tamponade — effusion pressure exceeds RV diastolic pressure.", color: CriticalDesign.Colors.accentRed)
                tamponadeSignRow(number: "2", title: "RA Systolic Collapse", detail: "RA wall inverts during systole. RA is thin-walled and low-pressure, so it collapses first.", color: CriticalDesign.Colors.accentOrange)
                tamponadeSignRow(number: "3", title: "Swinging Heart", detail: "Heart swings freely within the pericardium. Creates electrical alternans on ECG.", color: CriticalDesign.Colors.accentPurple)
                tamponadeSignRow(number: "4", title: "Plethoric IVC", detail: "Dilated, non-collapsing IVC. Backup from impaired filling transmits to the venous system.", color: CriticalDesign.Colors.accentBlue)
                tamponadeSignRow(number: "5", title: "Exaggerated Respiratory Variation", detail: "Significant change in mitral/tricuspid inflow velocities with respiration (Doppler).", color: CriticalDesign.Colors.accentTeal)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.accentOrange.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(CriticalDesign.Colors.accentOrange.opacity(0.2), lineWidth: 1)
                    )
            )

            // Key Distinction
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 14))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                    Text("Key Distinction")
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    (Text("Pericardial effusion").font(.custom("Poppins-SemiBold", size: 13)).foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme)) + Text(" collects between the pericardium and myocardium. ").font(.custom("Poppins-Regular", size: 13)).foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme)) + Text("Pleural effusion").font(.custom("Poppins-SemiBold", size: 13)).foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme)) + Text(" collects posterior to the descending aorta in PLAX.").font(.custom("Poppins-Regular", size: 13)).foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme)))
                    HStack(spacing: 4) {
                        Text("The descending aorta")
                            .font(.custom("Poppins-SemiBold", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        Text("is your landmark — fluid anterior to it is pericardial, fluid posterior is pleural.")
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                }
                .lineSpacing(4)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.25), value: isAppearing)
    }

    // MARK: - Wall Motion Section
    private var wallMotionSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Wall Motion Abnormalities", icon: "waveform.path.ecg", color: CriticalDesign.Colors.accentTeal)

            // Regional vs Global
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text("Regional vs Global")
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                wallMotionRow(
                    type: "Global Hypokinesis",
                    description: "All walls move poorly.",
                    think: "Dilated cardiomyopathy, end-stage heart failure, severe septic cardiomyopathy, Takotsubo",
                    color: CriticalDesign.Colors.accentRed
                )

                wallMotionRow(
                    type: "Regional Wall Motion Abnormality",
                    description: "One segment doesn't move while others do.",
                    think: "Acute MI in a specific coronary territory — the non-moving segment corresponds to the culprit artery",
                    color: CriticalDesign.Colors.accentOrange
                )
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(neumorphicCardBackground)

            // Coronary Territory Mapping
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 14))
                        .foregroundColor(CriticalDesign.Colors.accentTeal)
                    Text("PSAX Coronary Territory Mapping")
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(CriticalDesign.Colors.accentTeal)
                    Text("papillary level")
                        .font(.custom("Poppins-Medium", size: 10))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.gray.opacity(0.12)))
                }

                coronaryRow(wall: "Anterior / Anteroseptum", territory: "LAD", color: CriticalDesign.Colors.accentRed)
                coronaryRow(wall: "Lateral Wall", territory: "Circumflex", color: CriticalDesign.Colors.accentBlue)
                coronaryRow(wall: "Inferior / Inferoseptum", territory: "RCA", color: CriticalDesign.Colors.accentOrange)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.accentTeal.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(CriticalDesign.Colors.accentTeal.opacity(0.2), lineWidth: 1)
                    )
            )

            // What to look for + Limitation
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                    Circle()
                        .fill(CriticalDesign.Colors.accentTeal)
                        .frame(width: 6, height: 6)
                        .padding(.top, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("What to look for:")
                            .font(.custom("Poppins-SemiBold", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        Text("Compare adjacent segments. A wall that doesn't thicken or move inward (akinetic) or moves outward (dyskinetic) while its neighbors contract normally = regional abnormality.")
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .lineSpacing(4)
                    }
                }

                HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                    Circle()
                        .fill(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .frame(width: 6, height: 6)
                        .padding(.top, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Limitation:")
                            .font(.custom("Poppins-SemiBold", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        Text("This is an advanced skill. At the bedside, you're making a gestalt assessment — \"is it squeezing globally, regionally, or not at all?\" That distinction alone is clinically valuable.")
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                            .lineSpacing(4)
                    }
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

                Text("Four windows. Four questions. Is the LV squeezing? Is the RV strained? Is there fluid around it? Are walls moving together? PLAX for function and EPSS. PSAX for the D-sign. A4C for RV comparison. Subxiphoid as your entry point. These four views connect every cardiac protocol in your toolkit.")
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

    private func orientationQuestionRow(number: String, question: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Text(number + ".")
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(CriticalDesign.Colors.accentRed)
                .frame(width: 20, alignment: .leading)
            VStack(alignment: .leading, spacing: 2) {
                Text(question)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(detail)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
        }
    }

    private func windowCard(number: String, title: String, tagline: String, color: Color, content: String) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Text(number)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(color))

                Text(title)
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text(tagline)
                .font(.custom("Poppins-SemiBold", size: 12))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Capsule().fill(color.opacity(0.8)))
                .padding(.leading, 40)

            Text(CriticalDesign.markdownToAttributedString(content))
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
    }

    private func rvSignRow(sign: String, view: String, detail: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(color)

                VStack(alignment: .leading, spacing: 2) {
                    Text(sign)
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(color)
                    Text("Best seen: \(view)")
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
            }
            Text(detail)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)
                .padding(.leading, 26)
        }
    }

    private func efGradeRow(grade: String, ef: String, description: String, clinical: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 4, height: 20)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Text(grade)
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    Text(ef)
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(color))
                }
                Text(description)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                HStack(alignment: .top, spacing: 4) {
                    Text("Think:")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(color)
                    Text(clinical)
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }
        }
    }

    private func epssRow(range: String, interpretation: String, color: Color) -> some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Text("EPSS \(range)")
                .font(.custom("Poppins-Bold", size: 13))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(RoundedRectangle(cornerRadius: 6).fill(color))

            Text(interpretation)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
    }

    private func effusionGradeRow(grade: String, size: String, description: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .padding(.top, 5)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Text(grade)
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    Text(size)
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1)
                        .background(Capsule().stroke(color, lineWidth: 1))
                }
                Text(description)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
        }
    }

    private func tamponadeSignRow(number: String, title: String, detail: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Text(number)
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(detail)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
            }
        }
    }

    private func wallMotionRow(type: String, description: String, think: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: "arrow.right.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(type)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(color)
                Text(description)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                HStack(alignment: .top, spacing: 4) {
                    Text("Think:")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(color)
                    Text(think)
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }
        }
    }

    private func coronaryRow(wall: String, territory: String, color: Color) -> some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: "arrow.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
            Text(wall)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            Spacer()
            Text(territory)
                .font(.custom("Poppins-Bold", size: 13))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(Capsule().fill(color))
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
        FocusedCardiacView()
    }
}
