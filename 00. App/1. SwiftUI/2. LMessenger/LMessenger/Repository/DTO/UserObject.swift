//
//  UserObject.swift
//  LMessenger
//
//  Created by 김동현 on 1/15/25.
//

/*
 MARK: - DTO: DB에 DB값을 넣기 위한 규격이다
 MARK: - UserObject는 유저 관련 DTO이다
 - 참고적으로 이 프로젝트에서는 Model(User)랑 DTO(UserObject)랑 규격이 다르지 않다
 - 하지만 실무적 구성을 위해 도입하였다
 
 codable
 - json 인코더를 통해 이 object를 데이터화 시킬 수 있다
 - 그리고나서 이 데이터를 jsonserization을 통해 딕셔너리로 만들어서 값을 파이어베이스 db에 넣을 것이다
 */
import Foundation


struct UserObject: Codable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}

extension UserObject {
    func toModel() -> User {
        .init(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            profileURL: profileURL,
            description: description
        )
    }
}
