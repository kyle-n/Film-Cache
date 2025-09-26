//
//  TMDBConnector.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import Foundation

enum TMDBConnector {
    static func searchMovies(title: String, year: Int) async throws -> [TMDBResult] {
        var url = URL(string: "https://api.themoviedb.org/3/search/movie")!
        
        // Megaplex puts "MegaReelDeal" in titles of rep screenings
        let currentYear = Calendar.current.component(.year, from: Date())
        let repScreeningIndicators = [
            "MegaReelDeal",
            "(Re-release)",
            "(Fathom \(currentYear))"
        ]
        var isRepScreening = false
        repScreeningIndicators.forEach { indicator in
            if title.contains(indicator) {
                isRepScreening = true
            }
        }
        
        let deletables = repScreeningIndicators + [
            "-Dub",
            "-Sub"
        ]
        var simplifiedTitle = title
        deletables.forEach { deletable in
            simplifiedTitle = simplifiedTitle.replacingOccurrences(of: deletable, with: "")
        }
        simplifiedTitle = simplifiedTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        url.append(queryItems: [
            URLQueryItem(name: "query", value: simplifiedTitle),
            URLQueryItem(name: "include_adult", value: "false"),
        ])
        if !isRepScreening {
            url.append(queryItems: [
                URLQueryItem(name: "primary_release_year", value: String(year))
            ])
        }

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

    static func getMovie(byTitle title: String, year: Int) async throws -> TMDBMovieDetails {
        let searchResults = try await searchMovies(title: title, year: year)
        guard let result = searchResults.first else {
            throw NSError(domain: "No movies returned from title search", code: 404)
        }
        let detailsResponse = try await getMovie(byTMDBID: result.id)
        return detailsResponse
    }
}
