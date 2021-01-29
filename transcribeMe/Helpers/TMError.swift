//
//  TMError.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/29/21.
//

import Foundation

/// Custom transcribeMe Error to identify the cause of potential failures in our Network Calls
enum TMError: String, Error {
    case invalidData = "The data received from the server was invalid."
}
