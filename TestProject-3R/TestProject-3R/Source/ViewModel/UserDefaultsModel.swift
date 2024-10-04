import Foundation

struct ShoppingItem: Codable {
    var name: String
    var quantity: Int
    var price: Double
    var unitPrice: Double
}


class ShoppingUserDefaultsViewModel:ObservableObject {
    @Published var shoppingList: [ShoppingItem] = [
        ShoppingItem(name: "Apples", quantity: 1, price: 1500, unitPrice: 1500),
        ShoppingItem(name: "Bananas", quantity: 1, price: 2000, unitPrice: 2000),
        ShoppingItem(name: "Milk", quantity: 1, price: 3500, unitPrice: 3500)
    ]
    
    // 앱이 시작될 때 UserDefaults에서 데이터를 불러오기
    init() {
        loadShoppingListFromUserDefaults()
    }
    
    // 데이터를 인코딩하고 UserDefaults에 저장
    func saveShppingListToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(shoppingList) {
            UserDefaults.standard.set(encoded, forKey: "shoppingList")
        }
    }
    
    // UserDefaults에서 데이터를 불러오기
    func loadShoppingListFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "shoppingList") {
            if let savedList = try? JSONDecoder().decode([ShoppingItem].self, from: savedData) {
                shoppingList = savedList
                for item in savedList {
                    print("\(item.name): \(item.quantity)개, 가격: \(item.price)원")
                   
                }
            }
        }
    }
    
    func pricing() {
        for index in shoppingList.indices {
            shoppingList[index].price = shoppingList[index].unitPrice * Double(shoppingList[index].quantity)
        }
        saveShppingListToUserDefaults()
        loadShoppingListFromUserDefaults()
    }

}
