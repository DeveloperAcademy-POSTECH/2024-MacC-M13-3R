import Foundation



// MARK: UserDefaults 데이터모델

struct DateItem: Codable, Hashable {
    var date: Date
    var items: [ShoppingItem]
    var total: Int //총 금액
    var place: String
}

struct ShoppingItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var quantity: Int
    var unitPrice: Int //단가
    var price: Int //수량*단가
}

class ShoppingViewModel:ObservableObject {
    @Published var dateItem: [DateItem] = []
    @Published var shoppingItem: [ShoppingItem] = []
    @Published var selectedDateItem: DateItem?
    
    
    @Published var nowBudget: Int? // 예산
    @Published var nowPlace: String = "장소 안정함"
    
    init(){
        loadShoppingListFromUserDefaults()
        
//        if shoppingItem.isEmpty {
//            shoppingItem = [
//                ShoppingItem(name: "일이삼사오육칠팔구십일이삼", quantity: 1, unitPrice: 1000, price: 1000),
//                ShoppingItem(name: "테스트2", quantity: 2, unitPrice: 5000, price: 10000),
//                ShoppingItem(name: "테스트3", quantity: 3, unitPrice: 10000, price: 30000),
//                ShoppingItem(name: "테스트4", quantity: 4, unitPrice: 1500, price: 6000),
//                ShoppingItem(name: "테스트5", quantity: 5, unitPrice: 2000, price: 10000),
//                ShoppingItem(name: "테스트6", quantity: 6, unitPrice: 2500, price: 15000),
//                ShoppingItem(name: "테스트7", quantity: 7, unitPrice: 3000, price: 21000),
//                ShoppingItem(name: "테스트8", quantity: 8, unitPrice: 3500, price: 28000),
//                ShoppingItem(name: "테스트9", quantity: 9, unitPrice: 4000, price: 36000),
//                ShoppingItem(name: "테스트10", quantity: 10, unitPrice: 4500, price: 45000),
//                ShoppingItem(name: "테스트11", quantity: 11, unitPrice: 5000, price: 55000),
//                ShoppingItem(name: "테스트12", quantity: 12, unitPrice: 5500, price: 66000)
//            ]
//
//            saveShoppingListToUserDefaults()
//        }
        if dateItem.isEmpty {
            dateItem = [
                DateItem(date: Date(), items: shoppingItem, total: 50000, place: "이마트 포항이동점"),
                DateItem(date: Date(), items: shoppingItem, total: 80000, place: "홈플러스 포항점")
            ]

            saveShoppingListToUserDefaults()
        }
    }
    
    // MARK: 데이터를 인코딩하고 UserDefaults에 저장
    func saveShoppingListToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(dateItem) {
            UserDefaults.standard.set(encoded, forKey: "shoppingLists")
        }
            for item in dateItem {
                print("\(item.date): \(item.items)")
            }
        print("save 됨")
    }
    
    // MARK: UserDefaults에서 데이터를 불러오기
    func loadShoppingListFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "shoppingLists") {
            if let saveLists = try? JSONDecoder().decode([DateItem].self, from: savedData){
                dateItem = saveLists
            }
        }
        print("load 됨")
    }

    // MARK: 현재 날짜에서 초만 삭제 (초를 0으로 설정)
    func removeSeconds(from date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.second = 0
        return calendar.date(from: components) ?? date
    }
    // MARK: 현재 날짜 출력
    func formatDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    // MARK: 총 금액 계산
    func totalPricing(from items: [ShoppingItem]) -> Int {
        var total = 0
        for index in items.indices {
            total += items[index].price
        }
        saveShoppingListToUserDefaults()
        return total
    }
    // MARK: 종류별 단가에 따라 가격 계산
    func pricing(from items: [ShoppingItem]) -> [ShoppingItem] {
        
        var updatedItems = items
        for index in updatedItems.indices {
            updatedItems[index].price = updatedItems[index].unitPrice * updatedItems[index].quantity
        }
        saveShoppingListToUserDefaults()
        return updatedItems
    }
    // MARK: 종류별 단가에 따라 가격 계산
    func pricingItem(for item: inout ShoppingItem) {
        item.price = item.unitPrice * item.quantity
        saveShoppingListToUserDefaults()
        loadShoppingListFromUserDefaults()
    }


}


