//
//  BalloonPumpMainView.swift
//  CriticalX
//
//  Created by Macbook 7 on 23/12/2021.
//  Updated with CriticalDesign neumorphic styling
//

import SwiftUI

struct BalloonPumpMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    private let haptic = UIImpactFeedbackGenerator(style: .light)

    // NanoBanana custom images
    private let timingImages = [
        "NanoBanana/iabp/iabp_normal_timing",
        "NanoBanana/iabp/iabp_early_inflation",
        "NanoBanana/iabp/iabp_late_inflation",
        "NanoBanana/iabp/iabp_early_deflation",
        "NanoBanana/iabp/iabp_late_deflation"
    ]

    private let complicationImages = [
        "NanoBanana/iabp/iabp_aortic_dissection_perforation",
        "", // Ineffective Augmentation - no image
        "", // Bleeding
        "NanoBanana/iabp/iabp_balloon_rupture_leak",
        "", // Dysrhythmias
        "", // Vascular Injury
        "", // Failure to pump
        "NanoBanana/iabp/iabp_limb_ischemia",
        ""  // Cardiac Arrest
    ]

    // Section icons and colors
    private let timingIcons: [(icon: String, color: Color)] = [
        ("waveform.path.ecg", CriticalDesign.Colors.accentGreen),      // Normal Timing
        ("arrow.up.forward", CriticalDesign.Colors.accentRed),         // Early Inflation
        ("arrow.down.forward", CriticalDesign.Colors.accentOrange),    // Late Inflation
        ("arrow.up.backward", CriticalDesign.Colors.accentPurple),     // Early Deflation
        ("arrow.down.backward", CriticalDesign.Colors.accentBlue)      // Late Deflation
    ]

    private let complicationIcons: [(icon: String, color: Color)] = [
        ("bolt.heart.fill", CriticalDesign.Colors.accentRed),          // Aortic Dissection
        ("waveform.path.ecg.rectangle", CriticalDesign.Colors.accentOrange), // Ineffective Augmentation
        ("drop.fill", CriticalDesign.Colors.accentRed),                // Bleeding
        ("bubble.left.and.exclamationmark.bubble.right", CriticalDesign.Colors.accentPurple), // Balloon Rupture
        ("heart.slash.fill", CriticalDesign.Colors.accentOrange),      // Dysrhythmias
        ("arrow.triangle.branch", CriticalDesign.Colors.accentBlue),   // Vascular Injury
        ("exclamationmark.triangle.fill", CriticalDesign.Colors.accentRed), // Failure to Pump
        ("figure.walk", CriticalDesign.Colors.accentPurple),           // Limb Ischemia
        ("heart.fill", CriticalDesign.Colors.accentRed)                // Cardiac Arrest
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header Card
                    headerCard

                    // IABP Timing Section
                    sectionHeader(title: "IABP Timing", subtitle: "Inflation & Deflation Patterns")

                    ForEach(0..<BalloonPumpDataModel.allSectionData[0].rows.count, id: \.self) { index in
                        IABPNeumorphicListCard(
                            item: BalloonPumpDataModel.allSectionData[0].rows[index],
                            sectionIndex: 0,
                            icon: timingIcons[index].icon,
                            accentColor: timingIcons[index].color,
                            customImage: timingImages[safe: index]
                        )
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                        .animation(
                            .easeOut(duration: 0.4).delay(0.05 + Double(index) * 0.04),
                            value: isAppearing
                        )
                    }

                    // Pump Complications Section
                    sectionHeader(title: "Pump Complications", subtitle: "Recognition & Management")
                        .padding(.top, CriticalDesign.Spacing.md)

                    ForEach(0..<BalloonPumpDataModel.allSectionData[1].rows.count, id: \.self) { index in
                        IABPNeumorphicListCard(
                            item: BalloonPumpDataModel.allSectionData[1].rows[index],
                            sectionIndex: 1,
                            icon: complicationIcons[index].icon,
                            accentColor: complicationIcons[index].color,
                            customImage: complicationImages[safe: index]
                        )
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                        .animation(
                            .easeOut(duration: 0.4).delay(0.15 + Double(index) * 0.04),
                            value: isAppearing
                        )
                    }
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
                .padding(.top, CriticalDesign.Spacing.md)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
            GlobalPatientContext.shared.showFloatingButton = false
        }
        .onDisappear {
            GlobalPatientContext.shared.showFloatingButton = true
        }
    }

    // MARK: - Header Card
    private var headerCard: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            // Icon with gradient background
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [CriticalDesign.Colors.accentRed, CriticalDesign.Colors.accentOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: CriticalDesign.Colors.accentRed.opacity(0.4), radius: 8, x: 0, y: 4)

                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Intra-Aortic")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text("Balloon Pump (IABP)")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }

            Spacer()
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(LinearGradient(
                            colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(LinearGradient(
                                    colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1)
                        )
                }
            }
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Section Header
    private func sectionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Poppins-Bold", size: 20))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text(subtitle)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 4)
    }
}

// MARK: - IABP Neumorphic List Card
struct IABPNeumorphicListCard: View {
    @Environment(\.colorScheme) var colorScheme
    let item: BalloonPumpRowDataModel
    let sectionIndex: Int
    let icon: String
    let accentColor: Color
    var customImage: String? = nil

    var body: some View {
        NavigationLink(destination: destinationView) {
            HStack(spacing: CriticalDesign.Spacing.md) {
                // Icon with neumorphic circle background
                if let customImage = customImage, !customImage.isEmpty, UIImage(named: customImage) != nil {
                    CatalogThumbnailImage(name: customImage, size: 80, cornerRadius: 12)
                } else {
                    ZStack {
                        Circle()
                            .fill(colorScheme == .dark
                                ? AnyShapeStyle(CriticalDesign.Colors.cardBlue)
                                : AnyShapeStyle(LinearGradient(
                                    colors: [Color.white, Color(UIColor.systemGray6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                            )
                            .frame(width: 50, height: 50)
                            .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
                            .shadow(color: colorScheme == .dark ? .clear : Color.white.opacity(0.9), radius: 4, x: -2, y: -2)

                        Circle()
                            .fill(accentColor.opacity(0.15))
                            .frame(width: 44, height: 44)

                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(accentColor)
                    }
                }

                // Title
                Text(item.title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .multilineTextAlignment(.leading)

                Spacer()

                // Chevron with subtle background
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.1))
                        .frame(width: 28, height: 28)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(accentColor)
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(CriticalDesign.Colors.cardBlue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                            )
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(LinearGradient(
                                    colors: [Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))

                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.clear)
                                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                                .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.6), lineWidth: 1)
                        )
                    }
                }
            )
        }
        .buttonStyle(IABPNeumorphicButtonStyle(accentColor: accentColor))
    }

    @ViewBuilder
    private var destinationView: some View {
        if sectionIndex == 0 {
            BalloonPumpTimingDetailView(data: item)
        } else {
            BalloonPumpComplicationDetailView(data: item)
        }
    }
}

// MARK: - Neumorphic Button Style
struct IABPNeumorphicButtonStyle: ButtonStyle {
    let accentColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .shadow(
                color: configuration.isPressed ? accentColor.opacity(0.2) : Color.clear,
                radius: configuration.isPressed ? 8 : 0,
                x: 0,
                y: 0
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    let haptic = UIImpactFeedbackGenerator(style: .light)
                    haptic.impactOccurred()
                }
            }
    }
}

struct BalloonPumpMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BalloonPumpMainView()
        }
    }
}
