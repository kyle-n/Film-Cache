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
                FCListDetailsSplitPane(movies: controller.movies)
            }
        }
        .navigationTitle(APP_NAME)
        .toolbar {
            FCRefreshButton()
        }
    }
}

struct FCListDetailsSplitPane: View {
    let movies: [FCMovie]

    var body: some View {
        GeometryReader { geo in
            HSplitView {
                FCMovieList(movies: movies)
                FCMovieDetailsContainer()
                    .frame(width: max(geo.size.width / 3, 300))
            }
        }
    }
}

#Preview {
    VStack {
        FCListDetailsSplitPane(
            movies: [mockMovieCaughtStealing.toFCMovie()],
        )
        .frame(width: 700, height: 350)
        .navigationTitle(APP_NAME)
        .border(Color.white)
        FCListDetailsSplitPane(
            movies: [mockMovieCaughtStealing.toFCMovie()]
        )
        .frame(width: 700, height: 350)
        .navigationTitle(APP_NAME)
    }
}
