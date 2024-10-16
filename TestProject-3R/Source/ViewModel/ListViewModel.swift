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
    @Published var nowPlace: String = ""
    
    init(){
        loadShoppingListFromUserDefaults()
    }
    
    // MARK: 데이터를 인코딩하고 UserDefaults에 저장
    func saveShoppingListToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(dateItem) {
            UserDefaults.standard.set(encoded, forKey: "shoppingLists")
        }
//        print("*******************************")
//            for item in dateItem {
//                print("\(item.date): \(item.items)")
//            }
        
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

        if var lastDateItem = dateItem.last {
            lastDateItem.total = total
            if let lastIndex = dateItem.indices.last {
                dateItem[lastIndex] = lastDateItem
            }
        }
        
        return total
    }

    // MARK: 전체 쇼핑 항목에 대한 가격 계산
    func pricing(from items: [ShoppingItem]) {
        for index in shoppingItem.indices {
            shoppingItem[index].price = shoppingItem[index].unitPrice * shoppingItem[index].quantity
        }

        if var lastDateItem = dateItem.last {
            lastDateItem.items = shoppingItem
            lastDateItem.total = shoppingItem.reduce(0) { $0 + $1.price }
            if let lastIndex = dateItem.indices.last {
                dateItem[lastIndex] = lastDateItem
            }
        }
    }

    // MARK: 개별 쇼핑 항목에 대한 가격 계산
    func pricingItem(for item: inout ShoppingItem) {
        item.price = item.unitPrice * item.quantity

        if let index = shoppingItem.firstIndex(where: { $0.id == item.id }) {
            shoppingItem[index] = item

            if var lastDateItem = dateItem.last {
                lastDateItem.items = shoppingItem
                lastDateItem.total = shoppingItem.reduce(0) { $0 + $1.price }
                if let lastIndex = dateItem.indices.last {
                    dateItem[lastIndex] = lastDateItem
                }
            }
        }
    }
}


