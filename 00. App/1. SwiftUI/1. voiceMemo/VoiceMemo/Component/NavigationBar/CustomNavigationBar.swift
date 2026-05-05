//
//  CustomNavigationBar.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/27/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    let isDisplayLeftBtn: Bool
    let isDisplayRightBtn: Bool
    let leftBtnAction: () -> Void   // 왼쪽 버튼 액션 클로저
    let rightBtnAction: () -> Void  // 오른쪽 버튼 액션 클로저
    let rightBtnType: NavigationBtnType
    
    init(isDisplayLeftBtn: Bool = true, isDisplayRightBtn: Bool = true, leftBtnAction: @escaping () -> Void = {}, rightBtnAction: @escaping () -> Void = {}, rightBtnType: NavigationBtnType = .edit) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.rightBtnType = rightBtnType
    }
    
    var body: some View {
        HStack {
            if isDisplayLeftBtn {
                Button(action: leftBtnAction, label: { Image("leftArrow") })
            }
            
            Spacer()
            
            if isDisplayRightBtn {
                Button(
                    action: rightBtnAction,
                    label: {
                        if rightBtnType == .close {
                            Image("close")
                        } else {
                            Text(rightBtnType.rawValue)
                                .foregroundColor(.customBlack)
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}

#Preview {
    CustomNavigationBar()
}
