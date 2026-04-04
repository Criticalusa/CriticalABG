//
//  cellDetaillView.swift
//  CriticalX
//
//  Created by Macbook 7 on 22/12/2021.
//

import SwiftUI

struct cellDetaillView: View {
    @Environment(\.colorScheme) var colorScheme
    let data: LabValueDataModel
    @State private var isAppearing = false
    
    var body: some View {
        ZStack {
            // Neumorphic background
            CriticalDesign.Colors.canvas
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header Card
                    headerCard
                    
                    // Description Card
                    descriptionCard
                    
                    // Lab Values List
                    labValuesList
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
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

    // MARK: - Header Card
    private var headerCard: some View {
        VStack(spacing: 0) {
            // Top section - Navy blue with icon and title
            HStack(spacing: 16) {
                // Icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 64, height: 64)

                    Image(data.image)
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
                        .foregroundColor(Color(red: 0.96, green: 0.71, blue: 0.0)) // Gold
                }

                Spacer()
            }
            .padding(20)
            .background(CriticalDesign.Colors.cardBlue)

            // Bottom section - Stats bar
            HStack(spacing: 0) {
                // Tests count
                VStack(spacing: 4) {
                    Text("\(data.labValueDetail.btnData.count)")
                        .font(.custom("Poppins-Bold", size: 22))
                        .foregroundColor(CriticalDesign.Colors.cardBlue)

                    Text("Tests")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)

                // Divider
                Rectangle()
                    .fill(CriticalDesign.Colors.cardBlue.opacity(0.15))
                    .frame(width: 1, height: 40)

                // Panel type
                VStack(spacing: 4) {
                    Text(data.title)
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                        .lineLimit(1)

                    Text("Panel")
                        .font(.custom("Poppins-Medium", size: 12))
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
                        colors: [
                            Color(red: 0.96, green: 0.71, blue: 0.0), // Gold
                            Color(red: 0.96, green: 0.71, blue: 0.0).opacity(0.3)
                        ],
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

    // MARK: - Description Card
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                
                Text("Overview")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
            }
            
            Text(data.labValueDetail.description)
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
                        : CriticalDesign.Colors.cardBlue.opacity(0.15),
                    lineWidth: colorScheme == .dark ? 2 : 1
                )
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Lab Values List
    private var labValuesList: some View {
        VStack(spacing: 16) {
            ForEach(Array(data.labValueDetail.btnData.enumerated()), id: \.offset) { index, btnData in
                NavigationLink(destination: BtnDetailView(item: index, data: btnData).navigationBarBackground { CriticalDesign.Colors.cardBlue }) {
                    LabValueRowCard(data: btnData)
                }
                .opacity(isAppearing ? 1 : 0)
                .offset(y: isAppearing ? 0 : 20)
                .animation(
                    .easeOut(duration: 0.4).delay(0.3 + Double(index) * 0.05),
                    value: isAppearing
                )
            }
        }
    }
}

// MARK: - Lab Value Row Card
struct LabValueRowCard: View {
    @Environment(\.colorScheme) var colorScheme
    let data: BtnDataModel

    var body: some View {
        HStack(spacing: 16) {
            // Left content
            VStack(alignment: .leading, spacing: 6) {
                Text(data.title)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                    .multilineTextAlignment(.leading)
                
                Text(data.subTitle)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Colors.accentOrange)
            }
            
            Spacer()
            
            // Right content - Range
            VStack(alignment: .trailing, spacing: 4) {
                Text(data.range)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Colors.accentGreen)
                                        
                Text(data.potiency)
                    .font(.custom("Poppins-Medium", size: 11))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 4, y: 4)
                .shadow(color: Color.white, radius: 8, x: -4, y: -4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    colorScheme == .dark
                        ? Color(red: 0.96, green: 0.71, blue: 0.0) // Gold stroke in dark mode
                        : Color.white.opacity(0.8),
                    lineWidth: colorScheme == .dark ? 2 : 1
                )
        )
    }
}

struct cellDetaillView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            cellDetaillView(data: LabValueDataModel.labValueData[0])
        }
    }
}
