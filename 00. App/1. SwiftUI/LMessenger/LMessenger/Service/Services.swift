//
//  Services.swift
//  LMessenger
//
//  Created by 김동현 on 6/21/25.
//

import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
    var userService: UserServiceType { get set }
    var contactService: ContactServiceType { get set }
}

final class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var contactService: ContactServiceType
    
    init() {
        self.authService = AuthenticationService()
        /// 구현체와 의존성이 없으므로 다른 구현체를 주입할 수 있도록 즉 느슨한 결합을 할 수 있도록 dbRepository를프로토콜로  선언하였다
        self.userService = UserService(dbRepository: UserDBRepository())
        self.contactService = ContactService()
    }
}

final class StubServices: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var contactService: ContactServiceType
    
    init() {
        self.authService = StubAuthenticationService()
        self.userService = StubUserService()
        self.contactService = StubContactService()
    }
}
