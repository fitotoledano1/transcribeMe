//
//  TranscribedTextView.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/28/21.
//

import SwiftUI

struct TranscribedTextView: View {
    
    @Binding var isRecording: Bool
    @Binding var transcribedText: String
    
    var body: some View {
        Text(isRecording ? "Listening..." : transcribedText) // to make even more clear to the user that we're recording
            .font(.title3)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 400, alignment: .topLeading)
            .cornerRadius(10)
            .border(Color.gray, width: 1)
            .padding()
    }
}
