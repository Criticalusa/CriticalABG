//
//  AtrialFlutterDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 26/11/2021.
//  Updated: Premium Light Theme with Glass Cards
//  Updated: 2025 AHA Guidelines + AI Explanations
//

import SwiftUI

struct AtrialFlutterDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false
    
    // AI Explanation context
    private let rhythmContext = """
    Atrial Flutter - 2025 AHA Guidelines:
    • Synchronized cardioversion ≥200J
    • Sedate "whenever feasible" (updated language)
    • Avoid CCBs in reduced EF or systolic heart failure
    • Cardioversion now has its own dedicated algorithm
    • WPW: Avoid AV nodal blockers
    """

    // Accent color for atrial rhythms (purple/violet)
    // NOTE: Do NOT name this "accentColor" — it shadows SwiftUI's built-in
    // accentColor and causes NavigationLink to push then immediately pop.
    private let brandAccent = CriticalDesign.Colors.cardBlue

    private var pageFill: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.darkCanvas
            : Color(red: 228/255, green: 233/255, blue: 240/255)
    }

    // Critical Pearls content - Updated for 2025 AHA Guidelines
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Saw-tooth pattern:", content: "Flutter waves at ~300 bpm with regular ventricular response is the hallmark finding."),
        CriticalPearlItem(header: "Common ratios:", content: "2:1 block = ~150 bpm, 3:1 = ~100 bpm, 4:1 = ~75 bpm ventricular rate."),
        CriticalPearlItem(header: "Stable = rate control:", content: "Consider CCBs or BBs. 2025: Avoid CCBs in reduced EF or systolic heart failure."),
        CriticalPearlItem(header: "Unstable (2025):", content: "Synchronized cardioversion ≥200J. Sedate whenever feasible. Cardioversion has own algorithm."),
        CriticalPearlItem(header: "WPW changes everything:", content: "Avoid AV nodal blockers (digoxin, CCBs, BBs, IV amiodarone) in preexcitation."),
        CriticalPearlItem(header: "The takeaway:", content: "Look for the saw-tooth pattern. Stability determines treatment approach.")
    ]

    // Text colors
    private var textPrimary: Color { CriticalDesign.Adaptive.textPrimary(for: colorScheme) }
    private var textSecondary: Color { CriticalDesign.Adaptive.textSecondary(for: colorScheme) }

    var body: some View {
        ZStack {
            // Bottom half: light gray
            pageFill
                .ignoresSafeArea()

            // Top half: gradient center color fills safe area + top portion
            VStack(spacing: 0) {
                Rectangle()
                    .fill(CriticalDesign.Colors.ekgDetailRadialGradient)
                pageFill
            }
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    VStack(spacing: 20) {
                        // MARK: - Title Section
                        headerSection
                            .opacity(isAppearing ? 1 : 0)
                            .offset(y: isAppearing ? 0 : 20)

                        // MARK: - EKG Animation Card
                        ekgAnimationCard
                            .opacity(isAppearing ? 1 : 0)
                            .offset(y: isAppearing ? 0 : 30)
                    }
                    .padding(.bottom, 24)
                    .background(
                        ZStack {
                            CriticalDesign.Colors.ekgDetailRadialGradient
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 32,
                                bottomTrailingRadius: 32,
                                topTrailingRadius: 0,
                                style: .continuous
                            )
                            .fill(.clear)
                        }
                        .compositingGroup()
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 32,
                                bottomTrailingRadius: 32,
                                topTrailingRadius: 0,
                                style: .continuous
                            )
                        )
                        .ignoresSafeArea(edges: .top)
                    )

                    // MARK: - Quick Reference Card
                    quickReferenceCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)

                    // MARK: - Characteristics Card
                    characteristicsCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 50)

                    // MARK: - Treatment Card
                    treatmentCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 60)
                    
                    // AI Explanation Button
                    aiExplainSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 65)

                    // MARK: - Clinical Takeaway
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 70)

                    Spacer(minLength: 60)
                }
                .padding(.top, 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image("GoldLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)

            Text("Atrial Flutter")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Category badge
            Text("ATRIAL DYSRHYTHMIA")
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(CriticalDesign.Colors.gold)
                .tracking(2)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(brandAccent.opacity(0.12))
                )
        }
        .padding(.bottom, 8)
    }

    // MARK: - EKG Animation Card
    private var ekgAnimationCard: some View {
        VStack(spacing: 12) {
            CardiacDetailWaveformContent(fallbackGifName: "Aflutter", textSecondary: textSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? Color.white.opacity(0.08)
                        : brandAccent.opacity(0.25),
                    lineWidth: 1
                )
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    // MARK: - Quick Reference Card
    private var quickReferenceCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(brandAccent)

                Text("Quick Reference")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textPrimary)
            }

            VStack(spacing: 12) {
                referenceRow(label: "Rate", value: "~110 bpm (ventricular)", color: Color(red: 0.2, green: 0.5, blue: 0.9))
                referenceRow(label: "Rhythm", value: "Regular", color: brandAccent)
                referenceRow(label: "P-Wave", value: "Saw-tooth pattern, 300/min", color: Color(red: 0.90, green: 0.35, blue: 0.40))
                referenceRow(label: "PR Interval", value: "Not measurable", color: Color(red: 0.58, green: 0.44, blue: 0.86))
                referenceRow(label: "QRS", value: "Prolonged", color: CriticalDesign.Colors.accentOrange)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [brandAccent.opacity(0.08), Color.white.opacity(0.3), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? Color.white.opacity(0.08)
                        : brandAccent.opacity(0.25),
                    lineWidth: 1
                )
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    private func referenceRow(label: String, value: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            Text(label)
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(textPrimary)
                .frame(width: 90, alignment: .leading)

            Text(value)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(textSecondary)

            Spacer()
        }
    }

    // MARK: - Characteristics Card
    private var characteristicsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [brandAccent, brandAccent.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: brandAccent.opacity(0.3), radius: 4, y: 2)

                Text("Characteristics")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)

            Text(ContentFormatter.format("""
            Mechanism:
            Atrial flutter is a type of supraventricular tachycardia usually caused by a reentry circuit in the right atrium. These reentry circuits can be anti-clockwise (~90% of cases) or clockwise (less common).

            Atrial rate:
            The reentry circuit corresponds to the size of the right atrium, resulting in an atrial rate around 300 bpm.

            Ventricular response:
            The average ventricular rate is approximately 150 bpm with 2:1 AV conduction. Other ratios: 3:1 block ~100 bpm; 4:1 block ~75 bpm.

            Classic finding:
            The "saw-tooth" pattern of flutter waves is the hallmark EKG finding, best seen in the inferior leads (II, III, aVF).
            """, headings: ["Mechanism:", "Atrial rate:", "Ventricular response:", "Classic finding:"], isDarkMode: colorScheme == .dark))
                .lineSpacing(6)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [brandAccent.opacity(0.1), Color.white.opacity(0.3), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? Color.white.opacity(0.08)
                        : brandAccent.opacity(0.25),
                    lineWidth: 1
                )
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    // MARK: - Treatment Card
    private var treatmentCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))

                Text("Treatment")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textPrimary)
            }

            Text(ContentFormatter.format("""
            Stable patient:
            Consider Calcium Channel Blockers or Beta Blockers for rate control. 2025: Avoid CCBs in reduced EF or systolic HF.

            Unstable patient (2025):
            Synchronized cardioversion ≥200J. Sedate whenever feasible (changed from "consider sedation"). If energy unknown → max settings.

            Preexcitation (WPW):
            Avoid cardioversion—use antiarrhythmics instead. Avoid digoxin, CCBs, BBs, and IV amiodarone in preexcitation.

            2025 Updates:
            • Cardioversion now has its own dedicated algorithm
            • Double synchronized cardioversion has uncertain usefulness
            """, headings: ["Stable patient:", "Unstable patient (2025):", "Preexcitation (WPW):", "2025 Updates:"], isDarkMode: colorScheme == .dark))
                .lineSpacing(6)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(red: 0.2, green: 0.5, blue: 0.9).opacity(0.06))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? Color.white.opacity(0.08)
                        : Color(red: 0.2, green: 0.5, blue: 0.9).opacity(0.25),
                    lineWidth: 1
                )
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    // MARK: - AI Explanation Section
    private var aiExplainSection: some View {
        VStack(spacing: 12) {
            ExplainButton(
                topic: "Atrial Flutter",
                result: "Atrial Dysrhythmia - 2025 Guidelines",
                context: rhythmContext,
                screenName: "AFlutter Detail",
                style: .prominent,
                buttonText: "Explain Flutter Management"
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    AtrialFlutterDetailView()
}
