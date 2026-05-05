//
//  ContentView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/18/25.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab: Int = 1
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white

        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    var body: some View {
        ZStack {
            // ✅ 탭바 아래까지 침투 방지: 전체 백그라운드 깔기
            Color(.white)
                .ignoresSafeArea() // ← 오직 백그라운드 용도
            TabView(selection: $selectedTab) {
                SwiftUIView()
                    .tabItem {
                        Label("SwiftUI", systemImage: "1.square.fill")
                    }
                    .tag(1)

                UIKitViewController.getRepresentablee()
                    .tabItem {
                        Label("UIKit", systemImage: "2.square.fill")
                    }
                    .tag(1)
            }
        }
    }
}


//struct ContentView: View {
//    @State var selectedTab: Int = 1
//    
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            SwiftUIView()
//                .tabItem {
//                    Image(systemName: "1.square.fill")
//                    Text("SwiftUI")
//                }
//                .tag(1) // 첫 번째 탭의 고유 값
//
//            UIKitViewController.getRepresentable()
//                .tabItem {
//                    Image(systemName: "2.square.fill")
//                    Text("UIKit")
//                }
//                .tag(2) // 두 번째 탭의 고유 값
//        }
//        .ignoresSafeArea()
//    }
//}

#Preview {
    ContentView()
}
