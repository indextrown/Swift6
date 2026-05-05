//
//  MyProfileDescEditView.swift
//  LMessenger
//
//  Created by 김동현 on 11/18/24.
//

import SwiftUI

/*
 NavigationStack
 - 기존의 NavigationView를 대체하며, 가열, 유연한 방식으로 화면 간 네비게이션 관리한다
 - NavigationStack은 화면의 경로를 추적하고, 스택 데이터 구조를 기반으로 화면 이동(push)과 뒤로 가기(pop)를 구현한다
 */
struct MyProfileDescEditView: View {
    
    // 클로저 정의
    // 상태메시지 입력 완료 후 수행할 작업을 외부에서 정의할 수 있도록 제공
    // 화면 외부에서 작업 완료 후 실행할 동작(예: 서버 저장)을 정의할 수 있다
    /*
     클로저는 코드 블록으로, 특정 동작을 캡슐화하여 전달, 또는 나중에 실행할 수 있는 기능이다
     함수와 유사하지만 익명 함수로 사용된다
     
     // 일반 함수
     func sayHello() {
         print("Hello!")
     }

     // 클로저
     let sayHelloClosure = {
         print("Hello!")
     }
     
     클로저를 사용하는 이유
     코드 전달:
     클로저를 사용하면 코드 블록을 다른 함수나 메서드로 전달할 수 있습니다.
     예: 네트워크 요청 완료 후 결과를 처리.
     간결함:
     클로저는 코드의 중복을 줄이고 간결하게 작성할 수 있습니다.
     비동기 작업:
     클로저는 비동기 작업(네트워크 요청, 애니메이션 등)에서 작업 완료 후의 동작을 처리하는 데 유용합니다.
     유연성:
     클로저는 데이터를 캡처(저장)하거나 동적으로 동작을 정의할 수 있어 코드의 유연성을 제공합니다.
     
     let sum: (Int, Int) -> Int = { a, b in
         return a + b
     }

     let result = sum(3, 5) // 결과: 8

     
     func performOperation(_ a: Int, _ b: Int, operation: (Int, Int) -> Int) -> Int {
         return operation(a, b)
     }

     let result = performOperation(4, 2) { $0 * $1 } // 클로저 전달
     print(result) // 출력: 8

     func fetchData(completion: @escaping (String) -> Void) {
         DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
             completion("Data received!")
         }
     }

     fetchData { result in
         print(result) // 출력: "Data received!"
     }

     
     @escaping 키워드
     클로저가 함수가 종료된 후에도 실행될 가능성이 있으면 @escaping 키워드를 사용해야 합니다.
     
     
     결론
     클로저는 Swift에서 유연한 코드 전달 및 비동기 작업 처리를 위한 강력한 도구입니다.
     언제 사용하나요?

     코드 블록을 함수로 전달하거나 실행을 나중으로 미루고 싶을 때.
     비동기 작업(네트워크 요청, 애니메이션, 고차 함수 등)을 처리할 때.
     왜 사용하나요?

     코드를 간결하고 유연하게 작성하기 위해.
     상태나 데이터를 저장(Capture)하거나, 비동기 작업의 결과를 처리하기 위해.
     클로저는 Swift 프로그래밍에서 매우 자주 사용되므로, 기본 개념부터 실제 사례까지 익혀두는 것이 중요합니다!
     
     */
    @Environment(\.dismiss) var dismiss
    @State var description: String
    var onCompleted: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("상태메시지를 입력해주시요", text: $description)
                    // 사용자가 입력하는 텍스트를 TextField 내에서 가운데 정렬
                    .multilineTextAlignment(.center)
            }
            .toolbar {
                Button {
                    dismiss()
                    onCompleted(description)
                } label: {
                    Text("완료")
                }
                .disabled(description.isEmpty) // 비어있으면 버튼 비활성화
            }
        }
    }
}

#Preview {
    MyProfileDescEditView(description: "") { _ in
        
    }
}
