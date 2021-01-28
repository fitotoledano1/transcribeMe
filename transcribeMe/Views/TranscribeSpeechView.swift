//
//  ContentView.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import SwiftUI
import AVFoundation

struct TranscribeSpeechView: View {
    
    @StateObject var viewModel = TranscriberViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                TranscribedTextView(isRecording: $viewModel.isRecording,
                                    transcribedText: $viewModel.transcribedText)
                Spacer()
                RecordButton(isRecording: $viewModel.isRecording)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TranscribeSpeechView()
    }
}
