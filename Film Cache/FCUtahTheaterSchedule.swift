//
//  FCUtahTheaterSchedule.swift
//  Film Cache
//
//  Created by Kyle Nazario on 10/5/25.
//

import SwiftUI

struct FCUtahTheaterSchedule: View {
    @State private var scrollViewHeight: CGFloat?
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                AsyncImage(url: FCUtahTheaterSchedule.scheduleURL, transaction: Transaction(animation: .snappy)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else {
                        fullScreenLoader
                    }
                }
            }
            .onAppear {
                scrollViewHeight = geo.size.height
            }
        }
    }
    
    private var fullScreenLoader: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
        .frame(height: scrollViewHeight)
    }
    
    private static let scheduleURL = URL(string: "https://theutahtheatre.org/utah-festival-static-home-page.jpg")!
}

#Preview {
    FCUtahTheaterSchedule()
        .frame(width: 700, height: 700)
}
