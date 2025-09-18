//
//  TMDBConnector.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import Foundation

enum TMDBConnector {
    static func searchMovies(title: String) async throws -> TMDBSearchResponse {
        var url = URL(string: "https://api.themoviedb.org/3/search/movie")!

        let currentYear = Calendar.current.component(.year, from: Date())
        url.append(queryItems: [
            URLQueryItem(name: "query", value: title),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "primary_release_year", value: String(currentYear))
        ])
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + TMDB_API_READ_TOKEN, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let response = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(TMDBSearchResponse.self, from: response.0)
    }
}
