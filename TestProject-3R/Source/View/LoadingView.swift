//
//  LoadingView.swift
//  TestProject-3R
//
//  Created by 임이지 on 10/16/24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    @Binding var isCartViewActive: Bool
    
    @State private var progress: Float = 0.0
    @State private var timerActive = false
    
    var body: some View {
        VStack(alignment: .center) {
            CircularProgressBar(progress: progress)
                .frame(width: 125, height: 125)
                .padding(.bottom, 24)
                .padding(.top, 264)
            Text("잠시만 기다려주세요")
                .font(.RHeadline)
                .padding(.bottom, 4)
            Text("음성 인식을 준비 중입니다")
                .font(.RTitle)
                .padding(.bottom, 80)
            Text("곧 음성 인식이 시작됩니다.\n장바구니에 담는 물건의\n[이름], [가격], [개수]를 말씀해주세요.")
                .font(.RBody)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .onAppear {
            startProgress()
        }
    }

    private func startProgress() {
        timerActive = true
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.progress >= 1.0 || !timerActive {
                timer.invalidate() // 타이머 정지
                timerActive = false
                isLoading = false  // 로딩 뷰를 닫음
                isCartViewActive = true // 카트 뷰로 전환
            } else {
                self.progress += 0.015 // 10초 동안 점진적으로 증가
            }
        }
    }
}

struct CircularProgressBar: View {
    var progress: Float

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .foregroundColor(.rLightGray)
            
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(.rGreen)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            Image(systemName: "cart.fill")
                .frame(width: 68, height: 60)
                .font(.system(size: 50))
                .foregroundColor(.rWhite)
                .padding(.leading, 15)
                .padding(.trailing, 17)
                .padding(.vertical, 20)
                .background(Color("RGreen"))
                .cornerRadius(50)
        }
        
    }
}

//#Preview {
//    LoadingView()
//}
