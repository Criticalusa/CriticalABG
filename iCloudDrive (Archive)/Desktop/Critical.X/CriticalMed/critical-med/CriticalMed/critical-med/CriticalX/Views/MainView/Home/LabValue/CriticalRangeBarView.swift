//
//  CriticalRangeBarView.swift
//  CriticalX
//
//  Reusable horizontal color-coded range bar for lab values.
//  Shows Normal (green), Critical (orange), and Panic (red) zones
//  with labeled boundary values and nursing actions.
//

import SwiftUI

// MARK: - Lab Name Matching

extension CriticalLabDatabase {

    /// Fuzzy-matches a BtnDataModel to a CriticalLabRange by title and subtitle.
    static func match(title: String, subtitle: String) -> CriticalLabRange? {
        let t = title.lowercased()
        let s = subtitle.lowercased()

        // Direct match on labName
        if let exact = ranges.first(where: { $0.labName.lowercased() == t }) {
            return exact
        }

        // Subtitle exact match (e.g. subtitle "INR" → labName "INR")
        if let sub = ranges.first(where: { $0.labName.lowercased() == s }) {
            return sub
        }

        // Title contains labName (e.g. "Serum Sodium" contains "Sodium")
        if let contains = ranges.first(where: { t.contains($0.labName.lowercased()) }) {
            return contains
        }

        // labName contains title word (e.g. "Troponin I" in "Troponin I (Standard)")
        if let reverse = ranges.first(where: { t.contains($0.labName.lowercased().components(separatedBy: " ").first ?? "") && $0.labName.lowercased().components(separatedBy: " ").first?.count ?? 0 > 2 }) {
            return reverse
        }

        // Known alias mappings for tricky lab names
        let aliases: [String: String] = [
            "serum sodium": "Sodium",
            "serum magnesium": "Magnesium",
            "serum phosphorus": "Phosphorus",
            "serum bicarbonate hco3-": "HCO3",
            "partial pressure arterial co2": "pCO2",
            "partial pressure arterial o2": "pO2",
            "potential hydrogen": "pH",
            "b-type natriuretic peptide (bnp)": "BNP",
            "creatine kinase-mb": "CK-MB",
            "troponin i (standard)": "Troponin I",
            "international normalized ratio": "INR",
            "partial thromboplastin time": "PTT",
            "blood urea nitrogen": "BUN",
            "carbon dioxide": "Bicarbonate (CO2)",
            "calcium": "Calcium (Total)",
            "total bilirubin": "Total Bilirubin",
            "alkaline phosphatase": "Alkaline Phosphatase",
            "alanine aminotransferase": "ALT",
            "aspartate aminotransferase": "AST",
        ]

        if let mapped = aliases[t], let result = lookup(mapped) {
            return result
        }

        return nil
    }
}

// MARK: - Range Zone Model

private struct RangeZone: Identifiable {
    let id = UUID()
    let label: String
    let color: Color
    let startValue: Double
    let endValue: Double
}

// MARK: - Critical Range Bar View

struct CriticalRangeBarView: View {
    @Environment(\.colorScheme) var colorScheme
    let labRange: CriticalLabRange

    private let barHeight: CGFloat = 28
    private let cornerRadius: CGFloat = 8

    private var zones: [RangeZone] {
        buildZones()
    }

    private var displayMin: Double {
        let candidates = [
            labRange.panicLow,
            labRange.criticalLow,
            labRange.normalLow
        ].compactMap { $0 }
        let minVal = candidates.min() ?? labRange.normalLow
        let span = labRange.normalHigh - labRange.normalLow
        return minVal - max(span * 0.15, 1)
    }

