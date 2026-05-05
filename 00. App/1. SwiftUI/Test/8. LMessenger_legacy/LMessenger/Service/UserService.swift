//
//  UserService.swift
//  LMessenger
//
//  Created by 김동현 on 11/1/24.
//

import Foundation
import Combine

protocol UserServiceType {
    // MARK: - 여기는 서비스 layer이기 때문에 DTO가 아닌 User모델을 받도록 하자
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError>
    func getUser(userId: String) -> AnyPublisher<User, ServiceError>
    func getUser(userId: String) async throws -> User
    func updateDescription(userId: String, description: String) async throws
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError>
    
}

class UserService: UserServiceType {
    
    
    private var dbRepository: UserDBRepositoryType
    
    init(deRepository: UserDBRepositoryType) {
        self.dbRepository = deRepository
    }
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        dbRepository.addUser(user.toObject())
            .map { user }                   // 저장 작업 성공시 원래의 User데이털르 반환(이유: 서비스 계층에서는 앱에서 사용하는 User모델을 반환해야 한다)
            .mapError { .error($0) }        // 저장 작업 중 발생한 오류를 ServiceError로 변환(이유: 서비스 계층에서는 데이터베이스 오류를 직접 노출하지 않고, 서비스에 적합한 에러 형태로 변환하여 ViewModel이나 UI에 전달)
            .eraseToAnyPublisher()          // Combine에서 사용되는 퍼블리셔의 세부적인 타입을 숨기고, 호출자에게 AnyPublisher로 반환한다(이유: 메서드가 퍼블리셔의 구체적인 타입에 의존하지 않도록 추상화)
    }
    
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        dbRepository.addUserAfterContact(users: users.map { $0.toObject() })
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        dbRepository.getUser(userId: userId)
            .map { $0.toModel() }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> User {
        let userObject = try await dbRepository.getUser(userId: userId)
        return userObject.toModel()
    }
    
    func updateDescription(userId: String, description: String) async throws {
        try await dbRepository.updateUser(userid: userId, key: "description", value: description)
    }
    
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.loadUsers()
            .map { $0
                .map { $0.toModel() }
                .filter { $0.id != id }
            }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
}

class StubUserService: UserServiceType {
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
    
    // User에 세팅한 더미 데이터를 가져옴
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError> {
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()  
    }
}

// 실제 구현체와 의존성이 없으므로 실제 유저DB 리퍼지토리가 아닌 다른 구현체에도 주입을 할 수가 있고
// 느슨한 결합을 하기 위해 사용..
