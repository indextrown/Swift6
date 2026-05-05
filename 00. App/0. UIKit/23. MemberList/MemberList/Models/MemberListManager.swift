//
//  MemberListManager.swift
//  MemberList
//
//  Created by 김동현 on 3/9/25.
//

import Foundation

/*
MemberListManager
 - 데이터 매니저(관리자) 역할
 - 데이터 배열을 보유, 데이터 배열을 뷰컨트롤러에 전달가능, 비즈니스 로직을 담을 수 있음
 - 비즈니스 로직을 관리하는 데이터 모델이다
*/

final class MemberListManager {
    
    private var membersList: [Member] = []
    
    // 서버와의 통신으로 받아온 데이터 대체 하드코딩
    func makeMemberListCreate() {
        membersList = [
            Member(name: "홍길동", age: 20, phone: "010-1111-2222", address: "서울"),
            Member(name: "임꺽정", age: 23, phone: "010-2222-3333", address: "서울"),
            Member(name: "스티브", age: 50, phone: "010-1234-1234", address: "미국"),
            Member(name: "쿡", age: 30, phone: "010-7777-7777", address: "캘리포니아"),
            Member(name: "베조스", age: 50, phone: "010-2222-7777", address: "하와이"),
            Member(name: "배트맨", age: 40, phone: "010-3333-1234", address: "고담씨티"),
            Member(name: "조커", age: 40, phone: "010-4321-1234", address: "고담씨티")
        ]
    }
    
    // 새로운 멤버 만들기 - create
    func makeNewMember(_ member: Member) {
        membersList.append(member)
    }
    
    // 전체 멤버 리스트 받기 - read
    func getMemberList() -> [Member] {
        return membersList
    }
    
    // 기존 멤버의 정보 업데이트 - update
    func updateMember(index: Int, _ member: Member) {
        membersList[index] = member
    }
    
    // 특정 멤버 얻기 (굳이 필요 없지만 서브스크립트 구현해보기)
    subscript(index: Int) -> Member {
        get {
            return membersList[index]
        }
        set {
            membersList[index] = newValue
        }
    }
}
