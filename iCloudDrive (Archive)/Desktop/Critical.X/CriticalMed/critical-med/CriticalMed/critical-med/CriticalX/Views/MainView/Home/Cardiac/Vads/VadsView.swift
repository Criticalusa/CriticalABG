//
//  VadsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 23/11/2021.
//  Updated: Adaptive dark/light mode using CriticalDesign system
//

import SwiftUI

// MARK: - VAD Adaptive Background
struct VADAdaptiveBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false

    private var navyOrb: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.gold.opacity(0.06)
            : Color(red: 0.11, green: 0.21, blue: 0.34).opacity(0.04)
    }

    private var goldOrb: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.cardBlue.opacity(0.3)
            : Color(red: 0.79, green: 0.64, blue: 0.15).opacity(0.03)
    }

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)

            GeometryReader { geo in
                Circle()
                    .fill(navyOrb)
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                        y: animate ? geo.size.height * 0.3 : geo.size.height * 0.6
                    )

                Circle()
                    .fill(goldOrb)
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                    .offset(
                        x: animate ? geo.size.width * 0.1 : geo.size.width * 0.5,
                        y: animate ? geo.size.height * 0.7 : geo.size.height * 0.2
                    )

                Circle()
                    .fill(navyOrb)
                    .frame(width: 150, height: 150)
                    .blur(radius: 60)
                    .offset(
                        x: animate ? geo.size.width * 0.7 : geo.size.width * 0.3,
                        y: animate ? geo.size.height * 0.5 : geo.size.height * 0.8
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - VAD Adaptive Card
struct VADAdaptiveCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(CriticalDesign.Colors.cardBlue)
                            .overlay(
                                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                                    .stroke(CriticalDesign.Colors.gold.opacity(0.3), lineWidth: 1)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .fill(LinearGradient(
                                colors: [Color.white, Color(UIColor.systemGray6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                            .shadow(color: Color.white, radius: 10, x: -5, y: -5)
                            .overlay(
                                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                    }
                }
            )
    }
}

// MARK: - VAD Adaptive Info Card
struct VADAdaptiveInfoCard: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let content: String
    var accentColor: Color = .white

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(width: 4, height: 20)

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text(content)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                                .stroke(accentColor.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .fill(LinearGradient(
                            colors: [Color.white, Color(UIColor.systemGray6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 4, y: 4)
                        .shadow(color: Color.white.opacity(0.9), radius: 8, x: -4, y: -4)
                        .overlay(
                            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                                .stroke(accentColor.opacity(0.2), lineWidth: 1)
                        )
                }
            }
        )
    }
}

// MARK: - VAD Adaptive Warning Card
struct VADAdaptiveWarningCard: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(CriticalDesign.Colors.gold)

                Text(title)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Colors.gold)
            }

            Text(content)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(CriticalDesign.Colors.gold.opacity(colorScheme == .dark ? 0.12 : 0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(CriticalDesign.Colors.gold.opacity(0.4), lineWidth: 1)
        )
    }
}

// MARK: - VADs Main View
struct VadsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented = false
    @State private var isPresented1 = false
    @State var indcx: Int
    @State var otherModel: VadsOtherDataModel
    @State var url: String

    var body: some View {
        ZStack {
            VADAdaptiveBackground()

            ScrollView {
                VStack(spacing: 24) {

                    // MARK: Title Section
                    VStack(spacing: 16) {
                        Image("icon-vad")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.2) : Color.black.opacity(0.1), radius: 10)

                        Text("VADS 101")
                            .font(.custom("Poppins-Bold", size: 36))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                        Text("Ventricular Assist Devices")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)

                    // MARK: - Basic Overview Card
                    Button(action: { isPresented = true }) {
                        VADAdaptiveCard {
                            VStack(spacing: 8) {
                                Text("Basic Overview")
                                    .font(.custom("Poppins-SemiBold", size: 20))
                                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                                Text("Mechanical Overview")
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            }
                        }
                    }
                    .sheet(isPresented: $isPresented) {
                        BasicOverView()
                    }

                    // MARK: - VADs Cards
                    ForEach(0..<VadsDataModel.vadsData.count, id: \.self) { item in
                        Button(action: {
                            indcx = item
                            otherModel = VadsOtherDataModel.TAHData[item]
                            url = getURL(for: item)
                            isPresented1 = true
                        }) {
                            VADAdaptiveCard {
                                VStack(spacing: 8) {
                                    Text(VadsDataModel.vadsData[item].title)
                                        .font(.custom("Poppins-SemiBold", size: 20))
                                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                                    Text(VadsDataModel.vadsData[item].subTitle)
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $isPresented1) {
                        VadsOtherView(category: $indcx, model: $otherModel, url: $url)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }

    func getURL(for index: Int) -> String {
        switch index {
        case 0: return "https://www.mylvad.com/ems/field_guides/syncardia-tah-ems-field-guide"
        case 1: return "https://www.mylvad.com/sites/default/files/EMS%20Guide%20HeartMate%20II%20new%20cover.pdf"
        case 2: return "https://www.mylvad.com/sites/default/files/EMS%20Guidelines%20HeartWare%20HVAD%20updated%20cover.pdf"
        case 3: return "https://d1edr79mp9g5zc.cloudfront.net/5eb0affe-1991-449b-bfc0-a5a0516548bf/f4fc23f9-06ae-4e85-9be8-f9e6c72f3f0a/f4fc23f9-06ae-4e85-9be8-f9e6c72f3f0a_viewable_rendition__v.pdf"
        default: return ""
        }
    }
}

struct VadsView_Previews: PreviewProvider {
    static var previews: some View {
        VadsView(indcx: 0, otherModel: VadsOtherDataModel(title: "", overViewDescription: "", whatToKnowDescription: "", image: ""), url: "")
    }
}
