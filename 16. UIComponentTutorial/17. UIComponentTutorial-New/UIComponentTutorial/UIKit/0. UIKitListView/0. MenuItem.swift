//
//  MenuItem.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 10/26/25.
//

import UIKit

// 각 셀에 표시할 메뉴 정보
struct MenuItem: Hashable {
    let title: String
    let viewControllerType: UIViewController.Type

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.title == rhs.title
    }
}

// 섹션
enum MenuSection: String, CaseIterable {
    case textField = "기본 텍스트필드"
}

let menuData: [MenuSection: [MenuItem]] = [
    .textField: [
        MenuItem(title: "BasicTextField", viewControllerType: BasicTextFieldVC.self)
    ],
]
