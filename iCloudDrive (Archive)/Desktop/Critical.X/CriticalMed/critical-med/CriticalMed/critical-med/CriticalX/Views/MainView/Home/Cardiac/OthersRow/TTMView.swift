//
//  TTMView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 2/21/24.
//  Redesigned: Premium Light Theme with Clinical Teaching Style
//

import SwiftUI

// MARK: - TTM Background
struct TTMBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false
    
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                CriticalDesign.Colors.darkCanvas
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.98, blue: 0.99),
                        Color(red: 0.94, green: 0.96, blue: 0.98),
                        Color(red: 0.96, green: 0.97, blue: 0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            GeometryReader { geo in
                Circle()
                    .fill(Color(red: 0.2, green: 0.5, blue: 0.9).opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                        y: animate ? geo.size.height * 0.2 : geo.size.height * 0.4
                    )
                
                Circle()
                    .fill(Color(red: 0.0, green: 0.71, blue: 0.85).opacity(0.04))
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                    .offset(
                        x: animate ? geo.size.width * 0.1 : geo.size.width * 0.5,
                        y: animate ? geo.size.height * 0.6 : geo.size.height * 0.3
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Content Formatter
struct TTMContentFormatter {
    static let textPrimary = Color(red: 0.04, green: 0.09, blue: 0.16)
    static let textTertiary = Color(red: 0.24, green: 0.35, blue: 0.50)
    
    static func format(_ text: String, headings: [String]) -> AttributedString {
        var result = AttributedString(text)
        let baseFont = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        result.font = Font(baseFont)
        result.foregroundColor = textTertiary
        
        let boldFont = UIFont(name: "Poppins-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
        for heading in headings {
            if let range = result.range(of: heading) {
                result[range].font = Font(boldFont)
                result[range].foregroundColor = textPrimary
            }
        }
        return result
    }
}

// MARK: - Glass Card Component
struct TTMGlassCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let icon: String
    var accentColor: Color = Color(red: 0.2, green: 0.5, blue: 0.9)
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(accentColor)
                }
                
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            content
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
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
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldGradient : LinearGradient(colors: [Color.white.opacity(0.8)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.06), radius: 16, y: 8)
        .padding(.horizontal, 16)
    }
}

// MARK: - Physiological Effect Row
struct PhysiologicalEffectRow: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let title: String
    let effects: [(direction: String, description: String)]
    var accentColor: Color = Color(red: 0.2, green: 0.5, blue: 0.9)
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 50, height: 50)
                
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                ForEach(effects, id: \.description) { effect in
                    HStack(spacing: 6) {
                        Image(systemName: effect.direction == "up" ? "arrow.up" : "arrow.down")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(effect.direction == "up" ? Color(red: 0.02, green: 0.6, blue: 0.4) : Color(red: 0.75, green: 0.22, blue: 0.27))
                        
                        Text(effect.description)
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue.opacity(0.6))
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
                .stroke(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.8), lineWidth: 1)
        )
    }
}

