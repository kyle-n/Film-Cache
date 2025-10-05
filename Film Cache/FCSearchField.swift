//
//  FCSearchField.swift
//  Film Cache
//
//  Created by Kyle Nazario on 10/1/25.
//

import AppKit
import ReSwift
import SwiftUI

struct FCSearchField: NSViewControllerRepresentable {
    typealias NSViewControllerType = FCSearchFieldController

    func makeCoordinator() -> FCSearchFieldController {
        let coordinator = FCSearchFieldController()
        coordinator.parentView = self
        return coordinator
    }

    func makeNSViewController(context: Context) -> FCSearchFieldController {
        context.coordinator
    }

    func updateNSViewController(_ nsViewController: FCSearchFieldController, context: Context) {}
}

final class FCSearchFieldController: NSViewController, NSSearchFieldDelegate, StoreSubscriber {
    var parentView: FCSearchField?
    var searchField = NSSearchField()
    var initialized = false
    private var recentSearches: [String] = []

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayout() {
        if !initialized {
            initialized = true
            view.translatesAutoresizingMaskIntoConstraints = false
            setupSearchField()

            if fcStore.state.listQuery != nil {
                // Gives slide in animation in ContentView time to finish
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.searchField.becomeFirstResponder()
                }
            }
        }
    }

    private func setupSearchField() {
        view.addSubview(searchField)
        searchField.frame = view.bounds
        searchField.delegate = self
        searchField.drawsBackground = false
        searchField.backgroundColor = .clear
        searchField.recentSearches = []
        searchField.maximumRecents = 5
        searchField.recentsAutosaveName = "search"
        searchField.setAccessibilityHelp("Search sites")
    }

    func newState(state: FCAppState) {
        if state.listQuery != nil {
            searchField.becomeFirstResponder()
        } else {
            searchField.resignFirstResponder()
        }
    }

    func controlTextDidEndEditing(_ obj: Notification) {
        let newQuery = searchField.stringValue

        // FCSearchField is in toolbar
        let searchFieldActive = searchField.window?.firstResponder == searchField.window

        if fcStore.state.listQuery != newQuery, searchFieldActive {
            fcStore.dispatch(FCAction.queryChanged(newQuery))
        }
        if newQuery.isEmpty, !searchFieldActive {
            fcStore.dispatch(FCAction.searchEnded)
        }
    }
}
