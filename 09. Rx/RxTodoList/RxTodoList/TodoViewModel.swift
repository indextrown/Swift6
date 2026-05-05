//
//  TodoViewModel.swift
//  RxTodoList
//
//  Created by 김동현 on 4/13/25.
//

import UIKit
import RxSwift // disposeBag
import RxCocoa // tap
import FirebaseDatabase

// MARK: - 할 일 데이터 모델
struct TodoEntity {
    var refId: String
    var todo: String
    var isDone: Bool
}

final class TodoViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        // Create - 버튼탭 누르면 Todo내용도 같이 보냄
        let addTodoTapped: Observable<String>
    }
    
    struct Output {
        // Read
        let todoList: Observable<[TodoEntity]>
    }
    
    // 상태 저장소 - BehaviorRelay를 통해 View에 최신 상태를 전달
    private let todoRelay = BehaviorRelay<[TodoEntity]>(value: [])
    
    private let ref = Database.database(url: "https://indextodolist-default-rtdb.asia-southeast1.firebasedatabase.app")
        .reference().child("Todos")
    
    init() {
        getData()
        observeTodoChanged()
    }
    
    func transform(input: Input) -> Output {
        // Create
        input.addTodoTapped // 여기서 addTodoRelay.asObservable()을 받음
            .bind(onNext: { [weak self] todoText in
                guard !todoText.isEmpty else { return }
                self?.ref.childByAutoId().setValue([
                    "todo": todoText,
                    "isDone": false
                ])
            })
            .disposed(by: disposeBag)
        return Output(todoList: todoRelay.asObservable())
    }
    
    // Read - 데이터 한번만 받기
    private func getData() {
        ref.getData(completion: { error, snapshot in
            if let error = error {
                print(#fileID, #function, #line, "- 에러: \(error)")
                return
            }
            guard let snapshot = snapshot else { return }
            var todoList: [TodoEntity] = []
     
            for child in snapshot.children {
                guard let childSnapShot = child as? DataSnapshot else { return }
                let value = childSnapShot.value as? NSDictionary
                let todo = value?["todo"] as? String ?? ""
                let isDone = value?["isDone"] as? Bool ?? false
                
                let fetchedTodoEntity = TodoEntity(refId: childSnapShot.key, todo: todo, isDone: isDone)
                todoList.append(fetchedTodoEntity)
            }
            self.todoRelay.accept(todoList)
        })
    }
    
    // 실시간 데이터 감지
    private func observeTodoChanged() {
        // Create 감지
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let value = snapshot.value as? NSDictionary
            let todo = value?["todo"] as? String ?? ""
            let isDone = value?["isDone"] as? Bool ?? false
            let addedTodoEntity = TodoEntity(refId: snapshot.key, todo: todo, isDone: isDone)
         
            // 데이터 추가
            var currentList = self.todoRelay.value
            currentList.append(addedTodoEntity)
            self.todoRelay.accept(currentList)
        })
        
        // Update 감지
        ref.observe(.childChanged) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: Any],
                  let todo = value["todo"] as? String,
                  let isDone = value["isDone"] as? Bool else { return }

            let changedTodo = TodoEntity(refId: snapshot.key, todo: todo, isDone: isDone)

            var currentList = self.todoRelay.value
            if let index = currentList.firstIndex(where: { $0.refId == snapshot.key }) {
                currentList[index] = changedTodo
                self.todoRelay.accept(currentList)
            }
        }
        
        // Delete 감지
        ref.observe(.childRemoved) { [weak self] snapshot in
            guard let self = self else { return }

            var currentList = self.todoRelay.value
            currentList.removeAll { $0.refId == snapshot.key }
            self.todoRelay.accept(currentList) // ✅ Relay 업데이트 (Read)
        }
    }
    
    /// addTodo는 "버튼 탭"이라는 View의 직접적인 이벤트가 있기 때문에 Input으로
    /// update/delete/edit은 ViewModel에서 데이터만 바꾸면 되는 "결과적 동작"
    // MARK: - ✅ Update: 완료 여부 변경
    func updateIsDone(for index: Int, isDone: Bool) {
        let todo = todoRelay.value[index]
        ref.child(todo.refId).updateChildValues(["isDone": isDone])
    }

    // MARK: - ✅ Delete: 항목 삭제
    func deleteTodo(at index: Int) {
        let todo = todoRelay.value[index]
        ref.child(todo.refId).removeValue()
    }

    // MARK: - ✅ Update: 텍스트 수정
    func editTodo(at index: Int, newText: String) {
        let todo = todoRelay.value[index]
        ref.child(todo.refId).updateChildValues(["todo": newText])
    }
}

