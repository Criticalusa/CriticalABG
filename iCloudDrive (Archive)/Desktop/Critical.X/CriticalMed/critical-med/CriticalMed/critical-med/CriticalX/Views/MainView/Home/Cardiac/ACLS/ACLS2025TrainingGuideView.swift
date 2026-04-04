//
//  ACLS2025TrainingGuideView.swift
//  CriticalX
//
//  Comprehensive 2025 AHA Resuscitation Guidelines Training Guide
//  For EMS and In-Hospital Teams
//
//  Created: January 2026
//

import SwiftUI

struct ACLS2025TrainingGuideView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var selectedSection: GuideSection = .overview
    
    enum GuideSection: String, CaseIterable, Identifiable {
        case overview = "Overview"
        case chainOfSurvival = "Chain of Survival"
        case systemsOfCare = "Systems of Care"
        case adultBLS = "Adult BLS"
        case adultALS = "Adult ALS"
        case pediatric = "Pediatric"
        case postArrest = "Post-Arrest"
        case specialCircumstances = "Special Cases"
        case quickReference = "Quick Reference"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .overview: return "doc.text.fill"
            case .chainOfSurvival: return "link"
            case .systemsOfCare: return "person.3.fill"
            case .adultBLS: return "hand.raised.fill"
            case .adultALS: return "cross.case.fill"
            case .pediatric: return "figure.and.child.holdinghands"
            case .postArrest: return "heart.text.square.fill"
            case .specialCircumstances: return "exclamationmark.triangle.fill"
            case .quickReference: return "list.bullet.rectangle.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Section Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(GuideSection.allCases) { section in
                            SectionTab(
                                title: section.rawValue,
                                icon: section.icon,
                                isSelected: selectedSection == section
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedSection = section
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
                
                Divider()
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedSection {
                        case .overview:
                            OverviewSection()
                        case .chainOfSurvival:
                            ChainOfSurvivalSection()
                        case .systemsOfCare:
                            SystemsOfCareSection()
                        case .adultBLS:
                            AdultBLSSection()
                        case .adultALS:
                            AdultALSSection()
                        case .pediatric:
                            PediatricSection()
                        case .postArrest:
                            PostArrestSection()
                        case .specialCircumstances:
                            SpecialCircumstancesSection()
                        case .quickReference:
                            QuickReferenceSection()
                        }
                    }
                    .padding()
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("2025 Guidelines")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Section Tab

struct SectionTab: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption.weight(.medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? CriticalDesign.Colors.cardBlue : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

// MARK: - Overview Section

struct OverviewSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("2025 AHA Guidelines")
                        .font(.title.bold())
                }
                
                Text("Cardiopulmonary Resuscitation and Emergency Cardiovascular Care")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Key Stats Card
            GuideCard(title: "Evidence Base", icon: "chart.bar.fill", color: .blue) {
                VStack(alignment: .leading, spacing: 12) {
                    StatRow(label: "Total Recommendations", value: "760")
                    StatRow(label: "Class 1 (Strong)", value: "31%")
                    StatRow(label: "Class 2a/2b (Moderate/Weak)", value: "59%")
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Only 1.4% backed by Level A (high-quality RCT) evidence")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("65% based on Limited Data or Expert Opinion")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Ethical Framework
            GuideCard(title: "Ethical Framework (Principlism)", icon: "scale.3d", color: .purple) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(EthicalFramework2025.principles) { principle in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: principle.icon)
                                .foregroundColor(.purple)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text(principle.name)
                                    .font(.subheadline.weight(.semibold))
                                Text(principle.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Divider()
                    
                    Text(EthicalFramework2025.defaultApproach)
                        .font(.caption)
                        .padding(8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            // Equity Imperative
            HighlightCard(
                text: EthicalFramework2025.equityImperative,
                icon: "equal.circle.fill",
                color: .green
            )
            
            // Implementation Timeline
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.orange)
                Text(ACLS2025QuickReference.implementationTimeline)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

// MARK: - Chain of Survival Section

struct ChainOfSurvivalSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 2025 Change Banner
            ChangeHighlightBanner(text: ChainOfSurvival2025.keyChange)
            
            Text("The 2025 Unified Chain of Survival")
                .font(.headline)
            
            Text("Now applicable to ALL ages (adult/pediatric) and settings (IHCA/OHCA)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Chain Links
            ForEach(ChainOfSurvival2025.links) { link in
                ChainLinkCard(link: link)
            }
        }
    }
}

struct ChainLinkCard: View {
    @Environment(\.colorScheme) var colorScheme
    let link: ChainOfSurvivalLink
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(link.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text("\(link.order)")
                    .font(.title2.bold())
                    .foregroundColor(link.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: link.icon)
                        .foregroundColor(link.color)
                    Text(link.title)
                        .font(.subheadline.weight(.semibold))
                }
                Text(link.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.05), radius: 6, y: 3)
    }
}

