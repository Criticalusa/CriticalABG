//
//  PostArrestCare2025View.swift
//  CriticalX
//
//  Comprehensive 2025 AHA Post-Cardiac Arrest Care Guidelines
//
//  Created: January 2026
//

import SwiftUI

struct PostArrestCare2025View: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedPhase: PostArrestPhase = .initial
    
    enum PostArrestPhase: String, CaseIterable, Identifiable {
        case initial = "Initial"
        case airway = "Airway"
        case hemodynamics = "Hemodynamics"
        case temperature = "Temperature"
        case neuro = "Neuro"
        case diagnostics = "Diagnostics"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .initial: return "play.circle.fill"
            case .airway: return "lungs.fill"
            case .hemodynamics: return "heart.fill"
            case .temperature: return "thermometer.medium"
            case .neuro: return "brain"
            case .diagnostics: return "waveform.path.ecg"
            }
        }
        
        var color: Color {
            switch self {
            case .initial: return .blue
            case .airway: return .cyan
            case .hemodynamics: return .red
            case .temperature: return .teal
            case .neuro: return .purple
            case .diagnostics: return .orange
            }
        }
    }
    
    private var cardBackground: Color {
        colorScheme == .dark ? CriticalDesign.Colors.cardBlue : .white
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Phase Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(PostArrestPhase.allCases) { phase in
                            PhaseTab(
                                title: phase.rawValue,
                                icon: phase.icon,
                                color: phase.color,
                                isSelected: selectedPhase == phase
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedPhase = phase
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
                        switch selectedPhase {
                        case .initial:
                            InitialStabilizationSection()
                        case .airway:
                            AirwaySection()
                        case .hemodynamics:
                            HemodynamicsSection()
                        case .temperature:
                            TemperatureSection()
                        case .neuro:
                            NeuroPrognosticationSection()
                        case .diagnostics:
                            DiagnosticsSection()
                        }
                    }
                    .padding()
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Post-Arrest Care 2025")
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

// MARK: - Phase Tab

struct PhaseTab: View {
    let title: String
    let icon: String
    let color: Color
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
            .background(isSelected ? color : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

// MARK: - Initial Stabilization Section

struct InitialStabilizationSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    Text("Initial Stabilization")
                        .font(.title.bold())
                }
                
                Text("Upon achieving ROSC, perform these actions concurrently")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Key Actions
            PostArrestCard(
                title: "Immediate Actions (Concurrent)",
                icon: "list.bullet.clipboard.fill",
                color: .blue
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    PostArrestAction(number: 1, text: "Manage Airway - Assess, place/exchange advanced airway, confirm with capnography")
                    PostArrestAction(number: 2, text: "Manage Oxygenation - Target SpO₂ 90-98%")
                    PostArrestAction(number: 3, text: "Manage Ventilation - Target PaCO₂ 35-45 mmHg")
                    PostArrestAction(number: 4, text: "Manage Hemodynamics - Target MAP ≥65 mmHg")
                    PostArrestAction(number: 5, text: "Early Diagnostics - 12-lead ECG, CT, POCUS")
                }
            }
            
            // 2025 Highlight
            PostArrestHighlight(
                text: "2025: ROSC now has its own dedicated algorithm, removed from side panel of cardiac arrest algorithm",
                icon: "arrow.right.doc.on.clipboard",
                color: .green
            )
            
            // Next Steps
            PostArrestCard(
                title: "Algorithm Flow",
                icon: "arrow.triangle.branch",
                color: .orange
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("After initial stabilization, pathway depends on neurological status:")
                        .font(.caption)
                    
                    HStack(spacing: 16) {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Follows Commands")
                                .font(.caption2.weight(.semibold))
                            Text("Continued care pathway")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                        
                        VStack {
                            Image(systemName: "moon.zzz.fill")
                                .foregroundColor(.purple)
                            Text("Unresponsive")
                                .font(.caption2.weight(.semibold))
                            Text("Neuroprognostication pathway")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct PostArrestAction: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption.weight(.bold))
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color.blue)
                .clipShape(Circle())
            
            Text(text)
                .font(.caption)
        }
    }
}

