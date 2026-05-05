//
//  ContentView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/31/25.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab: Int = 2
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground

        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SwiftUIListView()
                .tabItem {
                    Label("SwiftUI", systemImage: "1.square.fill")
                }
                .tag(1)

            UIKitListViewController.getRepresentablee()
                .tabItem {
                    Label("UIKit", systemImage: "2.square.fill")
                }
                .tag(2)
        }
    }
}

// MARK: - 네비게이션포함버전(UIKit VC를 SwiftUI에서 사용할 때 쓰는 표준 방식)
extension UIViewController {
    struct VCWrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UINavigationController {
            let root = UIKitListViewController()
            let nav = UINavigationController(rootViewController: root)
            return nav
        }

        func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    }

    static func getRepresentablee() -> some View {
        VCWrapper()
            .ignoresSafeArea(.all, edges: .top) // ✅ 상단 safeArea 영향 제거
    }
}

#Preview {
    ContentView()
}
