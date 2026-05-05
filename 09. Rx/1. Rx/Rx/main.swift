//
//  main.swift
//  Rx
//
//  Created by 김동현 on 4/8/25.
//

import Foundation
import RxSwift

let disposeBag = DisposeBag()

let myJust = { element -> Observable<String> in
    return Observable.create { observer in
        observer.on(.next(element))
        return Disposables.create()
    }
}

myJust("hello world")
    .subscribe { print($0) }
    .disposed(by: disposeBag)
