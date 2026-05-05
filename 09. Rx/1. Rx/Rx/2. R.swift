//
//  2. R.swift
//  Rx
//
//  Created by 김동현 on 4/18/25.
//

import Foundation
import RxSwift
import RxCocoa

@main
struct Main {
    static func main() {
        
        let disposebag = DisposeBag()
        
        let observable = Observable<String>.of("1", "2", "3")
        
        observable
            .subscribe(onNext: { value in
                print(value)
            }, onError: { error in
                print("error: \(error)")
            }, onCompleted: {
                print("completed")
            })
            .disposed(by: disposebag)
        
        observable
            .bind(onNext: { value in
                print(value)
            })
            .disposed(by: disposebag)
    }
}
