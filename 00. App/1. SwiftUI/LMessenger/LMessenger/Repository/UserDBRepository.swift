//
//  UserDBRepository.swift
//  LMessenger
//
//  Created by 김동현 on 6/29/25.
//

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
}

final class UserDBRepository: UserDBRepositoryType {
    var db: DatabaseReference = Database.database().reference()
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        
        // MARK: - object -> data -> dic와 같이 데이터 변환을 컴파인 연산자를 이용하여 체이닝하여 작업
        Just(object)
            // 1. object -> data
            .compactMap { try? JSONEncoder().encode($0) }
            // 2. data -> dic
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in // Users/userId/..
                    self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }.mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).child(userId).getData { error, snapshot in
                if let error = error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }.flatMap { value in
            if let value {
                return Just(value)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: UserObject.self, decoder: JSONDecoder())
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: .emptyValue).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }.flatMap { value in
            if let dic = value as? [String: [String: Any]] {
                return Just(dic)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                    .map { $0.values.map { $0 as UserObject } } // 딕셔너리의 value인 UserObject만 뽑겠다
                    .mapError { DBError.error($0) } // 에러를 DBError로 변환
                    .eraseToAnyPublisher()
            } else if value == nil {
                return Just([])
                    .setFailureType(to: DBError.self) // Just의 기본 에러는 Never이므로 이 타입을 변경해준다
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: .invailedatedType)
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
        /*
         Users/
            user_id: [String: Any]
            user_id: [String: Any]
            user_id: [String: Any]
         */
        
        /*
         Zip 으로 Stream을 users -> 데이터화 -> 딕셔너리화 할예정
         zip의 첫번쨰 스트림은 유저 정보를 변환하지 않은 퍼블리셔, 두번째는 변환을 하는 퍼블리셔로 진행
         */
        
        // users.publisher는 users 안에 있는 정보가 하나씩 방출이 되는 퍼블리셔를 만들 수 있다
        Publishers.Zip(users.publisher, users.publisher)
            .compactMap { origin, converted in
                if let converted = try? JSONEncoder().encode(converted) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
            .compactMap { origin, converted in
                if let converted = try? JSONSerialization.jsonObject(with: converted, options: .fragmentsAllowed) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
            .flatMap { origin, converted in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.Users).child(origin.id).setValue(converted) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            /// 유저 여러 명을 저장해도 마지막 저장 작업이 끝난 시점에 퍼블리셔를 종료
            /// 따라서 결과는 가장 마지막 유저 저장 성공 여부만 알려줌
            .last()
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
}
