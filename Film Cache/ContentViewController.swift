//
//  ContentViewController.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import SwiftUI

final class ContentViewController: ObservableObject {
    @Published private(set) var megaplexMovies: [MegaplexScheduledMovie] = []
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
                print("qqq setting movies", moviesFromAPI)
                self.megaplexMovies = moviesFromAPI
                self.loading = false
            }
        }
    }
}
