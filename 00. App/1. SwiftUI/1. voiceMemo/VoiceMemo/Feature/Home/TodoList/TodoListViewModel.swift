//
//  TodoListViewModel.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/27/24.
//

import Foundation

final class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var isEditTodoMode: Bool
    @Published var removeTodos: [Todo]
    @Published var isDisplayRemoveTodoAlert: Bool // 삭제 메시지 알림 호출하는 바인딩 역할
    
    // 삭제할 Todo 개수
    var removeTodosCount: Int {
        return removeTodos.count
    }
    
    // 커스텀 네비게이션바 오른쪽 버튼 현재모드
    var navigationBarRightBtnMode: NavigationBtnType {
        isEditTodoMode ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        isEditMode: Bool = false,
        removeTodos: [Todo] = [],
        isDisplayRemoveTodoAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditTodoMode = isEditMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}

// MARK: - 실제 로직
extension TodoListViewModel {
    
    // todolist 체크박스 탭 토글 역할
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    // 네비게이션바 우측 버튼 역할
    func navigationRightBtnTapped() {
        if isEditTodoMode {
            // 삭제될 것들이 비버있다
            if removeTodos.isEmpty {
                isEditTodoMode = false
            } else {
                // 알림을 불러준다
                setIsDisplayRemoveTodoAlert(true)
            }
        } else {
            isEditTodoMode = true
        }
    }
    
    // 알람설정 상태값 변경 로직
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    
    // 삭제해주는 동작(removeTodos에 있는 요소들과 일치하는 todos요소 삭제)
    func removeBtnTapped() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
        }
        removeTodos.removeAll()
        isEditTodoMode = false
    }
}
