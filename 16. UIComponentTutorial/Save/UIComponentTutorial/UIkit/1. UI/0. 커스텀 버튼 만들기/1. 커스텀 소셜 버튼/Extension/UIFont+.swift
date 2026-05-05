//
//  UIFont+.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/28/25.
//
// https://stackoverflow.com/questions/50978284/swift-4-set-custom-font-programmatically

import Foundation
import UIKit

extension UIFont {

    public enum PretendardType: String {
        case black = "-Black"
        case bold = "-Bold"
        case extraBold = "-ExtraBold"
        case extraLight = "-ExtraLight"
        case light = "-Light"
        case medium = "-Medium"
        case regular = "-Regular"
        case semiBold = "-SemiBold"
        case thin = "-Thin"
    }

    static func pretendard(_ type: PretendardType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Pretendard\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}
