import SwiftUI
import ChatGPT

struct GptView: View {
//    @StateObject private var speechRecognizer = SpeechRecognizer()
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @State private var answerText = ""
    var body: some View {
        VStack {
            Text(answerText)
            Button {
                Task {
                    await sendMessage()
                }
            } label: {
                Text("계산 보기 (누르면 -12원) 밑에꺼 눌러서 print로 살펴보세요.")
                    .font(.title)
            }.padding()
            
            Button{
                print("GPT가 인식한 sttText: ", speechRecognizer.sttText)
            } label: {
                Text( "GPT가 인식한 sttText").font(.title)
            }
        }
    }
    
    func sendMessage() async {
        do {
            print("sttText: ", speechRecognizer.sttText)
            let chatGPT = ChatGPT(apiKey: "", defaultModel: .gpt3)
            let answer = try await chatGPT.ask("내가 장을 보러 왔는데 혼잣말을 할거야. 내가 집은 물건들의 목록과 각각의 가격을 띄워주고, 총 가격을 계산해서 보여줘. 다른 문구 없이 목록과 가격 리스트만 뽑아줘. \(speechRecognizer.sttText)")
            print(answer)
            answerText = answer
        } catch {
            print(error)
        }
    }
}

#Preview {
    GptView(speechRecognizer: SpeechRecognizer())
}
