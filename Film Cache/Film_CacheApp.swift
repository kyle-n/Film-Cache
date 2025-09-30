//
//  Film_CacheApp.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

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
                FCQuitButton()
            }
            CommandGroup(before: .appVisibility) {
                    FCRefreshButton()
            }
        }
    }
    
    private func initializeApp() {
        NSWindow.allowsAutomaticWindowTabbing = false
    }
}