    private var displayMax: Double {
        let candidates = [
            labRange.panicHigh,
            labRange.criticalHigh,
            labRange.normalHigh
        ].compactMap { $0 }
        let maxVal = candidates.max() ?? labRange.normalHigh
        let span = labRange.normalHigh - labRange.normalLow
        return maxVal + max(span * 0.15, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title row
            HStack(spacing: 10) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(CriticalDesign.Colors.accentOrange)

                Text("Range Visualization")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(colorScheme == .dark ? .white : .black)

                Spacer()

                Text(labRange.unit)
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.5))
            }

            // Color-coded bar
            GeometryReader { geo in
                let totalWidth = geo.size.width
                let totalRange = displayMax - displayMin

                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill((colorScheme == .dark ? Color.white : Color.black).opacity(0.06))
                        .frame(height: barHeight)

                    // Zone segments
                    HStack(spacing: 0) {
                        ForEach(zones) { zone in
                            let fraction = (zone.endValue - zone.startValue) / totalRange
                            let segmentWidth = max(totalWidth * fraction, 2)

                            Rectangle()
                                .fill(zone.color.opacity(0.85))
                                .frame(width: segmentWidth, height: barHeight)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

                    // Boundary tick marks and labels
                    boundaryMarkers(totalWidth: totalWidth, totalRange: totalRange)
                }
            }
            .frame(height: barHeight + 34)

            // Legend
            legendRow
        }
    }

    // MARK: - Boundary Markers

    @ViewBuilder
    private func boundaryMarkers(totalWidth: CGFloat, totalRange: Double) -> some View {
        let boundaries = collectBoundaries()

        ForEach(Array(boundaries.enumerated()), id: \.offset) { _, boundary in
            let xPos = totalWidth * ((boundary.value - displayMin) / totalRange)

            VStack(spacing: 2) {
                Rectangle()
                    .fill((colorScheme == .dark ? Color.white : Color.black).opacity(0.4))
                    .frame(width: 1, height: barHeight + 4)

                Text(formatValue(boundary.value))
                    .font(.custom("Poppins-Medium", size: 9))
                    .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.6))
                    .lineLimit(1)
                    .fixedSize()
            }
            .position(x: clampPosition(xPos, totalWidth: totalWidth), y: (barHeight + 34) / 2)
        }
    }

    private func clampPosition(_ x: CGFloat, totalWidth: CGFloat) -> CGFloat {
        min(max(x, 16), totalWidth - 16)
    }

    // MARK: - Legend

    private var legendRow: some View {
        HStack(spacing: 16) {
            legendDot(color: CriticalDesign.Colors.accentGreen, label: "Normal")
            if labRange.criticalLow != nil || labRange.criticalHigh != nil {
                legendDot(color: CriticalDesign.Colors.accentOrange, label: "Critical")
            }
            if labRange.panicLow != nil || labRange.panicHigh != nil {
                legendDot(color: CriticalDesign.Colors.accentRed, label: "Panic")
            }
            Spacer()
        }
    }

    private func legendDot(color: Color, label: String) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.5))
        }
    }

    // MARK: - Zone Building

    private func buildZones() -> [RangeZone] {
        var result: [RangeZone] = []
        var cursor = displayMin

        // Panic low
        if let pLow = labRange.panicLow {
            result.append(RangeZone(label: "Panic Low", color: CriticalDesign.Colors.accentRed, startValue: cursor, endValue: pLow))
            cursor = pLow
        }

        // Critical low
        if let cLow = labRange.criticalLow {
            if cursor < cLow {
                result.append(RangeZone(label: "Critical Low", color: CriticalDesign.Colors.accentOrange, startValue: cursor, endValue: cLow))
                cursor = cLow
            }
        }

        // Abnormal low (between critical/panic boundary and normal low)
        if cursor < labRange.normalLow {
            result.append(RangeZone(label: "Abnormal Low", color: CriticalDesign.Colors.accentOrange.opacity(0.6), startValue: cursor, endValue: labRange.normalLow))
            cursor = labRange.normalLow
        }

        // Normal
        result.append(RangeZone(label: "Normal", color: CriticalDesign.Colors.accentGreen, startValue: labRange.normalLow, endValue: labRange.normalHigh))
        cursor = labRange.normalHigh

        // Abnormal high (between normal high and critical high)
        if let cHigh = labRange.criticalHigh, cursor < cHigh {
            result.append(RangeZone(label: "Abnormal High", color: CriticalDesign.Colors.accentOrange.opacity(0.6), startValue: cursor, endValue: cHigh))
            cursor = cHigh
        }

        // Critical high (when there's panic high too)
        if let pHigh = labRange.panicHigh, let cHigh = labRange.criticalHigh, cHigh < pHigh {
            result.append(RangeZone(label: "Critical High", color: CriticalDesign.Colors.accentOrange, startValue: cursor, endValue: pHigh))
            cursor = pHigh
        }

        // Panic high
        if cursor < displayMax {
            let hasPanic = labRange.panicHigh != nil
            let hasCritical = labRange.criticalHigh != nil
            let color: Color = hasPanic ? CriticalDesign.Colors.accentRed :
                                hasCritical ? CriticalDesign.Colors.accentOrange :
                                (colorScheme == .dark ? Color.white : Color.black).opacity(0.06)
            result.append(RangeZone(label: "High", color: color, startValue: cursor, endValue: displayMax))
        }

        return result
    }

    // MARK: - Boundaries

    private struct Boundary {
        let value: Double
        let label: String
    }

    private func collectBoundaries() -> [Boundary] {
        var boundaries: [Boundary] = []

        if let pLow = labRange.panicLow { boundaries.append(Boundary(value: pLow, label: "Panic")) }
        if let cLow = labRange.criticalLow { boundaries.append(Boundary(value: cLow, label: "Crit")) }
        boundaries.append(Boundary(value: labRange.normalLow, label: "Low"))
        boundaries.append(Boundary(value: labRange.normalHigh, label: "High"))
        if let cHigh = labRange.criticalHigh { boundaries.append(Boundary(value: cHigh, label: "Crit")) }
        if let pHigh = labRange.panicHigh { boundaries.append(Boundary(value: pHigh, label: "Panic")) }

        // Deduplicate boundaries that are too close
        var filtered: [Boundary] = []
        let totalRange = displayMax - displayMin
        for b in boundaries.sorted(by: { $0.value < $1.value }) {
            if let last = filtered.last, (b.value - last.value) / totalRange < 0.04 {
                continue
            }
            filtered.append(b)
        }

        return filtered
    }

    // MARK: - Formatting

    private func formatValue(_ v: Double) -> String {
        if v.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", v)
        } else if abs(v) < 1 {
            return String(format: "%.2f", v)
        } else {
            return String(format: "%.1f", v)
        }
    }
}

