//
//  ContentView.swift
//  Annotation
//
//  Created by 김동현 on 11/4/24.
//

/*
 MARK: - 언제 @StateObject를 사용해야 할까?
 - 상태 객체의 소유권을 가지는 뷰에서 사용하여 해당 상태의 생명 주기를 관리할 때
 - 상위 뷰에서 생성한 상태 객체를 여러 하위 뷰에 전달할 때 상위 뷰에서 @StateObject로 한 번만 생성
 - @EnvironmentObject, @ObservedObject로 전달할 객체는 상위 뷰에서 @StateObject로 먼저 선언해 초기화
 - 단, 하위 뷰에서 독립적으로 사용하는 객체를 직접 @ObservedObject로 초기화하는 경우 @StateObject는 필요 없음
   (예: 해당 뷰에서만 필요한 데이터를 관리할 때)
 - 그러나, 하위 뷰에서 직접 @ObservedObject로 객체를 초기화하면 생명 주기 관리가 어려워지고,
   다른 뷰와 일관된 상태 관리가 어려워질 수 있음
 - 따라서, 상태가 여러 뷰에서 공유되거나 상위 뷰와 데이터 일관성이 필요하면 상위 뷰에서 @StateObject로 관리하는 것이 바람직

 정리: 상태가 여러 뷰에서 필요하거나 일관된 상태 관리를 위해서는 상위 뷰에서 @StateObject를 사용해 관리하는 것이 좋음



 MARK: - 언제 @EnvironmentObject를 사용해야 할까?(참조역할)
 - 여러 뷰 계층에서 상태를 공유할 경우
 - 부모 - 자식 간 뷰 계층이 깊을 때
 - 전역적으로 데이터를 참조하지만 직접 수정이 필요하지 않을 때
 ex) 사용자 로그인 정보를 앱 전역에서 공유
 
 
 MARK: - 언제 @ObservedObject를 사용해야 할까?(참조역할)
 - 부모 뷰가 특정 뷰에 전달하는 상태로, 해당 뷰와 그 하위뷰에서만 관리되는 데이터를 공유시 사용
 - 독립적인 데이타 관리가 필요할 때
 - 단일 뷰와 그 하위 뷰에서만 사용되는 데이터일 때
 ex) 게시글 목록뷰와 게시글뷰는 다른 뷰와 관련 없음 이럴때 사용
*/


import SwiftUI

struct User {
    var username: String
    var isLoggedIn: Bool
}

// MARK: - ViewModel
class UserSettings: ObservableObject {
    @Published var user: User
    
    init(user: User = User(username: "Annonymous", isLoggedIn: false)) {
        self.user = user
    }

}

struct ContentView: View {
    @StateObject var userSettings = UserSettings()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(userSettings.user.username)")
                NavigationLink(destination: ProfileView()) {
                    Text("Go to Profile")
                }
                NavigationLink(destination: SettingView()) {
                    Text("Go to Setting")
                }
                NavigationLink(destination: DetailView(userSettings: userSettings)) {
                    Text("Go to Setting")
                }
                
            }
            .environmentObject(userSettings)
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        VStack {
            Text("Username: \(userSettings.user.username)")
            TextField("Change Username", text: $userSettings.user.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .navigationTitle("Profile")
    }
}

struct SettingView: View {
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        VStack {
            Text("Current User: \(userSettings.user.username)")
            Text("Login Status: \(userSettings.user.isLoggedIn ? "Logged In" : "Logged Out")")
        }
        .navigationTitle("Settings")
    }
}

struct DetailView: View {
    @ObservedObject var userSettings: UserSettings
    
    var body: some View {
        VStack {
            Text("Detail Username: \(userSettings.user.username)")
            Button {
                userSettings.user.isLoggedIn.toggle()
            } label: {
                Text("Login Status: \(userSettings.user.isLoggedIn ? "Logged In" : "Logged Out")")
            }
        }
        .navigationTitle("Detail")
    }
}

// MARK: - 기본생성자로 기본값 사용
#Preview {
    ContentView()
        .environmentObject(UserSettings())
}

// MARK: - 초기값을 미리보기에 전달 가능
// ContentView는 @StateObject로 userSettings를 직접 생성하지만, 하위 뷰(ProfileView, SettingView)에 이 객체를 전달하려면 .environmentObject(userSettings)로 전달해야함
#Preview {
    ContentView()
        .environmentObject(UserSettings(user: User(username: "Preview User", isLoggedIn: true)))
}

// MARK: - EnviromentObject를 사용하는 뷰에는 직접적으로 매개변수를 전달하지 않는다
// environmentObject를 통해 주입한다
#Preview {
    SettingView()
        .environmentObject(UserSettings())
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
}

#Preview {
    DetailView(userSettings: UserSettings())
}




//
//import SwiftUI
//
//// 사용자 로그인 상태 관리 (전역적으로 공유)
//class UserSettings: ObservableObject {
//    @Published var isLoggedIn: Bool = false
//    @Published var username: String = "Guest"
//}
//
//// 게시물 목록 관리 (특정 뷰에서만 필요)
//class PostList: ObservableObject {
//    @Published var posts: [String] = ["First Post", "Second Post"]
//}
//
//// MARK: - App Root View
//
//struct AppRootView: View {
//    @StateObject var userSettings = UserSettings() // 전역 상태 객체 생성
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if userSettings.isLoggedIn {
//                    ContentView()
//                        .environmentObject(userSettings) // 전역 상태를 하위 뷰에 주입
//                } else {
//                    LoginView()
//                        .environmentObject(userSettings)
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Login View
//struct LoginView: View {
//    @EnvironmentObject var userSettings: UserSettings
//
//    var body: some View {
//        VStack {
//            Text("Please log in")
//            Button("Log in as User1") {
//                userSettings.username = "User1"
//                userSettings.isLoggedIn = true
//            }
//        }
//    }
//}
//
//// MARK: - Content View
//struct ContentView: View {
//    @EnvironmentObject var userSettings: UserSettings
//
//    var body: some View {
//        VStack {
//            Text("Welcome, \(userSettings.username)")
//            NavigationLink(destination: PostListView()) {
//                Text("Go to Posts")
//            }
//        }
//    }
//}
//
//// MARK: - Post List View
//struct PostListView: View {
//    @ObservedObject var postList = PostList() // 특정 뷰에서만 사용하는 상태 객체
//
//    var body: some View {
//        VStack {
//            Text("Posts")
//            List(postList.posts, id: \.self) { post in
//                Text(post)
//            }
//            Button("Add Post") {
//                postList.posts.append("New Post \(postList.posts.count + 1)")
//            }
//        }
//        .navigationTitle("Posts")
//    }
//}
//
//#Preview {
//    AppRootView()
//}
//
//#Preview {
//    LoginView()
//        .environmentObject(UserSettings())
//}
//
//#Preview {
//    ContentView()
//        .environmentObject(UserSettings())
//}
//
//#Preview {
//    PostListView(postList: PostList())
//}
