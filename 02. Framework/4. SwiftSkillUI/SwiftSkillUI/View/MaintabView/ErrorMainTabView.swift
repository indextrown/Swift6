//
//  ErrorMainTabView.swift
//  SwiftSkillUI
//
//  Created by 김동현 on 1/29/25.
//

import SwiftUI

struct ErrorMainTabView: View {
    @State var searchText: String
    var body: some View {
        
        ZStack {
            Color.mainBlack
                .ignoresSafeArea()
            
            VStack {
                TextField("검색", text: $searchText)
                    .padding()
                    .background(Color.subBlack)
                    .cornerRadius(10)
                    .padding()
                
                List {
                    Section(header:
                        Text("Numbers")
                        .foregroundColor(Color.mainGreen)
                        .font(.system(size: 17, weight: .bold))
                        .padding(.leading, -10)
                    ) {
                        ForEach(0...5, id: \.self) { memo in
                            Button {
                                
                            } label: {
                                Text(String(memo))
                                    .foregroundColor(.white) // ✅ 텍스트 색상
                                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ 왼쪽 정렬
                                
                            }
                            .listRowBackground(Color.subBlack) // ✅ 각 행의 배경색 지정
                            .listRowSeparatorTint(Color.gray.opacity(0.4), edges: .bottom) // ✅ 구분선 색상 지정
                        }
                    }
                }
                .scrollContentBackground(.hidden) // ✅ 리스트 기본 배경 제거
                .background(Color.mainBlack) // ✅ 전체 리스트 배경 변경
            }
        }
    }
}

#Preview {
    ErrorMainTabView(searchText: "")
}

// MARK: - 리스트 커스텀 버튼
struct ListRowButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            // to cover the whole length of the cell
            .frame(
                maxWidth: .greatestFiniteMagnitude,
                alignment: .leading)
            // to make all the cell tapable, not just the text
            .contentShape(.rect)
            .background {
                if configuration.isPressed {
                    Rectangle()
                        .fill(Color.mainGreen)
                    // Arbitrary negative padding, adjust accordingly
                        .padding(-20)
                }
            }
    }
}
