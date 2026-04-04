//
//  InferiorWallDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 25/11/2021.
//  Updated: Premium light theme with Teaching Style structure
//

import SwiftUI
import UIKit

struct InferiorWallDetailView: View {

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
                        title: "Inferior Wall",
                        subtitle: "RCA/LCx Territory",
                        icon: "heart.fill",
                        accentColor: LeadColors.critical
                    )

                    // MARK: - EKG Image Card
                    LeadDetailImageCard(
                        imageName: "InferiorWallMInew",
                        caption: "Inferior Wall STEMI",
                        onTap: { isPresented = true }
                    )
                    .fullScreenCover(isPresented: $isPresented) {
                        PhotoView(image: "InferiorWallMInew")
                    }

                    // MARK: - Anatomy Image Card
                    LeadDetailImageCard(
                        imageName: "InferiorWallHeart",
                        caption: "Inferior Wall Anatomy",
                        onTap: { showAnatomyImage = true }
                    )
                    .fullScreenCover(isPresented: $showAnatomyImage) {
                        PhotoView(image: "InferiorWallHeart")
                    }

                    // MARK: - Key Statistics
                    LeadDetailWarningCard(
                        title: "Critical Statistics",
                        content: statisticsContent()
                    )

                    LeadDetailSectionDivider(title: "Coronary Anatomy")

                    // MARK: - Culprit Vessels
                    LeadDetailGlassCard(
                        title: "Culprit Vessels",
                        icon: "arrow.triangle.branch",
                        content: culpritVesselsContent(),
                        accentColor: LeadColors.critical
                    )

                    // MARK: - Vascular Territories
                    LeadDetailGlassCard(
                        title: "Vascular Territories",
                        icon: "map",
                        content: vascularTerritoriesContent(),
                        accentColor: LeadColors.critical
                    )

                    // MARK: - Lead Localization
                    LeadDetailGlassCard(
                        title: "Lead Localization",
                        icon: "square.grid.3x3",
                        content: leadLocalizationContent(),
                        accentColor: LeadColors.critical
                    )

                    // MARK: - Clinical Takeaway
                    LeadDetailTakeawayCard(
                        takeaway: "40% of inferior MIs have RV involvement—always get a right-sided EKG (V4R). Avoid nitrates if RV infarct is suspected. The culprit is usually RCA, but in 20% of cases it's LCx."
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

    private func statisticsContent() -> AttributedString {
        let text = """
        Inferior Wall MIs are common:

        40-50% of all MIs involve the inferior wall.

        40% of inferior wall MIs will have RV involvement.

        This makes right-sided EKG (V4R) essential for risk stratification.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Inferior Wall MIs are common:", "40-50%", "40%"]
        )
    }

    private func culpritVesselsContent() -> AttributedString {
        let text = """
        During an inferior wall MI, the culprit vessels are either:

        RCA (Right Coronary Artery):
        Most common culprit. Supplies the medial part of the inferior wall, including the inferior septum.

        LCx (Left Circumflex):
        In approximately 20% of cases, the circumflex artery wraps around and supplies the inferior wall.

        LAD (Rare):
        In rare cases, a Type III "wrap-around" LAD can cause inferior MI.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["During an inferior wall MI, the culprit vessels are either:", "RCA (Right Coronary Artery):", "LCx (Left Circumflex):", "LAD (Rare):"]
        )
    }

    private func vascularTerritoriesContent() -> AttributedString {
        let text = """
        RCA Territory:
        • Medial part of the inferior wall
        • Inferior septum
        • Right ventricle (in most patients)

        LCx Territory:
        • Lateral part of the inferior wall
        • Left posterobasal area

        The RCA usually supplies this region. The circumflex takes over in about 20% of patients.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["RCA Territory:", "LCx Territory:"]
        )
    }

    private func leadLocalizationContent() -> AttributedString {
        let text = """
        Inferior STEMI Leads:
        II, III, aVF

        Reciprocal Changes:
        ST depression in I, aVL

        RV Involvement:
        ST elevation in V4R (right-sided lead)

        Always get a right-sided EKG when you see inferior ST elevation.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Inferior STEMI Leads:", "Reciprocal Changes:", "RV Involvement:"]
        )
    }
}

struct InferiorWallDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InferiorWallDetailView()
    }
}
