//
//  MockUserRepository.swift
//  MVVM+CleanArchitecture+RxTests
//
//  Created by 김동현 on 4/5/25.
//

import Foundation
@testable import MVVM_CleanArchitecture_Rx

public struct MockUserRepository: UserRepositoryProtocol {
    public func fetchUser(query: String, page: Int) async -> Result<MVVM_CleanArchitecture_Rx.UserListResults, MVVM_CleanArchitecture_Rx.NetworkError> {
        .failure(.dataNil)
    }
    
    public func getFavoriteUsers() -> Result<[MVVM_CleanArchitecture_Rx.UserListItem], MVVM_CleanArchitecture_Rx.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    public func saveFavoriteUser(user: MVVM_CleanArchitecture_Rx.UserListItem) -> Result<Bool, MVVM_CleanArchitecture_Rx.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    public func deleteFavoriteUser(userId: Int) -> Result<Bool, MVVM_CleanArchitecture_Rx.CoreDataError> {
        .failure(.entityNotFound(""))
    }
}
