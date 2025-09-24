//
//  MegaplexScheduledMovies.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import Foundation

let mockMovieCaughtStealing = MegaplexScheduledMovie(
    id: "0010-HO00003847",
    scheduledFilmId: "HO00003847",
    cinemaId: "0010",
    sessions: [
        MegaplexSession(
            id: "0010-96351",
            cinemaId: "0010",
            scheduledFilmId: "HO00003847",
            sessionId: "96351",
            areaCategoryCodes: ["0000000000"],
            showtime: "2025-09-11T16:30:00",
            isAllocatedSeating: true,
            allowChildAdmits: false,
            seatsAvailable: 147,
            allowComplimentaryTickets: true,
            eventId: "",
            priceGroupCode: "2423",
            screenName: "Screen 03",
            screenNameAlt: "",
            screenNumber: 3,
            cinemaOperatorCode: "0010",
            formatCode: "vs00000001",
            formatHOPK: "vs00000001",
            salesChannels: ";ATMOB;IVR;CALL;FAND;FANDM;GSALE;MXHW;WWW;KIOSK;CELL;PDA;MTINT;MTMOB;MXATM;MXFD;MXS;MXTV;POSBK;POS;RSP;SKI;",
            sessionAttributesNames: [MegaplexAttributesName.the2D, MegaplexAttributesName.cc, MegaplexAttributesName.dvs],
            conceptAttributesNames: [MegaplexAttributesName.the2D, MegaplexAttributesName.cc, MegaplexAttributesName.dvs],
            allowTicketSales: true,
            hasDynamicallyPricedTicketsAvailable: false,
            playThroughId: nil,
            sessionBusinessDate: "2025-09-11T00:00:00",
            sessionDisplayPriority: 0,
            groupSessionsByAttribute: false,
            soldoutStatus: 0,
            typeCode: MegaplexTypeCode.n,
            sponsoredAuditoriumImageUrl: nil
        ),
        // ...repeat for the other Session objects using their respective values...
    ],
    sessionCount: 0,
    firstDaysSessions: nil,
    futureSessions: nil,
    hasFutureSessions: true,
    title: "Caught Stealing",
    titleAlt: "",
    distributor: "Sony",
    rating: "R",
    ratingAlt: "",
    ratingDescription: "for strong violent content,  pervasive language, some sexuality/nudity and brief drug  use.",
    ratingDescriptionAlt: "",
    synopsis: """
    Hank Thompson (Austin Butler) was a high-school baseball phenom who can’t play anymore, but everything else is going okay. He’s got a great girl (Zoë Kravitz), tends bar at a New York dive, and his favorite team is making an underdog run at the pennant.

    When his punk-rock neighbor Russ (Matt Smith) asks him to take care of his cat for a few days, Hank suddenly finds himself caught in the middle of a motley crew of threatening gangsters. They all want a piece of him; the problem is he has no idea why. As Hank attempts to evade their ever-tightening grip, he’s got to use all his hustle to stay alive long enough to find out…

    Caught Stealing is directed by Academy Award® nominee Darren Aronofsky, screenplay by Charlie Huston, based on his book of the same name. The film stars Austin Butler, Regina King, Zoë Kravitz, Matt Smith, Liev Schreiber, Vincent D’Onofrio, Griffin Dunne, Benito A Martínez Ocasio, and Carol Kane.
    """,
    synopsisAlt: "",
    openingDate: "2025-08-29T00:00:00",
    filmHOPK: "HO00003847",
    filmHOCode: "F000005237",
    shortCode: "",
    runTime: "107",
    trailerUrl: "",
    cast: nil,
    displaySequence: 50,
    twitterTag: "Caught Stealing",
    hasSessionsAvailable: true,
    graphicUrl: "",
    cinemaName: "Providence",
    cinemaNameAlt: "",
    allowTicketSales: true,
    advertiseAdvanceBookingDate: true,
    advanceBookingDate: "2025-08-05T07:00:00",
    loyaltyAdvanceBookingDate: nil,
    hasDynamicallyPricedTicketsAvailable: false,
    isPlayThroughMarketingFilm: false,
    playThroughFilms: nil,
    nationalOpeningDate: "2025-08-29T00:00:00",
    corporateFilmId: "",
    ediCode: nil,
    genres: [],
    genreId: nil,
    genreId2: nil,
    genreId3: nil,
    genreIDs: ["0000000005", "0000000016", nil],
    additionalUrls: nil
)

let mockDetailsCS = try! JSONDecoder().decode(TMDBMovieDetails.self, from: """
{
  "adult": false,
  "backdrop_path": "/9ZhhlJbtLmzjvdbxbNzHZEBFdIZ.jpg",
  "belongs_to_collection": null,
  "budget": 40000000,
  "genres": [
    {
      "id": 80,
      "name": "Crime"
    },
    {
      "id": 53,
      "name": "Thriller"
    },
    {
      "id": 35,
      "name": "Comedy"
    }
  ],
  "homepage": "https://caughtstealing.movie",
  "id": 1245993,
  "imdb_id": "tt1493274",
  "origin_country": [
    "US"
  ],
  "original_language": "en",
  "original_title": "Caught Stealing",
  "overview": "Burned-out ex-baseball player Hank Thompson unexpectedly finds himself embroiled in a dangerous struggle for survival amidst the criminal underbelly of 1990s New York City, forced to navigate a treacherous underworld he never imagined.",
  "popularity": 14.4907,
  "poster_path": "/cvda8s5J8YaHjTyEyXQpvD6f3iV.jpg",
  "production_companies": [
    {
      "id": 7503,
      "logo_path": "/3K8wbNkTn7O4wX89ucnp1ZYR1XF.png",
      "name": "Protozoa Pictures",
      "origin_country": "US"
    },
    {
      "id": 22213,
      "logo_path": "/qx9K6bFWJupwde0xQDwOvXkOaL8.png",
      "name": "TSG Entertainment",
      "origin_country": "US"
    },
    {
      "id": 5,
      "logo_path": "/71BqEFAF4V3qjjMPCpLuyJFB9A.png",
      "name": "Columbia Pictures",
      "origin_country": "US"
    }
  ],
  "production_countries": [
    {
      "iso_3166_1": "US",
      "name": "United States of America"
    }
  ],
  "release_date": "2025-08-26",
  "revenue": 27400375,
  "runtime": 107,
  "spoken_languages": [
    {
      "english_name": "English",
      "iso_639_1": "en",
      "name": "English"
    },
    {
      "english_name": "Russian",
      "iso_639_1": "ru",
      "name": "Pусский"
    },
    {
      "english_name": "Spanish",
      "iso_639_1": "es",
      "name": "Español"
    },
    {
      "english_name": "Yiddish",
      "iso_639_1": "yi",
      "name": ""
    }
  ],
  "status": "Released",
  "tagline": "2 Russians, 2 Jews, and a Puerto Rican walk into a bar...",
  "title": "Caught Stealing",
  "video": false,
  "vote_average": 6.952,
  "vote_count": 189
}
""".data(using: .utf8)!)
