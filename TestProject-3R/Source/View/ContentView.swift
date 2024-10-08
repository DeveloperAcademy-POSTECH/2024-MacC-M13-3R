import SwiftUI
struct ContentView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer() // 상위 뷰에서 SpeechRecognizer 생성
        
    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination: SttView(speechRecognizer: speechRecognizer)){
                    Text("SttView")
                        .font(.title)
                }.padding()
                
                NavigationLink(destination: GptView(speechRecognizer: speechRecognizer)){
                    Text("GptView")
                        .font(.title)
                }.padding()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
