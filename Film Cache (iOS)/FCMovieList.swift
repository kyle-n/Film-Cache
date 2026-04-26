//
//  FCMovieList.swift
//  Film Cache
//
//  Created by Kyle Nazario on 4/26/26.
//

import SwiftUI

struct FCMovieList: View {
    let movies: [FCMovie]
    
    var body: some View {
        List(movies) { movie in
            FCMovieCard(movie: movie)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(.plain)
    }
}

private struct FCMovieCard: View {
    let movie: FCMovie

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(movie.title)
                .font(.title2)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            poster

            Text(movie.theaterName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 3)
    }

    @ViewBuilder
    private var poster: some View {
        if let posterURL = movie.posterURL {
            AsyncImage(url: posterURL, transaction: Transaction(animation: .snappy)) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    posterPlaceholder
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    posterPlaceholder
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(2 / 3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .clipped()
        } else {
            posterPlaceholder
                .frame(maxWidth: .infinity)
                .aspectRatio(2 / 3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }

    private var posterPlaceholder: some View {
        ZStack {
            Color.secondary.opacity(0.15)
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    FCMovieList(movies: [mockMovieCaughtStealing.toFCMovie()])
}
