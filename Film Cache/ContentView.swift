//
//  ContentView.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject() private var controller = ContentViewController()
    @State private var selectedMovieID: FCMovie.ID?

    var body: some View {
        Group {
            if controller.loading {
                ProgressView()
            } else {
                FCListDetailsSplitPane(movies: controller.movies, selectedMovieID: $selectedMovieID)
            }
        }
        .navigationTitle(APP_NAME)
        .toolbar {
            Button(action: controller.loadMovies) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
}

struct FCListDetailsSplitPane: View {
    let movies: [FCMovie]
    @Binding var selectedMovieID: FCMovie.ID?

    var body: some View {
        GeometryReader { geo in
            HSplitView {
                FCMovieList(movies: movies, selectedMovieID: $selectedMovieID)
                if let selectedMovie {
                    FCMovieDetailsContainer(movie: selectedMovie)
                        .frame(width: max(geo.size.width / 3, 300))
                }
            }
        }
    }

    private var selectedMovie: FCMovie? {
        movies.first { $0.id == selectedMovieID }
    }
}

#Preview {
    VStack {
        FCListDetailsSplitPane(
            movies: [mockMovieCaughtStealing.toFCMovie()],
            selectedMovieID: .constant(mockMovieCaughtStealing.id)
        )
        .frame(width: 700, height: 350)
        .navigationTitle(APP_NAME)
        .border(Color.white)
        FCListDetailsSplitPane(
            movies: [mockMovieCaughtStealing.toFCMovie()],
            selectedMovieID: .constant(nil)
        )
        .frame(width: 700, height: 350)
        .navigationTitle(APP_NAME)
    }
}
