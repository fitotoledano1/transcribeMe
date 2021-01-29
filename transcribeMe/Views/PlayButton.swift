//
//  PlayButton.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/29/21.
//

import SwiftUI

struct PlayButton: View {
    
    @ObservedObject var viewModel = TranscriberViewModel()
    
    var body: some View {
        Button(action: {
            viewModel.synthesizeSpeech()
        }, label: {
            Text("Play")
                .bold()
                .foregroundColor(.white)
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color(.systemGreen))
                .cornerRadius(8)
                .opacity(viewModel.isRecording ? 0.33 : 1) // reducing the opacity of the button to make obvious to the user that it's disabled when recording
        })
        .disabled(viewModel.isRecording) // disabling this button when recording :)
    }
}
