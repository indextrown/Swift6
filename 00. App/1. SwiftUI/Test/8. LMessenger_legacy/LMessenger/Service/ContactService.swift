//
//  ContactService.swift
//  LMessenger
//
//  Created by 김동현 on 11/11/24.
//

import Foundation
import Combine
import Contacts

enum ContactError: Error {
    case permissionDenied
}

protocol ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError>
}

// 연락처는 Combine을 제공하지 않음. 그래서 컴플리션으로 작업하고 Future로 만들어주겠다
class ContactService: ContactServiceType {
    // MARK: - Publisher
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Future { [weak self] promise in
            self?.fetchContacts {
                promise($0)
            }
        }
        .mapError { .error($0) }
        .eraseToAnyPublisher()
    }
    
    // 유저의 목록을 리턴으로 받는 함수
    private func fetchContacts(completion: @escaping (Result<[User], Error>) -> Void) {
        let store = CNContactStore() // 유저 연락처인 데이터베이스이다
        
        // MARK: - 권한 추가 -> Info.plist에 추가작업
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            // 권한 없으면 리턴
            guard granted else {
                completion(.failure(ContactError.permissionDenied))
                return
            }
            
            self?.fetchContacts(store: store, completion: completion)
        }
    }
    
    // 실질적으로 유저의 연락처 정보를 가져오는 함수
    private func fetchContacts(store: CNContactStore, completion: @escaping (Result<[User], Error>) -> Void) {
        // contact의 속성을 가져올 키 선언
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
                
                let user: User = .init(id: UUID().uuidString, name: name, phoneNumber: phoneNumber)
                users.append(user)
            }
            completion(.success(users))
        } catch {
                completion(.failure(error))
        }
    }
}

class StubContactService: ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    
}
