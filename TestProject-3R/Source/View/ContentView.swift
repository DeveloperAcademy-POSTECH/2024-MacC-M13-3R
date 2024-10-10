import SwiftUI
struct ContentView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
        
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
                
                
            }
            
                        
        }
        
    }
}

#Preview {
    ContentView()
}
