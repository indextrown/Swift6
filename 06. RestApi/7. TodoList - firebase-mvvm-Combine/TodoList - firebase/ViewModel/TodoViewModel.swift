//
//  TodoViewModel.swift
//  TodoList - firebase
//
//  Created by 김동현 on 4/3/25.
//

import Foundation
import FirebaseDatabase
import Combine

final class TodoViewModel {
    private var ref: DatabaseReference?
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var todoList: [TodoEntity] = []

    let insertSubject = PassthroughSubject<IndexPath, Never>()
    let deleteSubject = PassthroughSubject<IndexPath, Never>()
    let updateSubject = PassthroughSubject<IndexPath, Never>()
    let reloadTrigger = PassthroughSubject<Void, Never>()

    private var isInitialLoadFinished = false
    private var initialSnapshotCount = 0
    private var loadedCount = 0

    init() {
        ref = Database.database(url: "https://indextodolist-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("Todos")
        observeTodos()
    }

    func addTodo(_ todo: String) {
        ref?.childByAutoId().setValue(["todo": todo, "isDone": false])
    }

    func updateTodo(indexPath: IndexPath, newText: String) {
        let todo = todoList[indexPath.row]
        ref?.child(todo.refId).updateChildValues(["todo": newText])
    }

    func toggleIsDone(indexPath: IndexPath, isDone: Bool) {
        let todo = todoList[indexPath.row]
        ref?.child(todo.refId).updateChildValues(["isDone": isDone])
    }

    func deleteTodo(indexPath: IndexPath) {
        let todo = todoList[indexPath.row]
        ref?.child(todo.refId).removeValue()
    }

    private func observeTodos() {
        // ✅ self.todoList 초기화는 여기서 직접 해줌 (childAdded에 의존 X)
        ref?.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self else { return }

            var initialList: [TodoEntity] = []
            for child in snapshot.children {
                guard let snap = child as? DataSnapshot,
                      let value = snap.value as? NSDictionary else { continue }
                let todo = value["todo"] as? String ?? ""
                let isDone = value["isDone"] as? Bool ?? false
                let entity = TodoEntity(refId: snap.key, todo: todo, isDone: isDone)
                initialList.append(entity)
            }

            self.todoList = initialList
            self.isInitialLoadFinished = true
            self.reloadTrigger.send()
        })

        ref?.observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            let value = snapshot.value as? NSDictionary
            let todo = value?["todo"] as? String ?? ""
            let isDone = value?["isDone"] as? Bool ?? false
            let addedTodo = TodoEntity(refId: snapshot.key, todo: todo, isDone: isDone)
            self.todoList.append(addedTodo)
            self.loadedCount += 1

            if self.loadedCount == self.initialSnapshotCount {
                self.isInitialLoadFinished = true
                self.reloadTrigger.send()
                return
            }

            if self.isInitialLoadFinished {
                let indexPath = IndexPath(row: self.todoList.count - 1, section: 0)
                self.insertSubject.send(indexPath)
            }
        }

        ref?.observe(.childRemoved) { [weak self] snapshot in
            guard let self = self else { return }
            guard let index = self.todoList.firstIndex(where: { $0.refId == snapshot.key }) else { return }
            self.todoList.remove(at: index)
            self.deleteSubject.send(IndexPath(row: index, section: 0))
        }

        ref?.observe(.childChanged) { [weak self] snapshot in
            guard let self = self else { return }
            let value = snapshot.value as? NSDictionary
            let todo = value?["todo"] as? String ?? ""
            let isDone = value?["isDone"] as? Bool ?? false
            let changed = TodoEntity(refId: snapshot.key, todo: todo, isDone: isDone)
            guard let index = self.todoList.firstIndex(where: { $0.refId == snapshot.key }) else { return }
            self.todoList[index] = changed
            self.updateSubject.send(IndexPath(row: index, section: 0))
        }
    }
}
