//
//  FCDate.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/18/25.
//

import SwiftUI

struct FCFormattedDate: View {
    private let date: Date?
    
    init(_ date: Date?) {
        self.date = date
    }
    
    var body: some View {
        Text(formattedDate)
    }
    
    private var formattedDate: String {
        guard let date else { return "" }
        return FCFormattedDate.outputDateFormatter.string(from: date)
    }
    
    private static let outputDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM. d"
        return formatter
    }()
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
            .padding(.bottom)
        FCFormattedRunTime(100)
    }
    .padding()
}
