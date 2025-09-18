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
    }
}

struct FCListDetailsSplitPane: View {
    let movies: [FCMovie]
    @Binding var selectedMovieID: FCMovie.ID?
    
    var body: some View {
        HStack {
            FCMovieList(movies: movies, selectedMovieID: $selectedMovieID)
            if let selectedMovie {
                FCMovieDetails(movie: selectedMovie)
            }
        }
    }
    
    private var selectedMovie: FCMovie? {
        movies.first { $0.id == selectedMovieID }
    }
}

#Preview {
    FCListDetailsSplitPane(
        movies: [mockMovieCaughtStealing.toFCMovie()],
        selectedMovieID: .constant(mockMovieCaughtStealing.id)
    )
        .frame(width: 700, height: 500)
        .navigationTitle(APP_NAME)
}
