//
//  DiaryListViewReactor.swift
//  Diary
//
//  Created by 김동현 on 5/7/26.
//

import ReactorKit

final class DiaryListViewReactor: Reactor {
    
    enum ListMode {
        case normal
        case delete
    }
    
    enum Action {
        case refresh
        case touchMode
        case query(String)
        case selectItem(id: String)
        case delete
    }
    
    enum Mutation {
        case setCellDataList([DiaryListCellData])
        case setList([DiaryItem])
        case setMode(ListMode)
        case setSelectedItems(Set<String>)
        case deletedSuccess(Bool)
        case setError(CoreDataError)
        case setQuery(String)
    }
    
    struct State {
        var query: String = ""
        var listMode: ListMode = .normal
        var cellDataList: [DiaryListCellData] = []
        var list: [DiaryItem] = []
        var selectedItems: Set<String> = []
        @Pulse var deleteSuccess: Bool = false
        @Pulse var error: CoreDataError?
    }
    
    let initialState: State
    let coreData: DiaryCoreDataProtocol
    init(initialState: State, coreData: DiaryCoreDataProtocol) {
        self.initialState = initialState
        self.coreData = coreData
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return getList(query: currentState.query)
        case .touchMode:
            return getNewMode()
                .withUnretained(self)
                .flatMap { reactor, mode in
                    Observable.concat(
                        .just(Mutation.setMode(mode)),
                        reactor.createCellData(
                            list: reactor.currentState.list,
                            mode: mode,
                            selectedItems: reactor.currentState.selectedItems
                        ).map { Mutation.setCellDataList($0) }
                    )
                }
        case .query(let query):
            return .concat(
                getList(query: query),
                .just(Mutation.setQuery(query))
            )
        case .selectItem(let id):
            return updateSelectedItems(id: id)
                .withUnretained(self)
                .flatMap { reactor, selectedItems in
                    Observable.concat(
                        .just(Mutation.setSelectedItems(selectedItems)),
                        reactor.createCellData(
                            list: reactor.currentState.list,
                            mode: reactor.currentState.listMode,
                            selectedItems: selectedItems
                        ).map { Mutation.setCellDataList($0) }
                    )
                }
            
        case .delete:
            for id in currentState.selectedItems {
                if case let .failure(error) = coreData.deleteDiary(id: id) {
                    // 에러 발생 시
                    return Observable.just(.setError(error))
                }
            }
            return .concat(
                .just(.deletedSuccess(true)),
                .just(.setMode(.normal))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setCellDataList(let cellDataList):
            state.cellDataList = cellDataList
        case .setList(let list):
            state.list = list
        case .setMode(let listMode):
            state.listMode = listMode
        case .setSelectedItems(let selectedItems):
            state.selectedItems = selectedItems
        case .deletedSuccess(let isSuccess):
            state.deleteSuccess = isSuccess
        case .setError(let coreDataError):
            state.error = coreDataError
        case .setQuery(let query):
            state.query = query
        }
        return state
    }
}

extension DiaryListViewReactor {
    func getList(query: String) -> Observable<Mutation> {
        let result = coreData.getDiaryList(query: query)
        switch result {
        case .success(let list):
            return Observable.concat( // concat으로 두가지 이벤트 방출
                .just(Mutation.setList(list)), // list 저장
                createCellData(                // cell
                    list: list,
                    mode: currentState.listMode,
                    selectedItems: currentState.selectedItems
                ).map { Mutation.setCellDataList($0) }
            )
            
        case .failure(let error):
            return Observable.just(Mutation.setError(error))
        }
    }
    
    func createCellData(
        list: [DiaryItem],
        mode: ListMode,
        selectedItems: Set<String>
    ) -> Observable<[DiaryListCellData]> {
        let cellDataList = list.map { item in
            switch mode {
            case .normal:
                return DiaryListCellData(isSelected: nil, diary: item)
            case .delete:
                let isSelected = selectedItems.contains(item.id)
                return DiaryListCellData(isSelected: isSelected, diary: item)
            }
        }
        return .just(cellDataList)
    }
    
    func getNewMode() -> Observable<ListMode> {
        let mode: ListMode = if currentState.listMode == .normal {
            .delete
        } else {
            .normal
        }
        return .just(mode)
    }
    
    func updateSelectedItems(id: String) -> Observable<Set<String>> {
        var selectedItems = currentState.selectedItems
        if currentState.selectedItems.contains(id) {
            selectedItems.remove(id)
        } else {
            selectedItems.insert(id)
        }
        return .just(selectedItems)
    }
}

struct DiaryListCellData: Equatable {
    let isSelected: Bool?
    let diary: DiaryItem
    let cellId = DiaryListCell.id
}
