//
//  CardiacDetailWaveformContent.swift
//  CriticalX
//
//  Uses the same image asset as CardiacDataModel list rows when available,
//  so overview and detail stay visually consistent.
//

import SwiftUI
import UIKit
import SSSwiftUIGIFView

private struct CardiacListRowImageKey: EnvironmentKey {
    static let defaultValue: String = ""
}

extension EnvironmentValues {
    /// Image name from `CardiacDataModel.image` for the row the user selected (set by `CriticalEKGView` / `MiddleView`).
    var cardiacListRowImage: String {
        get { self[CardiacListRowImageKey.self] }
        set { self[CardiacListRowImageKey.self] = newValue }
    }
}

extension CardiacHeader {
    /// Resolved list-row image name for the given section/row indices in `allSectionsData`.
    static func listRowImage(section: Int, row: Int) -> String {
        guard section >= 0, section < allSectionsData.count else { return "" }
        let rows = allSectionsData[section].row
        guard row >= 0, row < rows.count else { return "" }
        return rows[row].image
    }
}

/// Hero waveform area: prefers the animated GIF strip; falls back to the NanoBanana list asset.
struct CardiacDetailWaveformContent: View {
    @Environment(\.cardiacListRowImage) private var listRowImage

    let fallbackGifName: String
    let textSecondary: Color

    /// True when the GIF file exists in the app bundle.
    private var hasGif: Bool {
        !fallbackGifName.isEmpty && Bundle.main.url(forResource: fallbackGifName, withExtension: "gif") != nil
    }

    private var hasListAsset: Bool {
        !listRowImage.isEmpty && UIImage(named: listRowImage) != nil
    }

    var body: some View {
        VStack(spacing: 12) {
            Group {
                if hasGif {
                    SwiftUIGIFPlayerView(gifName: fallbackGifName)
                        .frame(height: 120)
                        .cornerRadius(16)
                        .clipped()
                } else if hasListAsset {
                    Image(listRowImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }

            Text(hasGif ? "EKG Waveform Animation" : "Rhythm Illustration")
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(textSecondary)
        }
    }
}
