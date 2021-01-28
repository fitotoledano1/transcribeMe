//
//  Constants.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import Foundation

struct Constants {
    
    /// This constant stores the title of the Recording button when the application is not listening to the user. Using a static constant for reusability throughout the application. e.g. If we wanted to add an onboarding flow, but wanted to change the title in both place very quickly, we can use this constant to change it in both places at the same time.
    static let startRecordingText = "Record"
    
    /// This constant stores the title of the Recording button when the application is listening to the user. Using a static constant for reusability throughout the application. e.g. If we wanted to add an onboarding flow, but wanted to change the title in both place very quickly, we can use this constant to change it in both places at the same time.
    static let stopRecordingText = "Stop Recording"
}