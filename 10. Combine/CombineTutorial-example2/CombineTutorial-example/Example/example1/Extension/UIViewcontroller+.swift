//
//  UIViewcontroller+.swift
//  CombineTutorial-example
//
//  Created by 김동현 on 7/17/25.
//

import UIKit

/*
 static 변수
 - 인스턴스를 생성하지 않아도 접근할 수 있다
 - 타입에 속한 변수이며, 모든 인스턴스가 이 값을 공유한다
 
 static 함수는
 - 인스턴스를 만들지 않고도 호출할 수 있다
 - 보통 공통 정보 제공이나 객체 생성 팩토리 용도로 사용한다
 
 */

protocol Storyboarded {
    // static함수는 해당하는 객체를 메모리에 만들지 않아도 만들 수 있다
    static func instantiate(_ storyboardName: String) -> Self
}

// 프로토콜 정의
// Storyboarded를 준수하면서 본인이 UIViewController이라면
extension Storyboarded where Self: UIViewController {
    
    /// 객체를 메모리에 생성하지 않고도 호출 가능한 타입 메서드입니다.
    ///
    /// 주어진 스토리보드 이름에서 이 타입의 뷰 컨트롤러를 인스턴스화합니다.
    /// - Parameter storyboardName: 뷰 컨트롤러가 위치한 스토리보드 파일의 이름
    /// - Returns: 스토리보드에서 생성된 현재 타입(Self)의 인스턴스
    static func instantiate(_ storyboardName: String) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main) // 내자신의 이름
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
        return vc
    }
}

extension UIViewController: Storyboarded {}
