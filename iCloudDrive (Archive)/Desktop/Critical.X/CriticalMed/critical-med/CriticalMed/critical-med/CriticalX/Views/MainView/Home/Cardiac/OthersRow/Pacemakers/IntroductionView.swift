//
//  IntroductionView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 2/8/24.
//  Updated: Premium Light Mode with Glass Cards
//

import SwiftUI

struct IntroductionView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var sections = pacemakerSections
    @State private var animate = false
    @State private var showAllPearls = false

    // Critical Pearls content
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Know the indications:", content: "Symptomatic bradycardia, complete heart block, sick sinus syndrome, and post-op AV block."),
        CriticalPearlItem(header: "Mode matters:", content: "DDD, VVI, AAI—each mode has specific applications. Understand the letter codes."),
        CriticalPearlItem(header: "Rate-responsive pacing:", content: "Modern pacemakers adjust heart rate based on activity level for physiologic response."),
        CriticalPearlItem(header: "Failure recognition:", content: "Know failure to pace vs failure to capture vs failure to sense—each requires different intervention."),
        CriticalPearlItem(header: "The takeaway:", content: "Pacemakers maintain cardiac output when the heart's electrical system fails. Master the basics.")
    ]

    // MARK: - Formatted Content
    private var overviewContent: AttributedString {
        ContentFormatter.format("""
        What is a Pacemaker:
        Pacemakers provide electrical stimulation to the heart to maintain an adequate heart rate and rhythm in patients with certain types of cardiac arrhythmias.

        Clinical Importance:
        There are various types of pacemakers, each suited for different clinical scenarios. Understanding when and how to use them is essential for critical care providers.
        """, headings: ["What is a Pacemaker:", "Clinical Importance:"])
    }

    private var indicationsContent: AttributedString {
        ContentFormatter.format("""
        Primary Indications:
        The decision to implant a permanent pacemaker is based on specific clinical indications, primarily related to the management of bradyarrhythmias or, in some cases, tachyarrhythmias.

        Symptomatic Bradycardia:
        Heart rate < 60 bpm with symptoms such as dizziness, syncope, or fatigue.

        Complete Heart Block:
        No AV conduction present. Requires pacing to maintain adequate cardiac output.

        Sick Sinus Syndrome:
        SA node dysfunction causing inappropriate sinus bradycardia or chronotropic incompetence.

        Post-operative AV Block:
        Following cardiac surgery when conduction system is damaged.

        Rate-Responsive Pacing:
        Modern pacemakers can adjust the heart rate in response to the body's activity level, providing rate-responsive pacing.
        """, headings: ["Primary Indications:", "Symptomatic Bradycardia:", "Complete Heart Block:", "Sick Sinus Syndrome:", "Post-operative AV Block:", "Rate-Responsive Pacing:"])
    }

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // MARK: - Header
                    HStack {
                        Spacer()
                        CriticalFavoriteButton(title: "Pacemaker Introduction", type: "Cardiac")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // MARK: - Title Section
                    VStack(spacing: 16) {
                        // Animated Pacemaker Icon
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 100, height: 100)

                            Circle()
                                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.5))
                                .frame(width: 100, height: 100)

                            Circle()
                                .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.8), lineWidth: 1)
                                .frame(width: 100, height: 100)

                            Image("icon-pacemaker")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .scaleEffect(animate ? 1.08 : 1.0)
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 4)

                        Text("Introduction to Pacemakers")
                            .font(.custom("Poppins-Bold", size: 28))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .multilineTextAlignment(.center)

                        Text("Electrical Cardiac Support")
                            .font(.custom("Poppins-Medium", size: 16))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }
                    .padding(.bottom, 12)

                    // MARK: - Overview Card
                    PremiumLightGlassCard(
                        title: "Overview",
                        icon: "heart.circle.fill",
                        content: overviewContent
                    )

                    // MARK: - Indications Card
                    PremiumLightGlassCard(
                        title: "Key Indications",
                        icon: "list.bullet.clipboard.fill",
                        content: indicationsContent
                    )

                    // MARK: - Expandable Details Section
                    expandableDetailsCard

                    // MARK: - Clinical Takeaway
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }

    // MARK: - Expandable Details Card
    private var expandableDetailsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.5, blue: 0.8),
                                Color(red: 0.3, green: 0.6, blue: 0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.blue.opacity(0.3), radius: 4, y: 2)

                Text("Clinical Details")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)

            // Expandable items
            VStack(spacing: 8) {
                ForEach($sections.indices, id: \.self) { index in
                    expandableItem(for: index)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.5))
                if colorScheme != .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.8),
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: colorScheme == .dark
                            ? [Color.white.opacity(0.15), Color.white.opacity(0.05)]
                            : [Color.white.opacity(0.9), Color.white.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        .shadow(color: Color.blue.opacity(0.08), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Expandable Item
    private func expandableItem(for index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeOut(duration: 0.3)) {
                    sections[index].isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(sections[index].title)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                    Spacer()

                    Image(systemName: sections[index].isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.08))
                )
            }
            .buttonStyle(PlainButtonStyle())

            if sections[index].isExpanded {
                Text(sections[index].details)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(4)
                    .padding(12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    IntroductionView()
}
