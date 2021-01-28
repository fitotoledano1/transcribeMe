//
//  TranscribeViewModel.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import Foundation
import AVKit

final class TranscriberViewModel: ObservableObject {
    
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    
    /// A published variable that controls whether the recorder is on or off.
    @Published var isRecording: Bool = false {
        didSet {
            print("Published var 'isRecording' is now set to:", isRecording)
            print("test")
        }
    }
    
    /// A published variable that will contain the transcribed text received from the Google Cloud Speech-to-text API. Initialized with a user-friendly placeholder that indicates the user how to start the application workflow.
    @Published var transcribedText: String = "Press the record button to start."
    
    func startRecordingSession() {
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default, policy: .default, options: .duckOthers)
            try recordingSession?.setActive(true, options: .notifyOthersOnDeactivation)
            recordingSession?.requestRecordPermission({ [unowned self] allowed in
                DispatchQueue.main.async {
                    switch allowed {
                    case true:
                        // it's allowed to record, start recording
                        print("Recording is allowed.")
                    case false:
                        // show an alert
                        print("Recording is now allowed.")
                        isRecording = false
                    }
                }
            })
        } catch {
            print("There was an error with the Audio Session.")
        }
    }
    
    func startRecording() {
        print("Started recording...")
        startRecordingSession()
    }
    
    func transcribeSpeech() {
        print("Transcribing speech...")
    }
    
    func stopRecording() {
        print("Stopped recording.")
    }
}
