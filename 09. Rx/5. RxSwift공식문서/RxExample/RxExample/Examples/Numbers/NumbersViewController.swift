//
//  NumbersViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa // 입력이 된것들 UIControl인데 여기에 접근할 수 있도록 지원해준다

class NumbersViewController: ViewController {
    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!
    @IBOutlet weak var number4: UITextField!
    
    @IBOutlet weak var result: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - 세개의 물줄기 = 파이프라인을 합친것
        // 텍스트필드에서 글자가 입력되면 Observable<String>형태로 주는것
        // orEmpty - 글자가 있을떄만 들어온다
        Observable.combineLatest(
            number1.rx.text.orEmpty,
            number2.rx.text.orEmpty,
            number3.rx.text.orEmpty,
            number4.rx.text.orEmpty
        ) { textValue1, textValue2, textValue3, textValue4 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0) + (Int(textValue4) ?? 0
            )
            } // Int
            .map { $0.description } // Int -> String
            // 해당 객체가 가지고 있는 아이템(프로퍼티) result에 바로 꽂은 상태
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
}
