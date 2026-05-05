//
//  UIViewController+.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/19/25.
//

import UIKit
import SwiftUI


// MARK: - 네비게이션포함버전
extension UIViewController {
    struct VCWrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UINavigationController {
            let root = UIKitViewController()
            let nav = UINavigationController(rootViewController: root)
            return nav
        }

        func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    }

    static func getRepresentable() -> some View {
        VCWrapper()
    }
}


// MARK: - 네비게이션 미포함버전
//extension UIViewController {
//    // SwiftUI에서 UIKit ViewController를 감싸는 Representable
//    struct VCRepresentable: UIViewControllerRepresentable {
//        func makeUIViewController(context: Context) -> UIKitViewController {
//            return UIKitViewController()  // 코드 기반 생성
//        }
//
//        func updateUIViewController(_ uiViewController: UIKitViewController, context: Context) {
//            // 상태가 변경될 때 필요한 작업이 있다면 여기에 구현
//        }
//    }
//
//    static func getRepresentable() -> some View {
//        VCRepresentable()
//    }
//}

/*
extension UIKitViewController {
    // SwiftUI에서 UIKit ViewController를 감싸는 Representable
    struct VCRepresentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIKitViewController {
            return UIKitViewController()  // 코드 기반 생성
        }

        func updateUIViewController(_ uiViewController: UIKitViewController, context: Context) {
            // 상태가 변경될 때 필요한 작업이 있다면 여기에 구현
        }
    }

    static func getRepresentable() -> some View {
        VCRepresentable()
    }
}
*/
