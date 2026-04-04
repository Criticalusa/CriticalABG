//
//  SgarbossaDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 25/11/2021.
//  Updated: Premium light theme with Teaching Style structure
//

import SwiftUI
import UIKit

struct SgarbossaDetailView: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented = false

    var body: some View {
        ZStack {
            // Premium light animated background
            LeadDetailBackground()

            ScrollView {
                VStack(spacing: 20) {
                    // Header with gold accent for special pattern
                    LeadDetailHeader(
                        title: "Sgarbossa Criteria",
                        subtitle: "MI in LBBB",
                        icon: "checklist",
                        accentColor: LeadColors.gold
                    )

                    // MARK: - EKG Image Card
                    LeadDetailImageCard(
                        imageName: "sgarbossas",
                        caption: "Sgarbossa Criteria Visual Guide",
                        onTap: { isPresented = true }
                    )
                    .fullScreenCover(isPresented: $isPresented) {
                        PhotoView(image: "sgarbossas")
                    }

                    // MARK: - Why This Matters
                    LeadDetailWarningCard(
                        title: "The Problem",
                        content: problemContent()
                    )

                    LeadDetailSectionDivider(title: "The Criteria")

                    // MARK: - Criteria Overview
                    LeadDetailGlassCard(
                        title: "Scoring System",
                        icon: "number",
                        content: scoringOverviewContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Criterion 1 (5 points)
                    LeadDetailGlassCard(
                        title: "Criterion 1 (5 points)",
                        icon: "5.circle.fill",
                        content: criterionOneContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Criterion 2 (3 points)
                    LeadDetailGlassCard(
                        title: "Criterion 2 (3 points)",
                        icon: "3.circle.fill",
                        content: criterionTwoContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Criterion 3 (2 points)
                    LeadDetailGlassCard(
                        title: "Criterion 3 (2 points)",
                        icon: "2.circle.fill",
                        content: criterionThreeContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Interpretation
                    LeadDetailGlassCard(
                        title: "Interpretation",
                        icon: "equal.circle",
                        content: interpretationContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Clinical Takeaway
                    LeadDetailTakeawayCard(
                        takeaway: "LBBB doesn't mean you can't diagnose MI. Concordant ST changes are the most specific finding. Score ≥3 points suggests acute MI. Don't let LBBB make you miss a STEMI equivalent."
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

    private func problemContent() -> AttributedString {
        let text = """
        The old teaching:
        "You can't detect an MI in the presence of a LBBB."

        Why it's confusing:
        LBBB causes substantial changes in LV repolarization, resulting in secondary ST-T changes that mimic ischemia.

        What you'll see in LBBB (without MI):
        • ST elevations in V1-V2
        • ST depressions and T-wave inversions in V5, V6, I, and aVL

        Sgarbossa's criteria allow us to detect acute MI despite these confounding changes.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["The old teaching:", "Why it's confusing:", "What you'll see in LBBB (without MI):"]
        )
    }

    private func scoringOverviewContent() -> AttributedString {
        let text = """
        A scoring system to diagnose MI in the presence of LBBB.

        Total possible: 10 points

        Score ≥3 points: High specificity for acute MI.

        The key concept is looking for changes that go AGAINST what LBBB should produce.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Total possible:", "Score ≥3 points:"]
        )
    }

    private func criterionOneContent() -> AttributedString {
        let text = """
        Concordant ST elevation ≥1 mm

        What it means:
        ST elevation in the same direction as the QRS complex.

        Worth 5 points—this is the most specific criterion.

        If QRS is positive and ST segment is elevated, that's concordant—and highly suggestive of MI.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Concordant ST elevation ≥1 mm", "What it means:", "Worth 5 points—this is the most specific criterion."]
        )
    }

    private func criterionTwoContent() -> AttributedString {
        let text = """
        ST depression ≥1 mm in V1, V2, or V3

        What it means:
        ST depression in the right precordial leads.

        Worth 3 points.

        This suggests posterior involvement and is highly specific for acute MI.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["ST depression ≥1 mm in V1, V2, or V3", "What it means:", "Worth 3 points."]
        )
    }

    private func criterionThreeContent() -> AttributedString {
        let text = """
        Discordant ST elevation ≥5 mm

        What it means:
        ST elevation in the opposite direction of the QRS complex, but excessive (>5 mm).

        Worth 2 points.

        This is the least specific criterion. Modified Sgarbossa (Smith criteria) uses a ratio instead: ST elevation / S-wave depth >0.25 is more accurate.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Discordant ST elevation ≥5 mm", "What it means:", "Worth 2 points."]
        )
    }

    private func interpretationContent() -> AttributedString {
        let text = """
        Score ≥3 points:
        High specificity for acute MI. Activate the cath lab.

        Score <3 points:
        Does not rule out MI. Use clinical judgment—troponins, symptoms, and serial EKGs still matter.

        Modified Sgarbossa (Smith):
        Replaces criterion 3 with ST/S ratio >0.25. More sensitive and now widely preferred.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Score ≥3 points:", "Score <3 points:", "Modified Sgarbossa (Smith):"]
        )
    }
}

struct SgarbossaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SgarbossaDetailView()
    }
}
