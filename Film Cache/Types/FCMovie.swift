//
//  FCMovie.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import Foundation

struct FCMovie: Identifiable {
    let id: String
    let megaplexFilmId: String?
    let title: String
    let openingDate: Date
    let runTimeMinutes: Int
    let distributor: String
    let theaterName: String
    let screenings: [FCScreening]
    
    static let blankDate = Date(timeIntervalSince1970: 0)
}

extension [FCMovie] {
    func merged(with movies: [FCMovie]) -> [FCMovie] {
        var merged: [FCMovie] = []
        let nonUniqueMerged = self + movies
        nonUniqueMerged.forEach { movie in
            let alreadyMerged = merged.contains { mergedMovie in
                mergedMovie.megaplexFilmId == movie.megaplexFilmId
            }
            guard !alreadyMerged else { return }
            let moviesWithMegaplexId = nonUniqueMerged.filter { $0.megaplexFilmId == movie.megaplexFilmId }
            let theaterName = moviesWithMegaplexId
                .map { $0.theaterName }
                .joined(separator: ", ")
            let combined = FCMovie(id: movie.id, megaplexFilmId: movie.megaplexFilmId, title: movie.title, openingDate: movie.openingDate, runTimeMinutes: movie.runTimeMinutes, distributor: movie.distributor, theaterName: theaterName, screenings: moviesWithMegaplexId.flatMap { $0.screenings })
            merged.append(combined)
        }
        return merged
    }
}

struct FCScreening: Identifiable {
    var id: String {
        theater.rawValue + " " + time.ISO8601Format()
    }
    let theater: FCTheater
    let time: Date
}

enum FCTheater: String, CaseIterable {
    // Megaplex cases use their internal IDs
    case MegaplexProvidence = "0010"
    case MegaplexUniversity = "0008"
    case UtahTheater
    
    var formattedName: String {
        switch (self) {
        case .MegaplexProvidence:
            return "Megaplex Providence"
        case .MegaplexUniversity:
            return "Megaplex University Stadium 6"
        case .UtahTheater:
            return "The Utah Theater"
        }
    }
}
