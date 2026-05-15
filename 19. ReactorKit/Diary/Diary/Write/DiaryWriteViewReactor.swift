//
//  DiaryWriteViewReactor.swift
//  Diary
//
//  Created by 김동현 on 5/7/26.
//

import ReactorKit
import Foundation

final class DiaryWriteViewReactor: Reactor {
    
    enum WriteType {
        case create
        case edit(id: String)
    }
    
    enum Action {
        case inputTitle(String)
        case inputContent(String)
        case save
    }
    
    enum Mutation {
        case setTitle(String)
        case setContent(String)
        case saveResult(Result<Bool, CoreDataError>)
        case editResult(Result<Bool, CoreDataError>)
    }
    
    struct State {
        var type: WriteType = .create
        var title: String = ""
        var content: String = ""
        var isRequestEnable: Bool {
            !title.isEmpty && !content.isEmpty
        }
        var saveSuccess: Bool = false
        var error: CoreDataError?
    }
    
    var initialState: State
    private let coreData: DiaryCoreDataProtocol
    init(initialState: State, coreData: DiaryCoreDataProtocol) {
        self.initialState = initialState
        self.coreData = coreData
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputTitle(let title):
            return Observable.just(Mutation.setTitle(title))
        case .inputContent(let content):
            return Observable.just(Mutation.setContent(content))
        case .save:
            switch currentState.type {
            case .create:
                let entity = DiaryItem(
                    id: NSUUID().uuidString,
                    title: currentState.title,
                    content: currentState.content,
                    createdDate: .now,
                    editedDate: .now
                )
                let result = coreData.saveDiary(diary: entity)
                return .just(.saveResult(result))
                
            case .edit(let id):
                return requestEdit(
                    id: id,
                    title: currentState.title,
                    content: currentState.content
                )
            }

        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setTitle(let title):
            state.title = title
        case .setContent(let content):
            state.content = content
        case .saveResult(let result):
            switch result {
            case .success:
                EventBus.shared.publish(event: .refreshList)
                state.saveSuccess = true
            case .failure(let error):
                state.error = error
            }
        case .editResult(let result):
            switch result {
            case .success:
                EventBus.shared.publish(event: .refreshList)
                EventBus.shared.publish(event: .refreshDetail)
                state.saveSuccess = true
            case .failure(let error):
                state.error = error
            }
        }
        return state
    }
}

extension DiaryWriteViewReactor {
    private func requestEdit(id: String, title: String, content: String) -> Observable<Mutation> {
        let result = coreData.editDiary(id: id, title: title, content: content)
        return Observable.just(.editResult(result))
    }
}
