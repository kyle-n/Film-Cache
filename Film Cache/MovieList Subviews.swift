//
//  MovieList Subviews.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import SwiftUI

struct FCFormattedDate: View {
    private let date: Date
    private let displayTime: Bool

    init(_ date: Date, displayTime: Bool = false) {
        self.date = date
        self.displayTime = displayTime
    }

    var body: some View {
        Text(formattedDate)
    }

    private var formattedDate: String {
        guard date.timeIntervalSince1970 != FCMovie.blankDate.timeIntervalSince1970 else { return "" }
        return outputDateFormatter.string(from: date)
    }

    private var outputDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        if displayTime {
            formatter.dateFormat = "E, MMM. d 'at' h:mm a"
        } else {
            formatter.dateFormat = "E, MMM. d"
        }
        return formatter
    }
}

struct FCFormattedRunTime: View {
    private let runTimeMinutes: Int

    init(_ runTimeMinutes: Int) {
        self.runTimeMinutes = runTimeMinutes
    }

    var body: some View {
        Text(formattedRunTime)
    }

    private var formattedRunTime: String {
        let hours = Int(floor(Double(runTimeMinutes) / 60))
        let leftoverMinutes = runTimeMinutes % 60
        return "\(hours)h \(leftoverMinutes)m"
    }
}

#Preview {
    VStack {
        FCFormattedDate(Date(timeIntervalSince1970: 10000))
        FCFormattedDate(Date(timeIntervalSince1970: 10000), displayTime: true)
            .padding(.vertical)
        FCFormattedRunTime(100)
    }
    .padding()
}
