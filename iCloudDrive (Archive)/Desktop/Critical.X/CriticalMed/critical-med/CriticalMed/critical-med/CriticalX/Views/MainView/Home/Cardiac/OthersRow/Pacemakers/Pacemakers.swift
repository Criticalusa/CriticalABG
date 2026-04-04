//
//  Pacemakers.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 2/7/24.
//  Redesigned: Premium Light Theme Pacemaker Hub
//

import SwiftUI

// MARK: - Animated Light Background
struct PacemakerLightBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false
    
    private let accentBlue = Color(red: 0.2, green: 0.5, blue: 0.9).opacity(0.06)
    private let accentTeal = Color(red: 0.0, green: 0.71, blue: 0.85).opacity(0.05)
    
    var body: some View {
        ZStack {
            // Adaptive base background
            if colorScheme == .dark {
                CriticalDesign.Colors.darkCanvas
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.96, green: 0.97, blue: 0.98),
                        Color(red: 0.93, green: 0.94, blue: 0.98),
                        Color(red: 0.96, green: 0.97, blue: 0.98)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            // Animated floating orbs
            GeometryReader { geo in
                Circle()
                    .fill(accentBlue)
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                        y: animate ? geo.size.height * 0.2 : geo.size.height * 0.4
                    )
                
                Circle()
                    .fill(accentTeal)
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

// MARK: - Pacemaker Glass Card
struct PacemakerGlassCard: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let systemIcon: Bool
    let title: String
    let subtitle: String
    var accentColor: Color = Color(red: 0.2, green: 0.5, blue: 0.9)
    
    init(icon: String, title: String, subtitle: String, accentColor: Color = Color(red: 0.2, green: 0.5, blue: 0.9), systemIcon: Bool = true) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.accentColor = accentColor
        self.systemIcon = systemIcon
    }
    
    var body: some View {
        HStack(spacing: 14) {
            // Vertical accent line
            RoundedRectangle(cornerRadius: 2)
                .fill(accentColor)
                .frame(width: 4, height: 50)
            
            // Icon badge
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                
                if systemIcon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(accentColor)
                } else {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.7))
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldGradient : LinearGradient(colors: [Color.white.opacity(0.8)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
        )
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.5) : Color.black.opacity(0.05), radius: 12, y: 6)
        .contentShape(Rectangle())
    }
}

// MARK: - Section Divider
struct PacemakerSectionDivider: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [CriticalDesign.Adaptive.textTertiary(for: colorScheme).opacity(0.4), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .textCase(.uppercase)
                .tracking(2)
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, CriticalDesign.Adaptive.textTertiary(for: colorScheme).opacity(0.4)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Main View
struct Pacemakers: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
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
            // Animated light background
            PacemakerLightBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    
                    // MARK: - Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    // MARK: - Foundation Section
                    PacemakerSectionDivider(title: "Fundamentals")
                    
                    VStack(spacing: 12) {
                        NavigationLink(destination: IntroductionView()) {
                            PacemakerGlassCard(
                                icon: "heart.circle.fill",
                                title: "Introduction",
                                subtitle: "Indications & basic concepts",
                                accentColor: accentBlue
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink(destination: TypesOfPacemakersView()) {
                            PacemakerGlassCard(
                                icon: "rectangle.split.3x1.fill",
                                title: "Types of Pacemakers",
                                subtitle: "Single, dual, biventricular & ICDs",
                                accentColor: accentTeal
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 30)
                    
                    // MARK: - Clinical Application Section
                    PacemakerSectionDivider(title: "Clinical Application")
                        .padding(.top, 8)
                    
                    VStack(spacing: 12) {
                        NavigationLink(destination: PacingModesView()) {
                            PacemakerGlassCard(
                                icon: "waveform.path.ecg",
                                title: "Pacing Modes",
                                subtitle: "AAI, VVI, DDD & code interpretation",
                                accentColor: accentPurple
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink(destination: ExternalPacingFunctionsView()) {
                            PacemakerGlassCard(
                                icon: "dial.medium.fill",
                                title: "External Pacing Functions",
                                subtitle: "Temporary pacing controls & settings",
                                accentColor: accentGreen
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 40)
                    
                    // MARK: - Troubleshooting Section
                    PacemakerSectionDivider(title: "Troubleshooting")
                        .padding(.top, 8)
                    
                    NavigationLink(destination: MalfunctionListView()) {
                        PacemakerGlassCard(
                            icon: "exclamationmark.triangle.fill",
                            title: "Pacemaker Malfunctions",
                            subtitle: "Sensing, capture & output failures",
                            accentColor: accentRed
                        )
                    }
                    .buttonStyle(.plain)
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 50)
                    
                    // Bottom spacing
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            // MARK: - Close Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
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
                                    .stroke(colorScheme == .dark ? Color.white.opacity(0.15) : Color.white.opacity(0.9), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
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
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Pacemaker icon with glass container
            ZStack {
                // Soft glow
                Circle()
                    .fill(accentBlue.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                // Glass circle
                ZStack {
                    if colorScheme == .dark {
                        Circle()
                            .fill(CriticalDesign.Colors.cardBlue)
                            .frame(width: 80, height: 80)
                    } else {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 80, height: 80)
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 80, height: 80)
                    }

                    Circle()
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.15) : Color.white, lineWidth: 1.5)
                        .frame(width: 80, height: 80)

                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentBlue, accentBlue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .padding(.top, 40)
            
            Text("Pacemakers")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("Electrical Cardiac Support")
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.5))
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    Pacemakers()
}
