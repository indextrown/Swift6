//
//  Member.swift
//  MemberList
//
//  Created by 김동현 on 3/9/25.
//

/*
 데이터와 관련된 모델
 
 타입 저장 속성
 - 인스턴스에 속한게 아니라 모든 인스턴스들이 공유할 수 있는 저장 속성이다
 - 멤버의 수가 늘어날때마다 타입 저장속성을 늘리면 된다
 - 타입 저장 속성이 언제 사용되는지 공부 필요
 
 멤버와이즈 이니셜라이저
 - 구조체의 경우 생성자를 구현안하면 기본적으로 메멉와이즈 이니셜라이저가 자동으로 생성된다
 - 보유한 저장속성을 자동으로 세팅해주는 생성자를 자동으로 만들어준다
 - 생성자에 논리를 추가하기위해 멤버와이즈 이니셜라이저가 아닌 일부러 생성자를 구현하는경우도 있다
 
 lazy
 - 지연 저장 속성을 선언하면 나중에 메모리가 생긴다
 - 클로저의 실행 방식으로 실행하여 값이 리턴되면 변수에 저장한다
 - 이미지가 없다면 메모리가 낭비될 필요가 없다
 */

import UIKit

// 데이터 묶음을 만들 때 클래스는 무겁고 느림, struct 사용하자
struct Member {
    
    lazy var memberImage: UIImage? = {
        // 이름이 없다면, 시스템 사람이미지 세팅 -> nil이 아님을 보장
        guard let image = name else {
            return UIImage(systemName: "person")
        }
        // 해당이름으로 된 이미지 존재한다면 시스템 -> 이미지 로드 실패시 기본 시스템 이미지를 제공
        return UIImage(named: "\(image).png") ?? UIImage(systemName: "person")
    }()

    // 멤버의 (절대적) 순서를 위한 타입 저장 속성
    static var memberNumbers: Int = 0
    
    let memberId: Int
    var name: String?
    var age: Int?
    var phone: String?
    var address: String?
    
    init(name: String?, age: Int?, phone: String?, address: String?) {
        // 타입저장속성의 절대적 값으로 세팅한다(자동 순번)
        self.memberId = Member.memberNumbers
        
        // 저장속성을 외부에서 세팅
        self.name = name
        self.age = age
        self.phone = phone
        self.address = address
        
        // 멤버를 생성한다면 항상 타입 저장속성의 정수값을 증가
        Member.memberNumbers += 1
    }
}
