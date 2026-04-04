//
//  REBOA.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 2/5/24.
//  Revamped with CriticalDesign System + Teaching Style Guide
//

import SwiftUI

struct REBOA: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var showEnlargedImage = false
    @State private var expandedSection: String? = nil
    @State private var showAllPearls = false

    // Critical Pearls for stepper
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Time is critical:", content: "Zone 1 occlusion should be limited to 30-60 minutes. Prolonged occlusion causes distal ischemia and reperfusion injury."),
        CriticalPearlItem(header: "Know your zones:", content: "Zone 1 for thoracic/abdominal hemorrhage. Zone 3 for pelvic/junctional. NEVER inflate in Zone 2."),
        CriticalPearlItem(header: "Measure accurately:", content: "Sternal notch to umbilicus for Zone 1. Sternal notch to symphysis for Zone 3. Wrong placement = wrong results."),
        CriticalPearlItem(header: "Bridge to definitive care:", content: "REBOA buys time—it's not a fix. Get the patient to the OR or IR suite as fast as possible."),
        CriticalPearlItem(header: "The takeaway:", content: "REBOA is a lifesaving temporizing measure in hemorrhagic shock. Follow ME-FIIS, choose the right zone, and don't delay definitive care.")
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Colors.canvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Header
                    headerSection

                    // Clinical Context
                    clinicalContextCard

                    // Image Card
                    imageCard

                    // Zones Card
                    zonesCard

                    // ME-FIIS Steps
                    stepsCard

                    // Critical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)

                    Spacer(minLength: CriticalDesign.Spacing.xxl)
                }
                .padding(.horizontal, CriticalDesign.Spacing.lg)
                .padding(.vertical, CriticalDesign.Spacing.lg)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
        .fullScreenCover(isPresented: $showEnlargedImage) {
            REBOAEnlargedImageView()
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.accentRed.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)

                ZStack {
                    Circle()
                        .fill(colorScheme == .dark
                            ? CriticalDesign.Colors.cardBlue.opacity(0.85)
                            : Color.white.opacity(0.9))
                        .frame(width: 80, height: 80)

                    Circle()
                        .stroke(colorScheme == .dark
                            ? Color.white.opacity(0.12)
                            : Color.white.opacity(0.8), lineWidth: 1)
                        .frame(width: 80, height: 80)

                    Image(systemName: "arrow.up.and.down.circle.fill")
                        .font(.system(size: 36, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [CriticalDesign.Colors.accentRed, CriticalDesign.Colors.accentRed.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("REBOA")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Colors.cardBlue)

            Text("Resuscitative Endovascular Balloon Occlusion of the Aorta")
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, CriticalDesign.Spacing.lg)
        }
        .padding(.top, CriticalDesign.Spacing.md)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : -10)
    }

    // MARK: - Clinical Context Card
    private var clinicalContextCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                Text("Why This Matters")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            Text("REBOA is a **minimally invasive, lifesaving procedure** used to control hemorrhagic shock by temporarily occluding blood flow to the lower body. It stabilizes the patient and buys time for definitive surgical intervention.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)

            Text("Think of it as a **temporary tourniquet for the aorta** — it stops the bleeding you can't compress from the outside.")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .lineSpacing(5)
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.05), value: isAppearing)
    }

    // MARK: - Image Card
    private var imageCard: some View {
        VStack(spacing: CriticalDesign.Spacing.sm) {
            if UIImage(named: "reboa") != nil {
                Image("reboa")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 220)
                    .cornerRadius(16)
                    .clipped()
                    .onTapGesture {
                        showEnlargedImage = true
                    }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.accentRed.opacity(0.05))
                        .frame(height: 180)

                    VStack(spacing: 12) {
                        Image(systemName: "arrow.up.and.down.circle")
                            .font(.system(size: 40))
                            .foregroundColor(CriticalDesign.Colors.accentRed.opacity(0.4))
                        Text("REBOA Zones Diagram")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                    }
                }
            }

            HStack(spacing: 4) {
                Text("Aortic Zones Diagram")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 10))
                    .foregroundColor(CriticalDesign.Colors.accentRed.opacity(0.6))
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.1), value: isAppearing)
    }

    // MARK: - Zones Card
    private var zonesCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "map.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentBlue)

                Text("Zones of the Aorta")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            // Zone 1
            zoneRow(
                zone: "Zone 1",
                color: CriticalDesign.Colors.accentRed,
                description: "Left subclavian artery → Celiac artery",
                indication: "Massive thoracic or abdominal hemorrhage",
                details: "Measure from sternal notch. Balloon inflation ~8cc. Treat within 30-60 min."
            )

            // Zone 2 Warning
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(CriticalDesign.Colors.accentRed)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Zone 2")
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                    Text("Celiac artery → Lowest renal artery")
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    Text("NEVER INFLATE IN ZONE 2 — Critical branch vessels")
                        .font(.custom("Poppins-SemiBold", size: 13))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.accentRed.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .stroke(CriticalDesign.Colors.accentRed.opacity(0.2), lineWidth: 1)
            )

            // Zone 3
            zoneRow(
                zone: "Zone 3",
                color: CriticalDesign.Colors.accentBlue,
                description: "Lowest renal artery → Aortic bifurcation",
                indication: "Pelvic and lower extremity hemorrhage",
                details: "Longer occlusion time tolerated. Still move quickly to definitive care."
            )
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(neumorphicCardBackground)
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.15), value: isAppearing)
    }

    // MARK: - ME-FIIS Steps Card
    private var stepsCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "list.number")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CriticalDesign.Colors.accentTeal)

                Text("ME-FIIS Procedure Steps")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                stepRow("M", "Measure", "Accurately measure the distance to the occlusion zone", CriticalDesign.Colors.accentRed)
                stepRow("E", "Empty", "Ensure the balloon is empty of air to minimize embolism risk", CriticalDesign.Colors.accentPurple)
                stepRow("F", "Flush", "Flush the catheter and balloon with saline", CriticalDesign.Colors.accentBlue)
                stepRow("I", "Insert", "Gently insert the catheter to the designated zone", CriticalDesign.Colors.accentGreen)
                stepRow("I", "Inflate", "Inflate the balloon (~8cc) to occlude blood flow", CriticalDesign.Colors.accentOrange)
                stepRow("S", "Secure", "Secure the catheter in place to prevent displacement", CriticalDesign.Colors.cardBlue)
            }
        }
        .padding(CriticalDesign.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(CriticalDesign.Colors.accentTeal.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .stroke(CriticalDesign.Colors.accentTeal.opacity(0.2), lineWidth: 1)
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: isAppearing)
    }

    // MARK: - Helper Views
    private func zoneRow(zone: String, color: Color, description: String, indication: String, details: String) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.xs) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)

                Text(zone)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(color)
            }

            Text(description)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .padding(.leading, 18)

            Text("Indication: \(indication)")
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .padding(.leading, 18)

            Text(details)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .italic()
                .padding(.leading, 18)
        }
        .padding(.vertical, CriticalDesign.Spacing.xs)
    }

    private func stepRow(_ letter: String, _ title: String, _ description: String, _ color: Color) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.md) {
            Text(letter)
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text(description)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
        }
    }

    // MARK: - Neumorphic Card Background
    private var neumorphicCardBackground: some View {
        Group {
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(CriticalDesign.Colors.cardBlue)
                    .overlay(
                        RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(
                            LinearGradient(
                                colors: [Color.white, Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .fill(Color.clear)
                        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 6, y: 6)
                        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 10, y: 10)
                        .shadow(color: Color.white, radius: 12, x: -6, y: -6)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            }
        }
    }
}

// MARK: - Enlarged Image View
struct REBOAEnlargedImageView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(20)
                }

                Spacer()

                ScrollView([.vertical, .horizontal], showsIndicators: true) {
                    if UIImage(named: "reboa") != nil {
                        Image("reboa")
                            .resizable()
                            .scaledToFit()
                            .pinchToZoom()
                            .padding()
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "arrow.up.and.down.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.5))
                            Text("Image not available")
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }

                Text("REBOA Zones")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                Text("Pinch to zoom")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.bottom, 30)
            }
        }
    }
}

// MARK: - Pinch to Zoom Modifier
struct PinchToZoomModifier: ViewModifier {
    @GestureState private var zoomState: CGFloat = 1.0
    @State private var currentScale: CGFloat = 1.0

    func body(content: Content) -> some View {
        content
            .scaleEffect(zoomState * currentScale)
            .gesture(
                MagnificationGesture()
                    .updating($zoomState) { value, state, _ in
                        state = value
                    }
                    .onEnded { value in
                        currentScale *= value
                    }
            )
    }
}

extension View {
    func pinchToZoom() -> some View {
        modifier(PinchToZoomModifier())
    }
}

// MARK: - Preview
#Preview {
    REBOA()
}
