import SwiftUI

struct CartView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    
    @State private var isEdit: Bool = true  //수정버튼
    
    @State private var price: Int = 50000      //현재까지 담은 가격
    
    @State private var percent: CGFloat = 0.4 //프로그래스바 퍼센트
    @State private var percentText: String = "이제 아껴볼까요?"
    @State private var percentColor: Color = Color.rYellow
    
    @State private var isSort: Bool = false    //정렬버튼
    @State private var isRefresh: Bool = false //새로고침버튼
    @State private var updateTime: Int = 8     //새로고침시간
    @State private var isRecoding: Bool = true //음성인식버튼
    
    
    @State private var text = ""
    
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
                            isRefresh.toggle()
                        } label: {
                            HStack(spacing: 0){
                                Text(isRefresh ? "새로고침 눌림": "\(updateTime)분 전  ")
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
                if isEdit {
                    editListView
                }
                else {
                    listView
                }
                
                Button{
                    isRecoding.toggle()
                } label: {
                    voiceRecodingButton
                    
                }
                
            }
            .navigationTitle("장바구니")
            .onAppear{
                updatePercent()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isEdit.toggle()
                    }) {
                        Text(isEdit ? "수정완료": "수정하기")
                            .font(.RBody)
                            .foregroundColor(.rDarkGreen)
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        MainView()
                    }) {
                        Text("종료")
                            .font(.RBody)
                            .foregroundColor(.rDarkGreen)
                        
                    }
                }
            }
        }
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
    private var voiceRecodingButton: some View{
        ZStack{
            if isRecoding{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.rDarkGreen)
                    .ignoresSafeArea()
                    .frame(height: 60)
                VStack{
                    HStack{
                        Image("voiceRecordingLottie")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 39)
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
    private var listView: some View{
        List {
            ForEach(shoppingViewModel.shoppingItem, id: \.self){ item in
                VStack(alignment:.leading, spacing: 0){
                    ZStack{
                        HStack (spacing: 0){
                            Text(item.name)
                                .font(.RCallout)
                            
                            Spacer()
                            Text("\(item.unitPrice) 원")
                                .font(.RBody)
                        }
                        Text("\(item.quantity)개")
                            .font(.RCaption2)
                            .foregroundColor(.rDarkGray)
                            .padding(.leading, 80)
                    }
                    
                    Text("10:08")
                        .font(.RCaption2)
                        .foregroundColor(.rDarkGray)
                }
                .padding(.vertical,2)
            }
        }
        
        .listStyle(.plain)
        
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
                            } label: {
                                Image(systemName: "minus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 7)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button{
                                item.quantity += 1
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
                    
                    Text("10:08")
                        .font(.RCaption2)
                        .foregroundColor(.rDarkGray)
                }
                .padding(.vertical,2)
            }
            .onDelete(perform: removeList)
        }
        .listStyle(.plain)
        
    }
    func removeList(at offsets: IndexSet) {
        shoppingViewModel.shoppingItem.remove(atOffsets: offsets)
    }
    func updatePercent() {
        let budget = CGFloat(shoppingViewModel.nowBudget ?? 50000)
        percent = (CGFloat(price) / budget)
        
        if percent<=0.33 {
            percentColor = Color.rYellow
        }
        else if 0.33<percent && percent<=0.66 {
            percentColor = Color.rOrange
        }
        else {
            percentColor = Color.rRed
        }
        print("percent= ", percent)
        print("progressBarWidth= ", progressBarWidth)
        print("(progressBarWidth * percent)= ",(progressBarWidth * percent))
        print("progressBarWidth * percent-10 =", progressBarWidth * percent-10 )
    }
}

#Preview {
    CartView(size: CGSize(width: 450, height: 50), shoppingViewModel: ShoppingViewModel())
}
