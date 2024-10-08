import Foundation

struct ShoppingItem: Codable {
    var name: String
    var quantity: Int
    var price: Double //수량*단가
    var unitPrice: Double //단가
}

struct ShoppingDateItem: Codable {
    var date: Date
    var items: [ShoppingItem]
}

class ShoppingUserDefaultsViewModel:ObservableObject {
    @Published var shoppingLists: [ShoppingDateItem] = []
    @Published var shoppingItems: [ShoppingItem] = []
    
    // 앱이 시작될 때 UserDefaults에서 데이터를 불러오기
    init() {
        loadShoppingListFromUserDefaults()
        if shoppingItems.isEmpty {
            shoppingItems = [
                ShoppingItem(name: "Apples", quantity: 1, price: 1500, unitPrice: 1500),
                ShoppingItem(name: "Bananas", quantity: 1, price: 2000, unitPrice: 2000),
                ShoppingItem(name: "Milk", quantity: 1, price: 3500, unitPrice: 3500)
            ]
            saveShoppingListToUserDefaults()
        }
    }
    
    func addShoppingList() {
        let currentDate = removeSeconds(from: Date())
        let newShoppingList = ShoppingDateItem(date: currentDate, items: shoppingItems) // 오늘 날짜로 리스트 추가
        shoppingLists.append(newShoppingList)
        saveShoppingListToUserDefaults()
        loadShoppingListFromUserDefaults()
        
        
        print("shoppingItems: \(shoppingItems)")
        for item in shoppingLists.indices {
            print("shoppingLists: \(shoppingLists[item])")
            print("-------------------------")
        }
    }

    func removeSeconds(from date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.second = 0 // 초를 0으로 설정
        return calendar.date(from: components) ?? date
    }

    
    // MARK: 데이터를 인코딩하고 UserDefaults에 저장
    func saveShoppingListToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(shoppingLists) {
            UserDefaults.standard.set(encoded, forKey: "shoppingLists")
        }
    }
    
    // MARK: UserDefaults에서 데이터를 불러오기
    func loadShoppingListFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "shoppingLists") {
            if let saveLists = try? JSONDecoder().decode([ShoppingDateItem].self, from: savedData){
                shoppingLists = saveLists
                for item in shoppingItems {
                    print("\(item.name): \(item.quantity)개, 가격: \(item.price)원")
                }
            }
        }
    }
    
    // MARK: 종류별 단가에 따라 가격 계산
    func pricing() {
        for index in shoppingItems.indices {
            shoppingItems[index].price = shoppingItems[index].unitPrice * Double(shoppingItems[index].quantity)
        }
        saveShoppingListToUserDefaults()
        loadShoppingListFromUserDefaults()
    }
    
    // MARK: 총 금액 계산
    func totalPricing() -> Double {
        var total = 0.0
        
        for index in shoppingItems.indices {
           total += shoppingItems[index].price
        }
        return total
    }

}
