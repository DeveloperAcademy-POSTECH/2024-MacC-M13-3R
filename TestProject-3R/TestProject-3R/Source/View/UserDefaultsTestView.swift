import SwiftUI

struct UserDefaultsTestView: View {
    let myUserDefaults = UserDefaults.standard
    @State private var testNum  = UserDefaults.standard.integer(forKey: "testNum")
    @StateObject private var shoppingViewModel = ShoppingUserDefaultsViewModel()
        
    var body: some View {
        VStack{
            Button {
                testNum += 1
                UserDefaults.standard.set(testNum, forKey: "testNum")
                

            } label: {
                Text("testNum is = \(testNum)")
                    .font(.title)
            }
            
            Button {
                shoppingViewModel.shoppingList[0].quantity += 1
                shoppingViewModel.pricing()
                print("--------------\n")
                
            } label: {
                Text("Apple = \(shoppingViewModel.shoppingList[0].quantity)개")
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Button {
                shoppingViewModel.shoppingList[1].quantity += 1
                shoppingViewModel.pricing()
                print("--------------\n")
                
            } label: {
                Text("Bananas = \(shoppingViewModel.shoppingList[1].quantity)개")
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Button {
                shoppingViewModel.shoppingList[2].quantity += 1
                shoppingViewModel.pricing()
                print("--------------\n")
                
            } label: {
                Text("Milk = \(shoppingViewModel.shoppingList[2].quantity)개")
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
