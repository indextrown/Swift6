//
//  ch3-03-Navigation-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/7/24.
//

/*
 네비게이션
 - 어디로 가야할 지 알려주세요
 - 그게 네비게이션의 역할입니다
 - 여러화면의 길잡이가 네비게이션입니다
 - 키워드는 NavigationStack
 - NavigationView는 사라질예정
 - toolbar까지 챙겨볼게요
 
 NavigationStack
 - Navigation이 어디로 갔는지 기록을 해주는 녀석(보내주지는 않음)
 */
import SwiftUI

// MARK: - 노가다 방식
//struct ch3_03_Navigation_View: View {
//    var body: some View {
//        // NavigationStack은 Navigation이 어디로 갔는지 기록을 해주는 녀석(보내주지는 않음)
//        NavigationStack {
//            
//            List {
//                // 이동하도록 해줌
//                NavigationLink {
//                    Text("Destination 입니다.")
//                } label: {
//                    Text("디테일뷰로 이동하기")
//                }
//                
//                NavigationLink {
//                    Text("Destination2 입니다.")
//                } label: {
//                    Text("디테일뷰로 이동하기2")
//                }
//            }
//            .navigationTitle("네비게이션")
//        }
//    }
//}
//
//#Preview {
//    ch3_03_Navigation_View()
//}


// MARK: - 배열 2개 방식
//struct ch3_03_Navigation_View: View {
//    let titles = ["디테일뷰로 이동하기", "디테일뷰로 이동하기2"]
//    let descriptions = ["Destination 입니다1", "Destination2 입니다2"]
//    
//    var body: some View {
//        // NavigationStack은 Navigation이 어디로 갔는지 기록을 해주는 녀석(보내주지는 않음)
//        NavigationStack {
//            
//            List {
//                // 이동하도록 해줌
//                ForEach([0, 1], id: \.self) { index in
//                    NavigationLink {
//                        Text(descriptions[index])
//                    } label: {
//                        Text(titles[index ])
//                    }
//                }
//            }
//            .navigationTitle("네비게이션")
//        }
//    }
//}
//
//#Preview {
//    ch3_03_Navigation_View()
//}



// MARK: - 구조체 방식
struct NavigationModel: Hashable {
    let title: String
    let description: String
}

struct ch3_03_Navigation_View: View {

    let data = [
        NavigationModel(title: "디테일뷰로 이동하기", description: "Destination 입니다1"),
        NavigationModel(title: "디테일뷰로 이동하기2", description: "Destination 입니다2")
    ]
    
    @State var showModal: Bool = false
    
    var body: some View {
        // NavigationStack은 Navigation이 어디로 갔는지 기록을 해주는 녀석(보내주지는 않음)
        NavigationStack {
            List {
                
                ForEach(data, id: \.self) { item in
                    // 이동하도록 해줌(쌓이도록 도와줌)
                    NavigationLink {
                        Text(item.description)
                    } label: {
                        Text(item.title)
                    }
                }
            }
            .toolbar {
                // MARK: 우측 상단
                ToolbarItem {
                    Button {
                        showModal.toggle()
                    } label: {
                        Text("Add")
                    }
                }
                /*
                 MARK: 하단
                 .bottomBar
                 .leading
                 .trailing
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showModal.toggle()
                    } label: {
                        Text("Add")
                    }
                }
                 */
            }
            .sheet(isPresented: $showModal, content: {
                Text("아이템 추가 페이지 입니다.")
            })
            .navigationTitle("네비게이션")
        }
    }
}

#Preview {
    ch3_03_Navigation_View()
}
