import SwiftUI

// Progress bar
struct ProgressBar: View {
    let percent: CGFloat
    let progressBarWidth: CGFloat
    let percentColor: Color

    var body: some View {
        let progressBarHeight: CGFloat = 24.0
        ZStack(alignment: .leading) {
            Capsule()
                .frame(width: progressBarWidth+10, height: progressBarHeight, alignment: .leading)
                .foregroundColor(.rLightGreen)
            Capsule()
                .frame(width: progressBarWidth * percent , height: progressBarHeight-6, alignment: .leading)
                .foregroundColor(percentColor)
                .padding(.horizontal, 5)
        }
    }
}

//struct progressbar: View{
//    let progressBarHeight: CGFloat = 24.0
//    var percent: CGFloat = 0.4 //프로그래스바 퍼센트
//    var percentText: String = "이제 아껴볼까요?"
//    var percentColor: Color = Color.rYellow
//    
//    let size: CGSize
//    let fullWidth: CGFloat
//    let progressBarWidth: CGFloat
//    
//    init(size: CGSize) {
//        self.size = size
//        self.fullWidth = size.width
//        self.progressBarWidth = size.width * 0.77
//    }
//    var body: some View{
//        ZStack(alignment: .leading) {
//            Capsule()
//                .frame(width: progressBarWidth+10, height: progressBarHeight, alignment: .leading)
//                .foregroundColor(.rLightGreen)
//            Capsule()
//                .frame(width: progressBarWidth * percent , height: progressBarHeight-6, alignment: .leading)
//                .foregroundColor(percentColor)
//                .padding(.horizontal,5)
//        }
//    }
//}



// Indicator for cart
struct Indicator: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 18)
                .foregroundColor(.white)
                .shadow(radius: 1)
            Text(Image(systemName: "cart"))
                .font(.system(size: 15))
        }
    }
}

// Edit List View
struct EditListView: View {
    @Binding var shoppingItems: [ShoppingItem]
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @Binding var price: Int
    
    var body: some View {
        List {
            ForEach($shoppingItems, id: \.id) { $item in
                VStack(alignment:.leading, spacing: 0) {
                    HStack(spacing: 0) {
                        TextField("", text: $item.name)
                            .font(.RCallout)
                            .frame(width: 190)
                        Spacer()
                        Text("\(item.unitPrice) 원")
                            .font(.RBody)
                    }
                    Text("\(item.quantity)개")
                        .font(.RCaption2)
                        .foregroundColor(.rDarkGray)
                        .padding(.leading, 80)
                    
                    HStack(spacing: 13) {
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
                        
                        Button {
                            item.quantity += 1
                            shoppingViewModel.pricingItem(for: &item)
                            price = shoppingViewModel.totalPricing(from: shoppingViewModel.shoppingItem)
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 7)
                        }
                    }
                    .padding(.leading, 150)
                }
                .padding(.vertical, 2)
            }
            .onDelete(perform: removeList)
        }
        .listStyle(.plain)
    }
    
    func removeList(at offsets: IndexSet) {
        shoppingViewModel.shoppingItem.remove(atOffsets: offsets)
    }
}

// Regular List View
struct RegularListView: View {
    @Binding var shoppingItems: [ShoppingItem]

    var body: some View {
        List {
            ForEach(shoppingItems, id: \.self) { item in
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
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
                .padding(.vertical, 2)
            }
        }
        .listStyle(.plain)
    }
}
