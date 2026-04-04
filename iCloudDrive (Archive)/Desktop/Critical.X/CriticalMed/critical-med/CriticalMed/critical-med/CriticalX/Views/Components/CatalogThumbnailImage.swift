//
//  CatalogThumbnailImage.swift
//  CriticalX
//
//  NanoBanana (and similar) catalog art is usually **landscape** (~1408×768). List/grid cells use **square**
//  frames with `.scaledToFit()`, which letterboxes: only ~55% of the cell height is used, so the icon reads
//  "tiny" next to **square** hand-authored assets that fill the frame. This view uses **fill + clip** so the
//  subject occupies the full cell (edges may crop — acceptable for thumbnails).
//

import SwiftUI

struct CatalogThumbnailImage: View {
    let name: String
    var size: CGFloat
    var cornerRadius: CGFloat = 10
    /// When true, clips to a circle (e.g. icon centered on a circular squircle background).
    var clipCircular: Bool = false

    var body: some View {
        Group {
            if clipCircular {
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            }
        }
    }
}
