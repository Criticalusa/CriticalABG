//
//  StrokePathologyDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 29/12/2021.
//  Revamped with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct StrokePathologyDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false

    // Stroke type colors for visual distinction
    private let strokeColors: [Color] = [
        CriticalDesign.Colors.accentRed,
        CriticalDesign.Colors.accentBlue,
        CriticalDesign.Colors.accentOrange,
        CriticalDesign.Colors.accentPurple,
        CriticalDesign.Colors.accentGreen,
        CriticalDesign.Colors.accentTeal
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header
                    headerSection

                    // Clinical Context
                    clinicalContextCard

                    // Stroke Types
                    strokeTypesSection

                    Spacer(minLength: CriticalDesign.Spacing.xxl)
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
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
            GradientEdgeFadeImage(imageName: "icon-neuro", size: 120)

            HStack(spacing: 0) {
                Text("Stroke ")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text("Pathology")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(CriticalDesign.Colors.accentRed)
            }

            Text("Types & Classifications")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.top, CriticalDesign.Spacing.md)
    }

    // MARK: - Clinical Context Card
    private var clinicalContextCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("Why This Matters")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("Understanding stroke subtypes helps you **anticipate treatment options**, identify contraindications, and communicate effectively with the stroke team.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(6)

            Text("**Ischemic strokes** (85%) and **hemorrhagic strokes** (15%) require very different interventions. Getting this distinction right is critical.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
    }

    // MARK: - Stroke Types Section
    private var strokeTypesSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                Text("Stroke Types")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("Tap a stroke type to learn about its pathophysiology, symptoms, and treatment.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(4)

            VStack(spacing: CriticalDesign.Spacing.sm) {
                ForEach(Array(CriticalPathologyDataModel.pathologyData.enumerated()), id: \.offset) { index, stroke in
                    NavigationLink(destination: StrokePathologyBtnDetailView(data: PathologyBtnDetail.pathologyBtnDetail[index]).navigationBarBackground { Color.logoBlue.shadow(radius: 1) }) {
                        StrokeTypeCardNew(
                            title: stroke.title,
                            color: strokeColors[index % strokeColors.count],
                            index: index
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 10)
                    .animation(.easeOut(duration: 0.4).delay(0.1 + Double(index) * 0.05), value: isAppearing)
                }
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
    }

    // MARK: - Neumorphic Card Background
    private var neumorphicCardBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(Color.clear)
                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 10, y: 10)
                .shadow(color: Color.white, radius: 12, x: -6, y: -6)
        }
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.8), Color.white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Stroke Type Card Component (New Design)
private struct StrokeTypeCardNew: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let color: Color
    let index: Int

    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            // Color indicator circle
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)

            // Number badge
            Text("\(index + 1)")
                .font(.custom("Poppins-Bold", size: 13))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Circle().fill(color.opacity(0.8)))

            // Title
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Spacer()

            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(CriticalDesign.Spacing.md)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(
                        LinearGradient(
                            colors: [Color.white, CriticalDesign.Colors.canvas],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(Color.clear)
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 3, y: 3)
                    .shadow(color: Color.white, radius: 6, x: -3, y: -3)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        StrokePathologyDetailView()
    }
}
