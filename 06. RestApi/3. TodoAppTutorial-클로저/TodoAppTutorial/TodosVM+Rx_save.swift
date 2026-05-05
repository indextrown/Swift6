////
////  TodosVMClosure.swift
////  TodoAppTutorial
////
////  Created by 김동현 on 4/6/25.
////
//
//
///*
// 
// // ViewModel
// var todos: [Todo] = [] {
//     didSet {
//         notifyTodosChanged?(todos)  // 1️⃣ 외부에 알려줌
//     }
// }
//
// // ViewController
// todosVM.notifyTodosChanged = { todos in
//     self.todos = todos             // 2️⃣ 데이터 받고 테이블뷰 리로드
// }
//
// 
// 필요하면 @Published, Combine, RxSwift처럼 더 진보된 방식도 있지만
// 지금처럼 MVVM을 구조 연습하는 단계에선 didSet + 클로저 조합이 아주 좋은 선택
// 
// didSet: 값이 바뀔 때 실행되는 자동 후킹 포인트
// 클로저: 외부에서 ViewModel의 상태 변화를 감지해서 처리할 수 있도록 연결해주는 수단
// 
// 
// MARK: 함수구현 -> 클로저 구현 -> didSet 적용 or 특정함수에서 터트리기
// */
//
//import Foundation
//import RxSwift // 기본 형태
//import RxRelay // relay라는 subject 상위 단계인 relay를 추가했다고 생각(실패를 하더라도 스트림 흐름이 끊기지 않는다)
//
//final class TodosVMRx2 {
//    
//    // 1. Observable    BehaviorRelay/PublishRelay에서 일어난 이밴트를 변경해서 받을 수 있게 해준다
//    
//    // 2. BehaviorRelay  .value로 접근 가능 ->
//    /// -> 최종적으로 데이터 상태를 가지려면 BehaviorRelay를 사용하자
//    /// -> .value로 마지막에 보낸 데이터를 사용하면 편하다
//    
//    // 3. PublishRelay   이벤트를 한번 보내는 녀석
//    
//    
//    
//    // MARK: - 가공된 최종 데이터
//    var todos: BehaviorRelay<[Todo]> = BehaviorRelay<[Todo]>(value: [])
//    /*
//    var todos: [Todo] = [] {
//        didSet { // 프로퍼티 옵저버
//            print(#fileID, #function, #line, "- ")
//            
//            // 트리거
//            self.notifyTodosChanged?(todos)
//        }
//    }
//     */
//    
//     
//    // MARK: - 현재 페이지 트리거
//    var currentPage: Int {
//        get {
//            if let pageInfo = self.pageInfo,
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
//     
//    // MARK: - 로딩 트리거
//    var isLoading: Bool = false {
//        didSet {
//            notifyLoadingStateChanged?(isLoading)
//        }
//    }
//    
//    // MARK: - 검색어 트리거
//    var searchTerm: String = "" {
//        didSet {
//            print(#fileID, #function, #line, "- 검색어\(searchTerm)")
//            if searchTerm.count > 0 {
//                self.searchTodos(searchTerm: searchTerm)
//            } else {
//                self.fetchTodos()
//            }
//        }
//    }
//    
//    // MARK: - 페이지 정보 트리거
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
//    
//    func fetchMore() {
//        
//        guard let pageInfo = self.pageInfo, pageInfo.hasNext(), !isLoading else {
//            print("다음 페이지가 없습니다")
//            return
//        }
//        
//        if searchTerm.count > 0 { // 검색어가 있으면
//            self.searchTodos(searchTerm: searchTerm, page: currentPage + 1)
//        } else {
//            self.fetchTodos(page: currentPage+1)
//        }
//    }
//    
//    // MARK: - 데이터 변경 이벤트
//    // 클로저 -> 정대리 생초보를 위한 클로저 영상 공부
////    var notifyTodosChanged: (([Todo]) -> Void)? = nil
//    
//    // MARK: - 현재 페이지 변경 이벤트
//    var notifyCurrentPageChanged: ((Int) -> Void)? = nil
//    
//    // MARK: - 로딩중 이벤트
//    var notifyLoadingStateChanged: ((_ isLoading: Bool) -> Void)? = nil
//    
//    // MARK: - 리프래시 완료 이벤트
//    var notifyRefreshEnded: (() -> Void)? = nil
//    
//    // MARK: - 검색결과 없음 여부 이벤트
//    var notifySearchDataNotFound: ((_ noContent: Bool) -> Void)? = nil
//    
//    // MARK: - 다음 페이지 있는지 여부 이벤트
//    var notifyNextPage: ((_ hasNext: Bool) -> Void)? = nil
//     
//    // MARK: - 할일 추가완료 이벤트
//    var notifyTodoAdded: (() -> Void)? = nil
//    
//    // MARK: - 에러발생 이벤ㅌ
//    var notifyErrorOccured: ((_ errorMSG: String) -> Void)? = nil
//    
//    /// API 에러처리
//    /// - Parameter err: API에러
//    fileprivate func handleError(_ error: Error) {
//        
//        guard let _ = error as? TodosAPI.ApiError else {
//            print("모르는 에러입니다.")
//            return
//        }
//        
//        if error is TodosAPI.ApiError {
//            let apiError = error as! TodosAPI.ApiError
//
//            print("handleError: err: \(apiError.info)")
//
//            switch apiError {
//            case .noContentError:
//                print("컨텐츠 없음")
//                self.notifySearchDataNotFound?(true)
//            case .unAuthorized:
//                print("인증안함")
//            case .errorResponseFromServer:
//                notifyErrorOccured?(apiError.info)
//                print("서버에서 온 에러입니다: \(apiError.info)")
//            default:
//                return
//            //print("default")
//            }
//        }
//    }
//    
//    
//    
//    init() {
//        print(#fileID, #function, #line, "- ")
//        fetchTodos()
//    }
//    
//    
//}
//
//extension TodosVMRx {
//    // MARK: - 데이터 리프래시
//    func fetchRefresh() {
//        self.fetchTodos()
//    }
//    
//    func fetchTodos(page: Int = 1) {
//        
//        
//        if isLoading {
//            print("로딩중입니다...")
//            return
//        }
//        
//        isLoading = true
//
//        
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
//            
//            // 서비스 로직
//            TodosAPI.fetchTodos(page: page) { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let response):
//                    
//                    isLoading = false
//                    // 페이지 갱신
//                    if let fetchedTodos: [Todo] = response.data, let pageInfo: Meta = response.meta {
//                        if page == 1 {
//                            self.todos.accept(fetchedTodos)
//                        } else {
//                            // MARK: - 현재 todosRelay에서 .value로 접근하면 마지막에 보낸값 즉 현재 데이터를 알 수 있다
//                            let addedTodos = self.todos.value + fetchedTodos
//                            self.todos.accept(addedTodos)
//                            // self.todos.append(contentsOf: fetchedTodos)
//                        }
//                        self.pageInfo = pageInfo
//                    }
//                    
//                case .failure(let failure):
//                    print("실패: \(failure)")
//                }
//                self.notifyRefreshEnded?()
//                isLoading = false
//            }
//        }
//    }
//    
//    /// 할일 검색하기
//    /// - Parameters:
//    ///   - searchTerm: 검색어
//    ///   - page: 페이지
//    func searchTodos(searchTerm: String, page: Int = 1) {
//        
//        if searchTerm.count < 1 {
//            print("검색어가 없습니다")
//            return
//        }
//        
//        if isLoading {
//            print("로딩중입니다...")
//            return
//        }
//        
//        
//        guard pageInfo?.hasNext() ?? true else {
//            return print("다음페이지 없음")
//        }
//        
//        self.notifySearchDataNotFound?(false)
//        
//        if page == 1 {
//            self.todos.accept([])
//            // self.todos = []
//        }
//        
//        
//        isLoading = true
//
//        
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
//            
//            // 서비스 로직
//            TodosAPI.searchTodos(searchTerm: searchTerm, page: page) { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let response):
//                    isLoading = false
//                    // 페이지 갱신
//                    // self.currentPage = page
//                    
//                    if let fetchedTodos: [Todo] = response.data, let pageInfo: Meta = response.meta {
//                        if page == 1 {
//                            // self.todos = fetchedTodos
//                            self.todos.accept([])
//                        } else {
//                            
//                            // MARK: - 현재 todosRelay에서 .value로 접근하면 마지막에 보낸값 즉 현재 데이터를 알 수 있다
//                            let addedTodos = self.todos.value + fetchedTodos
//                            self.todos.accept(addedTodos)
//                            // self.todos.append(contentsOf: fetchedTodos)
//                        }
//                        self.pageInfo = pageInfo
//                    }
//                    
//                case .failure(let failure):
//                    print("실패: \(failure)")
//                    isLoading = false
//                    self.handleError(failure)
//                }
//                self.notifyRefreshEnded?()
//            }
//        }
//    }
//    
//    
//    /// 할일추가
//    /// - Parameter title: 할일 타이틀
//    func addTodo(_ title: String) {
//        
//        if title.isEmpty {
//            self.notifyErrorOccured?("할 일을 입력해주세요.")
//            return
//        }
//        
//        TodosAPI.addATodoAndFetchTodos(title: title) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                
//                isLoading = false
//                // 페이지 갱신
//                if let fetchedTodos: [Todo] = response.data, let pageInfo: Meta = response.meta {
//                    self.todos.accept(fetchedTodos)
//                    // self.todos = fetchedTodos
//                    self.pageInfo = pageInfo
//                    self.notifyTodoAdded?()
//                }
//                
//            case .failure(let failure):
//                print("실패: \(failure)")
//                self.isLoading = false
//                self.handleError(failure)
//            }
//        }
//    }
//    
//}
