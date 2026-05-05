//
//  CALayer+Extension.swift
//  uikit-storyboard-tutorial
//
//  Created by 김동현 on 3/19/25.
//

/*
 [Reference]
 - https://medium.com/better-programming/how-to-match-shadow-and-blur-to-the-sketch-application-d4ed20dfa816
 - https://stackoverflow.com/questions/34269399/how-to-control-shadow-spread-and-blur
 
 */
import UIKit

extension CALayer {
    
    /// 그림자 적용
    /// - Parameters:
    ///   - color: 그림자 색상
    ///   - alpha: 투명도(opacity)
    ///   - x: 그림자 가로위치
    ///   - y: 그림자 세로위치
    ///   - blur: 블러
    ///   - spread: 퍼짐정도
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 20,
        blur: CGFloat = 35,
        spread: CGFloat = 0)
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
