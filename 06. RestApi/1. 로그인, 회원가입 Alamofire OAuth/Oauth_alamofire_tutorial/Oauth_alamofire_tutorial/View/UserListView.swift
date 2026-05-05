//
//  UserListView.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import SwiftUI

// 사용자 목록 뷰
struct UserListView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var users: [UserData] = [
//        UserData(id: 1, name: "1", email: "Index1@gmail.com", avatar: "https://res.cloudinary.com/ppak-coders-com/image/upload/v1666424389/f4uoyyjgfo2pantau0zx.png"),
//        UserData(id: 2, name: "2", email: "Index2@gmail.com", avatar: "https://res.cloudinary.com/ppak-coders-com/image/upload/v1666424389/f4uoyyjgfo2pantau0zx.png"),
//        UserData(id: 3, name: "3", email: "Index3@gmail.com", avatar: "https://res.cloudinary.com/ppak-coders-com/image/upload/v1666424389/f4uoyyjgfo2pantau0zx.png")
    ]
    
    var body: some View {
        List(users) { user in
            NavigationLink {
                OtherUserProfileView(userData: user)
            } label: {
                HStack {
                    AsyncImage(url: URL(string: user.avatar)!) { phase in
                        switch phase {
                        case .empty:
                            ProfileView()
                                .frame(width: 120, height: 120, alignment: .center)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120, alignment: .center)
                        case .failure:
                            Image(systemName: "person.fill.questionmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                                .frame(width: 120, height: 120, alignment: .center)
                        default:
                            EmptyView()
                                .frame(width: 120, height: 120, alignment: .center)
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(user.name).font(.title3)
                        Text(user.email).font(.callout)
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("사용자 목록")
        .onAppear {
            userViewModel.fetchUsers()
        }
        .onReceive(userViewModel.$users) { self.users = $0 }
            
        
    }
}

#Preview {
    UserListView()
}

