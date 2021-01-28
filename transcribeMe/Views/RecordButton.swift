//
//  RecordButton.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import SwiftUI

struct RecordButton: View {
    
    @Binding var isRecording: Bool
    
    @ObservedObject var viewModel = TranscriberViewModel()
    
    var body: some View {
        Button(action: {
            isRecording ? viewModel.stopRecording() : viewModel.startRecording()
            isRecording.toggle()
        }, label: {
            Text(isRecording ? Constants.stopRecordingText : Constants.startRecordingText)
                .bold()
                .foregroundColor(.white)
                .frame(width: 300, height: 50, alignment: .center)
                .background(isRecording ? Color(.systemRed) : Color(.systemBlue))
                .cornerRadius(8)
                .padding(.bottom)
        })
    }
}
