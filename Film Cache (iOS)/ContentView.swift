//
//  ContentView.swift
//  Film Cache (iOS)
//
//  Created by Kyle Nazario on 10/24/25.
//

import SwiftUI
import ReSwift

struct ContentView: View {
    @StateObject() private var controller = ContentViewController()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $controller.selectedTab) {
                Tab(value: FCAppState.TabOption.megaplex) {
                    if controller.loading {
                        ProgressView()
                    } else {
                        FCMovieList(movies: controller.movies)
                    }
                } label: {
                    Label("Megaplex", systemImage: "film")
                }
                Tab(value: FCAppState.TabOption.utahTheater) {
                    FCUtahTheaterSchedule()
                } label: {
                    Label("Utah Theater", systemImage: "theatermasks")
                }
            }
        }
    }
}

final class ContentViewController: ObservableObject, StoreSubscriber {
    @Published private(set) var movies: [FCMovie] = []
    @Published private(set) var loading = false
    @Published var query: String = ""
    @Published private(set) var showSearchField = false
    @Published var selectedTab: FCAppState.TabOption = .megaplex {
        didSet {
            if selectedTab != fcStore.state.selectedTab {
                fcStore.dispatch(FCAction.tabSelected(selectedTab))
            }
        }
    }

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
            if let listQuery = state.listQuery {
                self.query = listQuery
            }
            withAnimation {
                self.showSearchField = state.listQuery != nil
            }
            self.selectedTab = state.selectedTab
        }
    }
}


#Preview {
    ContentView()
}
