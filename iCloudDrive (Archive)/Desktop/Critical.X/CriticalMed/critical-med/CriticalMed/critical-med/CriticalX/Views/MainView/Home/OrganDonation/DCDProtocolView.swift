//
//  DCDProtocolView.swift
//  CriticalX
//
//  Donation after Circulatory Death (DCD) Protocol
//  Comprehensive reference and tracking tool for transplant coordinators
//
//  Redesigned with Premium Light Glass design
//

import SwiftUI
import UIKit

// MARK: - Recoverable Organ
enum DCDRecoverableOrgan: String, CaseIterable, Identifiable {
    case kidneyLeft = "L Kidney"
    case kidneyRight = "R Kidney"
    case liver = "Liver"
    case lungLeft = "L Lung"
    case lungRight = "R Lung"
    case pancreas = "Pancreas"
    case heart = "Heart"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .kidneyLeft, .kidneyRight: return "drop.fill"
        case .liver: return "rectangle.fill"
        case .lungLeft, .lungRight: return "wind"
        case .pancreas: return "cross.vial.fill"
        case .heart: return "heart.fill"
        }
    }

    var warmIschemiaLimit: String {
        switch self {
        case .kidneyLeft, .kidneyRight: return "60 min"
        case .liver: return "30 min"
        case .lungLeft, .lungRight: return "60 min"
        case .pancreas: return "30 min"
        case .heart: return "Emerging"
        }
    }

    var color: Color {
        switch self {
        case .kidneyLeft, .kidneyRight: return .orange
        case .liver: return Color(red: 0.55, green: 0.35, blue: 0.25) // Warm brown
        case .lungLeft, .lungRight: return Color(red: 0.20, green: 0.50, blue: 0.70) // Rich blue
        case .pancreas: return Color(red: 0.70, green: 0.45, blue: 0.55) // Dusty rose
        case .heart: return .red
        }
    }
}

