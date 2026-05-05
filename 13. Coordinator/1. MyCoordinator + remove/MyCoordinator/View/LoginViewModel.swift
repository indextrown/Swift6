//
//  LoginViewModel.swift
//  MyCoordinator
//
//  Created by 김동현 on 4/21/25.
//

import Foundation
import RxSwift
import RxRelay

final class LoginViewModel {
    
    let nickname = BehaviorRelay<String>(value: "테스트닉네임")
    private let disposeBag = DisposeBag()
    
    func bindTestBtn(_ tapped: Observable<Void>) {
        tapped.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
                print("닉네임: \(self.nickname.value)")
        })
        .disposed(by: disposeBag)
    }
}