// MARK: - Critical Range Detail Card

/// Full card wrapping the range bar with nursing action, styled to match the app's card system.
struct CriticalRangeCard: View {
    @Environment(\.colorScheme) var colorScheme
    let labRange: CriticalLabRange
    let isAppearing: Bool
    let animationDelay: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Range Bar
            CriticalRangeBarView(labRange: labRange)

            // Separator
            Rectangle()
                .fill((colorScheme == .dark ? Color.white : Color.black).opacity(0.08))
                .frame(height: 0.5)

            // Range Summary
            rangeSummaryRow

            // Separator
            Rectangle()
                .fill((colorScheme == .dark ? Color.white : Color.black).opacity(0.08))
                .frame(height: 0.5)

            // Nursing Action
            nursingActionSection
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .overlay(cardStroke)
        .shadow(color: CriticalDesign.Colors.accentOrange.opacity(colorScheme == .dark ? 0 : 0.08), radius: 12, y: 6)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(animationDelay), value: isAppearing)
    }

    // MARK: - Range Summary

    private var rangeSummaryRow: some View {
        HStack(spacing: 0) {
            rangeColumn(
                label: "Normal",
                value: labRange.displayRange,
                color: CriticalDesign.Colors.accentGreen
            )

            if !labRange.criticalRange.isEmpty {
                divider
                rangeColumn(
                    label: "Critical",
                    value: labRange.criticalRange,
                    color: CriticalDesign.Colors.accentOrange
                )
            }

            if !labRange.panicRange.isEmpty {
                divider
                rangeColumn(
                    label: "Panic",
                    value: labRange.panicRange,
                    color: CriticalDesign.Colors.accentRed
                )
            }
        }
    }

    private func rangeColumn(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(label)
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill((colorScheme == .dark ? Color.white : Color.black).opacity(0.1))
            .frame(width: 0.5, height: 32)
    }

    // MARK: - Nursing Action

    private var nursingActionSection: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "stethoscope")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(CriticalDesign.Colors.accentOrange)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 6) {
                Text("Nursing Action")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Colors.accentOrange)

                Text(labRange.notifyMessage)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Card Styling

    @ViewBuilder
    private var cardBackground: some View {
        if colorScheme == .dark {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
        } else {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(CriticalDesign.Colors.accentOrange.opacity(0.2), lineWidth: 1)
                )
        }
    }

    @ViewBuilder
    private var cardStroke: some View {
        RoundedRectangle(cornerRadius: 20)
            .strokeBorder(
                CriticalDesign.Colors.accentOrange.opacity(colorScheme == .dark ? 0.25 : 0),
                lineWidth: 1
            )
    }
}

// MARK: - Preview

struct CriticalRangeBarView_Previews: PreviewProvider {
    static var previews: some View {
        let potassium = CriticalLabDatabase.lookup("Potassium")!

        ScrollView {
            VStack(spacing: 20) {
                CriticalRangeCard(
                    labRange: potassium,
                    isAppearing: true,
                    animationDelay: 0
                )
            }
            .padding(20)
        }
        .background(Color(red: 0.96, green: 0.97, blue: 1.0).ignoresSafeArea())
        .previewDisplayName("Light")

        ScrollView {
            VStack(spacing: 20) {
                CriticalRangeCard(
                    labRange: potassium,
                    isAppearing: true,
                    animationDelay: 0
                )
            }
            .padding(20)
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark")
    }
}
