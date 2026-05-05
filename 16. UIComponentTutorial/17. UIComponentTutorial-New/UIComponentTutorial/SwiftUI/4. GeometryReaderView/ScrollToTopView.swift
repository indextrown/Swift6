//
//  ScrollToTopView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/16/25.
//
// https://minwoostory.tistory.com/103
// https://seons-dev.tistory.com/entry/SwiftUI-ScrollToTop-맨위로-버튼

import SwiftUI

struct ScrollToTopView: View {
    @State private var startOffset: CGFloat = 0
    @State private var scrollViewOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxyReader in
            
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    ForEach(1...30, id: \.self) {_ in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 70, height: 70)
                            VStack(alignment: .leading, spacing: 10) {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 20)
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 20)
                                    .padding(.trailing, 100)
                            }
                        }
                    }
                }
                .padding()
                
                // 스크롤위치 지정해줄 id 부여
                .id("Scroll_To_Top")
                
                // offset구하기
                .overlay (
                    GeometryReader { proxy -> Color in
                        DispatchQueue.main.async {
                            if startOffset == 0 {
                                self.startOffset = proxy.frame(in: .named("scroll")).minY
                            }
                            let offset = proxy.frame(in: .global).minY
                            self.scrollViewOffset = offset - startOffset
                            print(self.scrollViewOffset)
                        }
                        return Color.clear
                    }
                    .frame(width: 0, height: 0)
                    ,alignment: .top
                )
            }
            .coordinateSpace(name: "scroll")
            
            // 특정 offset조건에 버튼 생성
            .overlay(
                Button {
                    withAnimation(.default) {
                        proxyReader.scrollTo("Scroll_To_Top", anchor: .top)
                    }
                } label: {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                }
                // 패딩
                    .padding(.trailing)
                    .padding(.bottom, getSafeArea().bottom == 0 ? 12 : 0)
                
                // startOffset이 450보다 작으면 투명도 적용
                    .opacity(scrollViewOffset < -450 ? 1 : 0)
                
                // 우측 하단 버튼 고정
                ,alignment: .bottomTrailing
            )
        }
    }
}

extension ScrollToTopView {
    func getSafeArea() -> UIEdgeInsets {
        guard let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first,
              let window = scene.windows.first(where: { $0.isKeyWindow })
        else {
            return .zero
        }
        
        return window.safeAreaInsets
    }
}

#Preview {
    ScrollToTopView()
}

// 베젤없는 기종과 있는 기종 비교를 위한 프리뷰 설정
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(["iPhone 12 Pro", "iPhone 8"], id: \.self) {
//        ContentView()
//            .previewDevice(PreviewDevice(rawValue: $0))
//            .previewDisplayName($0)
//        }
//    }
//}
