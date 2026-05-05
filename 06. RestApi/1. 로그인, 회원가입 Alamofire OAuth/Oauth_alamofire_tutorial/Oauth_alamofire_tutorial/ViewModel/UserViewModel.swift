//
//  UserViewModel.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import Foundation
import Alamofire
import Combine

class UserViewModel: ObservableObject {
    
    // MARK: - Properties
    var subscription = Set<AnyCancellable>()
    
    @Published var loggedInUser: UserData? = nil
    
    @Published var users: [UserData] = []
    
    // MARK: - PassthroughSubject는 데이터를 물고 있는게 아니라 단방향으로 데이터스트림에서 데이터를 한번만 보내게되서 아무것도 안보내려면 <(), Never>
    
    // 회원가입 완료 이벤트
    var registrationSuccess = PassthroughSubject<(), Never>()
    
    // 로그인 완료 이벤트
    var loginSuccess = PassthroughSubject<(), Never>()
    
    /// 회원가입하기
    func register(name: String, email: String, password: String) {
        print("UserViewModel - register() called")
        
        AuthApiService.register(name: name, email: email, password: password)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("UserViewModel completion: \(completion)")
            } receiveValue: { (receivedUser: UserData) in
                self.loggedInUser = receivedUser
                self.registrationSuccess.send()
            }.store(in: &subscription)   // 데이터를 sink를 통해서 구독을 했다면 메모리에 날려줘야하기 떄문에 store로 subscription이라는 Set<AnyCancellable>에 담아서 처리를한다
    }
    
    /// 로그인하기
    func login(email: String, password: String) {
    print("UserViewModel - login() called")
    
    AuthApiService.login(email: email, password: password)
        .sink { (completion: Subscribers.Completion<AFError>) in
            print("UserViewModel completion: \(completion)")
        } receiveValue: { (receivedUser: UserData) in
            self.loggedInUser = receivedUser
            self.loginSuccess.send()
        }.store(in: &subscription)   // 데이터를 sink를 통해서 구독을 했다면 메모리에 날려줘야하기 떄문에 store로 subscription이라는 Set<AnyCancellable>에 담아서 처리를한다
    }
    
    /// 현재 사용자 정보 가져오기
    func fetchCurrentUserInfo() {
        print("UserViewModel - fetchCurrentUserInfo() called")
        UserApiService.fetchCurrentUserInfo()
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("UserViewModel fetchCurrentUserInfo completion: \(completion)")
                if case .failure(let error) = completion {
                    print("Error fetching user info: \(error)")
                    // 여기서 에러 처리 (예: 로그인 화면으로 이동)
                }
            } receiveValue: { (receivedUser: UserData) in
                print("UserVM fetchCurrentUserInfo receivedUser: \(receivedUser)")
                self.loggedInUser = receivedUser
            }.store(in: &subscription)
    }
    
    /// 모든 사용자 가져오기
    func fetchUsers() {
        print("UserViewModel - fetchCurrentUserInfo() called")
        UserApiService.fetchUsers()
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("UserViewModel fetchCurrentUserInfo completion: \(completion)")
                if case .failure(let error) = completion {
                    print("Error fetching user info: \(error)")
                    // 여기서 에러 처리 (예: 로그인 화면으로 이동)
                }
            } receiveValue: { (fetchedUsers: [UserData]) in
                print("UserVM fetchCurrentUserInfo receivedUser.count: \(fetchedUsers.count)")
                self.users = fetchedUsers
            }.store(in: &subscription)
    }
//    func fetchCurrentUserInfo() {
//        UserApiService.fetchCurrentUserInfo()
//            .sink(receiveCompletion: { completion in
//                 switch completion {
//                 case .finished:
//                     print("API call finished successfully")
//                 case .failure(let error):
//                     print("API call failed with error: \(error)")
//                 }
//            }, receiveValue: { user in
//                 print("Fetched user: \(user)")
//            })
//            .store(in: &subscription) // 구독을 유지하기 위한 cancel bag
//
//    }
}
