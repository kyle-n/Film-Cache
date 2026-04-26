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

    var body: some View {
        VStack {
            List {
                Text(APP_NAME)
                    .font(.largeTitle)
                    .bold()
                ForEach(movies) { movie in
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
            .navigationDestination(isPresented: detailsPresented) {
                FCMovieDetails()
            }
        }
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

        var uniqueDays: [Date] = []
        for day in screeningDays {
            guard !uniqueDays.contains(where: { calendar.isDate($0, inSameDayAs: day) }) else {
                continue
            }
            uniqueDays.append(day)
            if uniqueDays.count == 3 {
                break
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return uniqueDays.map { formatter.string(from: $0) }
    }
}

#Preview {
    FCMovieList(movies: [mockMovieCaughtStealing.toFCMovie()])
}
