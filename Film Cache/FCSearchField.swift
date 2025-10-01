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
//            view.addConstraint(NSLayoutConstraint(
//                item: searchField,
//                attribute: .left,
//                relatedBy: .equal,
//                toItem: view,
//                attribute: .left,
//                multiplier: 1.0,
//                constant: 0
//            ))
//            view.addConstraint(NSLayoutConstraint(
//                item: searchField,
//                attribute: .top,
//                relatedBy: .equal,
//                toItem: view,
//                attribute: .top,
//                multiplier: 1.0,
//                constant: 0
//            ))
//            view.addConstraint(NSLayoutConstraint(
//                item: searchField,
//                attribute: .right,
//                relatedBy: .equal,
//                toItem: view,
//                attribute: .right,
//                multiplier: 1.0,
//                constant: 0
//            ))
//            view.addConstraint(NSLayoutConstraint(
//                item: searchField,
//                attribute: .bottom,
//                relatedBy: .equal,
//                toItem: view,
//                attribute: .bottom,
//                multiplier: 1.0,
//                constant: 0
//            ))
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
}
