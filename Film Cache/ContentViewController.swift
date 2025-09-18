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
            self.loadMegaplexMovies()
        }
    }
    
    func loadMegaplexMovies() {
        self.loading = true
        Task {
            let moviesFromAPI = try await MegaplexConnector.getScheduledMovies(forTheaterId: "0010")
            DispatchQueue.main.async {
                self.movies = moviesFromAPI.map { $0.toFCMovie() }
                self.loading = false
            }
        }
    }
}
