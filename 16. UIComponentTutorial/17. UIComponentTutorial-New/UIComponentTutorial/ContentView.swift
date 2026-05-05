//
//  ContentView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 10/26/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab: Int = 1
    @State private var tabBarHeight: CGFloat = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SwiftUIListView()
                .tabItem {
                    Label("SwiftUI", systemImage: "1.square.fill")
                }
                .tag(1)
            
                // MARK: - 탭바 높이 아는법
                .background(
                    TabBarProxy { view, tabBar in
                        let safeInsets = tabBar.safeAreaInsets
                        print("🧭 탭바 전체 bounds:", tabBar.bounds)
                        // print("⬆️ 상단 안전영역(top):", safeInsets.top)
                        // print("⬇️ 하단 안전영역(bottom):", safeInsets.bottom)
                        // print("⬅️ 좌측(left):", safeInsets.left)
                        // print("➡️ 우측(right):", safeInsets.right)

                        let contentHeight = tabBar.bounds.height - safeInsets.bottom
                        print("📏 탭 콘텐츠 높이:", contentHeight)
                        
                        print("📱 View 전체 safeAreaInsets:", view.safeAreaInsets)
                        print("🧭 TabBar 자체 safeAreaInsets:", tabBar.safeAreaInsets)
                    }
                )
            
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





import SwiftUI
import UIKit

struct TabBarProxy: UIViewControllerRepresentable {
    var callback: (_ view: UIView, _ tabBar: UITabBar) -> Void
    
    class ProxyController: UIViewController {
        var callback: (_ view: UIView, _ tabBar: UITabBar) -> Void = { _, _ in }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBarController = self.tabBarController {
                callback(tabBarController.view, tabBarController.tabBar)
            }
        }
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ProxyController()
        vc.callback = callback
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // nothing
    }
}
