//
//  ContentView.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/11/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject() private var controller = ContentViewController()
    
    var body: some View {
        Group {
            if controller.loading {
                ProgressView()
            } else {
                MovieList(movies: controller.megaplexMovies)
            }
        }
        .navigationTitle(APP_NAME)
    }
}

struct MovieList: View {
    let movies: [MegaplexScheduledMovie]
    
    @State private var sortedMovies: [MegaplexScheduledMovie]
    @State private var sortOrder: [KeyPathComparator<MegaplexScheduledMovie>]
    
    init(movies: [MegaplexScheduledMovie]) {
        self.movies = movies
        let sortOrder = [KeyPathComparator(\MegaplexScheduledMovie.openingDate)]
        self.sortOrder = sortOrder
        self.sortedMovies = movies.sorted(using: sortOrder)
    }
    
    var body: some View {
        Table(sortedMovies, sortOrder: $sortOrder) {
            TableColumn("Title", value: \.title)
            TableColumn("Opening") { movie in
                MegaplexDate(date: movie.openingDate)
            }
            TableColumn("Runtime") { movie in
                Text(MovieList.getFormattedRunTime(forMinutes: movie.runTime))
            }
            TableColumn("Distributor", value: \.distributor)
            TableColumn("Theater", value: \.cinemaName)
        }
        .onAppear(perform: {
            print("\n\nqqq\n\n")
        })
        .onChange(of: movies, { _, newMovies in
            self.sortedMovies = movies.sorted(using: sortOrder)
        })
        .onChange(of: sortOrder) { _, newSortOrder in
            sortedMovies.sort(using: newSortOrder)
        }
    }
    
    private static func getFormattedRunTime(forMinutes min: String) -> String {
        let minutes = Int(min)
        guard let minutes else { return "" }
        let hours = Int(floor(Double(minutes) / 60))
        let leftoverMinutes = minutes % 60
        return "\(hours)h \(leftoverMinutes)m"
    }
}

struct MegaplexDate: View {
    let date: String
    
    var body: some View {
        Text(MegaplexDate.getFormattedDate(forStringDate: date))
    }
    
    private static let outputDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM. d"
        return formatter
    }()
    private static let inputDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    private static func getFormattedDate(forStringDate strDate: String) -> String {
        let date = inputDateFormatter.date(from: strDate)
        guard let date else { return "" }
        return outputDateFormatter.string(from: date)
    }
}

struct MovieLink: View {
    let movie: MegaplexScheduledMovie
    
    var body: some View {
        Text(movie.title)
            .font(.title)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.red, lineWidth: 2)
            }
    }
}

#Preview {
    MovieList(movies: [mockMovieCaughtStealing])
        .frame(width: 700, height: 500)
        .navigationTitle(APP_NAME)
}
