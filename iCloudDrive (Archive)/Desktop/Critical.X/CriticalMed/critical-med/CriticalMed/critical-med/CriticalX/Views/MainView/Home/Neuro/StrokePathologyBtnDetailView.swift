//
//  StrokePathologyBtnDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 29/12/2021.
//  Revamped with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct StrokePathologyBtnDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    let data: PathologyBtnDetail
    @State private var isAppearing = false
    @State private var showImageFullScreen = false

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header
                    headerSection

                    // Image Card
                    imageCard

                    // Overview Card
                    overviewCard

                    // Exam Findings Card
                    examFindingsCard

                    // Status Card
                    statusCard

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
        .fullScreenCover(isPresented: $showImageFullScreen) {
            StrokeImageFullScreenView(imageName: data.image, title: data.btnTitle)
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            GradientEdgeFadeImage(imageName: "icon-neuro", size: 100)

            Text(data.btnTitle)
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .multilineTextAlignment(.center)

            Text("Stroke Pathology")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.top, CriticalDesign.Spacing.md)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Image Card
    private var imageCard: some View {
        VStack(spacing: CriticalDesign.Spacing.sm) {
            if !data.image.isEmpty, UIImage(named: data.image) != nil {
                Image(data.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .onTapGesture {
                        showImageFullScreen = true
                    }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.accentBlue.opacity(0.05))
                        .frame(height: 180)

                    VStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 40))
                            .foregroundColor(CriticalDesign.Colors.accentBlue.opacity(0.4))
                        Text("Brain Imaging")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    }
                }
            }

            HStack(spacing: 4) {
                Text("Tap to enlarge")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 10))
                    .foregroundColor(CriticalDesign.Colors.accentBlue.opacity(0.6))
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - Overview Card
    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentTeal)

                Text("Overview")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text(data.overView)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - Exam Findings Card
    private var examFindingsCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "stethoscope")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)

                Text("Exam Findings")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text(data.examFinding)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.goldLight.opacity(0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(CriticalDesign.Colors.goldMid.opacity(0.3), lineWidth: 1)
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Status Card (Clinical Takeaway)
    private var statusCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(data.color)

                Text("Clinical Status")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(.white)
            }

            Text(data.status)
                .font(.custom("Poppins-SemiBold", size: 15))
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(4)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.cardBlue)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    LinearGradient(
                        colors: [data.color, data.color.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: data.color.opacity(0.2), radius: 8, x: 0, y: 4)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.25), value: isAppearing)
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

// MARK: - Stroke Image Full Screen View
struct StrokeImageFullScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    let imageName: String
    let title: String

    var body: some View {
        ZStack {
            CriticalDesign.Colors.darkCanvas.ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(20)
                }

                Spacer()

                if !imageName.isEmpty, UIImage(named: imageName) != nil {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.5))
                        Text("Image not available")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                Spacer()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    StrokePathologyBtnDetailView(data: PathologyBtnDetail(
        btnTitle: "Subarachnoid Hemorrhage",
        image: "",
        overView: "SAH is a life-threatening condition caused by bleeding into the subarachnoid space, typically from a ruptured cerebral aneurysm. Classic presentation is thunderclap headache - the worst headache of their life with sudden onset.",
        examFinding: "• Severe headache with sudden onset\n• Neck stiffness (meningismus)\n• Photophobia\n• Altered mental status\n• Focal neurologic deficits\n• Nausea and vomiting",
        status: "Fibrinolytics are CONTRAINDICATED",
        color: .red
    ))
}
