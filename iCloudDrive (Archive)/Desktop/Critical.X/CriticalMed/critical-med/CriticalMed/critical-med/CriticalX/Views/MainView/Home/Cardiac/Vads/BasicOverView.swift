//
//  BasicOverView.swift
//  CriticalX
//
//  Created by Macbook 4 on 23/11/2021.
//  Updated: Teaching Style Guide compliant
//

import SwiftUI

// MARK: - Custom Components
struct VADInfoCard: View {
    let title: String
    let content: String
    var accentColor: Color = .white
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(width: 4, height: 20)
                
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 17))
                    .foregroundColor(.white)
            }
            
            Text(content)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(.white.opacity(0.85))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(accentColor.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Warning Card
struct VADWarningCard: View {
    let title: String
    let content: String
    
    private let goldColor = Color(red: 0.79, green: 0.64, blue: 0.15)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(goldColor)
                
                Text(title)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(goldColor)
            }
            
            Text(content)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(goldColor.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(goldColor.opacity(0.4), lineWidth: 1)
        )
    }
}

struct BasicOverView: View {
    
    @Environment(\.dismiss) var dismiss
    
    private let accentTeal = Color(red: 0.0, green: 0.71, blue: 0.85)
    private let accentGold = Color(red: 0.79, green: 0.64, blue: 0.15)
   
    var body: some View {
        
        ZStack {
            // Animated background with subtle gold orbs
            VADAdaptiveBackground()
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    // Sheet drag indicator
                    Capsule()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                    
                    // MARK: - Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(accentTeal.opacity(0.15))
                                .frame(width: 100, height: 100)
                                .blur(radius: 15)
                            
                            Image("icon-vad")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                        }
                       
                        Text("VAD Fundamentals")
                            .font(.custom("Poppins-Bold", size: 32))
                            .foregroundColor(.white)
                        
                        Text("What you need to know before approaching any VAD patient")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: - Content Cards
                    VStack(spacing: 16) {
                        
                        VADInfoCard(
                            title: "Why This Matters",
                            content: "A VAD is a mechanical pump that supports a failing heart. You'll see these in patients with end-stage heart failure—either bridging to transplant or as permanent therapy.\n\nThe key insight: these devices can maintain perfusion even when the native heart is barely contributing. A pulseless patient can be stable and talking.",
                            accentColor: accentTeal
                        )
                        
                        VADInfoCard(
                            title: "Two Types of Flow",
                            content: "Pulsatile (TAH): Creates a pulse. You can feel it and get a BP with a cuff.\n\nContinuous (HeartMate, HVAD, Impella): No pulse. Blood pressure requires a Doppler—the first sound you hear is the MAP.",
                            accentColor: .white
                        )
                        
                        VADInfoCard(
                            title: "The Hardware",
                            content: "Controller: The brain. Shows flow, speed, and alarms.\n\nDriveline: The lifeline. Connects pump to controller. Never pull on it.\n\nBatteries: Usually two. Know when they expire.\n\nPump: Inside the patient. You can't see it, but you can sometimes hear it.",
                            accentColor: .white
                        )
                        
                        VADInfoCard(
                            title: "Key Parameters",
                            content: "Flow (L/min): How much blood is moving. Low flow = problem.\n\nSpeed (RPM): How fast the pump spins. Set by the team.\n\nPower (Watts): Energy consumption. Sudden increase suggests thrombus.\n\nPulsatility Index (PI): How much the native heart is contributing. Higher PI = better native function.",
                            accentColor: .white
                        )
                        
                        VADWarningCard(
                            title: "Universal VAD Rules",
                            content: "• Always call the VAD team early\n• Never disconnect power without a backup\n• CPR is a last resort—auscultate first\n• These patients are anticoagulated (bleeding risk)\n• MAP targets are lower than you think (70–85)"
                        )
                        
                        VADInfoCard(
                            title: "When Things Go Wrong",
                            content: "Low flow alarm?\nThink: Hypovolemia, suction, RV failure, thrombus.\n\nPatient unresponsive?\nListen for pump hum. Check power. Get a Doppler BP.\n\nBleeding?\nCommon. GI bleeds are frequent. Don't stop anticoagulation without consulting VAD team.\n\nInfection?\nDriveline site is vulnerable. Look for erythema, drainage.",
                            accentColor: Color(red: 0.90, green: 0.22, blue: 0.27)
                        )
                        
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - Clinical Takeaway
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .foregroundColor(accentGold)
                            Text("Clinical Takeaway")
                                .font(.custom("Poppins-Bold", size: 15))
                                .foregroundColor(.white)
                        }
                        
                        Text("VAD patients look different. No pulse doesn't mean no perfusion. Your job is to recognize what's normal for them, identify when something's wrong, and call the experts early. The device is keeping them alive—your job is to not interrupt that.")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(4)
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
                                    colors: [accentGold.opacity(0.6), accentGold.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct BasicOverView_Previews: PreviewProvider {
    static var previews: some View {
        BasicOverView()
    }
}
