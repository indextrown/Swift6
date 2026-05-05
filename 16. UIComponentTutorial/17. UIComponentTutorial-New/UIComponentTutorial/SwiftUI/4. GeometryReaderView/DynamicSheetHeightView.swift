//
//  TestView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/3/25.
//

import SwiftUI
import BottomSheet

struct DynamicSheetHeightView: View {
    @State private var sheetHeight: CGFloat = .zero
    @State private var bottomSheetPosition: BottomSheetPosition = .relative(0.45)
    
    private var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }
    private var tabBarHeight: CGFloat { 49 + safeBottom }
    
    private var safeBottom: CGFloat { keyWindow?.safeAreaInsets.bottom ?? 0 }
    
    // 검색창 고정 높이
    private let searchBarHeight: CGFloat = 50
    
    // 화면 전체 높이
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    // 검색창 밑면과 화면 하단 사이 거리
    private var searchBarBottomFromScreenBottom: CGFloat {
        screenHeight - searchBarHeight
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Rectangle()
                .frame(width: 200, height: 50)
                .cornerRadius(20)
            
            Spacer()
            
        }
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                     switchablePositions: [.absolute(0),
                                           .absolute(tabBarHeight + 50),
                                           .relative(0.45),
                                           .absolute(searchBarBottomFromScreenBottom - (tabBarHeight + safeBottom))
                                          ],
        ) {
            SampleSheetView(sheetHeight: $sheetHeight)
        }
        .onChange(of: bottomSheetPosition) { _, newPosition in
            print("🟢 시트 위치 변경됨 → \(newPosition)")
        }
        .onAppear {
            print("searchBarBottomFromScreenBottom: \(searchBarBottomFromScreenBottom)")
            print("tabBarHeight: \(tabBarHeight)")
            print("safeBottom: \(safeBottom)")
        }
    }
}

private struct SampleSheetView: View {
    @Binding var sheetHeight: CGFloat
    @State private var sheetTopY: CGFloat = 0
    
    var body: some View {
        VStack {
            Text("SampleSheetView")
            Text("📏 밑에서부터 높이: \(sheetHeight, specifier: "%.1f")")
                .font(.caption)
        }
        .ignoresSafeArea()
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        let globalFrame = geo.frame(in: .global)
                        let screenHeight = UIScreen.main.bounds.height
                        sheetHeight = screenHeight - globalFrame.minY
                        print("📍 초기 밑에서부터 높이: \(sheetHeight)")
                    }
                    .onChange(of: geo.frame(in: .global).minY) { _, newY in
                        let screenHeight = UIScreen.main.bounds.height
                        sheetHeight = screenHeight - newY
                        print("📍 밑에서부터 높이 변경됨: \(sheetHeight)")
                    }
            }
        )
    }
}

#Preview {
    TabView {
        DynamicSheetHeightView()
            .tabItem {
                Label("시트 테스트", systemImage: "square.and.arrow.up")
            }

        Text("다른 탭")
            .tabItem {
                Label("기본", systemImage: "house")
            }
    }
}
