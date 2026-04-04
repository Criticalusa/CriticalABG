//
//  CriticalLabValuesView.swift
//  CriticalX
//
//  Reference view for critical lab value ranges organized by category.
//  Color-coded bar visualizations showing normal → critical → panic zones.
//

import SwiftUI

// MARK: - Critical Lab Values View

struct CriticalLabValuesView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var searchText = ""
    @State private var isAppearing = false
    @State private var expandedLabId: UUID?
    @FocusState private var searchFieldFocused: Bool

    private let haptic = UIImpactFeedbackGenerator(style: .light)

    private var filteredGroups: [(category: CriticalLabCategory, labs: [CriticalLabRange])] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return CriticalLabDatabase.grouped
        }
        let results = CriticalLabDatabase.search(searchText)
        return CriticalLabCategory.allCases.compactMap { cat in
            let labs = results.filter { $0.category == cat }
            return labs.isEmpty ? nil : (category: cat, labs: labs)
        }
    }

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    headerSection
                    searchBar
                    labCategorySections
                    disclaimerFooter
                }
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                LiquidGlassBackButton()
            }
            ToolbarItem(placement: .principal) {
                Text("Critical Lab Values")
                    .font(.custom("Poppins-Medium", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                isAppearing = true
            }
            GlobalPatientContext.shared.showFloatingButton = false
        }
        .onDisappear {
            GlobalPatientContext.shared.showFloatingButton = true
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.accentRed.opacity(0.15))
                    .frame(width: 72, height: 72)

                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentRed)
            }
            .opacity(isAppearing ? 1 : 0)
            .scaleEffect(isAppearing ? 1 : 0.8)

            Text("Critical Lab Values")
                .font(.custom("Poppins-Light", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .opacity(isAppearing ? 1 : 0)

            Text("Values Requiring Immediate Provider Notification")
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .kerning(0.5)
                .multilineTextAlignment(.center)
                .opacity(isAppearing ? 1 : 0)

            severityLegend
                .opacity(isAppearing ? 1 : 0)
        }
        .padding(.top, 16)
        .animation(.spring(response: 0.6, dampingFraction: 0.85), value: isAppearing)
    }

    // MARK: - Severity Legend

    private var severityLegend: some View {
        HStack(spacing: 16) {
            ForEach(CriticalLabSeverity.allCases, id: \.self) { severity in
                HStack(spacing: 4) {
                    Circle()
                        .fill(severity.color)
                        .frame(width: 8, height: 8)
                    Text(severity.rawValue)
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }
        }
        .padding(.top, 4)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))

            TextField("Quick Lookup... (e.g., potassium, INR)", text: $searchText)
                .focused($searchFieldFocused)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .submitLabel(.search)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button {
                    haptic.impactOccurred()
                    searchText = ""
                    searchFieldFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(CriticalDesign.Colors.accentRed.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .accessibilityLabel("Search critical lab values")
    }

    // MARK: - Category Sections

    private var labCategorySections: some View {
        LazyVStack(spacing: 24) {
            ForEach(Array(filteredGroups.enumerated()), id: \.element.category) { index, group in
                VStack(alignment: .leading, spacing: 12) {
                    categoryHeader(group.category)

                    ForEach(group.labs) { lab in
                        CriticalLabCard(
                            lab: lab,
                            isExpanded: expandedLabId == lab.id,
                            onTap: {
                                haptic.impactOccurred()
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    expandedLabId = expandedLabId == lab.id ? nil : lab.id
                                }
                            }
                        )
                    }
                }
                .staggeredAppear(index: index, isAppearing: isAppearing, baseDelay: 0.2, staggerDelay: 0.08)
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Category Header

    private func categoryHeader(_ category: CriticalLabCategory) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.15))
                    .frame(width: 32, height: 32)

                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(category.color)
            }

            Text(category.rawValue)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Spacer()
        }
        .accessibilityLabel("\(category.rawValue) category")
    }

    // MARK: - Disclaimer

    private var disclaimerFooter: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .font(.system(size: 12))
            Text("Clinical reference tool. Follow institutional protocols for critical value notification.")
                .font(.custom("Poppins-Regular", size: 11))
        }
        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
}

// MARK: - Critical Lab Card

private struct CriticalLabCard: View {
    @Environment(\.colorScheme) var colorScheme
    let lab: CriticalLabRange
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(lab.labName)
                            .font(.custom("Poppins-Medium", size: 15))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .lineLimit(1)

