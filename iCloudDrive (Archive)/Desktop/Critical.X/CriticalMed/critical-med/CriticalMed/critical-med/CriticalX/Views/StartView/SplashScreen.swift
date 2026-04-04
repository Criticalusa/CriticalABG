//
//  Splashscreen.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 12/15/21.
//

import SwiftUI
import FirebaseAuth
import UIKit

struct SplashScreen: View {

    @State var isActiveSplash: Bool = false
    @AppStorage("hasCompletedAppOnboarding") private var hasCompletedAppOnboarding = false

    // Animation states for "Critical Med" text
    @State private var showText: Bool = false
    @State private var textOpacity: Double = 0
    @State private var textOffset: CGFloat = 20
    @State private var shimmerOffset: CGFloat = -1

    // Gold brand colors
    private let goldLight = Color(red: 245/255, green: 230/255, blue: 163/255)   // #F5E6A3
    private let goldMid = Color(red: 222/255, green: 189/255, blue: 104/255)     // #DEBD68
    private let goldDeep = Color(red: 184/255, green: 146/255, blue: 61/255)     // #B8923D

    var body: some View {
        ZStack {
            if self.isActiveSplash {
                // First launch: show app onboarding once; then main app
                if hasCompletedAppOnboarding {
                    AppTabContainer()
                } else {
                    AppOnboardingView(hasCompletedOnboarding: $hasCompletedAppOnboarding)
                }
            } else {
                // Display the splash screen with animated text overlay
                GeometryReader { geometry in
                    ZStack {
                        // Dark navy background matching dark mode theme
                        Color(red: 15/255, green: 18/255, blue: 25/255)
                            .ignoresSafeArea(.all)

                        // Full-bleed splash image (logo centered in the PNG)
                        if let image = UIImage(named: "SplashScreen_img") {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                .clipped()
                        } else {
                            // Fallback if image not found
                            Image("Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }

                        // Animated copyright text overlaid below center
                        Text("The Barringer Group  \u{00A9} 2026")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .tracking(1.5)
                            .foregroundColor(Color(white: 0.75))
                            .opacity(textOpacity)
                            .offset(y: geometry.size.height * 0.14 + textOffset)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .ignoresSafeArea(.all)
                .onAppear {
                    // Delay text appearance slightly so logo registers first
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        // Fade in + slide up
                        withAnimation(.easeOut(duration: 0.7)) {
                            textOpacity = 1
                            textOffset = 0
                        }
                    }

                    // Start gold shimmer sweep after text appears
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        withAnimation(.easeInOut(duration: 1.2)) {
                            shimmerOffset = 1
                        }
                    }

                    // Transition to main app after animations complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.isActiveSplash = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
