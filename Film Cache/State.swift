//
//  State.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/30/25.
//

import ReSwift
import ReSwiftThunk

struct FCAppState {
    var movies: [FCMovie]
    var loadingMovies: Bool
}

enum FCAction: Action {
    case moviesRequestStarted
    case moviesLoaded([FCMovie])
    
    enum Thunks {    
        static func appOpened() -> Thunk<FCAppState> {
            Thunk { dispatch, getState in
                guard getState()?.loadingMovies == false else { return }
                dispatch(FCAction.moviesRequestStarted)
                Task {
                    let providenceMovies = try await MegaplexConnector
                        .getScheduledMovies(forTheaterId: FCTheater.MegaplexProvidence.rawValue).map { $0.toFCMovie() }
                    let universityMovies = try await MegaplexConnector
                        .getScheduledMovies(forTheaterId: FCTheater.MegaplexUniversity.rawValue).map { $0.toFCMovie() }
                    let megaplexMovies = providenceMovies.merged(with: universityMovies)
                    dispatch(FCAction.moviesLoaded(megaplexMovies))
                }
            }
        }
    }
}

let defaultAppState = FCAppState(movies: [], loadingMovies: false)

func fcReducer(action: Action, state: FCAppState?) -> FCAppState {
    var state = state ?? defaultAppState
    guard let action = action as? FCAction else { return state }
    
    switch action {
    case .moviesRequestStarted:
        state.loadingMovies = true
        state.movies = []
    case .moviesLoaded(let movies):
        state.movies = movies
        state.loadingMovies = false
    }
    
    return state
}

let thunkMiddleware: Middleware<FCAppState> = createThunkMiddleware()

let fcStore = Store(reducer: fcReducer, state: defaultAppState, middleware: [thunkMiddleware])
