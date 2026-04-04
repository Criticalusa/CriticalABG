//
//  RoundTabBarView.swift
//  CriticalX
//
//  Created by Jadie Barringer on 15/10/22.
//  Updated with minimal light style
//

import SwiftUI

struct RoundTabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedIndex: Int
    var tabSelected: (_ index: Int) -> Void = { _ in }

    init(selectedIndex: Binding<Int> = .constant(0), tabSelected: @escaping (_ index: Int) -> Void = { _ in }) {
        self._selectedIndex = selectedIndex
        self.tabSelected = tabSelected
    }

    /// Tabs on the left of the center logo (no Home — logo = Home)
    private static let leftTabs: [Tab] = [.meds, .peds]
    /// Tabs on the right of the center logo
    private static let rightTabs: [Tab] = [.drips, .fav]

    var body: some View {
        HStack(spacing: 0) {
            // Left: Meds, Peds
            ForEach(Self.leftTabs) { tab in
                TabButton(
                    tab: tab,
                    isSelected: selectedIndex == tab.rawValue,
                    colorScheme: colorScheme,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedIndex = tab.rawValue
                            tabSelected(tab.rawValue)
                        }
                    }
                )
            }

            // Center: oversized logo circle (tap = Home)
            CenterLogoButton(
                colorScheme: colorScheme,
                isHomeSelected: selectedIndex == 0,
                action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = 0
                        tabSelected(0)
                    }
                }
            )

            // Right: Drips, Favorites
            ForEach(Self.rightTabs) { tab in
                TabButton(
                    tab: tab,
                    isSelected: selectedIndex == tab.rawValue,
                    colorScheme: colorScheme,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedIndex = tab.rawValue
                            tabSelected(tab.rawValue)
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            Group {
                if colorScheme == .dark {
                    // Dark mode: CardBlue with gold stroke
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 34, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [CriticalDesign.Colors.gold.opacity(0.5), CriticalDesign.Colors.gold.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                } else {
                    // Light mode: white gradient with subtle border
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color(red: 248/255, green: 249/255, blue: 252/255)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 34, style: .continuous)
                                .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
                        )
                }
            }
        )
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.5 : 0.14), radius: 24, x: 0, y: 12)
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.25 : 0.06), radius: 8, x: 0, y: 4)
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.08 : 0.03), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Center Logo Button (oversized circle, tap = Home)
private struct CenterLogoButton: View {
    let colorScheme: ColorScheme
    let isHomeSelected: Bool
    let action: () -> Void

    @State private var pulseScale: CGFloat = 1
    @State private var hasPerformedWelcomePulse = false

    private var ringColor: Color {
        CriticalDesign.Adaptive.brandAccent(for: colorScheme)
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.cardBlue
                            : Color.white
                    )
                    .frame(width: 58, height: 58)
                    .overlay(
                        Circle()
                            .stroke(
                                ringColor.opacity(isHomeSelected ? (colorScheme == .dark ? 0.9 : 0.7) : (colorScheme == .dark ? 0.5 : 0.3)),
                                lineWidth: isHomeSelected ? 2.5 : 2
                            )
                    )
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0.35 : 0.12), radius: 8, x: 0, y: 4)

                Image("LogoMonogram")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            }
            .frame(width: 64, height: 64)
            .scaleEffect(pulseScale)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Home")
        .accessibilityAddTraits(isHomeSelected ? .isSelected : [])
        .onAppear {
            guard isHomeSelected, !hasPerformedWelcomePulse else { return }
            hasPerformedWelcomePulse = true
            // Short delay so home content is visible first, then pulse to say "this is Home"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.easeOut(duration: 0.35)) {
                    pulseScale = 1.18
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        pulseScale = 1
                    }
                }
            }
        }
    }
}

// MARK: - Tab Button
fileprivate struct TabButton: View {
    let tab: Tab
    let isSelected: Bool
    let colorScheme: ColorScheme
    let action: () -> Void

    // Accent blue for selected state (light mode)
    private let accentBlue = Color(red: 58/255, green: 110/255, blue: 220/255)
    private let inactiveGray = Color(red: 160/255, green: 168/255, blue: 180/255)

    // Dark mode colors
    private var selectedColor: Color {
        colorScheme == .dark ? CriticalDesign.Colors.gold : accentBlue
    }
    private var unselectedColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.6) : inactiveGray
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 22 : 20, weight: isSelected ? .medium : .light))
                    .foregroundColor(isSelected ? selectedColor : unselectedColor)

                Text(tab.title)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? selectedColor : unselectedColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct RoundTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(red: 228/255, green: 233/255, blue: 240/255)
                .ignoresSafeArea()

            VStack {
                Spacer()
                RoundTabBarView(selectedIndex: .constant(0), tabSelected: { _ in })
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }
        }
    }
}

// MARK: - Tab Definition
enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case home, meds, peds, drips, fav

    internal var id: Int { rawValue }

    // SF Symbol icons - thin/light style
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .meds:
            return "cross.vial"
        case .peds:
            return "figure.child"
        case .drips:
            return "drop"
        case .fav:
            return "book.fill"
        }
    }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .meds:
            return "Meds"
        case .peds:
            return "Peds"
        case .drips:
            return "Drips"
        case .fav:
            return "Learn"
        }
    }
}
