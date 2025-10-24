//
//  ErrorHandler.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/26/25.
//
#if os(macOS)
import AppKit
#else
import UIKit
#endif

enum FCError: Int {
    static func display(error: Error, type: FCError) {
        var description: String
        switch type {
        case .couldNotLoadFilmDetails:
            description = "Could not load movie details from The Movie DB"
        case .couldNotLoadFilms:
            description = "Could not load movies"
        }
        let nsError = NSError(domain: BUNDLE_IDENTIFIER, code: type.rawValue, userInfo: [
            NSLocalizedDescriptionKey: description,
            NSLocalizedRecoverySuggestionErrorKey: error.localizedDescription
        ])
        showSystemError(error: nsError)
    }
    
    #if os(macOS)
    private static func showSystemError(error: NSError) {
        DispatchQueue.main.async {
            let alert = NSAlert(error: error)
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
    #else
    private static func showSystemError(error: NSError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            alert.present(alert, animated: true)
        }
    }
    #endif

    case couldNotLoadFilmDetails
    case couldNotLoadFilms
}
