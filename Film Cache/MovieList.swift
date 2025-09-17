//
//  MovieList.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/17/25.
//

import SwiftUI

struct MovieList: View {
    
    @StateObject private var controller: MovieListController
    
    init(movies: [MegaplexScheduledMovie]) {
        self._controller = StateObject(wrappedValue: MovieListController(movies: movies))
    }
    
    var body: some View {
        Table(controller.sortedMovies, sortOrder: $controller.sortOrder) {
            TableColumn("Title", value: \.title)
            TableColumn("Opening") { movie in
                MegaplexDate(date: movie.openingDate)
            }
            TableColumn("Runtime") { movie in
                Text(MovieList.getFormattedRunTime(forMinutes: movie.runTime))
            }
            TableColumn("Distributor", value: \.distributor)
            TableColumn("Theater", value: \.cinemaName)
        }
    }
    
    private static func getFormattedRunTime(forMinutes min: String) -> String {
        let minutes = Int(min)
        guard let minutes else { return "" }
        let hours = Int(floor(Double(minutes) / 60))
        let leftoverMinutes = minutes % 60
        return "\(hours)h \(leftoverMinutes)m"
    }
}

fileprivate final class MovieListController: ObservableObject {
    var sortedMovies: [MegaplexScheduledMovie] {
        movies.sorted(using: sortOrder)
    }
    @Published var sortOrder: [KeyPathComparator<MegaplexScheduledMovie>]
    
    private var movies: [MegaplexScheduledMovie]
    
    init(movies: [MegaplexScheduledMovie]) {
        self.movies = movies
        let sortOrder = [KeyPathComparator(\MegaplexScheduledMovie.title)]
        self.sortOrder = sortOrder
    }
    
    func updateMovies(newMovies: [MegaplexScheduledMovie]) {
        self.movies = newMovies
    }
}

#Preview {
    MovieList(movies: [mockMovieCaughtStealing])
        .frame(width: 700, height: 500)
        .navigationTitle(APP_NAME)
}
