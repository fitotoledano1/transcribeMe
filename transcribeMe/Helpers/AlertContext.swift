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
                                       alertButton: .default(Text("Try again"))
    )
    
    // Using this one for audio playback errors
    static let playbackError = AlertItem(title: "Uh-Oh!",
                                             message: "Something went wrong playing audio. Please, try again.",
                                             alertButton: .default(Text("Try again"))
    )
    
    // If the user doesn't grant the application access to the microphone, this is the one that shows - and takes the user to settings to grant permissions
    static let requiresMicrophoneAccess = AlertItem(title: "Microphone Access",
                                                    message: "transcribeMe needs to access your microphone to record and transcribe your speech.",
                                                    alertButton: .default(Text("Give Permissions"), action: {
                                                                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                                    })
    )
    
    // leaving here some more alerts I would use - the usual suspects
    static let invalidUrl = AlertItem(title: "Invalid Url",
                                      message: "The URL for this request was invalid. Please, try again.",
                                      alertButton: .default(Text("Try again"))
    )
    
    static let invalidResponse = AlertItem(title: "Invalid Response",
                                           message: "The response received from the server was invalid. Please, try again.",
                                           alertButton: .default(Text("Try again"))
    )
    
    static let unableToComplete = AlertItem(title: "Uh-Oh!",
                                             message: "Something wrong happened. Please, try again.",
                                             alertButton: .default(Text("Try again"))
    )
}
