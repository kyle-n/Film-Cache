//
//  Film_CacheApp.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import NZSSystemExtensions
import SwiftUI

@main
struct Film_CacheApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: initializeApp)
        }
        .commandsRemoved()
        .commands {
            CommandGroup(replacing: .appInfo) {
                AboutAppButton(APP_NAME)
                FCQuitButton()
            }
            CommandGroup(before: .appVisibility) {
                FCRefreshButton()
                FCSearchButton()
            }
            CommandGroup(after: .toolbar) {
                FCNextTabButton()
            }
        }
    }

    private func initializeApp() {
        NSWindow.allowsAutomaticWindowTabbing = false
    }
}
