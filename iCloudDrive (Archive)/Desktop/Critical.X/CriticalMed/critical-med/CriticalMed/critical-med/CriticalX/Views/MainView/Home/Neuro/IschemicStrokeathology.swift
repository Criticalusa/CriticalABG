//
//  IschemicStrokePathology.swift
//  CriticalX
//
//  Created by Macbook 7 on 28/12/2021.
//  Reconstructed with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct IschemicStrokeathology: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var expandedSection: String? = nil
    
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header
                    headerSection
                    
                    // Clinical Context
                    clinicalContextCard
                    
                    // The Key Pattern
                    keyPatternCard
                    
                    // Artery Territory Cards
                    mcaSection
                    acaSection
                    pcaSection
                    vertebrobasilarSection
                    
                    // Clinical Takeaway
                    clinicalTakeawayCard
                    
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
            GradientEdgeFadeImage(imageName: "icon-neuro", size: 120)
            
            Text("Ischemic Stroke")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("Arterial Territories & Clinical Patterns")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.top, CriticalDesign.Spacing.md)
    }
    
    // MARK: - Clinical Context Card
    private var clinicalContextCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)
                
                Text("Why This Matters")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            Text("Recognizing which artery is occluded helps you **predict the clinical course**, anticipate complications, and communicate effectively with neurology and interventional teams.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(6)
            
            Text("You don't need to memorize every detail. Focus on the **dominant patterns** — these will guide your exam and triage decisions.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
    }
    
    // MARK: - Key Pattern Card
    private var keyPatternCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)
                
                Text("The Mental Model")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                PatternRow(
                    label: "MCA",
                    pattern: "Face & arm > leg, ± speech/neglect",
                    color: CriticalDesign.Colors.accentRed
                )
                PatternRow(
                    label: "ACA",
                    pattern: "Leg > arm, behavioral changes",
                    color: CriticalDesign.Colors.accentGreen
                )
                PatternRow(
                    label: "PCA",
                    pattern: "Visual field loss, ± confusion",
                    color: CriticalDesign.Colors.accentPurple
                )
                PatternRow(
                    label: "Posterior",
                    pattern: "Vertigo, ataxia, diplopia, dysarthria",
                    color: CriticalDesign.Colors.accentOrange
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
    }
    
    // MARK: - MCA Section
    private var mcaSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            StrokeSectionHeader(title: "Middle Cerebral Artery (MCA)", subtitle: "Most common stroke territory (~70%)")
            
            // Left MCA
            ArteryTerritoryCard(
                side: "Left MCA",
                sideColor: CriticalDesign.Colors.accentTeal,
                clinicalFindings: [
                    "Aphasia (Broca's, Wernicke's, or global)",
                    "Right hemiparesis: Face & arm > leg",
                    "Right hemisensory loss",
                    "Right visual field cut (homonymous hemianopia)",
                    "Left gaze preference (eyes look toward lesion)"
                ],
                keyPoint: "**Left MCA = Language.** If they can't speak or understand, think left hemisphere.",
                isExpanded: expandedSection == "leftMCA",
                onTap: { toggleSection("leftMCA") }
            )
            
            // Right MCA
            ArteryTerritoryCard(
                side: "Right MCA",
                sideColor: CriticalDesign.Colors.accentOrange,
                clinicalFindings: [
                    "Left hemi-neglect (ignores left side of world)",
                    "Left hemiparesis: Face & arm > leg",
                    "Left hemisensory loss",
                    "Left visual field cut",
                    "Anosognosia (unaware of deficits)",
                    "Aprosodia (flat emotional speech)"
                ],
                keyPoint: "**Right MCA = Neglect.** They may not know anything is wrong. Look for them ignoring the left side.",
                isExpanded: expandedSection == "rightMCA",
                onTap: { toggleSection("rightMCA") }
            )
        }
    }
    
    // MARK: - ACA Section
    private var acaSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            StrokeSectionHeader(title: "Anterior Cerebral Artery (ACA)", subtitle: "Frontal lobe & medial motor strip")
            
            ArteryTerritoryCard(
                side: "ACA Territory",
                sideColor: CriticalDesign.Colors.accentGreen,
                clinicalFindings: [
                    "Contralateral leg weakness > arm (inverted MCA pattern)",
                    "Leg sensory loss",
                    "Behavioral changes: apathy, abulia, disinhibition",
                    "Urinary incontinence",
                    "Alien hand syndrome (rare)"
                ],
                keyPoint: "**ACA = Leg > Arm.** The opposite of MCA. Think frontal/medial territory.",
                isExpanded: expandedSection == "aca",
                onTap: { toggleSection("aca") }
            )
        }
    }
    
    // MARK: - PCA Section
    private var pcaSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            StrokeSectionHeader(title: "Posterior Cerebral Artery (PCA)", subtitle: "Occipital lobe & visual cortex")
            
            ArteryTerritoryCard(
                side: "PCA Territory",
                sideColor: CriticalDesign.Colors.accentPurple,
                clinicalFindings: [
                    "Contralateral homonymous hemianopia (visual field cut)",
                    "Patient may be unaware of visual loss",
                    "Visual agnosia (can't recognize objects)",
                    "Memory impairment (if bilateral or hippocampal)",
                    "Alexia without agraphia (can write but can't read)"
                ],
                keyPoint: "**PCA = Vision.** They lose half their visual field but may not notice. Always test visual fields.",
                isExpanded: expandedSection == "pca",
                onTap: { toggleSection("pca") }
            )
        }
    }
    
    // MARK: - Vertebrobasilar Section
    private var vertebrobasilarSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            StrokeSectionHeader(title: "Vertebrobasilar System", subtitle: "Brainstem, cerebellum, posterior circulation")
            
            ArteryTerritoryCard(
                side: "Posterior Circulation",
                sideColor: CriticalDesign.Colors.accentRed,
                clinicalFindings: [
                    "The 5 D's: Diplopia, Dysarthria, Dysphagia, Dizziness, Dystaxia",
                    "Crossed findings: ipsilateral face + contralateral body",
                    "Cerebellar signs: ataxia, nystagmus, intention tremor",
                    "Altered consciousness (basilar involvement)",
                    "Nausea/vomiting with vertigo"
                ],
                keyPoint: "**Posterior = The D's + Crossed signs.** Vertigo with neuro deficits is posterior circulation until proven otherwise.",
                isExpanded: expandedSection == "posterior",
                onTap: { toggleSection("posterior") }
            )
            
            // Danger warning for basilar
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.accentRed)
                
                Text("**Basilar artery occlusion** can present with coma, locked-in syndrome, or subtle early findings. High suspicion in unexplained altered mental status with brainstem signs.")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
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
    }
    
    // MARK: - Clinical Takeaway
    private var clinicalTakeawayCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "star.fill")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)
                
                Text("Clinical Takeaway")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(.white)
            }
            
            Text("At the bedside, focus on the **pattern**: Is it face/arm or leg? Is there speech or neglect? Are there posterior signs? This tells you the territory and helps you communicate the clinical picture clearly.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(6)
            
            Text("Remember: **Time is brain.** Your job is rapid recognition and activation — not perfect localization.")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Colors.goldLight)
                .lineSpacing(4)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.cardBlue)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(CriticalDesign.Colors.goldGradient, lineWidth: 1.5)
        )
        .shadow(color: CriticalDesign.Colors.goldMid.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Neumorphic Card Background
    private var neumorphicCardBackground: some View {
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
    
    // MARK: - Helper Functions
    private func toggleSection(_ section: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            if expandedSection == section {
                expandedSection = nil
            } else {
                expandedSection = section
            }
        }
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
    }
}

