//
//  UserListViewModel.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/5/25.
//

import Foundation
import RxSwift
import RxCocoa // bind를 위함

protocol UserListViewModelProtocol {
    func transform(input: UserListViewModel.Input) -> UserListViewModel.Output
}

public final class UserListViewModel: UserListViewModelProtocol {
    private let usecase: UserListUsecaseProtocol
    
    // 내부 프로퍼티 값으로 Rx를 사용할것이라서 DisposeBag가 필요하다
    // transform()처럼 바인딩이 있는 곳은 DisposeBag가 필요하다
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    
    // API, CoreData에러가 발생시 VC에서 에러 메시지 전달을 위해 Relay형태로 정의
    // MARK: - Relay를 사용하는 이유는 VC에 전달해서 UI적인 요소로 사용하기 때문에 Subject는 에러타입을 던져주지만 Relay는 에러가 없고, data를 VC에게 전달하기 위한 목적(Main thread)
    // MARK: - BehaviorRelay는 내부족으로 값을 접근해야할 때 사용한다. 아니면 PublishRelay쓰면된다.
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])       // api 호출로 받은 유저리스트
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // fetchUser 즐겨찾기 여부를 위한 전체목록/전체 즐겨찾기 유저 리스트 (검색어와 관계없이 저장)
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: [])    // 검색어에 따라 필터링된 즐겨찾기 유저 리스트
    private var page: Int = 1
    
    public init(usecase: UserListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    // 이벤트(VC에서 받음) -> 가공 or 외부에서 데이터 호출 or 상태값같은 뷰 데이터를 전달(ViewModel의 역할)
    // Input Out Pattern: MVVM을 구현하는 여러 방식 중하나. ViewModel과 ViewController의 각각의 역할과 협동을 명시적으로 나타내는 패턴이라고 생각
    public struct Input { // VM에게 전달 되어야 할 이벤트
        // 탭, 텍스트필드, 즐겨찾기 추가 or 삭제, 페이지네이션 Observable(옵저버블을 VC에 전달하여 VC가 이를 구독하여 사용할 수 있도록 하여 동적인 프로그래밍 가능하도록 구현)
        let tabButtonType: Observable<TabButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int>
        let fetchMore: Observable<Void>
    }
    
    public struct Output { // VC에게 전달할 뷰 데이터
        // cell data(유저 리스트)
        // error
        let cellData: Observable<[UserListCellData]>
        let error: Observable<String>
    }
    
    // 상단 텍스트필드 입력시
    // 하단 API탭 / 즐겨찾기 탭 둘다 영향 가야함
    
    // MARK: - Input에서 해당하는 Input 값이 발생시 필요한 기능을 나열
    // VC에서 이벤트 전달이 되면 VM데이털 반환해주는 역할
    public func transform(input: Input) -> Output { // VC이벤트 -> VM데이터
        // MARK: - weak사용 이유: 강하게 참조를 막아서 순환 참조를 막기 위함
        input.query.bind { [weak self] query in
            
            // TODO: -  user Fetch and get favorite Users 둘다
            
            // query가 유효하지 않다면 빈쿼리로 호출
            /*
            guard let isValidate = self?.validateQuery(query: query), isValidate else {
                self?.getFavoriteUsers(query: "")
                return
            }
             */
            guard let self = self, validateQuery(query: query) else {
                self?.getFavoriteUsers(query: "")
                return
            }
            
            page = 1
            // 유효한 쿼리시 진행
            self.fetchUsers(query: query, page: 0)
            self.getFavoriteUsers(query: query)
            
        }.disposed(by: disposeBag)
        
        input.saveFavorite
            // 이벤트 발생시 값을 가져올 수 있다
            .withLatestFrom(input.query, resultSelector: { users, query in
                return (users, query)
            })
            .bind { [weak self] user, query in
            // TODO: - 즐겨찾기 추가
                self?.saveFavoriteUser(user: user, query: query)
            
        }.disposed(by: disposeBag)
        
        input.deleteFavorite
            .withLatestFrom(input.query, resultSelector: {($0, $1)}) // 위와 동일
            .bind { [weak self] userId, query in
            // TODO: - 즐겨찾기 삭제
                self?.deleteFavoriteUser(userId: userId, query: query)
                
        }.disposed(by: disposeBag)
        
        input.fetchMore
            .withLatestFrom(input.query)
            .bind { [weak self] query in
                guard let self = self else { return }
                // TODO: - 다음 페이지 검색
                page += 1
                self.fetchUsers(query: query, page: page)
        }.disposed(by: disposeBag)
        
        // 탭이 눌렸을 때 -> api유저 or 즐겨찾기 유저
        // 탭 유저리스트, 즐겨찾기리스트
         
        // tabButtonType or fetchUserList, favoriteUserList 셋중 하나만 변경되도 해당하는 바인딩 호출되는 부분 -> 이후에 이벤트 흐름이 전달되어 동적인 프로그래밍 가능해짐
        /*
        Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList).bind { tabButtonType, fetchUserList, favoriteUserList in
            
        }
         */
        
        // MARK: - combineLatest사용이유: 각각의 이벤트(탭)가 발생시 map함수가 돌고 새로은 cellData를 리턴하기 위함
//        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, allFavoriteUserList)
//            .map { [weak self] tabButtonType, fetchUserList, allFavoriteUserList in
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList)
            .map { [weak self] tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList in
                
            var cellData: [UserListCellData] = []
            guard let self = self else { return cellData }
            // TODO: - CellData 생성
            // Tab 타입에 따라 fetchUserList or favoriteUserList 보여줘야함
            switch tabButtonType {
            case .api:
                // fetchUserList
                let tuple = usecase
                    .checkFavoriteState(fetchUsers: fetchUserList, favoriteUsers: allFavoriteUserList)
                
                
                let userCellList = tuple.map { user, isFavorite in
                    UserListCellData.user(user: user, isFavorite: isFavorite )
                }
                return userCellList
            case .favorite:
                // favoriteUserList
                let dict = usecase.convertListToDictionary(favoriteUsers: favoriteUserList)
                let keys = dict.keys.sorted()
                keys.forEach { key in
                    cellData.append(.header(key))
                    if let users = dict[key] {
                        cellData += users.map { UserListCellData.user(user: $0, isFavorite: true) }
                    }
                }
            }
            
            return cellData
        }
        return Output(cellData: cellData, error: error.asObservable())
    }
    
    private func fetchUsers(query: String, page: Int) {
        // 한국어 에러 방지를 위해 쿼리 인코딩 작업 추가
        guard let urlAllowedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        Task {
            let result = await usecase.fetchUser(query: urlAllowedQuery, page: page)
            switch result {
            case let .success(users):
                // 첫번째 페이지
                if page == 1 {
                    fetchUserList.accept(users.items)
                    
                } else {
                    // 두번째 그 이상 체이지
                    fetchUserList.accept(fetchUserList.value + users.items)
                }
               
            case let .failure(error):
                self.error.accept(error.localizedDescription)
            }
        }
    }
    
    private func getFavoriteUsers(query: String) {
        let result = usecase.getFavoriteUsers()
        switch result {
        case .success(let users):
            // 검색어가 비어있으면 좋아요한 전체 리스트 리턴
            if query.isEmpty {
                favoriteUserList.accept(users)
            } else {
                // 검색어가 있을 떄 필터링
                let filteredUsers =  users.filter { user in
                    user.login.contains(query.lowercased())
                }
                favoriteUserList.accept(filteredUsers)
            }
            
            // 즐겨찾기 목록 여부 판단을 위해 전체목록 가져오기
            allFavoriteUserList.accept(users)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func validateQuery(query: String) -> Bool {
        if query.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    private func saveFavoriteUser(user: UserListItem, query: String) { // 입력값이 있을수도 없을수도
        let result = usecase.saveFavoriteUser(user: user)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    private func deleteFavoriteUser(userId: Int, query: String) {
        let result = usecase.deleteFavoriteUser(userId: userId)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
}

// rawValue, associatedValue 차이알자 여기서는 rawValue
public enum TabButtonType: String {
    case api = "Api"
    case favorite = "Favorite"
}

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
    
    var id: String {
        switch self {
        case .header: HeaderTableViewCell.id
        case .user: UserTableViewCell.id
        }
    }
}

protocol UserListCellProtocol {
    func apply(cellData: UserListCellData)
}
