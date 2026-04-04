//
//  LabValueCellCircularPrototype.swift
//  CriticalX
//
//  Circular glass card prototype with open text below
//

import SwiftUI

// MARK: - Circular Card Prototype
struct LabValueCellCircularPrototype: View {
    @Environment(\.colorScheme) var colorScheme
    var item: Int?

    private var labData: LabValueDataModel {
        LabValueDataModel.labValueData[item ?? 0]
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Circular volumetric glass card with icon
            ZStack {
                if colorScheme == .light {
                    // Volumetric glass circle
                    Circle()
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
                            Circle()
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
                        .shadow(color: Color.black.opacity(0.04), radius: 10, y: 5)
                        .frame(width: 110, height: 110)
                } else {
                    // Dark mode circle
                    Circle()
                        .fill(Color.black)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
                        )
                        .frame(width: 110, height: 110)
                }
                
                // Icon with depth
                ZStack {
                    if colorScheme == .light {
                        CatalogThumbnailImage(name: labData.image, size: 68, cornerRadius: 0, clipCircular: true)
                            .blur(radius: 8)
                            .opacity(0.2)
                            .offset(y: 4)
                    }
                    
                    CatalogThumbnailImage(name: labData.image, size: 64, cornerRadius: 0, clipCircular: true)
                        .shadow(color: CriticalDesign.Colors.cardBlue.opacity(colorScheme == .dark ? 0.3 : 0.2), radius: 12, y: 4)
                }
            }
            
            // Open text content below (no background)
            VStack(spacing: 6) {
                // Title
                Text(labData.title)
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.2))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.8), radius: 4, y: 1)
                
                // Subtitle
                Text(labData.subTitle)
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.5) : Color(red: 0.3, green: 0.3, blue: 0.4).opacity(0.7))
                    .lineLimit(1)
                
                // Test count badge
                HStack(spacing: 4) {
                    Text("\(labData.labValueDetail.btnData.count)")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Colors.cardBlue)
                    
                    Text("tests")
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.4) : Color(red: 0.4, green: 0.4, blue: 0.5).opacity(0.6))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color(red: 0.9, green: 0.92, blue: 0.96))
                )
            }
            .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }
}

// MARK: - Full Page Demo View
struct LabValueCircularPrototypeDemo: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    
    let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18)
    ]
    
    var body: some View {
        ZStack {
            // Bright atmospheric background
            if colorScheme == .dark {
                Color.black.ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.97, blue: 1.0),
                        Color(red: 0.92, green: 0.94, blue: 0.98)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 16) {
                        Image("icon-lab")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .opacity(colorScheme == .dark ? 0.95 : 0.9)
                        
                        Text("Circular Glass Cards")
                            .font(.custom("Poppins-Light", size: 34))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Text("Icon on glass, text openly displayed")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.5))
                            .kerning(0.5)
                    }
                    .padding(.top, 60)
                    
                    // Grid with circular cards
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(Array(LabValueDataModel.labValueData.enumerated()), id: \.offset) { index, _ in
                            LabValueCellCircularPrototype(item: index)
                                .opacity(isAppearing ? 1 : 0)
                                .scaleEffect(isAppearing ? 1 : 0.92)
                                .offset(y: isAppearing ? 0 : 40)
                                .animation(
                                    .spring(response: 0.55, dampingFraction: 0.78).delay(0.25 + Double(index) * 0.05),
                                    value: isAppearing
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                isAppearing = true
            }
        }
    }
}

// MARK: - Preview
struct LabValueCellCircularPrototype_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Single card preview
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.97, blue: 1.0),
                        Color(red: 0.92, green: 0.94, blue: 0.98)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                LabValueCellCircularPrototype(item: 0)
                    .padding()
            }
            .previewDisplayName("Single Card - Light")
            
            // Full demo
            LabValueCircularPrototypeDemo()
                .previewDisplayName("Full Demo - Light")
            
            // Dark mode demo
            LabValueCircularPrototypeDemo()
                .preferredColorScheme(.dark)
                .previewDisplayName("Full Demo - Dark")
        }
    }
}
