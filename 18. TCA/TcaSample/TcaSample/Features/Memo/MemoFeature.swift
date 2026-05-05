//
//  MemoFeature.swift
//  TcaSample
//
//  Created by 김동현 on 12/13/25.
//

import Foundation
import ComposableArchitecture

struct MemoFeature: Reducer {

    struct State: Equatable {
        var memos: MemoList = []
        var selectedMemo: Memo?
        var isLoading = false
    }

    enum Action: Equatable {
        case fetchMemoList
        case fetchMemoListResponse(Result<MemoList, MemoError>)

        case fetchMemoItem(id: String)
        case fetchMemoItemResponse(Result<Memo, MemoError>)
    }

    enum MemoError: Error, Equatable {
        case network
    }

    @Dependency(\DependencyValues.memoClient) var memoClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case .fetchMemoList:
            state.isLoading = true
            return memoClient.fetchMemoList()

        case let .fetchMemoListResponse(.success(memos)):
            state.isLoading = false
            state.memos = memos
            return .none

        case .fetchMemoListResponse(.failure):
            state.isLoading = false
            return .none

        case let .fetchMemoItem(id):
            state.isLoading = true
            return memoClient.fetchMemoItem(id)

        case let .fetchMemoItemResponse(.success(memo)):
            state.isLoading = false
            state.selectedMemo = memo
            return .none

        case .fetchMemoItemResponse(.failure):
            state.isLoading = false
            return .none
        }
    }
}
