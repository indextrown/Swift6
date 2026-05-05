//
//  CounterFeature.swift
//  TcaSample
//
//  Created by 김동현 on 12/13/25.
//

import Foundation
import ComposableArchitecture

struct CounterFeature: Reducer {

    // 도메인(=데이터) + 상태
    struct State: Equatable {
        var count = 0
    }

    // 도메인 + 액션
    enum Action: Equatable {
        case addCount
        case subtractCount
    }

    /// CounterFeature의 핵심 로직
    /// - 역할:
    ///   - Action이 들어왔을 때 State를 어떻게 변경할지 정의한다
    ///   - 모든 상태 변경은 반드시 이 함수 안에서만 일어난다
    /// - 특징:
    ///   - 단방향 데이터 흐름 (Action → Reducer → State)
    ///   - 외부 사이드 이펙트는 Effect로 분리된다
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .addCount:
            state.count += 1
            // 추가로 실행할 비동기 작업이나 사이드 이펙트가 없으므로 .none 반환
            return .none

        case .subtractCount:
            state.count -= 1
            return .none
        }
    }
}
