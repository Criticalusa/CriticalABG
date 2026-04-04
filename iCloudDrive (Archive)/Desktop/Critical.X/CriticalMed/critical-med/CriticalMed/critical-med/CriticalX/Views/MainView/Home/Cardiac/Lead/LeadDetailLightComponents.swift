//
//  LeadDetailLightComponents.swift
//  CriticalX
//
//  Shared components for 12-Lead Mastery detail views
//  Premium light theme with brand-consistent colors
//

import SwiftUI
import UIKit

// MARK: - Brand Colors (from Design.md)
struct LeadColors {
    // Backgrounds
    static let canvas = Color(red: 0.96, green: 0.97, blue: 0.98)       // #F5F7FA
    static let recessed = Color(red: 0.93, green: 0.94, blue: 0.98)     // #EDF0FA
    static let surface = Color.white

    // Text Hierarchy (Navy)
    static let textPrimary = Color(red: 0.04, green: 0.09, blue: 0.16)  // #0A1628
    static let textSecondary = Color(red: 0.11, green: 0.33, blue: 0.34) // #1D3557
    static let textTertiary = Color(red: 0.24, green: 0.35, blue: 0.50) // #3D5A80
    static let textMuted = Color(red: 0.42, green: 0.49, blue: 0.54)    // #6B7C8A

    // Semantic (used sparingly - 3%)
    static let critical = Color(red: 0.75, green: 0.22, blue: 0.27)     // #C03744
    static let success = Color(red: 0.02, green: 0.60, blue: 0.41)      // #059869

    // Accent (2%)
    static let gold = Color(red: 0.79, green: 0.64, blue: 0.15)         // #C9A227

    // Card accents
    static let navyAccent = Color(red: 0.11, green: 0.33, blue: 0.34)   // #1D3557
}

// MARK: - Animated Light Background
struct LeadDetailBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false

    var body: some View {
        ZStack {
            // Adaptive base background
            if colorScheme == .dark {
                CriticalDesign.Colors.darkCanvas
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        LeadColors.canvas,
                        LeadColors.recessed,
                        LeadColors.canvas
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }

            // Subtle animated orbs
            GeometryReader { geo in
                Circle()
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.04) : LeadColors.navyAccent.opacity(0.04))
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                        y: animate ? geo.size.height * 0.2 : geo.size.height * 0.4
                    )

                Circle()
                    .fill(LeadColors.gold.opacity(0.03))
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

// MARK: - Detail Header (Title + Icon)
struct LeadDetailHeader: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let subtitle: String
    let icon: String
    var accentColor: Color = LeadColors.navyAccent

    var body: some View {
        VStack(spacing: 16) {
            // Glass icon container
            ZStack {
                // Soft glow
                Circle()
                    .fill(accentColor.opacity(0.12))
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

                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentColor, accentColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .padding(.top, 20)

            Text(title)
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text(subtitle)
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Glass Content Card
struct LeadDetailGlassCard: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let icon: String
    let content: AttributedString
    var accentColor: Color = LeadColors.navyAccent

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                // Vertical accent line
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(width: 4, height: 44)

                // Icon badge
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(accentColor)
                }

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)

            // Content
            Text(content)
                .lineSpacing(6)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.7))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldGradient : LinearGradient(colors: [Color.white.opacity(0.8)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.06), radius: 16, y: 8)
        .padding(.horizontal, 16)
    }
}

// MARK: - Image Card (Tappable)
struct LeadDetailImageCard: View {
    @Environment(\.colorScheme) var colorScheme
    let imageName: String
    let caption: String
    var onTap: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            if UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
                    .cornerRadius(16)
                    .onTapGesture {
                        onTap()
                    }
            } else {
                // Placeholder
                RoundedRectangle(cornerRadius: 16)
                    .fill(LeadColors.recessed)
                    .frame(height: 150)
                    .overlay(
                        Image(systemName: "waveform.path.ecg")
                            .font(.system(size: 40))
                            .foregroundColor(LeadColors.textMuted)
                    )
            }

            Text(caption)
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            Text("Tap to enlarge")
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.6))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldGradient : LinearGradient(colors: [Color.white.opacity(0.6)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
        )
        .shadow(color: colorScheme == .dark ? .clear : Color.black.opacity(0.06), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 16)
    }
}

