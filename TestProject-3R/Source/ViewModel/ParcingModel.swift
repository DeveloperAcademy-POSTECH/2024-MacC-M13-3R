import Foundation

// CSV 파일을 로드하여 파싱하는 함수
func loadLocationsFromCSV(completion: @escaping ([[String]]) -> Void) {
    if let path = Bundle.main.path(forResource: "MyCart", ofType: "csv") {
        parseCSVAt(url: URL(fileURLWithPath: path), completion: completion)
    }
}


func parseCSVAt(url: URL, completion: @escaping ([[String]]) -> Void) {
    do {
        let data = try Data(contentsOf: url)
        if let dataEncoded = String(data: data, encoding: .utf8) {
            let dataArr = dataEncoded
                .components(separatedBy: "\n")
                .map { $0.components(separatedBy: ",") }
            
            // 파싱한 데이터를 completion 핸들러를 통해 반환
            completion(dataArr)
        }
    } catch {
        print("Error reading CSV file")
    }
}
