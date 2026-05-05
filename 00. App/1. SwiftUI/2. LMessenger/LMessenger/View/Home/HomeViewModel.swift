//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by 김동현 on 1/14/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    enum Action {
        case load
        case requestContacts
        case presentMyProfileView
        case presentOtherProfileView(String)
    }
    
    @Published var myUser: User?
    @Published var users: [User] = []// = [.stub1, .stub2]
    @Published var phase: Phase = .notRequested
    @Published var modalDestination: HomeModalDestination?
    
    var userId: String
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            
            // 나의 정보 + 모든 유저 정보 불러오기
            /*
             getUser
             입력: userId = "123".
             출력: UserObject(id: "123", name: "John").
             */
            phase = .loading
            container.services.userService.getUser(userId: userId)
                // MARK: 1. handleEvents: handleEvents는 데이터 스트림에 영향을 주지 않고 부수 작업(예: myUser 업데이트)을 수행
                /*
                 handleEvents
                 UserObject(id: "123", name: "John")가 방출됨.
                 myUser에 John을 저장.
                 */
                .handleEvents(receiveOutput:  { [weak self] user in
                    // 방출된 UserObject를 myUser에 저장.
                    self?.myUser = user
                })
                // MARK: 2. flatMap: getUser로 얻은 현재 사용자 정보를 기반으로 새로운 퍼블리셔를 생성
                /*
                 flatMap
                 입력: UserObject(id: "123", name: "John").
                 작업: loadUsers(userId: "123") 호출.
                 출력: [UserObject(id: "234", name: "Alice"), UserObject(id: "345", name: "Bob")].
                 */
                .flatMap { user in
                    self.container.services.userService.loadUsers(userId: user.id)
                }
                // MARK: - 3. sink: users에 [Alice, Bob]
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
            
            /*
                나의 정보만 불러오는 로직
                .sink { completion in
                    
                } receiveValue: { [weak self] user in
                    self?.myUser = user
                }.store(in: &subscriptions)
             */
            
        case .requestContacts:
            container.services.contactService.fetchContacts()
                .flatMap { users in
                    self.container.services.userService.addUserAfterContact(users: users)
                }
                .flatMap { _ in
                    self.container.services.userService.loadUsers(userId: self.userId)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    // TODO: - 유저정보를db에 넣고 load
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
            
        case .presentMyProfileView:
            modalDestination = .myProfile

        case let .presentOtherProfileView(userId):
            modalDestination = .otherProfile(userId)
            
        }
    }
}
