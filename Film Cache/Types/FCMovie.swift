//
//  FCMovie.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import Foundation

struct FCMovie: Identifiable {
    let id: String
    let title: String
    let openingDate: Date
    let runTimeMinutes: Int
    let distributor: String
    let theaterName: String
    let screenings: [FCScreening]
    
    static let blankDate = Date(timeIntervalSince1970: 0)
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
