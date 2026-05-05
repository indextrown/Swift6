//
//  ProfileView.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import SwiftUI

struct ProfileView: View {
    
    // @State var userData: UserData? = nil
    @EnvironmentObject var userViewModel: UserViewModel
    @State var id: String = ""
    @State var name: String = ""
    @State var email: String = ""
    @State var avataImage: String = ""

    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        if !avataImage.isEmpty {
                            AsyncImage(url: URL(string: avataImage)!) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
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
                        } else {
                            Image(systemName: "person.fill.questionmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                                .frame(width: 250, height: 250, alignment: .center)
                        }
                        Spacer()
                    }
                }
                Section {
                    Text("아이디: \(id)")
                    Text("이름: \(name)")
                    Text("이메일: \(email)")
                }
                Section {
                    Button {
                        print("새로 고침 버튼 클릭")
                        userViewModel.fetchCurrentUserInfo()
                    } label: {
                        Text("새로고침")
                    }
                }
            }
            .onAppear {
                print("ProfileView onAppear() called")
                userViewModel.fetchCurrentUserInfo()
            }
            .onReceive(userViewModel.$loggedInUser) { loggedInUser in
                print("ProfileView onReceive() called")
                guard let user = loggedInUser else { return }
                self.id = "\(user.id)"
                self.name = user.name
                self.email = user.email
                self.avataImage = user.avatar
            }
        }
        .navigationTitle("프로필")
    }
}

#Preview {
    ProfileView()
}


//https://res.cloudinary.com/ppak-coders-com/image/upload/v1666424389/f4uoyyjgfo2pantau0zx.png
