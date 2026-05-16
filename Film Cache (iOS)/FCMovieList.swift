//
//  FCMovieList.swift
//  Film Cache
//
//  Created by Kyle Nazario on 4/26/26.
//

import ReSwift
import SwiftUI

struct FCMovieList: View {
    let movies: [FCMovie]

    @StateObject private var controller = FCMovieListController()
    @State private var dragging = false

    var body: some View {
        VStack {
            List {
                Text(APP_NAME)
                    .font(.largeTitle)
                    .bold()
                ForEach(sortedMovies) { movie in
                    Button {
                        controller.movieTapped(movie)
                    } label: {
                        FCMovieCard(movie: movie)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
            }
            .listStyle(.plain)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        dragging = true
                    }
                    .onEnded { _ in
                        dragging = false
                    }
            )
            .refreshable {
                await refreshMoviesAfterDragEnds()
            }
            .navigationDestination(isPresented: detailsPresented) {
                FCMovieDetails()
            }
        }
    }

    private var sortedMovies: [FCMovie] {
        let now = Date()
        return movies.sorted { lhs, rhs in
            let lhsNextScreening = lhs.nextScreeningTime(after: now)
            let rhsNextScreening = rhs.nextScreeningTime(after: now)

            switch (lhsNextScreening, rhsNextScreening) {
            case let (lhsNextScreening?, rhsNextScreening?):
                if lhsNextScreening != rhsNextScreening {
                    return lhsNextScreening < rhsNextScreening
                }
                return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            case (nil, nil):
                return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
            }
        }
    }

    private func refreshMoviesAfterDragEnds() async {
        while dragging {
            try? await Task.sleep(for: .milliseconds(50))
        }
        controller.refreshMovies()
    }

    private var detailsPresented: Binding<Bool> {
        Binding {
            controller.showMovieDetails
        } set: { isPresented in
            if !isPresented {
                controller.movieDetailsDismissed()
            }
        }
    }
}

private extension FCMovie {
    func nextScreeningTime(after referenceDate: Date) -> Date? {
        screenings
            .map(\.time)
            .filter { $0 >= referenceDate }
            .min()
    }
}

private final class FCMovieListController: ObservableObject, StoreSubscriber {
    @Published private(set) var showMovieDetails = false

    init() {
        DispatchQueue.main.async {
            fcStore.subscribe(self)
        }
    }

    deinit {
        fcStore.unsubscribe(self)
    }

    func movieTapped(_ movie: FCMovie) {
        fcStore.dispatch(FCAction.movieSelected(id: movie.id))
    }

    func refreshMovies() {
        fcStore.dispatch(FCAction.movieListRefreshed())
    }

    func movieDetailsDismissed() {
        fcStore.dispatch(FCAction.movieDeselected)
    }

    func newState(state: FCAppState) {
        DispatchQueue.main.async {
            self.showMovieDetails = state.movieDetails != nil
        }
    }
}

private struct FCMovieCard: View {
    let movie: FCMovie

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(movie.title)
                .font(.title2)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Text(movie.theaterName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            if !nextScreeningWeekdays.isEmpty {
                Text(nextScreeningWeekdays.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(cardBorder, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: shadowColor, radius: 8, x: 0, y: 3)
    }

    private var cardBackground: Color {
        colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }

    private var cardBorder: Color {
        colorScheme == .dark ? .white.opacity(0.18) : .black.opacity(0.08)
    }

    private var shadowColor: Color {
        colorScheme == .dark ? .black.opacity(0.65) : .black.opacity(0.12)
    }

    private var nextScreeningWeekdays: [String] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let screeningDays = movie.screenings
            .map { calendar.startOfDay(for: $0.time) }
            .filter { $0 >= today }
            .sorted()

        let weekdayCutoff = calendar.date(byAdding: .day, value: 6, to: today) ?? today
        var uniqueDays: [Date] = []
        var labels: [String] = []
        for day in screeningDays {
            guard !uniqueDays.contains(where: { calendar.isDate($0, inSameDayAs: day) }) else {
                continue
            }
            uniqueDays.append(day)

            if day > weekdayCutoff {
                return labels.isEmpty ? [day.fcShowtimeDayLabel(relativeTo: today, calendar: calendar)] : labels
            }

            labels.append(day.fcShowtimeDayLabel(relativeTo: today, calendar: calendar))
            if labels.count == 3 {
                break
            }
        }

        return labels
    }
}

#Preview {
    FCMovieList(movies: [mockMovieCaughtStealing.toFCMovie()])
}
