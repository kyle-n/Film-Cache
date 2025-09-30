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
            self.loadMovies()
//            self.listenForRefreshNotifications()
            DispatchQueue.main.async {
                fcStore.subscribe(self)
            }
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
    
    private func listenForRefreshNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadMovies), name: .fcRefreshed, object: nil)
    }

    @objc
    func loadMovies() {
        fcStore.dispatch(FCAction.moviesRequestStarted)
        Task {
            do {
                let providenceMovies = try await MegaplexConnector
                    .getScheduledMovies(forTheaterId: FCTheater.MegaplexProvidence.rawValue).map { $0.toFCMovie() }
                let universityMovies = try await MegaplexConnector
                    .getScheduledMovies(forTheaterId: FCTheater.MegaplexUniversity.rawValue).map { $0.toFCMovie() }
                let megaplexMovies = providenceMovies.merged(with: universityMovies)
                fcStore.dispatch(FCAction.moviesLoaded(megaplexMovies))
            } catch {
                print(error)
                FCError.display(error: error, type: .couldNotLoadFilms)
                DispatchQueue.main.async {
                    self.loading = false
                }
            }
        }
    }
}
