//
//  AnteriorDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 25/11/2021.
//  Updated: Premium light theme with Teaching Style structure
//

import SwiftUI
import UIKit

struct AnteriorDetailView: View {

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
                        title: "Anterior & Septal",
                        subtitle: "LAD Territory",
                        icon: "heart.fill",
                        accentColor: LeadColors.critical
                    )

                    // MARK: - EKG Image Card
                    LeadDetailImageCard(
                        imageName: "Anterior",
                        caption: "Anterolateral STEMI - Note ST elevations V2-V5",
                        onTap: { isPresented = true }
                    )
                    .fullScreenCover(isPresented: $isPresented) {
                        PhotoView(image: "Anterior")
                    }

                    // MARK: - Anatomy Image Card
                    LeadDetailImageCard(
                        imageName: "AnteriorHeart",
                        caption: "Anterior Wall Anatomy",
                        onTap: { showAnatomyImage = true }
                    )
                    .fullScreenCover(isPresented: $showAnatomyImage) {
                        PhotoView(image: "AnteriorHeart")
                    }

                    // MARK: - Why This Matters
                    LeadDetailWarningCard(
                        title: "Why This Matters",
                        content: orientationContent()
                    )

                    LeadDetailSectionDivider(title: "Pattern Recognition")

                    // MARK: - Infarction Patterns Card
                    LeadDetailGlassCard(
                        title: "Infarction Patterns",
                        icon: "waveform.path.ecg",
                        content: infarctionPatternsContent(),
                        accentColor: LeadColors.critical
                    )

                    // MARK: - What You'll See
                    LeadDetailGlassCard(
                        title: "What You'll See",
                        icon: "eye",
                        content: whatYoullSeeContent(),
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
                        takeaway: "Anterior STEMIs are \"widow-makers.\" The LAD supplies the largest territory. Look for ST elevation in V2-V5 with reciprocal depression in III and aVF. Early recognition = early reperfusion = better outcomes."
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
        The anterior wall is supplied by the LAD (Left Anterior Descending artery), a branch of the Left Coronary Artery.

        LAD lesions have the worst prognosis—they're associated with serious LV damage due to the larger infarction area.

        Critical threshold: Infarctions involving more than 40% of the LV will result in cardiogenic shock.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Critical threshold:"]
        )
    }

    private func infarctionPatternsContent() -> AttributedString {
        let text = """
        Anterior infarctions can extend to the septal and lateral portions of the wall.

        What You'll Find:
        • ST segment elevation in precordial leads (V1-6) and/or high lateral leads (I, aVL)
        • Prominent Q wave formation
        • Reciprocal ST depression in inferior leads (mainly III and aVF)
        • Progressive loss of R wave progression
        """
        return LeadContentFormatter.format(
            text,
            headings: ["What You'll Find:"]
        )
    }

    private func whatYoullSeeContent() -> AttributedString {
        let text = """
        The tracing above shows an Anterolateral infarction.

        Notice the ST elevations in leads V2-V5.

        This pattern indicates LAD involvement with lateral extension.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Notice the ST elevations in leads V2-V5."]
        )
    }

    private func leadLocalizationContent() -> AttributedString {
        let text = """
        Anterior:
        V2-V5

        Anteroseptal:
        V1-V4

        Anterolateral:
        V3-V6, Lead I + aVL

        Extensive Anterior/Anterolateral:
        V1-V6, Lead I + aVL
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Anterior:", "Anteroseptal:", "Anterolateral:", "Extensive Anterior/Anterolateral:"]
        )
    }
}

struct AnteriorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AnteriorDetailView()
    }
}
