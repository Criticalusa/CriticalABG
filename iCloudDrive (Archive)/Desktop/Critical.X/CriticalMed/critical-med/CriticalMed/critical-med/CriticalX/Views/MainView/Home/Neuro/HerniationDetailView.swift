//
//  HerniationDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 29/12/2021.
//  Updated with Nano Banana Pro Design System
//

import SwiftUI

struct HerniationDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false

    // Herniation levels data - progression from cortex to brainstem
    private let herniationLevels: [HerniationLevel] = [
        HerniationLevel(
            name: "Cerebral Cortex",
            stage: "Early",
            color: CriticalDesign.Colors.cardBlue,
            loc: "Decreased alertness → semi-coma",
            breathing: "Irregular, Cheyne-Stokes",
            pupils: "May be reactive initially",
            motor: "Contralateral weakness, early posturing",
            whatToWatch: "This is your window. Intervene now."
        ),
        HerniationLevel(
            name: "Midbrain",
            stage: "Progressing",
            color: CriticalDesign.Colors.accentOrange,
            loc: "Comatose",
            breathing: "Central neurogenic hyperventilation",
            pupils: "Midposition, nonreactive",
            motor: "Decorticate → decerebrate posturing",
            whatToWatch: "Pupils fixed midposition = midbrain compression."
        ),
        HerniationLevel(
            name: "Pons",
            stage: "Late",
            color: CriticalDesign.Colors.accentPurple,
            loc: "Deep coma",
            breathing: "Apneustic (long inspiratory pause)",
            pupils: "Pinpoint, nonreactive",
            motor: "Decerebrate → flaccid",
            whatToWatch: "Pinpoint pupils = pontine involvement."
        ),
        HerniationLevel(
            name: "Medulla",
            stage: "Terminal",
            color: CriticalDesign.Colors.accentRed,
            loc: "Unresponsive",
            breathing: "Ataxic → agonal → apnea",
            pupils: "Dilated, fixed",
            motor: "Flaccid",
            whatToWatch: "Without intervention, this is irreversible."
        )
    ]

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

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    headerSection
                    urgencyBanner
                    mentalModelCard
                    progressionCard
                    herniationPatternsSection
                    actionCard
                    clinicalPearlCard
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

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // 3D Icon placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [CriticalDesign.Colors.accentRed, Color(hex: "991B1B")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)

                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.white)
            }

            VStack(spacing: 4) {
                Text("Herniation Syndrome")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text("Recognizing Brainstem Compression")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Urgency Banner
    private var urgencyBanner: some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: "clock.badge.exclamationmark")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(CriticalDesign.Colors.accentRed)

            Text("Herniation is a clinical emergency. Recognition must lead to immediate action.")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Colors.accentRed)
        }
        .padding(CriticalDesign.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(CriticalDesign.Colors.accentRed.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(CriticalDesign.Colors.accentRed.opacity(0.3), lineWidth: 1)
                )
        )
        .opacity(isAppearing ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.05), value: isAppearing)
    }

    // MARK: - Mental Model Card
    private var mentalModelCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "brain")
                    .font(.system(size: 18))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)

                Text("The Mental Model")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("The skull is a fixed box. When pressure builds inside, the brain has nowhere to go except down—through the tentorium and eventually out the foramen magnum.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineSpacing(6)

            Text("As the brain herniates, it compresses structures in a predictable sequence: cortex → midbrain → pons → medulla. Each level produces a distinct clinical picture.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 10)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - Progression Card
    private var progressionCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            Text("What You'll See")
                .font(.custom("Poppins-Bold", size: 18))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                ProgressionRow(number: "1", text: "Decreasing level of consciousness", color: CriticalDesign.Colors.cardBlue)
                ProgressionRow(number: "2", text: "Pupil changes (unilateral → bilateral)", color: CriticalDesign.Colors.accentOrange)
                ProgressionRow(number: "3", text: "Posturing (decorticate → decerebrate → flaccid)", color: CriticalDesign.Colors.accentPurple)
                ProgressionRow(number: "4", text: "Breathing pattern changes", color: CriticalDesign.Colors.accentRed)
                ProgressionRow(number: "5", text: "Vital sign instability (Cushing's triad)", color: Color(hex: "991B1B"))
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 10)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - Herniation Patterns Section
    private var herniationPatternsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            Text("Progression by Level")
                .font(.custom("Poppins-Bold", size: 20))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text("As herniation progresses, the exam findings change predictably")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))

            VStack(spacing: CriticalDesign.Spacing.md) {
                ForEach(Array(herniationLevels.enumerated()), id: \.offset) { index, level in
                    HerniationLevelCard(level: level)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 15)
                        .animation(.easeOut(duration: 0.4).delay(0.2 + Double(index) * 0.05), value: isAppearing)
                }
            }
        }
    }

    // MARK: - Action Card
    private var actionCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 18))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                Text("What To Do")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                ActionRow(text: "Elevate head of bed 30°")
                ActionRow(text: "Ensure adequate oxygenation and ventilation")
                ActionRow(text: "Avoid hypotension (MAP > 80)")
                ActionRow(text: "Hyperosmolar therapy (mannitol or hypertonic saline)")
                ActionRow(text: "Emergent neurosurgical consultation")
                ActionRow(text: "Consider emergent decompression")
            }

            Text("Speed matters. Every minute of herniation causes more irreversible damage.")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Colors.accentRed)
                .padding(.top, 4)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.4), value: isAppearing)
    }

    // MARK: - Clinical Pearl Card
    private var clinicalPearlCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)

                Text("Clinical Takeaway")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(.white)
            }

            Text("A blown pupil in a deteriorating patient is herniation until proven otherwise. Don't wait for imaging to start treatment—intervene first, then get the CT.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .signatureCard(cornerRadius: 16, strokeWidth: 1.5)
        .opacity(isAppearing ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.45), value: isAppearing)
    }
}

