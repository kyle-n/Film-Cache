//
//  ContentViewController.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import SwiftUI

final class ContentViewController: ObservableObject {
    @Published private(set) var movies: [FCMovie] = []
    @Published private(set) var loading = false
    
    init() {
        DispatchQueue.main.async {
            self.loadMovies()
        }
    }
    
    func loadMovies() {
        self.loading = true
        self.movies = []
        Task {
            let providenceMovies = try await MegaplexConnector.getScheduledMovies(forTheaterId: FCTheater.MegaplexProvidence.rawValue)
            let universityMovies = try await MegaplexConnector.getScheduledMovies(forTheaterId: FCTheater.MegaplexUniversity.rawValue)
            let megaplexMovies = (providenceMovies + universityMovies).map { $0.toFCMovie() }
            DispatchQueue.main.async {
                self.movies = megaplexMovies
                self.loading = false
            }
        }
    }
}
