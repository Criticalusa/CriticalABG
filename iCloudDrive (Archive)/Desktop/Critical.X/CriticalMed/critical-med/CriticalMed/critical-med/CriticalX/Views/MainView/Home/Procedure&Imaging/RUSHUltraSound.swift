//
//  RUSHUltraSound.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 4/14/22.
//  Revamped with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct RUSHUltraSound: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false
    @State private var expandedSection: String? = nil

    // Critical Pearls for stepper
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Think in categories:", content: "RUSH helps you differentiate the 4 types of shock: hypovolemic, cardiogenic, obstructive, and distributive. The findings guide your resuscitation."),
        CriticalPearlItem(header: "Pump first:", content: "Start with cardiac views—a hyperdynamic heart suggests hypovolemia or distributive shock. A poorly contracting heart suggests cardiogenic. Pericardial fluid suggests obstructive."),
        CriticalPearlItem(header: "IVC tells the story:", content: "Small, collapsing IVC = volume depleted. Plethoric, non-collapsing IVC = obstructive or cardiogenic. Context matters!"),
        CriticalPearlItem(header: "Don't forget the pipes:", content: "Check the aorta for aneurysm/dissection. Check femoral veins for DVT if PE is suspected."),
        CriticalPearlItem(header: "The takeaway:", content: "RUSH is a systematic bedside exam that guides shock resuscitation in real-time. Master the three components: Pump, Tank, and Pipes.")
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

                    // The Three Components Overview
                    componentsOverviewCard

                    // PUMP Section
                    NavigationLink(destination: RUSHPumpDetailView()) {
                        pumpCard
                    }
                    .buttonStyle(PlainButtonStyle())

                    // TANK Section
                    NavigationLink(destination: RUSHTankDetailView()) {
                        tankCard
                    }
                    .buttonStyle(PlainButtonStyle())

                    // PIPES Section
                    NavigationLink(destination: RUSHPipesDetailView()) {
                        pipesCard
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Clinical Integration
                    clinicalIntegrationCard

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
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("RUSH Exam")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("Rapid Ultrasound in Shock")
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

            Text("The RUSH exam is a **structured point-of-care ultrasound protocol** for patients in undifferentiated shock. It helps you rapidly identify the **cause of shock** at the bedside.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)

            Text("Unlike FAST (which focuses on trauma), RUSH evaluates **cardiac function, volume status, and vascular integrity** to differentiate between hypovolemic, cardiogenic, obstructive, and distributive shock.")
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

    // MARK: - Components Overview Card
    private var componentsOverviewCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentTeal)

                Text("The Three Components")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(spacing: CriticalDesign.Spacing.md) {
                componentRow(
                    icon: "heart.fill",
                    title: "PUMP",
                    subtitle: "Cardiac Function",
                    color: CriticalDesign.Colors.accentRed
                )

                componentRow(
                    icon: "drop.fill",
                    title: "TANK",
                    subtitle: "Volume Status",
                    color: CriticalDesign.Colors.accentBlue
                )

                componentRow(
                    icon: "arrow.left.arrow.right",
                    title: "PIPES",
                    subtitle: "Vascular Integrity",
                    color: CriticalDesign.Colors.accentPurple
                )
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - PUMP Card
    private var pumpCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                Text("PUMP — Cardiac Evaluation")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }

            Text("Evaluate cardiac contractility and look for pericardial effusion.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                viewRow("Parasternal Long Axis (PLAX)", "Assess LV contractility, pericardial effusion")
                viewRow("Parasternal Short Axis (PSAX)", "LV shape, septal motion")
                viewRow("Subxiphoid (4-chamber)", "RV/LV comparison, pericardium")
                viewRow("Apical 4-Chamber", "Overall cardiac function")
            }

            // Interpretation Box
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
                Text("Interpretation:")
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                interpretationRow("Hyperdynamic", "Hypovolemic or distributive shock")
                interpretationRow("Hypodynamic", "Cardiogenic shock")
                interpretationRow("Pericardial fluid", "Consider tamponade (obstructive)")
                interpretationRow("Dilated RV", "PE, massive or submassive")
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.accentRed.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .stroke(CriticalDesign.Colors.accentRed.opacity(0.15), lineWidth: 1)
            )
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - TANK Card
    private var tankCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("TANK — Volume Status")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }

            Text("Assess intravascular volume and look for fluid in body cavities.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                viewRow("IVC (Inferior Vena Cava)", "Diameter and respiratory variation")
                viewRow("FAST Views (RUQ, LUQ, Pelvis)", "Free fluid in abdomen/pelvis")
                viewRow("Thoracic Views", "Pleural effusion, lung sliding")
            }

            // IVC Interpretation Box
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
                Text("IVC Assessment:")
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                HStack(alignment: .top, spacing: CriticalDesign.Spacing.md) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Small + Collapsing")
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        Text("<2cm, >50% collapse")
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        Text("→ Volume depleted")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(CriticalDesign.Colors.accentRed)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Plethoric + Fixed")
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        Text(">2cm, <50% collapse")
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        Text("→ Obstructive/Cardiogenic")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(CriticalDesign.Colors.accentPurple)
                    }
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.accentBlue.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .stroke(CriticalDesign.Colors.accentBlue.opacity(0.15), lineWidth: 1)
            )
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - PIPES Card
    private var pipesCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentPurple)

                Text("PIPES — Vascular Integrity")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }

            Text("Evaluate the aorta and check for DVT if PE is suspected.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                viewRow("Abdominal Aorta", "Aneurysm (>3cm), dissection flap")
                viewRow("Proximal Aorta (PLAX)", "Aortic root dilation, dissection")
                viewRow("Femoral & Popliteal Veins", "Compressibility (DVT screening)")
            }

            // Warning Box
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Red Flags")
                        .font(.custom("Poppins-Bold", size: 13))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                    Text("AAA >5cm with shock = emergent surgery. Non-compressible femoral vein + dyspnea = consider PE and anticoagulation.")
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.accentRed.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .stroke(CriticalDesign.Colors.accentRed.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.25), value: isAppearing)
    }

    // MARK: - Clinical Integration Card
    private var clinicalIntegrationCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "stethoscope")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)

                Text("Putting It Together")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                shockTypeRow(
                    type: "Hypovolemic",
                    findings: "Hyperdynamic heart, small/collapsing IVC, ± free fluid",
                    color: CriticalDesign.Colors.accentOrange
                )

                shockTypeRow(
                    type: "Cardiogenic",
                    findings: "Hypodynamic heart, plethoric IVC, ± pulmonary edema",
                    color: CriticalDesign.Colors.accentRed
                )

                shockTypeRow(
                    type: "Obstructive",
                    findings: "Pericardial effusion, dilated RV, plethoric IVC",
                    color: CriticalDesign.Colors.accentPurple
                )

                shockTypeRow(
                    type: "Distributive",
                    findings: "Hyperdynamic heart, variable IVC, warm extremities",
                    color: CriticalDesign.Colors.accentGreen
                )
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
    private func componentRow(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }

            Spacer()
        }
    }

    private func viewRow(_ view: String, _ description: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(CriticalDesign.Colors.accentTeal)
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 2) {
                Text(view)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(description)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }
        }
    }

    private func interpretationRow(_ finding: String, _ meaning: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Text("•")
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(CriticalDesign.Colors.accentRed)

            Text("\(finding): ")
                .font(.custom("Poppins-SemiBold", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            +
            Text(meaning)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    private func shockTypeRow(type: String, findings: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 2) {
                Text(type)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(color)
                Text(findings)
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

// MARK: - Preview
#Preview {
    RUSHUltraSound()
}
