//
//  SecondDegreeAvDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 26/11/2021.
//  Updated: Premium Light Theme with Glass Cards
//

import SwiftUI

struct SecondDegreeAvDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false

    // Accent color for Type II - more serious, use purple
    // NOTE: Do NOT name this "accentColor" — it shadows SwiftUI's built-in
    // accentColor and causes NavigationLink to push then immediately pop.
    private let brandAccent = CriticalDesign.Colors.cardBlue

    private var pageFill: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.darkCanvas
            : Color(red: 228/255, green: 233/255, blue: 240/255)
    }

    // Critical Pearls content
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "More dangerous than Type I:", content: "Type II has higher risk of progression to complete heart block."),
        CriticalPearlItem(header: "Constant PR is key:", content: "PR interval stays the same during conducted beats—this differentiates from Type I."),
        CriticalPearlItem(header: "Wide QRS = infra-Hisian:", content: "Block is typically below the AV node in the His-Purkinje system."),
        CriticalPearlItem(header: "Pacemaker usually needed:", content: "Permanent pacemaker insertion is almost always warranted."),
        CriticalPearlItem(header: "The takeaway:", content: "Type II = more concerning. Plan for pacing, not just observation.")
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

                    warningCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)

                    quickReferenceCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 50)

                    characteristicsCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 60)

                    treatmentCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 70)

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

            Text("Second Degree Type II")
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("2° TYPE II AV BLOCK")
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
            CardiacDetailWaveformContent(fallbackGifName: "2ndDegreeTypeII2", textSecondary: textSecondary)
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
        .shadow(color: colorScheme == .dark ? .clear : brandAccent.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Warning Card
    private var warningCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 4) {
                Text("HIGH RISK OF PROGRESSION")
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(.white)

                Text("May deteriorate to complete heart block. Pacemaker often required.")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.9))
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 0.75, green: 0.22, blue: 0.27))
        )
        .shadow(color: Color(red: 0.75, green: 0.22, blue: 0.27).opacity(0.3), radius: 8, x: 0, y: 4)
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
                referenceRow(label: "Rate", value: "Usually normal", color: Color(red: 0.2, green: 0.5, blue: 0.9))
                referenceRow(label: "Rhythm", value: "Regular (with dropped beats)", color: brandAccent)
                referenceRow(label: "P-Wave", value: "Present, may be 2:1 or 3:1", color: Color(red: 0.90, green: 0.35, blue: 0.40))
                referenceRow(label: "PR Interval", value: "Constant (key finding)", color: Color(red: 0.58, green: 0.44, blue: 0.86))
                referenceRow(label: "QRS", value: "Often wide (infra-Hisian)", color: CriticalDesign.Colors.accentOrange)
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
        .shadow(color: colorScheme == .dark ? .clear : brandAccent.opacity(0.1), radius: 10, x: 0, y: 4)
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
            2nd° Type II AV block is due to conduction failure below the AV node—typically in the His-Purkinje system. Often deteriorates into complete heart block.

            Key differentiator:
            The PR interval remains constant during conducted beats. Ventricular contractions do not regularly follow atrial contractions. The R-R interval between dropped beats usually remains constant.

            Pathophysiology:
            Most blocks are distal to the Bundle of His, so you'll see broad QRS complexes—often with pre-existing LBBB or bifascicular block. Structural damage from infarction, necrosis, or fibrosis is typical.
            """, headings: ["Definition:", "Key differentiator:", "Pathophysiology:"], isDarkMode: colorScheme == .dark))
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
        .shadow(color: colorScheme == .dark ? .clear : brandAccent.opacity(0.1), radius: 10, x: 0, y: 4)
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
            Definitive:
            Permanent pacemaker insertion is almost always warranted.

            Temporizing measures:
            If atropine is ineffective, IV infusions of Dopamine (2-20 mcg/kg/min) or Epinephrine (2-10 mcg/min) as alternatives.

            Hemodynamically unstable:
            Transcutaneous pacing (TCP) is warranted while awaiting permanent pacemaker.
            """, headings: ["Definitive:", "Temporizing measures:", "Hemodynamically unstable:"], isDarkMode: colorScheme == .dark))
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
        .shadow(color: colorScheme == .dark ? .clear : Color(red: 0.2, green: 0.5, blue: 0.9).opacity(0.08), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

#Preview {
    SecondDegreeAvDetailView()
}