// MARK: - Systems of Care Section

struct SystemsOfCareSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Team Composition
            GuideCard(title: "Team Composition", icon: "person.3.fill", color: .blue) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(SystemsOfCare2025.teamRecommendations) { rec in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(rec.setting)
                                    .font(.caption.weight(.bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(4)
                                
                                CORBadge(cor: rec.classOfRecommendation)
                            }
                            Text(rec.recommendation)
                                .font(.subheadline)
                            Text(rec.rationale)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        
                        if rec.id != SystemsOfCare2025.teamRecommendations.last?.id {
                            Divider()
                        }
                    }
                }
            }
            
            // On-Scene vs Transport
            GuideCard(title: "On-Scene vs Transport", icon: "location.fill", color: .orange) {
                VStack(alignment: .leading, spacing: 8) {
                    ChangeHighlightBanner(text: "PRIORITY: Resuscitate on scene with goal of ROSC before transport")
                    
                    Text(SystemsOfCare2025.onSceneVsTransport)
                        .font(.caption)
                }
            }
            
            // Debriefing
            GuideCard(title: "Clinical Debriefing", icon: "bubble.left.and.bubble.right.fill", color: .green) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(SystemsOfCare2025.debriefingTypes, id: \.0) { type in
                        HStack(alignment: .top) {
                            Text("•")
                            VStack(alignment: .leading) {
                                Text(type.0)
                                    .font(.subheadline.weight(.semibold))
                                Text(type.1)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Adult BLS Section

struct AdultBLSSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Adult Basic Life Support Updates")
                .font(.headline)
            
            ForEach(AdultBLS2025.updates) { update in
                BLSUpdateCard(update: update)
            }
            
            // Compression Quality Reference
            GuideCard(title: "High-Quality CPR Parameters", icon: "waveform.path.ecg", color: .red) {
                Text(AdultBLS2025.compressionQuality)
                    .font(.caption)
            }
        }
    }
}

struct BLSUpdateCard: View {
    @Environment(\.colorScheme) var colorScheme
    let update: BLSUpdate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(update.topic)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                if update.isNew {
                    Text("NEW")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                CORBadge(cor: update.classOfRecommendation)
            }
            
            Text(update.update)
                .font(.subheadline)
            
            HStack(alignment: .top, spacing: 4) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
                Text(update.rationale)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.05), radius: 6, y: 3)
    }
}

// MARK: - Adult ALS Section

