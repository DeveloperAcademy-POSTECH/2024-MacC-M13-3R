//
//  UpdateView.swift
//  TestProject-3R
//
//  Created by 장유진 on 10/7/24.
//

import SwiftUI
import ChatGPT

struct UpdateView: View {
    //    @State private var userInput = ""
    @ObservedObject var speechRecognizer: SpeechRecognizer
    
    var body: some View {
        VStack {
            TextEditor(text: $speechRecognizer.transcript)
                .frame(height: 150)
                .border(Color.gray, width: 1)
                .padding()
        }
        //뷰 시작되자마자 녹음 시작
        .onAppear {
            speechRecognizer.startTranscribing()
            print("Recording")
        }
        .onDisappear {
            speechRecognizer.stopTranscribing()
            print("Not recording")
        }
    }
}

#Preview {
    UpdateView(speechRecognizer: SpeechRecognizer())
}
