//
//  TranscribeViewModel.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import Foundation
import AVKit
import AVFoundation

final class TranscriberViewModel: NSObject, ObservableObject {
    
    /// A published variable that controls whether the recorder is on or off.
    @Published var isRecording: Bool = false {
        didSet {
            print("Published var 'isRecording' is now set to:", isRecording)
        }
    }
    
    /// A published variable that will contain the transcribed text received from the Google Cloud Speech-to-text API. Initialized with a user-friendly placeholder that indicates the user how to start the application workflow.
    @Published var transcribedText: String = "Press the record button to start."
    
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    /// Route that will contain the Audio URL
    private var publicAudioUrl = ""
    
}

// MARK: - Methods to start the recording workflow
extension TranscriberViewModel {
    func recordButtonTapped() {
        print("Record button tapped.")
        
        isRecording ? stopRecording(success: true) : startRecordingSession()
        isRecording.toggle()
    }
    
    func startRecordingSession() {
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default, policy: .default, options: .duckOthers)
            try recordingSession?.setActive(true, options: .notifyOthersOnDeactivation)
            recordingSession?.requestRecordPermission({ [unowned self] allowed in
                DispatchQueue.main.async {
                    switch allowed {
                    case true:
                        print("Recording granted transcribeMe permission to access this iPhone's microphone.")
                        print("Recording session session started successfully.")
                        startRecording()
                    case false:
                        // show an alert
                        print("User didn't grant transcribeMe permissions to access the Microphone.")
                        stopRecording(success: false)
                    }
                }
            })
        } catch {
            print("There was an error with the Audio Session.")
        }
    }
    
    
    
    func startRecording() {
        print("Started recording...")
        
        let audioUrl = TranscriberViewModel.getAudioRecordingURL()
        publicAudioUrl = audioUrl.absoluteString
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatFLAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioUrl, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            print("There was an error starting to record.")
        }
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    class func getAudioRecordingURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("audioRecording.flac")
    }
    
}

extension TranscriberViewModel: AVAudioRecorderDelegate {
    
    func stopRecording(success: Bool) {
        print("Stopped recording.")
        
        audioRecorder?.stop()
        audioRecorder = nil
        
        print("Ending recording session...")
        recordingSession = nil
        
        switch success {
        case true:
            print("Audio was saved successfully.")
        case false:
            print("Recording stopped with an error.")
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        switch flag {
        case true:
            stopRecording(success: true)
            uploadAudioFile()
        case false:
            stopRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error?.localizedDescription ?? "")
    }
}

// MARK: - Handling network calls to the Google Cloud Platform
extension TranscriberViewModel {
    func uploadAudioFile() {
        print("Uploading audio file to background...")
        NetworkManager.shared.uploadAudioFile(localPath: publicAudioUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                print(result)
                self.transcribedText = result
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func synthesizeSpeech() {
        NetworkManager.shared.synthesizeSpeech(forText: transcribedText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.playAudio(audioData: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Playing synthesized speech

extension TranscriberViewModel {
    
    func playAudio(audioData: Data) {

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("output.mp3")
        do {
            try audioData.write(to: url, options: .atomicWrite)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)

                guard let player = audioPlayer else {
                    return
                }
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error)
            }
        } catch {
            
        }
    }
}