// MARK: - Main DCD Protocol View
struct DCDProtocolView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    // Timeline tracking
    @State private var withdrawalTime: Date?
    @State private var asystoleTime: Date?
    @State private var deathDeclaredTime: Date?
    @State private var incisionTime: Date?

    // Warm ischemia timer
    @State private var timerRunning = false
    @State private var elapsedSeconds: Int = 0
    @State private var timer: Timer?

    // Organ recovery tracking
    @State private var recoveredOrgans: [DCDRecoverableOrgan: Date] = [:]

    // Customizable checklist
    @AppStorage("dcdCustomChecklistItems") private var customChecklistData: Data = Data()
    @State private var customChecklistItems: [String] = []
    @State private var showAddItemSheet = false
    @State private var newItemText = ""

    // Editable warm ischemia limits (in minutes)
    @AppStorage("dcdKidneyWIT") private var kidneyWIT: Int = 60
    @AppStorage("dcdLiverWIT") private var liverWIT: Int = 30
    @AppStorage("dcdLungWIT") private var lungWIT: Int = 60
    @AppStorage("dcdPancreasWIT") private var pancreasWIT: Int = 30
    @AppStorage("dcdHeartWIT") private var heartWIT: Int = 0
    @State private var showWITSettings = false

    // UI State
    @State private var isAppearing = false
    @State private var expandedSection: String?

    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15)
    }

    private var textSecondary: Color {
        colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.3, green: 0.3, blue: 0.4)
    }

    private var cardBackground: Color {
        colorScheme == .dark ? Color(red: 0.09, green: 0.15, blue: 0.24) : Color.white
    }

    var body: some View {
        ZStack {
            // Background
            backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Close button
                    closeButtonRow

                    // Hero Header with Timer
                    heroHeaderWithTimer

                    // Educational Overview
                    dcdOverviewCard

                    // DCD vs DBD Comparison
                    comparisonCard

                    // Editable Warm Ischemia Limits
                    warmIschemiaLimitsCard

                    // Phase 1: Withdrawal
                    withdrawalPhaseCard

                    // Phase 2: Death Declaration
                    deathDeclarationCard

                    // Phase 3: Procurement
                    procurementPhaseCard

                    // Organ Recovery Grid
                    organRecoveryCard

                    // DCD Summary
                    summaryCard

                    // Customizable OR Checklist
                    customChecklistCard

                    Spacer().frame(height: 40)
                }
            }
        }
        .onAppear {
            loadCustomChecklist()
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .sheet(isPresented: $showAddItemSheet) {
            addChecklistItemSheet
        }
        .sheet(isPresented: $showWITSettings) {
            witSettingsSheet
        }
    }

    // MARK: - Background
    private var backgroundGradient: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        Color(red: 0.09, green: 0.15, blue: 0.24),
                        Color(red: 0.06, green: 0.10, blue: 0.18),
                        Color(red: 0.09, green: 0.15, blue: 0.24).opacity(0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.97, blue: 0.98),
                        Color(red: 0.92, green: 0.94, blue: 0.97),
                        Color(red: 0.94, green: 0.96, blue: 0.98)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }

    // MARK: - Close Button
    private var closeButtonRow: some View {
        HStack {
            Spacer()
            Button(action: {
                timer?.invalidate()
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(textSecondary)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(colorScheme == .dark
                                ? AnyShapeStyle(CriticalDesign.Colors.cardBlue)
                                : AnyShapeStyle(.ultraThinMaterial))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(colorScheme == .dark ? 0.15 : 0.5), lineWidth: 1)
                    )
            }
            .padding(.trailing, 20)
            .padding(.top, 16)
        }
    }

    // MARK: - Hero Header with Timer
    private var heroHeaderWithTimer: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 100, height: 100)

                Image(systemName: "heart.circle")
                    .font(.system(size: 44, weight: .medium))
                    .foregroundColor(.orange)
            }

            // Title
            VStack(spacing: 4) {
                Text("DCD Protocol")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(textPrimary)

                Text("Donation after Circulatory Death")
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(.orange)
            }

            // Warm Ischemia Timer Card (in header)
            warmIschemiaTimerCard
        }
        .padding(.top, 8)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
    }

    // MARK: - Warm Ischemia Timer Card
    private var warmIschemiaTimerCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(timerColor)
                Text("WARM ISCHEMIA TIMER")
                    .font(.custom("Poppins-Bold", size: 12))
                    .foregroundColor(timerColor)
                Spacer()
            }

            // Timer Display
            Text(formatTimerDisplay(elapsedSeconds))
                .font(.system(size: 44, weight: .bold, design: .monospaced))
                .foregroundColor(timerColor)

            // Status
            Text(timerStatus)
                .font(.custom("Poppins-Medium", size: 11))
                .foregroundColor(timerColor.opacity(0.8))

            // Controls
            HStack(spacing: 16) {
                if timerRunning {
                    Button(action: stopTimer) {
                        Label("Stop", systemImage: "stop.fill")
                            .font(.custom("Poppins-SemiBold", size: 13))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color.red))
                    }
                } else {
                    Button(action: startTimer) {
                        Label("Start", systemImage: "play.fill")
                            .font(.custom("Poppins-SemiBold", size: 13))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color(red: 0.20, green: 0.50, blue: 0.70))) // Rich blue
                    }

                    if elapsedSeconds > 0 {
                        Button(action: resetTimer) {
                            Label("Reset", systemImage: "arrow.counterclockwise")
                                .font(.custom("Poppins-Medium", size: 13))
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(timerBackgroundColor)
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(timerBackgroundColor)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.3), Color.clear],
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
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.1 : 0.5),
                            timerColor.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : timerColor.opacity(0.2), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    private var timerBackgroundColor: Color {
        if elapsedSeconds > 3600 { return Color.red.opacity(0.15) }
        if elapsedSeconds > 1800 { return Color.orange.opacity(0.12) }
        return Color(red: 0.20, green: 0.50, blue: 0.70).opacity(0.1) // Rich blue
    }

    private var timerColor: Color {
        if elapsedSeconds > 3600 { return .red }
        if elapsedSeconds > 1800 { return .orange }
        return Color(red: 0.20, green: 0.50, blue: 0.70) // Rich blue
    }

    private var timerStatus: String {
        let minutes = elapsedSeconds / 60
        if minutes > 60 { return "CRITICAL - Exceeds most organ limits" }
        if minutes > 30 { return "Warning - Liver limit approaching" }
        if minutes > 0 { return "Within acceptable range" }
        return "Timer not started"
    }

    // MARK: - DCD Overview Card
    private var dcdOverviewCard: some View {
        DCDInfoCard(title: "Understanding DCD", icon: "book.fill", iconColor: .blue, colorScheme: colorScheme) {
            VStack(alignment: .leading, spacing: 14) {
                Text("DCD occurs when a patient experiences circulatory death after planned withdrawal of life-sustaining therapy (WLST). Unlike brain death donation, the patient's heart stops before organ recovery.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(textSecondary)
                    .lineSpacing(4)

                DCDKeyPointRow(title: "Family Decision First", description: "Decision to withdraw support must be independent of donation", icon: "person.2.fill", color: Color(red: 0.70, green: 0.45, blue: 0.55)) // Dusty rose

                DCDKeyPointRow(title: "Time-Critical", description: "Warm ischemia begins at circulatory arrest", icon: "clock.fill", color: .orange)

                DCDKeyPointRow(title: "Controlled Environment", description: "Category III (planned WLST) is most common", icon: "checkmark.shield.fill", color: Color(red: 0.20, green: 0.50, blue: 0.70)) // Rich blue
            }
        }
    }

    // MARK: - Warm Ischemia Limits Card (Editable)
    private var warmIschemiaLimitsCard: some View {
        DCDInfoCard(title: "Warm Ischemia Limits", icon: "clock.badge.exclamationmark.fill", iconColor: .orange, colorScheme: colorScheme) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Tap to edit limits for this case")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(textSecondary)

                    Spacer()

                    Button(action: { showWITSettings = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "pencil.circle.fill")
                            Text("Edit")
                        }
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(.orange)
                    }
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    witLimitBadge(organ: "Kidney", limit: kidneyWIT, color: .orange)
                    witLimitBadge(organ: "Liver", limit: liverWIT, color: Color(red: 0.55, green: 0.35, blue: 0.25)) // Warm brown
                    witLimitBadge(organ: "Lung", limit: lungWIT, color: Color(red: 0.20, green: 0.50, blue: 0.70)) // Rich blue
                    witLimitBadge(organ: "Pancreas", limit: pancreasWIT, color: Color(red: 0.70, green: 0.45, blue: 0.55)) // Dusty rose
                    witLimitBadge(organ: "Heart", limit: heartWIT, color: .red)
                }
            }
        }
    }

    private func witLimitBadge(organ: String, limit: Int, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(organ)
                .font(.custom("Poppins-Medium", size: 10))
                .foregroundColor(color)
            Text(limit > 0 ? "\(limit) min" : "N/A")
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 8).fill(color.opacity(0.12)))
    }

    // MARK: - WIT Settings Sheet
    private var witSettingsSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("Warm Ischemia Time Limits (minutes)")) {
                    Stepper("Kidney: \(kidneyWIT) min", value: $kidneyWIT, in: 0...120, step: 5)
                    Stepper("Liver: \(liverWIT) min", value: $liverWIT, in: 0...90, step: 5)
                    Stepper("Lung: \(lungWIT) min", value: $lungWIT, in: 0...120, step: 5)
                    Stepper("Pancreas: \(pancreasWIT) min", value: $pancreasWIT, in: 0...90, step: 5)
                    Stepper("Heart: \(heartWIT) min", value: $heartWIT, in: 0...60, step: 5)
                }

                Section(header: Text("Presets")) {
                    Button("Standard Limits") {
                        kidneyWIT = 60
                        liverWIT = 30
                        lungWIT = 60
                        pancreasWIT = 30
                        heartWIT = 0
                    }

                    Button("Extended Criteria") {
                        kidneyWIT = 45
                        liverWIT = 20
                        lungWIT = 45
                        pancreasWIT = 20
                        heartWIT = 0
                    }
                }

                Section(footer: Text("Warm ischemia time limits vary by center, organ condition, and recipient factors. Consult your OPO for case-specific guidance.")) {
                    EmptyView()
                }
            }
            .navigationTitle("Edit WIT Limits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showWITSettings = false
                    }
                }
            }
        }
    }

    // MARK: - Comparison Card
    private var comparisonCard: some View {
        DCDInfoCard(title: "DCD vs Brain Death Donation", icon: "arrow.left.arrow.right", iconColor: Color(red: 0.20, green: 0.50, blue: 0.70), colorScheme: colorScheme) {
            VStack(spacing: 8) {
                comparisonHeader
                Divider()
                comparisonRow(label: "Death Type", dcd: "Circulatory", dbd: "Neurologic")
                comparisonRow(label: "Timing", dcd: "After WLST", dbd: "After brain death")
                comparisonRow(label: "Warm Ischemia", dcd: "Critical factor", dbd: "Minimal")
                comparisonRow(label: "Observation", dcd: "5-min hands-off", dbd: "Not required")
                comparisonRow(label: "Typical Organs", dcd: "Kidney, liver, lung", dbd: "All organs")
            }
        }
    }

    private var comparisonHeader: some View {
        HStack {
            Text("Parameter")
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(textSecondary)
                .frame(width: 90, alignment: .leading)

            Text("DCD")
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity)

            Text("DBD")
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(Color(red: 0.70, green: 0.45, blue: 0.55))
                .frame(maxWidth: .infinity)
        }
    }

    private func comparisonRow(label: String, dcd: String, dbd: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(textSecondary)
                .frame(width: 90, alignment: .leading)

            Text(dcd)
                .font(.custom("Poppins-Medium", size: 10))
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity)

            Text(dbd)
                .font(.custom("Poppins-Medium", size: 10))
                .foregroundColor(Color(red: 0.70, green: 0.45, blue: 0.55))
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 2)
    }

    // MARK: - Withdrawal Phase Card
    private var withdrawalPhaseCard: some View {
        DCDPhaseSection(
            phase: "Phase 1",
            title: "Withdrawal of Life Support",
            icon: "xmark.circle.fill",
            color: .red,
            isExpanded: expandedSection == "withdrawal",
            colorScheme: colorScheme,
            onTap: { expandedSection = expandedSection == "withdrawal" ? nil : "withdrawal" }
        ) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Document the exact time life-sustaining therapy is withdrawn.")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(textSecondary)

                DCDTimeRow(
                    title: "WLST Time",
                    subtitle: "Extubation or vasopressor cessation",
                    time: $withdrawalTime,
                    color: .red,
                    colorScheme: colorScheme
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text("Pre-Withdrawal Checklist:")
                        .font(.custom("Poppins-SemiBold", size: 12))
                        .foregroundColor(textPrimary)

                    DCDCheckRow(text: "Family at bedside and ready")
                    DCDCheckRow(text: "OPO coordinator present")
                    DCDCheckRow(text: "OR team standing by")
                    DCDCheckRow(text: "Comfort medications prepared")
                }
            }
        }
    }

    // MARK: - Death Declaration Card
    private var deathDeclarationCard: some View {
        DCDPhaseSection(
            phase: "Phase 2",
            title: "Death Declaration",
            icon: "waveform.path.ecg",
            color: .orange,
            isExpanded: expandedSection == "death",
            colorScheme: colorScheme,
            onTap: { expandedSection = expandedSection == "death" ? nil : "death" }
        ) {
            VStack(alignment: .leading, spacing: 14) {
                DCDTimeRow(
                    title: "Asystole / Pulselessness",
                    subtitle: "Start warm ischemia timer NOW",
                    time: $asystoleTime,
                    color: .orange,
                    colorScheme: colorScheme,
                    onRecord: {
                        if !timerRunning { startTimer() }
                    }
                )

                // 5-minute observation warning
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("5-Minute Observation Period")
                            .font(.custom("Poppins-Bold", size: 12))
                            .foregroundColor(.red)

                        Text("UNOS requires mandatory \"hands-off\" period. No interventions until death declared.")
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(textSecondary)
                    }
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.08)))

                DCDTimeRow(
                    title: "Death Declared",
                    subtitle: "By attending physician after 5-min observation",
                    time: $deathDeclaredTime,
                    color: Color(red: 0.70, green: 0.45, blue: 0.55), // Dusty rose
                    colorScheme: colorScheme
                )

                // Agonal phase calculation
                if let withdrawal = withdrawalTime, let asystole = asystoleTime {
                    let agonalMinutes = Int(asystole.timeIntervalSince(withdrawal) / 60)
                    HStack {
                        Text("Agonal Phase:")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(textSecondary)
                        Spacer()
                        Text("\(agonalMinutes) min")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(agonalMinutes > 60 ? .red : Color(red: 0.20, green: 0.50, blue: 0.70))
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).fill(agonalMinutes > 60 ? Color.red.opacity(0.1) : Color(red: 0.20, green: 0.50, blue: 0.70).opacity(0.1)))
                }
            }
        }
    }

    // MARK: - Procurement Phase Card
    private var procurementPhaseCard: some View {
        DCDPhaseSection(
            phase: "Phase 3",
            title: "Procurement",
            icon: "scissors",
            color: .blue,
            isExpanded: expandedSection == "procurement",
            colorScheme: colorScheme,
            onTap: { expandedSection = expandedSection == "procurement" ? nil : "procurement" }
        ) {
            VStack(alignment: .leading, spacing: 14) {
                Text("After death is declared, proceed immediately to OR.")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(textSecondary)

                DCDTimeRow(
                    title: "Incision Time",
                    subtitle: "Start of procurement surgery",
                    time: $incisionTime,
                    color: .blue,
                    colorScheme: colorScheme
                )

                if let death = deathDeclaredTime, let incision = incisionTime {
                    let minutes = Int(incision.timeIntervalSince(death) / 60)
                    HStack {
                        Text("Death → Incision:")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(textSecondary)
                        Spacer()
                        Text("\(minutes) min")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(minutes < 10 ? Color(red: 0.20, green: 0.50, blue: 0.70) : .orange)
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).fill(minutes < 10 ? Color(red: 0.20, green: 0.50, blue: 0.70).opacity(0.1) : Color.orange.opacity(0.1)))
                }

                // Warm ischemia limits (uses editable values)
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Current WIT Limits:")
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .foregroundColor(textPrimary)

                        Spacer()

                        Button(action: { showWITSettings = true }) {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.orange)
                        }
                    }

                    HStack(spacing: 8) {
                        witLimitBadgeSmall(organ: "Kidney", limit: kidneyWIT, color: .orange)
                        witLimitBadgeSmall(organ: "Liver", limit: liverWIT, color: .brown)
                        witLimitBadgeSmall(organ: "Lung", limit: lungWIT, color: Color(red: 0.20, green: 0.50, blue: 0.70))
                    }
                }
            }
        }
    }

    private func witLimitBadgeSmall(organ: String, limit: Int, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(organ)
                .font(.custom("Poppins-Medium", size: 9))
                .foregroundColor(color)
            Text(limit > 0 ? "\(limit)m" : "N/A")
                .font(.custom("Poppins-Bold", size: 10))
                .foregroundColor(textPrimary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(RoundedRectangle(cornerRadius: 6).fill(color.opacity(0.12)))
    }

    // MARK: - Organ Recovery Card
    private var organRecoveryCard: some View {
        DCDInfoCard(title: "Organ Recovery Tracking", icon: "heart.text.square.fill", iconColor: .red, colorScheme: colorScheme) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Tap an organ when recovered. Time recorded automatically.")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(textSecondary)

                organGrid

                if !recoveredOrgans.isEmpty {
                    Divider()
                    recoveredOrgansList
                }
            }
        }
    }

    private var organGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(DCDRecoverableOrgan.allCases) { organ in
                organButton(organ: organ)
            }
        }
    }

    private func organButton(organ: DCDRecoverableOrgan) -> some View {
        let isRecovered = recoveredOrgans[organ] != nil

        return Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

            if recoveredOrgans[organ] == nil {
                recoveredOrgans[organ] = Date()
            } else {
                recoveredOrgans[organ] = nil
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(isRecovered ? organ.color.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 44, height: 44)

                    Image(systemName: organ.icon)
                        .font(.system(size: 18))
                        .foregroundColor(isRecovered ? organ.color : .gray)

                    if isRecovered {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.20, green: 0.50, blue: 0.70)) // Rich blue
                            .background(Circle().fill(Color.white).frame(width: 12, height: 12))
                            .offset(x: 14, y: -14)
                    }
                }

                Text(organ.rawValue)
                    .font(.custom("Poppins-Medium", size: 9))
                    .foregroundColor(isRecovered ? organ.color : textSecondary)
            }
        }
        .buttonStyle(.plain)
    }

    private var recoveredOrgansList: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Recovery Times:")
                .font(.custom("Poppins-SemiBold", size: 12))
                .foregroundColor(textPrimary)

            ForEach(recoveredOrgans.sorted(by: { $0.value < $1.value }), id: \.key) { organ, time in
                HStack {
                    Image(systemName: organ.icon)
                        .foregroundColor(organ.color)
                        .frame(width: 18)

                    Text(organ.rawValue)
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(textPrimary)

                    Spacer()

                    Text(time, style: .time)
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(textSecondary)

                    if let death = deathDeclaredTime {
                        let minutes = Int(time.timeIntervalSince(death) / 60)
                        Text("(+\(minutes)m)")
                            .font(.custom("Poppins-Medium", size: 10))
                            .foregroundColor(organ.color)
                    }
                }
            }
        }
    }

    // MARK: - Summary Card
    private var summaryCard: some View {
        DCDInfoCard(title: "DCD Case Summary", icon: "doc.text.fill", iconColor: Color(red: 0.20, green: 0.50, blue: 0.70), colorScheme: colorScheme) {
            VStack(alignment: .leading, spacing: 8) {
                if withdrawalTime != nil || deathDeclaredTime != nil || !recoveredOrgans.isEmpty {
                    summaryRow(label: "WLST Time", value: withdrawalTime != nil ? formatTime(withdrawalTime!) : "—")
                    summaryRow(label: "Asystole", value: asystoleTime != nil ? formatTime(asystoleTime!) : "—")
                    summaryRow(label: "Death Declared", value: deathDeclaredTime != nil ? formatTime(deathDeclaredTime!) : "—")
                    summaryRow(label: "Incision Time", value: incisionTime != nil ? formatTime(incisionTime!) : "—")

                    if !recoveredOrgans.isEmpty {
                        Divider()
                        summaryRow(label: "Organs Recovered", value: "\(recoveredOrgans.count)")
                    }

                    summaryRow(label: "Total Warm Ischemia", value: "\(elapsedSeconds / 60) min", highlight: true)
                } else {
                    Text("Begin recording times to generate summary.")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(textSecondary)
                        .italic()
                }
            }
        }
    }

    private func summaryRow(label: String, value: String, highlight: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(textSecondary)
            Spacer()
            Text(value)
                .font(.custom(highlight ? "Poppins-Bold" : "Poppins-Medium", size: highlight ? 14 : 12))
                .foregroundColor(highlight ? .orange : textPrimary)
        }
    }

    // MARK: - Custom Checklist Card
    private var customChecklistCard: some View {
        DCDInfoCard(title: "OR Checklist", icon: "checklist", iconColor: .indigo, colorScheme: colorScheme) {
            VStack(alignment: .leading, spacing: 12) {
                // Standard items
                VStack(alignment: .leading, spacing: 6) {
                    Text("Standard Items:")
                        .font(.custom("Poppins-SemiBold", size: 11))
                        .foregroundColor(textSecondary)

                    DCDCheckRow(text: "Patient identity verified")
                    DCDCheckRow(text: "Authorization documents confirmed")
                    DCDCheckRow(text: "Blood/tissue samples collected")
                    DCDCheckRow(text: "Preservation solution prepared")
                    DCDCheckRow(text: "OR team briefed on allocation")
                }

                Divider()

                // Custom items
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Custom Items:")
                            .font(.custom("Poppins-SemiBold", size: 11))
                            .foregroundColor(textSecondary)

                        Spacer()

                        Button(action: { showAddItemSheet = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "plus.circle.fill")
                                Text("Add")
                            }
                            .font(.custom("Poppins-Medium", size: 11))
                            .foregroundColor(.indigo)
                        }
                    }

                    if customChecklistItems.isEmpty {
                        Text("No custom items. Tap + to add.")
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(textSecondary.opacity(0.6))
                            .italic()
                    } else {
                        ForEach(customChecklistItems.indices, id: \.self) { index in
                            HStack {
                                DCDCheckRow(text: customChecklistItems[index])
                                Spacer()
                                Button(action: {
                                    customChecklistItems.remove(at: index)
                                    saveCustomChecklist()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red.opacity(0.5))
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Add Checklist Item Sheet
    private var addChecklistItemSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter checklist item...", text: $newItemText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                Spacer()
            }
            .navigationTitle("Add Checklist Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        newItemText = ""
                        showAddItemSheet = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if !newItemText.isEmpty {
                            customChecklistItems.append(newItemText)
                            saveCustomChecklist()
                            newItemText = ""
                            showAddItemSheet = false
                        }
                    }
                    .disabled(newItemText.isEmpty)
                }
            }
        }
    }

    // MARK: - Helper Functions
    private func startTimer() {
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }

    private func stopTimer() {
        timerRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func resetTimer() {
        stopTimer()
        elapsedSeconds = 0
    }

    private func formatTimerDisplay(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        }
        return String(format: "%02d:%02d", minutes, secs)
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func loadCustomChecklist() {
        if let decoded = try? JSONDecoder().decode([String].self, from: customChecklistData) {
            customChecklistItems = decoded
        }
    }

    private func saveCustomChecklist() {
        if let encoded = try? JSONEncoder().encode(customChecklistItems) {
            customChecklistData = encoded
        }
    }
}

