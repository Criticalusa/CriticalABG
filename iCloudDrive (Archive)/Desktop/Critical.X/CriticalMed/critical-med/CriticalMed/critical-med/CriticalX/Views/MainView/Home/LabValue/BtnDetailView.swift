//
//  BtnDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 23/12/2021.
//

import SwiftUI

struct BtnDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    var item: Int?
    let data: BtnDataModel
    @State private var isAppearing = false
   
    var body: some View {
        ZStack {
            // Neumorphic background
            CriticalDesign.Colors.canvas
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header Card
                    headerCard
                    
                    // Overview Section
                    sectionCard(
                        title: "\(data.subTitle) Overview",
                        content: data.btnDetail.overview,
                        icon: "doc.text.fill",
                        accentColor: CriticalDesign.Colors.cardBlue,
                        delay: 0.2
                    )
                    
                    // Indication Section
                    sectionCard(
                        title: "Why evaluate the \(data.subTitle)",
                        content: data.btnDetail.indication,
                        icon: "questionmark.circle.fill",
                        accentColor: CriticalDesign.Colors.accentGreen,
                        delay: 0.25
                    )
                    
                    // Increased Values Section
                    sectionCard(
                        title: "Increased Values",
                        content: data.btnDetail.increaseValue,
                        icon: "arrow.up.circle.fill",
                        accentColor: CriticalDesign.Colors.accentBlue,
                        delay: 0.3
                    )
                    
                    // Decreased Values Section
                    sectionCard(
                        title: "Decreased Values",
                        content: data.btnDetail.decreaseValue,
                        icon: "arrow.down.circle.fill",
                        accentColor: .red,
                        delay: 0.35
                    )
                    
                    // Factors Affecting Section
                    sectionCard(
                        title: "Factors Affecting the Study",
                        content: data.btnDetail.factorAffecting,
                        icon: "exclamationmark.triangle.fill",
                        accentColor: CriticalDesign.Colors.accentPurple,
                        delay: 0.4
                    )
                    
                    // Critical Value Alert
                    if !data.btnDetail.criticalValue.isEmpty {
                        criticalValueCard
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                LiquidGlassBackButton()
            }
        }
    }

    // MARK: - Header Card (Two-Tone Style)
    private var headerCard: some View {
        let gold = Color(red: 0.96, green: 0.71, blue: 0.0)

        return VStack(spacing: 0) {
            // Top section - Navy with title and icon
            HStack(spacing: 16) {
                // Frosted icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 64, height: 64)

                    Image("Tubes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(data.title)
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(.white)

                    Text(data.subTitle)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(gold)
                }

                Spacer()
            }
            .padding(20)
            .background(CriticalDesign.Colors.cardBlue)

            // Bottom section - Stats bar
            HStack(spacing: 0) {
                // Normal Range
                VStack(spacing: 4) {
                    Text(data.range)
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                        .lineLimit(1)

                    Text("Normal Range")
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)

                // Divider
                Rectangle()
                    .fill(CriticalDesign.Colors.cardBlue.opacity(0.15))
                    .frame(width: 1, height: 40)

                // Unit
                VStack(spacing: 4) {
                    Text(data.potiency)
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(CriticalDesign.Colors.cardBlue)
                        .lineLimit(1)

                    Text("Unit")
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 16)
            .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [gold, gold.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.2), radius: 12, x: 0, y: 6)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - Section Card
    private func sectionCard(title: String, content: String, icon: String, accentColor: Color, delay: Double) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(accentColor)

                Text(title)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(accentColor)
            }
            
            // Content
            Text(content)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 4, y: 4)
                .shadow(color: Color.white, radius: 8, x: -4, y: -4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    colorScheme == .dark
                        ? Color(red: 0.96, green: 0.71, blue: 0.0) // Gold stroke in dark mode
                        : accentColor.opacity(0.2),
                    lineWidth: colorScheme == .dark ? 2 : 1
                )
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(delay), value: isAppearing)
    }

    // MARK: - Critical Value Card
    private var criticalValueCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [CriticalDesign.Colors.accentOrange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )

                Text("CRITICAL VALUE")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Colors.accentOrange)

                Spacer()
            }

            Text(data.btnDetail.criticalValue)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 4, y: 4)
                .shadow(color: Color.white, radius: 8, x: -4, y: -4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [CriticalDesign.Colors.accentOrange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(0.45), value: isAppearing)
    }
}

struct BtnDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BtnDetailView(data: BtnDataModel.btnImmunolofyData[0])
        }
    }
}
