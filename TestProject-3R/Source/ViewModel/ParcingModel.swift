
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
