//
//  FutureVisionPrototype2035Light.swift
//  Critical Medical Guide
//
//  Created by Claude on 2/7/26.
//  iOS UI Vision: 2035-2040 (Light Version)
//

import SwiftUI

// MARK: - Main Prototype View (Light)
struct FutureVisionPrototype2035Light: View {
    @StateObject private var unitPreference = LabUnitPreference.shared
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedPanel: (index: Int, data: LabValueDataModel)? = nil
    @State private var isAppearing = false
    @State private var searchText = ""
    @State private var hoveredIndex: Int? = nil
    @State private var pressedIndex: Int? = nil
    @State private var anticipationScale: CGFloat = 1.0
    
    // Advanced haptic patterns
    private let lightHaptic = UIImpactFeedbackGenerator(style: .soft)
    private let mediumHaptic = UIImpactFeedbackGenerator(style: .medium)
    private let heavyHaptic = UIImpactFeedbackGenerator(style: .heavy)
    
    // Simulated biometric data (would be real in 2035)
    @State private var heartRate: Double = 72.0
    @State private var ambientLight: Double = 0.5
    
    var body: some View {
        ZStack {
            // Bright atmospheric background
            brightAtmosphere
                .ignoresSafeArea()
            
            if selectedPanel == nil {
                mainGridView
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.98)),
                        removal: .opacity.combined(with: .scale(scale: 1.02))
                    ))
            } else {
                detailViewWithMorphing
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom)
                            .combined(with: .opacity)
                            .combined(with: .scale(scale: 0.92)),
                        removal: .move(edge: .bottom)
                            .combined(with: .opacity)
                            .combined(with: .scale(scale: 1.05))
                    ))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.82)) {
                isAppearing = true
            }
            startBiometricSimulation()
        }
    }
    
    // MARK: - Bright Atmosphere
    private var brightAtmosphere: some View {
        ZStack {
            // Bright gradient base
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.97, blue: 1.0)
                        .opacity(0.8 + ambientLight * 0.2),
                    Color(red: 0.92, green: 0.94, blue: 0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Subtle biometric-responsive glow
            RadialGradient(
                colors: [
                    CriticalDesign.Colors.cardBlue
                        .opacity(0.08 * (heartRate / 100.0)),
                    Color.clear
                ],
                center: .top,
                startRadius: 50,
                endRadius: 400
            )
            .blur(radius: 80)
            .scaleEffect(anticipationScale)
            .animation(
                .easeInOut(duration: 60.0 / heartRate).repeatForever(autoreverses: true),
                value: anticipationScale
            )
            
            // Accent gradient overlay
            LinearGradient(
                colors: [
                    Color(red: 0.85, green: 0.90, blue: 1.0).opacity(0.3),
                    Color.clear
                ],
                startPoint: .topTrailing,
                endPoint: .center
            )
        }
    }
    
    // MARK: - Main Grid View
    private var mainGridView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Volumetric header
                volumetricHeader
                    .padding(.top, 40)
                
                // Spatial search bar
                spatialSearchBar
                
                // Volumetric grid
                volumetricGrid
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Volumetric Header
    private var volumetricHeader: some View {
        VStack(spacing: 20) {
            // Floating icon with depth
            ZStack {
                // Shadow layer (back)
                Image("icon-lab")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 84, height: 84)
                    .blur(radius: 20)
                    .opacity(0.15)
                    .offset(y: 12)
                
                // Mid layer
                Image("icon-lab")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 82, height: 82)
                    .blur(radius: 8)
                    .opacity(0.3)
                    .offset(y: 6)
                
                // Front layer (crisp)
                Image("icon-lab")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.25), radius: 20, y: 8)
            }
            .rotation3DEffect(
                .degrees(isAppearing ? 0 : -15),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.5
            )
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : -30)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.75).delay(0.1),
                value: isAppearing
            )
            
            // Title with depth
            Text("Lab Values")
                .font(.custom("Poppins-Light", size: 38))
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.2))
                .shadow(color: Color.white.opacity(0.8), radius: 8, x: 0, y: 2)
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : -20)
                .animation(
                    .spring(response: 0.65, dampingFraction: 0.78).delay(0.2),
                    value: isAppearing
                )
            
            // Subtitle
            Text("Comprehensive Reference")
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4).opacity(0.7))
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : -15)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.8).delay(0.3),
                    value: isAppearing
                )
            
            // Volumetric unit picker
            volumetricUnitPicker
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : -10)
                .animation(
                    .spring(response: 0.55, dampingFraction: 0.82).delay(0.4),
                    value: isAppearing
                )
        }
    }
    
    // MARK: - Volumetric Unit Picker
    private var volumetricUnitPicker: some View {
        HStack(spacing: 12) {
            ForEach(LabUnitSystem.allCases, id: \.self) { system in
                Button(action: {
                    lightHaptic.impactOccurred()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        unitPreference.unitSystem = system
                    }
                }) {
                    Text(system.displayName)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(
                            unitPreference.unitSystem == system
                                ? .white
                                : Color(red: 0.3, green: 0.3, blue: 0.4).opacity(0.6)
                        )
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            ZStack {
                                if unitPreference.unitSystem == system {
                                    // Vibrant selected state
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    CriticalDesign.Colors.cardBlue,
                                                    CriticalDesign.Colors.cardBlue.opacity(0.85)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.35), radius: 12, y: 6)
                                    
                                    // Bright inner glow
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                        .blur(radius: 2)
                                } else {
                                    // Unselected glass state
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.white.opacity(0.4))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(Color(red: 0.7, green: 0.75, blue: 0.85).opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        )
                }
                .scaleEffect(unitPreference.unitSystem == system ? 1.05 : 1.0)
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.85, green: 0.88, blue: 0.95),
                                    Color(red: 0.75, green: 0.80, blue: 0.90)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: Color.black.opacity(0.08), radius: 20, y: 10)
        )
    }
    
    // MARK: - Spatial Search Bar
    private var spatialSearchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4).opacity(0.6))
            
            TextField("", text: $searchText, prompt: Text("Search lab values...").foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.5).opacity(0.5)))
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.2))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            ZStack {
                // Bright volumetric glass
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.85, green: 0.88, blue: 0.95),
                                        Color(red: 0.75, green: 0.80, blue: 0.90)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 15, y: 8)
                
                // Subtle inner highlight
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
            }
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.8).delay(0.5),
            value: isAppearing
        )
    }
    
    // MARK: - Volumetric Grid
    private var volumetricGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 18),
                GridItem(.flexible(), spacing: 18)
            ],
            spacing: 18
        ) {
            ForEach(Array(LabValueDataModel.labValueData.enumerated()), id: \.offset) { index, item in
                LightVolumetricLabCard(
                    item: item,
                    index: index,
                    isHovered: hoveredIndex == index,
                    isPressed: pressedIndex == index,
                    isAppearing: isAppearing,
                    onHover: { hovering in
                        if hovering {
                            hoveredIndex = index
                            lightHaptic.prepare()
                        } else if hoveredIndex == index {
                            hoveredIndex = nil
                        }
                    },
                    onPress: { pressing in
                        if pressing {
                            pressedIndex = index
                            mediumHaptic.impactOccurred()
                        } else {
                            pressedIndex = nil
                        }
                    },
                    onTap: {
                        heavyHaptic.impactOccurred()
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                            selectedPanel = (index: index, data: item)
                        }
                    }
                )
            }
        }
    }
    
    // MARK: - Detail View with Morphing
    private var detailViewWithMorphing: some View {
        Group {
            if let panel = selectedPanel {
                LightVolumetricDetailView(
                    data: panel.data,
                    onDismiss: {
                        heavyHaptic.impactOccurred()
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                            selectedPanel = nil
                        }
                    }
                )
            }
        }
    }
    
    // MARK: - Biometric Simulation
    private func startBiometricSimulation() {
        // Simulate heart rate variation
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                heartRate = 72.0 + Double.random(in: -5...5)
                anticipationScale = 1.0 + (heartRate - 72.0) / 500.0
            }
        }
        
        // Simulate ambient light changes
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 5.0)) {
                ambientLight = Double.random(in: 0.3...0.7)
            }
        }
    }
}

