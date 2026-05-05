//
//  MyProfileView.swift
//  LMessenger
//
//  Created by 김동현 on 2/3/25.
//

import SwiftUI
import PhotosUI

struct MyProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: MyProfileViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("profile_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    profileView
                        .padding(.bottom, 16)
                    
                    nameView
                        .padding(.bottom, 26)
                    
                    descriptionView
                    
                    Spacer()
                    
                    menuView
                        .padding(.bottom, 58)
                }
            }
            // 상단에 취소버튼, 네비게이션 버튼
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("close")
                    }
                }
            }
            // task modifier는 onAppear가 불리기 직전에 실행된다?? => 패스트캠퍼스 설명 오류같음
            .task {
                 await viewModel.getUser()
            }
        }
    }
    
    var profileView: some View {
        
        PhotosPicker(selection: $viewModel.imageSelection,
                     matching: .images) {
            
            // AsyncImage: 앱이 재시작되면 다시 네트워크 통신을 하여 이미지를 가져오는 작업..
            // NSCache랑 비슷하게 동작 예상.. 이미지캐시로 AsyncImage 대체해보자
            
//            AsyncImage(
//                url: URL(string: viewModel.userInfo?.profileURL ?? "")) { image in
//                image.resizable()
//            } placeholder: {
//                Image("person")
//                    .resizable()
//            }
//            .frame(width: 80, height: 80)
//            .clipShape(Circle())
             
            URLImageView(urlString: viewModel.userInfo?.profileURL)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        }
    }
    
    var nameView: some View {
        Text(viewModel.userInfo?.name ?? "이름")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color.bgWh)
    }
    
    var descriptionView: some View {
        Button {
            viewModel.isPresentedDescEditView.toggle()
        } label: {
            Text(viewModel.userInfo?.description ?? "상태메시지를 입력해주세요.")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.bgWh)
        }
        .sheet(isPresented: $viewModel.isPresentedDescEditView) {
            MyProfileDescEditView(description: viewModel.userInfo?.description ?? "") { willBeDesc in
                Task {
                    await viewModel.updateDescription(willBeDesc)
                }
            }
        }
    }
    
    var menuView: some View {
        HStack(alignment: .top, spacing: 27) {
            ForEach(MyProfileMenuType.allCases, id: \.self) { menu in
                Button {
                    
                } label: {
                    VStack(alignment: .center) {
                        Image(menu.imageNames)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(menu.description)
                            .font(.system(size: 10))
                            .foregroundStyle(Color.bgWh)
                    }
                }
            }
        }
    }
}

#Preview {
    MyProfileView(viewModel: MyProfileViewModel(container: DIContainer(services: StubServices()), userId: "user1_id"))
}
