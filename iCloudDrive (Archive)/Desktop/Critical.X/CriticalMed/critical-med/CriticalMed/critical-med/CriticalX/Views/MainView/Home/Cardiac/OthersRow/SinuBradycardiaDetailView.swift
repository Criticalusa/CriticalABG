//
//  SinuBradycardiaDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 26/11/2021.
//  Updated: Premium Light Theme with Glass Cards
//  Updated: 2025 AHA Guidelines + AI Explanations
//

import SwiftUI

struct SinuBradycardiaDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false
    
    // AI Explanation context
    private let rhythmContext = """
    Bradycardia - 2025 AHA Guidelines:
    • Assess cardiopulmonary compromise FIRST
    • Signs: hypotension, altered mental status, shock, ischemic chest pain, acute HF
    • Treat compromise BEFORE underlying cause
    • IV access now assumed in algorithm
    • Atropine 1 mg IV first-line
    • Dopamine 2-20 mcg/kg/min or Epinephrine 2-10 mcg/min as alternatives
    • TCP for hemodynamic instability
    """

    // Accent color for bradycardias (cool blue)
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
        CriticalPearlItem(header: "Assess compromise FIRST (2025):", content: "Check: hypotension, altered mental status, shock, ischemic chest pain, acute heart failure."),
        CriticalPearlItem(header: "Normal in athletes:", content: "Sinus bradycardia in well-conditioned individuals is physiologic—don't treat the monitor."),
        CriticalPearlItem(header: "Treat compromise first (2025):", content: "Address cardiopulmonary compromise BEFORE underlying cause. IV access now assumed."),
        CriticalPearlItem(header: "Atropine first:", content: "1 mg IV, repeat every 3-5 min up to 3 mg total. If ineffective, move to chronotropes or pacing."),
        CriticalPearlItem(header: "Chronotropes (2025):", content: "Dopamine 2-20 mcg/kg/min OR Epinephrine 2-10 mcg/min—equally effective alternatives."),
        CriticalPearlItem(header: "The takeaway:", content: "Treat the patient, not the rhythm. Assess compromise first, then treat systematically.")
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
                        headerSection
                            .opacity(isAppearing ? 1 : 0)
                            .offset(y: isAppearing ? 0 : 20)

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

                    quickReferenceCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)

                    characteristicsCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 50)

                    etiologyCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 60)

                    treatmentCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 70)
                    
                    // AI Explanation Button
                    aiExplainSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 75)

                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 80)

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

            Text("Sinus Bradycardia")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("BRADYCARDIA")
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
            CardiacDetailWaveformContent(fallbackGifName: "SinusBradycardia", textSecondary: textSecondary)
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
                referenceRow(label: "Rate", value: "< 60 bpm", color: Color(red: 0.2, green: 0.5, blue: 0.9))
                referenceRow(label: "Rhythm", value: "Regular", color: Color(red: 0.58, green: 0.44, blue: 0.86))
                referenceRow(label: "P-Wave", value: "Visible, precedes every QRS", color: Color(red: 0.90, green: 0.35, blue: 0.40))
                referenceRow(label: "PR Interval", value: "Slightly prolonged", color: Color(red: 0.58, green: 0.44, blue: 0.86))
                referenceRow(label: "QRS", value: "Normal, 1:1 ratio", color: CriticalDesign.Colors.accentOrange)
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
            Definition:
            Sinus Bradycardia is characterized by a ventricular rate less than 60 bpm while at rest. The impulse originates from the SA node with normal conduction.

            Normal variant:
            Athletes, the elderly, and well-conditioned individuals often exhibit physiologic bradycardia. If asymptomatic without cardiac disease, this is considered normal.

            Differential:
            At times, sinus bradycardia may be indistinguishable from 2nd° type II AV blocks—look carefully at the PR interval consistency.
            """, headings: ["Definition:", "Normal variant:", "Differential:"], isDarkMode: colorScheme == .dark))
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

    // MARK: - Etiology Card
    private var etiologyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentOrange)

                Text("Common Causes")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textPrimary)
            }

            Text(ContentFormatter.format("""
            Intrinsic:
            Sick Sinus Syndrome, increased vagal tone, AMI (especially inferior), increased ICP.

            Extrinsic:
            Hypothermia, hypothyroidism, hypoxia, electrolyte abnormalities.

            Medications:
            Beta blockers, Calcium channel blockers, Amiodarone, Opiates, Benzodiazepines.
            """, headings: ["Intrinsic:", "Extrinsic:", "Medications:"], isDarkMode: colorScheme == .dark))
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
                            .fill(CriticalDesign.Colors.accentOrange.opacity(0.06))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? Color.white.opacity(0.08)
                        : CriticalDesign.Colors.accentOrange.opacity(0.25),
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
                    .foregroundColor(brandAccent)

                Text("Treatment")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textPrimary)
            }

            Text(ContentFormatter.format("""
            Step 1 - Assess Compromise (2025):
            Check: hypotension, altered mental status, shock, ischemic chest discomfort, acute heart failure. Treat compromise BEFORE underlying cause.

            Asymptomatic:
            Rarely requires treatment. Monitor and address reversible causes.

            Symptomatic:
            Atropine 1 mg IV (first-line). May repeat every 3-5 minutes, max 3 mg. IV access now assumed in algorithm.

            Atropine ineffective:
            IV Dopamine (2-20 mcg/kg/min) or Epinephrine (2-10 mcg/min)—equally effective alternatives.

            Hemodynamically unstable:
            Transcutaneous pacing (TCP) is warranted. If refractory, consider temporary transvenous pacing (2025).
            """, headings: ["Step 1 - Assess Compromise (2025):", "Asymptomatic:", "Symptomatic:", "Atropine ineffective:", "Hemodynamically unstable:"], isDarkMode: colorScheme == .dark))
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
                            .fill(brandAccent.opacity(0.06))
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

    // MARK: - AI Explanation Section
    private var aiExplainSection: some View {
        VStack(spacing: 12) {
            ExplainButton(
                topic: "Bradycardia",
                result: "2025 Guidelines - Assess Compromise First",
                context: rhythmContext,
                screenName: "Bradycardia Detail",
                style: .prominent,
                buttonText: "Explain Bradycardia Management"
            )
            
            ExplainButton(
                topic: "2025 Algorithm Change",
                result: "Compromise assessment now prioritized",
                context: "2025: Cardiopulmonary compromise (hypotension, altered mental status, shock, ischemic chest pain, acute HF) is now assessed FIRST. IV access is assumed. Treatment prioritizes addressing compromise before the underlying cause.",
                screenName: "Bradycardia Detail",
                style: .inline,
                buttonText: "What changed in 2025?"
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SinuBradycardiaDetailView()
}