// MARK: - Airway Section

struct AirwaySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lungs.fill")
                        .font(.largeTitle)
                        .foregroundColor(.cyan)
                    Text("Airway Management")
                        .font(.title.bold())
                }
            }
            
            // 2025 Update
            PostArrestHighlight(
                text: "2025: Explicit instructions to assess, place/exchange advanced airway, and CONFIRM placement with waveform capnography",
                icon: "waveform.path",
                color: .cyan
            )
            
            // Oxygenation
            PostArrestCard(
                title: "Oxygenation (Updated 2025)",
                icon: "o.circle.fill",
                color: .cyan
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Initial FiO₂")
                                .font(.caption.weight(.semibold))
                            Text("100%")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.cyan)
                            Text("Until SpO₂/PaO₂ measured")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Target SpO₂")
                                .font(.caption.weight(.semibold))
                            Text("90-98%")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.cyan)
                            Text("Titrate once measurable")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text("2025: SpO₂ targets slightly widened from prior guidelines")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            // Ventilation
            PostArrestCard(
                title: "Ventilation (Updated 2025)",
                icon: "wind",
                color: .blue
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Target PaCO₂")
                                .font(.caption.weight(.semibold))
                            Text("35-45 mmHg")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Key Principle")
                                .font(.caption.weight(.semibold))
                            Text("Avoid Hyperventilation")
                                .font(.subheadline.weight(.bold))
                                .foregroundColor(.red)
                        }
                    }
                    
                    PostArrestHighlight(
                        text: "2025: REMOVED fixed \"10 breaths per minute\" language. Focus on PaCO₂ targets and avoiding hyperventilation.",
                        icon: "minus.circle.fill",
                        color: .green
                    )
                }
            }
        }
    }
}

// MARK: - Hemodynamics Section

struct HemodynamicsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("Hemodynamic Management")
                        .font(.title.bold())
                }
            }
            
            // MAP Target
            PostArrestCard(
                title: "Blood Pressure Target (Updated 2025)",
                icon: "gauge.with.dots.needle.bottom.50percent.badge.plus",
                color: .red
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    // Target display
                    HStack {
                        Spacer()
                        VStack {
                            Text("TARGET")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.secondary)
                            Text("MAP ≥65")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.red)
                            Text("mmHg")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    
                    // What's removed
                    PostArrestHighlight(
                        text: "2025: Systolic BP target of >90 mmHg has been REMOVED. Focus solely on MAP ≥65 mmHg.",
                        icon: "minus.circle.fill",
                        color: .green
                    )
                }
            }
            
            // Interventions
            PostArrestCard(
                title: "Achieving Hemodynamic Goals",
                icon: "syringe.fill",
                color: .orange
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Use vasopressors and/or fluid resuscitation as needed")
                        .font(.caption)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        InterventionRow(intervention: "Norepinephrine", note: "First-line vasopressor")
                        InterventionRow(intervention: "Epinephrine", note: "Alternative/adjunct")
                        InterventionRow(intervention: "Vasopressin", note: "Adjunct (not first-line)")
                        InterventionRow(intervention: "Fluid bolus", note: "If hypovolemia suspected")
                    }
                }
            }
            
            // Coronary Intervention
            PostArrestCard(
                title: "Early Cardiac Intervention (Updated 2025)",
                icon: "heart.text.square.fill",
                color: .purple
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("2025: Less rigid STEMI/non-STEMI categorization")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.purple)
                    
                    Text("""
                    • Strong push toward early coronary angiography
                    • Early PCI when appropriate
                    • Consider mechanical circulatory support
                    • More generalized approach to etiology management
                    """)
                    .font(.caption)
                }
            }
        }
    }
}

