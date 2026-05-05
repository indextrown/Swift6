//
//  UserListUsecase.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/4/25.
//

import Foundation

/*
 보통 하나의 큰 기능 단위 / 한 페이지 기능 단위로 usecase를 작성한다
 우리가 구현할 페이지는 유저 조회를 하는 기능을 가진 페이지 기준으로 작성
 */

// Usecase의 추상화 먼저 작성
public protocol UserListUsecaseProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResults, NetworkError> // 유저 리스트 불러오기(원격)
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> // 전체 즐겨찾기 리스트 불러오기
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> // 코어 데이터라서 async 필요 x, 저장실패할 수 있어서 CoreDataError
    func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError>
    
    // 유저리스트 - 즐겨찾기에 포함된 유저인지
    func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)]
    // 배열 -> 딕셔너리 [초성: [유저리스트]]
    func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String: [UserListItem]]
}

public struct UserListUsecase: UserListUsecaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResults, NetworkError> {
        await repository.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        repository.getFavoriteUsers()
        // .failure(.deleteError(""))
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        repository.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError> {
        repository.deleteFavoriteUser(userId: userId)
    }
    
    /// 유저의 즐겨찾기 상태를 확인
    /// - Parameters:
    ///   - fetchUsers: 전체 유저 리스트
    ///   - favoriteUsers: 즐겨찾기한 유저 리스트
    /// - Returns: 각 유저와 해당 유저가 즐겨찾기 상태인지 여부를 튜플로 반환
    public func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)] {
        
        // 배열로하면 이중반복문이라 느리니까 set으로 해주자
        let favoriteSet = Set(favoriteUsers)
        
        return fetchUsers.map { user in
            if favoriteSet.contains(user) {
                return (user: user, isFavorite: true)
            } else {
                return (user: user, isFavorite: false)
            }
        }
    }
    
    /// 리스트 -> 딕셔너리 변환
    /// - Parameter favoriteUsers: 전체 좋아요 유저 리스트
    /// - Returns: [초성: [유저리스트]]]
    public func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String : [UserListItem]] {
        // 이중반복을 돌리지 않고도 추가 가능
                                                   // 초기값
        return favoriteUsers.reduce(into: [String: [UserListItem]]()) { dict, user in
            if let firstString = user.login.first {         // 초성
                let key = String(firstString).uppercased()  // 초성 -> 대문자
                dict[key, default: []].append(user)         // 해당하는 키값의 value가 있으면 value를 리턴하고 없으면 빈배열 리턴
            }
        }
    }
}
