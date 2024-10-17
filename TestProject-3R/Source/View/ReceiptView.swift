import SwiftUI


struct ReceiptView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @State private var isMainViewActive = false
    
    var body: some View {
        NavigationStack{
            VStack (alignment: .leading) {
                HStack {
                    Text(shoppingViewModel.formatDate(from: shoppingViewModel.dateItem.last?.date ?? Date()))
                        .font(.RTitle)
                    Spacer()
                }
                .padding(.bottom, 4)
                HStack {
                    Text("영수증")
                        .font(.RHeadline)
                    Spacer()
                }
                .padding(.bottom,8)
                Divider()
                    .foregroundColor(.rGray)
                    .padding(.bottom,8)
                
                HStack {
                    Text(shoppingViewModel.dateItem.last?.place ?? "장소")
                        .font(.RCallout)
                    Spacer()
                }
                .padding(.bottom, 12)
                ScrollView {
                    VStack(alignment:.center) {
                        VStack(alignment: .center) {
                            HStack {
                                Text("품목")
                                    .font(.RCaption1)
                                    .frame(width: 118, alignment: .leading)
                                Text("수량")
                                    .font(.RCaption1)
                                    .frame(width: 24, alignment: .trailing)
                                Text("단가")
                                    .font(.RCaption1)
                                    .frame(width: 67, alignment: .trailing)
                                Text("합계")
                                    .font(.RCaption1)
                                    .frame(width: 57, alignment: .trailing)
                            }
                            .padding(.bottom, 20)
                            if let items = shoppingViewModel.dateItem.last?.items {
                                LazyVGrid(columns: [
                                    GridItem(.fixed(118)),
                                    GridItem(.fixed(24)),
                                    GridItem(.fixed(67)),
                                    GridItem(.fixed(57))
                                ]) {
                                    ForEach(items) { item in
                                        Text(item.name)
                                            .font(.RCaption1)
                                            .foregroundColor(.rDarkGray)
                                            .frame(width: 118, alignment: .leading)
                                            .padding(.bottom, 8)
                                        Text("\(item.quantity)")
                                            .font(.RCaption1)
                                            .foregroundColor(.rDarkGray)
                                            .frame(width: 24, alignment: .trailing)
                                            .padding(.bottom, 8)
                                        Text("\(item.unitPrice) 원")
                                            .font(.RCaption1)
                                            .foregroundColor(.rDarkGray)
                                            .frame(width: 67, alignment: .trailing)
                                            .padding(.bottom, 8)
                                        Text("\(item.price) 원")
                                            .font(.RCaption1)
                                            .foregroundColor(.rDarkGray)
                                            .frame(width: 57, alignment: .trailing)
                                            .padding(.bottom, 8)
                                    }
                                }
                            }
                            
                        }
                        .padding(32)
                        .background(Color("RLightGreen"))
                        .cornerRadius(4)
                        .padding(.bottom, 12)
                        
                        HStack {
                            Text("총계")
                                .font(.RCallout)
                            Spacer()
                            Text("\(shoppingViewModel.dateItem.last?.total ?? 10000)")
                                .font(.RCallout)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 36)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isMainViewActive = true
                    }) {
                        Image(systemName: "xmark")
                            .font(.RBody)
                            .foregroundColor(.rDarkGray)
                    }
                }
            }
            
            NavigationLink(destination: MainView(), isActive: $isMainViewActive) {
                EmptyView()
            }

        }.navigationBarBackButtonHidden()
       
    }
}

#Preview {
    ReceiptView(shoppingViewModel: ShoppingViewModel())
}