// MARK: - Supporting Components

struct DCDInfoCard<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    let colorScheme: ColorScheme
    @ViewBuilder let content: Content

    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(iconColor)
                    )

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(textPrimary)
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 12)

            // Content
            content
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
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
                            .fill(Color.white.opacity(0.7))
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.5), Color.clear],
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
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.15 : 0.8),
                            iconColor.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : iconColor.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

struct DCDPhaseSection<Content: View>: View {
    let phase: String
    let title: String
    let icon: String
    let color: Color
    let isExpanded: Bool
    let colorScheme: ColorScheme
    let onTap: () -> Void
    @ViewBuilder let content: Content

    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header (always visible)
            Button(action: onTap) {
                HStack(spacing: 10) {
                    Text(phase)
                        .font(.custom("Poppins-Bold", size: 9))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(color))

                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(color)

                    Text(title)
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(textPrimary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(color)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .buttonStyle(.plain)

            // Expanded content
            if isExpanded {
                Divider().padding(.horizontal, 16)

                content
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
            }
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
                            .fill(Color.white.opacity(0.75))
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.4), Color.clear],
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
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.12 : 0.6),
                            color.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : color.opacity(0.15), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
    }
}

struct DCDKeyPointRow: View {
    let title: String
    let description: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
                .background(Circle().fill(color.opacity(0.15)))

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 12))
                    .foregroundColor(color)

                Text(description)
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor(Color.secondary)
            }
        }
    }
}

