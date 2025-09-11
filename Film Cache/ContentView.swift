//
//  ContentView.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject() private var controller = ContentViewController()
    
    var body: some View {
        NavigationStack {
            VStack {
                if controller.loading {
                    ProgressView()
                } else {
                    MovieList(movies: controller.megaplexMovies)
                }
            }
            .padding()
        }
        .navigationTitle(APP_NAME)
        .frame(width: 700, height: 500)
    }
}

struct MovieList: View {
    let movies: [MegaplexScheduledMovie]
    
    var body: some View {
        ForEach(movies) { movie in
            MovieLink(movie: movie)
        }
    }
}

struct MovieLink: View {
    let movie: MegaplexScheduledMovie
    
    var body: some View {
        Text(movie.title)
            .font(.title)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.red, lineWidth: 2)
            }
    }
}

#Preview {
    MovieList(movies: [mockMovieCaughtStealing])
        .frame(width: 700, height: 500)
        .navigationTitle(APP_NAME)
}
