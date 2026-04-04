//
//  LateralWallDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 25/11/2021.
//  Updated: Premium light theme with Teaching Style structure
//

import SwiftUI
import UIKit

struct LateralWallDetailView: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented = false
    @State private var showAnatomyImage = false

    var body: some View {
        ZStack {
            // Premium light animated background
            LeadDetailBackground()

            ScrollView {
                VStack(spacing: 20) {
                    // Header with critical red accent for STEMI territory
                    LeadDetailHeader(
                        title: "Lateral Wall",
                        subtitle: "LAD/LCx Territory",
                        icon: "heart.fill",
                        accentColor: LeadColors.critical
                    )

                    // MARK: - EKG Image Card
                    LeadDetailImageCard(
                        imageName: "LateralWallEkg",
                        caption: "Lateral Wall STEMI",
                        onTap: { isPresented = true }
                    )
                    .fullScreenCover(isPresented: $isPresented) {
                        PhotoView(image: "LateralWallEkg")
                    }

                    // MARK: - Anatomy Image Card
                    LeadDetailImageCard(
                        imageName: "LateralWallHeart",
                        caption: "Lateral Wall Anatomy",
                        onTap: { showAnatomyImage = true }
                    )
                    .fullScreenCover(isPresented: $showAnatomyImage) {
                        PhotoView(image: "LateralWallHeart")
                    }

                    // MARK: - Why This Matters
                    LeadDetailGlassCard(
                        title: "Why This Matters",
                        icon: "target",
                        content: orientationContent(),
                        accentColor: LeadColors.critical
                    )

                    LeadDetailSectionDivider(title: "Infarction Patterns")

                    // MARK: - Infarction Patterns Card
                    LeadDetailWarningCard(
                        title: "Infarction Patterns",
                        content: infarctionPatternsContent()
                    )

                    // MARK: - Lead Localization
                    LeadDetailGlassCard(
                        title: "Lead Localization",
                        icon: "square.grid.3x3",
                        content: leadLocalizationContent(),
                        accentColor: LeadColors.critical
                    )

                    // MARK: - Associated Findings
                    LeadDetailGlassCard(
                        title: "Associated Findings",
                        icon: "exclamationmark.triangle",
                        content: associatedFindingsContent(),
                        accentColor: LeadColors.critical
                    )

                    // MARK: - Clinical Takeaway
                    LeadDetailTakeawayCard(
                        takeaway: "Lateral wall MIs often accompany other territories. Look for ST elevation in I, aVL, V5, V6. Isolated high lateral (I, aVL only) can be subtle—don't miss it. Expect reciprocal changes in inferior leads."
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
        Lateral wall infarctions occur in the lateral part of the left ventricle.

        Culprit vessels:
        Usually caused by occlusion in the diagonal branch of the LAD (Left Anterior Descending) or the LCx (Left Circumflex artery).
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Culprit vessels:"]
        )
    }

    private func infarctionPatternsContent() -> AttributedString {
        let text = """
        Three main patterns:

        Anterolateral STEMI:
        Due to LAD occlusion.

        Inferior-Posterior-Lateral STEMI:
        Due to LCx occlusion.

        Isolated Lateral Infarction:
        Due to occlusion of smaller branch arteries:
        • D1 (First diagonal)
        • Obtuse marginal
        • Ramus intermedius
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Three main patterns:", "Anterolateral STEMI:", "Inferior-Posterior-Lateral STEMI:", "Isolated Lateral Infarction:"]
        )
    }

    private func leadLocalizationContent() -> AttributedString {
        let text = """
        Lateral STEMI Leads:
        I, aVL, V5, V6

        High Lateral STEMI:
        ST elevation isolated to leads I and aVL only.

        Reciprocal Changes:
        ST depression in inferior leads (II, III, aVF).
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Lateral STEMI Leads:", "High Lateral STEMI:", "Reciprocal Changes:"]
        )
    }

    private func associatedFindingsContent() -> AttributedString {
        let text = """
        Watch for complications:

        • Hypotension
        • AV blocks
        • Other myocardial damage

        Lateral wall MIs usually accompany other territory involvement—rarely isolated.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Watch for complications:"]
        )
    }
}

struct LateralWallDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LateralWallDetailView()
    }
}
