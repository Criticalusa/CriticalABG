//
//  BloodDropsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 12/11/2021.
//

import SwiftUI

struct DripsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var activaCheckMyDrips: Bool
    @State private var selectedCategory: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                
                // Check My Drip Button - navigates to new CheckMyDrip view
                Color.clear
                    .navigationDestination(isPresented: $activaCheckMyDrips) {
                        CheckMyDrip_New(data: clinicalCalculatorData.checkmyDripSegmentDetails)
                            .navigationBarBackground { Color.logoBlue.shadow(radius: 1) }
                    }
                
                // Background images
                Image("Back")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width)
                    .ignoresSafeArea()
//                Color.black.opacity(0.45)
//                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Top bar: back/profile on left, title center, actions on right (same plane as back)
                    HStack(spacing: 10) {
                        NavBarProfileView(showName: true, showTierBadge: true, size: 36, forceLightText: true)
                        
                        Spacer()
                        
                        Text("Drips")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            activaCheckMyDrips = true
                        }) {
                            glassBarItem(iconName: "drop.fill", width: 42)
                        }
                        
                        NavigationLink(destination: IVCompatibilityView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}) {
                            glassBarItem(iconName: "checkmark.shield.fill", width: 42)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    
                    VStack(spacing: 0) {
                        DripsTableView(selectedCategory: $selectedCategory)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(CriticalDesign.Adaptive.canvas(for: colorScheme))
                            .shadow(color: .black.opacity(0.18), radius: 30, x: 0, y: 18)
                    )
                    .cornerRadius(28)
                    .padding(.bottom, -10)
                    .ignoresSafeArea(.all)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
