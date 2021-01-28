//
//  RecordButton.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import SwiftUI

struct RecordButton: View {
    
    
    @ObservedObject var viewModel = TranscriberViewModel()
    
    var body: some View {
        Button(action: {
            viewModel.recordButtonTapped()
        }, label: {
            Text(viewModel.isRecording ? Constants.stopRecordingText : Constants.startRecordingText)
                .bold()
                .foregroundColor(.white)
                .frame(width: 300, height: 50, alignment: .center)
                .background(viewModel.isRecording ? Color(.systemRed) : Color(.systemBlue))
                .cornerRadius(8)
                .padding(.bottom)
        })
    }
}
