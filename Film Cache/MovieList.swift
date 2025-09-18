//
//  MovieList.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/17/25.
//

import SwiftUI

struct MovieList: View {
    
    @StateObject private var controller: MovieListController
    
    init(movies: [FCMovie]) {
        self._controller = StateObject(wrappedValue: MovieListController(movies: movies))
    }
    
    var body: some View {
        Table(controller.sortedMovies, sortOrder: $controller.sortOrder) {
            TableColumn("Title", value: \.title)
            TableColumn("Opening", value: \.openingDate) { movie in
                FCFormattedDate(movie.openingDate)
            }
            TableColumn("Runtime", value: \.runTimeMinutes) { movie in
                FCFormattedRunTime(movie.runTimeMinutes)
            }
            TableColumn("Distributor", value: \.distributor)
            TableColumn("Theater", value: \.theaterName)
        }
    }
}

fileprivate final class MovieListController: ObservableObject {
    var sortedMovies: [FCMovie] {
        return movies.sorted(using: sortOrder)
    }
    @Published var sortOrder: [KeyPathComparator<FCMovie>]
    
    private var movies: [FCMovie]
    
    init(movies: [FCMovie]) {
        self.movies = movies
        let sortOrder = [KeyPathComparator(\FCMovie.openingDate)]
        self.sortOrder = sortOrder
    }
    
    func updateMovies(newMovies: [FCMovie]) {
        self.movies = newMovies
    }
}

#Preview {
    MovieList(movies: [mockMovieCaughtStealing.toFCMovie()])
        .frame(width: 700, height: 500)
        .navigationTitle(APP_NAME)
}
