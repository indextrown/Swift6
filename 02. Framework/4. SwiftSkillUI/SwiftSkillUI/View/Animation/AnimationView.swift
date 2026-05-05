//
//  AnimationView.swift
//  SwiftSkillUI
//
//  Created by 김동현 on 1/26/25.
//

import SwiftUI

struct AnimationView: View {
    @State private var buttonTapped: Bool = false
    
    var body: some View {
        VStack {
            CustomButton(buttonTapped:$buttonTapped)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 전체 화면 크기
        .background(Color.black.gradient) // 배경색 지정
        .ignoresSafeArea() // 안전 영역 무시
    }
}

// MARK: - 애니메이션 버튼
private struct CustomButton: View {
    @Binding var buttonTapped: Bool
    
    fileprivate var body: some View {
        Button {
            withAnimation {
                buttonTapped.toggle()
            }

        } label: {
            Text("버튼")
                .font(.headline)
                .foregroundStyle(Color.black)
                .frame(width: 200, height: 50)
                .frame(width: buttonTapped ? 100 : 200, height: 50)
                .background(Color.white)
                .cornerRadius(20)
        }
    }
}

#Preview {
    AnimationView()
}
