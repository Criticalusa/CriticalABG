//
//  CenterVenousCatheterView.swift
//  CriticalX
//
//  Created by Macbook 7 on 06/01/2022.
//  Revamped with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct CenterVenousCatheterView: View {
    @Environment(\.colorScheme) var colorScheme

    // Enum to represent modal types for clean and scalable modal handling
    enum ModalType: Identifiable {
        case anatomy, longAxisTenting, needleTenting, cxrConfirmation

        var id: Self { self }
    }

    @State private var selectedModal: ModalType? = nil
    @State private var isAppearing = false
    @State private var showAllPearls = false
    @State private var expandedSection: String? = nil

    // Critical Pearls for stepper
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Location matters:", content: "Internal jugular is preferred for emergent access. Subclavian has lower infection risk but higher pneumothorax risk. Femoral is fastest but has highest infection rate."),
        CriticalPearlItem(header: "Ultrasound is non-negotiable:", content: "Real-time ultrasound guidance reduces complications by >80%. Always visualize needle tip entering the vein."),
        CriticalPearlItem(header: "Confirm before dilating:", content: "ALWAYS confirm venous placement with manometry or blood gas before dilating. Arterial dilation is a catastrophic complication."),
        CriticalPearlItem(header: "Depth landmarks:", content: "Right IJ: 15-17cm. Left IJ: 17-19cm. Subclavian: 15-17cm. Tip should be at SVC-RA junction, ~1-2cm above carina."),
        CriticalPearlItem(header: "The takeaway:", content: "Central lines save lives but can cause serious harm. Use ultrasound, maintain sterile technique, and always confirm placement before use.")
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

                    // Anatomy Card
                    anatomyCard

                    // Procedure Overview
                    procedureOverviewCard

                    // Preparation & Steps
                    preparationCard

                    // Ultrasound Technique
                    ultrasoundTechniqueCard

                    // CXR Confirmation
                    cxrConfirmationCard

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
        .sheet(item: $selectedModal) { modal in
            switch modal {
            case .anatomy:
                CVCEnlargedImageView(imageName: "CentralLineAnatomy", title: "Central Line Anatomy")
            case .longAxisTenting:
                GifView(gifImage: "CentralLine_LongAxisTenting")
            case .needleTenting:
                GifView(gifImage: "CentralLine_NeedleTenting")
            case .cxrConfirmation:
                CVCEnlargedImageView(imageName: "CentralLinePlacement_Image", title: "CXR Confirmation")
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.accentBlue.opacity(0.15))
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

                    Image(systemName: "arrow.up.to.line.circle.fill")
                        .font(.system(size: 36, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [CriticalDesign.Colors.accentBlue, CriticalDesign.Colors.accentTeal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("Central Venous Catheterization")
                .font(.custom("Poppins-Bold", size: 24))
                .foregroundColor(CriticalDesign.Colors.cardBlue)
                .multilineTextAlignment(.center)

            Text("Ultrasound-Guided Technique")
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
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("Why This Matters")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("Central venous catheters are **essential for critically ill patients**. They enable hemodynamic monitoring, rapid medication delivery, and specialized therapies like CRRT, plasmapheresis, and dialysis.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)

            Text("Ultrasound guidance has transformed this procedure—reducing complications and improving first-pass success rates significantly.")
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

    // MARK: - Anatomy Card
    private var anatomyCard: some View {
        VStack(spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "figure.stand")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentPurple)

                Text("Anatomy")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()
            }

            if UIImage(named: "CentralLineAnatomy") != nil {
                Image("CentralLineAnatomy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
                    .cornerRadius(16)
                    .clipped()
                    .onTapGesture {
                        selectedModal = .anatomy
                    }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.accentBlue.opacity(0.05))
                        .frame(height: 180)

                    VStack(spacing: 12) {
                        Image(systemName: "figure.stand")
                            .font(.system(size: 40))
                            .foregroundColor(CriticalDesign.Colors.accentBlue.opacity(0.4))
                        Text("Anatomy Diagram")
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

    // MARK: - Procedure Overview Card
    private var procedureOverviewCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentTeal)

                Text("Access Sites")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                accessSiteRow(
                    site: "Internal Jugular",
                    color: CriticalDesign.Colors.accentBlue,
                    pros: "Excellent for emergent access, compressible",
                    cons: "Carotid artery nearby, difficult in obese patients"
                )

                accessSiteRow(
                    site: "Subclavian",
                    color: CriticalDesign.Colors.accentPurple,
                    pros: "Lower infection risk, more comfortable for patient",
                    cons: "Higher pneumothorax risk, non-compressible"
                )

                accessSiteRow(
                    site: "Femoral",
                    color: CriticalDesign.Colors.accentOrange,
                    pros: "Fastest access, away from airway",
                    cons: "Highest infection rate, limits mobility"
                )
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - Preparation Card
    private var preparationCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "checklist")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentGreen)

                Text("Preparation Checklist")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                checklistItem("Obtain informed consent")
                checklistItem("Check coagulation status (INR, platelets)")
                checklistItem("Prepare sterile field and equipment")
                checklistItem("Position patient (Trendelenburg for IJ/subclavian)")
                checklistItem("Ultrasound machine ready with sterile probe cover")
                checklistItem("Perform TIME OUT")
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.accentGreen.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(CriticalDesign.Colors.accentGreen.opacity(0.2), lineWidth: 1)
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Ultrasound Technique Card
    private var ultrasoundTechniqueCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("Ultrasound Technique")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                stepRow("1", "Identify", "Locate the vein in short axis. Confirm it compresses easily (artery won't).", CriticalDesign.Colors.accentBlue)
                stepRow("2", "Angle", "Insert needle at 30° toward ipsilateral nipple, watching for tenting.", CriticalDesign.Colors.accentPurple)
                stepRow("3", "Confirm", "Visualize needle tip entering vein. Aspirate dark blood.", CriticalDesign.Colors.accentGreen)
                stepRow("4", "Wire", "Advance guidewire under ultrasound visualization.", CriticalDesign.Colors.accentOrange)
                stepRow("5", "Verify", "Confirm wire in vein before dilating—this is critical!", CriticalDesign.Colors.accentRed)
                stepRow("6", "Complete", "Dilate, insert catheter, secure, and confirm placement.", CriticalDesign.Colors.cardBlue)
            }

            // GIF Section
            HStack(spacing: CriticalDesign.Spacing.md) {
                VStack(spacing: CriticalDesign.Spacing.xs) {
                    GifImage("CentralLine_LongAxisTenting")
                        .frame(height: 100)
                        .cornerRadius(12)
                        .onTapGesture {
                            selectedModal = .longAxisTenting
                        }
                    Text("Long Axis")
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }

                VStack(spacing: CriticalDesign.Spacing.xs) {
                    GifImage("CentralLine_NeedleTenting")
                        .frame(height: 100)
                        .cornerRadius(12)
                        .onTapGesture {
                            selectedModal = .needleTenting
                        }
                    Text("Needle Tenting")
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
            }
            .padding(.top, CriticalDesign.Spacing.xs)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.25), value: isAppearing)
    }

    // MARK: - CXR Confirmation Card
    private var cxrConfirmationCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "xray")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)

                Text("CXR Confirmation")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("Always confirm catheter placement with chest X-ray before use:")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
                bulletPoint("Tip at SVC-RA junction (~1-2cm above carina)")
                bulletPoint("No pneumothorax (check lung markings to chest wall)")
                bulletPoint("No hemothorax or widened mediastinum")
                bulletPoint("Catheter follows expected venous course")
            }

            if UIImage(named: "CentralLinePlacement_Image") != nil {
                Image("CentralLinePlacement_Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 180)
                    .cornerRadius(12)
                    .onTapGesture {
                        selectedModal = .cxrConfirmation
                    }

                HStack(spacing: 4) {
                    Text("Tap to enlarge")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 10))
                        .foregroundColor(CriticalDesign.Colors.goldDeep.opacity(0.6))
                }
            }
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
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.3), value: isAppearing)
    }

    // MARK: - Helper Views
    private func accessSiteRow(site: String, color: Color, pros: String, cons: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)

                Text(site)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 10))
                    .foregroundColor(CriticalDesign.Colors.accentGreen)
                Text(pros)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            .padding(.leading, 18)

            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 10))
                    .foregroundColor(CriticalDesign.Colors.accentRed)
                Text(cons)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            .padding(.leading, 18)
        }
        .padding(.vertical, CriticalDesign.Spacing.xs)
    }

    private func checklistItem(_ text: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: "checkmark.square")
                .font(.system(size: 14))
                .foregroundColor(CriticalDesign.Colors.accentGreen)

            Text(text)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(CriticalDesign.Colors.goldDeep)
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            Text(text)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    private func stepRow(_ number: String, _ title: String, _ description: String, _ color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.md) {
            Text(number)
                .font(.custom("Poppins-Bold", size: 13))
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(description)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
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
struct CVCEnlargedImageView: View {
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
                            Image(systemName: "photo")
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
    CenterVenousCatheterView()
}
