//
//  View+.swift
//  CombineTutorial-example
//
//  Created by 김동현 on 7/18/25.
//

import SwiftUI

extension View {
    // self는 View view 프로토콜 타입 자체를 의미한다. 그런데 View는 프로토콜이기 때문에 구체적인 인스턴스를 알 수 없고 self를 View 인스턴스로 사용할 수 없다.
    // 또한 static은 탕비 메서드이기 때문에 타입 자체에서 호출되며 구체적인 인스턴스를 만들지 못한다.
    // 하지만 SwiftUIViewContainerVC는 생성자에서 View 인스턴스를 요구하기 때문에 타입만으로 만들 수 없다.
    // 즉 self가 NumberView인스턴스가 되어야 한다
    // 이미 생성이 됬을테니 static를뺸다
    func getContainerVC() -> UIViewController {
        return SwiftUIViewContainerVC(swiftUIView: self)
    }
}
