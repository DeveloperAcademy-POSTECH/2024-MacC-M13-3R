//
//  HistoryView.swift
//  TestProject-3R
//
//  Created by 장유진 on 10/16/24.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(shoppingViewModel.dateItem.reversed(), id: \.self) { item in
                    HStack (spacing: 0){
                        Text(shoppingViewModel.formatDate(from: item.date))
//                        Text(shoppingViewModel.formatDate(from: shoppingViewModel.dateItem.last?.date ?? Date()))
                            .font(.RBody)
                        Spacer()
                        Text("\(shoppingViewModel.dateItem.last?.total ?? 10000)")
//                        Text(shoppingViewModel.selectedDateItem.total)
                    }
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
                .tint(.red)
            }
        }
        .listStyle(.plain)
        .navigationTitle("영수증 관리")
    }
}

#Preview {
    HistoryView(shoppingViewModel: ShoppingViewModel())
}
