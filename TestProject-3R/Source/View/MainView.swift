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
                    .fontWeight(.black)
                    .font(.system(size: 28))
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 47)
            .padding(.bottom, 14)
            VStack {
                VStack (alignment: .leading) {
                    Text("2024.10.06")
                        .fontWeight(.regular)
                        .font(.system(size: 16))
                        .padding(.top, 28)
                        .padding(.bottom, 14)
                    Text("오늘까지 32000원 아꼈어요!")
                        .fontWeight(.regular)
                        .font(.system(size: 18))
                    Text("목표 금액 50000원까지 달려볼까요?")
                        .fontWeight(.regular)
                        .font(.system(size: 18))
                        .padding(.bottom, 24)
                    Rectangle()
                        .frame(height: 25)
                        .cornerRadius(12)
                        .foregroundColor(.green)
                        .padding(.bottom, 28)
                }
                .padding(.horizontal, 16)
                .background(.white)
                .cornerRadius(8)
                .padding(.bottom, 18)
                NavigationLink(destination: BudgetView()) {
                    Text("장보러 가기")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.horizontal, 132)
                        .padding(.vertical, 12)
                        .background(.green)
                        .cornerRadius(15)
                        .padding(.bottom, 24)
                }
                    
                HStack {
                    Text("나의 영수증")
                        .fontWeight(.semibold)
                        .font(.system(size: 16))
                    Spacer()
                }
                .padding(.bottom, 12)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<5) { index in
                            VStack(alignment: .leading){
                                Text("2024.10.04")
                                    .fontWeight(.regular)
                                    .font(.system(size: 8))
                                    .padding(.bottom, 4)
                                Text("34,500원")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 12))
                            }
                            .padding(.vertical, 16)
                            .padding(.leading, 16)
                            .padding(.trailing, 44)
                            .background(.white)
                            .cornerRadius(9)
                            .shadow(color: Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.25), radius: 3, x: 4, y: 4)
                            .padding(.trailing, 8)
                        }
                    }
                    .padding(.bottom, 36)
                    
                }
                
                
                HStack {
                    VStack(alignment:.leading) {
                        Text("나의 영수증\n보러가기")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .padding(.horizontal, 18)
                            .padding(.top, 18)
                            .padding(.bottom, 44)
                        Image(systemName: "chevron.right")
                            .fontWeight(.medium)
                            .font(.system(size: 24))
                            .foregroundStyle(.green)
                            .padding(.leading, 110)
                            .padding(.trailing, 24)
                            .padding(.bottom, 18)
                    }
                    .background(.white)
                    .cornerRadius(16)
                    .shadow(color: Color(red: 0.77, green: 0.84, blue: 0.76), radius: 9.75, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.64, green: 0.63, blue: 0.63), lineWidth: 1)
                        
                    )
                    .padding(.trailing, 35)
                    VStack(alignment:.leading) {
                        Text("10월\n장보기 리포트")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .padding(.horizontal, 18)
                            .padding(.top, 18)
                            .padding(.bottom, 44)
                        Image(systemName: "chevron.right")
                            .fontWeight(.medium)
                            .font(.system(size: 24))
                            .foregroundStyle(.green)
                            .padding(.leading, 110)
                            .padding(.trailing, 24)
                            .padding(.bottom, 18)
                    }
                    .background(.white)
                    .cornerRadius(16)
                    .shadow(color: Color(red: 0.77, green: 0.84, blue: 0.76), radius: 9.75, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.64, green: 0.63, blue: 0.63), lineWidth: 1)
                        
                    )
                    
                }
                
                Spacer()
                
            }
            .padding(.vertical,32)
            .padding(.horizontal, 24)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            
        }
        .tint(.green) 
    }
}

#Preview {
    MainView()
}
