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
        case touchMode
        case query(String)
        case selectItem(id: String)
        case delete
    }
    
    enum Mutation {
        case setList([DiaryItem])
        case setMode(ListMode)
        case setSelectedItems(Set<String>)
        case deletedSuccess(Bool)
        case setError(CoreDataError)
    }
    
    struct State {
        var listMode: ListMode = .normal
        var list: [DiaryItem] = []
        var selectedItems: Set<String> = []
        var deleteSuccess: Bool = false
        var error: CoreDataError
    }
    
    let initialState: State
    let coreData: DiaryCoreDataProtocol
    init(initialState: State, coreData: DiaryCoreDataProtocol) {
        self.initialState = initialState
        self.coreData = coreData
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .touchMode:
            return .empty()
        case .query(let string):
            return .empty()
        case .selectItem(let id):
            return .empty()
        case .delete:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
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
        }
        return state
    }
}

struct DiaryListCellData: Equatable {
    let isSelected: Bool?
    let diary: DiaryItem
}
