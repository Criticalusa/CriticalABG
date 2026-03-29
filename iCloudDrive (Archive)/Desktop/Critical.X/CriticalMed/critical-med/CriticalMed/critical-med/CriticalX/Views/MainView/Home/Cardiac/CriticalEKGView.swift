//
//  CriticalEKGView.swift
//  CriticalX
//
//  Created by Macbook 4 on 23/11/2021.
//  Updated: Neumorphic card design matching app-wide theme
//

import SwiftUI

struct CriticalEKGView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss

    @State private var isActivating = false
    @State private var menuSection = -1
    @State private var selectedRow = -1
    @State private var animateCards = false
    @State private var searchText = ""

    @State private var navSection: Int = 0
    @State private var navRow: Int = 0
    @State private var isShowingRhythmDetail = false

    private var filteredSections: [(sectionIndex: Int, section: CardiacHeader, filteredRows: [CardiacDataModel])] {
        if searchText.isEmpty {
            return CardiacHeader.allSectionsData.enumerated().map { (index, section) in
                (sectionIndex: index, section: section, filteredRows: section.row)
            }
        }

        return CardiacHeader.allSectionsData.enumerated().compactMap { (index, section) in
            let filtered = section.row.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.subTitle.localizedCaseInsensitiveContains(searchText)
            }
            return filtered.isEmpty ? nil : (sectionIndex: index, section: section, filteredRows: filtered)
        }
    }

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                modalHeader
                    .padding(.top, 20)
                    .padding(.bottom, CriticalDesign.Spacing.md)

                searchBar
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                    .padding(.bottom, CriticalDesign.Spacing.lg)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: CriticalDesign.Spacing.xl) {
                        ForEach(Array(filteredSections.enumerated()), id: \.element.sectionIndex) { arrayIndex, sectionData in
                            sectionView(
                                sectionIndex: sectionData.sectionIndex,
                                section: sectionData.section,
                                filteredRows: sectionData.filteredRows,
                                animationIndex: arrayIndex
                            )
                        }

                        clinicalTakeawayCard

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                    .padding(.bottom, 40)
                }
            }
        }
        .fullScreenCover(isPresented: $isActivating) {
            MiddleView(count: $menuSection, row: $selectedRow)
        }
        .fullScreenCover(isPresented: $isShowingRhythmDetail) {
            NavigationView {
                OthersRowsMiddleView(section: navSection, row: navRow)
            }
            .navigationViewStyle(.stack)
            .environment(
                \.cardiacListRowImage,
                CardiacHeader.listRowImage(section: navSection, row: navRow)
            )
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                animateCards = true
            }
            GlobalPatientContext.shared.showFloatingButton = false
        }
        .onDisappear {
            GlobalPatientContext.shared.showFloatingButton = true
        }
    }

    // MARK: - Modal Header
    private var modalHeader: some View {
        HStack {
            Spacer()

            VStack(spacing: 4) {
                Text("Cardiac & EKG")
                    .font(.custom("Poppins-Bold", size: 22))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text("ACLS, Rhythms & Interpretation")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }

            Spacer()

            CriticalFavoriteButton(title: "Cardiac & EKG", type: "Clinical")
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
        .opacity(animateCards ? 1 : 0)
        .animation(.easeOut(duration: 0.3), value: animateCards)
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))

            TextField("Search rhythms & topics...", text: $searchText)
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }
        }
        .padding(.horizontal, CriticalDesign.Spacing.md)
        .padding(.vertical, 14)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.10), radius: 8, x: 4, y: 4)
                        .shadow(color: Color.white.opacity(0.95), radius: 8, x: -4, y: -4)
                }
            }
        )
        .overlay(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md, style: .continuous)
                        .stroke(CriticalDesign.Colors.accentGold.opacity(0.3), lineWidth: 1)
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            }
        )
        .opacity(animateCards ? 1 : 0)
        .animation(.easeOut(duration: 0.3).delay(0.1), value: animateCards)
    }

    // MARK: - Section View
    private func sectionView(sectionIndex: Int, section: CardiacHeader, filteredRows: [CardiacDataModel], animationIndex: Int) -> some View {
        let iconColor = sectionColor(for: sectionIndex)

        return VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            // Section header
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 36, height: 36)

                    Image(systemName: sectionIcon(for: sectionIndex))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                Text(section.title)
                    .font(.custom("Poppins-Bold", size: 17))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Spacer()

                Text("\(filteredRows.count)")
                    .font(.custom("Poppins-Bold", size: 11))
                    .foregroundColor(colorScheme == .dark ? CriticalDesign.Colors.gold : iconColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(colorScheme == .dark
                                  ? CriticalDesign.Colors.gold.opacity(0.15)
                                  : iconColor.opacity(0.10))
                    )
            }
            .padding(.horizontal, 4)
            .opacity(animateCards ? 1 : 0)
            .animation(.easeOut(duration: 0.3).delay(Double(animationIndex) * 0.05 + 0.15), value: animateCards)

            VStack(spacing: CriticalDesign.Spacing.md) {
                ForEach(Array(filteredRows.enumerated()), id: \.element.title) { rowIndex, item in
                    let actualRowIndex = section.row.firstIndex(where: { $0.title == item.title }) ?? rowIndex

                    if section.isPicCell {
                        Button(action: {
                            menuSection = sectionIndex
                            selectedRow = actualRowIndex
                            isActivating = true
                        }) {
                            CardiacFeaturedCard(
                                item: item,
                                iconColor: iconColor
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 10)
                        .animation(.easeOut(duration: 0.35).delay(Double(animationIndex) * 0.04 + Double(rowIndex) * 0.04 + 0.2), value: animateCards)
                    } else {
                        Button {
                            navSection = sectionIndex
                            navRow = actualRowIndex
                            isShowingRhythmDetail = true
                        } label: {
                            CardiacListCard(
                                item: item,
                                iconColor: iconColor
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 10)
                        .animation(.easeOut(duration: 0.35).delay(Double(animationIndex) * 0.04 + Double(rowIndex) * 0.03 + 0.2), value: animateCards)
                    }
                }
            }
        }
    }

    // MARK: - Clinical Takeaway Card
    private var clinicalTakeawayCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image("LogoMonogram")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Clinical Takeaway")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(colorScheme == .dark ? .white : CriticalDesign.Colors.cardBlue)

                    Text("Master the patterns")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(CriticalDesign.Colors.gold)
                }

                Spacer()
            }
            .padding(.horizontal, CriticalDesign.Spacing.lg)
            .padding(.top, CriticalDesign.Spacing.lg)
            .padding(.bottom, 14)

            Text("Rapid identification of cardiac rhythms is critical in emergent situations. Master the patterns to act decisively when seconds matter.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                .lineSpacing(4)
                .padding(.horizontal, CriticalDesign.Spacing.lg)
                .padding(.bottom, CriticalDesign.Spacing.lg)
        }
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.xl, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.xl, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                }
            }
        )
        .overlay(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.xl, style: .continuous)
                        .stroke(CriticalDesign.Colors.accentGold.opacity(0.3), lineWidth: 1)
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.xl, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            }
        )
        .opacity(animateCards ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.5), value: animateCards)
    }

    // MARK: - Helpers
    private func sectionIcon(for index: Int) -> String {
        switch index {
        case 0: return "heart.circle.fill"
        case 1: return "bolt.heart.fill"
        case 2: return "waveform.path.ecg"
        case 3: return "heart.fill"
        case 4: return "bolt.fill"
        case 5: return "exclamationmark.triangle.fill"
        case 6: return "heart.slash.fill"
        default: return "heart.fill"
        }
    }

    private func sectionColor(for index: Int) -> Color {
        switch index {
        case 0: return CriticalDesign.Colors.accentBlue
        case 1: return CriticalDesign.Colors.gold
        case 2: return CriticalDesign.Colors.accentPurple
        case 3: return CriticalDesign.Colors.accentTeal
        case 4: return CriticalDesign.Colors.accentOrange
        case 5: return CriticalDesign.Colors.accentRed
        case 6: return CriticalDesign.Colors.accentGreen
        default: return CriticalDesign.Colors.accentBlue
        }
    }
}

