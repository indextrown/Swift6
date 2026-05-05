//
//  NumbersViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

final class NumbersViewController: UIViewController {
    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!
    @IBOutlet weak var result: UILabel!
    var subscriptions = Set<AnyCancellable>()
    private var viewModel: NumbersVM = NumbersVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - ViewModel에 Input 넣어주기
        number1.textPublisher
            .compactMap { $0 }
            .assign(to: \.number1, on: viewModel) // viewModel이 가지고 있는 number1 속성에 꽂는다
            .store(in: &subscriptions)
        
        number2.textPublisher
            .compactMap { $0 }
            .assign(to: \.number2, on: viewModel)
            .store(in: &subscriptions)
        
        number3.textPublisher
            .compactMap { $0 }
            .assign(to: \.number3, on: viewModel)
            .store(in: &subscriptions)
        
        // MARK: - ViewModel에서 나오는 데이터 바인딩하기
        viewModel.$resultValue
            .compactMap { $0 }
            .map { String($0) }
            .assign(to: \.text, on: result) // result.text에 resultValue를 해줘라
            .store(in: &subscriptions)
        
        
//        Publishers
//            .CombineLatest3(number1.textPublisher,
//                           number2.textPublisher,
//                           number3.textPublisher)
//            .map { testValue1, testValue2, testValue3 -> Int in
//                return  testValue1.getNumber() +
//                        testValue2.getNumber() +
//                        testValue3.getNumber()
//            }
//            /*
//            .sink { value in
//                print(#fileID, #function, #line, "- value: \(value)")
//            }
//             */
//            .map { String($0) }
//            .assign(to: \.text, on: result)
//            .store(in: &subscriptions)
    }
}

/*
Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
        return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
    }
    .map { $0.description }
    .bind(to: result.rx.text)
    .disposed(by: disposeBag)
 */
