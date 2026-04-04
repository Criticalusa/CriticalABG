//
//  ChestXrayPocedureConfirmationView.swift
//  CriticalX
//
//  Created by Macbook 7 on 06/01/2022.
//  Revamped with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct ChestXrayPocedureConfirmationView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false

    // Critical Pearls for stepper
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Always compare:", content: "Compare to prior films when available. A 'new' finding might have been present before, or a subtle change might indicate migration."),
        CriticalPearlItem(header: "Follow the tube:", content: "Trace every tube from skin entry to tip. A tube that looks correctly positioned might actually be kinked or malpositioned along its course."),
        CriticalPearlItem(header: "Check for complications:", content: "After any line/tube placement, specifically look for pneumothorax, hemothorax, and subcutaneous emphysema."),
        CriticalPearlItem(header: "The carina is your friend:", content: "Most tube positions are defined relative to the carina. Know that the carina is typically at T4-T5, around the aortic knob level."),
        CriticalPearlItem(header: "The takeaway:", content: "Confirming tube/line placement on CXR is a critical skill. A systematic approach prevents missed malpositions that can cause patient harm.")
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

                    // Chest Tubes
                    chestTubesCard

                    // Central Lines
                    centralLinesCard

                    // ETT
                    ettCard

                    // Ventilation
                    ventilationCard

                    // NG/OG
                    ngOgCard

                    // Tracheostomy
                    trachCard

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
                    .fill(CriticalDesign.Colors.goldDeep.opacity(0.15))
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

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [CriticalDesign.Colors.goldDeep, CriticalDesign.Colors.accentOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("Procedure Confirmation")
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("CXR Tube & Line Positioning")
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
                    .foregroundColor(CriticalDesign.Colors.goldDeep)

                Text("Why This Matters")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("After placing any tube or line, **confirmation of proper positioning** is essential before use. Malpositioned tubes can cause significant harm—from tension pneumothorax to aspiration to vascular injury.")
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

    // MARK: - Chest Tubes Card
    private var chestTubesCard: some View {
        procedureCard(
            icon: "lungs.fill",
            title: "Chest Tubes",
            color: CriticalDesign.Colors.accentRed,
            content: [
                ProcedureSection(
                    subtitle: "For Pleural Effusions",
                    points: [
                        "Position: Inferior-posterior at 8th intercostal space",
                        "Tip aimed toward lower pleural cavity",
                        "Directly posterior placement"
                    ]
                ),
                ProcedureSection(
                    subtitle: "For Pneumothorax",
                    points: [
                        "Position: Anterior mid-clavicular at 3rd ICS, OR",
                        "Anterior axillary toward apex at 4th-5th ICS",
                        "Tip aimed toward upper pleural cavity"
                    ]
                )
            ],
            delay: 0.1
        )
    }

    // MARK: - Central Lines Card
    private var centralLinesCard: some View {
        procedureCard(
            icon: "arrow.up.to.line.circle.fill",
            title: "Central Lines",
            color: CriticalDesign.Colors.accentBlue,
            content: [
                ProcedureSection(
                    subtitle: "Catheter Tip Position",
                    points: [
                        "Tip at level of right tracheobronchial angle",
                        "~1-2 cm above the carina",
                        "SVC-RA junction ideal position"
                    ]
                ),
                ProcedureSection(
                    subtitle: "Complications to Check",
                    points: [
                        "Rule out pneumothorax",
                        "Check for mediastinal widening (vessel damage)",
                        "Confirm line follows expected venous course"
                    ]
                )
            ],
            delay: 0.15
        )
    }

    // MARK: - ETT Card
    private var ettCard: some View {
        procedureCard(
            icon: "waveform.path",
            title: "Endotracheal Tubes",
            color: CriticalDesign.Colors.accentPurple,
            content: [
                ProcedureSection(
                    subtitle: "Proper Position",
                    points: [
                        "~3 cm below the vocal cords",
                        "2-4 cm above the carina",
                        "Approximately at the level of the aortic arch",
                        "T2-T4 vertebral level"
                    ]
                )
            ],
            delay: 0.2
        )
    }

    // MARK: - Ventilation Card
    private var ventilationCard: some View {
        procedureCard(
            icon: "wind",
            title: "Ventilation",
            color: CriticalDesign.Colors.accentTeal,
            content: [
                ProcedureSection(
                    subtitle: "Primary Checks",
                    points: [
                        "Rule out pneumothorax",
                        "Check for subcutaneous air",
                        "Look for pneumomediastinum",
                        "Check for subpleural air cysts"
                    ]
                ),
                ProcedureSection(
                    subtitle: "Note",
                    points: [
                        "Lung infiltrates may appear diminished due to increased aeration and positive pressure"
                    ]
                )
            ],
            delay: 0.25
        )
    }

    // MARK: - NG/OG Card
    private var ngOgCard: some View {
        procedureCard(
            icon: "arrow.down.to.line",
            title: "NG / OG Tubes",
            color: CriticalDesign.Colors.accentOrange,
            content: [
                ProcedureSection(
                    subtitle: "Verification",
                    points: [
                        "Confirm tube is in the stomach",
                        "NOT coiled in esophagus",
                        "NOT in trachea (below carina = wrong!)",
                        "Tip should be below diaphragm"
                    ]
                )
            ],
            delay: 0.3
        )
    }

    // MARK: - Trach Card
    private var trachCard: some View {
        procedureCard(
            icon: "circle.hexagongrid.circle.fill",
            title: "Tracheostomy Tubes",
            color: CriticalDesign.Colors.accentGreen,
            content: [
                ProcedureSection(
                    subtitle: "Position",
                    points: [
                        "Halfway between stoma and carina",
                        "~2/3 width of the trachea",
                        "Cuff should NOT bulge tracheal walls"
                    ]
                ),
                ProcedureSection(
                    subtitle: "Complications to Check",
                    points: [
                        "Subcutaneous air in neck",
                        "Widening mediastinum (air leakage)",
                        "Tracheal wall injury"
                    ]
                )
            ],
            delay: 0.35
        )
    }

    // MARK: - Procedure Card Builder
    private func procedureCard(icon: String, title: String, color: Color, content: [ProcedureSection], delay: Double) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)

                Text(title)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            ForEach(content.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
                    Text(content[index].subtitle)
                        .font(.custom("Poppins-SemiBold", size: 13))
                        .foregroundColor(color.opacity(0.9))

                    ForEach(content[index].points, id: \.self) { point in
                        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                            Circle()
                                .fill(color.opacity(0.6))
                                .frame(width: 5, height: 5)
                                .padding(.top, 6)

                            Text(point)
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        }
                    }
                }
                .padding(.leading, CriticalDesign.Spacing.xs)
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(color.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(color.opacity(0.15), lineWidth: 1)
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(delay), value: isAppearing)
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

// MARK: - Helper Struct
private struct ProcedureSection {
    let subtitle: String
    let points: [String]
}

// MARK: - Preview
#Preview {
    ChestXrayPocedureConfirmationView()
}