struct InterventionRow: View {
    let intervention: String
    let note: String
    
    var body: some View {
        HStack {
            Text("•")
            Text(intervention)
                .font(.caption.weight(.semibold))
            Text("—")
                .foregroundColor(.secondary)
            Text(note)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Temperature Section

struct TemperatureSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "thermometer.medium")
                        .font(.largeTitle)
                        .foregroundColor(.teal)
                    Text("Temperature Control")
                        .font(.title.bold())
                }
            }
            
            // 2025 Update
            PostArrestHighlight(
                text: "Major 2025 Update: Temperature range widened and duration extended",
                icon: "sparkles",
                color: .teal
            )
            
            // Temperature Target
            PostArrestCard(
                title: "Temperature Management (Updated 2025)",
                icon: "thermometer.sun.fill",
                color: .teal
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    // Parameters
                    HStack(spacing: 16) {
                        VStack {
                            Text("TARGET")
                                .font(.caption2.weight(.medium))
                                .foregroundColor(.secondary)
                            Text("32-37.5°C")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.teal)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal.opacity(0.1))
                        .cornerRadius(10)
                        
                        VStack {
                            Text("DURATION")
                                .font(.caption2.weight(.medium))
                                .foregroundColor(.secondary)
                            Text("≥36 hrs")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        
                        VStack {
                            Text("REWARM")
                                .font(.caption2.weight(.medium))
                                .foregroundColor(.secondary)
                            Text("0.25°C/hr")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.orange)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // Changes from 2020
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Changes from 2020:")
                            .font(.caption.weight(.semibold))
                        Text("• Previous target: ≤36°C")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("• Previous duration: ≥24 hours")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Key Insight
            PostArrestCard(
                title: "Clinical Insight",
                icon: "lightbulb.fill",
                color: .yellow
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("FEVER IS THE ENEMY")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.red)
                    
                    Text("""
                    Even mild hyperthermia after arrest worsens outcomes. At minimum, prevent fever.
                    
                    Both hypothermic (32-34°C) and normothermic (36-37.5°C, fever prevention) strategies are acceptable.
                    """)
                    .font(.caption)
                }
            }
            
            // For unresponsive patients
            PostArrestHighlight(
                text: "Temperature control indicated for adult patients who remain UNRESPONSIVE after ROSC",
                icon: "person.fill.questionmark",
                color: .purple
            )
        }
    }
}

// MARK: - Neuroprognostication Section

struct NeuroPrognosticationSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "brain")
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                    Text("Neurologic Prognostication")
                        .font(.title.bold())
                }
            }
            
            // Key Principle
            PostArrestCard(
                title: "2025 Prognostication Principles",
                icon: "clock.fill",
                color: .purple
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Assessment must be performed OFF sedation and neuromuscular blockade")
                            .font(.caption.weight(.semibold))
                    }
                    
                    Text("""
                    • Allow adequate time for drug clearance
                    • Consider organ function affecting drug metabolism
                    • Temperature effects on drug metabolism
                    • Multi-modal prognostication is REQUIRED
                    """)
                    .font(.caption)
                }
            }
            
            // Multimodal Approach
            PostArrestCard(
                title: "Multimodal Prognostication (Required)",
                icon: "square.grid.3x3.fill",
                color: .blue
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    ModalityRow(modality: "Clinical Exam", tests: "GCS, pupil reactivity, motor response")
                    ModalityRow(modality: "Electrophysiology", tests: "EEG, SSEP")
                    ModalityRow(modality: "Neuroimaging", tests: "CT, MRI (diffusion-weighted)")
                    ModalityRow(modality: "Biomarkers", tests: "NSE (serial measurements)")
                }
            }
            
            // Timing
            PostArrestCard(
                title: "Timing Considerations",
                icon: "calendar.badge.clock",
                color: .orange
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("No single time point for definitive prognostication")
                        .font(.caption.weight(.semibold))
                    
                    Text("""
                    • Allow ≥72 hours after ROSC before prognostication
                    • Consider longer if hypothermia was used
                    • Repeated assessments may be needed
                    • Family discussions are ongoing process
                    """)
                    .font(.caption)
                }
            }
            
            // Survivor Support
            PostArrestHighlight(
                text: "2025 NEW: Provide structured assessment and treatment/referral for emotional distress in survivors AND caregivers before hospital discharge",
                icon: "heart.circle.fill",
                color: .green
            )
        }
    }
}

