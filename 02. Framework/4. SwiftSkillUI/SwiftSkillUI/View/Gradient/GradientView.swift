//
//  ContentView.swift
//  SwiftSkillUI
//
//  Created by 김동현 on 1/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Set the background to a gradient starting with black
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray]),
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea() // Ensures the gradient fills the entire screen
            
            Text("Hello, world!")
        }
    }
}

#Preview {
    ContentView()
}
