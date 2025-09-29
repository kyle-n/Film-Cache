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
            Image(systemName: "arrow.clockwise")
        }
        .help("Refresh")
    }
    
    private func publishRefreshNotification() {
        NotificationCenter.default.post(name: .fcRefreshed, object: nil)
    }
}
