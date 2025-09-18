//
//  TMDBConnector.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import Foundation

enum TMDBConnector {
    static func searchMovies(title: String) async throws -> [TMDBResult] {
        var url = URL(string: "https://api.themoviedb.org/3/search/movie")!

        let currentYear = Calendar.current.component(.year, from: Date())
        url.append(queryItems: [
            URLQueryItem(name: "query", value: title),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "primary_release_year", value: String(currentYear)),
            URLQueryItem(name: "video", value: "false")
        ])
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + TMDB_API_READ_TOKEN, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let response = try await URLSession.shared.data(for: request)
        let searchResults = try JSONDecoder().decode(TMDBSearchResponse.self, from: response.0)
        
        // Filters "World Premier" videos
        return searchResults.results.filter { !$0.video }
    }
    
    static func getMovie(byTMDBID id: Int64) async throws -> TMDBMovieDetails {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(String(id))")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + TMDB_API_READ_TOKEN, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let response = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(TMDBMovieDetails.self, from: response.0)
    }
    
    static func getMovie(byTitle title: String) async throws -> TMDBMovieDetails {
        let searchResults = try await searchMovies(title: title)
        print(searchResults.count, "qqq count")
        guard let result = searchResults.first else {
            throw NSError(domain: "No movies returned from title search", code: 404)
        }
        let detailsResponse = try await getMovie(byTMDBID: result.id)
        return detailsResponse
    }
}
