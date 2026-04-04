//
//  ArtialFibrillationDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 26/11/2021.
//  Updated: Premium Light Theme with Glass Cards
//  Updated: 2025 AHA Guidelines + AI Explanations
//

import SwiftUI

struct ArtialFibrillationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false
    
    // AI Explanation context
    private let rhythmContext = """
    Atrial Fibrillation - 2025 AHA Guidelines:
    • Synchronized cardioversion ≥200J (increased from 50J)
    • Sedate "whenever feasible" (updated language)
    • Avoid CCBs in reduced EF or systolic heart failure
    • Cardioversion now has its own dedicated algorithm
    • Double synchronized cardioversion has uncertain usefulness
    • WPW: Avoid AV nodal blockers (digoxin, CCBs, BBs, IV amiodarone)
    """

    // Accent color - consistent with app branding (cardBlue)
    // NOTE: Do NOT name this "accentColor" — it shadows SwiftUI's built-in
    // accentColor and causes NavigationLink to push then immediately pop.
    private let brandAccent = CriticalDesign.Colors.cardBlue

    private var pageFill: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.darkCanvas
            : Color(red: 228/255, green: 233/255, blue: 240/255)
    }

    // Adaptive text colors
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

                    criticalPearlsCard
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

            Text("Atrial Fibrillation")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

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
            CardiacDetailWaveformContent(fallbackGifName: "AtrialFib", textSecondary: textSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.gold.opacity(0.05))
                    }
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
                        ? LinearGradient(colors: [CriticalDesign.Colors.gold.opacity(0.4), CriticalDesign.Colors.gold.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [brandAccent.opacity(0.3), Color.white.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: brandAccent.opacity(0.1), radius: 10, x: 0, y: 4)
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
                referenceRow(label: "Rate", value: "100 - 160 bpm (variable)", color: Color(red: 0.2, green: 0.5, blue: 0.9))
                referenceRow(label: "Rhythm", value: "Irregularly irregular", color: brandAccent)
                referenceRow(label: "P-Wave", value: "None—fibrillatory/chaotic", color: Color(red: 0.90, green: 0.35, blue: 0.40))
                referenceRow(label: "PR Interval", value: "Not measurable", color: Color(red: 0.58, green: 0.44, blue: 0.86))
                referenceRow(label: "QRS", value: "Usually normal (narrow)", color: CriticalDesign.Colors.accentOrange)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [CriticalDesign.Colors.gold.opacity(0.1), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
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
                        ? LinearGradient(colors: [CriticalDesign.Colors.gold.opacity(0.4), CriticalDesign.Colors.gold.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [brandAccent.opacity(0.4), Color.white.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: brandAccent.opacity(0.1), radius: 10, x: 0, y: 4)
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
            Atrial fibrillation is the most common sustained arrhythmia, characterized by disorganized atrial electrical activity and contraction.

            Classic findings:
            • Irregularly irregular ventricular response
            • No discernible P-waves
            • Absence of an isoelectric baseline
            • Fibrillatory waves may mimic P-waves (can cause misdiagnosis)

            Key point:
            The hallmark is the absence of organized atrial activity with an irregularly irregular R-R interval.
            """, headings: ["Definition:", "Classic findings:", "Key point:"], isDarkMode: colorScheme == .dark))
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

            Text("Ischemic heart disease, digoxin toxicity, mitral and tricuspid valve disease, pulmonary embolism, hyperthyroidism, hypertension, alcohol use, post-cardiac surgery.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(textSecondary)
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
                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))

                Text("Treatment")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textPrimary)
            }

            Text(ContentFormatter.format("""
            Stable patient:
            Consider Calcium Channel Blockers or Beta Blockers for rate control. 2025: Avoid CCBs in reduced EF or systolic HF.

            Unstable patient (2025):
            Synchronized cardioversion ≥200J biphasic. Sedate whenever feasible (changed from "consider sedation"). If energy unknown → max settings.

            Preexcitation (WPW):
            Avoid cardioversion—use antiarrhythmics. Avoid digoxin, CCBs, BBs, and IV amiodarone.

            2025 Updates:
            • Cardioversion now has its own dedicated algorithm
            • Double synchronized cardioversion has uncertain usefulness
            • AFib/flutter cardioversion energy: ≥200J (increased from 50J)
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
                topic: "Atrial Fibrillation",
                result: "Atrial Dysrhythmia - 2025 Guidelines",
                context: rhythmContext,
                screenName: "AFib Detail",
                style: .prominent,
                buttonText: "Explain AFib Management"
            )
            
            ExplainButton(
                topic: "Cardioversion Energy Change",
                result: "≥200J (was 50J)",
                context: "2025: Synchronized cardioversion for atrial fibrillation is now ≥200J biphasic, significantly increased from the previous 50J recommendation.",
                screenName: "AFib Detail",
                style: .inline,
                buttonText: "Why 200J now?"
            )
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Critical Pearls Card (Two-Tone)
    private var criticalPearlsCard: some View {
        let gold = Color(red: 0.96, green: 0.71, blue: 0.0)

        let pearlItems: [StepperItem] = [
            StepperItem(
                header: "The classic finding:",
                content: "'Irregularly irregular' rhythm with no discernible P-waves is the hallmark of AFib."
            ),
            StepperItem(
                header: "Rate vs rhythm control:",
                content: "Decision depends on stability, duration, and patient factors. Stable patients get rate control first."
            ),
            StepperItem(
                header: "Watch for WPW:",
                content: "AV nodal blockers (digoxin, CCBs, BBs, IV amiodarone) are contraindicated—can trigger VFib."
            ),
            StepperItem(
                header: "Cardioversion timing:",
                content: "If AFib >48 hours or unknown duration, anticoagulate or TEE before cardioversion to reduce stroke risk."
            ),
            StepperItem(
                header: "The takeaway:",
                content: "AFib is the most common sustained arrhythmia. Identify, rate control, and always rule out WPW before AV nodal blockers."
            )
        ]

        let displayItems = showAllPearls ? pearlItems : Array(pearlItems.prefix(3))
        let hasMore = pearlItems.count > 3

        return VStack(spacing: 0) {
            // MARK: Top Section - Navy Header
            HStack(spacing: 12) {
                // Gold logo container
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    gold.opacity(0.25),
                                    gold.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)

                    Image("welcomeLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Critical Pearls")
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundColor(.white)

                    Text("\(pearlItems.count) key points")
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(gold)
                }

                Spacer()

                // Expand/Collapse button
                if hasMore {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showAllPearls.toggle()
                        }
                    }) {
                        Image(systemName: showAllPearls ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            .padding(20)
            .background(brandAccent)

            // MARK: Bottom Section - White Content
            VStack(alignment: .leading, spacing: 12) {
                AFibPearlsStepper(items: displayItems)

                // See More indicator
                if hasMore && !showAllPearls {
                    HStack {
                        Spacer()
                        Text("+\(pearlItems.count - 3) more")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(textSecondary)
                        Spacer()
                    }
                    .padding(.top, 4)
                }
            }
            .padding(20)
            .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [gold, gold.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: brandAccent.opacity(0.2), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 16)
    }
}

// MARK: - AFib Pearls Stepper (Light Theme)
private struct AFibPearlsStepper: View {
    let items: [StepperItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                AFibPearlsStepperRow(
                    item: item,
                    isLast: index == items.count - 1,
                    index: index
                )
            }
        }
    }
}

// MARK: - AFib Pearls Stepper Row
private struct AFibPearlsStepperRow: View {
    @Environment(\.colorScheme) var colorScheme
    let item: StepperItem
    let isLast: Bool
    let index: Int

    @State private var isFilled: Bool = false
    @State private var hasAppeared: Bool = false
    @State private var contentOpacity: Double = 0.0
    @State private var contentOffset: CGFloat = 10

    private let dotSize: CGFloat = 10
    private let lineWidth: CGFloat = 2
    private let navyColor = CriticalDesign.Colors.cardBlue

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Left rail with dot and line
            ZStack(alignment: .top) {
                // Connecting line
                if !isLast {
                    Rectangle()
                        .fill(isFilled ? navyColor.opacity(0.3) : navyColor.opacity(0.15))
                        .frame(width: lineWidth)
                        .padding(.top, dotSize / 2)
                }

                // Dot
                VStack {
                    ZStack {
                        // Glow when filled
                        if isFilled {
                            Circle()
                                .fill(navyColor.opacity(0.2))
                                .frame(width: dotSize * 1.8, height: dotSize * 1.8)
                                .blur(radius: 3)
                        }

                        Circle()
                            .fill(isFilled ? navyColor : Color.clear)
                            .overlay(
                                Circle()
                                    .stroke(isFilled ? navyColor : navyColor.opacity(0.3), lineWidth: 1.5)
                            )
                            .frame(width: dotSize, height: dotSize)
                    }

                    Spacer(minLength: 0)
                }
            }
            .frame(width: 20)

            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(item.header)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(navyColor)

                if !item.content.isEmpty {
                    Text(item.content)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .lineSpacing(4)
                }
            }
            .padding(.bottom, isLast ? 0 : 16)
            .opacity(contentOpacity)
            .offset(x: contentOffset)
        }
        .onAppear {
            if !hasAppeared {
                hasAppeared = true
                let delay = Double(index) * 0.12

                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        isFilled = true
                    }
                    withAnimation(.easeOut(duration: 0.4).delay(0.1)) {
                        contentOpacity = 1.0
                        contentOffset = 0
                    }
                }
            }
        }
    }
}

#Preview {
    ArtialFibrillationDetailView()
}
