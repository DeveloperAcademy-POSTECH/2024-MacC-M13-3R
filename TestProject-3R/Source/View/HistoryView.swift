//
//  HistoryView.swift
//  TestProject-3R
//
//  Created by 장유진 on 10/16/24.
//

import SwiftUI

struct HistoryView: View {
    @Environment (\.dismiss) var dismiss
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(shoppingViewModel.dateItem.reversed(), id: \.self) { item in
                    NavigationLink {
                        ModalView(shoppingViewModel: ShoppingViewModel())
                    } label: {
                        HStack (spacing: 0){
                            Text(shoppingViewModel.formatDate(from: item.date))
                            Spacer()
                            Text("\(item.total)")
                        }
                    }.font(.RBody)
                    
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
                .tint(.red)
            }
            .navigationTitle("영수증 관리")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HistoryView(shoppingViewModel: ShoppingViewModel())
}
