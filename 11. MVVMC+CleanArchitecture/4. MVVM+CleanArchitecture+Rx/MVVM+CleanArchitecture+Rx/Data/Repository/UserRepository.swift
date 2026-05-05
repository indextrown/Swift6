//
//  UserRepository.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/5/25.
//

import Foundation

// MARK: - Repository는 외부 Layer(ex. Domain) 에서 데이터에 접근하기 위한 통로 역할을 한다.
// MARK: - 내부(CoreData)/외부(Network) 데이터 접근할지에 따라 Repository에서 직접 어느 곳에 데이터를 요청할지 결정해주는 역할이다.
public struct UserRepository: UserRepositoryProtocol {
    private let coreData: UserCoreDataProtocol
    private let network: UserNetworkProtocol
    init(coreData: UserCoreDataProtocol, network: UserNetworkProtocol) {
        self.coreData = coreData
        self.network = network
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResults, NetworkError> {
        return await network.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        return coreData.getFavoriteUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        return coreData.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError> {
        return coreData.deleteFavoriteUser(userId: userId)
    }
    
    
}
