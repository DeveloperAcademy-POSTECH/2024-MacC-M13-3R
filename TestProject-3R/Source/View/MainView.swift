//
//  MainView.swift
//  TestProject-3R
//
//  Created by 임이지 on 10/8/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack{
            HStack{
                Text("Cart")
                    .font(.RLargeTitle)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 33)
            .padding(.bottom, 8)
            VStack {
                VStack (alignment: .leading) {
                    Text("2024.10.06")
                        .font(.RHeadline)
                        .padding(.top, 32)
                        .padding(.bottom, 20)
                    HStack(alignment: .bottom) {
                        Text("오늘까지")
                            .font(.RBody)
                        Text("32,000 원")
                            .font(.RCallout)
                        Text("아꼈어요!")
                            .font(.RBody)
                    }
                    HStack(alignment: .bottom) {
                        Text("목표 금액")
                            .font(.RBody)
                        Text("50,000 원")
                            .font(.RCallout)
                            .foregroundColor(.rDarkGreen)
                        Text("까지 아껴볼까요?")
                            .font(.RBody)
                    }
                    .padding(.bottom, 20)
                    
                    Rectangle()
                        .frame(height: 25)
                        .cornerRadius(12)
                        .foregroundColor(.green)
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 24)
                .background(.rWhite)
                .cornerRadius(8)
                .padding(.bottom, 16)
                NavigationLink(destination: BudgetView()) {
                    Text("장보러 가기")
                        .font(.RHeadline)
                        .foregroundColor(.rWhite)
                        .padding(.horizontal, 139)
                        .padding(.vertical, 15)
                        .background(.rGreen)
                        .cornerRadius(15)
                        .padding(.bottom, 32)
                }
                    
                HStack {
                    Text("나의 영수증")
                        .font(.RHeadline)
                    Spacer()
                }
                .padding(.horizontal, 8)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<7) { index in
                            VStack(alignment: .leading, spacing: -1){
                                HStack(alignment:.center
                                ){
                                    Text("34,500 원")
                                        .font(.RCallout)
                                        .padding(.trailing, 35)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.rDarkGray)
                                        .font(.system(size: 10))
                                }
                                .padding(.top, 12)
                                .padding(.bottom, 10)
                                .padding(.horizontal, 8)
                                .background(.rWhite)
                                .clipShape(
                                    RoundedCorner(radius: 9, corners: [.topLeft, .topRight])
                                )
                                VStack(alignment: .leading) {
                                    Text("2024.10.04")
                                        .font(.RCaption1)
                                    Text("이마트 포항이동점")
                                        .font(.RCaption2)
                                }
                                .padding(.vertical, 8)
                                .padding(.leading, 8)
                                .padding(.trailing, 64)
                                .background(.rLightGreen)
                                .clipShape(
                                    RoundedCorner(radius: 9, corners: [.bottomLeft, .bottomRight])
                                )
                            }
                            .shadow(color: Color("RDarkGray").opacity(0.25), radius: 3, x: 0, y: 0)
                            .overlay(
                            RoundedRectangle(cornerRadius: 9)
                            .inset(by: -0.4)
                            .stroke(Color("RGrayGreen"), lineWidth: 0.8)
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 16)
                    .padding(.bottom, 36)
                }
                
                
                HStack {
                    VStack(alignment:.leading) {
                        Text("추후\n업데이트 예정")
                            .font(.RTitle)
                            .padding(.leading, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 52)
                            .fixedSize(horizontal: false, vertical: true)
                        Image(systemName: "chevron.right")
                            .fontWeight(.medium)
                            .font(.system(size: 24))
                            .foregroundStyle(.rDarkGreen)
                            .padding(.leading, 124)
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                    .background(.rWhite)
                    .cornerRadius(16)
                    .shadow(color: Color("RGrayGreen"), radius: 9.75, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(Color("RGray"), lineWidth: 1)
                        
                    )
                    .padding(.trailing, 21)
                    VStack(alignment:.leading) {
                        Text("추후\n업데이트 예정")
                            .font(.RTitle)
                            .padding(.leading, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 52)
                            .fixedSize(horizontal: false, vertical: true)
                        Image(systemName: "chevron.right")
                            .fontWeight(.medium)
                            .font(.system(size: 24))
                            .foregroundStyle(.rDarkGreen)
                            .padding(.leading, 124)
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                    .background(.rWhite)
                    .cornerRadius(16)
                    .shadow(color: Color("RGrayGreen"), radius: 9.75, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(Color("RGray"), lineWidth: 1)
                        
                    )
                }
                .padding(.horizontal, 8)
                
                Spacer()
            }
            .padding(.vertical,32)
            .padding(.horizontal, 16)
            .background(Color("RSuperLightGray"))
            
        }
        .tint(Color("RDarkGreen"))
    }
}

#Preview {
    MainView()
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
