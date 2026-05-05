//
//  NumbersView.swift
//  CombineTutorial-example
//
//  Created by 김동현 on 7/18/25.
//

import SwiftUI

/*
 @StateObject
 - 객체를 직접 생성 및 소유한다
 - 뷰가 다시 그려져도 객체는 재생성되지않는다
 - 해당 뷰에서 객체롤 초기화 및 관리를 위해 사용
 - 상태 유지에 효율적
 - 루트뷰에서 주로 사용
 - 객체를 초기화하고 SwiftUI 뷰 상태에 저장하는데 사용하는 속성 래퍼
 - 뷰가 존재하는 한 객체가 저장되고 뷰와 함께 삭제됨을 의미한다
 - 일반적으로 @StateObject를 사용하는 것은 하나의 뷰가 아닌 여러 뷰에 필요한 클래스 객체에 실용적이다
 
 @ObservedObject
 - 상태 변경시 뷰를 다시 생성
 - 객체를 외부에서 주입받음
 - 뷰가 다시 그려지면 객체도 다시 주입됨
 - 상위 뷰에서 객체를 전달받아 사용시
 - 객체가 자주 재생성됨
 - 서브뷰 또는 전달받는뷰
 
 공통점
 - observable 객체를 구독하는 property wrapper
 - 구독중인 observable 객체가 변경되면 뷰에 업데이트 시켜주는 기능
 
 차이점
 - 둘다 observableObject를 구독하여 값이 변경되면 뷰에 반영하는 property wrapper
 - 상태 변경시 @ObservedObject는 뷰를 다시 생성하지만 @StateObject는 다시 생성하지않고 동일 뷰가 사용(효율)
 - 기본적으로 @StateObject를 사용하되, 해당 프로퍼티를 subView에 주입해야 한다면 @ObservedObject로 선언하여 사용할 것
 - subView에 @StateObject를 주입하면 해당 @StateObject의 수명 주기가 두 곳에서 관리가 되므로 의존성을 줄이기 위해 @ObservedObject를 사용
 
 - https://hackernoon.com/lang/ko/Swiftuis-5-주요-속성-래퍼-및-이를-효과적으로-사용하는-방법
 - https://ios-development.tistory.com/1160
 */

struct NumbersView: View {
    
    @StateObject private var viewModel = NumbersVM()
    var body: some View {
        VStack(alignment: .trailing) {
            TextField("", text: $viewModel.number1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("", text: $viewModel.number2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("", text: $viewModel.number3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("", text: $viewModel.number4)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Divider()
            Text(viewModel.resultValue)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow)
    }
}

#Preview {
    NumbersView()
}
