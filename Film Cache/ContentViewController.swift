//
//  ContentViewController.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import SwiftUI
import Combine
import ReSwift

final class ContentViewController: ObservableObject, StoreSubscriber {
    @Published private(set) var movies: [FCMovie] = []
    @Published private(set) var loading = false
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        DispatchQueue.main.async {
            fcStore.subscribe(self)
            fcStore.dispatch(FCAction.Thunks.appOpened())
        }
    }
    
    deinit {
        fcStore.unsubscribe(self)
    }
    
    func newState(state: FCAppState) {
        DispatchQueue.main.async {
            self.movies = state.movies
            self.loading = state.loadingMovies
        }
    }
}
