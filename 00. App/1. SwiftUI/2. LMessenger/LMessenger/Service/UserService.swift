//
//  UserService.swift
//  LMessenger
//
//  Created by 김동현 on 1/15/25.
//

/*
 UserService는 UserDBRepository를 주입받아 해당 리파지토리에 접근할 수 있도록 연결하자
 
 */

import Foundation
import Combine

protocol UserServiceType {
    // MARK: - 여기는 Service Layer이므로 DTO(userObject)가 아닌 Model(user)를 받자
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError>
    func getUser(userId: String) -> AnyPublisher<User, ServiceError>
    func getUser(userId: String) async throws -> User
    func updateDescription(userId: String, description: String) async throws
    func updateProfileURL(userId: String, urlString: String) async throws
    func loadUsers(userId: String) -> AnyPublisher<[User], ServiceError>
}

final class UserService: UserServiceType {
    // MARK: - 만약 UserService가 직접적으로 UserDBRepository에 의존하고 있다면, UserDBRepository를 변경하거나 교체해야 할 때 문제가 생길 수 있다
    // let dbRepository = UserDBRepository()
    
    // MARK: - 프로토콜을 사용한 느슨한 결합 구조 (의존성이 없는 경우)
    /// 프로토콜을 사용하면?
    /// UserService는 "데이터베이스와 관련된 기능을 제공하는 객체"만 알면 됩니다.
    /// 어떤 구현체를 사용할지는 초기화할 때 결정합니다.
    /// 즉, UserDBRepository뿐만 아니라 테스트용 MockDBRepository나 새로운 FirestoreDBRepository도 쉽게 교체할 수 있습니다.
    /// 
    /// 현재 코드에서는 UserService가 UserDBRepository에 직접 의존하지 않고, UserDBRepository와 같은 동작을 보장하는 프로토콜(UserDBRepositoryType)에 의존한다.
    /// 장점: UserService는 UserDBRepository 대신 UserDBRepositoryType 프로토콜만 알면 되므로, 어떤 구현체를 주입하든 동작에 문제가 없다
    /// 아래와 같이 다른 구현체를 주입할 수 있다.
    /// let userService = UserService(dbRepository: MockDBRepository()) // 테스트용
    /// let userService = UserService(dbRepository: FirestoreDBRepository()) // 실제 환경
    private var dbRepository: UserDBRepositoryType
    
    init(dbRepository: UserDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    /*
     .map의 역할
     dbRepository.addUser(user.toObject())는 Firebase에 데이터를 저장하는 작업을 처리하며, 반환 타입은 AnyPublisher<Void, DBError>입니다.
     즉, 작업이 성공하면 Void를 방출하고, 실패하면 DBError를 방출합니다.
     하지만, 이 메서드의 반환값(addUser)은 AnyPublisher<User, ServiceError> 타입이어야 합니다.
     .map { user }는 Void 값을 사용하지 않고, 대신 성공한 경우 방출할 값을 User로 변환합니다
     */
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        dbRepository.addUser(user.toObject())
            .map { user } // dbRepository.addUser() 리턴은 Void 즉 성공유무만 확인됨 user정보필요하므로 map해준다
            //.mapError { ServiceError.error($0) } // 에러타입을 DBError -> ServiceError 변환
            .mapError { ServiceError.dbError($0) }
            .eraseToAnyPublisher()
    }
    
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        dbRepository.addUserAfterContact(users: users.map { $0.toObject() })
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        dbRepository.getUser(userId: userId)
            .map { $0.toModel() }
            .mapError { ServiceError.dbError($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> User {
        let userObject = try await dbRepository.getUser(userId: userId)
        return userObject.toModel()
    }
    
    func updateDescription(userId: String, description: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "description", value: description)
    }
    
    func updateProfileURL(userId: String, urlString: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "profileURL", value: urlString)
    }
    
    func loadUsers(userId id: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.loadUsers()
            .map { $0
                .map { $0.toModel() }
                .filter { $0.id != id }  // 나를 제외한 모든 유저 호출
            }
            .mapError { ServiceError.dbError($0) }
            .eraseToAnyPublisher()
    }
}

final class StubUserService: UserServiceType {
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        Just(.stub1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> User {
        return .stub1
    }
    
    func updateDescription(userId: String, description: String) async throws {
        
    }
    
    func updateProfileURL(userId: String, urlString: String) async throws {
        
    }
    
    func loadUsers(userId: String) -> AnyPublisher<[User], ServiceError> {
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
}
