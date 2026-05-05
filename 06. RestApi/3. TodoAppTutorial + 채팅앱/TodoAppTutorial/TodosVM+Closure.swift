//
//  TodosVMClosure.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 4/6/25.
//

import Foundation

final class TodosVMClosure {
    
    // MARK: - 가공된 최종 데이터
    var todos: [Todo] = [] {
        didSet { // 프로퍼티 옵저버
            print(#fileID, #function, #line, "- ")
            
            // 트리거
            self.notifyTodosChanged?(todos)
        }
    }
    
    // MARK: - 선택된 할일들
    var selectedTodoIds: Set<Int> = [] {
        didSet {
            print("selectedTodoIds: \(selectedTodoIds)")
            notifySelectedTodoIdsChanged?(Array(selectedTodoIds))
        }
    }
     
    // MARK: - 현재 페이지 트리거
    var currentPage: Int {
        get {
            if let pageInfo = self.pageInfo,
               let currentPage = pageInfo.currentPage {
                return currentPage
            } else {
                return 1
            }
        }
        /*
        didSet {
            print(#fileID, #function, #line, "- ")
            self.notifyCurrentPageChanged?(currentPage)
        }
         */
    }
     
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
    var pageInfo: Meta? = nil {
        didSet {
            print(#fileID, #function, #line, "- pageInfo: \(String(describing: pageInfo))")
            
            // 다음페이지 있는지 여부 이벤트 보내기
            self.notifyNextPage?(pageInfo?.hasNext() ?? true)
            
            // 현재 페이지 변경 이벤트
            self.notifyCurrentPageChanged?(currentPage)
        }
    }
    
    func fetchMore() {
        
        guard let pageInfo = self.pageInfo, pageInfo.hasNext(), !isLoading else {
            print("다음 페이지가 없습니다")
            return
        }
        
        if searchTerm.count > 0 { // 검색어가 있으면
            self.searchTodos(searchTerm: searchTerm, page: currentPage + 1)
        } else {
            self.fetchTodos(page: currentPage+1)
        }
    }
    
    // MARK: - 데이터 변경 이벤트
    // 클로저 -> 정대리 생초보를 위한 클로저 영상 공부
    var notifyTodosChanged: (([Todo]) -> Void)? = nil
    
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
            default:
                return
            //print("default")
            }
        }
    }
    
    
    
    init() {
        print(#fileID, #function, #line, "- ")
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

extension TodosVMClosure {
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

        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
            
            // 서비스 로직
            TodosAPI.fetchTodos(page: page) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    
                    isLoading = false
                    // 페이지 갱신
                    if let fetchedTodos: [Todo] = response.data, let pageInfo: Meta = response.meta {
                        if page == 1 {
                            self.todos = fetchedTodos
                        } else {
                            self.todos.append(contentsOf: fetchedTodos)
                        }
                        self.pageInfo = pageInfo
                    }
                    
                case .failure(let failure):
                    print("실패: \(failure)")
                }
                self.notifyRefreshEnded?()
                isLoading = false
            }
        }
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
        
        
        guard pageInfo?.hasNext() ?? true else {
            return print("다음페이지 없음")
        }
        
        self.notifySearchDataNotFound?(false)
        
        if page == 1 {
            self.todos = []
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
                            self.todos = fetchedTodos
                        } else {
                            self.todos.append(contentsOf: fetchedTodos)
                        }
                        self.pageInfo = pageInfo
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
                    self.todos = fetchedTodos
                    self.pageInfo = pageInfo
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
                   let editedIndex = self.todos.firstIndex(where: { $0.id ?? 0 == editedTodoId }) {
                    
                    // 지금 수정한 녀석 아이디를 가지고 있는 인덱스 찾기
                    // 그 녀석을 바꾸기
                    self.todos[editedIndex] = editedTodo
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
                    self.todos = self.todos.filter { $0.id ?? 0 != deletedTodoId }
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
            self.todos = self.todos.filter { !deletedTodoIds.contains($0.id ?? 0) }

            self.selectedTodoIds = self.selectedTodoIds.filter {deletedTodoIds.contains($0)}
            
            self.isLoading = false
        }
    }
}

