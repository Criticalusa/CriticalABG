//
//  LeadOverviewDeatil.swift
//  CriticalX
//
//  Created by Macbook 4 on 25/11/2021.
//  Updated: Premium light theme with Teaching Style structure
//

import SwiftUI
import UIKit

struct LeadOverviewDeatil: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented = false

    var body: some View {
        ZStack {
            // Premium light animated background
            LeadDetailBackground()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    LeadDetailHeader(
                        title: "Lead Overview",
                        subtitle: "Foundation Concepts",
                        icon: "waveform.path.ecg"
                    )

                    // MARK: - Orientation Card
                    LeadDetailGlassCard(
                        title: "Why This Matters",
                        icon: "target",
                        content: orientationContent()
                    )

                    // MARK: - Image Card
                    LeadDetailImageCard(
                        imageName: "LeadOverview",
                        caption: "12-Lead EKG Overview",
                        onTap: { isPresented = true }
                    )
                    .fullScreenCover(isPresented: $isPresented) {
                        PhotoView(image: "Lead")
                    }

                    LeadDetailSectionDivider(title: "Lead Placement")

                    // MARK: - Lead Types Card
                    LeadDetailGlassCard(
                        title: "The 12 Leads",
                        icon: "square.grid.3x3",
                        content: leadTypesContent()
                    )

                    LeadDetailSectionDivider(title: "Systematic Approach")

                    // MARK: - Mental Model Card
                    LeadDetailGlassCard(
                        title: "How to Read It",
                        icon: "list.number",
                        content: systematicApproachContent()
                    )

                    LeadDetailSectionDivider(title: "Morphology")

                    // MARK: - P-Wave Card
                    LeadDetailGlassCard(
                        title: "P-Wave",
                        icon: "waveform",
                        content: pWaveContent()
                    )

                    // MARK: - QRS Complex Card
                    LeadDetailGlassCard(
                        title: "QRS Complex",
                        icon: "waveform.path",
                        content: qrsContent()
                    )

                    // MARK: - ST Segment Card
                    LeadDetailWarningCard(
                        title: "ST Segment",
                        content: stSegmentContent()
                    )

                    // MARK: - T-Wave Card
                    LeadDetailGlassCard(
                        title: "T-Wave",
                        icon: "waveform.badge.magnifyingglass",
                        content: tWaveContent()
                    )

                    // MARK: - Clinical Takeaway
                    LeadDetailTakeawayCard(
                        takeaway: "Read 12-leads methodically like chest x-rays. Every P-wave, QRS, ST segment, and T-wave tells part of the story. A systematic approach catches what pattern recognition misses."
                    )

                    Spacer(minLength: 40)
                }
                .padding(.top, 60)
            }

            // Close button overlay
            VStack {
                HStack {
                    Spacer()
                    LeadDetailCloseButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 16)
                }
                Spacer()
            }
        }
    }

    // MARK: - Content Formatters

    private func orientationContent() -> AttributedString {
        let text = """
        Reading 12-lead EKGs should be methodical, like reading chest x-rays.

        A 12-lead gives you electrical activity from 12 different angles—each lead tells you something different about the heart's conduction and structure.

        Below, we'll cover the different morphology of the rhythm strips and how to assess each complex.
        """
        return LeadContentFormatter.format(text, headings: [])
    }

    private func leadTypesContent() -> AttributedString {
        let text = """
        Limb Leads (Bipolar):
        Leads I, II, and III. Two electrodes (- and +) equidistant from the heart. The signal moves towards the + lead, producing a positive upright deflection.

        Augmented Limb Leads (Unipolar):
        aVR, aVL, and aVF. The letters mean something:
        • "a" = augmented
        • "V" = voltage
        • "R, L, F" = right arm, left arm, left leg

        These leads pick up electrical activity from the center of the heart towards the + lead.

        Precordial Leads (V1-V6):
        "Precordial" refers to the thorax area in front of the heart. "V" = unipolar, the number = chest position.
        • V1: Right ventricle
        • V2-V3: Ventricular septum
        • V4: Apex
        • V5-V6: Left ventricle and lateral wall
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Limb Leads (Bipolar):", "Augmented Limb Leads (Unipolar):", "Precordial Leads (V1-V6):"]
        )
    }

    private func systematicApproachContent() -> AttributedString {
        let text = """
        Ask yourself these 7 questions:

        1. Is the atrial and ventricular rate regular?

        2. Is there a P-wave for every QRS complex? Are there T-waves?

        3. Is the PR interval or QRS complex prolonged or wide?

        4. Is T-wave morphology normal?

        5. Are there any PVCs, PJCs, or PACs?

        6. Examine the axis—where is the rhythm originating from: Atrial, Ventricular, Junctional, or Paced?

        7. Make a differential interpretation.
        """
        return LeadContentFormatter.format(text, headings: ["Ask yourself these 7 questions:"])
    }

    private func pWaveContent() -> AttributedString {
        let text = """
        Key Rule:
        The P-wave should always be positive in leads II, III, and aVF. If not, it's not a sinus rhythm.

        In Precordial Leads:
        P-waves can be biphasic in V1 (negatively deflected) no more than 1 mm. This is physiological—caused by atrial depolarization vectors directed away from V1.

        Sinus Rhythm Check:
        In sinus rhythm, the P-wave is always positive in lead II.

        Double P-Waves:
        When P-waves don't depolarize simultaneously, you'll see double P-waves. This can represent left or right atrial enlargement.

        PR Interval:
        Should be 0.12–0.20 seconds in all leads. Prolongation suggests heart block.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Key Rule:", "In Precordial Leads:", "Sinus Rhythm Check:", "Double P-Waves:", "PR Interval:"]
        )
    }

    private func qrsContent() -> AttributedString {
        let text = """
        What It Represents:
        Three graphical deflections representing ventricular depolarization.

        Normal Duration:
        Less than 0.12 seconds.

        Prolonged QRS Think:
        • Left or right bundle branch block
        • Aberrant conduction
        • Intraventricular disturbance
        • Pre-excitation syndrome (WPW)

        Voltage Assessment:
        High voltage (R wave > 35 mm in precordial leads) = ventricular hypertrophy.

        Low voltage can indicate:
        • COPD
        • Pericardial effusion
        • Pleural effusion
        • Normal variant

        Axis:
        Should be normal or physiological left—between –30° to 90° in the limb leads.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["What It Represents:", "Normal Duration:", "Prolonged QRS Think:", "Voltage Assessment:", "Axis:"]
        )
    }

    private func stSegmentContent() -> AttributedString {
        let text = """
        Measurement:
        ST elevation is measured at the J point. Normally flat and isoelectric along the baseline.

        Benign ST Elevation:
        Common in V2–V6 in the general population. Concave ST elevation is normal in individuals without ischemia.

        ST Elevation Patterns in Ischemia:
        Can be convex, up-sloping, down-sloping, or horizontal.

        Causes of ST Elevation (not just STEMI):
        • Bundle branch blocks
        • Coronary vasospasm
        • Hyperkalemia
        • Aortic dissection
        • Takotsubo cardiomyopathy
        • Pulmonary embolism

        ST Depression:
        Not common. Less than 0.5 mm in chest leads is normal. Depression can indicate:
        • Ischemia
        • Bundle branch blocks
        • LV or RV hypertrophy
        • Heart failure
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Measurement:", "Benign ST Elevation:", "ST Elevation Patterns in Ischemia:", "Causes of ST Elevation (not just STEMI):", "ST Depression:"]
        )
    }

    private func tWaveContent() -> AttributedString {
        let text = """
        Normal T-Wave:
        Should be concordant (same direction) as the QRS complex. It's acceptable to be inverted in V1 and lead III.

        Deep T-Wave Inversions:
        In V2-V3 (may extend to V1-V6) without ST changes—think Wellens' Syndrome.

        Inversions with ST Changes:
        Should be concerning for myocardial ischemia.

        Peaked T-Waves:
        Associated with:
        • Hyperkalemia
        • Ventricular hypertrophy
        • Myocarditis
        • Bundle branch blocks
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Normal T-Wave:", "Deep T-Wave Inversions:", "Inversions with ST Changes:", "Peaked T-Waves:"]
        )
    }
}

struct LeadOverviewDeatil_Previews: PreviewProvider {
    static var previews: some View {
        LeadOverviewDeatil()
    }
}
