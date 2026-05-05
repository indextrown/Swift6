//
//  BookmarkView.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import SwiftUI
import Kingfisher

struct BookmarkView: View {
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel
    var body: some View {
        VStack(spacing: 0) {
            TitleView(title: "Favorite List")
                .padding(.top, 20)
                .padding(.leading, 20)
            
            BookMarkListView(bookmarkViewModel: bookmarkViewModel)
                .padding(.top, 20)
        }
    }
}

private struct BookMarkListView: View {
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    // 2개의 flexible한 열로 그리드 구성
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    fileprivate var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(bookmarkViewModel.bookmarkedCatList) { cat in
                    BookmarkImageView(cat: cat)
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
        .refreshable {
            bookmarkViewModel.fetchBookmarkedCats()
        }
    }
}


/*
private struct BookMarkListView: View {
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    fileprivate var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(bookmarkViewModel.bookmarkedCatList, id: \.self) { cat in
                    BookmarkImageView(cat: cat)
//                        .onAppear {
//                            print(cat.id)
//                            print(cat.bookmarkId!)
//                            print(cat.url)
//                        }
                }
            }
            .padding(.top, 30)
        }
        .refreshable {
            bookmarkViewModel.fetchBookmarkedCats()
        }
    }
}
*/

struct BookmarkImageView: View {
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel
    
    let cat: Cat
    @State private var isBookmarked: Bool = true
    
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
                    width: UIScreen.main.bounds.width * 0.4,
                    height: UIScreen.main.bounds.width * 0.4,
                    alignment: .center)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        // 좋아요 액션
                        bookmarkViewModel.removeBookmarkCat(bookmarkId: cat.bookmarkId!)
                        isBookmarked.toggle()
                        
                    } label: {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .foregroundColor(isBookmarked ? .red : .white)
                    }
                    .padding()
                    .onAppear {
                        // 북마크 해제 후 다시 좋아요를 누르면 기존의 @State가 남아있어 흰색하트로 이미지가 나타나기 떄문에 명시적으로 true 설정
                        // HomeView에서 좋아요 버튼을 누를 때 id로 고유성을 식별하기 때문에 항상 true로 생성해도 된다고 생각하였음
                        isBookmarked = true
                    }
                }
        }
    }
}

#Preview {
    BookmarkView()
        .environmentObject(BookmarkViewModel())
}

