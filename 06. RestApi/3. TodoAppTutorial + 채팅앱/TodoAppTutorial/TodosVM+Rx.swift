//
//  TodosVMClosure.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 4/6/25.
//

import Foundation
import RxSwift
import RxRelay
import Combine

final class TodosVMRx {
    private var subscriptions = Set<AnyCancellable>()
    
    var disposeBag = DisposeBag()
    
    // MARK: - 여러가지 Observable이 있음(drive도 있고) 하지만 여기 3개를 주로 사용
    // 1. Observable
    //      - 한번 발송하면 끝난다
    //      - 2, 3이벤트를 변경을 해서 받을 수 있는 기본 베이스
 
    // 2. BehaviorRelay
    //      - subject 래핑된애다, subject는 스트림이 completed or Error시 스트림이 종료되지 않는다 하지만 relay는 스트림이 끊기지 않는다
    //      - 계속 데이터를 보낼 수 있다
    //      - .value로 최종 데이터 상태를 알 수 있다 - 초기값 필요
    
    // 3. PublishRelay
    //      - subject 래핑된애다. 계속 데이터를 보낼 수 있다
    //      - 이벤트를 한번 보내는 것
    
    // MARK: - 가공된 최종 데이터
    var todos: BehaviorRelay<[Todo]> = BehaviorRelay<[Todo]>(value: [])

    // MARK: - 선택된 할일들
    var selectedTodoIds: Set<Int> = [] {
        didSet {
            print("selectedTodoIds: \(selectedTodoIds)")
            notifySelectedTodoIdsChanged?(Array(selectedTodoIds))
        }
    }
     
    // MARK: - 현재 페이지 트리거
//    var currentPage: Int {
//        get {
//            if let pageInfo = self.pageInfo.value,
//               let currentPage = pageInfo.currentPage {
//                return currentPage
//            } else {
//                return 1
//            }
//        }
//        /*
//        didSet {
//            print(#fileID, #function, #line, "- ")
//            self.notifyCurrentPageChanged?(currentPage)
//        }
//         */
//    }
     
    // MARK: - 로딩 트리거
    var isLoading: Bool = false {
        didSet {
            notifyLoadingStateChanged?(isLoading)
        }
    }
    
