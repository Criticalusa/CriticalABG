//
//  ACLSQuizResultsSheet.swift
//  CriticalX
//
//  Post-quiz results sheet with "Challenge a Colleague" share prompt.
//

import SwiftUI

struct ACLSQuizResultsSheet: View {
    let score: Int
    let total: Int
    let topic: String
    let accentColor: Color
    let correctColor: Color
    let onChallenge: () -> Void
    let onDone: () -> Void

    @Environment(\.colorScheme) var colorScheme

    private var percentage: Int {
        total > 0 ? (score * 100) / total : 0
    }

    private var headlineEmoji: String {
        if percentage >= 90 { return "🏆" }
        if percentage >= 80 { return "🔥" }
        if percentage >= 70 { return "💪" }
        return "📚"
    }

    private var headlineText: String {
        if percentage >= 90 { return "Outstanding!" }
        if percentage >= 80 { return "Great Job!" }
        if percentage >= 70 { return "Solid Work" }
        return "Keep Studying"
    }

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            VStack(spacing: 28) {
                Capsule()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)

                // Score ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.15), lineWidth: 10)
                        .frame(width: 110, height: 110)
                    Circle()
                        .trim(from: 0, to: CGFloat(percentage) / 100)
                        .stroke(
                            percentage >= 70 ? correctColor : accentColor,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .frame(width: 110, height: 110)
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 2) {
                        Text("\(percentage)%")
                            .font(.custom("Poppins-Bold", size: 28))
                            .foregroundColor(colorScheme == .dark ? .white : CriticalDesign.Colors.cardBlue)
                        Text("\(score)/\(total)")
                            .font(.custom("Poppins-Medium", size: 13))
                            .foregroundColor(.gray)
                    }
                }

                Text("\(headlineEmoji) \(headlineText)")
                    .font(.custom("Poppins-Bold", size: 22))
                    .foregroundColor(colorScheme == .dark ? .white : CriticalDesign.Colors.cardBlue)

                Text(topic)
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(.gray)

                // Challenge button
                Button(action: onChallenge) {
                    HStack(spacing: 10) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                        Text("Challenge a Colleague")
                            .font(.custom("Poppins-SemiBold", size: 16))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [accentColor, accentColor.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: CriticalDesign.Radius.md))
                }
                .padding(.horizontal, 24)

                Button(action: onDone) {
                    Text("Done")
                        .font(.custom("Poppins-Medium", size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 16)
            }
        }
    }
}
