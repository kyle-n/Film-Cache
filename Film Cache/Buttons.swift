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
        fcStore.dispatch(FCAction.movieListRefreshed())
    }
}

struct FCQuitButton: View {
    var body: some View {
        Button(action: quit) {
            Text("Quit \(APP_NAME)")
        }
        .help("Quit (Cmd-Q)")
        .keyboardShortcut("q", modifiers: .command)
    }

    private func quit() {
        NSApplication.shared.terminate(nil)
    }
}

struct FCSearchButton: View {
    var body: some View {
        Button(action: publishSearchNotification) {
            Label("Search", systemImage: "magnifyingglass")
        }
        .help("Search (Cmd-F)")
        .keyboardShortcut("f", modifiers: .command)
    }

    private func publishSearchNotification() {
        fcStore.dispatch(FCAction.searchStarted)
    }
}

struct FCNextTabButton: View {
    var body: some View {
        Button(action: publishNotification) {
            Label("Show Next Tab", systemImage: "chevron.right")
        }
        .help("Show Next Tab (Cmd-Shift-])")
        .keyboardShortcut("]", modifiers: [.command, .shift])
    }
    
    private func publishNotification() {
        fcStore.dispatch(FCAction.nextTabSelected)
    }
}
