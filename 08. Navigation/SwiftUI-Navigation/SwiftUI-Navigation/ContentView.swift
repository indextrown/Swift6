//
//  ContentView.swift
//  SwiftUI-Navigation
//
//  Created by 김동현 on 3/30/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            DetailView()
        }
    }
}

struct DetailView: View {
    var stepNum: Int = 1
    var body: some View {
        NavigationLink {
            DetailView(stepNum: stepNum + 1)
        } label: {
            VStack(spacing: 0) {
                Text("스탭 넘버: \(stepNum)")
                    .fontWeight(.black)
                    .font(.system(size: 30))
                    .foregroundStyle(.black)
                    .padding(20)
            }
            .cornerRadius(10)
            .border(Color.red)
        }
        .navigationTitle("스탭 넘버: \(stepNum)")
        // default: large title
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailView()
}