struct DCDTimeRow: View {
    let title: String
    let subtitle: String
    @Binding var time: Date?
    let color: Color
    let colorScheme: ColorScheme
    var onRecord: (() -> Void)? = nil

    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Poppins-SemiBold", size: 13))
                        .foregroundColor(textPrimary)

                    Text(subtitle)
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundColor(Color.secondary)
                }

                Spacer()

                if let recorded = time {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(recorded, style: .time)
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(color)

                        Button(action: {
                            self.time = Date()
                            onRecord?()
                        }) {
                            Text("Update")
                                .font(.custom("Poppins-Medium", size: 9))
                                .foregroundColor(color)
                        }
                    }
                } else {
                    Button(action: {
                        self.time = Date()
                        onRecord?()
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }) {
                        Text("Record Now")
                            .font(.custom("Poppins-SemiBold", size: 11))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(color))
                    }
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(color.opacity(0.08)))
    }
}

struct DCDCheckRow: View {
    let text: String
    @State private var isChecked = false

    var body: some View {
        Button(action: { isChecked.toggle() }) {
            HStack(spacing: 8) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? Color(red: 0.20, green: 0.50, blue: 0.70) : .gray) // Rich blue
                    .font(.system(size: 16))

                Text(text)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(isChecked ? .secondary : .primary)
                    .strikethrough(isChecked)

                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    DCDProtocolView()
}
