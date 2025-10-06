//
//  Buttons.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/29/25.
//

import SwiftUI

public protocol FCMenuButton {
    var title: String { get }
    func publishNotification() -> Void
}

struct FCRefreshButton: View, FCMenuButton {
    internal let title = "Refresh"
    private let showHelpText: Bool
    
    init(showHelpText: Bool = false) {
        self.showHelpText = showHelpText
    }
    
    var body: some View {
        if showHelpText {
            button
                .help("\(title) (Cmd-R)")
        } else {
            button
        }
    }
    
    private var button: some View {
        Button(action: publishNotification) {
            Label(title, systemImage: "arrow.clockwise")
        }
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
        .keyboardShortcut("q", modifiers: .command)
    }

    private func quit() {
        NSApplication.shared.terminate(nil)
    }
}

struct FCSearchButton: View, FCMenuButton {
    internal let title = "Search"
    private let showHelpText: Bool
    
    init(showHelpText: Bool = false) {
        self.showHelpText = showHelpText
    }
    
    var body: some View {
        if showHelpText {
            button
                .help("\(title) (Cmd-F)")
        } else {
            button
        }
    }
    
    private var button: some View {
        Button(action: publishNotification) {
            Label(title, systemImage: "magnifyingglass")
        }
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
        .keyboardShortcut("]", modifiers: [.command, .shift])
    }
    
    internal func publishNotification() {
        fcStore.dispatch(FCAction.nextTabSelected)
    }
}

struct FCPreviousTabButton: View, FCMenuButton {
    internal let title = "Show Previous Tab"
    
    var body: some View {
        Button(action: publishNotification) {
            Label(title, systemImage: "chevron.left")
        }
        .keyboardShortcut("[", modifiers: [.command, .shift])
    }
    
    internal func publishNotification() {
        fcStore.dispatch(FCAction.previousTabSelected)
    }
}
