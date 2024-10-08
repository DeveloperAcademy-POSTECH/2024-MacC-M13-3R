import SwiftUI
struct ContentView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer() // 상위 뷰에서 SpeechRecognizer 생성
        
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: UserDefaultsTestView()){
                    Text("UserDefaultsTestView")
                        .font(.title)
                }.padding()
                
                NavigationLink(destination: UpdateView(speechRecognizer: SpeechRecognizer())){
                    Text("UpdateView")
                        .font(.title)
                }.padding()
                
//                NavigationLink(destination: ParcingView()){
//                    Text("ParcingView")
//                        .font(.title)
//                }.padding()
                
                //                NavigationLink(destination: SttView(speechRecognizer: speechRecognizer)){
                //                    Text("SttView")
                //                        .font(.title)
                //                }.padding()
                //
                //                NavigationLink(destination: GptView(speechRecognizer: speechRecognizer)){
                //                    Text("GptView")
                //                        .font(.title)
                //                }.padding()
                
            }
            
                        
        }
        
    }
}

#Preview {
    ContentView()
}
