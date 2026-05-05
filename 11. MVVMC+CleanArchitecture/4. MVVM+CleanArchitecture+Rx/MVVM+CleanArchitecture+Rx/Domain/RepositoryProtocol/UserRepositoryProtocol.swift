//
//  UserRepositoryProtocol.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/4/25.
//

import Foundation

public protocol UserRepositoryProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResults, NetworkError> // 유저 리스트 불러오기(원격)
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> // 전체 즐겨찾기 리스트 불러오기
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> // 코어 데이터라서 async 필요 x, 저장실패할 수 있어서 CoreDataError
    func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError>
}
