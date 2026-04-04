//
//  CriticalEKGRowDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 26/11/2021.
//  Updated: Premium Light Theme with Glass Cards
//

import SwiftUI

struct CriticalEKGRowDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false

    // Brand accent — adaptive for dark/light
    // NOTE: Do NOT name this "accentColor" — it shadows SwiftUI's built-in
    // accentColor and causes NavigationLink to push then immediately pop.
    private var brandAccent: Color {
        colorScheme == .dark ? CriticalDesign.Colors.accentBlue : CriticalDesign.Colors.cardBlue
    }

    // Critical Pearls content
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "The gold standard:", content: "NSR is your baseline—know it well to recognize when something is wrong."),
        CriticalPearlItem(header: "Rate 60-100 bpm:", content: "Regular rhythm, narrow QRS, P-wave before every QRS, consistent PR interval."),
        CriticalPearlItem(header: "Sinus arrhythmia:", content: "Slight rate variation with respiration is normal, especially in young healthy patients."),
        CriticalPearlItem(header: "No treatment needed:", content: "NSR is completely normal physiology. Continue monitoring as indicated."),
        CriticalPearlItem(header: "The takeaway:", content: "Master NSR recognition—it's the foundation for identifying all other rhythms.")
    ]

    // Text colors
    private var textPrimary: Color { CriticalDesign.Adaptive.textPrimary(for: colorScheme) }
    private var textSecondary: Color { CriticalDesign.Adaptive.textSecondary(for: colorScheme) }

    // Adaptive background
    private var pageFill: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.darkCanvas
            : Color(red: 228/255, green: 233/255, blue: 240/255) // #E4E9F0
    }

    // Adaptive card surface
    private var cardFill: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.cardBlue
            : .white
    }
    private var cardBorder: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.08)
            : brandAccent.opacity(0.25)
    }

    var body: some View {
        ZStack {
            // Bottom half
            pageFill
                .ignoresSafeArea()

            // Top half: radial gradient for dark header area
            VStack(spacing: 0) {
                Rectangle()
                    .fill(CriticalDesign.Colors.ekgDetailRadialGradient)
                pageFill
            }
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: - Dark Top Section (logo area + EKG strip)
                    VStack(spacing: 20) {
                        // Title Section
                        headerSection
                            .opacity(isAppearing ? 1 : 0)
                            .offset(y: isAppearing ? 0 : 20)

                        // EKG Animation Card
                        ekgAnimationCard
                            .opacity(isAppearing ? 1 : 0)
                            .offset(y: isAppearing ? 0 : 30)
                    }
                    .padding(.bottom, 24)
                    .background(
                        ZStack {
                            // Radial gradient fills the top section
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

                    // MARK: - Clinical Significance Card
                    clinicalSignificanceCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 60)

                    // MARK: - Treatment Card
                    treatmentCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 70)

                    // MARK: - Clinical Takeaway
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 80)

                    Spacer(minLength: 60)
                }
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
            // Logo Monogram
            Image("GoldLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)

            Text("Normal Sinus Rhythm")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Category badge
            Text("SINUS RHYTHM")
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
            CardiacDetailWaveformContent(fallbackGifName: "NormalSinus", textSecondary: textSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cardFill)
                .shadow(
                    color: colorScheme == .dark ? .black.opacity(0.25) : .black.opacity(0.08),
                    radius: colorScheme == .dark ? 8 : 20,
                    x: 0, y: 10
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(cardBorder, lineWidth: 1)
        )
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
                referenceRow(label: "Rate", value: "60 - 100 bpm", color: Color(red: 0.36, green: 0.55, blue: 0.94))
                referenceRow(label: "Rhythm", value: "Regular", color: brandAccent)
                referenceRow(label: "P-Wave", value: "Visible, precedes every QRS", color: Color(red: 0.90, green: 0.35, blue: 0.40))
                referenceRow(label: "PR Interval", value: "0.12 - 0.20 sec (Normal)", color: Color(red: 0.58, green: 0.44, blue: 0.86))
                referenceRow(label: "QRS", value: "< 0.12 sec (Normal)", color: CriticalDesign.Colors.accentOrange)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cardFill)
                .shadow(
                    color: colorScheme == .dark ? .black.opacity(0.25) : .black.opacity(0.08),
                    radius: colorScheme == .dark ? 8 : 20,
                    x: 0, y: 10
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(cardBorder, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    private func referenceRow(label: String, value: String, color: Color) -> some View {
        HStack {
            // Color indicator
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
            // Header
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

            // Content
            Text(ContentFormatter.format("""
            Definition:
            Normal Sinus Rhythm (NSR) is the default heart rhythm representing normal cardiac electrical activity with a ventricular rate between 60-100 bpm.

            Electrical pathway:
            Impulses originate from the sino-atrial (SA) node and travel through the AV node and His-Purkinje system, producing a regular narrow-complex rhythm.

            Key features:
            • All complexes evenly spaced
            • Each P-wave followed by a QRS complex
            • Consistent PR interval throughout
            • Narrow QRS complexes (< 0.12 sec)

            Sinus arrhythmia:
            When there is slight irregularity in the rate (often with respiration), it's termed "sinus arrhythmia" - this is typically benign.
            """, headings: ["Definition:", "Electrical pathway:", "Key features:", "Sinus arrhythmia:"], isDarkMode: colorScheme == .dark))
                .lineSpacing(6)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cardFill)
                .shadow(
                    color: colorScheme == .dark ? .black.opacity(0.25) : .black.opacity(0.08),
                    radius: colorScheme == .dark ? 8 : 20,
                    x: 0, y: 10
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(cardBorder, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    // MARK: - Clinical Significance Card
    private var clinicalSignificanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "stethoscope")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.36, green: 0.55, blue: 0.94))

                Text("Clinical Significance")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textPrimary)
            }

            Text("NSR represents normal cardiac function. Heart rate naturally varies throughout the day - increasing with exertion, stress, or fever, and returning to baseline with rest. Athletes may have resting rates below 60 bpm (sinus bradycardia) which is physiologically normal.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(textSecondary)
                .lineSpacing(6)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cardFill)
                .shadow(
                    color: colorScheme == .dark ? .black.opacity(0.25) : .black.opacity(0.08),
                    radius: colorScheme == .dark ? 8 : 20,
                    x: 0, y: 10
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(cardBorder, lineWidth: 1)
        )
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

            Text("NSR is a completely normal physiological rhythm.")
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(brandAccent)

            Text("No treatment or medications required. Continue to monitor as clinically indicated.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(textSecondary)
                .lineSpacing(6)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cardFill)
                .shadow(
                    color: colorScheme == .dark ? .black.opacity(0.25) : .black.opacity(0.08),
                    radius: colorScheme == .dark ? 8 : 20,
                    x: 0, y: 10
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(cardBorder, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    CriticalEKGRowDetailView()
}
