//
//  ErrorHandler.swift
//  Film Cache
//
//  Created by Kyle Nazario on 9/26/25.
//
import AppKit

enum FCError: Int {
    static func display(error: FCError) {
        var description: String
        switch (error) {
        case .couldNotLoadFilmDetails:
            description = "Could not load movie details from The Movie DB"
        }
        let error = NSError(domain: BUNDLE_IDENTIFIER, code: error.rawValue, userInfo: [
            NSLocalizedDescriptionKey: description
        ])
        DispatchQueue.main.async {        
            let alert = NSAlert(error: error)
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
    
    case couldNotLoadFilmDetails
}
