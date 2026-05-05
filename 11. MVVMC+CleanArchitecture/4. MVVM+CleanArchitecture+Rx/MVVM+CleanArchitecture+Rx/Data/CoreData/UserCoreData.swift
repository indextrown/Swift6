//
//  UserCoreData.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/4/25.
//

import Foundation
import CoreData

// MARK: - UserListUsecaseProtocol에서 CoreData관련 부분만 가져오면 된다,
public protocol UserCoreDataProtocol {
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> // 전체 즐겨찾기 리스트 불러오기
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> // 코어 데이터라서 async 필요 x, 저장실패할 수 있어서 CoreDataError
    func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError>
}

// MARK: - CRUD
public struct UserCoreData: UserCoreDataProtocol {
    private let viewContext: NSManagedObjectContext
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    /// 즐겨찾기 유저 가져오기
    /// - Returns: 유저 리스트
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            let userList: [UserListItem] = result.compactMap { favoriteUser in
                guard let login = favoriteUser.login, let imageURL = favoriteUser.imageURL else { return nil }
                return UserListItem(id: Int(favoriteUser.id), login: login, imageURL: imageURL)
            }
            return .success(userList)
        } catch {
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    /// 유저 즐겨찾기 추가
    /// - Parameter user: 코어데이터 유저 구조체
    /// - Returns: 성공여부
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        guard let eneity = NSEntityDescription.entity(forEntityName: "FavoriteUser", in: viewContext) else { return .failure(.entityNotFound("FavoriteUser")) }
        let userObject = NSManagedObject(entity: eneity, insertInto: viewContext)
        userObject.setValue(user.id, forKey: "id")
        userObject.setValue(user.login, forKey: "login")
        userObject.setValue(user.imageURL, forKey: "imageURL")
        
        do {
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.saveError(error.localizedDescription))
        }
    }
    
    
    /// 유저 즐겨찾기 제거
    /// - Parameter userId: 제거할 유저 Id
    /// - Returns: 성공여부
    public func deleteFavoriteUser(userId: Int) -> Result<Bool, CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", userId) // Id가 동일한 객체만 가져온다
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach { favoriteUser in
                viewContext.delete(favoriteUser)
            }
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.deleteError(error.localizedDescription))
        }
    }
}