    // MARK: - 검색어 트리거
    var searchTerm: String = "" {
        didSet {
            print(#fileID, #function, #line, "- 검색어\(searchTerm)")
            if searchTerm.count > 0 {
                self.searchTodos(searchTerm: searchTerm)
            } else {
                self.fetchTodos()
            }
        }
    }
    
    // MARK: - 페이지 정보 트리거
//    var pageInfo: Meta? = nil {
//        didSet {
//            print(#fileID, #function, #line, "- pageInfo: \(String(describing: pageInfo))")
//            
//            // 다음페이지 있는지 여부 이벤트 보내기
//            self.notifyNextPage?(pageInfo?.hasNext() ?? true)
//            
//            // 현재 페이지 변경 이벤트
//            self.notifyCurrentPageChanged?(currentPage)
//        }
//    }
    
    // MARK: - 페이지 정보
    var pageInfo: BehaviorRelay<Meta?> = BehaviorRelay<Meta?>(value: nil)
    
    // MARK: - 다음 페이지 존재 유무
    var notifyHasNextPage: Observable<Bool>
    
    // MARK: - 현재 페이지 - 기존 클로저 getter부분은 init에서 처리
    var currentPage: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
    
    var currentPageInf0: Observable<String>
    
    func fetchMore() {
        
        guard let pageInfo = self.pageInfo.value, pageInfo.hasNext(), !isLoading else {
            print("다음 페이지가 없습니다")
            return
        }
        
        if searchTerm.count > 0 { // 검색어가 있으면
            self.searchTodos(searchTerm: searchTerm, page: currentPage.value + 1)
        } else {
            self.fetchTodos(page: currentPage.value+1)
        }
    }
    
    // MARK: - 데이터 변경 이벤트
    // MARK: - 현재 페이지 변경 이벤트
    var notifyCurrentPageChanged: ((Int) -> Void)? = nil
    
    // MARK: - 로딩중 이벤트
    var notifyLoadingStateChanged: ((_ isLoading: Bool) -> Void)? = nil
    
    // MARK: - 리프래시 완료 이벤트
    var notifyRefreshEnded: (() -> Void)? = nil
    
    // MARK: - 검색결과 없음 여부 이벤트
    var notifySearchDataNotFound: ((_ noContent: Bool) -> Void)? = nil
    
    // MARK: - 다음 페이지 있는지 여부 이벤트
    var notifyNextPage: ((_ hasNext: Bool) -> Void)? = nil
     
    // MARK: - 할일 추가완료 이벤트
    var notifyTodoAdded: (() -> Void)? = nil
    
    // MARK: - 에러발생 이벤트
    var notifyErrorOccured: ((_ errorMSG: String) -> Void)? = nil
    
    // MARK: - 선택된 할일들 변경 이벤트
    var notifySelectedTodoIdsChanged: ((_ selectedTodoIds: [Int]) -> Void)? = nil
    
    /// API 에러처리
    /// - Parameter err: API에러
    fileprivate func handleError(_ error: Error) {
        
        guard let _ = error as? TodosAPI.ApiError else {
            print("모르는 에러입니다.")
            return
        }
        
        if error is TodosAPI.ApiError {
            let apiError = error as! TodosAPI.ApiError

            print("handleError: err: \(apiError.info)")

            switch apiError {
            case .noContentError:
                print("컨텐츠 없음")
                self.notifySearchDataNotFound?(true)
            case .unAuthorized:
                print("인증안함")
            case .errorResponseFromServer:
                notifyErrorOccured?(apiError.info)
                print("서버에서 온 에러입니다: \(apiError.info)")
            case .nowAllowedUrl:
                self.notifyErrorOccured?(apiError.info)
            default:
                return
            //print("default")
            }
        }
    }
    
    
    
    init() {
        print(#fileID, #function, #line, "- ")
        
        currentPageInf0 = self.currentPage
            .map { "페이지: \($0)" }
        
        pageInfo
            .compactMap { $0 } // Observable<Meta>
            .map {
                if let currentPage = $0.currentPage {
                    return currentPage
                } else {
                    return 1
                }
            }
            .bind(onNext: self.currentPage.accept(_:))
            .disposed(by: disposeBag)

        // BehaviorRelay -> Observable<Bool> 형태 변경
        self.notifyHasNextPage = pageInfo.skip(1).map { $0?.hasNext() ?? true }
        fetchTodos()
    }

    
    /// 선택된 할일 처리
    /// - Parameters:
    ///   - selectedTodoId: selectedTodoId description
    ///   - isOn: isOn description
    func handleTodoSelection(_ selectedTodoId: Int, isOn: Bool) {
        if isOn {
            self.selectedTodoIds.insert(selectedTodoId)
        } else {
            self.selectedTodoIds.remove(selectedTodoId)
        }
    }
    
    
}

extension TodosVMRx {
    // MARK: - 데이터 리프래시
    func fetchRefresh() {
        self.fetchTodos()
    }
    
    func fetchTodos(page: Int = 1) {
        
        if isLoading {
            print("로딩중입니다...")
            return
        }
        
        isLoading = true

        // MARK: - delay를 주기위해 빈값을 보내고 0.7초 딜레이주기
        Observable.just([])
            .delay(RxTimeInterval.milliseconds(700), scheduler: MainScheduler.instance)
            // Observable 흐름 안에서 다른 Observable을 내맽는 방법
            .flatMapLatest {_ in
                TodosAPI
                    .fetchTodosWithObservable(page: page)
            }
            // 옵저버블의 이벤트에 따라 액션
            .do(onError: { error in
                self.handleError(error)
                self.pageInfo.accept(nil)
            }, onCompleted: {
                self.isLoading = false
                self.notifyRefreshEnded?()
            })
            // compactMap: nil이면 더이상 아래로 흘러보내지않는다 == nil이 아니면 각각  언래핑이된다
            .compactMap{ Optional(tuple: ($0.meta, $0.data))}
            .subscribe { pageInfo, fetchedTodos in
                if page == 1 {
                   self.todos.accept(fetchedTodos)
               } else {
                   let addedTodos = self.todos.value + fetchedTodos
                   self.todos.accept(addedTodos)
               }
                self.pageInfo.accept(pageInfo)
            }
            .disposed(by: disposeBag)
    }
    
    /// 할일 검색하기
    /// - Parameters:
    ///   - searchTerm: 검색어
    ///   - page: 페이지
    func searchTodos(searchTerm: String, page: Int = 1) {
        
        if searchTerm.count < 1 {
            print("검색어가 없습니다")
            return
        }
        
        if isLoading {
            print("로딩중입니다...")
            return
        }
        
        
        guard pageInfo.value?.hasNext() ?? true else {
            return print("다음페이지 없음")
        }
        
        self.notifySearchDataNotFound?(false)
        
        if page == 1 {
            self.todos.accept([])
        }
        
        
        isLoading = true

        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
            
            // 서비스 로직
            TodosAPI.searchTodos(searchTerm: searchTerm, page: page) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    isLoading = false
                    // 페이지 갱신
                    // self.currentPage = page
                    
                    if let fetchedTodos: [Todo] = response.data, let pageInfo: Meta = response.meta {
                        if page == 1 {
                            self.todos.accept(fetchedTodos)
                        } else {
                            let addedTodos = todos.value + fetchedTodos
                            self.todos.accept(addedTodos)
                        }
                        self.pageInfo.accept(pageInfo)
                    }
                    
                case .failure(let failure):
                    print("실패: \(failure)")
                    isLoading = false
                    self.handleError(failure)
                }
                self.notifyRefreshEnded?()
            }
        }
    }
    
    /// 할일추가
    /// - Parameter title: 할일 타이틀
    func addATodo(_ title: String) {
        
        if title.isEmpty {
            self.notifyErrorOccured?("할 일을 입력해주세요.")
            return
        }
        
        if isLoading {
            print("로딩중입니다")
            return
        }
        self.isLoading = true
        
        TodosAPI.addATodoAndFetchTodos(title: title) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                
                isLoading = false
                // 페이지 갱신
                if let fetchedTodos: [Todo] = response.data, let pageInfo: Meta = response.meta {
                    self.todos.accept(fetchedTodos)
                    self.pageInfo.accept(pageInfo)
                    self.notifyTodoAdded?()
                }
                
            case .failure(let failure):
                print("실패: \(failure)")
                self.isLoading = false
                self.handleError(failure)
            }
        }
    }
    
    /// 할일수정
    /// - Parameter title: 할일 타이틀
    func editATodo(_ id: Int, _ editedTitle: String) {
        print(#fileID, #function, #line, "- id: \(id), editedTitle: \(editedTitle)")
        
        if isLoading {
            print("로딩중이다")
            return
        }
        
        self.isLoading = true
        
        TodosAPI.editATodoJson(id: id, title: editedTitle) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.isLoading = false
                // 페이지 갱신
                if let editedTodo : Todo = response.data,
                   let editedTodoId : Int = editedTodo.id,
                   let editedIndex = self.todos.value.firstIndex(where: { $0.id ?? 0 == editedTodoId }) {
                    
                    // 지금 수정한 녀석 아이디를 가지고 있는 인덱스 찾기
                    // 그 녀석을 바꾸기
                    // self.todos[editedIndex] = editedTodo
                    
                    var currentTodos = self.todos.value
                    currentTodos[editedIndex] = editedTodo
                    self.todos.accept(currentTodos)
                }
            case .failure(let failure):
                print("failure: \(failure)")
                self.isLoading = false
                self.handleError(failure)
            }
        }
    }
    
    /// 단일 할일 삭제
    /// - Parameter id: 할일 아이디
    func deleteATodo(_ id: Int) {
        
        if isLoading {
            print("로딩중입니다")
            return
        }
        self.isLoading = true
        
        TodosAPI.deleteATodo(id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.isLoading = false
                // 페이지 갱신
                if let deletedTodo: Todo = response.data,
                   let deletedTodoId: Int = deletedTodo.id {
                    // 삭제된 아이템 찾아서 그 녀석만 현재 리스트에서 지우기
                    let filteredTodos = self.todos.value.filter { $0.id ?? 0 != deletedTodoId }
                    self.todos.accept(filteredTodos)
                }
        
            case .failure(let failure):
                print("실패: \(failure)")
                self.isLoading = false
                self.handleError(failure)
                
            }
        }
    }
    
    /// 선택된 할일들 삭제
    func deleteSelectedTodos() {
        if self.selectedTodoIds.count < 1 {
            notifyErrorOccured?("선택된 할일들이 없습니다.")
        }
        
        if isLoading {
            print("로딩중입니다")
            return
        }
        self.isLoading = true
        
        TodosAPI.deleteSelectedTodos(selectedTodoIds: Array(self.selectedTodoIds )) { [weak self] deletedTodoIds in
            guard let self = self else { return }
            
            // 삭제된 아이템 찾아서 그 녀석만 현재 리스트에서 지우기
            let filteredTodos = self.todos.value.filter { !deletedTodoIds.contains($0.id ?? 0) }
            self.todos.accept(filteredTodos)

            self.selectedTodoIds = self.selectedTodoIds.filter { !deletedTodoIds.contains($0) }
            
            self.isLoading = false
        }
    }
}

