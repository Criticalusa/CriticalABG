//
//  ABODetailsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 20/12/2021.
//  Updated: Premium Light Theme with Interactive Blood Compatibility
//

import SwiftUI

struct ABODetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var selectedBloodType: Int = 0
    @State private var showAllPearls = false

    // Blood types data
    private let bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]

    // Compatibility data
    private let compatibilityData: [BloodCompatibility] = [
        BloodCompatibility(type: "A+", canDonateTo: ["A+", "AB+"], canReceiveFrom: ["A+", "A-", "O+", "O-"]),
        BloodCompatibility(type: "A-", canDonateTo: ["A+", "A-", "AB+", "AB-"], canReceiveFrom: ["A-", "O-"]),
        BloodCompatibility(type: "B+", canDonateTo: ["B+", "AB+"], canReceiveFrom: ["B+", "B-", "O+", "O-"]),
        BloodCompatibility(type: "B-", canDonateTo: ["B+", "B-", "AB+", "AB-"], canReceiveFrom: ["B-", "O-"]),
        BloodCompatibility(type: "AB+", canDonateTo: ["AB+"], canReceiveFrom: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]),
        BloodCompatibility(type: "AB-", canDonateTo: ["AB+", "AB-"], canReceiveFrom: ["A-", "B-", "AB-", "O-"]),
        BloodCompatibility(type: "O+", canDonateTo: ["A+", "B+", "AB+", "O+"], canReceiveFrom: ["O+", "O-"]),
        BloodCompatibility(type: "O-", canDonateTo: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"], canReceiveFrom: ["O-"])
    ]

    // Accent colors
    private let bloodRed = Color(red: 0.85, green: 0.2, blue: 0.25)
    private let donateGreen = Color(red: 0.2, green: 0.7, blue: 0.4)
    private let receiveBlue = Color(red: 0.2, green: 0.5, blue: 0.9)

    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15)
    }
    private var textSecondary: Color {
        colorScheme == .dark ? Color.white.opacity(0.7) : Color(red: 0.4, green: 0.4, blue: 0.45)
    }

    // Critical Pearls
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Universal Donor:", content: "O-negative RBCs can be given to any patient in emergencies when blood type is unknown."),
        CriticalPearlItem(header: "Universal Recipient:", content: "AB+ patients can receive RBCs from any ABO/Rh type."),
        CriticalPearlItem(header: "Plasma is opposite:", content: "For plasma/FFP, AB is universal donor (no antibodies) and O is universal recipient."),
        CriticalPearlItem(header: "Rh-negative females:", content: "Give Rh-negative blood to Rh-negative females of childbearing age to prevent sensitization."),
        CriticalPearlItem(header: "Emergency switch:", content: "After 2+ units of O-negative, consider switching to type-specific when available.")
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Close button
                    HStack {
                        Spacer()
                        PremiumLightCloseButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }

                    // Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)

                    // Blood Type Selector
                    bloodTypeSelector
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 30)

                    // Selected Blood Type Result Card
                    resultCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)

                    // Compatibility Matrix
                    compatibilityMatrixCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 50)

                    // Critical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 60)

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
            ZStack {
                Circle()
                    .fill(bloodRed.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)

                ZStack {
                    if colorScheme == .dark {
                        Circle()
                            .fill(CriticalDesign.Colors.cardBlue)
                            .frame(width: 80, height: 80)
                    } else {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 80, height: 80)
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 80, height: 80)
                    }
                    Circle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        .frame(width: 80, height: 80)

                    Image(systemName: "drop.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [bloodRed, bloodRed.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("ABO Compatibility")
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(textPrimary)
                .multilineTextAlignment(.center)

            Text("BLOOD TYPE MATCHING")
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(bloodRed)
                .tracking(2)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(bloodRed.opacity(0.12))
                )
        }
        .padding(.bottom, 8)
    }

    // MARK: - Blood Type Selector
    private var bloodTypeSelector: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Select Patient Blood Type")
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(textSecondary)
                .padding(.horizontal, 20)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(0..<bloodTypes.count, id: \.self) { index in
                    bloodTypeButton(type: bloodTypes[index], index: index)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func bloodTypeButton(type: String, index: Int) -> some View {
        let isSelected = selectedBloodType == index

        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedBloodType = index
            }
        }) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isSelected ? bloodRed : Color.clear)
                        .frame(width: 50, height: 50)

                    Circle()
                        .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(.ultraThinMaterial))
                        .frame(width: 50, height: 50)
                        .opacity(isSelected ? 0 : 1)

                    Circle()
                        .stroke(isSelected ? bloodRed : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                        .frame(width: 50, height: 50)

                    Image(systemName: "drop.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .white : bloodRed.opacity(0.6))
                }
                .shadow(color: isSelected ? bloodRed.opacity(0.3) : Color.clear, radius: 8, y: 4)

                Text(type)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(isSelected ? bloodRed : textSecondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Result Card
    private var resultCard: some View {
        let compatibility = compatibilityData[selectedBloodType]

        return VStack(spacing: 0) {
            // Header with selected blood type
            HStack {
                ZStack {
                    Circle()
                        .fill(bloodRed)
                        .frame(width: 60, height: 60)

                    Image(systemName: "drop.fill")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(.white)
                }
                .shadow(color: bloodRed.opacity(0.4), radius: 8, y: 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Blood Type")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(textSecondary)

                    Text(compatibility.type)
                        .font(.custom("Poppins-Bold", size: 32))
                        .foregroundColor(textPrimary)
                }
                .padding(.leading, 8)

                Spacer()
            }
            .padding(20)

            Divider()
                .background(Color.gray.opacity(0.2))
                .padding(.horizontal, 20)

            // Can Donate To
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(donateGreen)

                    Text("CAN DONATE TO")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(donateGreen)
                        .tracking(1)
                }

                ABOFlowLayout(spacing: 8) {
                    ForEach(compatibility.canDonateTo, id: \.self) { type in
                        bloodTypeBadge(type: type, color: donateGreen)
                    }
                }

                if compatibility.canDonateTo.count == 8 {
                    Text("Universal Donor for RBCs")
                        .font(.custom("Poppins-SemiBold", size: 12))
                        .foregroundColor(donateGreen)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(donateGreen.opacity(0.15))
                        )
                }
            }
            .padding(20)

            Divider()
                .background(Color.gray.opacity(0.2))
                .padding(.horizontal, 20)

            // Can Receive From
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(receiveBlue)

                    Text("CAN RECEIVE FROM")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(receiveBlue)
                        .tracking(1)
                }

                ABOFlowLayout(spacing: 8) {
                    ForEach(compatibility.canReceiveFrom, id: \.self) { type in
                        bloodTypeBadge(type: type, color: receiveBlue)
                    }
                }

                if compatibility.canReceiveFrom.count == 8 {
                    Text("Universal Recipient for RBCs")
                        .font(.custom("Poppins-SemiBold", size: 12))
                        .foregroundColor(receiveBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(receiveBlue.opacity(0.15))
                        )
                }
            }
            .padding(20)
        }
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
                            .fill(Color.white.opacity(0.6))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            bloodRed.opacity(0.3),
                            colorScheme == .dark ? bloodRed.opacity(0.15) : Color.white.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    private func bloodTypeBadge(type: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "drop.fill")
                .font(.system(size: 10))
                .foregroundColor(color)

            Text(type)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(textPrimary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(color.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Compatibility Matrix Card
    private var compatibilityMatrixCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "tablecells")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(bloodRed)

                Text("Quick Reference Matrix")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textPrimary)
            }

            // Matrix Legend
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(donateGreen)
                        .frame(width: 10, height: 10)
                    Text("Compatible")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(textSecondary)
                }

                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                    Text("Incompatible")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(textSecondary)
                }
            }

            // Simplified matrix display
            VStack(spacing: 8) {
                // Header row
                HStack(spacing: 4) {
                    Text("Donor")
                        .font(.custom("Poppins-SemiBold", size: 9))
                        .foregroundColor(textSecondary)
                        .frame(width: 50, alignment: .leading)

                    ForEach(bloodTypes, id: \.self) { type in
                        Text(type)
                            .font(.custom("Poppins-Bold", size: 9))
                            .foregroundColor(textPrimary)
                            .frame(maxWidth: .infinity)
                    }
                }

                // Matrix rows
                ForEach(0..<bloodTypes.count, id: \.self) { recipientIndex in
                    HStack(spacing: 4) {
                        Text(bloodTypes[recipientIndex])
                            .font(.custom("Poppins-Bold", size: 10))
                            .foregroundColor(textPrimary)
                            .frame(width: 50, alignment: .leading)

                        ForEach(0..<bloodTypes.count, id: \.self) { donorIndex in
                            let isCompatible = compatibilityData[recipientIndex].canReceiveFrom.contains(bloodTypes[donorIndex])

                            Circle()
                                .fill(isCompatible ? donateGreen : Color.gray.opacity(0.2))
                                .frame(width: 12, height: 12)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(colorScheme == .dark ? 0.05 : 0.3))
            )

            Text("Recipient (rows) vs Donor (columns)")
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(textSecondary)
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
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.gray.opacity(colorScheme == .dark ? 0.15 : 0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
}

// MARK: - Supporting Types
private struct BloodCompatibility {
    let type: String
    let canDonateTo: [String]
    let canReceiveFrom: [String]
}

// MARK: - Flow Layout for badges
private struct ABOFlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)

        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX)
        }

        return (CGSize(width: maxX, height: currentY + lineHeight), positions)
    }
}

// MARK: - Preview
struct ABODetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ABODetailsView()
    }
}