// MARK: - Stroke Section Header Component
private struct StrokeSectionHeader: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Poppins-Bold", size: 18))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text(subtitle)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, CriticalDesign.Spacing.sm)
    }
}

// MARK: - Pattern Row Component
private struct PatternRow: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let pattern: String
    let color: Color
    
    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            Text(label)
                .font(.custom("Poppins-Bold", size: 13))
                .foregroundColor(.white)
                .frame(width: 70)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                )
            
            Text(pattern)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
    }
}

// MARK: - Artery Territory Card Component
private struct ArteryTerritoryCard: View {
    @Environment(\.colorScheme) var colorScheme
    let side: String
    let sideColor: Color
    let clinicalFindings: [String]
    let keyPoint: String
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header - Always visible
            Button(action: onTap) {
                HStack(spacing: CriticalDesign.Spacing.md) {
                    // Color indicator
                    Circle()
                        .fill(sideColor)
                        .frame(width: 12, height: 12)
                    
                    Text(side)
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(CriticalDesign.Spacing.md)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                    Rectangle()
                        .fill(CriticalDesign.Colors.muted.opacity(0.3))
                        .frame(height: 1)
                    
                    // Clinical findings
                    VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                        Text("Clinical Findings")
                            .font(.custom("Poppins-SemiBold", size: 13))
                            .foregroundColor(sideColor)
                        
                        ForEach(clinicalFindings, id: \.self) { finding in
                            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                                Circle()
                                    .fill(sideColor.opacity(0.6))
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 6)
                                
                                Text(finding)
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    
                    // Key point
                    HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 12))
                            .foregroundColor(CriticalDesign.Colors.goldDeep)
                        
                        Text(CriticalDesign.markdownToAttributedString(keyPoint))
                            .font(.custom("Poppins-Medium", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .lineSpacing(3)
                    }
                    .padding(CriticalDesign.Spacing.sm + 2)
                    .background(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.sm)
                            .fill(CriticalDesign.Colors.goldLight.opacity(0.2))
                    )
                }
                .padding(.horizontal, CriticalDesign.Spacing.md)
                .padding(.bottom, CriticalDesign.Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(
                        LinearGradient(
                            colors: [Color.white, CriticalDesign.Colors.canvas],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(Color.clear)
                    .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white, radius: 10, x: -5, y: -5)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .stroke(
                    isExpanded ? sideColor.opacity(0.3) : Color.white.opacity(0.6),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Preview
#Preview {
    IschemicStrokeathology()
}
