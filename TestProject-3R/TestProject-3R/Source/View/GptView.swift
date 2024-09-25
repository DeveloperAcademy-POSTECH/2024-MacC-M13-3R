import SwiftUI
import ChatGPT

struct GptView: View {
    @State private var answerText = ""
    var body: some View {
        VStack {
            Text(answerText)
            Button {
                Task {
                    await sendMessage()
                }
            } label: {
                Text("계산 보기")
            }
        }
    }
    func sendMessage() async {
        do {
            let chatGPT = ChatGPT(apiKey: "", defaultModel: .gpt3)
            let answer = try await chatGPT.ask("내가 장을 보러 왔는데 혼잣말을 할거야. 내가 집은 물건들의 목록과 각각의 가격을 띄워주고, 총 가격을 계산해서 보여줘. 다른 문구 없이 목록과 가격 리스트만 뽑아줘. 내가 뭘 사야되지 아 계란 계란이 어디있지 여깄다 계란 9000원 헐 1000원이나 올랐네 아 아니다 다음에 사야겠다 두부는 한모 2500원 심지어 원플러스 원이네 나이스 요거트도 먹고싶다 3000원 아니다 과자나 사자 초코송이 1000원밖에 안한다 초코송이 하나 하고 콜라도 1500원이네 이건 친구꺼까지 두개 이제 더 필요한거 없겠지 가자")
            print(answer)
            answerText = answer
        } catch {
            print(error)
        }
        /// try
        /// do - catch
        /// async-awiat
        /// Task
    }
}

#Preview {
    GptView()
}
