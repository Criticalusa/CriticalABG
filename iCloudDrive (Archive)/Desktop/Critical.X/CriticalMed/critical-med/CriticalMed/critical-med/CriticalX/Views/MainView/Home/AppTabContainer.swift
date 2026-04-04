//
//  AppTabContainer.swift
//  CriticalX
//
//  Full-app tab container — switches between Home, Meds, Peds, Drips, Learn
//  with the custom RoundTabBarView overlay at the bottom.
//

import SwiftUI

struct AppTabContainer: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: Int = Tab.home.rawValue

    var body: some View {
        ZStack {
            // ── TAB CONTENT ──
            Group {
                switch selectedTab {
                case Tab.home.rawValue:
                    CriticalHomePage()
                case Tab.meds.rawValue:
                    NavigationView {
                        ClinicalPharmacologyView(isCardView: .constant(true))
                    }
                    .navigationViewStyle(.stack)
                case Tab.peds.rawValue:
                    NavigationView {
                        PediatricsDashboardView()
                    }
                    .navigationViewStyle(.stack)
                case Tab.drips.rawValue:
                    NavigationView {
                        DripsView(activaCheckMyDrips: .constant(false))
                    }
                    .navigationViewStyle(.stack)
                case Tab.fav.rawValue:
                    NavigationView {
                        LearnTabView()
                    }
                    .navigationViewStyle(.stack)
                default:
                    CriticalHomePage()
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 90)
            }

            // ── CUSTOM TAB BAR ──
            VStack {
                Spacer()

                RoundTabBarView(selectedIndex: $selectedTab) { index in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    AppTabContainer()
}
