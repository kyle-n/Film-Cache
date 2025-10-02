//
//  FCSearchField.swift
//  Film Cache
//
//  Created by Kyle Nazario on 10/1/25.
//

import AppKit
import SwiftUI
import ReSwift

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
                searchField.becomeFirstResponder()
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
            self.searchField.becomeFirstResponder()
        } else {
            self.searchField.resignFirstResponder()
        }
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        fcStore.dispatch(FCAction.queryChanged(searchField.stringValue))
    }
}
