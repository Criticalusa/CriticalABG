//
//  LeadView.swift
//  CriticalX
//
//  Created by Macbook 4 on 24/11/2021.
//  Redesigned: Premium Light Theme 12-Lead Mastery Hub
//

import SwiftUI

// MARK: - Animated Light Background
struct LeadLightAnimatedBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false
    
    // Subtle blue/teal tints for light mode
    private let tealLight = Color(red: 0.0, green: 0.71, blue: 0.85).opacity(0.08)
    private let blueLight = Color(red: 0.2, green: 0.5, blue: 0.9).opacity(0.06)
    
    var body: some View {
        ZStack {
            // Adaptive base background
            if colorScheme == .dark {
                CriticalDesign.Colors.darkCanvas
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.96, green: 0.97, blue: 0.98),  // #F5F7FA
                        Color(red: 0.93, green: 0.94, blue: 0.98),  // #EDF0FA
                        Color(red: 0.96, green: 0.97, blue: 0.98)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            // Animated floating orbs
            GeometryReader { geo in
                Circle()
                    .fill(tealLight)
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                        y: animate ? geo.size.height * 0.2 : geo.size.height * 0.4
                    )
                
                Circle()
                    .fill(blueLight)
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
            withAnimation(
                .easeInOut(duration: 12)
                .repeatForever(autoreverses: true)
            ) {
                animate = true
            }
        }
    }
}

// MARK: - Light Glass Card Component
struct LeadLightCard: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let title: String
    let subtitle: String
    var accentColor: Color = Color(red: 0.0, green: 0.71, blue: 0.85)
    
    var body: some View {
        HStack(spacing: 16) {
            // Vertical accent line
            RoundedRectangle(cornerRadius: 2)
                .fill(accentColor)
                .frame(width: 4, height: 50)
            
            // Icon badge
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
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.7))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldGradient : LinearGradient(colors: [Color.white.opacity(0.8)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.06), radius: 16, y: 8)
    }
}

// MARK: - Territory Grid Card (Light)
struct TerritoryLightCard: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let leads: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                // Vertical accent line
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 3, height: 36)
                
                // Icon with subtle glow
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(color)
                }
            }
            
            Text(title)
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text(leads)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white.opacity(0.6))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(color.opacity(colorScheme == .dark ? 0.4 : 0.2), lineWidth: 1)
        )
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.4) : Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Section Header (Light)
struct LeadLightSectionHeader: View {
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
struct LeadView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    // Sheet states
    @State private var isPresentedOverview = false
    @State private var isPresentedLead = false
    @State private var isPresentedAnterior = false
    @State private var isPresentedInferior = false
    @State private var isPresentedLateral = false
    @State private var isPresentedBrugada = false
    @State private var isPresentedWellen = false
    @State private var isPresentedSgarbossa = false
    
    @State private var isAppearing = false
    @Environment(\.presentationMode) var presentationMode
    
    // Brand Colors (Simplified per Design.md)
    // Navy for foundation, Red for STEMI territories, Gold for special patterns
    private let navyAccent = Color(red: 0.11, green: 0.33, blue: 0.34)   // #1D3557
    private let criticalRed = Color(red: 0.75, green: 0.22, blue: 0.27)  // #C03744
    private let brandGold = Color(red: 0.79, green: 0.64, blue: 0.15)    // #C9A227
    
