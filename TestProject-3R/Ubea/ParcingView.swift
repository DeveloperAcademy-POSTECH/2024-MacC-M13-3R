//import SwiftUI
//
//struct ParcingView: View {
//    
//    @State private var csvFileList: [[String]] = []
//    
//    var body: some View {
//        NavigationView {
//            List(csvFileList, id: \.self) { item in
//                HStack {
//                    Text(item[0]) // 첫 번째 컬럼: 도시 이름
//                    Spacer()
//                    Text(item[1]) // 두 번째 컬럼: 국가 이름
//                    Spacer()
//                    Text(item[2]) // 첫 번째 컬럼: 도시 이름
//                    Spacer()
//                    Text(item[3]) // 두 번째 컬럼: 국가 이름
//                }
//            }
//            .navigationBarTitle("목록 (Test)")
////            .onAppear {
////                // CSV 파일을 로드하여 파싱된 데이터를 State에 저장
////                loadListFromCSV { data in
////                    CsvFileList = data
////                }
////            }
//        }
//    }
//}
//
//#Preview {
//    ParcingView()
//}
