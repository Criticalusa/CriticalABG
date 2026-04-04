//
//  TypesOfPacemakersView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 2/8/24.
//  Redesigned: Premium Light Theme with comprehensive pacemaker types
//

import SwiftUI

// MARK: - Pacemaker Type Card
struct PacemakerTypeCard: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let subtitle: String
    let description: String
    let chambers: String
    let indication: String
    let accentColor: Color
    let icon: String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header - always visible
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 14) {
                    // Vertical accent line
                    RoundedRectangle(cornerRadius: 2)
                        .fill(accentColor)
                        .frame(width: 4, height: 50)
                    
                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(accentColor.opacity(0.12))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.custom("Poppins-SemiBold", size: 17))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        
                        Text(subtitle)
                            .font(.custom("Poppins-Regular", size: 13))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(accentColor.opacity(0.7))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Divider()
                        .background(Color.gray.opacity(0.2))
                    
                    // Description
                    Text(description)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Chambers
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 14))
                            .foregroundColor(accentColor)
                            .frame(width: 20)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Chambers Paced")
                                .font(.custom("Poppins-SemiBold", size: 12))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            
                            Text(chambers)
                                .font(.custom("Poppins-Medium", size: 14))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        }
                    }
                    
                    // Indication
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 14))
                            .foregroundColor(accentColor)
                            .frame(width: 20)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Primary Indication")
                                .font(.custom("Poppins-SemiBold", size: 12))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            
                            Text(indication)
                                .font(.custom("Poppins-Medium", size: 14))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.7))
                
                if colorScheme != .dark {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.9), Color.white.opacity(0.3), Color.clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    isExpanded ? accentColor.opacity(0.3) : (colorScheme == .dark ? Color.white.opacity(0.15) : Color.white.opacity(0.8)),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
        .shadow(color: accentColor.opacity(isExpanded ? 0.1 : 0.04), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Main View
struct TypesOfPacemakersView: View {
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
            // Background
            PacemakerLightBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    // MARK: - Context Card
                    contextCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 25)
                    
                    // MARK: - Pacemaker Types
                    VStack(spacing: 14) {
                        
                        PacemakerTypeCard(
                            title: "Single-Chamber",
                            subtitle: "One lead, one chamber",
                            description: "A single lead is placed in either the right atrium (AAI) or right ventricle (VVI). The simplest form of pacemaker—used when only one chamber needs support.",
                            chambers: "Atrium OR Ventricle (not both)",
                            indication: "Sinus node dysfunction with intact AV conduction (AAI) or chronic atrial fibrillation with slow ventricular response (VVI)",
                            accentColor: accentBlue,
                            icon: "1.circle.fill"
                        )
                        
                        PacemakerTypeCard(
                            title: "Dual-Chamber",
                            subtitle: "Two leads, AV synchrony",
                            description: "One lead in the right atrium, one in the right ventricle. Maintains the natural AV timing sequence—atria contract before ventricles, preserving cardiac output.",
                            chambers: "Right Atrium + Right Ventricle",
                            indication: "AV block, sick sinus syndrome with AV conduction disease, need for AV synchrony",
                            accentColor: accentTeal,
                            icon: "2.circle.fill"
                        )
                        
                        PacemakerTypeCard(
                            title: "Biventricular (CRT)",
                            subtitle: "Three leads, resynchronization",
                            description: "Cardiac Resynchronization Therapy uses three leads: right atrium, right ventricle, and left ventricle (via coronary sinus). Coordinates contraction of both ventricles to improve efficiency in heart failure.",
                            chambers: "Right Atrium + Both Ventricles",
                            indication: "Heart failure with reduced EF (≤35%), LBBB with QRS ≥150ms, NYHA Class II-IV despite optimal medical therapy",
                            accentColor: accentPurple,
                            icon: "3.circle.fill"
                        )
                        
                        PacemakerTypeCard(
                            title: "ICD",
                            subtitle: "Pacing + defibrillation",
                            description: "Implantable Cardioverter-Defibrillator provides pacing functions PLUS the ability to detect and terminate life-threatening ventricular arrhythmias (VT/VF) via cardioversion or defibrillation.",
                            chambers: "Single or Dual Chamber + Shock Coil",
                            indication: "Secondary prevention (survived VT/VF), primary prevention in high-risk patients (EF ≤35%, ischemic or non-ischemic cardiomyopathy)",
                            accentColor: accentRed,
                            icon: "bolt.heart.fill"
                        )
                        
                        PacemakerTypeCard(
                            title: "CRT-D",
                            subtitle: "Resync + defibrillation",
                            description: "Combines biventricular pacing (CRT) with ICD capabilities. For patients who need both resynchronization therapy AND protection from sudden cardiac death.",
                            chambers: "Right Atrium + Both Ventricles + Shock Coil",
                            indication: "Heart failure meeting CRT criteria PLUS ICD indication (EF ≤35%)",
                            accentColor: accentOrange,
                            icon: "bolt.trianglebadge.exclamationmark.fill"
                        )
                        
                        PacemakerTypeCard(
                            title: "Leadless",
                            subtitle: "No leads, self-contained",
                            description: "A miniaturized, self-contained pacemaker implanted directly into the right ventricle via catheter. No leads, no pocket—reduced infection and lead complications. Currently single-chamber only.",
                            chambers: "Right Ventricle only (VVI)",
                            indication: "Patients needing VVI pacing who have limited venous access, prior lead complications, or high infection risk",
                            accentColor: accentGreen,
                            icon: "capsule.fill"
                        )
                        
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 30)
                    
                    // MARK: - Clinical Takeaway
                    clinicalTakeaway
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 35)
                    
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
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(accentTeal.opacity(0.15))
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
                    
                    Image(systemName: "rectangle.split.3x1.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentTeal, accentTeal.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .padding(.top, 20)
            
            Text("Types of Pacemakers")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .multilineTextAlignment(.center)
            
            Text("From single-chamber to CRT-D")
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.5))
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Context Card
    private var contextCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentBlue)
                    .frame(width: 4, height: 20)
                
                Text("Why This Matters")
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            Text("Not all pacemakers are the same. The type determines what chambers are paced, whether AV synchrony is maintained, and if the device can terminate arrhythmias. Knowing the type helps you anticipate what you'll see on the monitor and what complications to watch for.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.35))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(accentBlue.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
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
            
            Text("When you encounter a patient with a pacemaker, ask: Single or dual chamber? Does it have defib capability? This tells you what to expect on the EKG, whether they're protected from VT/VF, and what complications are possible.")
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
    TypesOfPacemakersView()
}