struct AdultALSSection: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showShockable = true

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Epinephrine Timing Card
            HighlightCard(
                text: AdultALS2025.epinephrineTiming,
                icon: "syringe.fill",
                color: .purple
            )
            
            // Algorithm Toggle
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Button(action: { showShockable = true }) {
                        Text("Shockable (VF/pVT)")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(showShockable ? Color.red : Color(.systemGray5))
                            .foregroundColor(showShockable ? .white : .primary)
                            .cornerRadius(8)
                    }
                    
                    Button(action: { showShockable = false }) {
                        Text("Non-Shockable (PEA/Asystole)")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(!showShockable ? Color.purple : Color(.systemGray5))
                            .foregroundColor(!showShockable ? .white : .primary)
                            .cornerRadius(8)
                    }
                }
                
                let steps = showShockable ? AdultALS2025.shockableAlgorithm : AdultALS2025.nonShockableAlgorithm
                
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1)")
                                .font(.caption.weight(.bold))
                                .frame(width: 20, height: 20)
                                .background(showShockable ? Color.red.opacity(0.2) : Color.purple.opacity(0.2))
                                .cornerRadius(10)
                            Text(step.replacingOccurrences(of: "\(index + 1). ", with: ""))
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemGray6))
                .cornerRadius(10)
            }
            
            // ALS Recommendations
            Text("Key ALS Updates")
                .font(.headline)
            
            ForEach(AdultALS2025.recommendations) { rec in
                ALSRecommendationCard(recommendation: rec)
            }
            
            // Cardioversion Energies
            GuideCard(title: "Cardioversion Energy (2025)", icon: "bolt.heart.fill", color: .yellow) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(CardioversionEnergies2025.energies) { energy in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(energy.rhythm)
                                    .font(.caption.weight(.semibold))
                                Text(energy.notes)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(energy.energy)
                                .font(.subheadline.weight(.bold))
                                .foregroundColor(.orange)
                        }
                        if energy.id != CardioversionEnergies2025.energies.last?.id {
                            Divider()
                        }
                    }
                    
                    Divider()
                    
                    Text(CardioversionEnergies2025.sedationGuidance)
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
    }
}

struct ALSRecommendationCard: View {
    @Environment(\.colorScheme) var colorScheme
    let recommendation: ALSRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(recommendation.category)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(recommendation.classOfRecommendation.color.opacity(0.2))
                    .cornerRadius(4)
                
                if recommendation.isChange {
                    Text("CHANGED")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                CORBadge(cor: recommendation.classOfRecommendation)
            }
            
            Text(recommendation.recommendation)
                .font(.subheadline)
            
            Text(recommendation.rationale)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.05), radius: 6, y: 3)
    }
}

// MARK: - Pediatric Section

struct PediatricSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HighlightCard(
                text: PediatricResuscitation2025.keyPrinciple,
                icon: "exclamationmark.triangle.fill",
                color: .orange
            )
            
            Text("Pediatric Updates")
                .font(.headline)
            
            ForEach(PediatricResuscitation2025.updates) { update in
                PediatricUpdateCard(update: update)
            }
            
            // Neonatal Section
            GuideCard(title: "Neonatal Resuscitation", icon: "figure.and.child.holdinghands", color: .pink) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Umbilical Cord Management")
                            .font(.subheadline.weight(.semibold))
                        Text(NeonatalResuscitation2025.umbilicalCordManagement)
                            .font(.caption)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ventilation Priority")
                            .font(.subheadline.weight(.semibold))
                        Text(NeonatalResuscitation2025.ventilationPriority)
                            .font(.caption)
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Initial Pressures")
                                .font(.caption.weight(.semibold))
                            Text(NeonatalResuscitation2025.initialPressures)
                                .font(.caption2)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Ventilation Rate")
                                .font(.caption.weight(.semibold))
                            Text(NeonatalResuscitation2025.ventilationRate)
                                .font(.caption2)
                        }
                    }
                }
            }
        }
    }
}

struct PediatricUpdateCard: View {
    @Environment(\.colorScheme) var colorScheme
    let update: PediatricUpdate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(update.topic)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(update.ageGroup)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Text(update.recommendation)
                .font(.subheadline)
            
            Text(update.rationale)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.05), radius: 6, y: 3)
    }
}

// MARK: - Post-Arrest Section

struct PostArrestSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ChangeHighlightBanner(text: "ROSC now has its own dedicated algorithm")
            
            // Targets
            GuideCard(title: "Post-ROSC Targets", icon: "target", color: .green) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(PostArrestCare2025.targets) { target in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(target.parameter)
                                        .font(.subheadline.weight(.semibold))
                                    if target.isChange {
                                        Text("CHANGED")
                                            .font(.caption2.weight(.bold))
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 1)
                                            .background(Color.orange)
                                            .foregroundColor(.white)
                                            .cornerRadius(3)
                                    }
                                }
                                Text(target.notes)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(target.target)
                                .font(.subheadline.weight(.bold))
                                .foregroundColor(.green)
                        }
                        if target.id != PostArrestCare2025.targets.last?.id {
                            Divider()
                        }
                    }
                }
            }
            
            // Diagnostic Imaging
            GuideCard(title: "Diagnostic Imaging", icon: "xray", color: .blue) {
                Text(PostArrestCare2025.diagnosticImaging)
                    .font(.caption)
            }
            
            // Survivor Support
            GuideCard(title: "Survivor & Caregiver Support", icon: "heart.circle.fill", color: .pink) {
                Text(PostArrestCare2025.survivorSupport)
                    .font(.caption)
            }
            
            // Neurologic Prognostication
            GuideCard(title: "Neurologic Prognostication", icon: "brain.head.profile", color: .purple) {
                Text(PostArrestCare2025.neurologicPrognostication)
                    .font(.caption)
            }
        }
    }
}

