//
//  BudgetView.swift
//  TestProject-3R
//
//  Created by 임이지 on 10/9/24.
//

import SwiftUI

struct BudgetView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack{
                    Text("예산 정하기")
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                }
                .padding(.top, 36)
                .padding(.bottom, 4)
                Divider()
                    .padding(.bottom, 16)
                HStack{
                    Text("오늘의 장보기 예산을 정해주세요")
                        .font(.system(size: 12, weight: .medium))
                    Spacer()
                }
                .padding(.bottom, 2)
                HStack(alignment: .bottom){
                    Text("50,000원")
                        .font(.system(size: 18))
                    Text("직접입력")
                        .font(.system(size: 8, weight: .medium))
                        .underline()
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.bottom, 20)
                Image("sample_slider")
                    .padding(.bottom, 54)
                
                HStack{
                    Text("장소 입력하기")
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                }
                .padding(.bottom, 4)
                Divider()
                    .padding(.bottom, 16)
                HStack{
                    Text("오늘의 장보기 장소를 입력해주세요")
                        .font(.system(size: 12, weight: .medium))
                    Spacer()
                }
                .padding(.bottom, 2)
                HStack(alignment: .bottom){
                    Text("이마트 포항이동점")
                        .font(.system(size: 18))
                    Text("직접입력")
                        .font(.system(size: 8, weight: .medium))
                        .underline()
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.bottom, 20)
                Image("sample_map")
                Spacer()
                NavigationLink(destination: CartView(size: CGSize(width: 300, height: 20))) {
                    Text("장보기 시작하기")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.horizontal, 132)
                        .padding(.vertical, 12)
                        .background(.green)
                        .cornerRadius(15)
                        .padding(.bottom, 36)
                }
                
            }
            .padding(.horizontal, 16)
            .navigationTitle("장보기 준비하기")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(.green)
    }
}

#Preview {
    BudgetView()
}
