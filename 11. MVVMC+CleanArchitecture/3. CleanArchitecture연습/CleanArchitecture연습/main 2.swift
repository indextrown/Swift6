////
////  main.swift
////  CleanArchitecture연습
////
////  Created by 김동현 on 4/3/25.
////
//
//import Foundation
//
///*
// MARK: 의존성 - 어떤 클래스가 다른 클래스에 직접적으로 사용하는 관계를 의미한다.
// 
// class A {
//     let b = B()  // A는 B에 의존한다
// }
// 
// MARK: 의존성 역전 - 고수준의 모듈이 저수준의 모듈에 의존하지 않도록 대신 둘다 추상(인터페이스, 프로토콜)에 의존하게 만드는 원칙이다
//
// */
//
//// MARK: - Presentation Layer
//class ViewModel { // 저수준
//    /// viewModel이 useCase 의존
//    private let usecase = UseCase() // 고수준
//}
//
//// MARK: - Domain Layer
//class UseCase { // 고수준
//    /// useCase가 repository 의존 -> 클린아키텍처 원칙 위반
//    /// Repository가 변경되면 UseCase도 변경될 가능성 있음..-> 결합도가 높아짐, 테스트도 어려움(Mock주입 불가)
//    /// 여기서 의존성 역전이 필요하다 -> protocol(인터페이스) == 고수준임: 추상화 한 개념이라 변경이 잘 일어나지 않는다
//    // private let repository = Repository() // 저수준(data에 더 가깝다)
//    
//    /// 해결방법
//    /// useCase가 Repository를 직접 의존하는게 아니라 Repository프로토콜 인터페이스 개념을 의존한다 -> 고수준이 고수준을 의존하게 해줌
//    /// 이제 UseCase는 Repository라는 구체적인 클래스가 뭔지 몰라도 됨 대신 RepositoryProtocol이라는 고수준 추상 개념만 알게 됨
//    private let repository: RepositoryProtocol // 더 고수준
//    
//    init(repository: RepositoryProtocol) {
//        self.repository = repository
//    }
//}
//
//// MARK: - Domain Layer
//protocol RepositoryProtocol {
//    func getUsers()
//}
//
//// MARK: - Data layer
//class Repository {
//    func getUsers() {
//        
//    }
//}