struct ModalityRow: View {
    let modality: String
    let tests: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(modality)
                .font(.caption.weight(.semibold))
            Text(tests)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Diagnostics Section

struct DiagnosticsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "waveform.path.ecg")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text("Early Diagnostics")
                        .font(.title.bold())
                }
            }
            
            // 2025 Emphasis
            PostArrestHighlight(
                text: "2025: Strong emphasis on EARLY diagnostic workup to identify etiology and guide intervention",
                icon: "magnifyingglass.circle.fill",
                color: .orange
            )
            
            // Required Diagnostics
            PostArrestCard(
                title: "Immediate Diagnostics",
                icon: "checkmark.rectangle.portrait.fill",
                color: .blue
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    DiagnosticItem(
                        test: "12-Lead ECG",
                        purpose: "Assess for cardiac etiology (STEMI, arrhythmia)",
                        timing: "Immediate",
                        isRequired: true
                    )
                    
                    Divider()
                    
                    DiagnosticItem(
                        test: "Head-to-Pelvis CT",
                        purpose: "Investigate etiology and identify resuscitation complications",
                        timing: "Early consideration",
                        isRequired: false
                    )
                    
                    Divider()
                    
                    DiagnosticItem(
                        test: "POCUS / Echocardiography",
                        purpose: "Identify cardiac issues requiring intervention",
                        timing: "As available",
                        isRequired: false
                    )
                }
            }
            
            // Lab Work
            PostArrestCard(
                title: "Laboratory Studies",
                icon: "flask.fill",
                color: .green
            ) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    LabItem(test: "ABG/VBG")
                    LabItem(test: "Lactate")
                    LabItem(test: "BMP")
                    LabItem(test: "CBC")
                    LabItem(test: "Troponin")
                    LabItem(test: "Coagulation")
                    LabItem(test: "Toxicology")
                    LabItem(test: "Glucose")
                }
            }
            
            // AI Explain
            VStack(spacing: 12) {
                ExplainButton(
                    topic: "Post-Cardiac Arrest Care 2025",
                    result: "Complete post-ROSC management",
                    context: "2025 Post-Arrest Care: MAP ≥65 mmHg (SBP target removed), SpO₂ 90-98%, PaCO₂ 35-45 mmHg (no fixed RR), temperature 32-37.5°C for ≥36 hours, early diagnostics (12-lead, CT, POCUS), multimodal neuroprognostication off sedation, survivor/caregiver emotional support before discharge.",
                    screenName: "Post-Arrest Care 2025",
                    style: .prominent,
                    buttonText: "Explain Post-Arrest 2025 Changes"
                )
            }
        }
    }
}

struct DiagnosticItem: View {
    let test: String
    let purpose: String
    let timing: String
    let isRequired: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(test)
                    .font(.caption.weight(.semibold))
                if isRequired {
                    Text("REQUIRED")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                Spacer()
                Text(timing)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Text(purpose)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct LabItem: View {
    let test: String
    
    var body: some View {
        Text(test)
            .font(.caption)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(Color.green.opacity(0.1))
            .cornerRadius(6)
    }
}

// MARK: - Reusable Components

struct PostArrestCard<Content: View>: View {
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
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.5) : Color.black.opacity(0.05), radius: 8, y: 4)
    }
}

struct PostArrestHighlight: View {
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

// MARK: - Preview

#Preview {
    PostArrestCare2025View()
}
