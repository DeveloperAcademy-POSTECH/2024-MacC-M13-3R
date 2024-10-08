//
//  RestartView.swift
//  gptAPI
//
//  Created by 장유진 on 10/7/24.
//

import SwiftUI
import ChatGPT

//새로고침 바로 누르면 저장되는데 stop이나 restart 누르면 질문이 저장안됨 -> stop 눌러도 gpt 답변 받아올 수 있게
struct UpdateView: View {
    
    let APIKey = Bundle.main.infoDictionary?["APIKey"] as! String
    
//    @State private var userInput = ""
    @State private var answerText = ""
    @State private var isProcessing = false
    @State private var showShareSheet = false
    @State private var showCSVPreview = false
    @State private var csvContent: String?
    @ObservedObject var speechRecognizer: SpeechRecognizer
    
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
            
            Button {
                Task {
                    await sendMessage()
                }
            } label: {
                Text(isProcessing ? "처리중" : "새로고침하여 csv파일 추출")
            }
            .disabled(isProcessing)
            .padding()
            
            if !answerText.isEmpty {
                Text("GPT응답: \n\(answerText)")
                    .padding()
            }
            if let csvContent = csvContent {
                Button("csv 파일 미리보기") {
                    showCSVPreview = true
                }
                .padding()
                .sheet(isPresented: $showCSVPreview) {
                    CSVPreviewView(content: csvContent)
                }
            }
            if let _ = csvContent {
                Button("csv 파일 다운") {
                    showShareSheet = true
                }
                .padding()
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(activityItems: [createCSV()])
                }
            }
        }
        .onAppear {
            speechRecognizer.startTranscribing()
            print("Recording")
        }
        .onDisappear {
            speechRecognizer.stopTranscribing()
            print("Not recording")
        }
    }
    func sendMessage() async {
        isProcessing = true
        do {
            let chatGPT = ChatGPT(apiKey: APIKey, defaultModel: .gpt3)
            let prompt =  """
                        난 지금 마트에 장을 보러왔는데 이제부터 말을 할거야. 내가 카트에 담은 물건들의 각각의 목록, 개수, 가격을 보여주고, 총 가격도 계산해서 csv파일로 만들어줘. csv 형식은 "물건, 수량, 가격, 합계"로 보여줘. 다른 불필요한 말은 하지 않아도 돼.
                        사용자가 입력한 목록: \(speechRecognizer.transcript)
                        """
            let answer = try await chatGPT.ask(prompt)
            //            "내가 뭘 사야되지 아 계란 계란이 어디있지 여깄다 계란 9000원 헐 1000원이나 올랐네 아 아니다 다음에 사야겠다 두부는 한모 2500원 심지어 원플러스 원이네 나이스 요거트도 먹고싶다 3000원 아니다 과자나 사자 초코송이 1000원밖에 안한다 초코송이 하나 하고 콜라도 1500원이네 이건 친구꺼까지 두개 이제 더 필요한거 없겠지 가자"
            print(answer)
            answerText = answer
            csvContent = answer
            
        } catch {
            print(error)
        }
        
        isProcessing = false
    }
    
    func createCSV() -> URL {
        let fileName = "MyCart.csv"
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try csvContent?.write(to: filePath, atomically: true, encoding: .utf8)
            print("csv파일이 생성되었습니다")
            return filePath
        } catch {
            print("csv 파일 생성 중 오류 발생: \(error.localizedDescription)")
            return URL(fileURLWithPath: "")
        }
    }
}

struct CSVPreviewView: View {
    let content: String
    
    var body: some View {
        VStack {
            Text("CSV 내용")
                .font(.headline)
                .padding()
            ScrollView {
                Text(content)
                    .padding()
            }
            .padding()
            
            Button("닫기") {
            }
            .padding()
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    UpdateView(speechRecognizer: SpeechRecognizer())
}