// MARK: - Herniation Level Model
private struct HerniationLevel {
    let name: String
    let stage: String
    let color: Color
    let loc: String
    let breathing: String
    let pupils: String
    let motor: String
    let whatToWatch: String
}

// MARK: - Progression Row
private struct ProgressionRow: View {
    @Environment(\.colorScheme) var colorScheme
    let number: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Text(number)
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(color))

            Text(text)
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
    }
}

// MARK: - Action Row
private struct ActionRow: View {
    @Environment(\.colorScheme) var colorScheme
    let text: String

    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(CriticalDesign.Colors.accentGreen)

            Text(text)
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
    }
}

// MARK: - Herniation Level Card
private struct HerniationLevelCard: View {
    @Environment(\.colorScheme) var colorScheme
    let level: HerniationLevel

    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            // Level Header
            HStack {
                Text(level.name)
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(level.color)

                Spacer()

                Text(level.stage)
                    .font(.custom("Poppins-SemiBold", size: 12))
                    .foregroundColor(level.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(level.color.opacity(0.15))
                    )
            }

            // Details Grid
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
                HerniationDetailRow(label: "LOC", value: level.loc, color: level.color)
                HerniationDetailRow(label: "Breathing", value: level.breathing, color: level.color)
                HerniationDetailRow(label: "Pupils", value: level.pupils, color: level.color)
                HerniationDetailRow(label: "Motor", value: level.motor, color: level.color)
            }

            // Clinical note
            HStack(spacing: 6) {
                Image(systemName: "hand.point.right.fill")
                    .font(.system(size: 10))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                Text(level.whatToWatch)
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .italic()
            }
            .padding(.top, 4)
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
        .overlay(
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(level.color)
                    .frame(width: 4)
                Spacer()
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        )
    }
}

// MARK: - Detail Row
private struct HerniationDetailRow: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Text(label)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(color)
                .frame(width: 70, alignment: .leading)

            Text(value)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineLimit(2)
        }
    }
}

// MARK: - Preview
#Preview {
    HerniationDetailView()
}
