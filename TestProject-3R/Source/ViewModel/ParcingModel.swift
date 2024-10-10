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
