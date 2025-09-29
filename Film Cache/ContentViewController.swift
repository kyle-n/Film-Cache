//
//  ContentViewController.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import SwiftUI
import Combine

final class ContentViewController: ObservableObject {
    @Published private(set) var movies: [FCMovie] = []
    @Published private(set) var loading = false
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        DispatchQueue.main.async {
            self.loadMovies()
            self.listenForRefreshNotifications()
        }
    }
    
    private func listenForRefreshNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadMovies), name: .fcRefreshed, object: nil)
    }

    @objc
    func loadMovies() {
        loading = true
        movies = []
        Task {
            do {
                let providenceMovies = try await MegaplexConnector
                    .getScheduledMovies(forTheaterId: FCTheater.MegaplexProvidence.rawValue).map { $0.toFCMovie() }
                let universityMovies = try await MegaplexConnector
                    .getScheduledMovies(forTheaterId: FCTheater.MegaplexUniversity.rawValue).map { $0.toFCMovie() }
                let megaplexMovies = providenceMovies.merged(with: universityMovies)
                DispatchQueue.main.async {
                    self.movies = megaplexMovies
                    self.loading = false
                }
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
