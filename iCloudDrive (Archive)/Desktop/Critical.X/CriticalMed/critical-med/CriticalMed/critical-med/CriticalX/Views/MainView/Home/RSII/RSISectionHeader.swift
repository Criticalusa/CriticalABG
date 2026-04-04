//
//  RSISectionHeader.swift
//  CriticalX
//
//  Redesigned with CriticalDesign System
//

import SwiftUI

struct RSISectionHeader: View {
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let icon: String
    
    private var iconTint: Color {
        switch title {
        case "Induction Agents":
            return CriticalDesign.Colors.accentGreen
        case "Paralytics":
            return CriticalDesign.Colors.accentRed
        case "Pre-Treatment":
            return CriticalDesign.Colors.accentBlue
        default:
            return CriticalDesign.Colors.accentBlue
        }
    }
    
    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            // Icon with glow effect
            ZStack {
                Circle()
                    .fill(iconTint.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconTint)
            }
            
            Text(title)
                .font(.custom("Poppins-Bold", size: 22))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Spacer()
            
            // Subtle indicator
            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(.horizontal, CriticalDesign.Spacing.md)
        .padding(.vertical, CriticalDesign.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .shadow(
                    color: colorScheme == .dark ? Color.black.opacity(0.25) : Color.black.opacity(0.08),
                    radius: 8, x: 4, y: 4
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .stroke(
                    colorScheme == .dark
                        ? LinearGradient(colors: [CriticalDesign.Colors.goldMid.opacity(0.4), iconTint.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [Color.white.opacity(0.8), iconTint.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Preview
struct RSISectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            RSISectionHeader(title: "Pre-Treatment", icon: "pills.fill")
            RSISectionHeader(title: "Induction Agents", icon: "syringe.fill")
            RSISectionHeader(title: "Paralytics", icon: "bolt.fill")
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
