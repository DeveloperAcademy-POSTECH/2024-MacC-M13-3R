import SwiftUI
import ChatGPT

struct UpdateView: View {
    let APIKey = Bundle.main.infoDictionary?["APIKey"] as! String
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @StateObject private var shoppingViewModel = ShoppingViewModel()
    
    @State private var answerText = ""
    @State private var isProcessing = false
    @State private var csvContent: String?
    @State private var csvFilePath: URL?
    
    var body: some View {
        VStack {
            TextEditor(text: $speechRecognizer.transcript)
                .frame(height: 150)
                .border(Color.gray, width: 1)
                .padding()
            
            HStack {
                Button(action: {
                    speechRecognizer.stopTranscribing()
                    print(speechRecognizer.sttText)
                    
                        Task {
                            await sendMessage()
                        }
                    
                }) {
                    Text("Stop")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button(action: {
                    speechRecognizer.startTranscribing()
                }) {
                    Text("ReStart")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            HStack{
                Button{
                    speechRecognizer.stopTranscribing()
                    print(speechRecognizer.sttText)
                    
                } label: {
                    Text("녹음만 중지")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button{
                    shoppingViewModel.loadShoppingListFromUserDefaults()
                } label: {
                    Text("UserDefault 불러오기")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            Button {
                Task {
                    await sendMessage()
                }
            } label: {
                Text(isProcessing ? "처리중" : "새로고침하여 csv파일 추출")
            }
            .disabled(isProcessing)
            .padding()
            
            List(shoppingViewModel.shoppingItem, id: \.self) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("\(item.quantity)")
                    Spacer()
                    Text("\(item.unitPrice)")
                    Spacer()
                    Text("\(item.price)")
                }
            }
            
            if !answerText.isEmpty {
                Text("GPT응답: \n\(answerText)")
                    .padding()
            }
        }
        .onAppear {
            speechRecognizer.startTranscribing()
            print("Recording")
            shoppingViewModel.loadShoppingListFromUserDefaults()
        }
        .onDisappear {
            shoppingViewModel.saveShoppingListToUserDefaults()
            speechRecognizer.stopTranscribing()
            print("Not recording")
        }
    }
    
    
    
    func sendMessage() async {
        isProcessing = true
        do {
            let chatGPT = ChatGPT(apiKey: APIKey, defaultModel: .gpt3)
            let prompt =  """
                        난 지금 마트에 장을 보러왔는데 이제부터 말을 할거야. 내가 카트에 담은 물건들의 각각의 목록, 개수, 가격을 보여주고, 총 가격도 계산해서 csv파일로 만들어줘.  가격들은 숫자로 써줘. 내가 아무말도 안했다면 '초콜릿 1000원짜리 5개'를 기본 입력해 csv파일 만들어줘. csv 형식은 "물건, 수량, 가격, 합계"로 보여줘. csv파일에 띄어쓰기는 무조건 삭제해서 올려줘. 파싱할거야. 다른 불필요한 말은 하지 않아도 돼.
                        사용자가 입력한 목록: \(speechRecognizer.transcript)
                        """
            let answer = try await chatGPT.ask(prompt)
            print(answer)
            answerText = answer
            csvContent = answer
            
            if let content = csvContent {
                csvFilePath = createCSV(from: content)
                if let path = csvFilePath {
                    print("CSV 파일이 생성되었습니다: \(path)")
                    
                    loadListFromCSV(at: path) { parsedData in
                        print("파싱된 데이터: \(parsedData)")
                        
                        shoppingViewModel.shoppingItem = parsedData.map{ item in
                            let name = item[0]
                            let quantity = Int(item[1]) ?? 0
                            let unitPrice = Int(item[2]) ?? 0
                            let price = Int(item[3]) ?? 0
                            return ShoppingItem(name: name, quantity: quantity, unitPrice: unitPrice, price: price)
                        }
                        let totalPrice = shoppingViewModel.shoppingItem.reduce(0) { $0 + $1.price }
                        let dateItem = DateItem(date: shoppingViewModel.removeSeconds(from: Date()), items: shoppingViewModel.shoppingItem, total: totalPrice, place: "장소")
                        shoppingViewModel.dateItem.append(dateItem)
                        shoppingViewModel.saveShoppingListToUserDefaults()
                    }
                }
            }
        } catch {
            print(error)
        }
        
        isProcessing = false
    }
}
