//
//  Transcription.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import Foundation

struct Transcription: Codable {
    let transcript: String
    let confidence: Double
}

// MARK: - Helper structs for better readability of the code when parsing the response from the Google Cloud Platform Speech-to-Text API.
/// Helper structure that contains the array of results obtained from the Speech-to-Text API in Google Cloud Platform. For easier readablity of the code when parsing the response in the uploadAudio() function.
struct TranscriptionResults: Codable {
    let results: [TrasncriptionResult]
}

/// Helper structure that contains the array of alternative transcriptions obtained from the Speech-to-Text API in Google Cloud Platform. For easier readablity of the code when parsing the response in the uploadAudio() function.
struct TrasncriptionResult: Codable {
    let alternatives: [TranscriptionAlternative]
}

/// Helper structure that contains the transcription, and its precision, obtained from the Speech-to-Text API in Google Cloud Platform. For easier readablity of the code when parsing the response in the uploadAudio() function.
struct TranscriptionAlternative: Codable {
    let transcript: String
    let confidence: Double
}

// MARK: - Helper structs for better readability of the code when sending the request to the Google Cloud Platform Speech-to-Text API
// Transcription Config
struct TConfig: Encodable {
    let encoding: String
    let sampleRateHertz: Int
    let languageCode: String
    let enableWordTimeOffsets: Bool
}

// Transcription Audio
struct TAudio: Encodable {
    let uri: String
}

// Transcription Request
struct TRequest: Encodable {
    let config: TConfig
    let audio: TAudio
}
