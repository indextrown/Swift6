//
//  SlideView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/7/25.
//

import SwiftUI

struct DoubleSidedBackgroundScrollView<Content: View>: View {

    private let ContentBuilder: () -> Content
    private let topColor: Color         // 배경의 상단 색상
    private let bottomColor: Color      // 배경의 하단 색상
    
    @State private var offset: CGFloat = .zero  // 스크롤 오프셋 값 저장(얼마나 위라래로 이동했는지)
    
    init(topColor: Color, bottomColor: Color, contentBuilder: @escaping () -> Content) {
        self.ContentBuilder = contentBuilder // ㅋ,ㄹ로저 형태로 전달된 스크롤 뷰의 실제 내용을 생성
        self.topColor = topColor
        self.bottomColor = bottomColor
    }

    var body: some View {
        ScrollView {
            ZStack {
                ContentBuilder()
                
                // 스크롤뷰 위치 추적
                GeometryReader { proxy in
                    // 스크롤 뷰 상단 부분이 기준 좌표에 대해 얼마나 이동했는가
                    let offset = proxy.frame(in: .named("scroll")).minY
                    // 투명한 색상을 사용하여 레이아웃에 영항을 주지 않음
                    Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                }
            }
        }
        .coordinateSpace(name: "scroll")
        
        // PreferenceKey의 값이 변경될 때 offset을 업데이트
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offset = value
        }
        .background(
            VStack(spacing: 0) {
                // offset 값에 따라 상단 배경의 높이를 조정
                // max를 사용하여 높이가 음수가 되지 않도록 제한
                topColor
                    .frame(
                        height: max(offset + (UIScreen.main.bounds.height / 2), 0),
                        alignment: .top)
                bottomColor
                    .clipShape(RoundedRectangle(cornerRadius: 30)) // 둥근 모서리 추가
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray, lineWidth: 2) // 테두리 추가
                    )
                    .padding(.top, -80)
            }
            .ignoresSafeArea()
        )
    }
}

// GeometryReader로 계산한 offset 값을 ScrollView에서 @State로 저장
// reduce 메서드는 현재 값과 새 값을 병합
private struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct SlideView: View {
    var body: some View {
        DoubleSidedBackgroundScrollView(topColor: .black, bottomColor: .white) {
            VStack {

            }
        }
        .navigationBarBackButtonHidden(true) // ← 뒤로가기 버튼 숨기기
        .toolbar(.hidden, for: .tabBar) 
    }
}

#Preview {
    SlideView()
}