// MARK: - Featured Card (VADs, Pacemakers, ACLS — isPicCell sections)
struct CardiacFeaturedCard: View {
    @Environment(\.colorScheme) var colorScheme
    let item: CardiacDataModel
    let iconColor: Color

    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            if !item.image.isEmpty, UIImage(named: item.image) != nil {
                CatalogThumbnailImage(name: item.image, size: 80, cornerRadius: 12)
            } else {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 50, height: 50)

                    Image(systemName: "heart.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(colorScheme == .dark ? .white : CriticalDesign.Colors.cardBlue)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(item.subTitle)
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                }
            }
        )
        .overlay(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .stroke(CriticalDesign.Colors.accentGold, lineWidth: 1)
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            }
        )
    }
}

// MARK: - Rhythm List Card (non-isPicCell sections)
struct CardiacListCard: View {
    @Environment(\.colorScheme) var colorScheme
    let item: CardiacDataModel
    let iconColor: Color

    var body: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            if !item.image.isEmpty, UIImage(named: item.image) != nil {
                CatalogThumbnailImage(name: item.image, size: 80, cornerRadius: 12)
            } else {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 50, height: 50)

                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(colorScheme == .dark ? .white : CriticalDesign.Colors.cardBlue)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(item.subTitle)
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
                }
            }
        )
        .overlay(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .stroke(CriticalDesign.Colors.accentGold, lineWidth: 1)
                } else {
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            }
        )
    }
}

struct CriticalEKGView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CriticalEKGView()
        }
    }
}
