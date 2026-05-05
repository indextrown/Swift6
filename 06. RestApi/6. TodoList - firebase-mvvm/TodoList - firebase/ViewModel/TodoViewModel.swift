//
//  TodoViewModel.swift
//  TodoList - firebase
//
//  Created by 김동현 on 4/3/25.
//

import Foundation
import FirebaseDatabase

final class TodoViewModel {
    private var ref: DatabaseReference?
    var todoList: [TodoEntity] = []
    
    var onUpdate: (() -> Void)?
    var onInsert: ((IndexPath) -> Void)?
    var onDelete: ((IndexPath) -> Void)?
    var onChange: ((IndexPath) -> Void)?
    
    init() {
        self.ref = Database
            .database(url: "https://indextodolist-default-rtdb.asia-southeast1.firebasedatabase.app")
            .reference().child("Todos")
        observeTodos()
    }
    
    /// Read - [한번] 할 밀 목록 불러오기
    /*
    func fetchTodos() {
        ref?.getData(completion: { [weak self] error, snapshot in
            
            if let error = error {
                print(#fileID, #function, #line, "- 에러: \(error)")
                return
            }
            
            guard let self = self else { return }
            guard let snapshot = snapshot else { return }
            
            for child in snapshot.children {
                guard let childSnapShot = child as? DataSnapshot else { return }
                let value = childSnapShot.value as? NSDictionary
                let todo = value?["todo"] as? String ?? ""
                let isDone = value?["isDone"] as? Bool ?? false
                
                let fetchedTodoEntity = TodoEntity(refId: childSnapShot.key, todo: todo, isDone: isDone)
                print(#fileID, #function, #line, "- fetchedTodoEntity: \(fetchedTodoEntity)")
                self.todoList.append(fetchedTodoEntity)
            }
            self.onUpdate?()
        })
    }
     */
    
    /// Create - 할 일 만들기
    func addTodo(_ todo: String) {
        ref?.childByAutoId()
            .setValue([
                "todo": todo,
                "isDone": false
            ])
    }
    
    /// Update - 할 일 todo 수정하기
    func updateTodo(indexPath: IndexPath, newText: String) {
        let todo = todoList[indexPath.row]
        ref?.child(todo.refId)
            .updateChildValues(["todo": newText])
    }
    
    /// Update - 할 일 isDone 수정하기
    func toggleIsDone(indexPath: IndexPath, isDone: Bool) {
        let todo = todoList[indexPath.row]
        ref?.child(todo.refId)
            .updateChildValues(["isDone": isDone])
    }
    
    /// Delete - 할 일 지우기
    func deleteTodo(indexPath: IndexPath) {
        let todo = todoList[indexPath.row]
        ref?.child(todo.refId).removeValue()
    }
    
    private func observeTodos() {
        
        // MARK: - 데이터 추가가 일어났을때만 받겠다
        ref?.observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let self = self else { return }
            let value = snapshot.value as? NSDictionary
            let todo = value?["todo"] as? String ?? ""
            let isDone = value?["isDone"] as? Bool ?? false
            let addedTodoEntity = TodoEntity(refId: snapshot.key, todo: todo, isDone: isDone)
            
            // 1. 데이터 추가
            self.todoList.append(addedTodoEntity)
           
            // 2. UI 업데이트
            let appendingIndexPath = IndexPath(row: self.todoList.count - 1, section: 0)
            self.onInsert?(appendingIndexPath)
        })
        
        
        // MARK: - 데이터 삭제가 일어났을때만 받겠다
        ref?.observe(.childRemoved, with: { [weak self] (snapshot) -> Void in
            guard let self = self else { return }
            guard let index: Int = self.todoList.firstIndex(where: {$0.refId == snapshot.key}) else { return }
            
            // 1. 데이터 추가
            self.todoList.remove(at: index)
            let removingIndexPath = IndexPath(row: index, section: 0)
            
            // 2. UI 업데이트
            self.onDelete?(removingIndexPath)
        })
        
        // MARK: - 데이터 변경이 일어났을때만 받겠다
        ref?.observe(.childChanged, with: { [weak self] (snapshot) -> Void in
            guard let self = self else { return }
            let value = snapshot.value as? NSDictionary
            let todo = value?["todo"] as? String ?? ""
            let isDone = value?["isDone"] as? Bool ?? false
            let changedTodoEntity = TodoEntity(refId: snapshot.key, todo: todo, isDone: isDone)
            guard let index: Int = self.todoList.firstIndex(where: {$0.refId == snapshot.key}) else { return }
            
            // 1. 데이터 변경
            self.todoList[index] = changedTodoEntity
            let changingIndexPath = IndexPath(row: index, section: 0)
            
            // 2. UI 업데이트
            self.onChange?(changingIndexPath)
        })
    }
}
