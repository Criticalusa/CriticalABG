//
//  NLMomentCard.swift
//  CriticalX
//
//  Natural Language Moment Search - Moment Card
//  Displays a computed moment output with dose, details, and safety guardrails
//  Premium design: Gold gradient strokes, navy surface, CriticalDesign tokens
//

import SwiftUI

// MARK: - NLMomentCard
/// Card displaying a computed moment output
/// Collapsed by default with semantic blue/green section differentiation
struct NLMomentCard: View {
    @Environment(\.colorScheme) var colorScheme

    let output: NLMomentOutput
    var isOffline: Bool = false
    var onWeightNeeded: (() -> Void)?

    @State private var isExpanded: Bool = false  // Collapsed by default - Ive 2030
    @State private var showCheckmark: Bool = false  // Checkmark animation
    @State private var dotPulse: Bool = false  // Status dot pulse
    @State private var labScaleAppeared: Bool = false  // Drives lab scale entrance animation

    private let haptic = UIImpactFeedbackGenerator(style: .light)
    
    /// True when this moment is pediatric — used to single out peds cards with Peds-style stroke.
    private var isPediatricCard: Bool {
        output.momentId.contains("peds") || output.tags.contains("peds")
    }
    
    /// Lab moments use a more subtle stroke; others use type-based accent.
    private var isLabCard: Bool {
        output.momentId == "lab_intelligence" || output.tags.contains("lab value")
    }
    
    /// Stroke for card outline: subtle so it doesn't dominate; lab = softest, others = tinted accent.
    private var strokeColor: Color {
        if output.isIncomplete { return Color.orange.opacity(0.6) }
        if isLabCard { return CriticalDesign.Colors.navyAccent.opacity(colorScheme == .dark ? 0.2 : 0.12) }
        return accentColor.opacity(colorScheme == .dark ? 0.4 : 0.32)
    }
    
    private var strokeLineWidth: CGFloat { 1 }
    
    // Accent color based on moment type — each type gets its own stroke on the card
    private var accentColor: Color {
        // Pediatric moments → purple
        if output.momentId.contains("peds") {
            return CriticalDesign.Colors.accentPurple
        }
        // Conversion moments → teal
        if output.momentId.contains("conversion") {
            return CriticalDesign.Colors.accentTeal
        }
        // Anaphylaxis / allergy → orange
        if output.momentId.contains("anaphylaxis") || output.tags.contains("anaphylaxis") {
            return CriticalDesign.Colors.accentOrange
        }
        // Cardiac / arrest / VF / SVT / antiarrhythmic → green
        if output.momentId.contains("arrest") || output.momentId.contains("vf") || output.momentId.contains("svt")
            || output.momentId.contains("cardiac") || output.momentId.contains("antiarrhythmic")
            || output.momentId.contains("adenosine") || output.momentId.contains("amiodarone")
            || output.momentId.contains("bradycardia") || output.tags.contains("cardiac") {
            return CriticalDesign.Colors.accentGreen
        }
        // RSI / induction / airway → teal
        if output.momentId.contains("rsi") || output.momentId.contains("induction") || output.momentId.contains("airway") {
            return CriticalDesign.Colors.accentTeal
        }
        // Drug dosing / vasoactive / infusion → blue
        if output.tags.contains("drug") || output.tags.contains("dosing") || output.momentId.contains("infusion")
            || output.momentId.contains("norepinephrine") || output.momentId.contains("epinephrine") {
            return CriticalDesign.Colors.accentBlue
        }
        // Default → blue
        return CriticalDesign.Colors.accentBlue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Minimal header
            cardHeader

            // Main content - generous breathing room
            VStack(alignment: .leading, spacing: 20) {
                // Weight plausibility warning — shows when dose IS calculated but weight seems off
                if let warning = output.weightWarning {
                    weightWarningBanner(warning)
                }

                // Dose display - the hero
                if let doseLine = output.doseLine {
                    doseDisplay(doseLine)
                } else if output.isIncomplete {
                    needsInputDisplay
                }
                
                // Lab scale diagram: normal range + where value sits
                if let scale = output.labScaleData {
                    labScaleDiagram(scale, appeared: $labScaleAppeared)
                }

                // Chips row - quiet tags
                if !output.chips.isEmpty {
                    chipRow
                }

                // Clinical Pearls - minimal list
                if isExpanded && !output.clinicalPearls.isEmpty {
                    clinicalPearlsSection
                }

                // Details - minimal list
                if isExpanded && !output.details.isEmpty {
                    detailsSection
                }

                // Max dose warning - red alert when dose exceeds safe max
                if let maxWarn = output.maxDoseWarning {
                    maxDoseWarningBanner(maxWarn)
                }

                // Renal/hepatic flag
                if let renalFlag = output.renalHepatic {
                    renalHepaticFlag(renalFlag)
                }

                // Warnings - subtle alert
                if isExpanded && !output.warnings.isEmpty {
                    warningsSection
                }

                // Disclaimer footer - always visible on drug dosing cards
                if output.showDisclaimer {
                    disclaimerFooter
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colorScheme == .dark
                      ? CriticalDesign.Colors.cardBlue
                      : Color.white)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(strokeColor, lineWidth: strokeLineWidth)
        )
        .shadow(
            color: isLabCard ? Color.black.opacity(colorScheme == .dark ? 0.15 : 0.06) : accentColor.opacity(0.12),
            radius: isLabCard ? 8 : 12,
            y: 6
        )
    }

