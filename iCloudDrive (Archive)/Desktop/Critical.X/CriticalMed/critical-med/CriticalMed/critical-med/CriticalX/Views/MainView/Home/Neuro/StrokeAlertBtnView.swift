//
//  StrokeAlertBtnView.swift
//  CriticalX
//
//  Created by Macbook 7 on 28/12/2021.
//  Updated with neumorphic styling
//

import SwiftUI

struct StrokeAlertBtnView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false

    private let strokeImages: [String] = [
        "NanoBanana/scales/scales_gcs_glasgow_coma_scale",
        "NanoBanana/neuro/neuro_race_stroke_scale",
        "NanoBanana/neuro/neuro_cincinnati_stroke_scale",
        "NanoBanana/neuro/neuro_nih_stroke_scale",
        "NanoBanana/neuro/neuro_path_ischemic_stroke"
    ]

    // Category icons and colors for stroke scores
    private let strokeCategoryData: [(icon: String, color: Color)] = [
        ("gauge.with.dots.needle.33percent", CriticalDesign.Colors.accentGreen),  // GCS
        ("waveform.path.ecg", CriticalDesign.Colors.accentRed),                    // RACE
        ("face.smiling", CriticalDesign.Colors.accentOrange),                      // Cincinnati
        ("list.clipboard", CriticalDesign.Colors.accentBlue),                      // NIH
        ("brain", CriticalDesign.Colors.accentPurple)                              // Ischemic
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
        }
    }

    // MARK: - Neumorphic Card Background
    private var neumorphicCardBackground: some View {
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

                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Stroke Scores")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text("Assessment & Calculators")
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
            ForEach(0..<StrokeScoresBtnDataModel.strokBtnData.count, id: \.self) { index in
                StrokeNeumorphicListCard(
                    item: StrokeScoresBtnDataModel.strokBtnData[index],
                    index: index,
                    icon: strokeCategoryData[index].icon,
                    accentColor: strokeCategoryData[index].color,
                    customImage: strokeImages[index]
                )
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 20)
                .animation(
                    .easeOut(duration: 0.4).delay(0.05 + Double(index) * 0.05),
                    value: isAppearing
                )
            }
        }
    }
}

// MARK: - Stroke Neumorphic List Card
struct StrokeNeumorphicListCard: View {
    @Environment(\.colorScheme) var colorScheme
    let item: StrokeScoresBtnDataModel
    let index: Int
    let icon: String
    let accentColor: Color
    var customImage: String? = nil

    var body: some View {
        NavigationLink(destination: StrokeMiddleView(i: index)) {
            HStack(spacing: CriticalDesign.Spacing.md) {
                // Icon with neumorphic circle background
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
                        .lineLimit(2)
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
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
            )
        }
        .buttonStyle(NeuroNeumorphicButtonStyle(accentColor: accentColor))
    }
}

struct StrokeAlertBtnView_Previews: PreviewProvider {
    static var previews: some View {
        StrokeAlertBtnView()
    }
}

struct StrokeMiddleView: View {
    
    var i: Int
    
    var body: some View {
        switch i {
        case 0:
            GlascowComaScoreDetailView()
        case 1:
            RaceStrokeDetailView()
        case 2:
            CincinnatiStrokeView()
        case 3:
            NIHDetailView()
        case 4:
            IschemicStrokeathology()
        default:
            StrokeAlertBtnView()
        }
        
    }
    
}
