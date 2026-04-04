//
//  ChestXrayView.swift
//  CriticalX
//
//  Created by Macbook 7 on 05/01/2022.
//  Revamped with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct ChestXrayView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var imgSwitch = true
    @State private var isActive = false
    @State private var showEnlargedImage = false
    @State private var isAppearing = false
    @State private var showAllPearls = false

    // Critical Pearls for stepper
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Systematic approach:", content: "Use ABCDEFGHI: Airway, Bones, Cardiac silhouette, Diaphragm, Effusions, Fields (lungs), Gastric bubble, Hilum, Instrumentation."),
        CriticalPearlItem(header: "Quality first:", content: "Before interpreting, check rotation (clavicles symmetric), inspiration (6+ anterior ribs visible), and penetration (vertebrae visible through heart)."),
        CriticalPearlItem(header: "Silhouette sign:", content: "If you can't see a border, something is touching it. Loss of right heart border = right middle lobe pathology. Loss of left heart border = lingula."),
        CriticalPearlItem(header: "Air bronchograms:", content: "Black tubes (air-filled bronchi) against white consolidation = alveolar process (pneumonia, pulmonary edema). Their absence suggests atelectasis."),
        CriticalPearlItem(header: "The takeaway:", content: "A systematic approach prevents missed findings. Always compare to prior films and correlate with clinical context.")
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Colors.canvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header
                    headerSection

                    // Clinical Context
                    clinicalContextCard

                    // Image Card
                    imageCard

                    // ABCDEFGHI Approach
                    systematicApproachCard

                    // Navigation to Procedural Confirmation
                    proceduralConfirmationCard

                    // Critical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)

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
        .fullScreenCover(isPresented: $showEnlargedImage) {
            CXREnlargedImageView(imageName: imgSwitch ? "CXR1" : "CXR_Detail", title: imgSwitch ? "Normal Chest X-Ray" : "Illustrated Chest X-Ray")
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.accentTeal.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)

                ZStack {
                    Circle()
                        .fill(colorScheme == .dark
                            ? CriticalDesign.Colors.cardBlue.opacity(0.85)
                            : Color.white.opacity(0.9))
                        .frame(width: 80, height: 80)

                    Circle()
                        .stroke(colorScheme == .dark
                            ? Color.white.opacity(0.12)
                            : Color.white.opacity(0.8), lineWidth: 1)
                        .frame(width: 80, height: 80)

                    Image(systemName: "xray")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [CriticalDesign.Colors.accentTeal, CriticalDesign.Colors.accentBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("Chest X-Ray")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("Systematic Interpretation")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.top, CriticalDesign.Spacing.md)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Clinical Context Card
    private var clinicalContextCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentTeal)

                Text("Why This Matters")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("The chest X-ray is **one of the most common imaging studies** in critical care. A systematic approach ensures you don't miss important findings like pneumothorax, effusions, or tube malpositions.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)

            Text("Toggle between the normal and illustrated views to learn the anatomical landmarks and structures.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.05), value: isAppearing)
    }

    // MARK: - Image Card
    private var imageCard: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Image Title
            Text(imgSwitch ? "Normal Chest X-Ray" : "Illustrated Chest X-Ray")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            // X-Ray Image
            if UIImage(named: imgSwitch ? "CXR1" : "CXR_Detail") != nil {
                Image(imgSwitch ? "CXR1" : "CXR_Detail")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .cornerRadius(16)
                    .clipped()
                    .onTapGesture {
                        showEnlargedImage = true
                    }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.accentTeal.opacity(0.05))
                        .frame(height: 250)

                    VStack(spacing: 12) {
                        Image(systemName: "xray")
                            .font(.system(size: 50))
                            .foregroundColor(CriticalDesign.Colors.accentTeal.opacity(0.4))
                        Text("Chest X-Ray")
                            .font(.custom("Poppins-Medium", size: 14))
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
                    .foregroundColor(CriticalDesign.Colors.accentTeal.opacity(0.6))
            }

            // Toggle Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    imgSwitch.toggle()
                }
            }) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: imgSwitch ? "rectangle.on.rectangle" : "rectangle")
                        .font(.system(size: 16, weight: .semibold))

                    Text(imgSwitch ? "Show Illustrated View" : "Show Normal View")
                        .font(.custom("Poppins-SemiBold", size: 15))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .fill(
                            LinearGradient(
                                colors: imgSwitch ? [CriticalDesign.Colors.accentTeal, CriticalDesign.Colors.accentBlue] : [CriticalDesign.Colors.accentGreen, CriticalDesign.Colors.accentTeal],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(color: (imgSwitch ? CriticalDesign.Colors.accentTeal : CriticalDesign.Colors.accentGreen).opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - Systematic Approach Card
    private var systematicApproachCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "checklist")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("ABCDEFGHI Approach")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                approachRow("A", "Airway", "Trachea midline? ETT position?", CriticalDesign.Colors.accentRed)
                approachRow("B", "Bones", "Ribs, clavicles, spine for fractures", CriticalDesign.Colors.accentOrange)
                approachRow("C", "Cardiac", "Heart size (<1/2 thorax width)", CriticalDesign.Colors.accentPurple)
                approachRow("D", "Diaphragm", "Right > Left, costophrenic angles", CriticalDesign.Colors.accentBlue)
                approachRow("E", "Effusions", "Blunting of costophrenic angles", CriticalDesign.Colors.accentTeal)
                approachRow("F", "Fields", "Lung parenchyma, symmetry", CriticalDesign.Colors.accentGreen)
                approachRow("G", "Gastric", "Gastric bubble under left diaphragm", CriticalDesign.Colors.goldDeep)
                approachRow("H", "Hilum", "Hilar structures, lymphadenopathy", CriticalDesign.Colors.accentPurple)
                approachRow("I", "Instrumentation", "Lines, tubes, devices in place", CriticalDesign.Colors.cardBlue)
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.accentBlue.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(CriticalDesign.Colors.accentBlue.opacity(0.15), lineWidth: 1)
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - Procedural Confirmation Card
    private var proceduralConfirmationCard: some View {
        Button(action: { isActive = true }) {
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.goldDeep)

                    Text("Procedural Confirmation")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.goldDeep)
                }

                Text("Learn how to confirm proper placement of ETTs, central lines, NG tubes, and chest tubes on CXR.")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
            }
            .padding(CriticalDesign.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.goldLight.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .stroke(CriticalDesign.Colors.goldMid.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .navigationDestination(isPresented: $isActive) {
            ChestXrayPocedureConfirmationView()
                .navigationBarBackground { Color.logoBlue.shadow(radius: 1) }
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Helper Views
    private func approachRow(_ letter: String, _ title: String, _ description: String, _ color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Text(letter)
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(description)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }
        }
    }

    // MARK: - Neumorphic Card Background
    private var neumorphicCardBackground: some View {
        Group {
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.cardBlue)
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            } else {
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
    }
}

// MARK: - Enlarged Image View
struct CXREnlargedImageView: View {
    @Environment(\.presentationMode) var presentationMode
    let imageName: String
    let title: String

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

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

                ScrollView([.vertical, .horizontal], showsIndicators: true) {
                    if UIImage(named: imageName) != nil {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .pinchToZoom()
                            .padding()
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "xray")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.5))
                            Text("Image not available")
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text("Pinch to zoom")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.bottom, 30)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ChestXrayView()
    }
}
