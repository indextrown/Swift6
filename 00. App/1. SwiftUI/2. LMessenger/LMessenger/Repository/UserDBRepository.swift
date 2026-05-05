//
//  UserDBRepository.swift
//  LMessenger
//
//  Created by 김동현 on 1/15/25.
//

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    // combine 방식
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    
    // async await 방식
    func getUser(userId: String) async throws -> UserObject
    func updateUser(userId: String, key: String, value: Any) async throws
    
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
}

final class UserDBRepository: UserDBRepositoryType {
    
    // MARK: - 파이어베이스 DB에 접근하려면 래퍼런스 객체가 필요하다
    // reference는 데이터베이스에서 root에 해당한다
    
    var db: DatabaseReference = Database.database().reference()
    
    /*
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // 파이어베이스에 데이터를 쓰려면 딕셔너리 형태로 넘겨야 한다
        // object > data > dict -> db에 삽입
        // 데이터 변환은 Combine연산자 이용하여(체이닝하여)작업을 진행해보자
        
        // 1. object를 stream으로 만들기 위해 Just로 만들어주자
        Just(object)
            // 2. 인코딩하는 작업을 compactMap으로 연결해주자
            /*
             첫 번째 compactMap:
             UserObject를 JSON 형식의 Data로 변환합니다.
             이 과정에서 JSONEncoder가 데이터를 인코딩하다가 실패할 경우, nil을 반환합니다.
             compactMap은 nil을 필터링해 스트림에서 제거하고, 성공적으로 인코딩된 데이터만 다음 단계로 전달합니다.
             
             두 번째 compactMap:
             JSON 형식의 Data를 Firebase에서 사용 가능한 딕셔너리([String: Any])로 변환합니다.
             JSONSerialization이 데이터를 변환하다가 실패하면 nil을 반환하므로, 역시 compactMap이 이를 제거합니다.
             */
            .compactMap { try? JSONEncoder().encode($0) }   // object > data
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) } // data > dict
        
            // 3. db에 set하는 작업 진행을 flatMap으로 진행하자
            // realtime database는 Combine제공하지 않아서 FlatMap 안에 Future를 정의해서 스트림을 이어주자
            /*
             flatMap은 스트림을 확장하거나 비동기 작업을 처리하는 데 사용됩니다.
             flatMap 안에서 Firebase에 데이터를 저장하는 작업을 비동기로 처리합니다.
             Future를 사용해 비동기 작업의 결과를 Combine 스트림에 연결합니다.
             promise(.success(())): Firebase에 성공적으로 데이터를 저장한 경우.
             promise(.failure(error)): Firebase 작업이 실패한 경우.
             
             왜 flatMap을 사용하는가?
             Firebase와 같은 비동기 작업을 Combine 스트림에서 처리하기 위해 사용합니다.
             flatMap은 비동기 작업이 완료될 때까지 기다리고, 그 결과를 스트림에 다시 연결합니다.
             이 방식으로 Firebase의 비동기 콜백을 Combine 스트림으로 통합하여 처리할 수 있습니다.
             */
            .flatMap { value in
                
                /*
                 Future
                 - 한 번만 값을 방출하는 비동기 작업을 처리하기 위해 사용
                 - 비동기 작업을 Combine 스트림으로 연결하는 다리
                 - Firebase 작업(Future) → Combine 체인에 결과 전달
                 - 결과는 성공(.success)이든 실패(.failure)든 Combine에서 처리 가능
                 
                 Future를 사용하지 않고 처리하면?
                 - Firebase 작업을 직접 처리하려면 아래처럼 복잡한 콜백 코드가 필요
                 
                 db.child("Users").child(object.id).setValue(value) { error, _ in
                     if let error = error {
                         // 에러 처리
                     } else {
                         // 성공 처리
                     }
                 }
                 
                 왜 Future를 사용하는가?

                 비동기 콜백을 Combine 스트림으로 연결
                 Firebase와 같은 비동기 콜백 기반 API를 사용하는 경우, Swift의 Result나 콜백 블록으로 처리해야 합니다.
                 이때 Future를 사용하면 해당 비동기 콜백을 Combine 퍼블리셔로 바꿀 수 있어, 체이닝이 가능해집니다.
                 한 번 결과를 내고 끝나는 작업에 적합
                 Future는 한 번만 값을 방출하고, 이후에는 완료(completion) 상태로 바뀝니다.
                 예:
                 “DB에 데이터를 쓰고, 성공하면 Void, 실패하면 Error를 리턴하겠다” → 작업이 한 번만 일어나는 경우
                 Combine 연산자와 자유롭게 결합
                 flatMap, mapError, eraseToAnyPublisher 등 다양한 Combine 연산자와 함께 사용해 스트림을 원하는 대로 조합할 수 있습니다.

                 
                 */
                Future<Void, Error> { [weak self] promise in    // Users/userId/..
                    // 4. 값이 정상적으로 세팅되거나 실패가 나면 컴풀리션으로 에러와 응답값을 준다
                    self?.db.child("Users").child(object.id).setValue(value) { error, _ in
                        // 5. 만약 에러가 있으면 promise에 failure를 넘기자
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            // Error를 DBError로 변형해서 퍼블리셔로 보낼예정
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
        //Empty().eraseToAnyPublisher()
    }
     */
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }   // object > data
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) } // data > dict
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in
                        if let error {
                            //print("[Error]", error)
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .mapError { DBError.addUserError($0) }
            //.mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).child(userId).getData {error, snapshot in
                if let error {
                    promise(.failure(DBError.getUserError(error)))
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
                    .mapError { DBError.getUserError($0) }
                    .eraseToAnyPublisher()
            // 값이 없다면
            } else {
                return Fail(error: .emptyValue).eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    // firebase realtime database는 async를 지원함(비동기 실행, 에러발생시 에러던짐)
    func getUser(userId: String) async throws -> UserObject {
        guard let value = try await self.db.child(DBKey.Users).child(userId).getData().value else { throw DBError.emptyValue }
        
        // 값을 정상적으로 받았다면 딕셔너리 형태를 userObject로 변환하자
        
        // 딕셔너리 -> 데이터화
        let data = try JSONSerialization.data(withJSONObject: value)
        let userObject = try JSONDecoder().decode(UserObject.self, from: data)
        
        return userObject
    }
    
    func updateUser(userId: String, key: String, value: Any) async throws {
        try await self.db.child(DBKey.Users).child(userId).child(key).setValue(value)
    }
    
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        // MARK: - Future로 값을 가져온다 그다음 원하는 유저 Array로 만들자
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.loadUserError(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }.flatMap { value in
            // 딕셔너리가 [String: [String: Any]] 형태인지 확인
            if let dic = value as? [String: [String: Any]] {
                // 참이면 딕셔너리 만들고 딕셔너리를 JSON 데이터로 변환
                return Just(dic)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                    // $0.values가 userObject인지 자동추론 안되므로 map을 돌려서 타입 명시
                    .map { $0.values.map { $0 as UserObject } }
                    .mapError { DBError.loadUserError($0) }
                    .eraseToAnyPublisher()
            // 데이터가 nil이라면 빈 배열을 리턴해주고 에러타입이 Never이기때문에 명시적으로 DBError로 만들어준다
            } else if value == nil {
                return Just([]).setFailureType(to: DBError.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: DBError.invalidatedType).eraseToAnyPublisher()
            }
            // 그 외에는 실패
        }.eraseToAnyPublisher()
    }
    
    /*
     - 스트림으로 users를 -> 데이터화 -> 딕셔너리화
     - 첫번째 스트림은(user_id) 유저정보를 변환하지 않는 퍼블리셔
     - 두번째 스트림은([String: Any]) 변환을 하는 퍼블리셔
     
     Users/
        user_id: [String: Any]
        user_id: [String: Any]
        user_id: [String: Any]
     */
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
 }
 




// 강의 방식
/*
class EasyUserDBRepository: UserDBRepositoryType {
    
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
*/
