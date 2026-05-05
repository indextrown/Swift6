//
//  CustomView.swift
//  uikit-storyboard-tutorial
//
//  Created by 김동현 on 3/19/25.
//

import Foundation
import UIKit

// @IBDesignable: 인터페이스 빌더에서 디자인으로 확인 가능하게끔 -> xcode 17부터 deprecated됨..
@IBDesignable
final class CustomView: UIView {
    
    // cornerRadius 값이 변경된다면 그 값으로 cornerRadius를 설정하겠다
    // @IBInspectable -> 인스펙터 패널에서 사용될 수 있도록 설정
    @IBInspectable
    var cornerRadius: CGFloat = 0 { // 프로퍼티 옵저버: 값이 변경되면 didSet부분 실행
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor =  UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var isCircle: Bool = false {
        didSet {
            // 정사각형이면서 isCircle이면 원으로 표현 -> 로직을 나누어보자
            if isSquare() && isCircle {
                self.layer.cornerRadius = self.frame.width / 2
            }
        }
    }
    
    // fileprivate: 접근제어자: CustomView 파일 안에서만 사용가능
    /// 뷰정사각형 여부
    /// - Returns: 여부
    fileprivate func isSquare() -> Bool {
        return self.frame.width == self.frame.height
    }
    
    fileprivate var isSquare2: Bool {
        get {
            return self.frame.width == self.frame.height
        }
    }
}
