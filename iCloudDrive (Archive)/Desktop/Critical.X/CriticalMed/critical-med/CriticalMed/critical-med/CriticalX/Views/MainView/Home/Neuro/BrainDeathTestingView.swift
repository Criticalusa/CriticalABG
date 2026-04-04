//
//  BrainDeathTestingView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 12/21/23.
//  Redesigned with CriticalDesign System
//

import SwiftUI

// MARK: - Main View
struct BrainDeathTestingView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var scrollViewContentOffset = CGFloat(0)
    
    var body: some View {
        ZStack {
            // Canvas background
            CriticalDesign.Colors.canvas.ignoresSafeArea()
            
            TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header with 3D icon
                    headerSection
                    
                    // Introduction Card
                    introCard
                    
                    // Prerequisites Section
                    prerequisitesSection
                    
                    // Examination Section
                    examinationSection
                    
                    // Apnea Test Section
                    apneaTestSection
                    
                    // Ancillary Testing Section
                    ancillaryTestingSection
                    
                    Spacer(minLength: CriticalDesign.Spacing.xl)
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
                .padding(.top, CriticalDesign.Spacing.md)
                .padding(.bottom, 100)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // 3D Icon with gradient fade
            GradientEdgeFadeImage(imageName: "icon-neuro", size: 120)
            
            Text("Brain Death Testing")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("Comatose, Areflexic, and Apneic")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(.top, CriticalDesign.Spacing.md)
    }
    
    // MARK: - Introduction Card
    private var introCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            Text(CriticalDesign.markdownToAttributedString("Brain death is the **irreversible cessation** of all functions of the entire brain, including the brainstem. This protocol guides the systematic evaluation required for determination."))
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
    }
    
    // MARK: - Prerequisites Section
    private var prerequisitesSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            BDTSectionHeader(title: "Pre-Requisites", icon: "checkmark.shield.fill", color: CriticalDesign.Colors.accentGreen)
            
            Text("Always consult your local and state protocols first. Before brain death testing commences, several factors should exist:")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: CriticalDesign.Spacing.sm) {
                BDTPrerequisiteRow(
                    icon: "icon-neuro",
                    title: "Irreversible Coma",
                    subtitle: "Unknown cause excluded",
                    accentColor: CriticalDesign.Colors.secondary
                )
                
                BDTPrerequisiteRow(
                    icon: "icon-lungs",
                    title: "Absent Spontaneous Respirations",
                    subtitle: "No respiratory effort",
                    accentColor: CriticalDesign.Colors.accentGreen
                )
                
                BDTPrerequisiteRow(
                    icon: "icon-hemodynamics",
                    title: "Normotensive & Euvolemic",
                    subtitle: "Hemodynamically stable",
                    accentColor: CriticalDesign.Colors.accentOrange
                )
                
                BDTPrerequisiteRow(
                    icon: "icon-IV",
                    title: "No Residual Drug Effects",
                    subtitle: "Sedatives and paralytics cleared",
                    accentColor: CriticalDesign.Colors.accentBlue
                )
                
                BDTPrerequisiteRow(
                    icon: "icon-temp",
                    title: "Normothermic",
                    subtitle: "Core temp ≥ 36°C (96.8°F)",
                    accentColor: CriticalDesign.Colors.accentRed
                )
                
                BDTPrerequisiteRow(
                    icon: "icon-periodicTable",
                    title: "No Metabolic Derangements",
                    subtitle: "Acid-base, electrolyte, endocrine normal",
                    accentColor: CriticalDesign.Colors.accentPurple
                )
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
    }
    
    // MARK: - Examination Section
    private var examinationSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            // Section header card
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                BDTSectionHeader(title: "Brain Death Examination", icon: "brain.head.profile", color: CriticalDesign.Colors.accentRed)
                
                // Compact gold note
                dualPhysicianNote
            }
            .padding(CriticalDesign.Spacing.lg)
            .background(neumorphicCardBackground)
            
            // Individual exam cards - each is its own card
            BDTExamCard(
                icon: "PupilsFlashlight",
                title: "Pupillary & Corneal Reflex",
                finding: "Absent, fixed, mid-position (4-6mm)",
                detail: "No direct or consensual response to bright light. Both corneal and pupillary reflexes must be tested bilaterally.",
                accentColor: CriticalDesign.Colors.accentBlue
            )
            
            BDTExamCard(
                icon: "icon-coughGag",
                title: "Cough & Gag Reflex",
                finding: "Absent to deep tracheal suctioning",
                detail: "No response to bronchial stimulation. Gag tested with oropharyngeal stimulation, cough with deep suctioning.",
                accentColor: CriticalDesign.Colors.accentTeal
            )
            
            BDTExamCard(
                icon: "Positive Occulovestibular",
                title: "Oculovestibular Reflex",
                finding: "Cold Calorics — Absent eye movement",
                detail: "No deviation after 50mL ice water irrigation. Wait 5 minutes between testing each ear. HOB elevated 30°.",
                accentColor: CriticalDesign.Colors.accentPurple
            )
            
            BDTExamCard(
                icon: "icon-body",
                title: "Motor Response",
                finding: "Absent in all extremities",
                detail: "No movement to painful stimuli (nail bed pressure, supraorbital ridge). Spinal reflexes may persist — these do NOT exclude brain death.",
                accentColor: CriticalDesign.Colors.accentOrange
            )
            
            // Doll's Eyes explanation - in its own card
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                dollsEyesSection
            }
            .padding(CriticalDesign.Spacing.lg)
            .background(neumorphicCardBackground)
        }
    }
    
    // MARK: - Dual Physician Note (Compact Gold Design)
    private var dualPhysicianNote: some View {
        HStack(alignment: .center, spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CriticalDesign.Colors.goldDeep)
            
            Text("Two attending physicians must independently complete this exam")
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, CriticalDesign.Spacing.md)
        .padding(.vertical, CriticalDesign.Spacing.sm + 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.sm)
                .fill(CriticalDesign.Colors.goldLight.opacity(0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.sm)
                        .stroke(CriticalDesign.Colors.goldMid.opacity(0.4), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Doll's Eyes Section
    private var dollsEyesSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            Text("Oculocephalic Reflex (Doll's Eyes)")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            HStack(spacing: CriticalDesign.Spacing.md) {
                // Present Reflex
                VStack(spacing: CriticalDesign.Spacing.sm) {
                    HStack(spacing: 4) {
                        Image("icon-normalEyes1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                        Image("icon-presentReflex")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }
                    
                    Text("Present")
                        .font(.custom("Poppins-Bold", size: 13))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                    
                    Text("Eyes stay fixed despite head turn")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity)
                .padding(CriticalDesign.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .fill(CriticalDesign.Colors.accentGreen.opacity(0.08))
                )
                
                // Absent Reflex
                VStack(spacing: CriticalDesign.Spacing.sm) {
                    HStack(spacing: 4) {
                        Image("icon-normaleyes2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                        Image("icon-absentReflex")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }
                    
                    Text("Absent")
                        .font(.custom("Poppins-Bold", size: 13))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                    
                    Text("Eyes move with head (brain dead)")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity)
                .padding(CriticalDesign.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .fill(CriticalDesign.Colors.accentRed.opacity(0.08))
                )
            }
        }
    }
    
    // MARK: - Apnea Test Section
    private var apneaTestSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            BDTSectionHeader(title: "Apnea Test", icon: "lungs.fill", color: CriticalDesign.Colors.accentTeal)
            
            Text(CriticalDesign.markdownToAttributedString("If brain dead, expect CO₂ to rise **>20 mmHg** above baseline, or to **≥60 mmHg**. Abort test if patient becomes unstable."))
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            // Horizontal scrolling steps
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: CriticalDesign.Spacing.md) {
                    BDTApneaStep(
                        step: 1,
                        title: "Baseline ABG",
                        detail: "Normalize PaCO₂ to 35-45",
                        color: CriticalDesign.Colors.accentRed
                    )
                    
                    BDTApneaStep(
                        step: 2,
                        title: "Pre-Oxygenate",
                        detail: "100% FiO₂ for 10 min",
                        color: CriticalDesign.Colors.accentBlue
                    )
                    
                    BDTApneaStep(
                        step: 3,
                        title: "Disconnect Vent",
                        detail: "O₂ catheter at carina",
                        color: CriticalDesign.Colors.accentOrange
                    )
                    
                    BDTApneaStep(
                        step: 4,
                        title: "Observe 8-10 min",
                        detail: "Watch for any breath",
                        color: CriticalDesign.Colors.accentPurple
                    )
                    
                    BDTApneaStep(
                        step: 5,
                        title: "Post-Apnea ABG",
                        detail: "Confirm CO₂ rise",
                        color: CriticalDesign.Colors.accentGreen
                    )
                    
                    BDTApneaStep(
                        step: 6,
                        title: "Reconnect Vent",
                        detail: "Resume ventilation",
                        color: CriticalDesign.Colors.accentTeal
                    )
                }
                .padding(.vertical, CriticalDesign.Spacing.sm)
            }
            
            // Abort conditions
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                Text("Abort If:")
                    .font(.custom("Poppins-Bold", size: 13))
                    .foregroundColor(CriticalDesign.Colors.accentRed)
                
                Text("• SpO₂ < 85%  • SBP < 90 mmHg  • Cardiac arrhythmia")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(CriticalDesign.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.accentRed.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                            .stroke(CriticalDesign.Colors.accentRed.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
    }
    
    // MARK: - Ancillary Testing Section
    private var ancillaryTestingSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            BDTSectionHeader(title: "Ancillary Testing", icon: "waveform.path.ecg", color: CriticalDesign.Colors.accentPurple)
            
            Text("Use when apnea test cannot be completed or confounding factors exist (e.g., drug intoxication, severe facial trauma).")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: CriticalDesign.Spacing.sm) {
                BDTAncillaryCard(
                    number: 1,
                    title: "EEG",
                    subtitle: "Electroencephalogram",
                    detail: "Electrocerebral silence × 30 min",
                    color: CriticalDesign.Colors.accentRed
                )
                
                BDTAncillaryCard(
                    number: 2,
                    title: "Cerebral Blood Flow",
                    subtitle: "Nuclear Medicine Scan",
                    detail: "No intracranial blood flow",
                    color: CriticalDesign.Colors.accentBlue
                )
                
                BDTAncillaryCard(
                    number: 3,
                    title: "Cerebral Angiography",
                    subtitle: "TCD or 4-Vessel",
                    detail: "Absent flow beyond Circle of Willis",
                    color: CriticalDesign.Colors.accentOrange
                )
            }
            
            // Note about blood flow tests
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)
                
                Text("Blood flow-based tests are preferred for intoxication as they are not affected by drug levels.")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.goldLight.opacity(0.15))
            )
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
    }
    
    // MARK: - Neumorphic Card Background
    private var neumorphicCardBackground: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(
                LinearGradient(
                    colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
            .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Section Header Component
private struct BDTSectionHeader: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            
            Text(title.uppercased())
                .font(.custom("Poppins-Bold", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .tracking(1)
        }
    }
}

// MARK: - Prerequisite Row Component
private struct BDTPrerequisiteRow: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let title: String
    let subtitle: String
    let accentColor: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: CriticalDesign.Spacing.md) {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 4)
            
            Circle()
                .fill(accentColor)
                .frame(width: 8, height: 8)
        }
        .padding(.vertical, CriticalDesign.Spacing.sm)
    }
}

