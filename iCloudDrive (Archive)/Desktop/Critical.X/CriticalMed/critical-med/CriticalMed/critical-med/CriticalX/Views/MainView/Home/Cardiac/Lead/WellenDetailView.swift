//
//  WellenDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 25/11/2021.
//  Updated: Premium light theme with Teaching Style structure
//

import SwiftUI
import UIKit

struct WellenDetailView: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented = false

    // MARK: - Scroll Animation State
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollY: CGFloat? = nil

    private let animationStartOffset: CGFloat = 40
    private let animationEndOffset: CGFloat = 140

    private var collapseProgress: CGFloat {
        guard scrollOffset > animationStartOffset else { return 0 }
        guard scrollOffset < animationEndOffset else { return 1 }
        return (scrollOffset - animationStartOffset) / (animationEndOffset - animationStartOffset)
    }

    private var headerVisibility: CGFloat {
        1 - collapseProgress
    }

    var body: some View {
        ZStack {
            // Premium light animated background
            LeadDetailBackground()

            ScrollView {
                VStack(spacing: 20) {
                    // Header with gold accent for special pattern - with scroll collapse
                    LeadDetailHeader(
                        title: "Wellens' Syndrome",
                        subtitle: "Proximal LAD Warning",
                        icon: "exclamationmark.triangle.fill",
                        accentColor: LeadColors.gold
                    )
                    .opacity(headerVisibility)
                    .scaleEffect(1 - (collapseProgress * 0.1), anchor: .top)
                    .offset(y: -collapseProgress * 20)
                    .animation(.easeOut(duration: 0.15), value: collapseProgress)

                    // MARK: - EKG Image Card
                    LeadDetailImageCard(
                        imageName: "wellensEKG",
                        caption: "Wellens' T-Wave Patterns",
                        onTap: { isPresented = true }
                    )
                    .fullScreenCover(isPresented: $isPresented) {
                        PhotoView(image: "wellensEKG")
                    }

                    // MARK: - Why This Matters
                    LeadDetailWarningCard(
                        title: "Critical Warning Sign",
                        content: orientationContent()
                    )

                    LeadDetailSectionDivider(title: "Pattern Recognition")

                    // MARK: - The Two Patterns
                    LeadDetailGlassCard(
                        title: "T-Wave Patterns",
                        icon: "waveform",
                        content: patternsContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Statistics
                    LeadDetailGlassCard(
                        title: "The Numbers",
                        icon: "chart.bar",
                        content: statisticsContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Clinical Context
                    LeadDetailGlassCard(
                        title: "Clinical Context",
                        icon: "clock",
                        content: clinicalContextContent(),
                        accentColor: LeadColors.gold
                    )

                    // MARK: - Clinical Takeaway
                    LeadDetailTakeawayCard(
                        takeaway: "Wellens' = impending widow-maker. Biphasic or deeply inverted T-waves in V1-V3 after chest pain = severe proximal LAD stenosis. Do NOT stress test these patients—they need cath. 75% will have massive anterior MI if untreated."
                    )

                    Spacer(minLength: 40)
                }
                .padding(.top, 60)
                // Scroll tracking overlay
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                if initialScrollY == nil {
                                    initialScrollY = geo.frame(in: .global).minY
                                }
                            }
                            .onChange(of: geo.frame(in: .global).minY) { newValue in
                                if initialScrollY == nil {
                                    initialScrollY = newValue
                                }
                                let offset = (initialScrollY ?? newValue) - newValue
                                scrollOffset = max(0, offset)
                            }
                    }
                )
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
        What it indicates:
        Severe proximal LAD (Left Anterior Descending) stenosis.

        This is a warning sign:
        The EKG changes appear AFTER chest pain resolves—during a "pain-free" window.

        Without intervention, these patients are at high risk for massive anterior wall MI.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["What it indicates:", "This is a warning sign:"]
        )
    }

    private func patternsContent() -> AttributedString {
        let text = """
        Two characteristic patterns:

        Type A (Biphasic):
        Acute biphasic T-waves in leads V1-V3.
        T-wave starts positive, then dips negative.

        Type B (Deep Symmetric Inversions):
        Deep, symmetric inverted T-waves in V1-V6, I, and aVL.

        Key feature:
        NO ST-segment elevation present. These are T-wave changes only.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Two characteristic patterns:", "Type A (Biphasic):", "Type B (Deep Symmetric Inversions):", "Key feature:"]
        )
    }

    private func statisticsContent() -> AttributedString {
        let text = """
        Incidence:
        Approximately 10% of patients with acute coronary syndromes will have Wellens' pattern.

        Progression risk:
        Of that 10%, 75% will likely develop a massive anterior wall MI without intervention.

        This is not a stress test candidate—these patients need cardiac catheterization.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Incidence:", "Progression risk:"]
        )
    }

    private func clinicalContextContent() -> AttributedString {
        let text = """
        Timing:
        Patients typically report having severe angina 24-48 hours PRIOR to the EKG findings.

        When you see Wellens':
        The chest pain has often resolved. The patient may feel "fine."

        Don't be fooled:
        The absence of active chest pain doesn't mean the patient is safe. This EKG pattern demands urgent evaluation.
        """
        return LeadContentFormatter.format(
            text,
            headings: ["Timing:", "When you see Wellens':", "Don't be fooled:"]
        )
    }
}

struct WellenDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WellenDetailView()
    }
}
