//
//  ContentView.swift
//  KingfisherTest
//
//  Created by 김동현 on 3/12/25.
//

/*
 https://magomercy.com/swift/swiftui-list-lazyVStack-scrollView-2탄
 
 // 이미지의 원래 비율을 유지하며 프레임 내에 맞게 조정
 .aspectRatio(contentMode: .fit)
 */

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    let imageUrls = [
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%91%E1%85%B5%E1%84%8F%E1%85%A1%E1%84%8E%E1%85%B2.png?alt=media&token=68c2ffff-81a5-4db9-a67e-b776242cea02",
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%8C%E1%85%A1%E1%86%B7%E1%84%86%E1%85%A1%E1%86%AB%E1%84%87%E1%85%A9.png?alt=media&token=e040d3d4-dd5e-4d81-b5e8-55c44c4f1606",
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A1%E1%86%BC%E1%84%92%E1%85%A2%E1%84%8A%E1%85%B5.png?alt=media&token=90aafed7-36d4-4da9-84f0-05285a8184d2",
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%8C%E1%85%B2%E1%84%87%E1%85%A6%E1%86%BA.png?alt=media&token=c3ed67c4-fc4b-4122-9c4c-e75e3c18b6b6",
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%82%E1%85%A1%E1%84%8B%E1%85%A9%E1%86%BC.png?alt=media&token=8c14389d-10ad-4c5a-9562-2088316afab5",
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%8B%E1%85%B5%E1%84%87%E1%85%B3%E1%84%8B%E1%85%B5.png?alt=media&token=bfd54682-7519-4ed9-a800-ca213b858a7f",
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%85%E1%85%B5.png?alt=media&token=9f5dba67-0857-4d21-8ffb-d92db0d54566",
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%81%E1%85%A9%E1%84%87%E1%85%AE%E1%84%80%E1%85%B5.png?alt=media&token=4c72eb7f-ab20-4184-8019-fe3033ee6fbe",
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%88%E1%85%AE%E1%86%AF%E1%84%8E%E1%85%AE%E1%86%BC%E1%84%8B%E1%85%B5.png?alt=media&token=e9f65eea-70c6-486a-a647-876105edbf51",
        "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%80%E1%85%A9%E1%84%85%E1%85%A1%E1%84%91%E1%85%A1%E1%84%83%E1%85%A5%E1%86%A8.png?alt=media&token=1bc8cf35-e38b-4726-b5ec-844b0851c035"
    ]
    
    
    var body: some View {
        /*
        NavigationStack {
            List {
                ForEach(imageUrls, id: \.self) { image in
                    HStack {
                        //Image(systemName: "person")
                        KFImage(URL(string: image))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        
                    }
                }
            }
            .navigationTitle("Test")
         
        }
         */
        
        let imageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%91%E1%85%B5%E1%84%8F%E1%85%A1%E1%84%8E%E1%85%B2.png?alt=media&token=68c2ffff-81a5-4db9-a67e-b776242cea02")
        
        VStack {
            HStack {
                // 1. Kingfisher방식
                VStack {
                    KFImage(imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text("Kingfisher")
                }
                
                // 2. SwiftUI AsyncImage
                VStack {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            // 로딩 중 상태
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            // 실패시 대체 이미지
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 100, height: 100)
                    Text("AsyncImage")
                }
                
                
                // 3. 동기 방식의 이미지 로딩
                // 주의: 동기 방식은 메인 스레드를 차단할 수 있으므로 실제 앱에서는 권장되지 않는다
                // 메인 스레드에서 네트워크 요청을 동기적으로 처리하면 네트워크 응답 대기 시간 동안 UI가 멈추어 사용자 경험이 저하될 수 있다
                VStack {
                    if let imageURL = imageURL,
                       let data = try? Data(contentsOf: imageURL),
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    } else {
                        Text("이미지 로드 실패")
                            .frame(width: 100, height: 100)
                    }
                    Text("SyncImage")
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
