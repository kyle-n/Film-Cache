//
//  FCUtahTheaterSchedule.swift
//  Film Cache
//
//  Created by Kyle Nazario on 4/26/26.
//

import SwiftUI

struct FCUtahTheaterSchedule: View {
    var body: some View {
        GeometryReader { geo in
            AsyncImage(
                url: FCUtahTheaterSchedule.scheduleURL,
                transaction: Transaction(animation: .snappy)
            ) { phase in
                switch phase {
                case let .success(image):
                    FCZoomableScheduleImage(image: image)
                case .failure:
                    unavailableView
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    unavailableView
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private var unavailableView: some View {
        ContentUnavailableView(
            "Schedule Unavailable",
            systemImage: "photo",
            description: Text("The Utah Theatre schedule could not be loaded.")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private static let scheduleURL = URL(string: "https://theutahtheatre.org/utah-festival-static-home-page.jpg")!
}

private struct FCZoomableScheduleImage: View {
    let image: Image

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero

    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .offset(offset)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(magnificationGesture)
            .simultaneousGesture(dragGesture)
            .onTapGesture(count: 2, perform: resetZoom)
            .clipped()
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = min(max(lastScale * value, 1), 5)
                if scale == 1 {
                    offset = .zero
                }
            }
            .onEnded { _ in
                lastScale = scale
                if scale == 1 {
                    lastOffset = .zero
                }
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard scale > 1 else { return }
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }

    private func resetZoom() {
        withAnimation(.snappy) {
            scale = 1
            lastScale = 1
            offset = .zero
            lastOffset = .zero
        }
    }
}

#Preview {
    FCUtahTheaterSchedule()
}