// MARK: - Special Circumstances Section

struct SpecialCircumstancesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Special Circumstances")
                .font(.headline)
            
            ForEach(SpecialCircumstances2025.circumstances) { circumstance in
                SpecialCircumstanceCard(circumstance: circumstance)
            }
            
            // Termination of Resuscitation
            GuideCard(title: "Termination of Resuscitation", icon: "xmark.circle.fill", color: .red) {
                VStack(alignment: .leading, spacing: 12) {
                    HighlightCard(
                        text: TerminationOfResuscitation2025.keyPrinciple,
                        icon: "exclamationmark.triangle.fill",
                        color: .red
                    )
                    
                    Text("Consider if ALL criteria met:")
                        .font(.caption.weight(.semibold))
                    
                    ForEach(TerminationOfResuscitation2025.criteria, id: \.self) { criterion in
                        HStack {
                            Image(systemName: "checkmark.square")
                                .foregroundColor(.red)
                            Text(criterion)
                                .font(.caption)
                        }
                    }
                    
                    Text(TerminationOfResuscitation2025.guidance)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct SpecialCircumstanceCard: View {
    @Environment(\.colorScheme) var colorScheme
    let circumstance: SpecialCircumstance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: circumstance.icon)
                    .foregroundColor(.orange)
                Text(circumstance.condition)
                    .font(.subheadline.weight(.semibold))
            }
            
            Text(circumstance.keyUpdate)
                .font(.subheadline)
            
            Text(circumstance.rationale)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.05), radius: 6, y: 3)
    }
}

// MARK: - Quick Reference Section

struct QuickReferenceSection: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Major Changes at a Glance")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(ACLS2025QuickReference.majorChanges, id: \.topic) { change in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(change.topic)
                            .font(.caption.weight(.bold))
                            .foregroundColor(CriticalDesign.Colors.accentBlue)
                        Text(change.change)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            
            // Education Science
            GuideCard(title: "Education Science", icon: "book.fill", color: .blue) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("CPR Feedback Devices")
                        .font(.caption.weight(.semibold))
                    Text(EducationScience2025.feedbackDevices)
                        .font(.caption2)
                    
                    Divider()
                    
                    Text("Virtual Reality")
                        .font(.caption.weight(.semibold))
                    Text(EducationScience2025.virtualReality)
                        .font(.caption2)
                    
                    Divider()
                    
                    Text("Teamwork Training")
                        .font(.caption.weight(.semibold))
                    Text(EducationScience2025.teamTraining)
                        .font(.caption2)
                }
            }
            
            // Implementation Timeline
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.orange)
                Text(ACLS2025QuickReference.implementationTimeline)
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

// MARK: - Reusable Components

struct GuideCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldGradient : LinearGradient(colors: [Color.gray.opacity(0.15)], startPoint: .top, endPoint: .bottom), lineWidth: colorScheme == .dark ? 1 : 0)
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.05), radius: 8, y: 4)
    }
}

struct HighlightCard: View {
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            Text(text)
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ChangeHighlightBanner: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "sparkles")
                .foregroundColor(.orange)
            Text(text)
                .font(.caption.weight(.semibold))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.2), Color.yellow.opacity(0.1)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(10)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption.weight(.bold))
        }
    }
}

struct CORBadge: View {
    let cor: ClassOfRecommendation
    
    var body: some View {
        Text(cor.strength)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(cor.color.opacity(0.2))
            .foregroundColor(cor.color)
            .cornerRadius(4)
    }
}

// MARK: - Preview

#Preview {
    ACLS2025TrainingGuideView()
}
