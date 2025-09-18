//
//  FCMovieDetails.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import SwiftUI

struct FCMovieDetails: View {
    let movie: FCMovie
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(movie.title)
                .font(.title)
                .padding(.top)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
}

#Preview {
    FCMovieDetails(movie: mockMovieCaughtStealing.toFCMovie())
        .frame(width: 250, height: 500)
}
