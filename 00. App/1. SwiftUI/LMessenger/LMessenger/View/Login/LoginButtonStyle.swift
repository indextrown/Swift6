//
//  LoginButtonStyle.swift
//  LMessenger
//
//  Created by 김동현 on 6/21/25.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
    let textColor: Color
    let borderColor: Color
    
    init(textColor: Color, borderColor: Color? = nil) {
        self.textColor = textColor
        self.borderColor = borderColor ?? textColor /// 없으면 textColor와 동일한 색상 적용
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 0.8)
            }
            .padding(.horizontal, 30)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

