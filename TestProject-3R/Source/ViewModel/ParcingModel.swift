
import Foundation

// MARK: CSV 파일을 로드하여 파싱하는 함수
func loadListFromCSV(at filePath: URL, completion: @escaping ([[String]]) -> Void) {
    parseCSVAt(url: filePath, completion: completion)
}

func parseCSVAt(url: URL, completion: @escaping ([[String]]) -> Void) {
    do {
        let data = try Data(contentsOf: url)
        if let dataEncoded = String(data: data, encoding: .utf8) {
            let dataArr = dataEncoded
                .components(separatedBy: "\n")
                .map { $0.components(separatedBy: ",") }
            
            completion(dataArr)
        }
    } catch {
        print("Error reading CSV file")
    }
}

// MARK: CSV파일을 만드는 함수
func createCSV(from content: String) -> URL? {
    let fileName = "TestCart.csv"
    let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
    do {
        try content.write(to: filePath, atomically: true, encoding: .utf8)
        print("CSV 파일이 생성되었습니다: \(filePath)")
        return filePath
    } catch {
        print("CSV 파일 생성 중 오류 발생: \(error.localizedDescription)")
        return nil
    }
}

//---------------------------------------------------------------------------------
// MARK: UserDefaults 데이터모델

struct DateItem: Codable {
    var date: Date
    var items: [ShoppingItem]
    var total: Int //총 금액
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
    
    
    init(){
        loadShoppingListFromUserDefaults()
        
        if shoppingItem.isEmpty {
            shoppingItem = [
                ShoppingItem(name: "일이삼사오육칠팔구십일이삼", quantity: 1, unitPrice: 1000, price: 1000),
                ShoppingItem(name: "테스트2", quantity: 2, unitPrice: 5000, price: 10000),
                ShoppingItem(name: "테스트3", quantity: 3, unitPrice: 10000, price: 30000),
                ShoppingItem(name: "테스트4", quantity: 4, unitPrice: 1500, price: 6000),
                ShoppingItem(name: "테스트5", quantity: 5, unitPrice: 2000, price: 10000),
                ShoppingItem(name: "테스트6", quantity: 6, unitPrice: 2500, price: 15000),
                ShoppingItem(name: "테스트7", quantity: 7, unitPrice: 3000, price: 21000),
                ShoppingItem(name: "테스트8", quantity: 8, unitPrice: 3500, price: 28000),
                ShoppingItem(name: "테스트9", quantity: 9, unitPrice: 4000, price: 36000),
                ShoppingItem(name: "테스트10", quantity: 10, unitPrice: 4500, price: 45000),
                ShoppingItem(name: "테스트11", quantity: 11, unitPrice: 5000, price: 55000),
                ShoppingItem(name: "테스트12", quantity: 12, unitPrice: 5500, price: 66000)
            ]

            saveShoppingListToUserDefaults()
        }
    }
    
    // MARK: 데이터를 인코딩하고 UserDefaults에 저장
    func saveShoppingListToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(dateItem) {
            UserDefaults.standard.set(encoded, forKey: "shoppingLists")
        }
    }
    
    // MARK: UserDefaults에서 데이터를 불러오기
    func loadShoppingListFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "shoppingLists") {
            if let saveLists = try? JSONDecoder().decode([DateItem].self, from: savedData){
                dateItem = saveLists
                
//                print("---------------------------------------------------------")
                for date in dateItem {
                    print("*************************************")
                    print("dateItem: : ", date.date)
                    for item in date.items {
                        print("\(item.name): \(item.quantity)개 단가:\(item.unitPrice)원 합계:\(item.price)")
                    }
                }
            }
        }
    }

    // MARK: 현재 날짜에서 초만 삭제 (초를 0으로 설정)
    func removeSeconds(from date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.second = 0
        return calendar.date(from: components) ?? date
    }
}
