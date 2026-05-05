//
//  ch3-04-Navigation-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/7/24.
//

/*
탭뷰로 그려보기
 - 다양한 내용이 하나의 앱에 들어가야 할 때
 - 화면을 구상하고 탭으로 나누자
 - 처음부터 탭을 만들기 보다는 나눠지도록
 - 각각의 탭은 결국 하나의 화면이다
 - 하나의 화면속에는 각각의 구성
 
 예상치 못하게 온보딩화면도 탭뷰로 구현 가능하다
 - 여러개의 화면을 넘기는 방법 알아보자
 - 다양한 방법이 있지만 제공하는 방법 사용선호
 */
//
//import SwiftUI
//
//struct ch3_04_TabView_View: View {
//    
//    var body: some View {
//        TabView {
//            TabDetailView()
//                .badge(20)
//                .tabItem {
//                    Label("Received", systemImage: "tray.and.arrow.down.fill")
//                }
//            TabDetailView()
//                .tabItem {
//                    Label("Sent", systemImage: "tray.and.arrow.up.fill")
//                }
//            TabDetailView()
//                .badge("!")
//                .tabItem {
//                    Label("Account", systemImage: "person.crop.circle.fill")
//                }
//        }
//        //.tabViewStyle(.page(indexDisplayMode: .always))
//    }
//}
//
//#Preview {
//    ch3_04_TabView_View()
//}
//
//
//
//struct TabDetailView: View {
//    var body: some View {
//        Text("hello")
//    }
//}



// MARK: - 알아두면 좋은 기능
import SwiftUI

struct ch3_04_TabView_View: View {
    
    var body: some View {
        TabView {
            TabDetailView()
//                .badge(20)
//                .tabItem {
//                    Label("Received", systemImage: "tray.and.arrow.down.fill")
//                }
            TabDetailView2()
//                .tabItem {
//                    Label("Sent", systemImage: "tray.and.arrow.up.fill")
//                }
            TabDetailView3()
//                .badge("!")
//                .tabItem {
//                    Label("Account", systemImage: "person.crop.circle.fill")
//                }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview {
    ch3_04_TabView_View()
}



struct TabDetailView: View {
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            Text("This is Detail")
        }
    }
}

struct TabDetailView2: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("This is Detail2")
        }
    }
}

struct TabDetailView3: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Text("This is Detail3")
                
                Button {
                    
                } label: {
                    Text("계속하기")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