    var body: some View {
        ZStack {
            // Animated light background
            LeadLightAnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    // MARK: - Foundation Section
                    VStack(spacing: 12) {
                        Button(action: { isPresentedOverview = true }) {
                            LeadLightCard(
                                icon: "waveform.path.ecg",
                                title: "Lead Overview",
                                subtitle: "Foundation concepts & morphology",
                                accentColor: navyAccent
                            )
                        }
                        .fullScreenCover(isPresented: $isPresentedOverview) {
                            LeadOverviewDeatil()
                        }

                        Button(action: { isPresentedLead = true }) {
                            LeadLightCard(
                                icon: "arrow.up.left.and.arrow.down.right",
                                title: "Lead Axis",
                                subtitle: "Electrical vectors & deviation",
                                accentColor: navyAccent
                            )
                        }
                        .fullScreenCover(isPresented: $isPresentedLead) {
                            LeadAxisDetailView()
                        }
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 30)
                    
                    // MARK: - STEMI Territories Section
                    LeadLightSectionHeader(title: "STEMI Territories")
                        .padding(.top, 4)
                    
                    // 2x2 Grid - All STEMI territories use criticalRed
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {

                        Button(action: { isPresentedAnterior = true }) {
                            TerritoryLightCard(
                                title: "Anterior",
                                leads: "V1-V4",
                                color: criticalRed,
                                icon: "heart.fill"
                            )
                        }
                        .fullScreenCover(isPresented: $isPresentedAnterior) {
                            AnteriorDetailView()
                        }

                        Button(action: { isPresentedInferior = true }) {
                            TerritoryLightCard(
                                title: "Inferior",
                                leads: "II, III, aVF",
                                color: criticalRed,
                                icon: "arrow.down.heart.fill"
                            )
                        }
                        .fullScreenCover(isPresented: $isPresentedInferior) {
                            InferiorWallDetailView()
                        }

                        Button(action: { isPresentedLateral = true }) {
                            TerritoryLightCard(
                                title: "Lateral",
                                leads: "I, aVL, V5-V6",
                                color: criticalRed,
                                icon: "arrow.left.and.right"
                            )
                        }
                        .fullScreenCover(isPresented: $isPresentedLateral) {
                            LateralWallDetailView()
                        }

                        Button(action: { isPresentedAnterior = true }) {
                            TerritoryLightCard(
                                title: "Septal",
                                leads: "V1-V2",
                                color: criticalRed,
                                icon: "rectangle.split.2x1.fill"
                            )
                        }
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 40)
                    
                    // MARK: - Special Patterns Section
                    LeadLightSectionHeader(title: "Special Patterns")
                        .padding(.top, 4)

                    VStack(spacing: 12) {
                        Button(action: { isPresentedBrugada = true }) {
                            LeadLightCard(
                                icon: "bolt.heart.fill",
                                title: "Brugada Syndrome",
                                subtitle: "Coved ST elevation in V1-V3",
                                accentColor: brandGold
                            )
                        }
                        .fullScreenCover(isPresented: $isPresentedBrugada) {
                            BrugadaDetailView()
                        }

                        Button(action: { isPresentedWellen = true }) {
                            LeadLightCard(
                                icon: "waveform.path.ecg.rectangle",
                                title: "Wellens' Syndrome",
                                subtitle: "Biphasic/inverted T-waves V2-V3",
                                accentColor: brandGold
                            )
                        }
                        .fullScreenCover(isPresented: $isPresentedWellen) {
                            WellenDetailView()
                        }

                        Button(action: { isPresentedSgarbossa = true }) {
                            LeadLightCard(
                                icon: "ruler",
                                title: "Sgarbossa Criteria",
                                subtitle: "STEMI detection in LBBB",
                                accentColor: brandGold
                            )
                        }
                        .fullScreenCover(isPresented: $isPresentedSgarbossa) {
                            SgarbossaDetailView()
                        }
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 50)
                    
                    // Bottom spacing
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            // MARK: - Close Button (Top Right)
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
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // EKG icon with glass container
            ZStack {
                // Soft glow
                Circle()
                    .fill(navyAccent.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)

                // Glass circle
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

                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [navyAccent, navyAccent.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .padding(.top, 40)

            Text("12-Lead Mastery")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text("EKG Morphology & Assessment")
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.bottom, 16)
    }
}

// MARK: - Preview
struct LeadView_Previews: PreviewProvider {
    static var previews: some View {
        LeadView()
    }
}
