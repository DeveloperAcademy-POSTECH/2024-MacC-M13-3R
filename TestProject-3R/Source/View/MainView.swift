import SwiftUI

struct MainView: View {
    @StateObject private var shoppingViewModel = ShoppingViewModel()
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationStack{
            HStack{
                Text("짱바구니")
                    .font(.RLargeTitle)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 33)
            .padding(.bottom, 8)
            VStack {
                // 오늘 금액
                VStack (alignment: .leading) {
                    Text(shoppingViewModel.formatDate(from: Date()))
                        .font(.RHeadline)
                        .padding(.top, 32)
                        .padding(.bottom, 20)
                    HStack(alignment: .bottom) {
                        Text("오늘까지")
                            .font(.RBody)
                        Text("32,000 원")
                            .font(.RCallout)
                        Text("아꼈어요!")
                            .font(.RBody)
                    }
                    HStack(alignment: .bottom) {
                        Text("목표 금액")
                            .font(.RBody)
                        Text("50,000 원")
                            .font(.RCallout)
                            .foregroundColor(.rDarkGreen)
                        Text("까지 아껴볼까요?")
                            .font(.RBody)
                    }
                    .padding(.bottom, 20)
                    
                    ProgressViewModel()
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 24)
                .background(.rWhite)
                .cornerRadius(8)
                .padding(.bottom, 16)
                
                //버튼
                NavigationLink(destination: BudgetView(shoppingViewModel: shoppingViewModel)) {
                    Text("장보러 가기")
                        .font(.RHeadline)
                        .foregroundColor(.rWhite)
                        .padding(.horizontal, 139)
                        .padding(.vertical, 15)
                        .background(.rGreen)
                        .cornerRadius(15)
                }
                .padding(.bottom, 32)
                
                //영수증
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("나의 영수증")
                            .font(.RHeadline)
                        Spacer()
                        Text("더보기")
                            .font(.RCaption1)
                            .foregroundColor(.rDarkGray)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.rDarkGray)
                            .font(.system(size: 10))
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(shoppingViewModel.dateItem.suffix(7).reversed(), id: \.self) { item in
                                Button {
                                    shoppingViewModel.selectedDateItem = item
                                    showSheet.toggle()
                                } label: {
                                    VStack(alignment: .leading, spacing: -1){
                                        HStack(){
                                            Text("\(item.total) 원")
                                                .font(.RCallout)
                                                .frame(width: 101, height: 18, alignment: .topLeading)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.rDarkGray)
                                                .font(.system(size: 10))
                                            
                                        }
                                        .frame(width: 110, height: 18)
                                        .padding(.top, 12)
                                        .padding(.bottom, 10)
                                        .padding(.horizontal, 8)
                                        .background(.rWhite)
                                        .clipShape(
                                            RoundedCorner(radius: 9, corners: [.topLeft, .topRight])
                                        )
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(
                                                shoppingViewModel.formatDate(from: item.date))
                                            .font(.RCaption1)
                                            .frame(width: 110, height: 11, alignment: .topLeading)
                                            Text(item.place)
                                                .font(.RCaption2)
                                                .frame(width: 110, height: 11, alignment: .topLeading)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 8)
                                        .background(.rLightGreen)
                                        .clipShape(
                                            RoundedCorner(radius: 9, corners: [.bottomLeft, .bottomRight])
                                        )
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9)
                                            .inset(by: -0.4)
                                            .stroke(Color("RGrayGreen"), lineWidth: 0.8)
                                            .shadow(color: Color("RDarkGray").opacity(0.25), radius: 3, x: 0, y: 0)
                                    )
                                    .padding(.trailing, 8)
                                    
                                }
                                .padding(.leading, 2)
                                .buttonStyle(PlainButtonStyle())
                                .sheet(isPresented: $showSheet) {
                                    ModalView(shoppingViewModel: shoppingViewModel)
                                        .presentationDetents([.medium])
                                        .presentationDragIndicator(.visible)
                                }
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 36)
                    }
                    
                    
                    
                    HStack {
                        VStack(alignment:.leading) {
                            Text("유저 인터뷰\n후 추가 예정")
                                .font(.RTitle)
                                .padding(.leading, 20)
                                .padding(.top, 20)
                                .padding(.bottom, 52)
                                .fixedSize(horizontal: false, vertical: true)
                            Image(systemName: "chevron.right")
                                .fontWeight(.medium)
                                .font(.system(size: 24))
                                .foregroundStyle(.rDarkGreen)
                                .padding(.leading, 124)
                                .padding(.trailing, 20)
                                .padding(.bottom, 20)
                        }
                        .background(.rWhite)
                        .cornerRadius(16)
                        .shadow(color: Color("RGrayGreen"), radius: 9.75, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .inset(by: 0.5)
                                .stroke(Color("RGray"), lineWidth: 1)
                            
                        )
                        .padding(.trailing, 21)
                        VStack(alignment:.leading) {
                            Text("유저 인터뷰\n후 추가 예정")
                                .font(.RTitle)
                                .padding(.leading, 20)
                                .padding(.top, 20)
                                .padding(.bottom, 52)
                                .fixedSize(horizontal: false, vertical: true)
                            Image(systemName: "chevron.right")
                                .fontWeight(.medium)
                                .font(.system(size: 24))
                                .foregroundStyle(.rDarkGreen)
                                .padding(.leading, 124)
                                .padding(.trailing, 20)
                                .padding(.bottom, 20)
                        }
                        .background(.rWhite)
                        .cornerRadius(16)
                        .shadow(color: Color("RGrayGreen"), radius: 9.75, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .inset(by: 0.5)
                                .stroke(Color("RGray"), lineWidth: 1)
                            
                        )
                    }
                }
                .padding(.horizontal, 8)
                
                Spacer()
            }
            .padding(.top,32)
            .padding(.bottom, 32)
            .padding(.horizontal, 16)
            .background(Color("RSuperLightGray"))
            .onAppear{
                shoppingViewModel.loadShoppingListFromUserDefaults()
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .tint(Color("RDarkGreen"))
    }
}


#Preview {
    MainView()
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