    // MARK: - Card Header
    /// Clean, confident. Accent-colored strokes, navy surface.

    private var cardHeader: some View {
        HStack(alignment: .top, spacing: 12) {
            // Minimal status dot with pulse animation
            Circle()
                .fill(output.isIncomplete ? Color.orange : Color.green.opacity(0.6))
                .frame(width: 6, height: 6)
                .scaleEffect(dotPulse ? 1.3 : 1.0)
                .opacity(dotPulse ? 0.7 : 1.0)
                .padding(.top, 6)  // Align with first line of text
                .onAppear {
                    // Pulse once when card appears
                    withAnimation(.easeInOut(duration: 0.6).delay(0.2)) {
                        dotPulse = true
                    }
                    withAnimation(.easeInOut(duration: 0.6).delay(0.8)) {
                        dotPulse = false
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                // Micro-label
                Text(output.headline.uppercased())
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary.opacity(0.7))
                    .tracking(1.2)
                    .lineLimit(1)

                // Title - clean, readable, multiline support
                Text(output.subhead)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)  // Allow multiline
                    .lineLimit(3)  // Max 3 lines
            }

            Spacer()
            
            // OPTION 4: Collapsed badge (uncomment to enable)
            // Shows tiny monogram when card is collapsed
            /*
            if !isExpanded {
                Image("LogoMonogram")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .opacity(0.3)
                    .padding(.trailing, 4)
                    .padding(.top, 2)
            }
            */

            // Minimal expand button
            Button(action: {
                haptic.impactOccurred()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary.opacity(0.6))
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 2)  // Align with text
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        // No background separator - seamless 2030 design
    }

    // MARK: - Dose Display (Ive Minimalism)
    /// "Simplicity is the ultimate sophistication"
    /// The dose is the content. Nothing competes with it.

