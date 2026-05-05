//
//  Services.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

import Foundation

// MARK: - 서비스 계층의 프로토콜 정의
/// 서비스 계층의 표준을 정의하는 프로토콜
/// 각 서비스는 반드시 'authService'와 'userService'를 포함해야 한다
protocol ServiceType {
    
    var authService: AuthenticationServiceType { get set }  // 인증 서비스 (로그인, 회원가입 등 처리)
    var userService: UserServiceType { get set }            // 인증 서비스 (로그인, 회원가입 등 처리)
    var contactService: ContactServiceType { get set }
    var photoPickerService: PhotoPickerServiceType { get set }
    var uploadService: UploadServiceType { get set }
    var imageCacheService: ImageCacheServiceType { get set }
}

// MARK: - 실제 구현체 (Services)
/// `ServiceType`의 실제 구현체
/// 실제 서비스와 데이터베이스 연결을 처리
final class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var contactService: ContactServiceType
    var photoPickerService: PhotoPickerServiceType
    var uploadService: UploadServiceType
    var imageCacheService: ImageCacheServiceType
    
    init() {
        self.authService = AuthenticationService()
        
        // userService에 대한 상세 설명
        // - `UserService`는 사용자 데이터를 관리하는 역할
        // - `dbRepository`로 실제 데이터베이스와의 의존성을 주입함

        // [프로토콜로 설정한 이유]
        // - 실제 구현체와 의존성이 없으므로 `UserDBRepository` 대신 다른 구현체를 주입 가능
        // - 느슨한 결합을 통해 테스트 및 유지보수 용이
        self.userService = UserService(dbRepository: UserDBRepository())
        self.contactService = ContactService()
        self.photoPickerService = PhotoPickerService()
        self.uploadService = UploadService(provider: UploadProvider())
        self.imageCacheService = ImageCacheService(memoryStorage: MemoryStorage(), diskStorage: DiskStorage())
    }
}

// MARK: - 테스트용 스텁 구현체 (StubServices)
/// `ServiceType`의 스텁(Stub) 구현체
/// 테스트 환경에서 사용되며, 실제 데이터베이스 대신 가짜 데이터를 제공
final class StubServices: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var contactService: ContactServiceType = ContactService()
    var photoPickerService: PhotoPickerServiceType = PhotoPickerService()
    var uploadService: UploadServiceType = UploadService(provider: UploadProvider())
    var imageCacheService: ImageCacheServiceType = ImageCacheService(memoryStorage: MemoryStorage(), diskStorage: DiskStorage())
}

