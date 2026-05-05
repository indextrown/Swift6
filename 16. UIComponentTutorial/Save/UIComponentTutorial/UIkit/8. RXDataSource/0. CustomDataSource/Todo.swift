//
//  Todo.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 8/3/25.
//

import Fakery
import UIKit

// MARK: - Model
struct Todo {
    let id: Int
    let title: String
    var isDone: Bool
    
    init(id: Int = 00, title: String = "00", isDone: Bool = false) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
    
    static func getDumies(_ count: Int = 10) -> [Todo] {
        let faker = Faker(locale: "ko")
        return (1...count).map { id in
            let firstName = faker.name.firstName()
            let lastName = faker.name.lastName()
            let title = "\(lastName) \(firstName)"
            return Todo(id: id, title: title, isDone: false)
        }
    }
}


struct Todo2 {
    let id: UUID = UUID()
    let title: String
    var isDone: Bool
    
    init(title: String? = nil, isDone: Bool = false) {
        self.title = title ?? "타이틀: \(id.uuidString.prefix(3))"
        self.isDone = isDone
    }
    
    static func getDumies(_ count: Int = 10) -> [Todo2] {
        return (0..<count).map { _ in Todo2() }
    }
}


// MARK: -
import RxDataSources

struct SectionOfTodo {
    var header: String
    var footer: String
    var items: [Item]
}

extension SectionOfTodo: SectionModelType {
    typealias Item = Todo
    
    init(original: SectionOfTodo, items: [Item]) {
        self = original
        self.items = items
    }
}
