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
    let openingDate: Date?
    let runTimeMinutes: Int
    let distributor: String
    let theaterName: String
}
