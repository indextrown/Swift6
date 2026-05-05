//
//  OtherUserProfileView.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import SwiftUI

// 타 사용자 프로필
struct OtherUserProfileView: View {
  
    var userData: UserData

    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        AsyncImage(url: URL(string: userData.avatar )!) { phase in
                            switch phase {
                            case .empty:
                                ProfileView()
                                    .frame(width: 250, height: 250, alignment: .center)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, height: 250, alignment: .center)
                            case .failure:
                                Image(systemName: "person.fill.questionmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .frame(width: 250, height: 250, alignment: .center)
                            default:
                                EmptyView()
                                    .frame(width: 250, height: 250, alignment: .center)
                            }
                        }
                        Spacer()
                    }
                }
                Section(header: Text("아이디").font(.callout)) {
                    Text("아이디: \(userData.id)")
                }
                
                Section(header: Text("이름").font(.callout)) {
                    Text("이름: \(userData.name)")
                }
                
                Section(header: Text("이메일").font(.callout)) {
                    Text("이메일: \(userData.email)")
                }

        
            }
        }.navigationTitle("로그인 하기")
    }
}

//#Preview {
//    OtherUserProfileView(userData: UserData(id: 1, name: <#T##String#>, email: <#T##String#>, avatar: <#T##String#>))
//}


//https://res.cloudinary.com/ppak-coders-com/image/upload/v1666424389/f4uoyyjgfo2pantau0zx.png
