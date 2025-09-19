//
//  FCMovieDetails.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import SwiftUI

struct FCMovieDetailsContainer: View {
    let movie: FCMovie
    
    @StateObject private var controller = FCMovieDetailsContainerController()
    
    var body: some View {
        VStack(alignment: .leading) {
            if controller.loading {
                ProgressView()
            }
            if let movieDetails = controller.movieDetails {
                FCMovieDetails(details: movieDetails)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            controller.loadMovieDetails(forTitle: movie.title)
        }
        .onChange(of: movie.title) { _, newMovieTitle in
            controller.loadMovieDetails(forTitle: newMovieTitle)
        }
    }
}

fileprivate final class FCMovieDetailsContainerController: ObservableObject {
    @Published private(set) var movieDetails: TMDBMovieDetails?
    @Published private(set) var loading = false
    
    init() {}
    
    func loadMovieDetails(forTitle title: String) {
        self.loading = true
        self.movieDetails = nil
        Task {
            let details = try await TMDBConnector.getMovie(byTitle: title)
            DispatchQueue.main.async {
                self.movieDetails = details
                self.loading = false
            }
        }
    }
}

struct FCMovieDetails: View {
    let details: TMDBMovieDetails
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                Text(details.title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                HStack {
                    Link("IMDB", destination: URL(string: "https://www.imdb.com/title/\(details.imdbID)")!)
                    Link("TMDB", destination: URL(string: "https://www.themoviedb.org/movie/\(details.id)")!)
                    Link("Letterboxd", destination: URL(string: "https://letterboxd.com/imdb/\(details.imdbID)")!)
                }
                if let posterURL {
                    AsyncImage(url: posterURL) { imgResult in
                        imgResult.image?
                            .resizable()
                            .scaledToFit()
                    }
                }
                Text(details.tagline)
                    .font(.title2)
                    .italic()
                    .padding(.bottom)
                Text(details.overview)
                Divider()
                    .padding(.vertical)
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
            }
        }
        .padding(.horizontal)
    }
    
    private var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500/\(details.posterPath)")
    }
    private var releaseDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.date(from: details.releaseDate)
    }
}

#Preview {
    FCMovieDetails(details: mockDetailsCS)
        .frame(width: 300, height: 700)
}
