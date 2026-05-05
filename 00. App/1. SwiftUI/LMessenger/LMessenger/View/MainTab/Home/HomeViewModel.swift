//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by 김동현 on 6/29/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    enum Action {
        case load
        case presentMyProfileView
        case presentOtherProfileView(String)
        case requestContacts
    }
    
    @Published var myUser: User?
    @Published var users: [User] = []
    @Published var phase: Phase = .notRequested
    @Published var modalDestination: HomeModalDestination?
    
    private var container: DIContainer
    var userId: String
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            phase = .loading
            container.services.userService.getUser(userId: userId)
                .handleEvents(receiveOutput: { [weak self] user in // receiveOutput는 이 스트림의 사이트 이펙트 느낌. 이벤트 중간에 어떤 작업을 하고싶을 때 사용
                    self?.myUser = user
                })
                .flatMap { user in
                    self.container.services.userService.loadUsers(id: user.id)
                }
                .sink { [weak self] completion in
                    // TODO: -
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
            
        case .presentMyProfileView:
            modalDestination = .myProfile
            
        case .presentOtherProfileView(let userId):
            modalDestination = .otherProfile(userId)
            
        case .requestContacts:
            container.services.contactService.fetchContaccts()
                // 서버에 유저들 업로드
                .flatMap { users in
                    self.container.services.userService.addUserAfterContact(users: users)
                }
                // 업로드된 유저들 load
                .flatMap {
                    self.container.services.userService.loadUsers(id: self.userId)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
              
            
            
//                .sink { completion in
//                    
//                } receiveValue: { [weak self] users in
//                    // TODO: - 유저들 정보를 DB에 넣고, DB를 load
//                }.store(in: &subscriptions)
            
        /*
        case .load:
            container.services.userService.getUser(userId: userId)
                .sink { completion in
                    
                } receiveValue: { [weak self] user in
                    self?.myUser = user
                    print(self?.myUser ?? "")
                }.store(in: &subscriptions )
         */
        }
    }
}