// MARK: - Light Volumetric Lab Card
struct LightVolumetricLabCard: View {
    let item: LabValueDataModel
    let index: Int
    let isHovered: Bool
    let isPressed: Bool
    let isAppearing: Bool
    let onHover: (Bool) -> Void
    let onPress: (Bool) -> Void
    let onTap: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Soft shadow layers for depth
                cardShape
                    .fill(Color.black.opacity(0.08))
                    .blur(radius: 20)
                    .offset(y: isPressed ? 8 : 16)
                
                cardShape
                    .fill(Color.black.opacity(0.04))
                    .blur(radius: 10)
                    .offset(y: isPressed ? 4 : 8)
                
                // Main card with bright glass
                cardShape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                Color.white.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        cardShape
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.85, green: 0.88, blue: 0.95),
                                        Color(red: 0.75, green: 0.80, blue: 0.90)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                
                // Content
                VStack(spacing: 8) {
                    // Icon with depth
                    ZStack {
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 68, height: 68)
                            .blur(radius: 8)
                            .opacity(0.2)
                            .offset(y: 4)
                        
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64)
                            .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.2), radius: 12, y: 4)
                    }
                    .rotation3DEffect(
                        .degrees(isHovered ? 5 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    
                    // Text content
                    VStack(spacing: 6) {
                        Text(item.title)
                            .font(.custom("Poppins-Medium", size: 16))
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.2))
                            .shadow(color: Color.white.opacity(0.8), radius: 4, y: 1)
                        
                        Text(item.subTitle)
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4).opacity(0.7))
                        
                        // Test count badge
                        HStack(spacing: 4) {
                            Text("\(item.labValueDetail.btnData.count)")
                                .font(.custom("Poppins-Medium", size: 12))
                                .foregroundColor(CriticalDesign.Colors.cardBlue)
                            
                            Text("tests")
                                .font(.custom("Poppins-Regular", size: 10))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.5).opacity(0.6))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.9, green: 0.92, blue: 0.96))
                        )
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 18)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 190)
        .scaleEffect(
            isPressed ? 0.93 :
            isHovered ? 1.03 :
            (isAppearing ? 1.0 : 0.85)
        )
        .rotation3DEffect(
            .degrees(isHovered ? -2 : 0),
            axis: (x: 1, y: 0, z: 0),
            perspective: 0.6
        )
        .offset(y: isPressed ? 4 : 0)
        .opacity(isAppearing ? 1 : 0)
        .animation(
            .spring(response: 0.55, dampingFraction: 0.75).delay(0.6 + Double(index) * 0.06),
            value: isAppearing
        )
        .animation(
            .spring(response: 0.35, dampingFraction: 0.65),
            value: isHovered
        )
        .animation(
            .spring(response: 0.25, dampingFraction: 0.6),
            value: isPressed
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    onHover(true)
                    onPress(true)
                }
                .onEnded { _ in
                    onPress(false)
                    onHover(false)
                }
        )
    }
    
    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 28)
    }
}

