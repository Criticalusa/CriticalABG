//
//  7PsBtnView.swift
//  CriticalX
//
//  Redesigned with CriticalDesign System
//

import SwiftUI

struct SevenPsbtnView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showingSheet = false
    @State private var selectedCard: Int? = nil
    
    var body: some View {
        ZStack {
            CriticalDesign.Colors.canvas
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header Section
                    VStack(spacing: CriticalDesign.Spacing.sm) {
                        Text("Rapid Sequence Intubation")
                            .font(.custom("Poppins-Bold", size: 28))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .multilineTextAlignment(.center)
                        
                        Text("The 7 P's")
                            .font(.custom("Poppins-SemiBold", size: 22))
                            .foregroundColor(CriticalDesign.Colors.accentBlue)
                    }
                    .padding(.vertical, CriticalDesign.Spacing.xl)
                    .padding(.horizontal)
                    .padding(.top, CriticalDesign.Spacing.md)
                    
                    // Process Cards
                    VStack(spacing: CriticalDesign.Spacing.md) {
                        ForEach(0..<RSIIDataModel.rsiiData.count, id: \.self) { index in
                            NavigationLink(
                                destination: SevenPsBtnDetailView(data: RSIIBtnDetailDataModel.rsiiBtnDetailData[index])
                                    .navigationBarBackground { Color.logoBlue.shadow(radius: 1) }
                            ) {
                                ProcessCard(
                                    title: RSIIDataModel.rsiiData[index].title,
                                    isSelected: selectedCard == index,
                                    index: index + 1
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        selectedCard = index
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, CriticalDesign.Spacing.md)
                }
                .padding(.bottom, CriticalDesign.Spacing.xl)
            }
        }
    }
}

// MARK: - Process Card
struct ProcessCard: View {
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let isSelected: Bool
    let index: Int
    
    private var stepColor: Color {
        switch index {
        case 1: return CriticalDesign.Colors.accentBlue
        case 2: return CriticalDesign.Colors.accentTeal
        case 3: return CriticalDesign.Colors.accentGreen
        case 4: return CriticalDesign.Colors.accentOrange
        case 5: return CriticalDesign.Colors.accentPurple
        case 6: return CriticalDesign.Colors.accentRed
        case 7: return Color(hex: "#E91E63") // Pink accent
        default: return CriticalDesign.Colors.accentBlue
        }
    }
    
    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            // Step Number Badge
            ZStack {
                Circle()
                    .fill(stepColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Text("\(index)")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(stepColor)
            }
            
            // Icon
            Image(systemName: getSystemImage(for: title))
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(stepColor)
                .frame(width: 32)
            
            // Title
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(.horizontal, CriticalDesign.Spacing.md)
        .padding(.vertical, CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(
                    LinearGradient(
                        colors: [Color.white, CriticalDesign.Colors.canvas],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(
                    color: isSelected ? stepColor.opacity(0.2) : Color.black.opacity(0.08),
                    radius: isSelected ? 8 : 12,
                    x: isSelected ? 2 : 5,
                    y: isSelected ? 2 : 5
                )
                .shadow(
                    color: Color.white.opacity(0.9),
                    radius: isSelected ? 8 : 12,
                    x: isSelected ? -2 : -5,
                    y: isSelected ? -2 : -5
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(
                    LinearGradient(
                        colors: [
                            stepColor.opacity(isSelected ? 0.5 : 0.2),
                            stepColor.opacity(isSelected ? 0.3 : 0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .scaleEffect(isSelected ? 0.98 : 1.0)
    }
    
    private func getSystemImage(for title: String) -> String {
        switch title {
        case "Preparation": return "checklist"
        case "Pre-oxygenation": return "lungs.fill"
        case "Pre-treatment": return "pills.fill"
        case "Paralysis with Induction": return "syringe.fill"
        case "Protection & Positioning": return "bed.double.fill"
        case "Placement": return "waveform.path"
        case "Post-intubation Management": return "heart.text.square.fill"
        default: return "questionmark.circle.fill"
        }
    }
}

// MARK: - Preview
struct SevenPsbtnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SevenPsbtnView()
        }
    }
}
