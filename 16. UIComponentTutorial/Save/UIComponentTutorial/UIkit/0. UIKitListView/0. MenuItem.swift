//
//  0. MenuItem.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/31/25.
//

/*
 서버에서 받을 수 있는 여러 타입을 모두 반영하기 위헤 제네릭으로 변환하는 코드 필요한 상태
 */

import UIKit

// MARK: - 데이터 구조 설계

// 각 셀에 표시할 메뉴 정보
struct MenuItem: Hashable {
    let title: String
    let viewControllerType: UIViewController.Type

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        // hasher.combine(String(describing: viewControllerType)) // 필요시 타입 이름도 추가 가능
    }

    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.title == rhs.title // 또는 && String(describing: lhs.viewControllerType) == String(describing: rhs.viewControllerType)
    }
}

// 섹션 정의
enum MenuSection: String, CaseIterable {
    case customButton = "커스텀 버튼"
    case textField = "텍스트필드"
    case tableView = "테이블뷰"
    case animationView = "애니메이션"
    case calendarView = "캘린더"
    case scrollView = "스크롤"
    case onboarding = "온보딩"
    case rxDataSource = "RxDataSource"
    
}

let menuData: [MenuSection: [MenuItem]] = [
    .customButton: [
        MenuItem(title: "CustomButton", viewControllerType: FirstViewController.self)
    ],
    .textField: [
        MenuItem(title: "BasicTextField", viewControllerType: BasicTextFieldVC.self),
        MenuItem(title: "CustomTextField", viewControllerType: CustomTextFieldVC.self)
    ],
    .tableView: [
        MenuItem(title: "BasicTable", viewControllerType: BasicTableVC.self),
        MenuItem(title: "BasicTable + CustomDataSource", viewControllerType: CustomDataSourceTableVC.self),
        MenuItem(title: "CombineTable", viewControllerType: CombineTableVC.self),
        MenuItem(title: "Combine + CustomDataSource", viewControllerType: CustomCombineDataSourceVC.self),
        MenuItem(title: "Combine + CustomDataSource + Generic", viewControllerType: GenericCustomCombineDataSourceVC.self),
        MenuItem(title: "Best + Combine + CustomDataSource + Generic", viewControllerType: BestGenericCustomCombineDataSourceVC.self),
        MenuItem(title: "DiffableDataSource", viewControllerType: DiffableDataSourceListVC.self)
    ],
    .animationView: [
        MenuItem(title: "Segment Control 화면 전환", viewControllerType: SegmentControlVC.self),
        MenuItem(title: "Segment ControlVC 슬라이드 전환", viewControllerType: CustomSegmentControlVC.self),
    ],
    
    .calendarView: [
        MenuItem(title: "Basic Calendar", viewControllerType: BasicCalendarVC.self),
        MenuItem(title: "Custom Calendar", viewControllerType: CustomCalendarVC.self)
    ],
    
    .scrollView: [
        MenuItem(title: "수평 Scroll", viewControllerType: ScrollViewController.self)
    ],
    
    .onboarding: [
        MenuItem(title: "온보딩", viewControllerType: StartViewController.self)
    ],
    
    .rxDataSource: [
        /*
        MenuItem(title: "셀이 화면에서 사라지면 메모리 해제 예시", viewControllerType: RxDataSourceVC.self),
        MenuItem(title: "CustomDataSourceVC", viewControllerType: CustomDataSourceVC.self),
        MenuItem(title: "CustomDataSourceVC2", viewControllerType: CustomDataSourceVC2.self)
         */
        
        MenuItem(title: "기본 커스텀 데이터소스", viewControllerType: TodosVC.self),
        MenuItem(title: "기본 커스텀 데이터소스 개선", viewControllerType: TodosVC2.self),
        MenuItem(title: "RX 흉내 데이터소스", viewControllerType: TodosVC3.self),
        MenuItem(title: "RX Datasource", viewControllerType: TodosVC4.self),
        MenuItem(title: "RX CRUD", viewControllerType: TodosVC5.self),
        MenuItem(title: "RX 멀티섹션", viewControllerType: TodosVC6.self),
        MenuItem(title: "RX 커스텀멀티섹션", viewControllerType: TodosVC7.self)
        
        

        
        
    ]
]