// MARK: - Warning/Critical Card (Red Accent)
struct LeadDetailWarningCard: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let content: AttributedString

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [LeadColors.critical, LeadColors.critical.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: LeadColors.critical.opacity(0.3), radius: 4, y: 2)

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(LeadColors.critical)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)

            // Content
            Text(content)
                .lineSpacing(6)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(LeadColors.critical.opacity(0.05))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(LeadColors.critical.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 10)
        .shadow(color: LeadColors.critical.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

// MARK: - Clinical Takeaway Card (Signature Style)
struct LeadDetailTakeawayCard: View {
    let takeaway: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(LeadColors.gold)
                Text("Clinical Takeaway")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(.white)
            }

            Text(takeaway)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LeadColors.textPrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [LeadColors.gold, LeadColors.gold.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: LeadColors.gold.opacity(0.2), radius: 8, y: 4)
        .padding(.horizontal, 16)
    }
}

// MARK: - Close Button
struct LeadDetailCloseButton: View {
    @Environment(\.colorScheme) var colorScheme
    var action: () -> Void

    var body: some View {
        Button(action: action) {
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
}

// MARK: - Section Divider
struct LeadDetailSectionDivider: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String

    var body: some View {
        HStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [CriticalDesign.Adaptive.textTertiary(for: colorScheme).opacity(0.3), Color.clear],
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
                        colors: [Color.clear, CriticalDesign.Adaptive.textTertiary(for: colorScheme).opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

// MARK: - Content Formatter
struct LeadContentFormatter {
    static func format(_ text: String, headings: [String], baseFontSize: CGFloat = 14) -> AttributedString {
        var result = AttributedString(text)

        // Base style
        let baseFont = UIFont(name: "Poppins-Regular", size: baseFontSize) ?? UIFont.systemFont(ofSize: baseFontSize, weight: .regular)
        result.font = Font(baseFont)
        result.foregroundColor = LeadColors.textTertiary

        // Bold headings
        let boldFont = UIFont(name: "Poppins-Bold", size: baseFontSize) ?? UIFont.systemFont(ofSize: baseFontSize, weight: .bold)
        for heading in headings {
            if let range = result.range(of: heading) {
                result[range].font = Font(boldFont)
                result[range].foregroundColor = LeadColors.textPrimary
            }
        }

        return result
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LeadDetailBackground()

        ScrollView {
            VStack(spacing: 20) {
                LeadDetailHeader(
                    title: "Lead Overview",
                    subtitle: "Foundation Concepts",
                    icon: "waveform.path.ecg"
                )

                LeadDetailGlassCard(
                    title: "What is ECMO",
                    icon: "heart.circle.fill",
                    content: LeadContentFormatter.format(
                        "Key Point:\nThis is sample content for preview.",
                        headings: ["Key Point:"]
                    )
                )

                LeadDetailWarningCard(
                    title: "Critical Finding",
                    content: LeadContentFormatter.format(
                        "Warning:\nST elevation is a time-sensitive emergency.",
                        headings: ["Warning:"]
                    )
                )

                LeadDetailTakeawayCard(
                    takeaway: "When in doubt, get a 12-lead. The tracing will guide your next decision."
                )
            }
            .padding(.top, 60)
        }

        VStack {
            HStack {
                Spacer()
                LeadDetailCloseButton { }
                    .padding(.trailing, 20)
                    .padding(.top, 16)
            }
            Spacer()
        }
    }
    .preferredColorScheme(.light)
}
