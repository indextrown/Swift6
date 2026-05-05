//
//  ButtonExtension.swift
//  LBSRiders
//
//  Created by 김동현 on 7/7/25.
//

import UIKit

extension UIButton {
    /// 버튼의 제목을 설정하는 메서드
    /// - Parameters:
    ///   - title: 버튼에 표시할 문자열
    ///   - state: 버튼의 상태 (예: .normal, .highlighted)
    /// - Returns: 자신(Self)을 반환하여 메서드 체이닝이 가능하게 합니다.
    @discardableResult
    func setTitle(_ title: String, state: UIControl.State) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    
    /// 버튼의 제목 색상을 설정하는 메서드
    /// - Parameters:
    ///   - color: 제목에 사용할 색상
    ///   - state: 버튼의 상태 (예: .normal, .disabled)
    /// - Returns: 자신(Self)을 반환하여 메서드 체이닝이 가능하게 합니다.
    @discardableResult
    func setTitleColor(_ color: UIColor, state: UIControl.State) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }
}
