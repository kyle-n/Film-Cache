//
//  ContentView.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import ReSwift
import SwiftUI

struct ContentView: View {
    @StateObject() private var controller = ContentViewController()

    var body: some View {
        Group {
            TabView(selection: $controller.selectedTab) {
                Tab(value: ContentViewController.TabOption.megaplex) {
                    if controller.loading {
                        ProgressView()
                    } else {
                        FCListDetailsSplitPane(movies: controller.movies, showDetails: controller.showDetails)
                    }
                } label: {
                    Label("Megaplex", systemImage: "film")
                }
                Tab(value: ContentViewController.TabOption.utahTheater) {
                    FCUtahTheaterSchedule()
                } label: {
                    Label("Utah Theater", systemImage: "theatermasks")
                }
            }
        }
        .navigationTitle(APP_NAME)
        .toolbar {
            // Nesting required, because top-level children of .toolbar() cannot be animated
            // https://www.reddit.com/r/SwiftUI/comments/1dt2bez/animated_transition_for_the_navigation_bar/
            ToolbarItemGroup {
                HStack {
                    FCRefreshButton()
                    if controller.showSearchField {
                        FCSearchField()
                            .frame(width: 160)
                            .transition(.scale)
                    } else {
                        FCSearchButton()
                    }
                }
                .animation(.snappy, value: controller.showSearchField)
            }
        }
    }
}

final class ContentViewController: ObservableObject, StoreSubscriber {
    @Published private(set) var movies: [FCMovie] = []
    @Published private(set) var loading = false
    @Published private(set) var showDetails = false
    @Published var query: String = ""
    @Published private(set) var showSearchField = false
    @Published var selectedTab: TabOption = .megaplex

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
            self.movies = state.filteredMovies
            self.loading = state.loadingMovies
            self.showDetails = state.selectedMovieID != nil
            if let listQuery = state.listQuery {
                self.query = listQuery
            }
            withAnimation {
                self.showSearchField = state.listQuery != nil
                if self.showSearchField {
                    self.selectedTab = .megaplex
                }
            }
        }
    }
    
    enum TabOption: CaseIterable, Hashable {
        case megaplex
        case utahTheater
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
