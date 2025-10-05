//
//  Buttons.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/29/25.
//

import SwiftUI

protocol FCMenuButton {
    var title: String { get }
    func publishNotification() -> Void
}

struct FCRefreshButton: View, FCMenuButton {
    internal let title: String = "Refresh"
    
    var body: some View {
        Button(action: publishNotification) {
            Label(title, systemImage: "arrow.clockwise")
        }
        .help("\(title) (Cmd-R)")
        .keyboardShortcut("r", modifiers: .command)
    }

    internal func publishNotification() {
        fcStore.dispatch(FCAction.movieListRefreshed())
    }
}

struct FCQuitButton: View {
    internal let title = "Quit"

    var body: some View {
        Button(action: quit) {
            Text("\(title) \(APP_NAME)")
        }
        .help("\(title) (Cmd-Q)")
        .keyboardShortcut("q", modifiers: .command)
    }

    private func quit() {
        NSApplication.shared.terminate(nil)
    }
}

struct FCSearchButton: View, FCMenuButton {
    internal let title = "Search"
    
    var body: some View {
        Button(action: publishNotification) {
            Label(title, systemImage: "magnifyingglass")
        }
        .help("\(title) (Cmd-F)")
        .keyboardShortcut("f", modifiers: .command)
    }

    internal func publishNotification() {
        fcStore.dispatch(FCAction.searchStarted)
    }
}

struct FCNextTabButton: View, FCMenuButton {
    internal let title: String = "Show Next Tab"
    
    var body: some View {
        Button(action: publishNotification) {
            Label(title, systemImage: "chevron.right")
        }
        .help("\(title) (Cmd-Shift-])")
        .keyboardShortcut("]", modifiers: [.command, .shift])
    }
    
    internal func publishNotification() {
        fcStore.dispatch(FCAction.nextTabSelected)
    }
}
