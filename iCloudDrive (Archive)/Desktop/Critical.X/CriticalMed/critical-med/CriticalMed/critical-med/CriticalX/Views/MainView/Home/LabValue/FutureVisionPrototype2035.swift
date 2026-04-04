//
//  FutureVisionPrototype2035.swift
//  Critical Medical Guide
//
//  Created by Claude on 2/7/26.
//  iOS UI Vision: 2035-2040
//

import SwiftUI

// MARK: - Main Prototype View
struct FutureVisionPrototype2035: View {
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
            // Adaptive atmospheric background
            adaptiveAtmosphere
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
    
    // MARK: - Adaptive Atmosphere
    private var adaptiveAtmosphere: some View {
        ZStack {
            // Base layer responds to ambient light
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15)
                        .opacity(1.0 - ambientLight * 0.3),
                    Color(red: 0.02, green: 0.02, blue: 0.08)
                        .opacity(1.0 - ambientLight * 0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Biometric-responsive glow (pulse with heart rate)
            RadialGradient(
                colors: [
                    CriticalDesign.Colors.cardBlue
                        .opacity(0.15 * (heartRate / 100.0)),
                    Color.clear
                ],
                center: .center,
                startRadius: 100,
                endRadius: 500
            )
            .blur(radius: 100)
            .scaleEffect(anticipationScale)
            .animation(
                .easeInOut(duration: 60.0 / heartRate).repeatForever(autoreverses: true),
                value: anticipationScale
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
                    .opacity(0.3)
                    .offset(y: 12)
                
                // Mid layer
                Image("icon-lab")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 82, height: 82)
                    .blur(radius: 8)
                    .opacity(0.5)
                    .offset(y: 6)
                
                // Front layer (crisp)
                Image("icon-lab")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.4), radius: 20, y: 8)
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
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 8, y: 4)
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : -20)
                .animation(
                    .spring(response: 0.65, dampingFraction: 0.78).delay(0.2),
                    value: isAppearing
                )
            
            // Subtitle
            Text("Comprehensive Reference")
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(.white.opacity(0.6))
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
                                : .white.opacity(0.4)
                        )
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            ZStack {
                                if unitPreference.unitSystem == system {
                                    // Volumetric selected state
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    CriticalDesign.Colors.cardBlue,
                                                    CriticalDesign.Colors.cardBlue.opacity(0.8)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.5), radius: 12, y: 6)
                                    
                                    // Inner glow
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        .blur(radius: 2)
                                } else {
                                    // Unselected glass state
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
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
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 20, y: 10)
        )
    }
    
    // MARK: - Spatial Search Bar
    private var spatialSearchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
            
            TextField("", text: $searchText, prompt: Text("Search lab values...").foregroundColor(.white.opacity(0.3)))
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            ZStack {
                // Volumetric glass
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.08),
                                Color.white.opacity(0.03)
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
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 15, y: 8)
                
                // Inner shadow for depth
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.1))
                    .blur(radius: 4)
                    .offset(y: 2)
                    .mask(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 2)
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
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(Array(LabValueDataModel.labValueData.enumerated()), id: \.offset) { index, item in
                VolumetricLabCard(
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
                VolumetricDetailView(
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

// MARK: - Volumetric Lab Card
struct VolumetricLabCard: View {
    let item: LabValueDataModel
    let index: Int
    let isHovered: Bool
    let isPressed: Bool
    let isAppearing: Bool
    let onHover: (Bool) -> Void
    let onPress: (Bool) -> Void
    let onTap: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Shadow layers for depth
                cardShape
                    .fill(Color.black.opacity(0.4))
                    .blur(radius: 20)
                    .offset(y: isPressed ? 8 : 16)
                
                cardShape
                    .fill(Color.black.opacity(0.2))
                    .blur(radius: 10)
                    .offset(y: isPressed ? 4 : 8)
                
                // Main card with volumetric glass
                cardShape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.05)
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
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                
                // Content
                VStack(spacing: 16) {
                    Spacer()
                    
                    // Icon with depth
                    ZStack {
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 68, height: 68)
                            .blur(radius: 8)
                            .opacity(0.4)
                            .offset(y: 4)
                        
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64)
                            .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.3), radius: 12, y: 4)
                    }
                    .rotation3DEffect(
                        .degrees(isHovered ? 5 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    
                    Spacer()
                    
                    // Text content
                    VStack(spacing: 6) {
                        Text(item.title)
                            .font(.custom("Poppins-Medium", size: 16))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, y: 2)
                        
                        Text(item.subTitle)
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(.white.opacity(0.6))
                        
                        // Test count badge
                        HStack(spacing: 4) {
                            Text("\(item.labValueDetail.btnData.count)")
                                .font(.custom("Poppins-Medium", size: 12))
                                .foregroundColor(CriticalDesign.Colors.cardBlue)
                            
                            Text("tests")
                                .font(.custom("Poppins-Regular", size: 10))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.3))
                        )
                    }
                    .padding(.bottom, 8)
                }
                .padding(16)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 220)
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

// MARK: - Volumetric Detail View
struct VolumetricDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var unitPreference = LabUnitPreference.shared
    let data: LabValueDataModel
    var onDismiss: (() -> Void)? = nil
    
    @State private var isAppearing = false
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            // Volumetric background
            Color.black.opacity(0.3)
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
                        .fill(Color.white.opacity(0.3))
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
                        // Volumetric glass background
                        RoundedRectangle(cornerRadius: 32)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.08, green: 0.08, blue: 0.18).opacity(0.95),
                                        Color(red: 0.05, green: 0.05, blue: 0.12).opacity(0.98)
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
                                                Color.white.opacity(0.3),
                                                Color.white.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.5), radius: 40, y: -10)
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
                    .opacity(0.4)
                    .offset(y: 6)
                
                Image(data.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.5), radius: 20, y: 6)
            }
            .rotation3DEffect(
                .degrees(isAppearing ? 0 : -10),
                axis: (x: 1, y: 0, z: 0)
            )
            
            // Title
            Text(data.title)
                .font(.custom("Poppins-Medium", size: 28))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 6, y: 3)
            
            // Subtitle
            Text(data.subTitle)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.white.opacity(0.6))
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
                .foregroundColor(.white)
            
            Text(data.labValueDetail.description)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.white.opacity(0.7))
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
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
                VolumetricLabValueRow(
                    title: btn.title,
                    subtitle: btn.subTitle,
                    isAppearing: isAppearing,
                    index: index
                )
            }
        }
    }
}

// MARK: - Volumetric Lab Value Row
struct VolumetricLabValueRow: View {
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
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 8, y: 4)
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
struct FutureVisionPrototype2035_Previews: PreviewProvider {
    static var previews: some View {
        FutureVisionPrototype2035()
            .preferredColorScheme(.dark)
    }
}
