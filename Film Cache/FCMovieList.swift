//
//  FCMovieList.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/17/25.
//

import SwiftUI

struct FCMovieList: View {
    let movies: [FCMovie]
    
    @State private var selectedMovieID: FCMovie.ID?
    @State private var sortOrder: [KeyPathComparator<FCMovie>] = [KeyPathComparator(\FCMovie.openingDate)]
    private let narrowColWidth: CGFloat = 60

    var body: some View {
        Table(sortedMovies, selection: $selectedMovieID, sortOrder: $sortOrder) {
            TableColumn("Title", value: \.title)
                .width(ideal: 150)
            TableColumn("Opening", value: \.openingDate) { movie in
                FCFormattedDate(movie.openingDate)
            }
            .width(ideal: narrowColWidth)
            TableColumn("Runtime", value: \.runTimeMinutes) { movie in
                FCFormattedRunTime(movie.runTimeMinutes)
            }
            .width(ideal: narrowColWidth)
            TableColumn("Distributor", value: \.distributor)
                .width(ideal: narrowColWidth)
            TableColumn("Theater(s)", value: \.theaterName)
        }
        .onChange(of: selectedMovieID) { _, newValue in
            fcStore.dispatch(FCAction.movieSelected(id: newValue))
        }
    }

    private var sortedMovies: [FCMovie] {
        return movies.sorted(using: sortOrder)
    }
}

#Preview {
    FCMovieList(
        movies: [mockMovieCaughtStealing.toFCMovie()]
    )
    .frame(width: 700, height: 500)
    .navigationTitle(APP_NAME)
}
