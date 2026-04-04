//
//  UltrasonographyMainView.swift
//  CriticalX
//
//  Created by Macbook 7 on 05/01/2022.
//  Revamped with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct UltrasonographyMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header
                    headerSection

                    // Clinical Context
                    clinicalContextCard

                    // Protocol Cards
                    protocolCardsSection

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
            // Icon
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.accentPurple.opacity(0.15))
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

                    if UIImage(named: "icon-ultrasound 1") != nil {
                        CatalogThumbnailImage(name: "icon-ultrasound 1", size: 44, cornerRadius: 0, clipCircular: true)
                    } else {
                        Image(systemName: "waveform.path.ecg.rectangle")
                            .font(.system(size: 34, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [CriticalDesign.Colors.accentPurple, CriticalDesign.Colors.accentBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("Point-of-Care Ultrasound")
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("Bedside Imaging Protocols")
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
                    .foregroundColor(CriticalDesign.Colors.accentPurple)

                Text("Why This Matters")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("Point-of-care ultrasound (POCUS) has transformed critical care. **Bedside imaging** allows rapid diagnosis of life-threatening conditions—from cardiac tamponade to pneumothorax to hemoperitoneum.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)

            Text("These protocols provide structured approaches to common clinical scenarios.")
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

    // MARK: - Protocol Cards Section
    private var protocolCardsSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // eFAST Card
            NavigationLink(destination: EFastExaminationView().navigationBarHidden(true)) {
                protocolCard(
                    icon: "figure.fall",
                    title: "eFAST Examination",
                    subtitle: "Extended-Focused Assessment with Sonography in Trauma",
                    description: "Rapid detection of free fluid in trauma patients",
                    color: CriticalDesign.Colors.accentRed,
                    isAvailable: true,
                    customImage: "NanoBanana/pocus/pocus_efast_examination"
                )
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 15)
            .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)

            // RUSH Card
            NavigationLink(destination: RUSHUltraSound().navigationBarBackground { Color.logoBlue.shadow(radius: 1) }) {
                protocolCard(
                    icon: "bolt.heart.fill",
                    title: "RUSH Protocol",
                    subtitle: "Rapid Ultrasound for Shock & Hypotension",
                    description: "Differentiate shock types: hypovolemic, cardiogenic, obstructive, distributive",
                    color: CriticalDesign.Colors.accentPurple,
                    isAvailable: true,
                    customImage: "NanoBanana/pocus/pocus_rush_protocol"
                )
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 15)
            .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)

            // Lung Protocol Card
            NavigationLink(destination: LungUltrasoundView()) {
                protocolCard(
                    icon: "lungs.fill",
                    title: "Lung Ultrasound",
                    subtitle: "BLUE Protocol & Lung Assessment",
                    description: "Diagnose cardiopulmonary emergencies at bedside",
                    color: CriticalDesign.Colors.accentTeal,
                    isAvailable: true,
                    customImage: "NanoBanana/pocus/pocus_lung_ultrasound"
                )
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 15)
            .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)

            // Cardiac Card
            NavigationLink(destination: FocusedCardiacView()) {
                protocolCard(
                    icon: "heart.fill",
                    title: "Focused Cardiac",
                    subtitle: "Basic Echocardiography Views",
                    description: "PLAX, PSAX, Apical, Subxiphoid cardiac assessment",
                    color: CriticalDesign.Colors.accentBlue,
                    isAvailable: true,
                    customImage: "NanoBanana/pocus/pocus_focused_cardiac"
                )
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 15)
            .animation(.easeOut(duration: 0.4).delay(0.25), value: isAppearing)

            // DVT Compression Study
            NavigationLink(destination: DVTCompressionView()) {
                protocolCard(
                    icon: "bandage.fill",
                    title: "DVT Compression",
                    subtitle: "2-Point Venous Compression Study",
                    description: "Rapid bedside DVT screening for PE workup",
                    color: CriticalDesign.Colors.accentRed,
                    isAvailable: true,
                    customImage: "NanoBanana/pocus/pocus_dvt_compression"
                )
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 15)
            .animation(.easeOut(duration: 0.4).delay(0.3), value: isAppearing)

            // Aorta Assessment
            NavigationLink(destination: AortaAssessmentView()) {
                protocolCard(
                    icon: "heart.circle",
                    title: "Aorta Assessment",
                    subtitle: "AAA Screening & Dissection",
                    description: "Abdominal aortic aneurysm detection and measurement",
                    color: CriticalDesign.Colors.accentOrange,
                    isAvailable: true,
                    customImage: "NanoBanana/pocus/pocus_aorta_assessment"
                )
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 15)
            .animation(.easeOut(duration: 0.4).delay(0.35), value: isAppearing)

            // Soft Tissue
            NavigationLink(destination: SoftTissueUltrasoundView()) {
                protocolCard(
                    icon: "hand.raised.fingers.spread.fill",
                    title: "Soft Tissue",
                    subtitle: "Abscess, Cellulitis & Foreign Body",
                    description: "Distinguish drainable collections from cellulitis",
                    color: CriticalDesign.Colors.accentGreen,
                    isAvailable: true,
                    customImage: "NanoBanana/pocus/pocus_soft_tissue_ultrasound"
                )
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 15)
            .animation(.easeOut(duration: 0.4).delay(0.4), value: isAppearing)

            // Ocular Ultrasound
            NavigationLink(destination: OcularUltrasoundView()) {
                protocolCard(
                    icon: "eye.fill",
                    title: "Ocular Ultrasound",
                    subtitle: "Eye Pathology & ONSD for ICP",
                    description: "Retinal detachment, vitreous hemorrhage, elevated ICP screening",
                    color: CriticalDesign.Colors.accentPurple,
                    isAvailable: true,
                    customImage: "NanoBanana/pocus/pocus_ocular_ultrasound"
                )
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 15)
            .animation(.easeOut(duration: 0.4).delay(0.45), value: isAppearing)

            // POCUS Integration (EM, Prehospital, Educational)
            NavigationLink(destination: EMPOCUSIntegrationView()) {
                protocolCard(
                    icon: "cross.case.fill",
                    title: "POCUS Integration",
                    subtitle: "EM, Prehospital & Foundations",
                    description: "Clinical workflows, probe selection, knobology, artifacts guide",
                    color: CriticalDesign.Colors.goldDeep,
                    isAvailable: true
                )
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 15)
            .animation(.easeOut(duration: 0.4).delay(0.5), value: isAppearing)
        }
    }

    // MARK: - Protocol Card Builder
    private func protocolCard(icon: String, title: String, subtitle: String, description: String, color: Color, isAvailable: Bool, customImage: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.md) {
                // Icon
                protocolCardIcon(icon: icon, color: color, customImage: customImage)

                protocolCardTextContent(title: title, subtitle: subtitle, color: color, isAvailable: isAvailable)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }

            Text(description)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(3)
                .padding(.leading, 62)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(protocolCardBackground(isAvailable: isAvailable))
        .overlay(protocolCardBorder(color: color, isAvailable: isAvailable))
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
        .opacity(isAvailable ? 1 : 0.8)
    }
    
    // MARK: - Protocol Card Subviews (Fix Type-Checking Timeout)
    
    @ViewBuilder
    private func protocolCardIcon(icon: String, color: Color, customImage: String?) -> some View {
        if let customImage = customImage, UIImage(named: customImage) != nil {
            CatalogThumbnailImage(name: customImage, size: 80, cornerRadius: 12)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
            .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
        }
    }
    
    private func protocolCardTextContent(title: String, subtitle: String, color: Color, isAvailable: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.custom("Poppins-Bold", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                if !isAvailable {
                    Text("SOON")
                        .font(.custom("Poppins-Bold", size: 9))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(CriticalDesign.Colors.accentOrange)
                        )
                }
            }

            Text(subtitle)
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(color)
                .lineLimit(1)
        }
    }
    
    private func protocolCardBackground(isAvailable: Bool) -> some View {
        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
            .fill(colorScheme == .dark
                ? CriticalDesign.Colors.cardBlue.opacity(isAvailable ? 1 : 0.7)
                : (isAvailable ? Color.white : Color.white.opacity(0.7)))
    }
    
    private func protocolCardBorder(color: Color, isAvailable: Bool) -> some View {
        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
            .stroke(color.opacity(isAvailable ? 0.2 : 0.1), lineWidth: 1)
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

// MARK: - Preview
#Preview {
    NavigationView {
        UltrasonographyMainView()
    }
}
