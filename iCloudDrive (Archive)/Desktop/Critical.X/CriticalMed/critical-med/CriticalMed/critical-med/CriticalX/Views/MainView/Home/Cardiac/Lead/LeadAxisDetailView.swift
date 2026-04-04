//
//  LeadAxisDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 25/11/2021.
//  Updated: Premium light theme with Teaching Style structure
//

import SwiftUI
import UIKit

struct LeadAxisDetailView: View {

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
                        title: "Lead Axis",
                        subtitle: "Cardiac Orientation",
                        icon: "arrow.up.right.and.arrow.down.left.rectangle"
                    )

                    // MARK: - Orientation Card
                    LeadDetailGlassCard(
                        title: "Why This Matters",
                        icon: "target",
                        content: orientationContent()
                    )

                    // MARK: - Image Card
                    LeadDetailImageCard(
                        imageName: "LeadAxis",
                        caption: "Cardiac Axis Reference",
                        onTap: { isPresented = true }
                    )
                    .fullScreenCover(isPresented: $isPresented) {
                        PhotoView(image: "LeadAxis")
                    }

                    LeadDetailSectionDivider(title: "Mental Model")

                    // MARK: - Clock Position Mental Model
                    LeadDetailGlassCard(
                        title: "The Clock Model",
                        icon: "clock",
                        content: clockModelContent()
                    )

                    // MARK: - How to Determine Axis
                    LeadDetailGlassCard(
                        title: "How to Determine Axis",
                        icon: "arrow.triangle.branch",
                        content: determinationContent()
                    )

                    LeadDetailSectionDivider(title: "Axis Types")

                    // MARK: - Normal Axis Card
                    LeadDetailGlassCard(
                        title: "Normal Axis",
                        icon: "checkmark.circle",
                        content: normalAxisContent()
                    )

                    // MARK: - Left Axis Deviation
                    LeadDetailGlassCard(
                        title: "Left Axis Deviation",
                        icon: "arrow.left",
                        content: leftAxisContent()
                    )

                    // MARK: - Right Axis Deviation
                    LeadDetailWarningCard(
                        title: "Right Axis Deviation",
                        content: rightAxisContent()
                    )

                    // MARK: - Extreme Right Axis
                    LeadDetailWarningCard(
                        title: "Extreme Right Axis Deviation",
                        content: extremeRightContent()
                    )

                    LeadDetailSectionDivider(title: "Quick Reference")

                    // MARK: - Summary Table
                    LeadDetailGlassCard(
                        title: "Deflection Patterns",
                        icon: "table",
                        content: summaryTableContent()
                    )

                    // MARK: - Clinical Takeaway
                    LeadDetailTakeawayCard(
                        takeaway: "Look at leads I, II, and III. Normal axis = all positive. If Lead I is negative, think right axis deviation. If Lead III is negative with Lead I positive, think left axis deviation."
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
        The basic regions of the heart where myocardial infarctions can occur are the inferior wall, posterior wall, lateral wall, septal and anterior walls.

        Understanding axis deviation helps you identify which region is affected and what conduction abnormalities may be present.

        Critical factor: Make sure leads are placed correctly. The limb leads should be placed on the limbs—the LLQ is NOT an appropriate substitute for the LL electrode.
        """
        return LeadContentFormatter.format(text, headings: ["Critical factor:"])
    }

    private func clockModelContent() -> AttributedString {
        let text = """
        Think of it like a clock:

        When looking at the heart from the front, depolarization should travel from roughly 11 o'clock (SA node) to 5 o'clock (apex).

        The heart is rotated in the chest:
        • Apex: 5 o'clock position → directed toward Lead II
        • Lead I: 3 o'clock position
        • Lead III: 7 o'clock position

        Normal cardiac axis: 2 o'clock to 6 o'clock
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Think of it like a clock:", "The heart is rotated in the chest:", "Normal cardiac axis:"]
        )
    }

    private func determinationContent() -> AttributedString {
        let text = """
        Look at Leads I, II, and III:

        Each lead can show one of three deflection patterns:
        • ⬆ Positive (upright) deflection
        • ⬇ Negative (downward) deflection
        • ⬇⬆ Biphasic (both positive and negative)

        The combination of these deflections tells you where the electrical impulse is traveling.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Look at Leads I, II, and III:", "Each lead can show one of three deflection patterns:"]
        )
    }

    private func normalAxisContent() -> AttributedString {
        let text = """
        What You'll See:
        As the impulse travels from 11 o'clock to 5 o'clock, all leads show positive (upright) deflection.

        Lead I: ⬆ Positive
        Lead II: ⬆ Positive
        Lead III: ⬆ Positive

        This is the easiest pattern to recognize.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["What You'll See:", "Lead I:", "Lead II:", "Lead III:"]
        )
    }

    private func leftAxisContent() -> AttributedString {
        let text = """
        Two Types:

        Physiological LAD (Normal):
        Axis shifts slightly left (toward 2:30 position).
        • Lead I: ⬆ Positive
        • Lead II: ⬆ Positive or ⬇⬆ Biphasic
        • Lead III: ⬇ Negative

        Pathological LAD (Abnormal):
        Axis shifts significantly (toward 12:30-1 o'clock).
        • Lead I: ⬆ Positive
        • Lead II: ⬇ Negative
        • Lead III: ⬇ Negative

        LAD Causes:
        • LVH
        • LBBB
        • Inferior Wall MI
        • WPW
        • Left Anterior Fascicular Block
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Two Types:", "Physiological LAD (Normal):", "Pathological LAD (Abnormal):", "LAD Causes:"]
        )
    }

    private func rightAxisContent() -> AttributedString {
        let text = """
        All RAD is pathological (except in newborns).

        What Happens:
        The impulse moves away from Lead I and toward the 7 o'clock position.

        Pattern:
        • Lead I: ⬇ Negative
        • Lead II: ⬆ Positive, ⬇⬆ Biphasic, or ⬇ Negative
        • Lead III: ⬇ Negative

        RAD Causes:
        • RVH
        • Cor pulmonale
        • Pulmonary embolism
        • COPD
        • Pulmonary hypertension
        • Lateral wall MI
        • Left Posterior Fascicular Block
        • Switched lead placement
        """
        return LeadContentFormatter.format(
            text,
            headings: ["All RAD is pathological (except in newborns).", "What Happens:", "Pattern:", "RAD Causes:"]
        )
    }

    private func extremeRightContent() -> AttributedString {
        let text = """
        What's Happening:
        The impulse originates at the opposite end (apex) and moves toward the right shoulder (11 o'clock position).

        Pattern:
        • Lead I: ⬇ Negative
        • Lead II: ⬇ Negative
        • Lead III: ⬇ Negative

        All leads are negatively deflected.

        ERAD Causes:
        • Misplaced electrodes
        • Ventricular arrhythmias (e.g., V-Tach)
        """
        return LeadContentFormatter.format(
            text,
            headings: ["What's Happening:", "Pattern:", "All leads are negatively deflected.", "ERAD Causes:"]
        )
    }

    private func summaryTableContent() -> AttributedString {
        let text = """
        Normal Axis:
        Lead I: ⬆  Lead II: ⬆  Lead III: ⬆

        Physiological LAD:
        Lead I: ⬆  Lead II: ⬆ or ⬇⬆  Lead III: ⬇

        Pathological LAD:
        Lead I: ⬆  Lead II: ⬇  Lead III: ⬇

        Right Axis Deviation:
        Lead I: ⬇  Lead II: ⬆/⬇⬆/⬇  Lead III: ⬇

        Extreme Right Axis:
        Lead I: ⬇  Lead II: ⬇  Lead III: ⬇
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Normal Axis:", "Physiological LAD:", "Pathological LAD:", "Right Axis Deviation:", "Extreme Right Axis:"]
        )
    }
}

struct LeadAxisDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LeadAxisDetailView()
    }
}
