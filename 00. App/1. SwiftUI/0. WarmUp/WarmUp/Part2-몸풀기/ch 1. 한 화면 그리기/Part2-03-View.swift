//
//  Part2-03-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/7/24.
//

/*
 VStack {
    이미지
    텍스트
    텍스트
    텍스트
 
    HStack {
        버튼
        버튼
    }
 }
 
 */

import SwiftUI

struct Part2_03_View: View {
    var body: some View {
        VStack {
            Image(systemName: "pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
            
            Text("Text Element 1")
                .font(.headline)
                .padding()
            Text("Text Element 2")
                .font(.subheadline)
                .padding()
            Text("Text Element 3")
                .font(.body)
                .padding()
            Text("Text Element 4")
                .font(.system(size: 30))
                .padding()
            
            HStack {
                MyButton(buttonTitle: "Button 1", buttonColor: .blue)
                MyButton(buttonTitle: "Button 4", buttonColor: .cyan)
            }
            
            Button {
                //
                
            } label: {
                VStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    Text("Complex Button")
                        
                }
                .foregroundColor(.white)
                .padding()
                .background(.orange)
                .cornerRadius(10)
            }
            
            
            
            Button {
                //
            } label: {
                VStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    Text("Complex Button")
                }
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    Part2_03_View()
}


