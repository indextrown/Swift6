//
//  Part2-02-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/7/24.
//

/*
 Vstack {
 이미지
 텍스트
 버튼
 }
 
 padding(여백)
 align(정렬)
 */

import SwiftUI

struct Part2_02_View: View {
    var body: some View {
        VStack {
            Image(systemName: "pencil")
                .resizable()
                .scaledToFit()                  // 비율에 맞게 유지
                .frame(width: 200, height: 200) // 정사각형
            
            Text("헤드라인 입니다")
                .font(.headline)                // 폰트설정
                .bold()
                .padding()                      // 여백(상하좌우전부)
            
            Text("서브헤드라인 입니다")
                .font(.subheadline)
                .padding()
            
            Text("바디 입니다")
                .font(.body)
                .padding()
            
            Button {
                //
            } label: {
                Text("Click Me")
                    .padding()                   // 여백을 주고 파란색
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .bold()
            }
        }
    }
}

#Preview {
    Part2_02_View()
}
