//
//  PacingModesView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 2/8/24.
//  Redesigned: Premium Light Theme with comprehensive pacing modes
//

import SwiftUI

// MARK: - Pacing Mode Card
struct PacingModeCard: View {
    @Environment(\.colorScheme) var colorScheme
    let code: String
    let name: String
    let description: String
    let accentColor: Color
    let isEmergency: Bool
    
    @State private var isExpanded = false
    
    init(code: String, name: String, description: String, accentColor: Color, isEmergency: Bool = false) {
        self.code = code
        self.name = name
        self.description = description
        self.accentColor = accentColor
        self.isEmergency = isEmergency
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 14) {
                    // Vertical accent line
                    RoundedRectangle(cornerRadius: 2)
                        .fill(accentColor)
                        .frame(width: 4, height: 44)
                    
                    // Code badge
                    Text(code)
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(accentColor)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        
                        if isEmergency {
                            Text("Emergency Use")
                                .font(.custom("Poppins-Medium", size: 11))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule().fill(accentColor)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .background(Color.gray.opacity(0.2))
                        .padding(.horizontal, 16)
                    
                    Text(description)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.7))
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isExpanded ? accentColor.opacity(0.3) : (colorScheme == .dark ? Color.white.opacity(0.15) : Color.white.opacity(0.8)), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Code Letter Explanation Card
struct CodeLetterCard: View {
    @Environment(\.colorScheme) var colorScheme
    let position: String
    let letter: String
    let meaning: String
    let options: [(letter: String, description: String)]
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Position indicator
                Text(position)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(accentColor))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(letter)
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Text(meaning)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }
            
            // Options
            VStack(alignment: .leading, spacing: 6) {
                ForEach(options, id: \.letter) { option in
                    HStack(spacing: 10) {
                        Text(option.letter)
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(accentColor)
                            .frame(width: 24)
                        
                        Text("=")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        
                        Text(option.description)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                }
            }
            .padding(.leading, 44)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(accentColor.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(accentColor.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Main View
struct PacingModesView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    
    // Colors
    private let accentBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    private let accentTeal = Color(red: 0.0, green: 0.71, blue: 0.85)
    private let accentPurple = Color(red: 0.58, green: 0.44, blue: 0.86)
    private let accentGreen = Color(red: 0.16, green: 0.62, blue: 0.56)
    private let accentRed = Color(red: 0.90, green: 0.22, blue: 0.27)
    private let accentOrange = Color(red: 0.96, green: 0.55, blue: 0.22)
    
    var body: some View {
        ZStack {
            PacemakerLightBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    // MARK: - Mnemonic Card
                    mnemonicCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 25)
                    
                    // MARK: - Code Letters Section
                    PacemakerSectionDivider(title: "The 5-Letter Code")
                    
                    VStack(spacing: 12) {
                        CodeLetterCard(
                            position: "1st",
                            letter: "Paced Chamber",
                            meaning: "Which chamber receives the pacing stimulus",
                            options: [
                                ("A", "Atrium"),
                                ("V", "Ventricle"),
                                ("D", "Dual (Both)"),
                                ("O", "None")
                            ],
                            accentColor: accentBlue
                        )
                        
                        CodeLetterCard(
                            position: "2nd",
                            letter: "Sensed Chamber",
                            meaning: "Which chamber is monitored for intrinsic activity",
                            options: [
                                ("A", "Atrium"),
                                ("V", "Ventricle"),
                                ("D", "Dual (Both)"),
                                ("O", "None")
                            ],
                            accentColor: accentRed
                        )
                        
                        CodeLetterCard(
                            position: "3rd",
                            letter: "Response to Sensing",
                            meaning: "What the pacemaker does when it senses",
                            options: [
                                ("I", "Inhibited (withholds pacing)"),
                                ("T", "Triggered (paces in response)"),
                                ("D", "Dual (both I and T)"),
                                ("O", "None")
                            ],
                            accentColor: accentGreen
                        )
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 30)
                    
                    // MARK: - Common Modes Section
                    PacemakerSectionDivider(title: "Common Pacing Modes")
                        .padding(.top, 8)
                    
                    VStack(spacing: 10) {
                        PacingModeCard(
                            code: "AAI",
                            name: "Atrial Demand",
                            description: "The atrium is paced and sensed. If the pacemaker detects intrinsic atrial activity, it withholds (inhibits) pacing. Used when the SA node is the problem but AV conduction is intact.\n\nAAIR adds rate-responsiveness—the device adjusts pacing rate based on activity level.",
                            accentColor: accentBlue
                        )
                        
                        PacingModeCard(
                            code: "VVI",
                            name: "Ventricular Demand",
                            description: "The ventricle is paced and sensed. If intrinsic ventricular activity is detected, pacing is inhibited. The workhorse mode for chronic atrial fibrillation with slow ventricular response.\n\nVVIR adds rate-responsiveness for patients who need heart rate to increase with activity.",
                            accentColor: accentTeal
                        )
                        
                        PacingModeCard(
                            code: "DDD",
                            name: "Dual Chamber",
                            description: "Both atrium and ventricle are paced and sensed. The pacemaker maintains AV synchrony—if it senses atrial activity, it waits for ventricular activity. If the ventricle doesn't fire in time, it paces it.\n\nThis is the most physiologic mode, preserving the natural A→V timing that optimizes cardiac output.",
                            accentColor: accentPurple
                        )
                        
                        PacingModeCard(
                            code: "DDI",
                            name: "Dual Sensing, Inhibition Only",
                            description: "Paces both chambers, senses both chambers, but only inhibits (no tracking). Atrial pacing occurs at the programmed lower rate. After atrial pacing, ventricular pacing follows the AV delay if no ventricular event is sensed.\n\nUseful when you want AV synchrony but need to avoid tracking atrial arrhythmias.",
                            accentColor: accentOrange
                        )
                        
                        PacingModeCard(
                            code: "VOO",
                            name: "Asynchronous Ventricular",
                            description: "Paces the ventricle at a fixed rate regardless of intrinsic activity. No sensing occurs—the pacemaker ignores the heart's rhythm completely.\n\nUsed during surgery or when electromagnetic interference might cause inappropriate inhibition. Can cause R-on-T if competing with intrinsic rhythm. Not for long-term use.",
                            accentColor: accentOrange,
                            isEmergency: false
                        )
                        
                        PacingModeCard(
                            code: "DOO",
                            name: "Asynchronous AV Sequential",
                            description: "Paces both atrium and ventricle at fixed rates without sensing. AV sequential pacing at ~80 BPM regardless of intrinsic activity.\n\nThis is the EMERGENCY mode—activated by pressing the emergency button on external pacers. Ensures pacing output when sensing might be compromised.",
                            accentColor: accentRed,
                            isEmergency: true
                        )
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 35)
                    
                    // MARK: - EKG Insights
                    PacemakerSectionDivider(title: "EKG Recognition")
                        .padding(.top, 8)
                    
                    ekgInsightsCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)
                    
                    // MARK: - Clinical Takeaway
                    clinicalTakeaway
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 45)
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(accentPurple.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.6))
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.white, lineWidth: 1.5)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentPurple, accentPurple.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .padding(.top, 20)
            
            Text("Pacing Modes")
                .font(.custom("Poppins-Bold", size: 30))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("Understanding the 5-letter code")
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.5))
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Mnemonic Card
    private var mnemonicCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(accentOrange)
                    .font(.system(size: 18))
                
                Text("P.A.C.E.R.S. Mnemonic")
                    .font(.custom("Poppins-Bold", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                mnemonicRow("P", "Paced chamber")
                mnemonicRow("A", "Area which is sensed")
                mnemonicRow("C", "Capture/response to sensing")
                mnemonicRow("E", "Exercise (rate adaptiveness)")
                mnemonicRow("R", "Response to sensing")
                mnemonicRow("S", "Special functions (anti-tachy, shock)")
            }
            
            Text("In practice, focus on the first 3 letters—they tell you the essentials.")
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(accentBlue)
                .padding(.top, 4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(accentOrange.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: accentOrange.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func mnemonicRow(_ letter: String, _ meaning: String) -> some View {
        HStack(spacing: 12) {
            Text(letter)
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(accentOrange)
                .frame(width: 24)
            
            Text(meaning)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
    }
    
    // MARK: - EKG Insights Card
    private var ekgInsightsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentTeal)
                    .frame(width: 4, height: 20)
                
                Text("What You'll See on the EKG")
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ekgRow(color: accentOrange, text: "Pacer spike before P wave", meaning: "Atrial pacing")
                ekgRow(color: accentTeal, text: "Pacer spike before QRS", meaning: "Ventricular pacing")
                ekgRow(color: accentPurple, text: "Spikes before both P and QRS", meaning: "Dual-chamber pacing")
            }
            
            Divider()
                .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Ventricular Paced Morphology")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                
                Text("RV apical pacing produces a LBBB-like pattern with left axis deviation. V5-V6 show consistently negative QRS—this distinguishes paced rhythm from true LBBB.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.4))
                    .lineSpacing(4)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(accentTeal.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
    
    private func ekgRow(color: Color, text: String, meaning: String) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("→")
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            
            Text(meaning)
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(color)
        }
    }
    
    // MARK: - Clinical Takeaway
    private var clinicalTakeaway: some View {
        let goldColor = Color(red: 0.79, green: 0.64, blue: 0.15)
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(goldColor)
                Text("Clinical Takeaway")
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(.white)
            }
            
            Text("The first 3 letters tell you everything you need at the bedside: what's being paced, what's being sensed, and what happens when sensing occurs. DDD is the most physiologic. DOO is for emergencies. VVI is for afib.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 0.09, green: 0.15, blue: 0.24))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [goldColor.opacity(0.6), goldColor.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: goldColor.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    PacingModesView()
}
