//
//  TodoEntity.swift
//  TodoList - firebase
//
//  Created by 김동현 on 4/3/25.
//

import Foundation
//
//struct TodoEntity {
//    var refId: String
//    var todo: String
//    var isDone: Bool
//}

struct TodoEntity: Identifiable {
    var id: String { refId }
    let refId: String
    var todo: String
    var isDone: Bool
}
