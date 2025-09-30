//
//  State.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/30/25.
//

import ReSwift

struct FCAppState {
    var movies: [FCMovie]
    var loadingMovies: Bool
}

enum FCAction: Action {
    case moviesRequestStarted
    case moviesLoaded([FCMovie])
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

let fcStore = Store(reducer: fcReducer, state: defaultAppState)
