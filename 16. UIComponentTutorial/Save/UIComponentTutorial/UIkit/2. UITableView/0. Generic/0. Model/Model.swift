//
//  Model.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/1/25.
//

import UIKit
import Fakery

// MARK: - Model
struct DummyData {
    let uuid: UUID
    let title: String
    let body: String
    
    init() {
        self.uuid = UUID()
        let faker = Faker(locale: "ko")
        let firstName = faker.name.firstName()  //=> "Emilie"
        let lastName = faker.name.lastName()    //=> "Hansen"
        
        let body = faker.lorem.paragraphs(amount: 5)
        
        self.title = "타이틀입니다: \(lastName) \(firstName)"
        self.body = "바디입니다: \(body)"
    }
    
    
    /// 더미 데이터 생성기
    /// - Parameter count: 기본 10개
    /// - Returns: DummyData
    static func getDumies(_ count: Int = 10) -> [DummyData] {
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
