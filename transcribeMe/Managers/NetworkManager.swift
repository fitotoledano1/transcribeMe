//
//  NetworkManager.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import Foundation
import Alamofire
import Firebase
import FirebaseStorage
import AVKit

/// Structs to send the request to the Google Cloud Platform Speech-to-Text API

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

// MARK: - Network Manager
class NetworkManager {
    
    /// Creating the Singleton
    private init() {}
    static let shared = NetworkManager()
    
    func uploadAudioFile(localPath: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let storage = Firebase.Storage.storage()
        
        // Create a root reference
        let storageRef = storage.reference()
        
        // File located on disk
        let localFile = URL(string: localPath)!
        
        // Create a reference to the file you want to upload - for my billing, I'm making it overwrite the same file 'audioRecording.flac' instead of filling the bucket up with hundreds of megabytes of Audio files.
        let audioRef = storageRef.child("audios/audioRecording.flac")
        
        // Upload the file to the path "audios/audioRecording.flac"
        let _ = audioRef.putFile(from: localFile, metadata: nil) { metadata, error in
//            guard let metadata = metadata else {
//                // Uh-oh, an error occurred!
//                return
//            }
//            // Metadata contains file metadata such as size, content-type.
//            let size = metadata.size
            // You can also access to download URL after upload.
            audioRef.downloadURL { (url, error) in
                
                let url = URL(string: "https://speech.googleapis.com/v1/speech:recognize?key=\(Constants.clientKey)")!
                
                let config = TConfig(encoding: "FLAC", sampleRateHertz: 16000, languageCode: "en-US", enableWordTimeOffsets: false)
                let audio = TAudio(uri: "gs://transcribeme-1611842393052.appspot.com/" + audioRef.fullPath)
                
                let params = TRequest(config: config, audio: audio)
                
                AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
                    .responseDecodable(of: TranscriptionResults.self) { responseDate in
                        switch responseDate.result {
                        case .success(let response):
                            let transcript = response.results[0].alternatives[0].transcript
                            completion(.success(String(transcript)))
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
            }
        }
    }
    
    func synthesizeSpeech(forText text: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let endpoint = "https://texttospeech.googleapis.com/v1/text:synthesize?key=\(Constants.clientKey)"
        let params = [
            "input": ["text": text],
            "voice": [
                "languageCode": "en-GB",
                "name": "en-GB-Standard-A",
                "ssmlGender": "FEMALE"
            ],
            "audioConfig": ["audioEncoding": "MP3"]
        ]

        AF.request(endpoint, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
            .responseJSON { (dataResponse) in
                print(dataResponse)

                switch dataResponse.result {
                case .success(let dictionary):
                    let dictionary = dictionary as! [String: Any]
                    let audioContent = dictionary["audioContent"] as! String

                    let audioData = Data(base64Encoded: audioContent, options: [])
                    if let audData = audioData {
                        completion(.success(audData))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
