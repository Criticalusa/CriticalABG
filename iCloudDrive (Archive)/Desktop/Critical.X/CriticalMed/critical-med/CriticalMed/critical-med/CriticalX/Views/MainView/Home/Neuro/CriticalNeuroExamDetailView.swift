//
//  CriticalNeuroExamDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 29/12/2021.
//  Updated with Design.md styling
//

import SwiftUI

struct CriticalNeuroExamDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false

    // Design.md colors
    private var textPrimary: Color { CriticalDesign.Adaptive.textPrimary(for: colorScheme) }
    private var textSecondary: Color { CriticalDesign.Adaptive.textSecondary(for: colorScheme) }
    private let primaryAccent = CriticalDesign.Colors.accentBlue
    private let dangerRed = CriticalDesign.Colors.accentRed
    private let successGreen = CriticalDesign.Colors.accentGreen

    // LOC states data
    private let locStates: [LOCState] = [
        LOCState(
            name: "Alert & Oriented",
            description: "The patient is awake, looks about, responds in a meaningful manner to verbal stimuli.",
            color: Color(red: 16/255, green: 185/255, blue: 129/255)
        ),
        LOCState(
            name: "Lethargic",
            description: "The patient is sleeping, but responds appropriately and has purposeful movement.",
            color: Color(red: 59/255, green: 130/255, blue: 246/255)
        ),
        LOCState(
            name: "Obtunded",
            description: "The patient will have a sluggish purposeful response, will be inconsistently responsive to voice and have a reduction in spontaneous activity.",
            color: Color(red: 249/255, green: 115/255, blue: 22/255)
        ),
        LOCState(
            name: "Confused",
            description: "The patient will be disoriented to time, place, or person. Usually has difficulty with commands.",
            color: Color(red: 139/255, green: 92/255, blue: 246/255)
        ),
        LOCState(
            name: "Semi-comatose",
            description: "The patient will sometimes respond to verbal stimuli and sometimes doesn't.",
            color: Color(red: 236/255, green: 72/255, blue: 153/255)
        ),
        LOCState(
            name: "Comatose",
            description: "The patient does not respond to painful stimuli at all. The patient also may be flaccid or posturing.",
            color: Color(red: 239/255, green: 68/255, blue: 68/255)
        )
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    headerCard
                    overviewCard
                    abnormalSignsCard
                    locAssessmentCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
    }

    // MARK: - Header Card
    private var headerCard: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [primaryAccent, Color(red: 37/255, green: 99/255, blue: 235/255)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)

                Image(systemName: "stethoscope")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text("Critical ")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(textPrimary)
                    Text("Neuro Exam")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(dangerRed)
                }

                Text("Neurological Assessment")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textSecondary)
            }

            Spacer()
        }
        .padding(16)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                }
            }
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Overview Card
    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(dangerRed)

            VStack(alignment: .leading, spacing: 12) {
                Text("Consciousness is the most sensitive indicator of neurological change and can be defined as a state of general awareness of oneself and the environment.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(textPrimary)
                    .lineSpacing(4)

                Text("Consciousness is also tricky to measure directly but is also measured by observing how the patient responds to specific stimuli.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(textPrimary)
                    .lineSpacing(4)

                Text("When abnormal vital signs are observed in a neurological assessment, it's not known whether the insult will be either reversible or irreversible. Time and a detailed neurological exam will tell the extent of the injury.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(textPrimary)
                    .lineSpacing(4)
            }
        }
        .padding(16)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
                }
            }
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 10)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - Abnormal Signs Card
    private var abnormalSignsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Causes of Abnormal Neuro Signs")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(dangerRed)

            VStack(alignment: .leading, spacing: 12) {
                AbnormalSignRow(number: 1, text: "Hypoxia", color: dangerRed)
                AbnormalSignRow(number: 2, text: "Infection", color: Color(red: 249/255, green: 115/255, blue: 22/255))
                AbnormalSignRow(number: 3, text: "Hyperthermia", color: Color(red: 236/255, green: 72/255, blue: 153/255))
                AbnormalSignRow(number: 4, text: "Electrolyte imbalances", color: primaryAccent)
                AbnormalSignRow(number: 5, text: "Ischemia secondary to clots, vasospasms, trauma or hypotension", color: Color(red: 139/255, green: 92/255, blue: 246/255))
            }
        }
        .padding(16)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
                }
            }
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - LOC Assessment Card
    private var locAssessmentCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Level of Consciousness (LOC)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(dangerRed)

            Text("Assessing the LOC can be done using the Glasgow Coma Scale or from the different states listed below:")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(dangerRed)

            VStack(spacing: 12) {
                ForEach(Array(locStates.enumerated()), id: \.offset) { index, state in
                    LOCStateCard(state: state)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 10)
                        .animation(.easeOut(duration: 0.4).delay(0.2 + Double(index) * 0.04), value: isAppearing)
                }
            }
        }
        .padding(16)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
                }
            }
        )
    }
}

// MARK: - LOC State Model
private struct LOCState {
    let name: String
    let description: String
    let color: Color
}

// MARK: - Abnormal Sign Row
private struct AbnormalSignRow: View {
    let number: Int
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Text("\(number)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Circle().fill(color))

            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

// MARK: - LOC State Card
private struct LOCStateCard: View {
    let state: LOCState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(state.name)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(state.color)

            Text(state.description)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
                .lineSpacing(3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(state.color.opacity(0.08))
        )
        .overlay(
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(state.color)
                    .frame(width: 4)
                Spacer()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        )
    }
}

// MARK: - Preview
#Preview {
    CriticalNeuroExamDetailView()
}
