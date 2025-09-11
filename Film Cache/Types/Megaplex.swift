//
//  Megaplex.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import Foundation

// MARK: - MegaplexScheduledMovie
struct MegaplexScheduledMovie: Codable {
    let id: String
    let scheduledFilmId: String
    let cinemaId: String
    let sessions: [MegaplexSession]
    let sessionCount: Int64
    let firstDaysSessions: AnyCodable?
    let futureSessions: AnyCodable?
    let hasFutureSessions: Bool
    let title: String
    let titleAlt: String
    let distributor: String
    let rating: String
    let ratingAlt: String
    let ratingDescription: String
    let ratingDescriptionAlt: String
    let synopsis: String
    let synopsisAlt: String
    let openingDate: MegaplexTime
    let filmHOPK: String
    let filmHOCode: String
    let shortCode: String
    let runTime: String
    let trailerUrl: String
    let cast: AnyCodable?
    let displaySequence: Int64
    let twitterTag: String
    let hasSessionsAvailable: Bool
    let graphicUrl: String
    let cinemaName: MegaplexCinemaName
    let cinemaNameAlt: String
    let allowTicketSales: Bool
    let advertiseAdvanceBookingDate: Bool
    let advanceBookingDate: MegaplexTime
    let loyaltyAdvanceBookingDate: AnyCodable?
    let hasDynamicallyPricedTicketsAvailable: Bool
    let isPlayThroughMarketingFilm: Bool
    let playThroughFilms: AnyCodable?
    let nationalOpeningDate: MegaplexTime
    let corporateFilmId: String
    let ediCode: AnyCodable?
    let genres: [AnyCodable]
    let genreId: String?
    let genreId2: String?
    let genreId3: String?
    let genreIDs: [String?]
    let additionalUrls: AnyCodable?
}

// MARK: - MegaplexSession
struct MegaplexSession: Codable {
    let id: String
    let cinemaId: String
    let scheduledFilmId: String
    let sessionId: String
    let areaCategoryCodes: [String]
    let showtime: MegaplexTime
    let isAllocatedSeating: Bool
    let allowChildAdmits: Bool
    let seatsAvailable: Int64
    let allowComplimentaryTickets: Bool
    let eventId: String
    let priceGroupCode: String
    let screenName: String
    let screenNameAlt: String
    let screenNumber: Int64
    let cinemaOperatorCode: String
    let formatCode: MegaplexFormat
    let formatHOPK: MegaplexFormat
    let salesChannels: String
    let sessionAttributesNames: [MegaplexAttributesName]
    let conceptAttributesNames: [MegaplexAttributesName]
    let allowTicketSales: Bool
    let hasDynamicallyPricedTicketsAvailable: Bool
    let playThroughId: AnyCodable?
    let sessionBusinessDate: MegaplexTime
    let sessionDisplayPriority: Int64
    let groupSessionsByAttribute: Bool
    let soldoutStatus: Int64
    let typeCode: MegaplexTypeCode
    let sponsoredAuditoriumImageUrl: AnyCodable?
}

// MARK: - Enums
enum MegaplexCinemaName: String, Codable {
    case university = "University"
}

enum MegaplexAttributesName: String, Codable {
    case cc = "CC"
    case dbox = "DBOX"
    case dvs = "DVS"
    case luxury = "Luxury"
    case openCapt = "Open Capt"
    case sensory = "Sensory"
    case the2D = "2D"
    case the3D = "3D"
}

enum MegaplexFormat: String, Codable {
    case the0000000001 = "0000000001"
    case the0000000017 = "0000000017"
    case vs00000001 = "VS00000001"
}

enum MegaplexTypeCode: String, Codable {
    case n = "N"
}

// MARK: - Placeholder Types
// Replace with your actual MegaplexTime implementation
typealias MegaplexTime = String

/// Wrapper to handle `interface{}`/`Any` equivalents in Go
struct AnyCodable: Codable {}
