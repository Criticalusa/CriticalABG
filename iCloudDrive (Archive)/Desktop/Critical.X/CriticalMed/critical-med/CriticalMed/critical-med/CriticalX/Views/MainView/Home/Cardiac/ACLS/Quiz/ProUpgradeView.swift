//
//  ProUpgradeView.swift
//  CriticalX
//
//  Pro upgrade prompt - redirects to PaywallView for ACLS subscription
//
//  Created: January 2026
//

import SwiftUI

struct ProUpgradeView: View {
    let feature: String

    var body: some View {
        PaywallView()
    }
}

#Preview {
    ProUpgradeView(feature: "ACLS Quiz")
}
