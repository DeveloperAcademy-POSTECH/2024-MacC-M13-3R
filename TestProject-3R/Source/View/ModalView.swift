import SwiftUI

struct ModalView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text(shoppingViewModel.formatDate(from: shoppingViewModel.selectedDateItem?.date ?? shoppingViewModel.dateItem[0].date))
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
                Text(shoppingViewModel.selectedDateItem?.place ?? "장소아무거나")
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
                        if let items = shoppingViewModel.selectedDateItem?.items {
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
                                        .frame(width: 118, alignment: .trailing)
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
                        Text("카드")
                            .font(.RCallout)
                        Spacer()
                        Text("\(shoppingViewModel.selectedDateItem?.total ?? 10000)")
                            .font(.RCallout)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 36)
    }
}

#Preview {
    ModalView(shoppingViewModel: ShoppingViewModel())
}
