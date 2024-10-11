import SwiftUI
struct ContentView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
        
    var body: some View {
        NavigationView{
            VStack{
                
                NavigationLink(destination: UpdateView(speechRecognizer: SpeechRecognizer())){
                    Text("UpdateView")
                        .font(.title)
                }.padding()
                
                
            }
            
                        
        }
        
    }
}

#Preview {
    ContentView()
}
