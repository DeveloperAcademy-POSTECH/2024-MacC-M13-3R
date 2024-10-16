//
//  ProgressViewModel.swift
//  TestProject-3R
//
//  Created by 임이지 on 10/14/24.
//

import SwiftUI

struct ProgressViewModel: View {
    @State private var savedAmount: CGFloat = 32000 // 예: 25000원 저축
    private let targetAmount: CGFloat = 50000 // 목표 금액

    var body: some View {
            GeometryReader { geometry in
                let progress = min(max(savedAmount / targetAmount, 0), 1) // 0과 1 사이로 클램프

                // 그라데이션 색상 설정
                let gradientColors: [Color] = {
                    if progress < 0.25 {
                        return [Color(red: 0.7, green: 0.87, blue: 0.39), Color(red: 0.61, green: 0.86, blue: 0.39)] // 0% - 25%
                    } else if progress >= 0.25 && progress < 0.5 {
                        return [Color(red: 0.7, green: 0.87, blue: 0.39), Color(red: 0.51, green: 0.84, blue: 0.4)] // 25% - 50%
                    } else if progress >= 0.5 && progress < 0.75 {
                        return [Color(red: 0.7, green: 0.87, blue: 0.39), Color(red: 0.41, green: 0.83, blue: 0.4)] // 50% - 75%
                    } else {
                        return [Color(red: 0.7, green: 0.87, blue: 0.39), Color(red: 0.31, green: 0.81, blue: 0.4)] // 75% - 100%
                    }
                }()

                let fixedWidth: CGFloat = geometry.size.width

            ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: fixedWidth, height: 25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 1)
                                .stroke(Color("RGrayGreen"), lineWidth: 2) // 테두리 색상 및 두께 설정
                            )

                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors:gradientColors), startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * progress, height: 19)
                        .cornerRadius(10)
                        .animation(.easeInOut, value: savedAmount)
                        .padding(3)
            }
        }
    }
}

#Preview {
    ProgressViewModel()
}
