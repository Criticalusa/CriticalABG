//
//  TabBarView.swift
//  CriticalX
//
//  Created by Macbook 4 on 12/11/2021.
//

import SwiftUI
import UIKit
import Network

struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var showingDetail = false
    @State var selectedIndex: Int = 0
    @State var showErrDig = false
    @State var activaCheckMyDrips = false
    let monitor = NWPathMonitor()
    let backgroundColor = Color.init(white: 1)
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $selectedIndex) {
                CriticalHomePage()
                    .tabItem {
                        Image("Home").renderingMode(.template)
                        Text("Home").font(.custom(AssetConstants.fontSFProDisplayMedium, size: 12))
                    }
                    .tag(0)
                
                MedsView()
                    .tabItem {
                        Image("Rx").renderingMode(.template)
                        Text("Meds").font(.custom(AssetConstants.fontSFProDisplayMedium, size: 12))
                    }
                    .tag(1)
                
                NavigationView {
                    PediatricsDashboardView()
                }
                .navigationViewStyle(.stack)
                    .tabItem {
                        Image("Baby").renderingMode(.template)
                        Text("Peds").font(.custom(AssetConstants.fontSFProDisplayMedium, size: 12))
                    }
                    .tag(2)
                
                DripsView(activaCheckMyDrips: $activaCheckMyDrips)
                    .tabItem {
                        Image("Drop").renderingMode(.template)
                        Text("Drips").font(.custom(AssetConstants.fontSFProDisplayMedium, size: 12))
                    }
                    .tag(3)
                
                FavoritesView()
                    .tabItem {
                        Image(systemName: "star").renderingMode(.template)
                        Text("Favorites").font(.custom(AssetConstants.fontSFProDisplayMedium, size: 12))
                    }
                    .tag(4)
            }
            .shadow(radius: 0)
            .tint(Color.logoBlue)
            .background(Color(.systemBackground))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                if #available(iOS 26.0, *) {
                    
                } else {
                    let image = UIImage.gradientImageWithBounds(
                        bounds: CGRect(x: 0, y: 0, width: UIScreen.main.scale, height: 5),
                        colors: [
                            UIColor.clear.cgColor,
                            UIColor.clear.withAlphaComponent(0.0).cgColor
                        ]
                    )
                    
                    // MARK: Hide TabBar but keep content visible
                    let appearance = UITabBarAppearance()
                    appearance.configureWithTransparentBackground()
                    appearance.backgroundColor = UIColor(Color.clear)
                    appearance.backgroundImage = UIImage()
                    appearance.shadowImage = image
                    
                    // Hide tab bar items but keep the bar functional
                    appearance.stackedLayoutAppearance.normal.iconColor = UIColor.clear
                    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
                    appearance.stackedLayoutAppearance.selected.iconColor = UIColor.clear
                    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
                    
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                    UITabBar.appearance().backgroundColor = UIColor(Color.clear)
                }
                
            }
//            .modify({ view in
//                if #available(iOS 26.0, *) {
//                    view.tabBarMinimizeBehavior(.onScrollDown)
//                    if selectedIndex == 3 {
//                        view.tabBarMinimizeBehavior(.onScrollDown)
//                        view.tabViewBottomAccessory {
//                            checkMyDripButton
//                        }
//                    }
//                } else {
//                    
//                }
//            })
            .fullScreenCover(isPresented: $showErrDig, content: {
                HoldOnPopupView(title: "Error", message: "Registration with MailChimp failed. Check your internet and try again.")
                    .background(BackgroundClearView())
            })

            // Offline banner — amber, non-dismissible (GOLDEN-MASTER-PLAN §11.2)
            VStack(spacing: 0) {
                OfflineStatusBanner()
                Spacer()
            }
            .allowsHitTesting(false)
            .ignoresSafeArea(edges: .bottom)

            if #available(iOS 26.0, *) {
                
            } else {
                // Custom tab bar overlay - positioned at bottom only
                VStack {
                    Spacer()
                    ZStack {
                        // Adaptive gradient - white for light mode, dark for dark mode
                        LinearGradient(
                            colors: colorScheme == .dark
                                ? [CriticalDesign.Colors.cardBlue.opacity(0.95), CriticalDesign.Colors.cardBlue.opacity(0.8), Color.clear]
                                : [Color.white, Color.white, Color.clear],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: 100)
                        .allowsHitTesting(false)
                        .padding(.bottom, -50)

                        // Custom tab bar - only this is interactive
                        RoundTabBarView(selectedIndex: $selectedIndex, tabSelected: { index in
                            selectedIndex = index
                        })
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    }
                    .frame(height: 150)
                    .background(Color.clear)
                }
                .background(Color.clear)
                .padding(.bottom, -40)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            
            // Global Floating AI Button - Disabled
            // FloatingAIButton(screenContext: currentTabContext)
        }
    }
    
    /// Get context string based on current selected tab
    private var currentTabContext: String {
        switch selectedIndex {
        case 0: return "Home"
        case 1: return "Medications"
        case 2: return "Pediatrics"
        case 3: return "Drips"
        case 4: return "Favorites"
        default: return ""
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
