//
//  FCMovieDetails.swift
//  Film Cache
//
//  Created by Kyle Nazario on 4/26/26.
//

import ReSwift
import SwiftUI

struct FCMovieDetails: View {
    @StateObject private var controller = FCMovieDetailsController()

    var body: some View {
        Group {
            if controller.loading {
                ProgressView()
            } else if let details = controller.movieDetails, let movie = controller.movie {
                FCMovieDetailsContent(movie: movie, details: details)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "film")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No movie selected")
                        .font(.headline)
                    Text("Select a movie to view details.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(controller.movieDetails?.title ?? "Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

final class FCMovieDetailsController: ObservableObject, StoreSubscriber {
    @Published private(set) var movieDetails: TMDBMovieDetails?
    @Published private(set) var movie: FCMovie?
    @Published private(set) var loading = false

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
            self.movie = state.selectedMovie
            self.loading = state.loadingMovieDetails
        }
    }
}

private struct FCMovieDetailsContent: View {
    let movie: FCMovie
    let details: TMDBMovieDetails

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(details.title)
                    .font(.largeTitle)
                    .bold()

                poster

                if !details.tagline.isEmpty {
                    Text(details.tagline)
                        .font(.title3)
                        .italic()
                }

                Text(details.overview)
                    .font(.body)

                VStack(spacing: 10) {
                    detailRow(label: "Release Date", value: formattedReleaseDate)
                    detailRow(label: "Runtime", value: formattedRuntime)
                    detailRow(label: "Genre(s)", value: genreList)
                }
                .padding(.top, 4)

                Divider()
                    .padding(.vertical, 4)

                Text("Showtimes")
                    .font(.title2)
                    .bold()

                FCScreeningTable(screenings: movie.screenings)
            }
            .padding()
        }
    }

    @ViewBuilder
    private var poster: some View {
        if let posterURL {
            AsyncImage(url: posterURL, transaction: Transaction(animation: .snappy)) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    posterPlaceholder
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(2 / 3, contentMode: .fit)
                @unknown default:
                    posterPlaceholder
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var posterPlaceholder: some View {
        ZStack {
            Color.secondary.opacity(0.15)
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(2 / 3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .bold()
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }

    private var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500/\(details.posterPath)")
    }

    private var formattedReleaseDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = inputFormatter.date(from: details.releaseDate) else {
            return details.releaseDate
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM. d, yyyy"
        return outputFormatter.string(from: date)
    }

    private var formattedRuntime: String {
        let hours = details.runtime / 60
        let minutes = details.runtime % 60
        return "\(hours)h \(minutes)m"
    }

    private var genreList: String {
        details.genres
            .map { $0.name }
            .joined(separator: ", ")
    }
}

private struct FCScreeningTable: View {
    let screenings: [FCScreening]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(FCTheater.allCases, id: \.self) { theater in
                if let theaterScreenings = screeningsByTheater[theater], !theaterScreenings.isEmpty {
                    FCTheaterScreeningDisclosure(theater: theater, screenings: theaterScreenings)
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
}

private struct FCTheaterScreeningDisclosure: View {
    let theater: FCTheater
    let screenings: [FCScreening]

    @State private var expanded = false

    var body: some View {
        DisclosureGroup(isExpanded: $expanded) {
            VStack(spacing: 0) {
                screeningHeader

                ForEach(sortedScreenings) { screening in
                    Divider()
                    screeningRow(screening)
                }
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.top, 8)
        } label: {
            Text(theater.formattedName)
                .font(.headline)
        }
    }

    private var screeningHeader: some View {
        HStack {
            Text("Date")
                .bold()
            Spacer()
            Text("Time")
                .bold()
        }
        .font(.subheadline)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private func screeningRow(_ screening: FCScreening) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(formattedDate(screening.time))
            Spacer()
            Text(formattedTime(screening.time))
                .foregroundStyle(.secondary)
        }
        .font(.subheadline)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private var sortedScreenings: [FCScreening] {
        screenings.sorted { $0.time < $1.time }
    }

    private func formattedDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM. d"
        return formatter.string(from: date)
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        FCMovieDetailsContent(movie: mockMovieCaughtStealing.toFCMovie(), details: mockDetailsCS)
    }
}
