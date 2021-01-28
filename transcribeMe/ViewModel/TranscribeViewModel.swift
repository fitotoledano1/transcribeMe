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
    
    func recordButtonTapped() {
        print("Record button tapped.")

        isRecording ? stopRecording() : startRecordingSession()
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
                        // it's allowed to record, start recording
                        print("Recording is allowed.")
                    case false:
                        // show an alert
                        print("Recording is now allowed.")
                        stopRecording()
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
            //audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            print("There was an error starting to record.")
        }
        
        //audioRecorder?.record()
        
    }
    
    func transcribeSpeech() {
        print("Transcribing speech...")
    }
    
    func stopRecording() {
        print("Stopped recording.")
        
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }

    class func getAudioRecordingURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
    }
    
}

extension TranscriberViewModel: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print(flag)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error?.localizedDescription ?? "")
    }
}
