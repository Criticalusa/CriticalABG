//
//  VentriculartachycardiaDetailView.swift
//  CriticalX
//
//  Created by Macbook 4 on 26/11/2021.
//  Updated: Premium Light Theme with Glass Cards
//  Updated: 2025 AHA Guidelines + AI Explanations
//

import SwiftUI

struct VentriculartachycardiaDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showAllPearls = false
    
    // AI Explanation context
    private let rhythmContext = """
    Ventricular Tachycardia (VT) - 2025 AHA Guidelines:
    • Monomorphic VT with pulse: Amiodarone 150mg or sync cardioversion 100J
    • Polymorphic VT: Treat as VF—unsynchronized defibrillation ≥200J
    • Pulseless VT: Defibrillation ≥200J preferred
    • Sotalol REMOVED from algorithm
    • Sedate "whenever feasible" (updated language)
    • Adenosine may be considered diagnostically for stable WCT
    """

    // Accent color for wide complex tachycardias - warning orange/red
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
        CriticalPearlItem(header: "When in doubt:", content: "Treat wide complex tachycardia as VT. It's VT until proven otherwise."),
        CriticalPearlItem(header: "Brugada Criteria:", content: "Use to differentiate VT from SVT with aberrancy. AV dissociation is the most specific finding."),
        CriticalPearlItem(header: "Pulseless VT:", content: "Defibrillate ≥200J immediately. 2025: First shock ≥200J preferred."),
        CriticalPearlItem(header: "Stable VT (2025):", content: "Amiodarone 150mg IV over 10 min. SOTALOL REMOVED from algorithm—no benefit."),
        CriticalPearlItem(header: "Unstable VT (2025):", content: "Synchronized cardioversion 100J. Sedate whenever feasible. Polymorphic VT = unsynchronized."),
        CriticalPearlItem(header: "The takeaway:", content: "Wide and fast with pulse = treat as VT. No pulse = shock ≥200J immediately.")
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

                    brugadaCriteriaCard
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

            Text("Ventricular Tachycardia")
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("WIDE COMPLEX TACHYCARDIA")
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
            CardiacDetailWaveformContent(fallbackGifName: "VTach", textSecondary: textSecondary)
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
                referenceRow(label: "Rate", value: "100 - 220 bpm", color: Color(red: 0.2, green: 0.5, blue: 0.9))
                referenceRow(label: "Rhythm", value: "Regular", color: brandAccent)
                referenceRow(label: "P-Wave", value: "Not present in QRS", color: Color(red: 0.90, green: 0.35, blue: 0.40))
                referenceRow(label: "PR Interval", value: "None", color: Color(red: 0.58, green: 0.44, blue: 0.86))
                referenceRow(label: "QRS", value: "Wide (> 120 ms)", color: CriticalDesign.Colors.accentOrange)
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
            Ventricular Tachycardia (VT) is a wide complex tachycardia—QRS > 120 ms—originating in the ventricles at a rate > 100 bpm. Monomorphic VT is the most common variant.

            Classification:
            Sustained VT lasts > 30 seconds or is symptomatic. Non-sustained VT (NSVT) lasts < 30 seconds and is typically asymptomatic, often from scarred myocardium.

            Key challenge:
            VT can be difficult to distinguish from SVT with aberrancy. The Brugada Criteria is the standard approach for differentiation.
            """, headings: ["Definition:", "Classification:", "Key challenge:"], isDarkMode: colorScheme == .dark))
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

    // MARK: - Brugada Criteria Card
    private var brugadaCriteriaCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentOrange)

                Text("Brugada Criteria")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textPrimary)
            }

            Text(ContentFormatter.format("""
            Step 1:
            Is there concordance in precordial leads (V1-V6)? If all QRS complexes are completely upright or completely downward → VT.

            Step 2:
            Is the R to S interval > 100 ms in any precordial lead? If yes → VT.

            Step 3:
            Is AV dissociation present? If yes → VT.

            Step 4 - RBBB pattern (upward in V1):
            • Monophasic R or biphasic qR in V1 → VT
            • RSR' ("bunny ear") with R > R' amplitude → VT
            • rS complex in lead V6 → VT

            Step 4 - LBBB pattern (downward in V1):
            • Any Q or QS-wave in V6 → VT
            • Wide R wave ≥ 40 ms in V1 or V2 → VT
            • Slurred/notched S wave downstroke in V1/V2 → VT
            • QRS onset to S wave peak > 60 ms → VT
            """, headings: ["Step 1:", "Step 2:", "Step 3:", "Step 4 - RBBB pattern (upward in V1):", "Step 4 - LBBB pattern (downward in V1):"], isDarkMode: colorScheme == .dark))
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
        .shadow(color: colorScheme == .dark ? .clear : CriticalDesign.Colors.accentOrange.opacity(0.08), radius: 10, x: 0, y: 4)
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
            Stable monomorphic VT (2025):
            Amiodarone 150 mg IVP over 10 min. Procainamide 20-50 mg IV may be considered. SOTALOL REMOVED—no benefit.

            Unstable monomorphic VT (2025):
            Synchronized cardioversion 100J. Sedate whenever feasible (changed from "if conscious"). Escalate energy if needed.

            Polymorphic VT (2025):
            Treat as VF—unsynchronized high-energy defibrillation. Synchronized cardioversion NOT appropriate.

            Pulseless VT (2025):
            Immediate defibrillation ≥200J preferred. High-quality CPR, Epinephrine after failed defib, Amiodarone 300 mg (then 150 mg).

            Additional 2025 Updates:
            • For stable, regular, monomorphic WCT, adenosine may be considered diagnostically
            • Do NOT give verapamil or diltiazem for WCT—risk of hemodynamic collapse
            """, headings: ["Stable monomorphic VT (2025):", "Unstable monomorphic VT (2025):", "Polymorphic VT (2025):", "Pulseless VT (2025):", "Additional 2025 Updates:"], isDarkMode: colorScheme == .dark))
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

    // MARK: - AI Explanation Section
    private var aiExplainSection: some View {
        VStack(spacing: 12) {
            ExplainButton(
                topic: "Ventricular Tachycardia",
                result: "Wide Complex Tachycardia - 2025 Guidelines",
                context: rhythmContext,
                screenName: "VTach Detail",
                style: .prominent,
                buttonText: "Explain VT Management"
            )
            
            ExplainButton(
                topic: "Monomorphic vs Polymorphic VT",
                result: "Different treatment approaches",
                context: "2025: Monomorphic VT uses synchronized cardioversion at 100J. Polymorphic VT is treated as VF with unsynchronized high-energy defibrillation ≥200J. This distinction is critical.",
                screenName: "VTach Detail",
                style: .inline,
                buttonText: "Mono vs Poly?"
            )
            
            ExplainButton(
                topic: "Sotalol Removed",
                result: "No longer in VT algorithm",
                context: "2025 ILCOR review: Sotalol showed no outcome benefit in VF/pVT refractory to defibrillation. It has been removed from cardiac arrest algorithms.",
                screenName: "VTach Detail",
                style: .inline,
                buttonText: "Why remove Sotalol?"
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    VentriculartachycardiaDetailView()
}
