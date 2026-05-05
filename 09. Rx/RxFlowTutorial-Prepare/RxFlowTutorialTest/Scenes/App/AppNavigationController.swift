//
//  AppNavigationController.swift
//  RxFlowTutorialTest
//
//  Created by 김동현 on 8/5/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class AppNavigationController: UINavigationController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        
        // MARK: - 이벤트 받기
        NotificationCenter.default.rx.notification(.userLoggedOutEvent)
            .bind(onNext: { [weak self] _ in
                self?.popToRoot()
            })
            .disposed(by: disposeBag)
    }
    
    func popToRoot() {
        print(#fileID, #function, #line, "- ")
        self.popToRootViewController(animated: true)
    }
}
