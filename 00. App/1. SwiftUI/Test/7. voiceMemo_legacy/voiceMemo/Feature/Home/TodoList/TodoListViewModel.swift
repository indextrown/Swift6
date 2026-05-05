//
//  TodoListViewModel.swift
//  voiceMemo
//

import Foundation

class TodoListViewModel: ObservableObject {
    // MARK: - Published속성이 붙어있으면 변경될 때 뷰가 자동으로 업데이트된다
    @Published var todos: [Todo]
    @Published var isEditTodoMode: Bool
    @Published var removeTodos: [Todo]
    @Published var isDisplayRemoveTodoAlert: Bool // 삭제시 삭제할지 안할지 알림
    
    var removeTodoCount: Int {
        return removeTodos.count
    }
    
    var navigationBarRightBtnMode: NavigationBtnType {
        isEditTodoMode ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        isEditTodoMode: Bool = false,
        removeTodos: [Todo] = [],
        isDisplayRemoveTodoAlert: Bool = false
    ){
        self.todos = todos
        self.isEditTodoMode = isEditTodoMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}

// 실제 로직
extension TodoListViewModel {
    // 사용자가 할 일 항목을 선택할 때 호출
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    // 오른쪽 버튼을 누를 때 편집모드이면 삭제항목 확인 후 있으면 삭제 확인 알림을 표시한다
    // 삭제 항목이 없으면 편집 모드를 종료한다.
    // 편집 모드가 아니면 편집 모드를 활성화한다.
    func navigationRightBtnTapped() {
        if isEditTodoMode {
            if removeTodos.isEmpty {
                isEditTodoMode = false
            } else {
                // 알람을 불러준다!
                setIsDisplayRemoveTodoAlert(true)
            }
        } else {
            isEditTodoMode = true
        }
    }
    
    // 삭제 확인 알림을 표시할지 여부를 설정하는 메서드이다
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    // 할 일 삭제 선택/해제를 처리하는 함수이다.
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        // 만약 removeTodos 배열에 해당 todo가 이미 있다면, 해당 항목을 배열에서 제거
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        } else {
            // 해당 todo가 removeTodos 배열에 없다면, 배열에 추가
            removeTodos.append(todo)
        }
    }
    
    // 삭제 버튼을 눌렀을 때 실제로 선택된 항목들을 삭제하는 기능
    func removeBtnTapped() {
        // todos 배열에서 removeTodos 배열에 포함된 todo들을 모두 제거
        todos.removeAll() { todo in
            removeTodos.contains(todo)
        }
        // removeTodos 배열을 비워서, 삭제 항목 목록을 초기화
        removeTodos.removeAll()
        
        // 편집 모드를 활성화 (isEditTodoMode = true)
        isEditTodoMode = true
    }
}


/*
 
 @Published의 주요 개념
 자동 데이터 알림: 
 @Published는 값이 변경될 때 이를 자동으로 구독자에게 알립니다.
 SwiftUI에서는 @StateObject 또는 @ObservedObject와 함께 사용하여 뷰가 변경 사항을 감지하고 다시 그려지도록 만들 수 있습니다.
 
 ObservableObject와 함께 사용:
 @Published는 일반적으로 ObservableObject 프로토콜을 준수하는 클래스에서 사용됩니다. ObservableObject는 데이터 변화를 감지할 수 있는 객체를 의미하며, @Published 속성의 변화가 발생할 때 이를 자동으로 알립니다.
 
 
 언제 사용하나?
 SwiftUI에서 상태 관리를 할 때: 
 SwiftUI에서 @State는 뷰 내부의 상태를 관리하지만, 뷰 외부의 데이터 상태(특히 여러 뷰에서 공유되는 상태)를 관리하려면
 @Published와 ObservableObject를 사용합니다. 이를 통해 데이터가 변경될 때 여러 뷰에서 자동으로 UI가 업데이트되도록 할 수 있습니다.
 
 데이터 모델이 변경될 때 UI에 즉각 반영되기를 원할 때: 
 예를 들어, 사용자가 할 일 목록을 추가, 삭제 또는 수정할 때,
 그 변화를 즉시 UI에 반영해야 하는 경우 @Published를 사용해 상태를 관리하면 편리합니다.

 */
