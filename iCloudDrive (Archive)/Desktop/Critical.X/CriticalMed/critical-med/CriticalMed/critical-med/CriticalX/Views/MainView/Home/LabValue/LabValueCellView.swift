//
//  LabValueCellView.swift
//  CriticalX
//
//  Created by Macbook 7 on 22/12/2021.
//

import SwiftUI

// MARK: - Lab Value Cell View (Jony Ive 2030)
struct LabValueCellView: View {
    @Environment(\.colorScheme) var colorScheme
    var item: Int?

    private var labData: LabValueDataModel {
        LabValueDataModel.labValueData[item ?? 0]
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Squircle volumetric glass card with icon
            ZStack {
                if colorScheme == .light {
                    // Volumetric glass squircle
                    Squircle()
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
                            Squircle()
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
                    // Dark mode squircle — gold standard
                    Squircle()
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            Squircle()
                                .stroke(
                                    LinearGradient(
                                        colors: [CriticalDesign.Colors.gold.opacity(0.5), CriticalDesign.Colors.gold.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: CriticalDesign.Colors.darkCanvas.opacity(0.3), radius: 10, y: 4)
                        .frame(width: 110, height: 110)
                }
                
                // Icon with depth
                ZStack {
                    if colorScheme == .light {
                        CatalogThumbnailImage(name: labData.image, size: 68, cornerRadius: 14)
                            .blur(radius: 8)
                            .opacity(0.2)
                            .offset(y: 4)
                    }
                    
                    CatalogThumbnailImage(name: labData.image, size: 64, cornerRadius: 14)
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

struct LabValueCellView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CriticalDesign.Colors.canvas.ignoresSafeArea()
            LabValueCellView(item: 0)
                .padding()
        }
    }
}
