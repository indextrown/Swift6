//
//  ContactService.swift
//  LMessenger
//
//  Created by 김동현 on 1/21/25.
//

import Foundation
import Combine
import Contacts

// Error
enum ContactError: Error {
    case permissionDenied
}

// MARK: - 연락처도 Combine 제공하지 않아서 기존과 같이 Completion으로 작업하고 Future로 만들자
protocol ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError>
}

final class ContactService: ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Future { [weak self] promise in
            self?.fetchContacts {
                promise($0)
            }
        }
        .mapError { ServiceError.error($0) }
        .eraseToAnyPublisher()
    }
    
    // 유저의 목록을 리턴으로 받는 함수
    private func fetchContacts(completion: @escaping (Result<[User], Error>) -> Void) {
        let store = CNContactStore()
        
        // 유저 권한 요청 -> Info.plist에 권한을 추가해주자
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            // 에러가 존재한다면 리턴
            if let error {
                completion(.failure(error))
                return
            }
            
            // 권한이 없다면 리턴
            guard granted else {
                completion(.failure(ContactError.permissionDenied))
                return
            }
            
            self?.fetchContacts(store: store, completion: completion)
        }
    }
    
    // MARK: - 실질적으로 연락처 정보를 가져오는 메서드
    private func fetchContacts(store: CNContactStore, completion: @escaping (Result<[User], Error>) -> Void) {
        let keyFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        let request = CNContactFetchRequest(keysToFetch: keyFetch)
        
        // 백그라운드 스레드에서 연락처 가져오기
        DispatchQueue.global(qos: .userInitiated).async {
            var users: [User] = []
            
            do {
                try store.enumerateContacts(with: request) { contact, _ in
                    let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                    let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                    
                    let user: User = .init(id: UUID().uuidString, name: name, phoneNumber: phoneNumber)
                    users.append(user)
                }
                
                // 완료 핸들러를 메인 스레드에서 호출
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } catch {
                // 오류 발생 시에도 완료 핸들러를 메인 스레드에서 호출
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

//    private func fetchContacts(store: CNContactStore, completion: @escaping (Result<[User], Error>) -> Void) {
//        let keyFetch = [
//            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
//            CNContactPhoneNumbersKey as CNKeyDescriptor
//        ]
//        
//        let request = CNContactFetchRequest(keysToFetch: keyFetch)
//        
//        // user정보 배열
//        var users: [User] = []
//        
//        do {
//            try store.enumerateContacts(with: request) { contact, _ in
//                let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
//                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
//                
//                let user: User = .init(id: UUID().uuidString, name: name, phoneNumber: phoneNumber)
//                users.append(user)
//            }
//            completion(.success(users))
//        } catch {
//            completion(.failure(error))
//        }
//    }
         
}

final class StubContactService: ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
