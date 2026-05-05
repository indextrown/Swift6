//
//  ContentView.swift
//  TcaSample
//
//  Created by 김동현 on 12/13/25.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        TabView {
            CounterView(
                store: Store(initialState: CounterFeature.State()) {
                    CounterFeature()
                }
            )
            .tabItem { Text("Counter") }

            MemoView(
                store: Store(initialState: MemoFeature.State()) {
                    MemoFeature()
                }
            )
            .tabItem { Text("Memo") }
        }
    }
}


#Preview {
    ContentView()
}

