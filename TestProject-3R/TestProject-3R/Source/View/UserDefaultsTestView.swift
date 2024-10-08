import SwiftUI

struct UserDefaultsTestView: View {
    let myUserDefaults = UserDefaults.standard
    @StateObject private var shoppingViewModel = ShoppingUserDefaultsViewModel()
        
    var body: some View {
        VStack{
            Button {
                shoppingViewModel.addShoppingList()
            } label: {
                Text("add")
            }
            
            
            Button {
                shoppingViewModel.shoppingItems[0].quantity += 1
                shoppingViewModel.pricing()
                print("--------------\n")
                
            } label: {
                Text("Apple = \(shoppingViewModel.shoppingItems[0].quantity)개")
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Button {
                shoppingViewModel.shoppingItems[1].quantity += 1
                shoppingViewModel.pricing()
                print("--------------\n")
                
            } label: {
                Text("Bananas = \(shoppingViewModel.shoppingItems[1].quantity)개")
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Button {
                shoppingViewModel.shoppingItems[2].quantity += 1
                shoppingViewModel.pricing()
                print("--------------\n")
                
            } label: {
                Text("Milk = \(shoppingViewModel.shoppingItems[2].quantity)개")
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Text("총 합계: \(shoppingViewModel.totalPricing())")

        }.onAppear {
            shoppingViewModel.loadShoppingListFromUserDefaults()  // View가 로드될 때 데이터 불러오기
        }
    }
}

#Preview {
    UserDefaultsTestView()
}
