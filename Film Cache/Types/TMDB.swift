//
//  TMDB.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import Foundation

// MARK: - TMDB Search Response
struct TMDBSearchResponse: Codable {
    let page: Int64
    let results: [TMDBResult]
    let totalPages: Int64
    let totalResults: Int64

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct TMDBResult: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDs: [Int64]
    let id: Int64
    let originalLanguage: TMDBOriginalLanguage
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int64

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Original Language
enum TMDBOriginalLanguage: String, Codable {
    case de = "de"
    case en = "en"
    case ja = "ja"
}
