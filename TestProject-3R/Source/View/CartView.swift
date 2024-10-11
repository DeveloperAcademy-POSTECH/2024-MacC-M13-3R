//
//  CartView.swift
//  TestProject-3R
//
//  Created by 임이지 on 10/10/24.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle("장바구니")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            print("수정중")
                        }) {
                            Text("수정하기")
                                .foregroundColor(.green)
                        }
                }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            MainView()
                        }) {
                            Text("종료")
                                .foregroundColor(.green)
                        }
                }
            }
        }
    }
}

#Preview {
    CartView()
}
