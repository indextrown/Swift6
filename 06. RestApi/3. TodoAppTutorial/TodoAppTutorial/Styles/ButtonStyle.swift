//
//  ButtonStyle.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/25/25.
//

import SwiftUI

struct MyDefaultButtonStyle: ButtonStyle {
    let bgColor: Color
    let textColor: Color
    
    init(bgColor: Color = Color.blue, textColor: Color = Color.white) {
        self.bgColor = bgColor
        self.textColor = textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .foregroundStyle(textColor)
                .lineLimit(2).minimumScaleFactor(0.7)
            Spacer()
        }
        .padding()
        .background(bgColor.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1) // 버튼이 눌렸을 때 약간 들어가는 효과
    }
}
