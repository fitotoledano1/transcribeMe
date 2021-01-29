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

class NetworkManager {
    
    /// Creating the Singleton
    private init() {}
    static let shared = NetworkManager()
    
    func uploadAudioFile(localPath: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let storage = Firebase.Storage.storage()
        
        // Create a root reference
        let storageRef = storage.reference()
        
        // File located on disk using the local passed at the function callsite (in TranscriberViewModel)
        let localFile = URL(string: localPath)!
        
        // Create a reference to the file you want to upload - for my billing, I'm making it overwrite the same file 'audioRecording.flac' instead of filling the bucket up with hundreds of megabytes of Audio files.
        let audioRef = storageRef.child("audios/audioRecording.flac")
        
        // Upload the file to the path "audios/audioRecording.flac"
        audioRef.putFile(from: localFile, metadata: nil) { metadata, error in
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
