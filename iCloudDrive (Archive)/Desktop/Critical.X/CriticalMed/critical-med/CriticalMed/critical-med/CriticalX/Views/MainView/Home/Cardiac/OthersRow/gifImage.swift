//
//  gifImage.swift
//  CriticalX
//
//  Created by Macbook 4 on 26/11/2021.
//

#if canImport(UIKit)
import SwiftUI
import WebKit

/// Content mode for GIF scaling
enum GifContentMode {
    case fill  // Fills container, may crop edges (object-fit: cover)
    case fit   // Shows entire GIF, may have letterboxing (object-fit: contain)
}

struct GifImage: UIViewRepresentable {

    private let name: String
    private let contentMode: GifContentMode

    init(_ name: String, contentMode: GifContentMode = .fit) {
        self.name = name
        self.contentMode = contentMode
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false

        guard let url = Bundle.main.url(forResource: name, withExtension: "gif"),
              let data = try? Data(contentsOf: url) else {
            return webView
        }

        let base64String = data.base64EncodedString()
        let objectFit = contentMode == .fill ? "cover" : "contain"

        // HTML that scales the GIF based on content mode
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; }
                html, body {
                    width: 100%;
                    height: 100%;
                    overflow: hidden;
                    background: transparent;
                }
                img {
                    width: 100%;
                    height: 100%;
                    object-fit: \(objectFit);
                    display: block;
                }
            </style>
        </head>
        <body>
            <img src="data:image/gif;base64,\(base64String)" />
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Don't reload on every update - causes flickering
    }

}

struct GifImage_Previews: PreviewProvider {
    static var previews: some View {
        GifImage("pokeball", contentMode: .fill)
    }
}
#endif
