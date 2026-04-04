//
//  CarnialNervesDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 28/12/2021.
//  Updated with Nano Banana Pro Design System
//

import SwiftUI

// MARK: - Cranial Nerve Data Model
struct CranialNerve: Identifiable {
    let id = UUID()
    let number: String
    let name: String
    let function: String
    let clinicalTest: String
    let type: NerveType

    enum NerveType {
        case sensory
        case motor
        case both

        var color: Color {
            switch self {
            case .sensory: return CriticalDesign.Colors.accentRed
            case .motor: return CriticalDesign.Colors.cardBlue
            case .both: return CriticalDesign.Colors.accentGreen
            }
        }

        var label: String {
            switch self {
            case .sensory: return "Sensory"
            case .motor: return "Motor"
            case .both: return "Both"
            }
        }
    }
}

struct CarnialNervesDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isToggle = true
    @State private var currentAmount: CGFloat = 0
    @State private var isAppearing = false

    // Cranial nerves data with clinical bedside tests
    private let cranialNerves: [CranialNerve] = [
        CranialNerve(number: "I", name: "Olfactory", function: "Smell", clinicalTest: "Rarely tested in acute settings", type: .sensory),
        CranialNerve(number: "II", name: "Optic", function: "Vision", clinicalTest: "Visual acuity, visual fields, fundoscopy", type: .sensory),
        CranialNerve(number: "III", name: "Oculomotor", function: "Pupil constriction, most eye movements, eyelid elevation", clinicalTest: "Pupil light reflex, eye tracking", type: .motor),
        CranialNerve(number: "IV", name: "Trochlear", function: "Downward and inward gaze", clinicalTest: "Look down and in", type: .motor),
        CranialNerve(number: "V", name: "Trigeminal", function: "Facial sensation, jaw strength", clinicalTest: "Light touch to face, corneal reflex, clench teeth", type: .both),
        CranialNerve(number: "VI", name: "Abducens", function: "Lateral eye movement", clinicalTest: "Look laterally", type: .motor),
        CranialNerve(number: "VII", name: "Facial", function: "Facial expression, taste (anterior 2/3 tongue)", clinicalTest: "Smile, raise eyebrows, close eyes tight", type: .both),
        CranialNerve(number: "VIII", name: "Vestibulocochlear", function: "Hearing, balance", clinicalTest: "Finger rub, Weber/Rinne if needed", type: .sensory),
        CranialNerve(number: "IX", name: "Glossopharyngeal", function: "Gag reflex (sensory), taste (posterior tongue)", clinicalTest: "Gag reflex (afferent limb)", type: .both),
        CranialNerve(number: "X", name: "Vagus", function: "Palate elevation, gag reflex (motor), autonomic", clinicalTest: "Say 'ah', gag reflex (efferent limb)", type: .both),
        CranialNerve(number: "XI", name: "Spinal Accessory", function: "Shoulder shrug, head turn", clinicalTest: "Shrug against resistance, turn head against resistance", type: .motor),
        CranialNerve(number: "XII", name: "Hypoglossal", function: "Tongue movement", clinicalTest: "Stick out tongue, push against cheek", type: .motor)
    ]

    // MARK: - Neumorphic Card Background
    @ViewBuilder
    private var neumorphicCardBackground: some View {
        if colorScheme == .dark {
            RoundedRectangle(cornerRadius: 18)
                .fill(CriticalDesign.Colors.cardBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                )
        } else {
            RoundedRectangle(cornerRadius: 18)
                .fill(LinearGradient(
                    colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(LinearGradient(
                            colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1)
                )
        }
    }

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    headerSection
                    clinicalContextCard
                    imageCard
                    legendCard
                    nervesListCard
                    clinicalPearlCard
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
                .padding(.top, CriticalDesign.Spacing.md)
                .padding(.bottom, 100)
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
        VStack(spacing: 16) {
            // 3D Icon placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [CriticalDesign.Colors.primary, CriticalDesign.Colors.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.white)
            }

            VStack(spacing: 4) {
                Text("Cranial Nerves")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text("Bedside Neurological Assessment")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }
        }
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Clinical Context Card
    private var clinicalContextCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "stethoscope")
                    .font(.system(size: 18))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)

                Text("Clinical Context")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("You don't need to test all 12 cranial nerves on every patient. Focus on the nerves relevant to your clinical question.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineSpacing(6)

            Text("For most acute neuro assessments, pupils (III), facial symmetry (VII), and gag reflex (IX/X) give you the critical information you need.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 10)
        .animation(.easeOut(duration: 0.4).delay(0.05), value: isAppearing)
    }

    // MARK: - Image Card
    private var imageCard: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            Image(isToggle ? "CranialNerveCartoon" : "CranialNerves1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .scaleEffect(1 + currentAmount)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentAmount = value - 1
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                currentAmount = 0
                            }
                        }
                )

            // Toggle for image type
            HStack(spacing: CriticalDesign.Spacing.md) {
                Text("Simplified")
                    .font(.custom(isToggle ? "Poppins-SemiBold" : "Poppins-Medium", size: 14))
                    .foregroundColor(isToggle ? CriticalDesign.Colors.primary : CriticalDesign.Colors.tertiary)

                Toggle("", isOn: $isToggle)
                    .labelsHidden()
                    .tint(CriticalDesign.Colors.goldDeep)

                Text("Anatomical")
                    .font(.custom(!isToggle ? "Poppins-SemiBold" : "Poppins-Medium", size: 14))
                    .foregroundColor(!isToggle ? CriticalDesign.Colors.primary : CriticalDesign.Colors.tertiary)
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 10)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - Legend Card
    private var legendCard: some View {
        HStack(spacing: CriticalDesign.Spacing.lg) {
            LegendItem(color: CranialNerve.NerveType.sensory.color, label: "Sensory")
            LegendItem(color: CranialNerve.NerveType.motor.color, label: "Motor")
            LegendItem(color: CranialNerve.NerveType.both.color, label: "Both")
        }
        .padding(CriticalDesign.Spacing.md)
        .frame(maxWidth: .infinity)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - Nerves List Card
    private var nervesListCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            Text("The 12 Cranial Nerves")
                .font(.custom("Poppins-Bold", size: 20))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text("Each nerve listed with its bedside test")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))

            VStack(spacing: 0) {
                ForEach(Array(cranialNerves.enumerated()), id: \.element.id) { index, nerve in
                    CranialNerveRow(nerve: nerve)

                    if index < cranialNerves.count - 1 {
                        Divider()
                            .background(CriticalDesign.Colors.muted)
                            .padding(.leading, 56)
                    }
                }
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Clinical Pearl Card
    private var clinicalPearlCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)

                Text("Clinical Takeaway")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(.white)
            }

            Text("In acute settings, an asymmetric pupil (III), facial droop (VII), or absent gag (IX/X) tells you more than a complete cranial nerve exam. Test what answers your clinical question.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .signatureCard(cornerRadius: 16, strokeWidth: 1.5)
        .opacity(isAppearing ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.25), value: isAppearing)
    }
}

// MARK: - Legend Item Component
private struct LegendItem: View {
    @Environment(\.colorScheme) var colorScheme
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)

            Text(label)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
    }
}

// MARK: - Cranial Nerve Row Component
private struct CranialNerveRow: View {
    @Environment(\.colorScheme) var colorScheme
    let nerve: CranialNerve

    var body: some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            // Roman numeral badge
            Text(nerve.number)
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(nerve.type.color)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(nerve.name)
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(nerve.type.color)

                    Spacer()

                    // Type indicator
                    Text(nerve.type.label)
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(nerve.type.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(nerve.type.color.opacity(0.12))
                        )
                }

                Text(nerve.function)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "hand.point.right.fill")
                        .font(.system(size: 10))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    Text(nerve.clinicalTest)
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .italic()
                }
            }
        }
        .padding(.vertical, CriticalDesign.Spacing.sm)
    }
}

// MARK: - Preview
struct CarnialNervesDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CarnialNervesDetailView()
        }
    }
}
