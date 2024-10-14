//
//  ModalView.swift
//  TestProject-3R
//
//  Created by 임이지 on 10/14/24.
//

import SwiftUI

struct ModalView: View {
    let items: [(String, Int, Int, Int)] = [
            ("쌀 (5kg)", 1, 15000, 15000),
            ("라면", 5, 800, 4000),
            ("계란 (10개)", 1, 3000, 3000),
            ("냉동만두", 1, 5000, 5000),
            ("우유 (1L)", 1, 1500, 1500),
            ("치킨너겟 (500g)", 1, 2000, 2000),
            ("샐러드 (300g)", 1, 1000, 1000),
            ("음료수 (1.5L)", 1, 500, 500)
        ]
    
    var body: some View {
            VStack (alignment: .leading) {
                HStack {
                    Text("2024.10.04")
                        .font(.RTitle)
                    Spacer()
                }
                .padding(.bottom, 4)
                HStack {
                    Text("영수증")
                        .font(.RHeadline)
                    Spacer()
                }
                .padding(.bottom,8)
                Divider()
                    .foregroundColor(.rGray)
                    .padding(.bottom,8)
                
                    HStack {
                        Text("이마트 포항이동점")
                            .font(.RCallout)
                        Spacer()
                    }
                    .padding(.bottom, 12)
                ScrollView {
                VStack(alignment:.center) {
                    VStack(alignment: .center) {
                        HStack {
                            Text("품목")
                                .font(.RCaption1)
                                .frame(width: 118, alignment: .leading)
                            Text("수량")
                                .font(.RCaption1)
                                .frame(width: 24, alignment: .trailing)
                            Text("단가")
                                .font(.RCaption1)
                                .frame(width: 67, alignment: .trailing)
                            Text("합계")
                                .font(.RCaption1)
                                .frame(width: 57, alignment: .trailing)
                        }
                        .padding(.bottom, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.fixed(118)),
                            GridItem(.fixed(24)),
                            GridItem(.fixed(67)),
                            GridItem(.fixed(57))
                        ]) {
                            ForEach(items, id: \.0) { item in
                                Text(item.0)
                                    .font(.RCaption1)
                                    .foregroundColor(.rDarkGray)
                                    .frame(width: 118, alignment: .leading)
                                    .padding(.bottom, 8)
                                Text("\(item.1)")
                                    .font(.RCaption1)
                                    .foregroundColor(.rDarkGray)
                                    .frame(width: 24, alignment: .trailing)
                                    .padding(.bottom, 8)
                                Text("\(item.2) 원")
                                    .font(.RCaption1)
                                    .foregroundColor(.rDarkGray)
                                    .frame(width: 67, alignment: .trailing)
                                    .padding(.bottom, 8)
                                Text("\(item.3) 원")
                                    .font(.RCaption1)
                                    .foregroundColor(.rDarkGray)
                                    .frame(width: 57, alignment: .trailing)
                                    .padding(.bottom, 8)
                            }
                        }
                        
                    }
                    .padding(32)
                    .background(Color("RLightGreen"))
                    .cornerRadius(4)
                    .padding(.bottom, 12)
                    HStack {
                        Text("카드")
                            .font(.RCallout)
                        Spacer()
                        Text("34,500 원")
                            .font(.RCallout)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 36)
    }
}

#Preview {
    ModalView()
}
