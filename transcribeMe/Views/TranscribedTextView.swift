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
        /// This view's Text defaults to a friendly 
        Text(isRecording ? "Listening..." : transcribedText)
            .font(.title3)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 400, alignment: .topLeading)
            .cornerRadius(10)
            .border(Color.gray, width: 1)
            .padding()
    }
}
