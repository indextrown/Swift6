//
//  CounterView.swift
//  TcaSample
//
//  Created by 김동현 on 12/13/25.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Text("Count: \(viewStore.count)")
                    .font(.largeTitle)

                Button("더하기") {
                    viewStore.send(.addCount)
                }

                Button("빼기") {
                    viewStore.send(.subtractCount)
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    CounterView()
//}