// MARK: - Light Volumetric Detail View
struct LightVolumetricDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var unitPreference = LabUnitPreference.shared
    let data: LabValueDataModel
    var onDismiss: (() -> Void)? = nil
    
    @State private var isAppearing = false
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            // Bright translucent background
            Color.black.opacity(0.15)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss?()
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Main content card
                VStack(spacing: 24) {
                    // Drag handle
                    Capsule()
                        .fill(Color(red: 0.6, green: 0.65, blue: 0.75).opacity(0.4))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Header
                            volumetricHeader
                            
                            // Description
                            volumetricDescription
                            
                            // Lab values list
                            volumetricLabValuesList
                        }
                        .padding(24)
                    }
                }
                .background(
                    ZStack {
                        // Bright volumetric glass background
                        RoundedRectangle(cornerRadius: 32)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.98, green: 0.98, blue: 1.0).opacity(0.95),
                                        Color(red: 0.95, green: 0.96, blue: 0.99).opacity(0.98)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.85, green: 0.88, blue: 0.95),
                                                Color(red: 0.75, green: 0.80, blue: 0.90)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.15), radius: 40, y: -10)
                    }
                )
                .frame(maxHeight: UIScreen.main.bounds.height * 0.85)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                isAppearing = true
            }
        }
    }
    
    // MARK: - Volumetric Header
    private var volumetricHeader: some View {
        VStack(spacing: 16) {
            // Icon with depth
            ZStack {
                Image(data.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 84, height: 84)
                    .blur(radius: 12)
                    .opacity(0.2)
                    .offset(y: 6)
                
                Image(data.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.3), radius: 20, y: 6)
            }
            .rotation3DEffect(
                .degrees(isAppearing ? 0 : -10),
                axis: (x: 1, y: 0, z: 0)
            )
            
            // Title
            Text(data.title)
                .font(.custom("Poppins-Medium", size: 28))
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.2))
                .shadow(color: Color.white.opacity(0.8), radius: 6, y: 2)
            
            // Subtitle
            Text(data.subTitle)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4).opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .opacity(isAppearing ? 1 : 0)
        .scaleEffect(isAppearing ? 1 : 0.9)
        .offset(y: isAppearing ? 0 : 20)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.8).delay(0.1),
            value: isAppearing
        )
    }
    
    // MARK: - Volumetric Description
    private var volumetricDescription: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.custom("Poppins-Medium", size: 18))
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.2))
            
            Text(data.labValueDetail.description)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4).opacity(0.8))
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 0.85, green: 0.88, blue: 0.95), lineWidth: 1)
                )
        )
        .opacity(isAppearing ? 1 : 0)
        .scaleEffect(isAppearing ? 1 : 0.95)
        .offset(y: isAppearing ? 0 : 25)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.8).delay(0.2),
            value: isAppearing
        )
    }
    
    // MARK: - Volumetric Lab Values List
    private var volumetricLabValuesList: some View {
        VStack(spacing: 16) {
            ForEach(Array(data.labValueDetail.btnData.enumerated()), id: \.offset) { index, btn in
                LightVolumetricLabValueRow(
                    title: btn.title,
                    subtitle: btn.subTitle,
                    isAppearing: isAppearing,
                    index: index
                )
            }
        }
    }
}

// MARK: - Light Volumetric Lab Value Row
struct LightVolumetricLabValueRow: View {
    let title: String
    let subtitle: String
    let isAppearing: Bool
    let index: Int
    
    @State private var isPressed = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.custom("Poppins-Medium", size: 15))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.2))
                
                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.5).opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.6).opacity(0.5))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.85, green: 0.88, blue: 0.95),
                                    Color(red: 0.75, green: 0.80, blue: 0.90)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .opacity(isAppearing ? 1 : 0)
        .scaleEffect(isAppearing ? 1 : 0.92)
        .offset(y: isAppearing ? 0 : 30)
        .animation(
            .spring(response: 0.5, dampingFraction: 0.78).delay(0.3 + Double(index) * 0.05),
            value: isAppearing
        )
        .animation(
            .spring(response: 0.3, dampingFraction: 0.7),
            value: isPressed
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Preview
struct FutureVisionPrototype2035Light_Previews: PreviewProvider {
    static var previews: some View {
        FutureVisionPrototype2035Light()
    }
}
