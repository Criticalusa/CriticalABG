//
//  NLMomentCard.swift
//  CriticalX
//
//  Natural Language Moment Search - Moment Card
//  Displays a computed moment output with dose, details, and safety guardrails
//  Styled to match CriticalDesign system (neumorphic, Poppins fonts)
//

import SwiftUI

// MARK: - NLMomentCard
/// Card displaying a computed moment output
/// Uses neumorphic styling consistent with VIEW_TEMPLATE_GUIDE
struct NLMomentCard: View {
    @Environment(\.colorScheme) var colorScheme

    let output: NLMomentOutput
    var onWeightNeeded: (() -> Void)?

    @State private var isExpanded: Bool = true
    
    private let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            cardHeader
            
            // Main content
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                // Dose line (big and bold if available)
                if let doseLine = output.doseLine {
                    doseDisplay(doseLine)
                } else if output.isIncomplete {
                    needsInputDisplay
                }
                
                // Chips row
                if !output.chips.isEmpty {
                    chipRow
                }
                
                // Clinical Pearls section (checklist)
                if isExpanded && !output.clinicalPearls.isEmpty {
                    clinicalPearlsSection
                }
                
                // Details section
                if isExpanded && !output.details.isEmpty {
                    detailsSection
                }
                
                // Warnings section
                if isExpanded && !output.warnings.isEmpty {
                    warningsSection
                }
            }
            .padding(CriticalDesign.Spacing.lg)
        }
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.9), CriticalDesign.Colors.canvas],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.gold.opacity(0.3)
                        : (output.isIncomplete ? Color.orange.opacity(0.4) : CriticalDesign.Colors.cardBlue.opacity(0.1)),
                    lineWidth: output.isIncomplete ? 2 : 1
                )
        )
    }
    
    // MARK: - Card Header
    
    private var cardHeader: some View {
        HStack {
            // Accent bar
            RoundedRectangle(cornerRadius: 2)
                .fill(output.isIncomplete ? Color.orange : CriticalDesign.Colors.cardBlue)
                .frame(width: 4, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(output.headline.uppercased())
                    .font(.custom("Poppins-Bold", size: 11))
                    .foregroundColor(output.isIncomplete ? .orange : CriticalDesign.Colors.cardBlue)
                    .tracking(1)
                
                Text(output.subhead)
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            Spacer()
            
            // Status indicator - using gold for complete, orange for incomplete
            ZStack {
                Circle()
                    .fill(output.isIncomplete ? Color.orange.opacity(0.15) : CriticalDesign.Colors.goldMid.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: output.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(output.isIncomplete ? .orange : CriticalDesign.Colors.goldDeep)
            }
            
            // Expand/collapse button
            Button(action: {
                haptic.impactOccurred()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.8) : CriticalDesign.Colors.canvas)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.08), radius: 4, x: 2, y: 2)
                            .shadow(color: Color.white.opacity(colorScheme == .dark ? 0 : 0.9), radius: 4, x: -2, y: -2)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(CriticalDesign.Spacing.md)
        .background(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            (output.isIncomplete ? Color.orange : CriticalDesign.Colors.cardBlue).opacity(0.06),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
    }
    
    // MARK: - Dose Display
    
    private func doseDisplay(_ doseLine: String) -> some View {
        VStack(alignment: .center, spacing: 6) {
            // Dose with gold gradient
            Text(doseLine)
                .font(.custom("Poppins-Bold", size: 36))
                .foregroundStyle(CriticalDesign.Colors.goldGradient)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            
            // Confidence indicator - white on dark background
            HStack(spacing: 4) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.9))
                Text("Calculated")
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, CriticalDesign.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(CriticalDesign.Colors.cardBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(CriticalDesign.Colors.goldGradient, lineWidth: 2)
                )
        )
    }
    
    // MARK: - Needs Input Display
    
    private var needsInputDisplay: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Missing input chips
            HStack(spacing: 8) {
                ForEach(output.needsInput, id: \.self) { inputKey in
                    MissingInputChip(inputKey: inputKey) {
                        if inputKey == .weightKg {
                            onWeightNeeded?()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, CriticalDesign.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(Color.orange.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Chip Row
    
    private var chipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(output.chips, id: \.self) { chip in
                    Text(chip)
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Colors.cardBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(CriticalDesign.Colors.cardBlue.opacity(0.08))
                        )
                        .overlay(
                            Capsule()
                                .stroke(CriticalDesign.Colors.cardBlue.opacity(0.15), lineWidth: 1)
                        )
                }
            }
        }
    }
    
    // MARK: - Clinical Pearls Section (Checklist)
    
    private var clinicalPearlsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "checklist")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)
                
                Text("CLINICAL PEARLS")
                    .font(.custom("Poppins-Bold", size: 11))
                    .foregroundColor(CriticalDesign.Colors.goldDeep)
                    .tracking(0.5)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(output.clinicalPearls, id: \.self) { pearl in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "circle")
                            .font(.system(size: 8))
                            .foregroundColor(CriticalDesign.Colors.goldMid)
                            .padding(.top, 5)
                        
                        Text(pearl)
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .lineSpacing(3)
                    }
                }
            }
        }
        .padding(CriticalDesign.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(CriticalDesign.Colors.goldLight.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(CriticalDesign.Colors.goldMid.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Details Section
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                
                Text("DETAILS")
                    .font(.custom("Poppins-Bold", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .tracking(0.5)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(output.details, id: \.self) { detail in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(CriticalDesign.Colors.cardBlue)
                            .padding(.top, 3)
                        
                        Text(detail)
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .lineSpacing(3)
                    }
                }
            }
        }
        .padding(CriticalDesign.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : CriticalDesign.Colors.canvas)
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.06), radius: 4, x: 2, y: 2)
                .shadow(color: Color.white.opacity(colorScheme == .dark ? 0 : 0.8), radius: 4, x: -2, y: -2)
        )
    }

    // MARK: - Warnings Section
    
    private var warningsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                
                Text("SAFETY")
                    .font(.custom("Poppins-Bold", size: 11))
                    .foregroundColor(.red)
                    .tracking(0.5)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(output.warnings, id: \.self) { warning in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                            .padding(.top, 2)
                        
                        Text(warning)
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .lineSpacing(4)
                    }
                }
            }
        }
        .padding(CriticalDesign.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(Color.red.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(Color.red.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview("Complete Card") {
    ScrollView {
        VStack(spacing: 16) {
            NLMomentCard(output: .sampleComplete)
            NLMomentCard(output: .sampleNeedsWeight)
        }
        .padding()
    }
    .background(CriticalDesign.Colors.canvas)
}
