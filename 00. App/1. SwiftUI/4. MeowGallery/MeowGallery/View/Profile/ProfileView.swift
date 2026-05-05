//
//  ProfileView.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isUploadPresented: Bool = false
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                TitleView(title: "My List")
                Spacer()
                DarkModeButton(isDarkMode: $isDarkMode)
                UploadPresentButton(isUploadPresented: $isUploadPresented)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            ProfileViewListView(profileViewModel: profileViewModel)
                .padding(.top, 20)
            
        } // VStack
        .sheet(isPresented: $isUploadPresented) {
            UploadView(profileViewModel: profileViewModel)
                .presentationDetents([.fraction(0.9)])
        }
    }
}

// 리스트 뷰
private struct ProfileViewListView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    private let columnsCount = 3
    private let spacing: CGFloat = 10
    private let horizontalPadding: CGFloat = 20

    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnsCount)
    }

    var imageSize: CGFloat {
        let availableWidth = UIScreen.main.bounds.width - horizontalPadding * 2 - spacing * CGFloat(columnsCount - 1)
        return availableWidth / CGFloat(columnsCount)
    }

    var body: some View {
        ScrollView {
            
            HeatmapView(profileViewModel: profileViewModel)
            
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(profileViewModel.myCatList) { cat in
                    MyCatImageView(profileViewModel: profileViewModel, width: imageSize, height: imageSize, cat: cat)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, horizontalPadding)
        }
        .refreshable {
            profileViewModel.fetchMyCats()
        }
    }
}

// 이미지 뷰
private struct MyCatImageView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    var width: CGFloat
    var height: CGFloat
    let cat: Cat
    
    fileprivate var body: some View {
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
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
            .contextMenu {
                Button (role: .destructive){
                    profileViewModel.removeMyCat(id: cat.id)
                } label: {
                    Label("삭제", systemImage: "trash")
                }
            }
    }
}

// 업로드 뷰
private struct UploadView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    fileprivate var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.8,
                        height: UIScreen.main.bounds.width * 0.8,
                        alignment: .center)
                    .cornerRadius(20)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .padding()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.8,
                        height: UIScreen.main.bounds.width * 0.8,
                        alignment: .center)
                    .cornerRadius(20)
            }
            
            HStack {
                // 앨범 버튼
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Label("앨범", systemImage: "photo")
                            .padding()
                            .frame(width: 120, height: 50)
                            .foregroundStyle(.mainWhite)
                            .background(.mainBlack)
                            .cornerRadius(10)
                    }
                    .onChange(of: selectedItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                selectedImage = image
                            }
                        }
                    }
                
                Button {
                    profileViewModel.uploadCat(image: selectedImage!)
                    dismiss()
                } label: {
                    Text("업로드")
                        .padding()
                        .frame(width: 120, height: 50)
                        .foregroundStyle(.mainWhite)
                        .background(.mainBlack)
                        .cornerRadius(10)
                }
            } // HStack
        }
    }
}

// 다크모드 토글 버튼
private struct DarkModeButton: View {
    @Binding var isDarkMode: Bool
    
    fileprivate var body: some View {
        Button {
            isDarkMode.toggle()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } label: {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(.mainBlack)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 0.5)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.mainBlack)
                }
        } // Button
    } // View
}

// 업로드 화면 열기 버튼
private struct UploadPresentButton: View {
    @Binding var isUploadPresented: Bool
    
    fileprivate var body: some View {
        Button {
            isUploadPresented.toggle()
        } label: {
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(.mainBlack)
        }  
    }
}

#Preview {
    ProfileView(profileViewModel: ProfileViewModel())
}

#Preview {
    UploadView(profileViewModel: ProfileViewModel())
}

#Preview {
    MainTabView()
}
