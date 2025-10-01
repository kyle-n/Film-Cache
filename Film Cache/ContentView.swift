//
//  ContentView.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import SwiftUI
import ReSwift

struct ContentView: View {
    @StateObject() private var controller = ContentViewController()

    var body: some View {
        Group {
            if controller.loading {
                ProgressView()
            } else {
                FCListDetailsSplitPane(movies: controller.movies, showDetails: controller.showDetails)
            }
        }
        .navigationTitle(APP_NAME)
        .toolbar {
            FCRefreshButton()
            FCSearchButton()
        }
    }
}

final class ContentViewController: ObservableObject, StoreSubscriber {
    @Published private(set) var movies: [FCMovie] = []
    @Published private(set) var loading = false
    @Published private(set) var showDetails = false

    init() {
        DispatchQueue.main.async {
            fcStore.subscribe(self)
            fcStore.dispatch(FCAction.appOpened())
        }
    }

    deinit {
        fcStore.unsubscribe(self)
    }

    func newState(state: FCAppState) {
        DispatchQueue.main.async {
            self.movies = state.movies
            self.loading = state.loadingMovies
            self.showDetails = state.selectedMovieID != nil
        }
    }
}

struct FCListDetailsSplitPane: View {
    let movies: [FCMovie]
    let showDetails: Bool

    var body: some View {
        GeometryReader { geo in
            HSplitView {
                FCMovieList(movies: movies)
                if showDetails {
                    FCMovieDetailsContainer()
                        .frame(width: max(geo.size.width / 3, 300))
                }
            }
        }
    }
}

#Preview {
    VStack {
        FCListDetailsSplitPane(
            movies: [mockMovieCaughtStealing.toFCMovie()],
            showDetails: false
        )
        .frame(width: 700, height: 350)
        .navigationTitle(APP_NAME)
        .border(Color.white)
        FCListDetailsSplitPane(
            movies: [mockMovieCaughtStealing.toFCMovie()],
            showDetails: true
        )
        .frame(width: 700, height: 350)
        .navigationTitle(APP_NAME)
    }
}
