//
//  LoadingView.swift
//  transcribeMe
//
//  Created by Fito Toledano on 1/29/21.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var isLoading: Bool
    
    var body: some View {
        if isLoading {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea(.all)
                    .opacity(0.67)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(.systemGray)))
                    .scaleEffect(1.67)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: .constant(false))
    }
}
