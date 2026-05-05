//
//  IntroView.swift
//  SwiftSkillUI
//
//  Created by 김동현 on 1/13/25.
//

import SwiftUI

struct IntroView: View {
    @State private var test: Bool = false
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Spacer()
                
                Text("Hello, world")
                    .indexBorderedCaption()

                Spacer()
                
                ContinueButton()
            }
            .frame(maxWidth: .infinity)
        }
        .overlay(alignment: .top) {
            HeaderView()
        }
        .background(.black.gradient)
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            Spacer(minLength: 0)
        }
        .foregroundColor(.white)
        .padding(15)
    }
    
    @ViewBuilder
    private func ContinueButton() -> some View {
        Button {
            test.toggle()
        } label: {
            Text("Continue")
                .padding(.vertical, 15)
                .foregroundStyle(.black)
                .frame(maxWidth: test ? 250 : 100)
                .background(.white, in: .capsule)
        }
        .padding(.bottom, 15)
    }
}

extension View {
    func indexBorderedCaption() -> some View {
        self
            .font(.title)
            .padding(20)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 3)
            }
            .foregroundColor(.white)
    }
}




#Preview {
    IntroView()
}
