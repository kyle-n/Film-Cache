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
        VStack {
            if controller.loading {
                ProgressView()
            } else {
                ForEach(controller.megaplexMovies, id: \.id) { megaplexMovie in
                    Text(megaplexMovie.title)
                }
            }
        }
        .padding()
        .frame(width: 700, height: 500)
    }
}

#Preview {
    ContentView()
}
