//
//  HomeView.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    /// MainTabView 기준으로 자식에게만 viewModel을 전달하기 때문에 @ObservedObject을 사용했습니다.
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            TitleView(title: "Meow List")
                .padding(.top, 20)
                .padding(.leading, 20)
            
            MeowListView(homeViewModel: homeViewModel)
                .padding(.top, 20)
        }
    }
}

// 리스트뷰
private struct MeowListView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    fileprivate var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(homeViewModel.catList) { cat in
                    CatImageView(
                        width: UIScreen.main.bounds.width * 0.8,
                        height: UIScreen.main.bounds.width * 0.8,
                        cat: cat)
                        .onAppear {
                            if homeViewModel.catList.last == cat {
                                homeViewModel.loadMore()
                            }
                        }
                } // ForEach
            } // VStack
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
        } // ScrollView
        .refreshable {
            homeViewModel.refresh()
        }
    }
}

// 고양이 이미지뷰
struct CatImageView: View {
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel
    var width: CGFloat
    var height: CGFloat
    let cat: Cat
    
    var body: some View {
        VStack {
            // 1 외부 라이브러리 방식
            KFImage(URL(string: cat.url))
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: width,
                    height: height,
                    alignment: .center)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        // 북마크에 존재하지 않는다면 좋아요를 진행
                        if bookmarkViewModel.bookmarkedCatList.allSatisfy({ $0.id != cat.id }) {
                            // 좋아요 액션
                            bookmarkViewModel.bookmarkCat(id: cat.id)
                        }
                        
                    } label: {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                    .padding()
                    .contentShape(Rectangle()) // 전체 영역을 터치 영역으로 설정
                }
            
            // 2. AsyncImage 방식
            /*
            AsyncImage(url: URL(string: cat.url)!) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 240, height: 240, alignment: .center)
                        .cornerRadius(20)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 320, height: 320, alignment: .center)
                        .cornerRadius(20)
                        ///  radius: 그림자 흐림 정도    x, y: 그림자 오프셋
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
                        .overlay(alignment: .bottomTrailing) {
                            Button {
                                
                            } label: {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .foregroundStyle(.red)
                                    // .foregroundStyle(.white.opacity(0.7))
                            }.padding()
                        }
                        
                case .failure:
                    Image(systemName: "person.fill.questionmark")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding()
                        .frame(width: 240, height: 240, alignment: .center)
                        .cornerRadius(20)
                @unknown default:
                    EmptyView()
                        .frame(width: 240, height: 240, alignment: .center)
                        .cornerRadius(20)
                }
            }
            // .onAppear(perform: onAppearAction)
             */
        }
    }
}

#Preview {
    MainTabView()
}
