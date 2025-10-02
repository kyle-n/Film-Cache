//
//  FCMovieDetailsContainer.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import ReSwift
import SwiftUI

struct FCMovieDetailsContainer: View {
    @StateObject private var controller = FCMovieDetailsContainerController()

    var body: some View {
        VStack(alignment: .leading) {
            if controller.loading {
                fullPanelLoader
            }
            if let movieDetails = controller.movieDetails, let movie = controller.movie {
                FCMovieDetails(movie: movie, details: movieDetails)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var fullPanelLoader: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
    }
}

private final class FCMovieDetailsContainerController: ObservableObject, StoreSubscriber {
    @Published private(set) var movieDetails: TMDBMovieDetails?
    @Published private(set) var loading = false
    @Published private(set) var movie: FCMovie?

    init() {
        DispatchQueue.main.async {
            fcStore.subscribe(self)
        }
    }

    deinit {
        fcStore.unsubscribe(self)
    }

    func newState(state: FCAppState) {
        DispatchQueue.main.async {
            self.movieDetails = state.movieDetails
            self.loading = state.loadingMovieDetails
            if let movie = state.selectedMovie {
                self.movie = movie
            }
        }
    }
}

struct FCMovieDetails: View {
    let movie: FCMovie
    let details: TMDBMovieDetails

    private let iconLinkHeight: CGFloat = 30

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(details.title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                HStack {
                    FCMovieDetailLinks(tmdbID: details.id, imdbID: details.imdbID)
                    Spacer()
                }
                if let posterURL {
                    AsyncImage(url: posterURL, transaction: Transaction(animation: .snappy)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
                Text(details.tagline)
                    .font(.title2)
                    .italic()
                    .padding(.bottom)
                Text(details.overview)
                    .padding(.bottom)
                FCMovieDetailList(details: details)
                Divider()
                    .padding(.vertical)
                Text("Screenings")
                    .font(.title2)
                    .bold()
                FCScreeningList(screenings: movie.screenings)
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
    }

    private var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500/\(details.posterPath)")
    }
}

struct FCScreeningList: View {
    let screenings: [FCScreening]

    var body: some View {
        VStack {
            ForEach(FCTheater.allCases, id: \.self) { theater in
                if let screeningsForTheater = screeningsByTheater[theater] {
                    Text(theater.formattedName)
                        .font(.title3)
                        .bold()
                        .padding(.vertical)

                    getScreeningsByDay(theaterScreenings: screeningsForTheater)
                }
            }
        }
    }

    private func getScreeningsByDay(theaterScreenings: [FCScreening]) -> some View {
        let screeningsByDay = FCScreeningList.getTheaterScreeningsByDay(screenings: theaterScreenings)
        return VStack {
            if !screeningsByDay.today.isEmpty {
                FCScreeningTimeList(name: "Today", screenings: screeningsByDay.today)
            } else {
                HStack {
                    Text("No screenings today.")
                    Spacer()
                }
            }
            if !screeningsByDay.tomorrow.isEmpty {
                FCScreeningTimeList(name: "Tomorrow", screenings: screeningsByDay.tomorrow)
            } else {
                HStack {
                    Text("No screenings tomorrow.")
                    Spacer()
                }
            }
            if !screeningsByDay.others.isEmpty {
                FCScreeningTimeList(name: "Other", screenings: screeningsByDay.others)
            } else {
                HStack {
                    Text("No other screenings.")
                    Spacer()
                }
            }
        }
    }

    private var screeningsByTheater: [FCTheater: [FCScreening]] {
        var groupedScreenings = [FCTheater: [FCScreening]]()
        for screening in screenings {
            var screeningsForTheater = groupedScreenings[screening.theater] ?? []
            screeningsForTheater.append(screening)
            groupedScreenings[screening.theater] = screeningsForTheater
        }
        return groupedScreenings
    }

    private static func getTheaterScreeningsByDay(screenings: [FCScreening]) -> FCScreeningsByDay {
        let now = Date()
        var today: [FCScreening] = []
        var tomorrow: [FCScreening] = []
        var others: [FCScreening] = []
        for screening in screenings {
            if Calendar.current.isDateInToday(screening.time) {
                today.append(screening)
            } else if Calendar.current.isDateInTomorrow(screening.time) {
                tomorrow.append(screening)
            } else {
                others.append(screening)
            }
        }
        return FCScreeningsByDay(today: today, tomorrow: tomorrow, others: others)
    }

    private struct FCScreeningsByDay {
        let today: [FCScreening]
        let tomorrow: [FCScreening]
        let others: [FCScreening]
    }
}

struct FCScreeningTimeList: View {
    let name: String
    let screenings: [FCScreening]

    @State private var expanded = true

    var body: some View {
        DisclosureGroup(isExpanded: $expanded) {
            Table(screenings) {
                TableColumn("Date") { screening in
                    FCFormattedDate(screening.time)
                }
                .width(100)
                TableColumn("Time") { screening in
                    Text(FCScreeningTimeList.getFormattedTime(forScreening: screening))
                }
            }
            .tableColumnHeaders(.hidden)
            .frame(height: 24 * CGFloat(screenings.count) + 6)
            .scrollDisabled(true)
        } label: {
            Text(name)
                .bold()
        }
    }

    private static func getFormattedTime(forScreening screening: FCScreening) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: screening.time)
    }
}

struct FCMovieDetailList: View {
    let details: TMDBMovieDetails

    var body: some View {
        if let releaseDate {
            HStack {
                Text("Release Date")
                    .bold()
                Spacer()
                FCFormattedDate(releaseDate)
            }
        }
        HStack {
            Text("Runtime")
                .bold()
            Spacer()
            FCFormattedRunTime(details.runtime)
        }
        HStack {
            Text("Genre(s)")
                .bold()
            Spacer()
            Text(genreList)
        }
    }

    private var releaseDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.date(from: details.releaseDate)
    }

    private var genreList: String {
        details.genres
            .map { $0.name }
            .joined(separator: ", ")
    }
}

struct FCMovieDetailLinks: View {
    let tmdbID: Int
    let imdbID: String

    var body: some View {
        HStack {
            ForEach(links, id: \.name) { link in
                Button(link.name) {
                    NSWorkspace.shared.open(link.url)
                }
            }
        }
    }

    private var links: [(name: String, url: URL)] {
        [
            (name: "IMDB", url: URL(string: "https://www.imdb.com/title/\(imdbID)")),
            (name: "Letterboxd", url: URL(string: "https://letterboxd.com/imdb/\(imdbID)")),
            (name: "The Movie DB", url: URL(string: "https://www.themoviedb.org/movie/\(tmdbID)"))
        ].compactMap { (name: String, url: URL?) in
            guard let url else { return nil }
            return (name: name, url: url)
        }
    }
}

#Preview {
    FCMovieDetails(movie: mockMovieCaughtStealing.toFCMovie(), details: mockDetailsCS)
        .frame(width: 400, height: 700)
}
