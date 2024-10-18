import SwiftUI
import ChatGPT

struct CartView: View {
    @Environment(\.dismiss) var dismiss
    let APIKey = Bundle.main.infoDictionary?["APIKey"] as! String
    
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    @State private var price: Int = 0      //현재까지 담은 가격
    
    @State private var percent: CGFloat = 0.4 //프로그래스바 퍼센트
    @State private var percentText: String = "이제 아껴볼까요?"
    @State private var percentColor: Color = Color.rYellow
    
    @State private var isSort: Bool = false    //정렬버튼
    @State private var refreshText: String = "새로고침"
    @State private var isFirstRefresh: Bool = false // 새로고침버튼 최초 눌렀는지 확인
    @State private var updateTime: Int = 8     //새로고침시간
    @State private var isRecoding: Bool = true //음성인식버튼
    
    @State private var answerText = ""
    @State private var isProcessing = false
    @State private var csvContent: String?
    @State private var csvFilePath: URL?
    
    @State private var text = ""
    
    @State private var isFinish = false  // MainView로 이동을 관리하는 상태 변수
    @State private var isAlert = false
    let size: CGSize
    let fullWidth: CGFloat
    let progressBarWidth: CGFloat
    
    init(size: CGSize, shoppingViewModel: ShoppingViewModel) {
        self.size = size
        self.fullWidth = size.width
        self.progressBarWidth = size.width * 0.77
        self.shoppingViewModel = shoppingViewModel
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                HStack(spacing: 0){
                    VStack(alignment: .leading, spacing: 0){
                        Text(shoppingViewModel.nowPlace)
                            .font(.RHeadline)
                            .padding(.top, 36)
                        Text("\(price) 원")
                            .font(.RMain)
                            .padding(.top, 4)
                        HStack(spacing: 0){
                            Text("예산까지 ")
                                .font(.RBody)
                            Text("\((shoppingViewModel.nowBudget ?? 50000)-price) 원")
                                .font(.RCallout)
                                .foregroundColor(.rOrange)
                            Text(" 남았어요!")
                                .font(.RBody)
                        }.padding(.top, 4)
                    }
                    Spacer()
                }.padding(.horizontal)
                ZStack(alignment: .leading){
                    progressbar
                        .padding(.top, 24)
                    VStack(alignment: .center){
//                        indicatorText
                        indicator
                    }
                    .padding(.leading, progressBarWidth * percent-10)
                }.padding(.top, 13)
                
                HStack(spacing: 0){
                    Spacer()
                    Text("\(shoppingViewModel.nowBudget ?? 50000)")
                        .font(.RCaption1)
                        .foregroundColor(.rDarkGray)
                        .padding(.top,4)
                        .padding(.horizontal)
                }
                .padding(.bottom)
                ZStack{
                    Color.rSuperLightGray
                        .frame(height: 36)
                    HStack(spacing: 0){
                        Button{
                            isSort.toggle()
                        } label: {
                            HStack(spacing: 3){
                                Text(isSort ? "정렬눌림": "정렬")
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12)
                            }
                            .font(.RCaption1)
                            .foregroundColor(.rDarkGray)
                        }
                        
                        Spacer()
                        
                        Button{
                            if isRecoding {
                                refreshText = "\(updateTime)분 전"
                                speechRecognizer.stopTranscribing()
                                Task {
                                    await sendMessage()
                                    speechRecognizer.startTranscribing()
                                }
                            }
                            else {
                                refreshText = "새로고침 할 내용이 없습니다."
                            }
                        } label: {
                            HStack(spacing: 0){
                                Text(refreshText)
                                Image(systemName: "arrow.circlepath")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12)
                            }
                            .font(.RCaption1)
                            .foregroundColor(.rDarkGray)
                        }
                    }.padding(.horizontal)
                }
                    
                editListView
                Button{
                    isRecoding.toggle()
                    
                    if isRecoding {
                        speechRecognizer.startTranscribing()
                    }
                    else {
                        speechRecognizer.stopTranscribing()
                        Task {
                            await sendMessage()
                        }
                    }
                } label: {
                    voiceRecordingButton
                }
                
                
            }
            .navigationTitle("장바구니")
            .onAppear{
                updatePercent()
                
                speechRecognizer.startTranscribing()
                shoppingViewModel.loadShoppingListFromUserDefaults()
            }
            .onDisappear {
                speechRecognizer.stopTranscribing()
            }
            .onTapGesture {
                updatePercent()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAlert = true
                    }) {
                        Text("종료")
                            .font(.RBody)
                            .foregroundColor(.rDarkGreen)
                        
                    }
                }
            }
            .alert(isPresented: $isAlert){
                Alert(title: Text("장보기를 종료하시겠습니까?"),
                      message: Text("다시는 이 화면으로 돌아오지 못합니다."),
                      primaryButton: .destructive(Text("종료하기"), action: {
                    isFinish=true
                    Task {
                        await sendMessage()
                        if let lastDateItem = shoppingViewModel.dateItem.last, !lastDateItem.items.isEmpty {
                            DispatchQueue.main.async {
                                shoppingViewModel.saveShoppingListToUserDefaults()
                                isSort = false
                                isRecoding = false
                            }
                        } else {
                            print("내용이 없음")
                        }
                    }
                }),
                      secondaryButton: .cancel(Text("돌아가기")))
            }
            NavigationLink(destination: ReceiptView(shoppingViewModel: shoppingViewModel), isActive: $isFinish) {
                EmptyView()
            }

        }.navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private var progressbar: some View{
        let progressBarHeight: CGFloat = 24.0
        
        ZStack(alignment: .leading) {
            Capsule()
                .frame(width: progressBarWidth+10, height: progressBarHeight, alignment: .leading)
                .foregroundColor(.rLightGreen)
            Capsule()
                .frame(width: progressBarWidth * percent , height: progressBarHeight-6, alignment: .leading)
                .foregroundColor(percentColor)
                .padding(.horizontal,5)
        }
    }
    
    @ViewBuilder
    private var indicator: some View {
        ZStack{
            Circle()
                .frame(width: 18)
                .foregroundColor(.white)
                .shadow(radius: 1)
            Text(Image(systemName: "cart"))
                .font(.system(size: 15))
        }
    }
    
    @ViewBuilder
    private var indicatorText: some View {
        ZStack{
            Image("polygon")
                .resizable()
                .scaledToFit()
                .frame(width: 89)
            Text(percentText)
                .font(.RCaption1)
                .padding(.bottom,4)
        }
    }
    
    @ViewBuilder
    private var voiceRecordingButton: some View{
        ZStack{
            if isRecoding{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.rDarkGreen)
                    .ignoresSafeArea()
                    .frame(height: 60)
                VStack{
                    HStack{
                        LottieView(jsonName: "voiceRecordingLottie1", play: true)
                            .frame(width: 50, height: 50)
                        Text("음성인식중입니다")
                            .font(.RHeadline)
                    }
                    HStack{
                        Text("장보기를 잠시 중지하려면 버튼을 눌러주세요.")
                            .font(.RCaption1)
                    }
                }.foregroundColor(.white)
                    .padding(.top)
            }
            else{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.rGreen)
                    .ignoresSafeArea()
                    .frame(height: 60)
                VStack{
                    HStack{
                        Image("mike")
                        Text("장보기 재개하기")
                            .font(.RHeadline)
                    }
                    HStack{
                        Text("버튼을 누르면 다시 음성인식이 시작됩니다.")
                            .font(.RCaption1)
                    }
                }.foregroundColor(.white)
                    .padding(.top)
            }
        }
    }
    
    @ViewBuilder
    private var editListView: some View{
        List {
            ForEach($shoppingViewModel.shoppingItem, id: \.id){ $item in
                VStack(alignment:.leading, spacing: 0){
                    ZStack{
                        HStack (spacing: 0){
                            TextField("", text: $item.name)
                                .font(.RCallout)
                                .frame(width: 190)
                                .onChange(of: text) { newValue in
                                    if newValue.count > 10 {
                                        text = String(newValue.prefix(13))
                                    }
                                }
                            Spacer()
                            Text("\(item.unitPrice) 원")
                                .font(.RBody)
                        }
                        Text("\(item.quantity)개")
                            .font(.RCaption2)
                            .foregroundColor(.rDarkGray)
                            .padding(.leading, 80)
                        
                        
                        HStack(spacing: 13){
                            Button {
                                item.quantity -= 1
                                shoppingViewModel.pricingItem(for: &item)
                                price = shoppingViewModel.totalPricing(from: shoppingViewModel.shoppingItem)
                            } label: {
                                Image(systemName: "minus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 7)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button{
                                item.quantity += 1
                                shoppingViewModel.pricingItem(for: &item)
                                price = shoppingViewModel.totalPricing(from: shoppingViewModel.shoppingItem)
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 7)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .background(Image("capsule"))
                        .padding(.leading, 150)
                    }
                    Text(shoppingViewModel.formatDateToHHMM(from: item.time))
                        .font(.RCaption2)
                        .foregroundColor(.rDarkGray)
                }
                .padding(.vertical,2)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        if let index = shoppingViewModel.shoppingItem.firstIndex(where: { $0.id == item.id }) {
                            removeList(at: IndexSet(integer: index))
                        }
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    .tint(.red)
                }
            }
        }
        .listStyle(.plain)
        
    }
    func removeList(at offsets: IndexSet) {
        shoppingViewModel.shoppingItem.remove(atOffsets: offsets)
        let totalPrice = shoppingViewModel.totalPricing(from: shoppingViewModel.shoppingItem)
        price = totalPrice
        updatePercent()
    }
    func updatePercent() {
        let budget = CGFloat(shoppingViewModel.nowBudget ?? 50000)
        percent = (CGFloat(price) / budget)
        
        if percent<=0.4 {
            percentColor = Color.rYellow
        }
        else if 0.4<percent && percent<=0.8 {
            percentColor = Color.rOrange
        }
        else {
            percentColor = Color.rRed
        }
    }
    
    func sendMessage() async {
        isProcessing = true
        var isValidFormat = false
        var answer = ""
        
        while !isValidFormat {
            do {
                let chatGPT = ChatGPT(apiKey: APIKey, defaultModel: .gpt3)
                let prompt = """
                            난 지금 마트에 장을 보러왔는데, 카트에 담은 물건들의 목록을 입력할거야. 물건 이름, 개수, 가격을 CSV 형식으로 만들어줘. CSV 형식은 반드시 다음과 같은 순서로 구성돼야 해:
                            1. "물건", "수량", "가격" 헤더가 포함돼야 해.
                            2. 각 항목은 쉼표(,)로 구분되어야 해.
                            3. 띄어쓰기 없이 값을 기록해줘.
                            4. 모든 가격과 수량은 숫자로만 표현하고, 불필요한 말은 하지 않아도 돼.
                            5. 입력: 뒤에 아무말도 없으면 앞서 지시한 1번의 헤더만 csv형식으로 줘.
                            입력: \(speechRecognizer.transcript)
                            """
                answer = try await chatGPT.ask(prompt)
                print ("answer: ", answer, "\n")
                // 응답의 형식을 검사
                if validateCSVFormat(answer) {
                    isValidFormat = true
                } else {
                    print("응답 형식이 맞지 않습니다. 다시 요청합니다.")
                }
                
            }catch {
                print("GPT API 호출 중 오류 발생: \(error.localizedDescription)")
            }
            
        }
        csvContent = answer
        
        if let content = csvContent {
            csvFilePath = createCSV(from: content)
            if let path = csvFilePath {
                print("CSV 파일이 생성되었습니다")
                loadListFromCSV(at: path) { parsedData in
                    
                    print("파싱된 데이터: \(parsedData)")
                    
                    let newItems = parsedData.compactMap { item in
                            if(item[0] != "물건") {
                                let name = item[0]
                                let quantity = Int(item[1]) ?? 0
                                let unitPrice = Int(item[2]) ?? 0
                                let price = quantity * unitPrice
                                let time = Date()
                                
                                return ShoppingItem(name: name, quantity: quantity, unitPrice: unitPrice, price: price, time: time)
                            } else {
                                return nil
                            }
                        }
                    
                    shoppingViewModel.shoppingItem.append(contentsOf: newItems)
                    
                    // MARK: total 계산
                    let totalPrice = shoppingViewModel.totalPricing(from: shoppingViewModel.shoppingItem)
                    
                    if !isFirstRefresh{
                        let dateItem = DateItem(
                            date: shoppingViewModel.removeSeconds(from: Date()),
                            items: shoppingViewModel.shoppingItem,
                            total: totalPrice,
                            place: shoppingViewModel.nowPlace)
                        
                        shoppingViewModel.dateItem.append(dateItem)
                        isFirstRefresh = true
                    }
                    else {
                        if var lastDateItem = shoppingViewModel.dateItem.last {
                            for newItem in shoppingViewModel.shoppingItem {
                                lastDateItem.items.append(newItem)
                                }
                            if let lastIndex = shoppingViewModel.dateItem.indices.last {
                                shoppingViewModel.dateItem[lastIndex] = lastDateItem
                            }
                        }
                    }
                    price = totalPrice
                    updatePercent()
                    print("shoppingViewModel.dateItem.last:",shoppingViewModel.dateItem.last)
                }
            }
        }
        print("******************************************************")
        speechRecognizer.sttText = ""
        speechRecognizer.transcript = ""
        isProcessing = false
    }
}
