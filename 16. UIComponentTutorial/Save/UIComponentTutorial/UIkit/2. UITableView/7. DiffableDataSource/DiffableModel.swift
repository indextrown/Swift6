//
//  Model.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/14/25.
//

import Foundation
import Fakery

/*
 Hashable == Equatable(두가지 일치)
 */
struct DiffableDummyData: Hashable {
    let uuid: UUID
    let title: String
    let body: String
    
    init() {
        self.uuid = UUID()
        let faker = Faker(locale: "ko")
        let firstName = faker.name.firstName()  //=> "Emilie"
        let lastName = faker.name.lastName()    //=> "Hansen"
        
        let body = faker.lorem.paragraphs(amount: 10)
        
        self.title = "타이틀입니다: \(lastName) \(firstName)"
        self.body = "바디입니다: \(body)"
    }
    
    static func getDumies(_ count: Int = 100) -> [DiffableDummyData] {
        return (1...count).map { _ in DiffableDummyData() }
    }
    
    // Hashable 준수
    static func == (lhs: DiffableDummyData, rhs: DiffableDummyData) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    // Hashable 준수
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct DiffableDummySection: Hashable {
    let uuid: UUID
    let title: String
    let body: String
    var rows: [DiffableDummyData]
    
    init() {
        self.uuid = UUID()
        self.title = "타이틀입니다: \(uuid)"
        self.body = "바디입니다: \(uuid)"
        self.rows = DiffableDummyData.getDumies(10)
    }
    
    static func getDummies(_ count: Int = 10) -> [DiffableDummySection] {
        return (1...count).map { _ in DiffableDummySection() }
    }
    
    // Hashable 준수
    static func == (lhs: DiffableDummySection, rhs: DiffableDummySection) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    // Hashable 준수
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