// MARK: - Main View
struct TTMView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresentedTTM = false
    @State private var isAppearing = false
    
    // Colors
    private let accentBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    private let accentTeal = Color(red: 0.0, green: 0.71, blue: 0.85)
    private let accentRed = Color(red: 0.75, green: 0.22, blue: 0.27)
    private let accentGreen = Color(red: 0.02, green: 0.6, blue: 0.4)
    private let accentOrange = Color(red: 0.96, green: 0.55, blue: 0.22)
    private let goldColor = Color(red: 0.79, green: 0.64, blue: 0.15)
    
    var body: some View {
        ZStack {
            TTMBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    // Clinical Context Card
                    TTMGlassCard(
                        title: "Why This Matters",
                        icon: "brain.head.profile",
                        accentColor: accentBlue
                    ) {
                        Text(TTMContentFormatter.format(
                            """
                            After cardiac arrest, the brain is vulnerable. Even after ROSC, ongoing inflammation and reperfusion injury continue to cause damage.
                            
                            The Goal:
                            TTM slows metabolism, reduces oxygen demand, and limits secondary brain injury. You're buying time for the brain to recover.
                            
                            The Key Insight:
                            Fever is the enemy. Even mild hyperthermia after arrest worsens outcomes. At minimum, prevent fever. Therapeutic cooling may offer additional benefit.
                            """,
                            headings: ["The Goal:", "The Key Insight:"]
                        ))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 30)
                    
                    // Temperature Targets Card
                    TTMGlassCard(
                        title: "Temperature Targets",
                        icon: "thermometer.medium",
                        accentColor: accentTeal
                    ) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(TTMContentFormatter.format(
                                """
                                Target Range (2025 Update):
                                32-37.5°C — expanded range includes normothermic strategies (fever prevention)
                                
                                Duration (2025 Update):
                                Maintain target for at least 36 hours (increased from 24 hours)
                                
                                Rewarming:
                                Slow and controlled: 0.25-0.5°C per hour
                                Rapid rewarming causes rebound injury
                                
                                2025 Key Point:
                                Both hypothermic (32-34°C) and normothermic (35-37.5°C) strategies are acceptable. Preventing fever is critical.
                                """,
                                headings: ["Target Range (2025 Update):", "Duration (2025 Update):", "Rewarming:", "2025 Key Point:"]
                            ))
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                            
                            // Quick reference box - 2025 Updated
                            HStack(spacing: 12) {
                                VStack(spacing: 4) {
                                    Text("TARGET")
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .foregroundColor(Color(red: 0.42, green: 0.49, blue: 0.54))
                                    Text("32-37.5°C")
                                        .font(.custom("Poppins-Bold", size: 16))
                                        .foregroundColor(accentTeal)
                                    Text("2025")
                                        .font(.custom("Poppins-Medium", size: 8))
                                        .foregroundColor(accentOrange)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(accentTeal.opacity(0.08))
                                .cornerRadius(12)
                                
                                VStack(spacing: 4) {
                                    Text("DURATION")
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .foregroundColor(Color(red: 0.42, green: 0.49, blue: 0.54))
                                    Text("≥36 hrs")
                                        .font(.custom("Poppins-Bold", size: 16))
                                        .foregroundColor(accentBlue)
                                    Text("2025")
                                        .font(.custom("Poppins-Medium", size: 8))
                                        .foregroundColor(accentOrange)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(accentBlue.opacity(0.08))
                                .cornerRadius(12)
                                
                                VStack(spacing: 4) {
                                    Text("REWARM")
                                        .font(.custom("Poppins-Medium", size: 10))
                                        .foregroundColor(Color(red: 0.42, green: 0.49, blue: 0.54))
                                    Text("0.25°C/hr")
                                        .font(.custom("Poppins-Bold", size: 16))
                                        .foregroundColor(accentOrange)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(accentOrange.opacity(0.08))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 40)
                    
                    // Monitoring Card
                    TTMGlassCard(
                        title: "Temperature Monitoring",
                        icon: "waveform.path.ecg",
                        accentColor: accentGreen
                    ) {
                        Text(TTMContentFormatter.format(
                            """
                            Continuous core temperature monitoring is essential. Peripheral sites (axillary, oral) are unreliable.
                            
                            Best Sites:
                            • Esophageal — fastest, most accurate (5 min lag)
                            • Bladder — practical, widely available
                            • Rectal — acceptable but slower response
                            
                            What You'll See:
                            Core temperature lags behind cooling interventions. Don't overshoot—anticipate the drift.
                            """,
                            headings: ["Best Sites:", "What You'll See:"]
                        ))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 50)
                    
                    // Cooling Methods Card
                    TTMGlassCard(
                        title: "Cooling Methods",
                        icon: "snowflake",
                        accentColor: accentBlue
                    ) {
                        Text(TTMContentFormatter.format(
                            """
                            Surface Cooling:
                            Water blankets and gel pad devices are most common. Gel pads provide faster induction and tighter control than blankets.
                            
                            Intravascular Cooling:
                            Catheter-based systems offer precise control but require central access. Similar efficacy to surface methods.
                            
                            Cold Saline:
                            Can help initiate cooling but don't rely on it alone. Risk of pulmonary edema if overused.
                            
                            The Bottom Line:
                            Use what your institution has. Consistent temperature control matters more than the specific method.
                            """,
                            headings: ["Surface Cooling:", "Intravascular Cooling:", "Cold Saline:", "The Bottom Line:"]
                        ))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Cooling Phase Side Effects
                    TTMGlassCard(
                        title: "Cooling Phase Complications",
                        icon: "exclamationmark.triangle.fill",
                        accentColor: accentRed
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(TTMContentFormatter.format(
                                """
                                Shivering:
                                Starts around 35.5°C, stops around 33.5°C. Increases metabolic demand and defeats the purpose of cooling. Treat aggressively with sedation, paralytics if needed.
                                
                                Bradycardia:
                                Expected. HR typically drops 10-15 bpm per degree. Usually well-tolerated—don't reflexively treat unless causing hypotension.
                                
                                Coagulopathy:
                                Enzyme dysfunction below 33°C. Platelet dysfunction below 35°C. Watch for bleeding but don't withhold TTM for minor coagulopathy.
                                
                                Electrolyte Shifts:
                                Potassium and magnesium drop as they shift intracellularly. Monitor and replace.
                                
                                Hyperglycemia:
                                Insulin resistance increases. Monitor glucose closely.
                                """,
                                headings: ["Shivering:", "Bradycardia:", "Coagulopathy:", "Electrolyte Shifts:", "Hyperglycemia:"]
                            ))
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    // Rewarming Phase Side Effects
                    TTMGlassCard(
                        title: "Rewarming Phase Complications",
                        icon: "flame.fill",
                        accentColor: accentOrange
                    ) {
                        Text(TTMContentFormatter.format(
                            """
                            Why Slow Rewarming Matters:
                            Rapid rewarming reverses the protective effects of cooling. It triggers vasodilation, hypotension, and metabolic instability.
                            
                            Vasodilation & Hypotension:
                            Expect vasodilation as temperature rises. May need volume or vasopressors temporarily.
                            
                            Rebound Hyperthermia:
                            Common if cooling is stopped abruptly. Can worsen neurological injury. Continue temperature monitoring for 48-72 hours.
                            
                            Hyperkalemia:
                            Potassium shifts back out of cells during rewarming. The patient who was hypokalemic during cooling may become hyperkalemic during rewarming.
                            
                            Infection Risk:
                            TTM suppresses immune function. Maintain high suspicion for sepsis, especially pneumonia.
                            """,
                            headings: ["Why Slow Rewarming Matters:", "Vasodilation & Hypotension:", "Rebound Hyperthermia:", "Hyperkalemia:", "Infection Risk:"]
                        ))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Physiological Effects Section
                    sectionHeader("Physiological Effects by System")
                    
                    VStack(spacing: 12) {
                        PhysiologicalEffectRow(
                            icon: "icons-heart",
                            title: "Cardiovascular",
                            effects: [
                                ("down", "Cardiac output"),
                                ("down", "Heart rate"),
                                ("up", "Risk of arrhythmias"),
                                ("up", "Peripheral vasoconstriction")
                            ],
                            accentColor: accentRed
                        )
                        
                        PhysiologicalEffectRow(
                            icon: "Kidneys",
                            title: "Renal & Electrolytes",
                            effects: [
                                ("up", "Urine output (cold diuresis)"),
                                ("down", "K+, Mg2+, Phosphate"),
                                ("up", "Intracellular electrolyte shifts")
                            ],
                            accentColor: accentTeal
                        )
                        
                        PhysiologicalEffectRow(
                            icon: "icon-pancreas",
                            title: "Endocrine",
                            effects: [
                                ("down", "Insulin secretion"),
                                ("up", "Insulin resistance"),
                                ("up", "Hyperglycemia")
                            ],
                            accentColor: accentOrange
                        )
                        
                        PhysiologicalEffectRow(
                            icon: "Lungs",
                            title: "Pulmonary",
                            effects: [
                                ("down", "CO₂ sensitivity"),
                                ("up", "Hemoglobin O₂ affinity"),
                                ("up", "Anatomic dead space")
                            ],
                            accentColor: accentBlue
                        )
                        
                        PhysiologicalEffectRow(
                            icon: "Liver",
                            title: "Hepatic",
                            effects: [
                                ("down", "Drug metabolism (CYP450)")
                            ],
                            accentColor: accentGreen
                        )
                        
                        PhysiologicalEffectRow(
                            icon: "Coags",
                            title: "Coagulation",
                            effects: [
                                ("down", "Platelet aggregation"),
                                ("down", "Clotting factor activity")
                            ],
                            accentColor: Color(red: 0.58, green: 0.44, blue: 0.86)
                        )
                        
                        PhysiologicalEffectRow(
                            icon: "immunology",
                            title: "Immune System",
                            effects: [
                                ("up", "Infection risk"),
                                ("down", "Immune function")
                            ],
                            accentColor: accentRed
                        )
                    }
                    .padding(.horizontal, 16)
                    
                    // Clinical Takeaway - Updated for 2025
                    signatureCard(
                        text: "2025 Update: Temperature control for ≥36 hours (increased from 24). Target 32-37.5°C—both hypothermic and normothermic strategies are acceptable. The key is preventing fever (hyperthermia worsens outcomes). Rewarm slowly and anticipate physiological shifts at each phase."
                    )
                    .padding(.top, 8)
                    
                    Spacer(minLength: 60)
                }
                .padding(.top, 20)
            }
            
            // Close Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.35))
                            .frame(width: 36, height: 36)
                            .background(
                                Group {
                                    if colorScheme == .dark {
                                        Circle()
                                            .fill(CriticalDesign.Colors.cardBlue)
                                    } else {
                                        ZStack {
                                            Circle()
                                                .fill(.ultraThinMaterial)
                                            Circle()
                                                .fill(Color.white.opacity(0.7))
                                        }
                                    }
                                }
                            )
                            .overlay(
                                Circle()
                                    .stroke(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.9), lineWidth: 1)
                            )
                            .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
        .fullScreenCover(isPresented: $isPresentedTTM) {
            PhotoView(image: "Therapeutic-Hypothermia")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(accentBlue.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                ZStack {
                    Group {
                        if colorScheme == .dark {
                            Circle()
                                .fill(CriticalDesign.Colors.cardBlue)
                                .frame(width: 80, height: 80)
                        } else {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 80, height: 80)
                                Circle()
                                    .fill(Color.white.opacity(0.6))
                                    .frame(width: 80, height: 80)
                            }
                        }
                    }

                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: colorScheme == .dark
                                    ? [Color.white.opacity(0.08), Color.white.opacity(0.08)]
                                    : [Color.white, Color.white.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "thermometer.snowflake")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentBlue, accentTeal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .padding(.top, 40)
            
            Text("TTM")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("Target Temperature Management")
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.5))
            
            // Image preview
            Button(action: { isPresentedTTM = true }) {
                Image("Therapeutic-Hypothermia")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.8), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                                    .padding(8)
                            }
                        }
                    )
            }
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Section Header
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.7, green: 0.7, blue: 0.75), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                .textCase(.uppercase)
                .tracking(2)
                .fixedSize()
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color(red: 0.7, green: 0.7, blue: 0.75)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Signature Card
    private func signatureCard(text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(goldColor)
                Text("Clinical Takeaway")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(.white)
            }
            
            CriticalDesign.autoBoldText(text)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(red: 0.04, green: 0.09, blue: 0.16))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [goldColor, goldColor.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: goldColor.opacity(0.2), radius: 8, y: 4)
        .padding(.horizontal, 16)
    }
}

#Preview {
    TTMView()
}
