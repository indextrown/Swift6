//
//  Part2-04-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/7/24.
//

/*
 VStack {
    텍스트
    VStack {
        HStack { 이미지, VStack {텍스트, 텍스트} }
        HStack { 이미지, VStack {텍스트, 텍스트} }
        HStack { 이미지, VStack {텍스트, 텍스트} }
    }
    
    버튼
 }
 */

import SwiftUI

struct Part2_04_View: View {
    var body: some View {
        VStack{
            Text("What's New in Photos")
                .font(.system(size: 30))
                .bold()
                .padding()
                .padding(.top, 50)
            
            HStack {
                Image(systemName: "person.2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .padding(.horizontal, 7)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text("Shared Library")
                        .font(.headline)
                    // Text("Combine photos and videos with the people closess to you and automaticaly share new photos from Camera")
                    Text("Save time by making edits to one photo, then applying the changes to other photos with a tap.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }
            
            HStack {
                Image(systemName: "square.on.square.badge.person.crop")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .padding(.horizontal, 7)
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text("Copy & Paste Edits")
                        .font(.headline)
                    Text("Save time by making edits to one photo, then applying the changes to other photos with a tap.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }
            .padding(.vertical)
            
            HStack {
                Image(systemName: "sparkles.square.filled.on.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .padding(.horizontal, 7)
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text("Merge Duplicates")
                        .font(.headline)
                    Text("Quickly find and merge all your duplicate photos and videos from one central place in the Albums tab.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }
            
            Spacer()
            
            Button {
                //
            } label: {
                Text("Continue")
                    .padding()
                    .frame(width: 350)
                    // .frame(maxWidth: .infinity) // 화면길이 상관없이 끝까지 길어짐
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
            }
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    Part2_04_View()
}
