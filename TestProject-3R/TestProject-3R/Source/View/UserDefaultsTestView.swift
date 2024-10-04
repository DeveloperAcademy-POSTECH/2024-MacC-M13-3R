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

        }.onAppear {
            shoppingViewModel.loadShoppingListFromUserDefaults()  // View가 로드될 때 데이터 불러오기
        }
    }
}

#Preview {
    UserDefaultsTestView()
}
