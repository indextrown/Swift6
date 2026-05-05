//
//  ContactService.swift
//  LMessenger
//
//  Created by 김동현 on 7/13/25.
//

/*
 후행 클로저
 - 함수의 마지막 인자로 클로저를 받을 때, 그 클로저를 함수 괄호 밖에 {} 블록으로 분리해서 작성할 수 있는 문법
 - 클로저를 간결하게 표현하고 가독성을 높이는 데 유용하다.
 
 Future
 - Future<Output, Failure>
 - 한 번 결과를 내고 끝내는 1회용 Publisher
 - 생성 시점에 비동기 작업을 실행하고 나중에 결과가 오면 promise(.success) 또는 promise(.failure)로 응답을 보낸다
 
 Future { [weak self] promise in
     // 여기서 비동기 작업 시작
 }
 - 여기서 promise는 (Result<[User], Error>) -> Void 타입의 클로저
 
 Future { [weak self] promise in
     self?.fetchContacts {
         promise($0)    // $0은 Result<[User], Error>
                        // promise()는 결과를 Future에 전달해주는 1회용 트리거, 호출된 순간 Publisher는 구독자에게 값 전송
     }
 }

 */

import Foundation
import Combine
import Contacts

enum ContactError: Error {
    case permissionDenied
}

protocol ContactServiceType {
    func fetchContaccts() -> AnyPublisher<[User], ServiceError>
}

final class ContactService: ContactServiceType {
    // 연락처도 combine을 제공하지 않기 때문에 completion으로 작업후 future로 만들어준다
    /// - Returns: Combine의 Future를 사용해 비동기 클로저를 퍼블리셔로 변환
    /// 연락처 퍼블리셔 반환(비동기 클로저 기반 함수를 Combine의 Publisher로 변환)
    /// 기존에는 completion 방식이어서 Combine 체인이 쓸 수 없다
    /// Future를 이용하면 1회성 비동기 작업을 Publisher로 감쌀 수 있다
    func fetchContaccts() -> AnyPublisher<[User], ServiceError> {
        Future { [weak self] promise in // (Result<[User], any Error>) -> Void // Future<[User], Error>
            self?.fetchContacts {
                promise($0)
            }
        }
        .mapError { .error($0) }  // Error -> ServiceError
        .eraseToAnyPublisher()
    }
    
    /// 연락처 퍼블리셔 반환
    /// - Parameter completion: 비동기 작업 결과를 반환하는 클로저
    private func fetchContacts(completion: @escaping (Result<[User], Error>) -> Void) {
        let store = CNContactStore()
        
        // 권한 요청 - Info.plist에서 추가하기
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            if let error {
                completion(.failure(error))
            }
            
            // 권한이 없다면
            guard granted else {
                completion(.failure(ContactError.permissionDenied))
                return
            }
            
            // TODO: - 유저 연락처 정보 가져오기
            self?.fetchContacts(store: store, completion: completion)
        }
    }
    
    
    /// 실제 연락처 정보를 가져오는 메서드
    /// - Parameters:
    ///   - store: CNContactStore 인스턴스
    ///   - completion: 연락처 조회 결과 클로저
    private func fetchContacts(store: CNContactStore, completion: @escaping (Result<[User], Error>) -> Void) {
        let keyToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        let request = CNContactFetchRequest(keysToFetch: keyToFetch)
        
        var users: [User] = []
        
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                
                let user: User = User(id: UUID().uuidString, name: name, phoneNumber: phoneNumber)
                users.append(user)
            }
            completion(.success(users))
        } catch {
            completion(.failure(error))
        }
    }
}

final class StubContactService: ContactServiceType {
    func fetchContaccts() -> AnyPublisher<[User], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
