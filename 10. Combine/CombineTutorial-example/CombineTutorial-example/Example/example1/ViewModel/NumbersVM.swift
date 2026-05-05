//
//  NumbersVM.swift
//  CombineTutorial-example
//
//  Created by 김동현 on 7/18/25.
//

import Combine
import UIKit

/*
 
 비즈니스 로직
 - 데이터 상태를 VM이 가지고 있다
 - 즉 완성된 데이터를 VM이 가지고 있다
 
 2가지 상태의 데이터
 - 뷰모델로 들어오는 Input
 - 뷰모델로 나가는 Output == 비즈니스 로직을 타서 완성된 데이터가 뷰모델에서 나가는 것
 
 https://hackernoon.com/lang/ko/Swiftuis-5-주요-속성-래퍼-및-이를-효과적으로-사용하는-방법
 
 */
final class NumbersVM: ObservableObject {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var resultPublisher: AnyPublisher<String, Never> =
        Publishers
            .CombineLatest4($number1,
                            $number2,
                            $number3,
                            $number4)
            .map { testValue1, testValue2, testValue3, testValue4 -> Int in
                return  testValue1.getNumber() +
                        testValue2.getNumber() +
                        testValue3.getNumber() +
                        testValue4.getNumber()
            }
            .map { String($0) }
            .eraseToAnyPublisher()
    
    private var resultPublisher2: AnyPublisher<String, Never> {
        Publishers
            .CombineLatest4($number1,
                           $number2,
                           $number3,
                           $number4)
           .map { testValue1, testValue2, testValue3, testValue4 -> Int in
               return  testValue1.getNumber() +
                       testValue2.getNumber() +
                       testValue3.getNumber() +
                       testValue4.getNumber()
           }
           .map { String($0) }
           .eraseToAnyPublisher()
    }
        
    
    // MARK: - Input: 뷰모델로 들어오는 데이터
    @Published var number1: String = ""
    @Published var number2: String = ""
    @Published var number3: String = ""
    @Published var number4: String = ""
    
    // MARK: - Output: 뷰모델로 나가는 데이터
    @Published var resultValue: String = ""
    
    init() {
        print(#fileID, #function, #line, "- ")
        
        // 1번 방식
        setupBinding()
        
        // 2번 방식
        /*
        resultPublisher
            .assign(to: \.resultValue, on: self)
            .store(in: &subscriptions)
         */
        
        // 3번 방식
        /*
        resultPublisher2
            .assign(to: \.resultValue, on: self)
            .store(in: &subscriptions)
         */
    }

    private func setupBinding() {
        Publishers
            .CombineLatest4($number1,
                            $number2,
                            $number3,
                            $number4)
            .map { testValue1, testValue2, testValue3, testValue4 -> Int in
                return  testValue1.getNumber() +
                        testValue2.getNumber() +
                        testValue3.getNumber() +
                        testValue4.getNumber()
            }

            .map { String($0) }
            // resultValue에 직접 꽂을건데 객체이므로 자기자신의 속성으로
            .assign(to: \.resultValue, on: self)
            /*
             assign대신 이렇게 해도됨
            .sink { value in
                self.resultValue = value
            }
             */
            .store(in: &subscriptions)
    }
}


