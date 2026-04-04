//
//  NeuroMainPage.swift
//  CriticalX
//
//  Created by Macbook 7 on 28/12/2021.
//  Updated with neumorphic styling
//

import SwiftUI

struct NeuroMainPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    private let haptic = UIImpactFeedbackGenerator(style: .light)

    // Category icons and colors using CriticalDesign colors
    private let neuroImages: [String] = [
        "NanoBanana/neuro/neuro_cranial_nerves",
        "NanoBanana/neuro/neuro_stroke_scores",
        "NanoBanana/neuro/neuro_herniation",
        "NanoBanana/neuro/neuro_increased_icp",
        "NanoBanana/neuro/neuro_neuro_exam",
        "NanoBanana/neuro/neuro_stroke_pathology",
        "NanoBanana/neuro/neuro_ct_brain",
        "NanoBanana/scales/scales_gcs_glasgow_coma_scale",
        "NanoBanana/neuro/neuro_brain_death_testing_bdt"
    ]

    private let categoryData: [(icon: String, color: Color)] = [
        ("brain.head.profile", CriticalDesign.Colors.accentPurple),     // Cranial Nerves
        ("waveform.path.ecg", CriticalDesign.Colors.accentOrange),      // Stroke Scores
        ("exclamationmark.triangle.fill", CriticalDesign.Colors.accentRed), // Herniation
        ("arrow.up.circle.fill", CriticalDesign.Colors.accentPurple),   // Increased ICP
        ("stethoscope", CriticalDesign.Colors.accentBlue),              // Neuro Exam
        ("brain", CriticalDesign.Colors.cardBlue),                      // Stroke Pathology
        ("brain.filled.head.profile", CriticalDesign.Colors.accentTeal), // CT Brain
        ("gauge.with.dots.needle.33percent", CriticalDesign.Colors.accentGreen), // GCS
        ("heart.slash.fill", CriticalDesign.Colors.accentRed)           // Brain Death
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header Card
                    headerCard

                    // List Items
                    listSection
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

    // MARK: - Neumorphic Card Background
    @ViewBuilder
    private var neumorphicCardBackground: some View {
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

    // MARK: - Header Card
    private var headerCard: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            // Brain icon with gradient background
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [CriticalDesign.Colors.cardBlue, CriticalDesign.Colors.cardBlue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.4), radius: 8, x: 0, y: 4)

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Neurological")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text("Assessment & Reference")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }

            Spacer()
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - List Section
    private var listSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            ForEach(Array(NeuroDataModel.neuroData.enumerated()), id: \.offset) { index, item in
                NeuroNeumorphicListCard(
                    item: item,
                    index: index,
                    icon: categoryData[index].icon,
                    accentColor: categoryData[index].color,
                    customImage: neuroImages[index]
                )
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 20)
                .animation(
                    .easeOut(duration: 0.4).delay(0.05 + Double(index) * 0.04),
                    value: isAppearing
                )
            }
        }
    }
}

// MARK: - Neumorphic List Card
struct NeuroNeumorphicListCard: View {
    @Environment(\.colorScheme) var colorScheme
    let item: NeuroDataModel
    let index: Int
    let icon: String
    let accentColor: Color
    var customImage: String? = nil

    @State private var isPressed = false
    private let haptic = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        NavigationLink(destination: NeuroMiddleView(i: index)) {
            HStack(spacing: CriticalDesign.Spacing.md) {
                // Icon
                if let customImage = customImage, UIImage(named: customImage) != nil {
                    CatalogThumbnailImage(name: customImage, size: 80, cornerRadius: 12)
                } else {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.white, Color(UIColor.systemGray6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 50, height: 50)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
                            .shadow(color: Color.white.opacity(0.9), radius: 4, x: -2, y: -2)

                        Circle()
                            .fill(accentColor.opacity(0.15))
                            .frame(width: 44, height: 44)

                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(accentColor)
                    }
                }

                // Title + Subtitle stack
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Text(item.subTitle)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .lineLimit(1)
                }

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
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.white.opacity(0.6), lineWidth: 1)
            )
        }
        .buttonStyle(NeuroNeumorphicButtonStyle(accentColor: accentColor))
    }
}

// MARK: - Neumorphic Button Style with Micro-interactions
struct NeuroNeumorphicButtonStyle: ButtonStyle {
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

// Keep old style for backwards compatibility
struct NeuroCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Neuro Middle View
struct NeuroMiddleView: View {
    var i: Int
    
    var body: some View {
        switch i {
        case 0:
            CarnialNervesDetailView()
        case 1:
            StrokeAlertBtnView()
        case 2:
            HerniationDetailView()
        case 3:
            IncreaseIcpDetailView()
        case 4:
            CriticalNeuroExamDetailView()
        case 5:
            StrokePathologyDetailView()
        case 6:
            NormalCTBrainView()
        case 7:
            GlascowComaScoreDetailView()
        case 8:
            BrainDeathTestingView()
        default:
            StrokeAlertBtnView()
        }
    }
}

// MARK: - Preview
struct NeuroMainPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NeuroMainPageView()
        }
    }
}
