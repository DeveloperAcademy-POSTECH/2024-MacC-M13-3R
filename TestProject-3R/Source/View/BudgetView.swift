import SwiftUI
struct BudgetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    
    @State var sliderValue = 0.0
    @State var showSheet1 = false
    //    @State private var locationDataManager = LocationManager()
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    @State private var cityN: String = ""
    @State  private var countryC: String = ""
    @State private var isCartViewActive = false
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack(spacing: 0){
                    Text("예산 정하기")
                        .font(.RHeadline)
                    Spacer()
                }
                .padding(.top, 36)
                .padding(.bottom, 4)
                Divider()
                    .padding(.bottom, 16)
                HStack{
                    Text("오늘의 장보기 예산을 입력해주세요")
                        .font(.RBody)
                    Spacer()
                }
                .padding(.bottom, 2)
                
                HStack(alignment: .bottom){
                    Text("\(Int(sliderValue)) 원")
                        .font(.RTitle)
                    
                    Button("직접입력") {
                        showSheet1 = true
                    }
                    .font(.RCaption2)
                    .underline()
                    .foregroundColor(.gray)
                    .sheet(isPresented: $showSheet1) {
                        BudgetModalView(showSheet: $showSheet1, sliderValue: $sliderValue)
                            .presentationDetents([.height(300)])
                            .presentationDragIndicator(.visible)
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
                
                Slider(value: $sliderValue, in: 50000 ... 250000, step: 10000)
                    .frame(width: 328)
                    .onChange(of: sliderValue) { NewValue in
                        let impactMed = UIImpactFeedbackGenerator(style: .light)
                        impactMed.impactOccurred()
                        shoppingViewModel.nowBudget = Int(sliderValue)
                    }
                HStack {
                    Text("50,000-")
                    Spacer()
                    Text("250,000+")
                }
                .font(.RCaption1)
                .foregroundColor(.gray)
                .padding(.horizontal)
                
                .padding(.bottom, 54)
                
                
                HStack{
                    Text("장소 입력하기")
                        .font(.RHeadline)
                    Spacer()
                }
                .padding(.bottom, 4)
                Divider()
                    .padding(.bottom, 16)
                HStack{
                    Text("오늘의 장보기 장소를 입력해주세요")
                        .font(.RBody)
                    Spacer()
                }
                .padding(.bottom, 2)
                HStack {
                    TextField("이마트 포항이동점", text: $shoppingViewModel.nowPlace)
                        .font(.RHeadline)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 500)
                }
                .padding(.leading, 135)
                .padding(.bottom, 20)
                
                //                Text("City : \(cityN)")
                //                    .font(.system(size: 28, weight: .bold))
                //                Text("Latitude : \(latitude)")
                //                    .font(.system(size: 28, weight: .bold))
                //                Text("Longitude : \(longitude)")
                //                    .font(.system(size: 28, weight: .bold))
                Image("sample_map")
                
                Spacer()
                
                NavigationLink(destination: CartView(size: CGSize(width: 450, height: 50), shoppingViewModel: shoppingViewModel), isActive: $isCartViewActive) {
                        EmptyView() // 조건에 따라 자동 전환되므로 빈 뷰를 사용
                        }
                            
                        Button(action: {
                                // 로딩 뷰를 표시하고 타이머 시작
                            isLoading = true
                                startLoading()
                        }) {
                    Text("장보기 시작하기")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .font(.RHeadline)
                        .frame(width: 361, height: 52)
                        .background(.rGreen)
                        .cornerRadius(15)
                        .padding(.bottom, 32)
                }
                .navigationTitle("장보기 준비하기")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
                .tint(.green)
                .sheet(isPresented: $isLoading) {
                            LoadingView(isLoading: $isLoading, isCartViewActive: $isCartViewActive)
                                
                        }
            //                .onAppear(){
            //            let yourLatitudeString = String(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")
            //            let yourLongitudeString = String(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")
            //            self.latitude = (Double(yourLatitudeString) ?? 0)
            //            self.longitude =  (Double(yourLongitudeString) ?? 0)
            //            // city and country
            //            let locationInfo = LocationInfo()
            //            locationInfo.getCityLocation(latitude: self.latitude, longitude: self.longitude) { city, country in
            //                if let city = city, let country = country {
            //                    self.cityN = city
            //                    self.countryC = country
            //                    print("City: \(city), Country: \(country)")
            //                } else {
            //                    print("Unable to fetch location information.")
            //                }
            //            }
            //                }
        }
        
        .tint(.green)
        //            .onAppear(){
        //            let yourLatitudeString = String(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")
        //            let yourLongitudeString = String(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")
        //            self.latitude = (Double(yourLatitudeString) ?? 0)
        //            self.longitude =  (Double(yourLongitudeString) ?? 0)
        //            // city and country
        //            let locationInfo = LocationInfo()
        //            locationInfo.getCityLocation(latitude: self.latitude, longitude: self.longitude) { city, country in
        //                if let city = city, let country = country {
        //                    self.cityN = city
        //                    self.countryC = country
        //                    print("City: \(city), Country: \(country)")
        //                } else {
        //                    print("Unable to fetch location information.")
        //                }
        //            }
        //            }
    }
    
    //    private func updateSliderValue() {
    //        if let newDoubleValue = Double(sliderValue) {
    //            DispatchQueue.main.async{
    //
    //                sliderValue = newDoubleValue
    //            }
    //        }
    //    }
    
    private func startLoading() {
            // 로딩을 위한 추가 작업이 필요하면 여기에 추가 가능
        }
}



struct BudgetModalView: View {
    @State private var inputValue = "50000"
    @Binding var showSheet: Bool
    @Binding var sliderValue: Double
    
    var body: some View {
        VStack {
            Spacer()
            Text("오늘의 장보기 예산을 입력해주세요")
                .font(.RBody)
            Spacer()
            Spacer()
            HStack {
                TextField("50000", text: $inputValue)
                    .font(.RMain)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 150)
                    .multilineTextAlignment(.center)
                Text("원")
                    .font(.system(size: 20, weight: .medium))
            }
            Spacer()
            Button{
                if let newValue = Double(inputValue){
                    sliderValue = newValue
                }
                showSheet = false
            } label: {
                Text("입력")
                    .foregroundColor(.white)
                    .font(.RHeadline)
                    .frame(width: 361, height: 52)
                    .background(.rDarkGreen)
                    .cornerRadius(15)
                    .padding(.bottom, 32)
            }
            .padding(.bottom, 32)
        }
        .onAppear {
            inputValue = "\(Int(sliderValue))"
        }
    }
}


func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}

#Preview {
    BudgetView(shoppingViewModel: ShoppingViewModel())
}
