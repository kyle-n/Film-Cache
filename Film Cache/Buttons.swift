//
//  Buttons.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/29/25.
//

import SwiftUI

struct FCRefreshButton: View {
    var body: some View {
        Button(action: publishRefreshNotification) {
            Label("Refresh", systemImage: "arrow.clockwise")
        }
        .help("Refresh (Cmd-R)")
        .keyboardShortcut("r", modifiers: .command)
    }
    
    private func publishRefreshNotification() {
        NotificationCenter.default.post(name: .fcRefreshed, object: nil)
    }
}
