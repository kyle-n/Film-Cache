//
//  FCMovieList.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/17/25.
//

import SwiftUI

struct FCMovieList: View {
    let movies: [FCMovie]
    @Binding var selectedMovieID: FCMovie.ID?

    @State private var sortOrder: [KeyPathComparator<FCMovie>] = [KeyPathComparator(\FCMovie.openingDate)]

    var body: some View {
        Table(sortedMovies, selection: $selectedMovieID, sortOrder: $sortOrder) {
            TableColumn("Title", value: \.title)
            TableColumn("Opening", value: \.openingDate) { movie in
                FCFormattedDate(movie.openingDate)
            }
            TableColumn("Runtime", value: \.runTimeMinutes) { movie in
                FCFormattedRunTime(movie.runTimeMinutes)
            }
            TableColumn("Distributor", value: \.distributor)
            TableColumn("Theater(s)", value: \.theaterName)
        }
    }

    private var sortedMovies: [FCMovie] {
        return movies.sorted(using: sortOrder)
    }
}

#Preview {
    FCMovieList(
        movies: [mockMovieCaughtStealing.toFCMovie()],
        selectedMovieID: .constant(nil)
    )
    .frame(width: 700, height: 500)
    .navigationTitle(APP_NAME)
}
