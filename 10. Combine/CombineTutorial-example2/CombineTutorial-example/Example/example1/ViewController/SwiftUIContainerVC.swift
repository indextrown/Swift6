//
//  NumbersSwiftUIContainerVC.swift
//  CombineTutorial-example
//
//  Created by 김동현 on 7/17/25.
//

import UIKit
import SwiftUI

// MARK: - HostingController
final class SwiftUIViewContainerVC<SwiftUIView: View>: UIViewController {
    
    let swiftUIView: SwiftUIView
    
    init(swiftUIView: SwiftUIView) {
        self.swiftUIView = swiftUIView
        
        // UIViewController를 상속받기 때문에 부모의 viewController생성자를 호출해줘야한다
        super.init(nibName: nil, bundle: nil)
    }
    
    // 코드베이스 구현시 필요
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.configureHostingVC()
    }
    
    fileprivate func configureHostingVC() {
        let hostingVC = UIHostingController(rootView: swiftUIView)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(hostingVC)
        self.view.addSubview(hostingVC.view)
        hostingVC.didMove(toParent: self)
        NSLayoutConstraint.activate([
            hostingVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            hostingVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

/*
 uikit은 메모리 참조방식
 swiftui는 뷰를 재생성하는 방식(계속 복사생성)
 */

