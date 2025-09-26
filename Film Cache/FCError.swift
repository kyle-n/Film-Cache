//
//  ErrorHandler.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/26/25.
//
import AppKit

enum FCError: Int {
    static func display(error: Error, type: FCError) {
        var description: String
        switch (type) {
        case .couldNotLoadFilmDetails:
            description = "Could not load movie details from The Movie DB"
        case .couldNotLoadFilms:
            description = "Could not load movies"
        }
        let nsError = NSError(domain: BUNDLE_IDENTIFIER, code: type.rawValue, userInfo: [
            NSLocalizedDescriptionKey: description,
            NSLocalizedRecoverySuggestionErrorKey: error.localizedDescription
        ])
        DispatchQueue.main.async {
            let alert = NSAlert(error: nsError)
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
    
    case couldNotLoadFilmDetails
    case couldNotLoadFilms
}
