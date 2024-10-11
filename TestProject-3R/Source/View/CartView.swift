import SwiftUI

struct CartView: View {
    @StateObject private var shoppingViewModel = ShoppingViewModel()
    
    @State private var percent: CGFloat = 0.4 //프로그래스바 퍼센트
    
    let size: CGSize
    let fullWidth: CGFloat
    let progressBarWidth: CGFloat
    
    init(size: CGSize) {
        self.size = size
        self.fullWidth = size.width
        self.progressBarWidth = size.width * 0.75
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                HStack(spacing: 0){
                    VStack(alignment: .leading, spacing: 0){
                        Text("이마트 포항이동점")
                            .padding(.bottom, 10)
                        Text("15,500 원")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 5)
                        HStack(spacing: 0){
                            Text("예산까지 ")
                            Text("35,500 원")
                                .foregroundColor(.yellow)
                            Text(" 남았어요!")
                        }.padding(.bottom, 10)
                    }
                    Spacer()
                }.padding(.horizontal)
                
                indicatorText
                ZStack{
                    progressbar
                    indicator
                }
                
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
                
                Button{
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.green)
                            .ignoresSafeArea()
                            .frame(height: 60)
                        VStack{
                            Text("버튼을 누른 채, 카트에 담는")
                            HStack{
                                Text("[상품명, 수량, 가격]").bold()
                                Text("을 말씀해주세요")
                            }
                        }.foregroundColor(.white)
                            .padding(.top)
                    }
                }
                
            }
            .navigationTitle("장바구니")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            print("수정중")
                        }) {
                            Text("수정하기")
                                .foregroundColor(.green)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            MainView()
                        }) {
                            Text("종료")
                                .foregroundColor(.green)
                        }
                    }
                }
        }
    }
    
    private var progressbar: some View{
        let progressBarHeight: CGFloat = 30.0
               
        return ZStack(alignment: .leading) {
            Capsule()
                .frame(width: progressBarWidth, height: progressBarHeight, alignment: .leading)
                .foregroundColor(Color.gray)
            Capsule()
                .frame(width: (progressBarWidth * percent) , height: progressBarHeight-7, alignment: .leading)
                .foregroundColor(Color.yellow)
                .padding(5)
        }
    }
    private var indicator: some View {
        return HStack(spacing: 0) {
            ZStack{
                Circle()
                    .frame(width: 25)
                    .foregroundColor(.white)
                Text(Image(systemName: "cart"))
                    .font(.system(size: 20))
            }.padding(.leading, progressBarWidth * percent)
            Spacer()
        }
    }
    private var indicatorText: some View {

        return HStack(spacing: 0) {
            ZStack{
                Text("필수 리스트부터 구매해볼까요?")
                    .font(.caption2)
                    .background(.gray)
            }.padding(.leading, (progressBarWidth * percent)-50)
            Spacer()
        }
    }
        
}

#Preview {
    CartView(size: CGSize(width: 450, height: 50))
}
