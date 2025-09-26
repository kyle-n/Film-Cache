//
//  MegaplexConnector.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import Foundation

enum MegaplexConnector {
    static func getScheduledMovies(forTheaterId theaterId: String) async throws -> [MegaplexScheduledMovie] {
        let url = URL(string: "https://apiv2.megaplex.com/api/film/cinemaFilms/\(theaterId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let response = try await URLSession.shared.data(for: request)
        var movies: [MegaplexScheduledMovie] = []
        do {
            movies = try JSONDecoder().decode([MegaplexScheduledMovie].self, from: response.0)
        } catch {
            print(error)
        }
        return movies
    }

    // Megaplex adds to titles of their rep screenings
    static func getNormalizedTitle(for title: String) -> (String, Bool) {
        let currentYear = Calendar.current.component(.year, from: Date())
        let repScreeningIndicators = [
            "MegaReelDeal",
            "(Re-release)",
            "(Fathom \(currentYear))",
            "(Fathom \(currentYear - 1)",
            "(Fathom \(currentYear + 1)"
        ]
        var isRepScreening = false
        for indicator in repScreeningIndicators {
            if title.contains(indicator) {
                isRepScreening = true
            }
        }

        let deletables = repScreeningIndicators + [
            "-Dub",
            "-Sub"
        ]
        var normalizedTitle = title
        for deletable in deletables {
            normalizedTitle = normalizedTitle.replacingOccurrences(of: deletable, with: "")
        }
        normalizedTitle = normalizedTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        return (normalizedTitle, isRepScreening)
    }
}
