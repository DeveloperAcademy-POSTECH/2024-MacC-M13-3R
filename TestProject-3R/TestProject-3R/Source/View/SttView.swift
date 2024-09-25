import SwiftUI

struct SttView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State var isTextButton = false
    var body: some View {
        VStack {
            Text("Speech To Text")
                .font(.title)
                .padding()
            
            TextEditor(text: $speechRecognizer.transcript)
            
            if isTextButton {
                Text(speechRecognizer.sttText)
            }
            HStack {
                Button(action: {
                    speechRecognizer.startTranscribing()
                    isTextButton = false
                }) {
                    Text("Start")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    speechRecognizer.stopTranscribing()
                    isTextButton = true
                    print(speechRecognizer.sttText)
                    
                }) {
                    Text("Stop")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            .padding()
        }
        .padding()
    }
}
#Preview {
    SttView()
}
