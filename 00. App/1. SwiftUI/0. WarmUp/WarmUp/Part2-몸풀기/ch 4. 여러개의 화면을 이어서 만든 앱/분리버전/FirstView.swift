//
//  FirstView.swift
//  WarmUp
//
//  Created by 김동현 on 10/8/24.
//

import SwiftUI

struct FirstView: View {
    var body: some View {
        NavigationStack {
            List {
                
                NavigationLink {
                    Text("내용")
                } label: {
                    Text("리스트1")
                }
                
                NavigationLink {
                    Text("내용")
                } label: {
                    Text("리스트2")
                }
                
                NavigationLink {
                    Text("내용")
                } label: {
                    Text("리스트3")
                }
            }
        }
    }
}

#Preview {
    FirstView()
}
