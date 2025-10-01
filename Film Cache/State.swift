//
//  State.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/30/25.
//

import Foundation
import ReSwift
import ReSwiftThunk

struct FCAppState {
    var movies: [FCMovie]
    var loadingMovies: Bool
    var selectedMovieID: FCMovie.ID?
    var loadingMovieDetails: Bool
    var movieDetails: TMDBMovieDetails?
    var listQuery: String?

    var selectedMovie: FCMovie? {
        movies.first { $0.id == selectedMovieID }
    }
}

enum FCAction: Action {
    case moviesRequestStarted
    case moviesRequestErrored
    case moviesLoaded([FCMovie])
    case movieDeselected
    case movieDetailsRequestStarted(FCMovie.ID?)
    case movieDetailsRequestErrored
    case movieDetailsLoaded(TMDBMovieDetails)
    case searchStarted
    case queryChanged(String)

    static func appOpened() -> Thunk<FCAppState> {
        loadMovieList()
    }

    static func movieListRefreshed() -> Thunk<FCAppState> {
        loadMovieList()
    }

    static func movieSelected(id: FCMovie.ID?) -> Thunk<FCAppState> {
        Thunk { dispatch, getState in
            guard let state = getState(),
                  state.loadingMovieDetails == false
            else { return }
            let movie = state.movies.first { movie in
                movie.id == id
            }
            guard let movie = movie else { return }
            dispatch(FCAction.movieDetailsRequestStarted(id))
            Task {
                do {
                    let year = Calendar.current.component(.year, from: movie.openingDate)
                    let details = try await TMDBConnector.getMovie(byTitle: movie.title, year: year)
                    dispatch(FCAction.movieDetailsLoaded(details))
                } catch {
                    print(error)
                    FCError.display(error: error, type: .couldNotLoadFilmDetails)
                    dispatch(FCAction.movieDetailsRequestErrored)
                }
            }
        }
    }

    private static func loadMovieList() -> Thunk<FCAppState> {
        Thunk { dispatch, getState in
            guard getState()?.loadingMovies == false else { return }
            dispatch(FCAction.moviesRequestStarted)
            Task {
                do {
                    let providenceMovies = try await MegaplexConnector
                        .getScheduledMovies(forTheaterId: FCTheater.MegaplexProvidence.rawValue).map { $0.toFCMovie() }
                    let universityMovies = try await MegaplexConnector
                        .getScheduledMovies(forTheaterId: FCTheater.MegaplexUniversity.rawValue).map { $0.toFCMovie() }
                    let megaplexMovies = providenceMovies.merged(with: universityMovies)
                    dispatch(FCAction.moviesLoaded(megaplexMovies))
                } catch {
                    print(error)
                    FCError.display(error: error, type: .couldNotLoadFilms)
                }
            }
        }
    }
}

let defaultAppState = FCAppState(movies: [], loadingMovies: false, loadingMovieDetails: false)

func fcReducer(action: Action, state: FCAppState?) -> FCAppState {
    var state = state ?? defaultAppState
    guard let action = action as? FCAction else { return state }

    switch action {
    case .moviesRequestStarted:
        state.loadingMovies = true
        state.movies = []
        state.selectedMovieID = nil
        state.movieDetails = nil
    case .moviesRequestErrored:
        state.loadingMovies = false
    case let .moviesLoaded(movies):
        state.movies = movies
        state.loadingMovies = false
    case .movieDeselected:
        state.movieDetails = nil
        state.loadingMovies = false
        state.selectedMovieID = nil
    case let .movieDetailsRequestStarted(selectedMovieID):
        state.movieDetails = nil
        state.loadingMovieDetails = true
        state.selectedMovieID = selectedMovieID
    case .movieDetailsRequestErrored:
        state.loadingMovieDetails = false
    case let .movieDetailsLoaded(movieDetails):
        state.movieDetails = movieDetails
        state.loadingMovieDetails = false
    case .searchStarted:
        state.listQuery = ""
    case let .queryChanged(newQuery):
        state.listQuery = newQuery
    }

    return state
}

let thunkMiddleware: Middleware<FCAppState> = createThunkMiddleware()

let fcStore = Store(reducer: fcReducer, state: defaultAppState, middleware: [thunkMiddleware])