    private func doseDisplay(_ doseLine: String) -> some View {
        VStack(alignment: .center, spacing: 12) {
            // Dose - neutral, no color (Jony Ive 2030: let the content be the content)
            Text(doseLine)
                .font(.system(size: 42, weight: .thin, design: .rounded))
                .foregroundColor(.primary)  // Back to neutral
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            // Minimal status with logo badge and checkmark
            VStack(spacing: 6) {
                HStack(spacing: 6) {
                    Text("Calculated")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary.opacity(0.6))
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    // Animated checkmark - subtle green
                    if showCheckmark {
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(Color.green.opacity(0.6))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                
                // CM monogram - larger and full opacity
                Image("LogoMonogram")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .opacity(1.0)  // Full opacity
            }
            .onAppear {
                // Checkmark draws in after brief delay
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.5)) {
                    showCheckmark = true
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colorScheme == .dark
                      ? CriticalDesign.Colors.darkCanvas.opacity(0.4)
                      : Color(UIColor.systemGray6).opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    CriticalDesign.Adaptive.cardStroke(for: colorScheme),
                    lineWidth: 0.5
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
                        if inputKey == .weightKg || inputKey == .weightConfirmation {
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

    // MARK: - Weight Warning Banner

    private func weightWarningBanner(_ message: String) -> some View {
        Button(action: { onWeightNeeded?() }) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.orange)

                Text(message)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .multilineTextAlignment(.leading)

                Spacer()

                Text("Edit")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.orange)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.orange.opacity(colorScheme == .dark ? 0.08 : 0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Color.orange.opacity(colorScheme == .dark ? 0.3 : 0.25), lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Lab Scale Diagram
    /// Horizontal scale showing normal range and where the lab value sits.
    private func labScaleDiagram(_ scale: LabScaleData, appeared: Binding<Bool>) -> some View {
        let rangeMin = min(scale.normalLow, scale.value) - max(0.1 * (scale.normalHigh - scale.normalLow), 0.5)
        let rangeMax = max(scale.normalHigh, scale.value) + max(0.1 * (scale.normalHigh - scale.normalLow), 0.5)
        let span = rangeMax - rangeMin
        let normalStart = (scale.normalLow - rangeMin) / span
        let normalEnd = (scale.normalHigh - rangeMin) / span
        let valuePos = (scale.value - rangeMin) / span
        
        let header = labScaleHeader
        let bar = labScaleBar(normalStart: normalStart, normalEnd: normalEnd, valuePos: valuePos, appeared: appeared.wrappedValue)
        let labels = labScaleLabels(scale: scale, rangeMin: rangeMin, rangeMax: rangeMax)
        let scaleBg = labScaleBackground
        let scaleStroke = labScaleStrokeColor
        
        return VStack(alignment: .leading, spacing: 12) {
            header
            bar
            labels
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(scaleBg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(scaleStroke, lineWidth: 1)
        )
        .onAppear {
            withAnimation(.spring(response: 0.75, dampingFraction: 0.82)) {
                appeared.wrappedValue = true
            }
        }
        .onChange(of: output.id) { _ in
            appeared.wrappedValue = false
        }
    }
    
    /// Cool gray/blue-gray; no red tint (offline uses same as online).
    private var labScaleBackground: Color {
        return colorScheme == .dark
            ? Color(white: 0.16)
            : Color(red: 0.97, green: 0.98, blue: 1.0)
    }
    
    private var labScaleStrokeColor: Color {
        return CriticalDesign.Colors.navyAccent.opacity(colorScheme == .dark ? 0.12 : 0.08)
    }
    
    private var labScaleHeader: some View {
        Text("Reference scale")
            .font(.custom("Poppins-SemiBold", size: 11))
            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            .textCase(.uppercase)
            .tracking(0.8)
    }
    
    /// Single green for the whole scale — track and normal range use same hue for a matched look.
    private static let labScaleGreen = Color(red: 0.22, green: 0.55, blue: 0.45)
    
    private func labScaleBar(normalStart: Double, normalEnd: Double, valuePos: Double, appeared: Bool) -> some View {
        let trackOpacity = colorScheme == .dark ? 0.14 : 0.08
        let fillOpacity = colorScheme == .dark ? 0.5 : 0.38
        let markerColor: Color = valuePos < normalStart || valuePos > normalEnd
            ? CriticalDesign.Colors.accentOrange
            : CriticalDesign.Colors.accentTeal
        let progress: CGFloat = appeared ? 1 : 0
        let h: CGFloat = 14
        
        return GeometryReader { geo in
            let w = geo.size.width
            let x0 = normalStart * w
            let x1 = normalEnd * w
            let segmentWidth = max(x1 - x0, 6)
            let mx = valuePos * w
            let clamped = min(max(mx, 8), w - 8)
            let dotCenterX = clamped - 7
            let dotCenterY: CGFloat = (h - 14) / 2
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: h/2, style: .continuous)
                    .fill(Self.labScaleGreen.opacity(trackOpacity))
                    .frame(height: h)
                RoundedRectangle(cornerRadius: h/2 - 1.5, style: .continuous)
                    .fill(Self.labScaleGreen.opacity(fillOpacity))
                    .frame(width: segmentWidth * progress, height: h - 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: h/2 - 1.5, style: .continuous)
                            .stroke(Self.labScaleGreen.opacity(0.35), lineWidth: 0.5)
                    )
                    .offset(x: x0 + 1.5, y: 1.5)
                Circle()
                    .fill(markerColor)
                    .frame(width: 14, height: 14)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(color: Color.black.opacity(0.12), radius: 2, x: 0, y: 1)
                    .offset(x: dotCenterX * progress, y: dotCenterY)
            }
            .animation(.spring(response: 0.75, dampingFraction: 0.82), value: appeared)
        }
        .frame(height: 28)
    }
    
    private func labScaleLabels(scale: LabScaleData, rangeMin: Double, rangeMax: Double) -> some View {
        func format(_ v: Double) -> String {
            if v >= 100 || (v < 1 && v > 0) { return String(format: "%.1f", v) }
            if v == floor(v) { return String(format: "%.0f", v) }
            return String(format: "%.2f", v)
        }
        let unitSuffix = scale.unit.isEmpty ? "" : " " + scale.unit
        let minText = format(rangeMin) + unitSuffix
        let maxText = format(rangeMax) + unitSuffix
        let normalText = "Normal " + format(scale.normalLow) + "–" + format(scale.normalHigh) + unitSuffix
        
        let minColor: Color = isOffline ? CriticalDesign.Colors.accentRed : CriticalDesign.Adaptive.textTertiary(for: colorScheme)
        let normalColor = colorScheme == .dark
            ? Self.labScaleGreen.opacity(0.9)
            : Self.labScaleGreen.opacity(0.75)
        return HStack(spacing: 8) {
            Text(minText)
                .font(.custom("Poppins-Regular", size: 11))
                .foregroundColor(minColor)
            Spacer(minLength: 4)
            Text(normalText)
                .font(.custom("Poppins-Medium", size: 11))
                .foregroundColor(normalColor)
            Spacer(minLength: 4)
            Text(maxText)
                .font(.custom("Poppins-Regular", size: 11))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Chip Row (Minimal Pills)
    /// Simple, quiet information tags. No decoration.

    private var chipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(output.chips.enumerated()), id: \.offset) { index, chip in
                    Text(chip)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(chipColor(for: index))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(chipBackground(for: index))
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(chipBorder(for: index), lineWidth: 0.5)
                        )
                }
            }
        }
    }
    
    // Chip colors — uses card's accent color for consistency
    private func chipColor(for index: Int) -> Color {
        if colorScheme == .dark {
            return CriticalDesign.Adaptive.textSecondary(for: colorScheme)
        } else {
            return CriticalDesign.Adaptive.textSecondary(for: colorScheme)
        }
    }

    private func chipBackground(for index: Int) -> Color {
        if colorScheme == .dark {
            return accentColor.opacity(0.08)
        } else {
            return accentColor.opacity(0.05)
        }
    }

    private func chipBorder(for index: Int) -> Color {
        return accentColor.opacity(colorScheme == .dark ? 0.2 : 0.15)
    }

    // MARK: - Clinical Pearls Section (Minimal)
    /// "Every element must have a reason to exist."
    /// No banners, no icons, no decoration. Just the information.

    private var clinicalPearlsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Micro-label - quiet hierarchy with blue accent
            Text("DETAILS")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(CriticalDesign.Colors.accentBlue.opacity(0.7))
                .tracking(1.2)
                .textCase(.uppercase)

            // Pearl items - clean list
            VStack(alignment: .leading, spacing: 10) {
                ForEach(output.clinicalPearls, id: \.self) { pearl in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(CriticalDesign.Colors.accentBlue.opacity(0.4))
                            .frame(width: 4, height: 4)
                            .padding(.top, 7)

                        Text(pearl)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.primary)
                            .lineSpacing(5)
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(colorScheme == .dark
                    ? CriticalDesign.Colors.accentBlue.opacity(0.06)
                    : CriticalDesign.Colors.accentBlue.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(
                    CriticalDesign.Colors.accentBlue.opacity(colorScheme == .dark ? 0.15 : 0.12),
                    lineWidth: 0.5
                )
        )
    }

    // MARK: - Details Section

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CONVERSION")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(CriticalDesign.Colors.accentGreen.opacity(0.7))
                .tracking(1.2)
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(output.details, id: \.self) { detail in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(CriticalDesign.Colors.accentGreen.opacity(0.4))
                            .frame(width: 4, height: 4)
                            .padding(.top, 7)

                        Text(detail)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.primary)
                            .lineSpacing(5)
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(colorScheme == .dark
                    ? CriticalDesign.Colors.accentGreen.opacity(0.06)
                    : CriticalDesign.Colors.accentGreen.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(
                    CriticalDesign.Colors.accentGreen.opacity(colorScheme == .dark ? 0.15 : 0.12),
                    lineWidth: 0.5
                )
        )
    }

    // MARK: - Warnings Section

    private var warningsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SAFETY")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(Color.orange.opacity(0.8))
                .tracking(1.2)
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(output.warnings, id: \.self) { warning in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(Color.orange.opacity(0.5))
                            .frame(width: 4, height: 4)
                            .padding(.top, 7)

                        Text(warning)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.primary)
                            .lineSpacing(5)
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.orange.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(
                    Color.orange.opacity(0.2),
                    lineWidth: 0.5
                )
        )
    }
    // MARK: - Max Dose Warning

    private func maxDoseWarningBanner(_ message: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.octagon.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)

            Text(message)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.red.opacity(colorScheme == .dark ? 0.08 : 0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.red.opacity(colorScheme == .dark ? 0.3 : 0.25), lineWidth: 1.5)
        )
    }

    // MARK: - Renal/Hepatic Flag

    private func renalHepaticFlag(_ message: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "kidney.fill")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(CriticalDesign.Colors.accentTeal)

            Text(message)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(CriticalDesign.Colors.accentTeal.opacity(colorScheme == .dark ? 0.06 : 0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(CriticalDesign.Colors.accentTeal.opacity(0.2), lineWidth: 0.5)
        )
    }

    // MARK: - Disclaimer Footer

    private var disclaimerFooter: some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary.opacity(0.4))

            Text("Verify all doses independently. Not a substitute for clinical judgment.")
                .font(.system(size: 10, weight: .regular, design: .rounded))
                .foregroundColor(.secondary.opacity(0.4))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
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
