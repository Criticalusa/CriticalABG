//
//  ExternalPacingFunctionsView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 2/8/24.
//  Redesigned: Premium Light Theme with external pacer controls
//

import SwiftUI

// MARK: - Control Card
struct PacerControlCard: View {
    @Environment(\.colorScheme) var colorScheme
    let number: String
    let title: String
    let description: String
    let accentColor: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Number indicator with vertical line
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(accentColor)
                        .frame(width: 32, height: 32)
                    
                    Text(number)
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(.white)
                }
                
                Rectangle()
                    .fill(accentColor.opacity(0.3))
                    .frame(width: 2)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text(description)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.35))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Main View
struct ExternalPacingFunctionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showImageFullscreen = false
    
    // Colors
    private let accentRed = Color(red: 0.90, green: 0.22, blue: 0.27)
    private let accentOrange = Color(red: 0.96, green: 0.55, blue: 0.22)
    private let accentBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    private let accentPurple = Color(red: 0.58, green: 0.44, blue: 0.86)
    private let accentGreen = Color(red: 0.16, green: 0.62, blue: 0.56)
    private let accentTeal = Color(red: 0.0, green: 0.71, blue: 0.85)
    
    var body: some View {
        ZStack {
            PacemakerLightBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    // MARK: - Device Image
                    deviceImageCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 25)
                    
                    // MARK: - Controls Section
                    PacemakerSectionDivider(title: "Device Controls")
                    
                    controlsSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 30)
                    
                    // MARK: - Modes Section
                    PacemakerSectionDivider(title: "Pacing Modes")
                        .padding(.top, 8)
                    
                    modesCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 35)
                    
                    // MARK: - Emergency Section
                    emergencyCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)
                    
                    // MARK: - Important Note
                    importantNote
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 45)
                    
                    // MARK: - Clinical Takeaway
                    clinicalTakeaway
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 50)
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .fullScreenCover(isPresented: $showImageFullscreen) {
            PhotoView(image: "ExternalPacemaker")
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
                    .fill(accentGreen.opacity(0.15))
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
                    
                    Image(systemName: "dial.medium.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentGreen, accentGreen.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .padding(.top, 20)
            
            Text("External Pacing")
                .font(.custom("Poppins-Bold", size: 30))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("Temporary pacemaker controls & functions")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.5))
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Device Image Card
    private var deviceImageCard: some View {
        Button(action: { showImageFullscreen = true }) {
            VStack(spacing: 12) {
                Image("ExternalPacemaker")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                HStack(spacing: 6) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 12))
                    Text("Tap to enlarge")
                        .font(.custom("Poppins-Medium", size: 12))
                }
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Controls Section
    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            PacerControlCard(
                number: "1",
                title: "Rate Control",
                description: "Sets the pacing rate (beats per minute). Must be set higher than the patient's intrinsic heart rate to ensure pacemaker captures consistently.",
                accentColor: accentRed
            )
            
            PacerControlCard(
                number: "2",
                title: "LED Indicators",
                description: "Visual indicators at the top of the device illuminate when sensing intrinsic activity or when pacing is delivered.",
                accentColor: accentOrange
            )
            
            PacerControlCard(
                number: "3",
                title: "Output Controls (A & V)",
                description: "These dials regulate the energy (in mA) delivered to each chamber. A-Output controls atrial pacing energy; V-Output controls ventricular pacing energy. Higher output = more energy to capture the myocardium.",
                accentColor: accentBlue
            )
            
            PacerControlCard(
                number: "4",
                title: "Sensitivity Control",
                description: "Adjusts how much intrinsic electrical activity the pacer needs to detect to recognize a heartbeat. Lower number = more sensitive. Higher number = less sensitive.",
                accentColor: accentPurple
            )
            
            PacerControlCard(
                number: "5",
                title: "Mode Selector",
                description: "Displays and selects the current pacing mode. Options include asynchronous (fixed rate) and synchronous (demand) modes.",
                accentColor: accentGreen
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
    }
    
    // MARK: - Modes Card
    private var modesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentTeal)
                    .frame(width: 4, height: 20)
                
                Text("Asynchronous vs. Demand")
                    .font(.custom("Poppins-SemiBold", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Asynchronous (Fixed) Mode")
                        .font(.custom("Poppins-SemiBold", size: 15))
                        .foregroundColor(accentOrange)
                    
                    Text("Delivers pacing stimulus at a fixed rate regardless of intrinsic cardiac activity. The pacer ignores the heart's rhythm completely.\n\nUse when: Electromagnetic interference is present, or intrinsic sensing is unreliable.")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.35))
                        .lineSpacing(4)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Synchronous (Demand) Mode")
                        .font(.custom("Poppins-SemiBold", size: 15))
                        .foregroundColor(accentGreen)
                    
                    Text("Only delivers pacing when the patient's heart rate falls below the set rate. Senses intrinsic activity and withholds pacing when not needed.\n\nUse when: Patient has some intrinsic rhythm you want to preserve.")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.35))
                        .lineSpacing(4)
                }
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
    
    // MARK: - Emergency Card
    private var emergencyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                
                Text("Emergency Button (DOO)")
                    .font(.custom("Poppins-Bold", size: 17))
                    .foregroundColor(.white)
            }
            
            Text("When pressed, the pacer immediately enters dual-chamber asynchronous mode (DOO), pacing both atrium and ventricle at maximum output.\n\nThis ensures cardiac output when you can't wait to troubleshoot. Use when the patient is deteriorating and you need guaranteed pacing NOW.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(accentRed)
        )
        .shadow(color: accentRed.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Important Note
    private var importantNote: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(accentBlue)
                
                Text("Remember")
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            Text("Temporary pacing (transvenous, transcutaneous, epicardial) is a bridge. These interventions stabilize the patient until a permanent solution—like an implanted pacemaker—can be implemented.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(accentBlue)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(accentBlue.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(accentBlue.opacity(0.2), lineWidth: 1)
        )
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
            
            Text("Know where the emergency button is. Set rate above intrinsic rate. Start with higher output and titrate down to threshold + safety margin. When in doubt, increase output and call for help.")
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
    ExternalPacingFunctionsView()
}
