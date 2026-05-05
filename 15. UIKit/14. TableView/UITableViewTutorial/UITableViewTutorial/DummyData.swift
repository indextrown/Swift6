//
//  DummyData.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/8/25.
//

import Foundation
import Fakery

struct DummySection {
    let uuid: UUID
    let title: String
    let body: String
    let rows: [DummyData]
    
    init() {
        self.uuid = UUID()
        self.title = "섹션 타이틀입니다: \(uuid)"
        self.body = "섹션 바디입니다: \(uuid)"
        self.rows = DummyData.getDumies(10)
    }
    
    static func getDummies(_ count: Int = 100) -> [DummySection] {
        return (1...count).map { _ in DummySection() }
    }
}

struct DummyData {
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
    
    static func getDumies(_ count: Int = 100) -> [DummyData] {
        return (1...count).map { _ in DummyData() }
    }
}

struct IndexData {
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
    
    static func getDumies(_ count: Int = 100) -> [IndexData] {
        return (1...count).map { _ in IndexData() }
    }
}
