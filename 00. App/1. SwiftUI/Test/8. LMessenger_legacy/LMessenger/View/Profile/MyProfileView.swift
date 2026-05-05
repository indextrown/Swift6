//
//  MyProfileView.swift
//  LMessenger
//
//  Created by 김동현 on 11/1/24.
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
                    .aspectRatio(contentMode: .fill)    // 비율을 유지하며 컨테이너를 채우도록 설정
                    .ignoresSafeArea(edges: .vertical)  // 기본적으로 이미지 뷰는 safe area를 포함하지 않음 -> 영역을 넓히기 위해 적용하자
                
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("close")
                    }
                }
            }
            // task라는 modifier는 onappear가 불리기 직전에 실행됨
            .task {
                await viewModel.getUser()
            }
        }
    }
    
    var profileView: some View {
        PhotosPicker(selection: $viewModel.imageSelection,
                     matching: .images) {
            Image("person")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())     //  뷰를 특정 모양으로 잘라내는 데 사용
        }
    }
    var nameView: some View {
        Text(viewModel.userInfo?.name ?? "이름")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.bgWh)
    }
    var descriptionView: some View {
        Button {
            viewModel.isPresentedDescEditView.toggle()
        } label: {
            Text(viewModel.userInfo?.description ?? "상태메시지를 입력해주세요.")
                .font(.system(size: 14))
                .foregroundColor(.bgWh)
        }
        .sheet(isPresented: $viewModel.isPresentedDescEditView) {
            MyProfileDescEditView(description: viewModel.userInfo?.description ?? "") { willBeDesc in
                // TODO: -
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
                        Image(menu.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(menu.description)
                            .font(.system(size: 10))
                            .foregroundColor(.bgWh)
                    }
                }
            }
        }
    }
}

#Preview {
    MyProfileView(viewModel: .init(container: DIContainer(services: StubService()), userId: "user1_id"))
}
