//
//  DirayDetailViewReactor.swift
//  Diary
//
//  Created by 김동현 on 5/15/26.
//

import Foundation
import ReactorKit

class DiaryDetailReactor: Reactor {
    enum Action {
        case getDiary
        case delete
    }
    
    enum Mutation {
        case setDiary(DiaryItem)
        case deleteSuccess(Bool)
        case error(CoreDataError?)
    }
    
    struct State {
        let id: String
        var diary: DiaryItem?
        @Pulse var deleteSuccess: Bool = false
        @Pulse var error: CoreDataError?
    }
    
    var initialState: State
    let coreData: DiaryCoreDataProtocol
    
    init(initialState: State, coreData: DiaryCoreDataProtocol) {
        self.initialState = initialState
        self.coreData = coreData
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getDiary:
            return getDiary(id: currentState.id)
        case .delete:
            return delete(id: currentState.id)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setDiary(let diary):
            state.diary = diary
        case .deleteSuccess(let isSuccess):
            state.deleteSuccess = isSuccess
        case .error(let error):
            state.error = error
        }
        return state
    }
}

// MARK: - Todo
// mutate func
extension DiaryDetailReactor {
    func getDiary(id: String) -> Observable<Mutation> {
        // Result<Bool, Error> -> Observable<Mutation>
        let result = coreData.getDiary(id: id)
        switch result {
        case .success(let diary):
            return Observable.just(.setDiary(diary))
        case .failure(let error):
            return Observable.just(.error(error))
        }
    }
    
    func delete(id: String) -> Observable<Mutation> {
        let result = coreData.deleteDiary(id: id)
        switch result {
        case .success:
            return .just(.deleteSuccess(true))
        case .failure(let error):
            return .just(.error(error))
        }
    }
}
