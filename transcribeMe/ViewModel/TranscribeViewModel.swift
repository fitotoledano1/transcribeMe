//
//  TranscribeViewModel.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import Foundation
import AVKit

final class TranscriberViewModel: NSObject, ObservableObject {
    
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    
    /// A published variable that controls whether the recorder is on or off.
    @Published var isRecording: Bool = false {
        didSet {
            print("Published var 'isRecording' is now set to:", isRecording)
        }
    }
    
    /// A published variable that will contain the transcribed text received from the Google Cloud Speech-to-text API. Initialized with a user-friendly placeholder that indicates the user how to start the application workflow.
    @Published var transcribedText: String = "Press the record button to start."
    
    
    // MARK: - Methods to start the recording workflow
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
        print(audioUrl.absoluteURL)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
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
        return getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
    }
}

// MARK: - Methods at the end of the recording workflow.
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
        case false:
            stopRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error?.localizedDescription ?? "")
    }
    
}

// MARK: - Google Cloud Platform Speech-To-Text methods
extension TranscriberViewModel {
    func transcribeSpeech() {
        print("Transcribing speech...")
    }
}

