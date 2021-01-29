//
//  AlertContext.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/29/21.
//

import SwiftUI

// Writing here some examples for alerts that could be presented to the user
struct AlertContext {
    // This one is the one I'm using when uploading a blank recording
    static let invalidData = AlertItem(title: "Whoops!",
                                       message: "Make sure you are speaking clearly and close to the microphone.",
                                       dismissButton: .default(Text("Try again"))
    )
    
    // Using this one for audio playback errors
    static let playbackError = AlertItem(title: "Uh-Oh!",
                                             message: "Something went wrong playing audio. Please, try again.",
                                             dismissButton: .default(Text("Try again"))
    )
    
    // leaving here some more alerts I would use - the usual suspects
    static let invalidUrl = AlertItem(title: "Invalid Url",
                                      message: "The URL for this request was invalid. Please, try again.",
                                      dismissButton: .default(Text("Try again"))
    )
    
    static let invalidResponse = AlertItem(title: "Invalid Response",
                                           message: "The response received from the server was invalid. Please, try again.",
                                           dismissButton: .default(Text("Try again"))
    )
    
    static let unableToComplete = AlertItem(title: "Uh-Oh!",
                                             message: "Something wrong happened. Please, try again.",
                                             dismissButton: .default(Text("Try again"))
    )
}
