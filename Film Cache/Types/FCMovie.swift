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
        theaterName + time.ISO8601Format()
    }
    let theaterName: String
    let time: Date
}
