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
        Group {
            if controller.loading {
                ProgressView()
            } else {
                MovieList(movies: controller.movies)
            }
        }
        .navigationTitle(APP_NAME)
    }
}

#Preview {
    MovieList(movies: [mockMovieCaughtStealing.toFCMovie()])
        .frame(width: 700, height: 500)
        .navigationTitle(APP_NAME)
}
