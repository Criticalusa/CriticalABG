//
//  BalloonPumpComplicationDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 24/12/2021.
//  Updated with CriticalDesign neumorphic styling
//

import SwiftUI

// MARK: - Complication Detail View (for Pump Complications section)
struct BalloonPumpComplicationDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    let data: BalloonPumpRowDataModel

    // Determine accent color based on complication type
    private var accentColor: Color {
        switch data.title.lowercased() {
        case let t where t.contains("dissection") || t.contains("perforation"):
            return CriticalDesign.Colors.accentRed
        case let t where t.contains("augmentation"):
            return CriticalDesign.Colors.accentOrange
        case let t where t.contains("bleeding"):
            return CriticalDesign.Colors.accentRed
        case let t where t.contains("rupture") || t.contains("leak"):
            return CriticalDesign.Colors.accentPurple
        case let t where t.contains("dysrhythmia"):
            return CriticalDesign.Colors.accentOrange
        case let t where t.contains("vascular"):
            return CriticalDesign.Colors.accentBlue
        case let t where t.contains("failure"):
            return CriticalDesign.Colors.accentRed
        case let t where t.contains("limb") || t.contains("ischemia"):
            return CriticalDesign.Colors.accentPurple
        case let t where t.contains("cardiac") || t.contains("arrest"):
            return CriticalDesign.Colors.accentRed
        default:
            return CriticalDesign.Colors.cardBlue
        }
    }

    // Icon for header
    private var headerIcon: String {
        switch data.title.lowercased() {
        case let t where t.contains("dissection"):
            return "bolt.heart.fill"
        case let t where t.contains("augmentation"):
            return "waveform.path.ecg.rectangle"
        case let t where t.contains("bleeding"):
            return "drop.fill"
        case let t where t.contains("rupture"):
            return "bubble.left.and.exclamationmark.bubble.right"
        case let t where t.contains("dysrhythmia"):
            return "heart.slash.fill"
        case let t where t.contains("vascular"):
            return "arrow.triangle.branch"
        case let t where t.contains("failure"):
            return "exclamationmark.triangle.fill"
        case let t where t.contains("limb"):
            return "figure.walk"
        case let t where t.contains("cardiac"):
            return "heart.fill"
        default:
            return "exclamationmark.circle.fill"
        }
    }

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    headerSection

                    // Overview card (if available)
                    if data.secondSection.overView != "N/A" && !data.secondSection.overView.isEmpty {
                        overviewCard
                    }

                    // Heading 1 card (Signs/Symptoms, Causes, etc.)
                    if data.secondSection.heading1Data != "N/A" && !data.secondSection.heading1Data.isEmpty {
                        heading1Card
                    }

                    // Heading 2 card (Interventions, Troubleshooting, etc.)
                    if data.secondSection.heading2Data != "N/A" && !data.secondSection.heading2Data.isEmpty {
                        heading2Card
                    }

                    Spacer(minLength: CriticalDesign.Spacing.xl)
                }
                .padding(.vertical, CriticalDesign.Spacing.lg)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 80, height: 80)

                Image(systemName: headerIcon)
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(accentColor)
            }

            Text(data.secondSection.subTitle)
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .multilineTextAlignment(.center)

            Text("IABP Complication")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Overview Card
    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(accentColor)

                Text("Overview")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            // Content with accent bar
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.md) {
                Rectangle()
                    .fill(accentColor)
                    .frame(width: 4)
                    .cornerRadius(2)

                Text(data.secondSection.overView)
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(5)
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.6), lineWidth: 1)
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - Heading 1 Card (Signs/Symptoms, Causes, etc.)
    private var heading1Card: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: heading1Icon)
                    .font(.system(size: 18))
                    .foregroundColor(heading1Color)

                Text(data.secondSection.heading1.isEmpty ? "Details" : data.secondSection.heading1)
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text(data.secondSection.heading1Data)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.6), lineWidth: 1)
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - Heading 2 Card (Interventions, Troubleshooting, etc.)
    private var heading2Card: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: heading2Icon)
                    .font(.system(size: 18))
                    .foregroundColor(heading2Color)

                Text(data.secondSection.heading2.isEmpty ? "Management" : data.secondSection.heading2)
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text(data.secondSection.heading2Data)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.6), lineWidth: 1)
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Helper computed properties for icons/colors
    private var heading1Icon: String {
        let heading = data.secondSection.heading1.lowercased()
        if heading.contains("sign") || heading.contains("symptom") {
            return "stethoscope"
        } else if heading.contains("cause") || heading.contains("reason") {
            return "exclamationmark.circle.fill"
        } else if heading.contains("treatment") || heading.contains("intervention") {
            return "cross.case.fill"
        } else {
            return "list.bullet.clipboard.fill"
        }
    }

    private var heading1Color: Color {
        let heading = data.secondSection.heading1.lowercased()
        if heading.contains("sign") || heading.contains("symptom") {
            return CriticalDesign.Colors.accentOrange
        } else if heading.contains("cause") || heading.contains("reason") {
            return CriticalDesign.Colors.accentRed
        } else if heading.contains("treatment") {
            return CriticalDesign.Colors.accentGreen
        } else {
            return accentColor
        }
    }

    private var heading2Icon: String {
        let heading = data.secondSection.heading2.lowercased()
        if heading.contains("troubleshoot") {
            return "wrench.and.screwdriver.fill"
        } else if heading.contains("intervention") {
            return "cross.case.fill"
        } else if heading.contains("treatment") {
            return "pills.fill"
        } else {
            return "checkmark.circle.fill"
        }
    }

    private var heading2Color: Color {
        let heading = data.secondSection.heading2.lowercased()
        if heading.contains("troubleshoot") {
            return CriticalDesign.Colors.accentBlue
        } else if heading.contains("intervention") || heading.contains("treatment") {
            return CriticalDesign.Colors.accentGreen
        } else {
            return CriticalDesign.Colors.accentTeal
        }
    }

    // MARK: - Neumorphic Card Background
    @ViewBuilder
    private var neumorphicCardBackground: some View {
        if colorScheme == .dark {
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.cardBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                )
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(Color.clear)
                    .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            }
        }
    }
}

// Keep old name for backwards compatibility during transition
typealias BalloonPumpSecondSectionDetailView = BalloonPumpComplicationDetailView

struct BalloonPumpComplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BalloonPumpComplicationDetailView(
                data: BalloonPumpRowDataModel(
                    title: "Aortic Dissection",
                    firstSection: FirstSectionDataModel(
                        subTitle: "",
                        image: "",
                        button: "",
                        criticalValue: "",
                        overView: "",
                        indications: "",
                        contraindication: ""
                    ),
                    secondSection: SecondSectionDataModel(
                        subTitle: "Aortic Dissection",
                        overView: "Sample overview text about aortic dissection...",
                        heading1: "Signs and Symptoms",
                        heading2: "Interventions",
                        heading1Data: "• Symptom 1\n• Symptom 2",
                        heading2Data: "• Intervention 1\n• Intervention 2"
                    )
                )
            )
        }
    }
}
