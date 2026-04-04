//
//  IncreaseIcpDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 29/12/2021.
//  Revamped with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct IncreaseIcpDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var expandedSection: String? = nil
    @State private var showAllPearls = false

    // Critical Pearls for stepper
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Think CPP:", content: "CPP = MAP - ICP. Always calculate this. Maintain CPP 60-70 mmHg; SBP >90 mmHg."),
        CriticalPearlItem(header: "Vasoactive support:", content: "Use vasoactive medications if needed (Neosynephrine) to maintain perfusion pressure."),
        CriticalPearlItem(header: "Avoid these fluids:", content: "Do NOT use D5W or 0.45% saline for maintenance—they worsen cerebral edema."),
        CriticalPearlItem(header: "Sedation choice:", content: "Propofol preferred (short half-life allows frequent neuro exams, reduces ICP spikes from suctioning/coughing/agitation)."),
        CriticalPearlItem(header: "The takeaway:", content: "A blown pupil in a deteriorating patient is herniation until proven otherwise. Don't wait for imaging—intervene first.")
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header
                    headerSection

                    // Clinical Context
                    clinicalContextCard

                    // ICP Overview
                    icpOverviewCard

                    // Emergency Signs
                    emergencySignsCard

                    // Causes & Pathophysiology
                    causesSection
                    pathophysiologySection

                    // Airway Management
                    airwayCard

                    // Treatment
                    treatmentCard

                    // Critical Pearls - Two-Tone Card with Stepper
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)

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

            HStack(spacing: 0) {
                Text("Increased ")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text("ICP")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(CriticalDesign.Colors.accentRed)
            }

            Text("Intracranial Pressure Management")
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

            Text("Elevated ICP is a **neurological emergency**. Early recognition and intervention can prevent herniation and death. Your goal is to **protect the brain** while addressing the underlying cause.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(6)

            Text("Focus on the **numbers that matter**: ICP >20 mmHg is elevated, sustained >40 mmHg carries poor prognosis, and >60 mmHg is often fatal.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
    }

    // MARK: - ICP Overview Card
    private var icpOverviewCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "gauge.high")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                Text("ICP Reference Values")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                ICPValueRow(label: "Normal", value: "5-15 mmHg", color: CriticalDesign.Colors.accentGreen)
                ICPValueRow(label: "Elevated", value: ">20 mmHg", color: CriticalDesign.Colors.accentOrange)
                ICPValueRow(label: "Poor Prognosis", value: ">40 mmHg sustained", color: CriticalDesign.Colors.accentRed)
                ICPValueRow(label: "Fatal", value: ">60 mmHg sustained", color: Color(red: 0.5, green: 0.1, blue: 0.1))
            }

            Text("**Intracranial hypertension** is defined as ICP >20 mmHg for longer than five minutes. Brain swelling affects the outer cerebral cortex first, then progresses to deeper structures and finally the brainstem.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(4)
                .padding(.top, CriticalDesign.Spacing.sm)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.accentRed.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(CriticalDesign.Colors.accentRed.opacity(0.2), lineWidth: 1)
        )
    }

    // MARK: - Emergency Signs Card
    private var emergencySignsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header - Always visible
            Button(action: { toggleSection("emergency") }) {
                HStack(spacing: CriticalDesign.Spacing.md) {
                    Circle()
                        .fill(CriticalDesign.Colors.accentRed)
                        .frame(width: 12, height: 12)

                    Text("Signs of Intracranial Emergency")
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .rotationEffect(.degrees(expandedSection == "emergency" ? 180 : 0))
                }
                .padding(CriticalDesign.Spacing.md)
            }
            .buttonStyle(PlainButtonStyle())

            // Expanded content
            if expandedSection == "emergency" {
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                    Rectangle()
                        .fill(CriticalDesign.Colors.muted.opacity(0.3))
                        .frame(height: 1)

                    VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                        emergencyFinding("ICP >20 mmHg")
                        emergencyFinding("CPP <60 mmHg")
                        emergencyFinding("Blood in the cerebrospinal fluid")
                        emergencyFinding("CSF leaking around insertion site")
                        emergencyFinding("Infection around insertion site")
                        emergencyFinding("CSF drainage >500 mL in 24 hours")
                    }
                }
                .padding(.horizontal, CriticalDesign.Spacing.md)
                .padding(.bottom, CriticalDesign.Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(expandableCardBackground(isExpanded: expandedSection == "emergency", color: CriticalDesign.Colors.accentRed))
    }

    // MARK: - Causes Section
    private var causesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { toggleSection("causes") }) {
                HStack(spacing: CriticalDesign.Spacing.md) {
                    Circle()
                        .fill(CriticalDesign.Colors.accentOrange)
                        .frame(width: 12, height: 12)

                    Text("Causes of Increased ICP")
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .rotationEffect(.degrees(expandedSection == "causes" ? 180 : 0))
                }
                .padding(CriticalDesign.Spacing.md)
            }
            .buttonStyle(PlainButtonStyle())

            if expandedSection == "causes" {
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                    Rectangle()
                        .fill(CriticalDesign.Colors.muted.opacity(0.3))
                        .frame(height: 1)

                    VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                        causeFinding("Interstitial edema")
                        causeFinding("Brain hypoxia")
                        causeFinding("Trauma")
                        causeFinding("Reduced cerebral blood flow or direct cerebral injury")
                        causeFinding("Mass effect from hematoma or hydrocephalus")
                    }
                }
                .padding(.horizontal, CriticalDesign.Spacing.md)
                .padding(.bottom, CriticalDesign.Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(expandableCardBackground(isExpanded: expandedSection == "causes", color: CriticalDesign.Colors.accentOrange))
    }

    // MARK: - Pathophysiology Section
    private var pathophysiologySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { toggleSection("patho") }) {
                HStack(spacing: CriticalDesign.Spacing.md) {
                    Circle()
                        .fill(CriticalDesign.Colors.accentGreen)
                        .frame(width: 12, height: 12)

                    Text("Pathophysiology")
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .rotationEffect(.degrees(expandedSection == "patho" ? 180 : 0))
                }
                .padding(CriticalDesign.Spacing.md)
            }
            .buttonStyle(PlainButtonStyle())

            if expandedSection == "patho" {
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                    Rectangle()
                        .fill(CriticalDesign.Colors.muted.opacity(0.3))
                        .frame(height: 1)

                    Text("When ICP increases, compensatory mechanisms occur in this order:")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                        pathoStep("1", "Ventricles contract, reducing CSF volume")
                        pathoStep("2", "Blood volume reduced by hyperventilation → cerebral vasoconstriction")
                        pathoStep("3", "Cushing's reflex (late sign): bradycardia + hypertension")
                    }

                    HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 12))
                            .foregroundColor(CriticalDesign.Colors.goldDeep)

                        Text("**Cushing's triad** (hypertension, bradycardia, irregular respirations) is a late, ominous sign of brainstem compression.")
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
        .background(expandableCardBackground(isExpanded: expandedSection == "patho", color: CriticalDesign.Colors.accentGreen))
    }

    // MARK: - Airway Card
    private var airwayCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "lungs.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentTeal)

                Text("Airway Management")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                airwayPoint("Intubation and mechanical ventilation are necessary")
                airwayPoint("Maintain oxygen delivery ≥600 mL/min by supporting cardiac index, hemoglobin, and oxygen saturation")
            }

            // Warning Box
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                Text("**Aggressive hyperventilation** (PaCO2 ~30) is only used for ICP resistant to treatment. Sustained hyperventilation can worsen cerebral edema.")
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
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
    }

    // MARK: - Treatment Card
    private var treatmentCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("Treatment & Management")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                treatmentCategory("Positioning", [
                    "Head of bed 30-45°",
                    "Head in neutral position",
                    "Ensure tracheal ties not tight"
                ])

                treatmentCategory("Osmotic Therapy", [
                    "Mannitol: 0.25-1 g/kg (maintain serum osmolarity 305-320 mOsm/L)",
                    "Hypertonic saline 3%"
                ])

                treatmentCategory("Diuretics", [
                    "Lasix: 0.5-1 mg/kg (decreases CSF production)"
                ])

                treatmentCategory("Other", [
                    "Albumin 4 g/dL for cerebral edema",
                    "Barbiturate comas for refractory cases",
                    "Labetalol: 10-40 mg IV q15-30 min for MAP >150 mmHg"
                ])
            }

            // Note
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("**75% of cranial blood volume is venous.** Avoid nitroglycerin and nipride as they increase ICP.")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.accentBlue.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .stroke(CriticalDesign.Colors.accentBlue.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
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

    // MARK: - Expandable Card Background
    private func expandableCardBackground(isExpanded: Bool, color: Color) -> some View {
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
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .stroke(
                    isExpanded ? color.opacity(0.3) : Color.white.opacity(0.6),
                    lineWidth: 1
                )
        )
    }

    // MARK: - Helper Views
    private func emergencyFinding(_ text: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(CriticalDesign.Colors.accentRed.opacity(0.6))
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            CriticalDesign.autoBoldText(text)
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    private func causeFinding(_ text: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(CriticalDesign.Colors.accentOrange.opacity(0.6))
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            CriticalDesign.autoBoldText(text)
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    private func pathoStep(_ number: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Text(number)
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Circle().fill(CriticalDesign.Colors.accentGreen))

            CriticalDesign.autoBoldText(text)
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    private func airwayPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(CriticalDesign.Colors.accentTeal.opacity(0.6))
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            CriticalDesign.autoBoldText(text)
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }

    private func treatmentCategory(_ title: String, _ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(CriticalDesign.Colors.accentBlue)

            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                    Circle()
                        .fill(CriticalDesign.Colors.accentBlue.opacity(0.4))
                        .frame(width: 5, height: 5)
                        .padding(.top, 7)

                    CriticalDesign.autoBoldText(item)
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }
        }
        .padding(.bottom, CriticalDesign.Spacing.sm)
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

// MARK: - ICP Value Row Component
private struct ICPValueRow: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            Text(label)
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(.white)
                .frame(width: 100)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                )

            Text(value)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    IncreaseIcpDetailView()
}
