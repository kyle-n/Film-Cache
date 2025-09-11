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
            formatCode: MegaplexFormat.vs00000001,
            formatHOPK: MegaplexFormat.vs00000001,
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
