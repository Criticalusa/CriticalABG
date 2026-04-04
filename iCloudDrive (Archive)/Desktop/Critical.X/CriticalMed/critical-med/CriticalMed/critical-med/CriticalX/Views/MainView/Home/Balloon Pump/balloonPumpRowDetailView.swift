//
//  BalloonPumpTimingDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 23/12/2021.
//  Updated with CriticalDesign neumorphic styling
//

import SwiftUI

// MARK: - Timing Detail View (for IABP Timing section)
struct BalloonPumpTimingDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var isVideoActive = false
    let data: BalloonPumpRowDataModel

    // Determine accent color based on timing type
    private var accentColor: Color {
        switch data.title.lowercased() {
        case let t where t.contains("normal"):
            return CriticalDesign.Colors.accentGreen
        case let t where t.contains("early inflation"):
            return CriticalDesign.Colors.accentRed
        case let t where t.contains("late inflation"):
            return CriticalDesign.Colors.accentOrange
        case let t where t.contains("early deflation"):
            return CriticalDesign.Colors.accentPurple
        case let t where t.contains("late deflation"):
            return CriticalDesign.Colors.accentBlue
        default:
            return CriticalDesign.Colors.cardBlue
        }
    }

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    headerSection

                    // Waveform image card
                    if !data.firstSection.image.isEmpty {
                        waveformImageCard
                    }

                    // Critical warning if present
                    if !data.firstSection.criticalValue.isEmpty {
                        criticalWarningCard
                    }

                    // Overview card
                    if !data.firstSection.overView.isEmpty {
                        overviewCard
                    }

                    // Indications card
                    if !data.firstSection.indications.isEmpty {
                        indicationsCard
                    }

                    // Contraindications card
                    if !data.firstSection.contraindication.isEmpty {
                        contraindicationsCard
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

                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(accentColor)
            }

            Text(data.firstSection.subTitle)
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .multilineTextAlignment(.center)

            Text("Intra-Aortic Balloon Pump")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Waveform Image Card
    private var waveformImageCard: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            Image(data.firstSection.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 160)
                .clipShape(RoundedRectangle(cornerRadius: CriticalDesign.Radius.md, style: .continuous))

            // Video button if available
            if !data.firstSection.button.isEmpty {
                Button(action: { isVideoActive = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 20))
                        Text("Watch Video")
                            .font(.custom("Poppins-SemiBold", size: 14))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [accentColor, accentColor.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(CriticalDesign.Radius.md)
                    .shadow(color: accentColor.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                .background(
                    NavigationLink(
                        destination: BalloonVideoView(),
                        isActive: $isVideoActive
                    ) { EmptyView() }
                        .hidden()
                )
            }
        }
        .padding(CriticalDesign.Spacing.lg)
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

    // MARK: - Critical Warning Card
    private var criticalWarningCard: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 24))
                .foregroundColor(CriticalDesign.Colors.accentRed)

            Text(data.firstSection.criticalValue)
                .font(.custom("Poppins-SemiBold", size: 15))
                .foregroundColor(CriticalDesign.Colors.accentRed)
        }
        .padding(CriticalDesign.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(CriticalDesign.Colors.accentRed.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(CriticalDesign.Colors.accentRed.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
        .opacity(isAppearing ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - Overview Card
    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "doc.text.fill")
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

                Text(data.firstSection.overView)
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
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Indications Card
    private var indicationsCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(CriticalDesign.Colors.accentGreen)

                Text("Indications")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text(data.firstSection.indications)
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
        .animation(.easeOut(duration: 0.4).delay(0.25), value: isAppearing)
    }

    // MARK: - Contraindications Card
    private var contraindicationsCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                Text("Contraindications")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text(data.firstSection.contraindication)
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
        .animation(.easeOut(duration: 0.4).delay(0.3), value: isAppearing)
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
typealias balloonPumpRowDetailView = BalloonPumpTimingDetailView

struct BalloonPumpTimingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BalloonPumpTimingDetailView(
                data: BalloonPumpRowDataModel(
                    title: "Normal Timing",
                    firstSection: FirstSectionDataModel(
                        subTitle: "Normal Timing",
                        image: "NormalTiming",
                        button: "YoutubeButton",
                        criticalValue: "",
                        overView: "Sample overview text...",
                        indications: "• Sample indication 1\n• Sample indication 2",
                        contraindication: "• Sample contraindication"
                    ),
                    secondSection: SecondSectionDataModel(
                        subTitle: "",
                        overView: "",
                        heading1: "",
                        heading2: "",
                        heading1Data: "",
                        heading2Data: ""
                    )
                )
            )
        }
    }
}
