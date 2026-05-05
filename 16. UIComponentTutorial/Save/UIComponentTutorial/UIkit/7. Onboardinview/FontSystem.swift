//
//  FontSystem.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/12/25.
//

import UIKit
import ScaleKit

extension UIFont {
    enum HCFont: String {
        case black = "Pretendard-Black"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semiBold = "Pretendard-SemiBold"
        case thin = "Pretendard-Thin"
    }
}

extension UIFont {
    @MainActor static func hcFont(_ font: HCFont, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size.scaled) ?? UIFont.systemFont(ofSize: DynamicSize.scaledSize(size))
    }
}
