//
//  MemoClient+Dependency.swift
//  TcaSample
//
//  Created by 김동현 on 12/13/25.
//

import Foundation
import ComposableArchitecture

private enum MemoClientKey: DependencyKey {
    static let liveValue = MemoClient.live
}

extension DependencyValues {
    var memoClient: MemoClient {
        get { self[MemoClientKey.self] }
        set { self[MemoClientKey.self] = newValue }
    }
}