                        if !lab.unit.isEmpty {
                            Text(lab.unit)
                                .font(.custom("Poppins-Regular", size: 11))
                                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        }
                    }

                    Spacer()

                    rangeChip("Normal", lab.displayRange, CriticalDesign.Colors.accentGreen)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel("\(lab.labName). Normal range \(lab.displayRange) \(lab.unit). Tap to expand.")

            if isExpanded {
                expandedContent
                    .transition(.opacity.combined(with: .scale(scale: 0.98, anchor: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? Color.white.opacity(0.08)
                        : Color.black.opacity(0.06),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 8, x: 0, y: 4)
    }

    // MARK: Range Chip

    private func rangeChip(_ label: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.12))
        )
    }

    // MARK: Expanded Content

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Rectangle()
                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
                .frame(height: 1)
                .padding(.horizontal, 16)

            rangeBarVisualization
                .padding(.horizontal, 16)

            rangeDetails
                .padding(.horizontal, 16)

            actionSection
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
        }
    }

    // MARK: Range Bar Visualization

    private var rangeBarVisualization: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("RANGE VISUALIZATION")
                .font(.custom("Poppins-SemiBold", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .kerning(1)

            GeometryReader { geo in
                let w = geo.size.width
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(panicColor.opacity(0.25))
                        .frame(width: w, height: 24)

                    let critWidth = computeCriticalWidth(total: w)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(CriticalDesign.Colors.accentOrange.opacity(0.35))
                        .frame(width: critWidth.width, height: 24)
                        .offset(x: critWidth.offset)

                    let normWidth = computeNormalWidth(total: w)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(CriticalDesign.Colors.accentGreen.opacity(0.5))
                        .frame(width: normWidth.width, height: 24)
                        .offset(x: normWidth.offset)

                    HStack {
                        Text(formatValue(lab.normalLow))
                            .font(.custom("Poppins-SemiBold", size: 9))
                            .foregroundColor(.white)
                            .offset(x: normWidth.offset + 4)
                        Spacer()
                        Text(formatValue(lab.normalHigh))
                            .font(.custom("Poppins-SemiBold", size: 9))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 4)
                }
            }
            .frame(height: 24)

            HStack(spacing: 16) {
                legendDot(CriticalDesign.Colors.accentGreen, "Normal")
                legendDot(CriticalDesign.Colors.accentOrange, "Critical")
                legendDot(panicColor, "Panic")
            }
        }
    }

    private var panicColor: Color {
        Color(red: 0.6, green: 0.0, blue: 0.1)
    }

    private func computeNormalWidth(total: CGFloat) -> (width: CGFloat, offset: CGFloat) {
        let lo = effectiveLow
        let hi = effectiveHigh
        let range = hi - lo
        guard range > 0 else { return (total * 0.4, total * 0.3) }
        let w = CGFloat((lab.normalHigh - lab.normalLow) / range) * total
        let off = CGFloat((lab.normalLow - lo) / range) * total
        return (max(w, 20), off)
    }

    private func computeCriticalWidth(total: CGFloat) -> (width: CGFloat, offset: CGFloat) {
        let lo = effectiveLow
        let hi = effectiveHigh
        let range = hi - lo
        guard range > 0 else { return (total * 0.6, total * 0.2) }
        let cLow = lab.criticalLow ?? lab.normalLow
        let cHigh = lab.criticalHigh ?? lab.normalHigh
        let w = CGFloat((cHigh - cLow) / range) * total
        let off = CGFloat((cLow - lo) / range) * total
        return (max(w, 30), off)
    }

    private var effectiveLow: Double {
        let candidates = [lab.panicLow, lab.criticalLow, lab.normalLow].compactMap { $0 ?? nil }
        let min = ([lab.normalLow] + candidates).min() ?? lab.normalLow
        return min - (lab.normalHigh - lab.normalLow) * 0.1
    }

    private var effectiveHigh: Double {
        let candidates = [lab.panicHigh, lab.criticalHigh, lab.normalHigh].compactMap { $0 ?? nil }
        let max = ([lab.normalHigh] + candidates).max() ?? lab.normalHigh
        return max + (lab.normalHigh - lab.normalLow) * 0.1
    }

    private func legendDot(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(label)
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
    }

    // MARK: Range Details

    private var rangeDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            rangeRow("Normal Range", lab.displayRange, lab.unit, CriticalDesign.Colors.accentGreen)

            if !lab.criticalRange.isEmpty {
                rangeRow("Critical", lab.criticalRange, lab.unit, CriticalDesign.Colors.accentOrange)
            }
            if !lab.panicRange.isEmpty {
                rangeRow("Panic", lab.panicRange, lab.unit, panicColor)
            }
        }
    }

    private func rangeRow(_ label: String, _ value: String, _ unit: String, _ color: Color) -> some View {
        HStack {
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 3, height: 20)

                Text(label)
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Spacer()

            Text("\(value) \(unit)")
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(color)
        }
    }

    // MARK: Action Section

    private var actionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NURSING ACTION")
                .font(.custom("Poppins-SemiBold", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .kerning(1)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "stethoscope")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.accentRed)
                    .frame(width: 20)

                Text(lab.notifyMessage)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(CriticalDesign.Colors.accentRed.opacity(0.08))
            )
        }
    }

    // MARK: Helpers

    private func formatValue(_ v: Double) -> String {
        v.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", v) : String(format: "%.2g", v)
    }
}

// MARK: - Preview

struct CriticalLabValuesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CriticalLabValuesView()
        }
    }
}
