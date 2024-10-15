import SwiftUI


struct BudgetView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    
    @State var sliderValue = 0.0
    //    @State var inputValue = "50000"
    @State var showSheet = false
    @FocusState private var isTextFieldFocused: Bool
    //    @State private var locationDataManager = LocationManager()
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    @State private var cityN:String = ""
    @State  private var countryC:String = ""
    
    
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
                        showSheet = true
                    }
                    .font(.RCaption2)
                    .underline()
                    .foregroundColor(.gray)
                    .sheet(isPresented: $showSheet) {
                        BudgetModalView(showSheet: $showSheet, sliderValue: $sliderValue)
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
                HStack(alignment: .bottom){
                    Text("이마트 포항이동점")
                        .font(.RTitle)
                    Text("직접입력")
                        .font(.RCaption2)
                        .underline()
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.bottom, 20)
                
                //                Text("City : \(cityN)")
                //                    .font(.system(size: 28, weight: .bold))
                //                Text("Latitude : \(latitude)")
                //                    .font(.system(size: 28, weight: .bold))
                //                Text("Longitude : \(longitude)")
                //                    .font(.system(size: 28, weight: .bold))
                Image("sample_map")
                
                Spacer()
                
                NavigationLink(destination: CartView(size: CGSize(width: 450, height: 50), shoppingViewModel: shoppingViewModel)) {
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
            }.padding(.horizontal, 16)
                .tint(.green)
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
                HStack {
                    TextField("50000", text: $inputValue)
                        .font(.RMain)
                    .font(.system(size: 15, weight: .medium))
                Spacer()
                HStack {
                    TextField("50000", text: $inputValue)
                        .font(.system(size: 30, weight: .bold))
                        .keyboardType(.decimalPad)
                        .font(.system(size: 16, weight: .medium))
                    //                    .onSubmit {
                    //                        if let newValue = Double(inputValue){
                    //                            sliderValue = newValue
                    //                        }
                    //                        showSheet = false
                    //                    }
                        .frame(width: 150)
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                    Text("원")
                        .font(.system(size: 20, weight: .medium))
                }
                Spacer()
                Button("입력") {
                    if let newValue = Double(inputValue){
                        sliderValue = newValue
                    }
                    showSheet = false
                }
                .foregroundColor(.white)
                .font(.RHeadline)
                .frame(width: 361, height: 52)
                .background(.rDarkGreen)
                .cornerRadius(15)
                .padding(.bottom, 32)
            }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .padding(.horizontal, 132)
                .padding(.vertical, 12)
                .background(.green)
                .cornerRadius(15)
                .padding(.bottom, 36)
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
