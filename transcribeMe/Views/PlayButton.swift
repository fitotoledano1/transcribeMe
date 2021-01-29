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
        })
    }
}
