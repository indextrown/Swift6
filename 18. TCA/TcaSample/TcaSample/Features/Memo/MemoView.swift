//
//  MemoView.swift
//  TcaSample
//
//  Created by 김동현 on 12/13/25.
//

import SwiftUI
import ComposableArchitecture

struct MemoView: View {
    let store: StoreOf<MemoFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.isLoading {
                    ProgressView()
                }

                List(viewStore.memos) { memo in
                    VStack(alignment: .leading) {
                        Text(memo.title)
                            .font(.headline)

                        Text("조회수: \(memo.viewCount)")
                            .font(.caption)
                    }
                    .onTapGesture {
                        viewStore.send(.fetchMemoItem(id: memo.id))
                    }
                }
            }
            .onAppear {
                viewStore.send(.fetchMemoList)
            }
        }
    }
}


#Preview {
    MemoView(store: Store(initialState: MemoFeature.State()) {
        MemoFeature()
    })
}
