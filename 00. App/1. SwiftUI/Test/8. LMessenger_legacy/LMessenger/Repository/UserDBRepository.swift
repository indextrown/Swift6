//
//  UserDBRepository.swift
//  LMessenger
//
//  Created by 김동현 on 11/1/24.
//

import Foundation
import Combine
import FirebaseDatabase
// MARK: - userdbrepository에서 함수 생성 -> userserviece가서 함수만듬.. ? -> viewmodel에서 사용

// 규격
protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>   // Combine버전
    func getUser(userId: String) async throws -> UserObject
    func updateUser(userid: String, key: String, value: Any) async throws
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
    
}

class UserDBRepository: UserDBRepositoryType {
    
    // 파이어베이스 db접근하려면 래퍼런스 객체가 필요하다
    var db: DatabaseReference = Database.database().reference()
    
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // object -> data화시킨다 -> dic만들어서 값을 -> DB에 넣는다
        Just(object)                                                     // Combine에서 **단일 값(object)**을 방출하는 퍼블리셔를 생성, UserObject를 다음 작업으로 전달
            .compactMap { try? JSONEncoder().encode($0)}                 // UserObject를 Json형식의 Data로 인코딩, 실패할경우 nil반환(UserObject -> Json 직렬화로 DB호환성 높임)
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) } // JSON -> 딕셔너리화(Firebase Realtime Database에 적합한 형태)
            // MARK: - Firebase Realtime Database에서는 데이터를 저장할 때 반드시 딕셔너리[String: Any]를 요구하기 때문
            
        
            // Realtime Database는 Combine을 제공하지 않기 때문에 flatmap으로 그 안에 future정의해서 stream을 이어주자
            /*
             Firebase Realtime Database는 Combine을 기본적으로 지원하지 않으므로, Combine 스트림과 Firebase 비동기 작업을 연결하기 위해 **Future**를 사용합니다.
             Future는 비동기 작업의 결과(성공 또는 실패)를 Combine 스트림으로 변환하는 데 사용됩니다.
             Firebase의 setValue 메서드는 클로저 기반의 비동기 작업을 제공합니다:
             
             db.child("Users").child(userId).setValue(value) { error, _ in
                 if let error = error {
                     // 실패 처리
                 } else {
                     // 성공 처리
                 }
             }
             이 방식은 Combine과 바로 호환되지 않으므로, **Combine 퍼블리셔(Publisher)**로 변환해야 Combine 스트림에서 사용할 수 있습니다.
             
             Future를 사용하는 이유
             Future는 한 번만 값을 방출하는 Combine 퍼블리셔입니다.
             Firebase와 같은 클로저 기반 비동기 작업을 Combine 스트림에 연결할 때 유용합니다.
             .flatMap { value in
                 Future<Void, Error> { [weak self] promise in
                     self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in
                         if let error {
                             promise(.failure(error)) // 실패 시
                         } else {
                             promise(.success(())) // 성공 시
                         }
                     }
                 }
             }

             
             
             */
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in // Users/userId/...
                    self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            // DBError로 에러 타입을 변환해서 퍼블리셔로 보내자
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).child(userId).getData {error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                    // DB에 해당 유저정보가 없는걸 체크할때 없으면 nil이 아닌 NSNULL을 갖고있기 떄문에 NSNULL일경우 nil을 아웃풋으로 넘겨줌
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }.flatMap { value in
            if let value {
                return Just(value)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0)}
                    .decode(type: UserObject.self, decoder: JSONDecoder())
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
            // 값이 없다면
            } else {
                return Fail(error: .emptyValue).eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    // realtimedatabase는 async를 지원한다. (비동기처리되고, 에러를 던질 수 있도록 명시한 함수)
    func getUser(userId: String) async throws -> UserObject {
        guard let value = try await self.db.child(DBKey.Users).child(userId).getData().value else {
            throw DBError.emptyValue
        }
        
        // 값을 받으면 딕셔너리 형태 -> userobject로 변환
        let data = try JSONSerialization.data(withJSONObject: value)
        let userObject = try JSONDecoder().decode(UserObject.self, from: data)
        return userObject
    }
    
    func updateUser(userid: String, key: String, value: Any) async throws {
        try await self.db.child(DBKey.Users).child(userid).child(key).setValue(value)
    }

    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                    // DB에 해당 유저정보가 없는걸 체크할때 없으면 nil이 아닌 NSNULL을 갖고있기 떄문에 NSNULL일경우 nil을 아웃풋으로 넘겨줌
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }
        // 딕셔너리형태(userID: Userobject) -> 배열형태
        .flatMap { value in
            if let dic = value as? [String: [String: Any]] {
                return Just(dic)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0)}
                    .decode(type: [String: UserObject].self, decoder: JSONDecoder()) // 형식
                    .map { $0.values.map {$0 as UserObject} }
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
            } else if value == nil {
                return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
            } else {
                return Fail(error: .invalidatedType).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
        Publishers.Zip(users.publisher, users.publisher)
            .compactMap { origin, toConvert -> (UserObject, Data)? in
                if let converted = try? JSONEncoder().encode(toConvert) {
                    return (origin, converted)
                }
                return nil
            }
            .compactMap { origin, converted -> (UserObject, Any)? in
                guard let serialized = try? JSONSerialization.jsonObject(with: converted, options: .fragmentsAllowed) else {
                    return nil
                }
                return (origin, serialized)
            }
            .flatMap { origin, serialized -> AnyPublisher<Void, DBError> in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.Users).child(origin.id).setValue(serialized) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
                .mapError { DBError.error($0) }
                .eraseToAnyPublisher()
            }
            .collect() // 모든 작업이 완료되었을 때 결합
            .map { _ in () } // Void 반환
            .eraseToAnyPublisher()
    }

//    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
//        /*
//         Users
//         user_id: [String: Any]
//         user_id: [String: Any]
//         user_id: [String: Any]
//         */
//        // 유저안에 있는 정보가 하나씩 방출되는 퍼블리셔
//        // users.publisher
//    }
    
}
