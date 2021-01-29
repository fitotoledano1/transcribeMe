//
//  AlertContext.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/29/21.
//

import SwiftUI

struct AlertContext {
    static let invalidUrl = AlertItem(title: "Invalid Url",
                                      message: "The URL for this request was invalid. Please, try again.",
                                      dismissButton: .default(Text("Try again"))
    )
    
    static let invalidResponse = AlertItem(title: "Invalid Response",
                                           message: "The response received from the server was invalid. Please, try again.",
                                           dismissButton: .default(Text("Try again"))
    )
    
    static let invalidData = AlertItem(title: "Try again",
                                       message: "Make sure you are speaking clearly and close to the microphone.",
                                       dismissButton: .default(Text("Alright"))
    )
    
    static let unableToComplete = AlertItem(title: "Uh-Oh!",
                                             message: "Something wrong happened. Please, try again.",
                                             dismissButton: .default(Text("Try again"))
    )
}