// MARK: - Exam Card Component (Static - No Dropdown)
private struct BDTExamCard: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let title: String
    let finding: String
    let detail: String
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            // Header with icon and title
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.md) {
                // Icon
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(finding)
                        .font(.custom("Poppins-SemiBold", size: 13))
                        .foregroundColor(accentColor)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer(minLength: 0)
            }
            
            // Detail text
            Text(detail)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
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
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 4, y: 4)
                    .shadow(color: Color.white, radius: 8, x: -4, y: -4)
            }
        )
        .overlay(
            // Colored top accent bar
            VStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(height: 4)
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                Spacer()
            }
            .clipShape(RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg))
        )
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

// MARK: - Apnea Step Component
private struct BDTApneaStep: View {
    @Environment(\.colorScheme) var colorScheme
    let step: Int
    let title: String
    let detail: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            // Step number badge
            Text("\(step)")
                .font(.custom("Poppins-Bold", size: 18))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(Circle().fill(color))
            
            Text(title)
                .font(.custom("Poppins-Bold", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
            
            Text(detail)
                .font(.custom("Poppins-Regular", size: 11))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 120, alignment: .topLeading)
        .padding(CriticalDesign.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(color.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(color.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

// MARK: - Ancillary Card Component
private struct BDTAncillaryCard: View {
    @Environment(\.colorScheme) var colorScheme
    let number: Int
    let title: String
    let subtitle: String
    let detail: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.md) {
            // Number badge
            Text("\(number)")
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Circle().fill(color))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text(subtitle)
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(color)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(detail)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(CriticalDesign.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(CriticalDesign.Colors.elevatedSurface.opacity(0.6))
        )
    }
}

// MARK: - Preview
#Preview {
    BrainDeathTestingView()
}
