//
//  BrugadaDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 25/11/2021.
//  Updated: Premium light theme with Teaching Style structure
//

import SwiftUI
import UIKit

struct BrugadaDetailView: View {

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
                        title: "Brugada Syndrome",
                        subtitle: "Sodium Channelopathy",
                        icon: "bolt.heart.fill",
                        accentColor: LeadColors.gold
                    )

                    // MARK: - EKG Image Card
                    LeadDetailImageCard(
                        imageName: "Brugada",
                        caption: "Brugada Patterns - Types I, II, III",
                        onTap: { isPresented = true }
                    )
                    .fullScreenCover(isPresented: $isPresented) {
                        PhotoView(image: "Brugada")
                    }

                    // MARK: - Why This Matters
                    LeadDetailWarningCard(
                        title: "Why This Matters",
                        content: orientationContent()
                    )

                    LeadDetailSectionDivider(title: "Pattern Recognition")

                    // MARK: - The Three Types
                    LeadDetailGlassCard(
                        title: "The Three Types",
                        icon: "list.number",
                        content: threeTypesContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Type I Detail
                    LeadDetailGlassCard(
                        title: "Type I (Coved)",
                        icon: "1.circle.fill",
                        content: typeOneContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Type II Detail
                    LeadDetailGlassCard(
                        title: "Type II (Saddleback)",
                        icon: "2.circle.fill",
                        content: typeTwoContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Type III Detail
                    LeadDetailGlassCard(
                        title: "Type III",
                        icon: "3.circle.fill",
                        content: typeThreeContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Clinical Takeaway
                    LeadDetailTakeawayCard(
                        takeaway: "Brugada causes sudden cardiac death during sleep. Look for coved (Type I) or saddleback (Type II) ST elevation in V1-V3. Type I is diagnostic. If suspected, these patients need EP consultation and likely an ICD."
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
        Brugada Syndrome is a rare autosomal dominant genetic disorder.

        What's happening:
        A sodium channelopathy occurs due to direct mutation in the sodium channels.

        The outcome:
        • Syncope
        • VT/VF arrest
        • Sudden cardiac death during sleep
        """
        return LeadContentFormatter.format(
            text,
            headings: ["What's happening:", "The outcome:"]
        )
    }

    private func threeTypesContent() -> AttributedString {
        let text = """
        Where to look:
        Precordial leads V1-V3

        There are 3 distinct ST segment changes in individuals with suspected Brugada Syndrome.

        Each type has a characteristic morphology that you need to recognize.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Where to look:"]
        )
    }

    private func typeOneContent() -> AttributedString {
        let text = """
        The Diagnostic Pattern:

        Lead V1 shows a "coved" ST-segment elevation.

        Criteria:
        • At least 2 mm elevation
        • Followed by a negative T wave
        • Coved = rounded, dome-shaped

        This is the only pattern that's diagnostic on its own.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["The Diagnostic Pattern:", "Criteria:"]
        )
    }

    private func typeTwoContent() -> AttributedString {
        let text = """
        The Saddleback Pattern:

        Lead V1 shows a "saddleback" appearance.

        Criteria:
        • At least 2 mm ST-segment elevation
        • Shape looks like a saddle
        • Can also be present in normal individuals

        Important: Type II alone is not diagnostic—it can be a normal variant.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["The Saddleback Pattern:", "Criteria:", "Important:"]
        )
    }

    private func typeThreeContent() -> AttributedString {
        let text = """
        Subtle Pattern:

        Features of either Type I (coved) or Type II (saddleback), but with less than 2 mm of ST-segment elevation.

        This is the mildest form and can be intermittent.

        May require provocation testing (procainamide, flecainide) to unmask.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Subtle Pattern:"]
        )
    }
}

struct BrugadaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BrugadaDetailView()
    }
}
