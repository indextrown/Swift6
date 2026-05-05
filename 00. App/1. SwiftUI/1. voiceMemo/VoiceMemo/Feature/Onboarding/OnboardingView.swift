//
//  OnboardingView.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/24/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    @StateObject private var memoListViewModel = MemoListViewModel()

    var body: some View {
        
        // TODO: - 화면 전환 구현 필요
        // MARK: - SwiftUi는 NavigationStack의 path 바인딩을 통해 스택을 관리하고 배열의 마지막 요소가 화면에 반영되도록 설계되어 있다
        NavigationStack(path: $pathModel.paths) {
            // MARK: - paths가 비어 있을 때 표시되는 기본 콘텐츠
             OnboardingContentView(onboardingViewModel: onboardingViewModel)
                .navigationDestination(for: PathType.self) { pathType in    // 종착지
                    switch pathType {
                    case .homeView:
                        HomeView()
                            .navigationBarBackButtonHidden() // 네비게이션바 커스텀으로 만들거라서 숨기자
                            .environmentObject(todoListViewModel)
                            .environmentObject(memoListViewModel)

                    case .todoView:
                        TodoView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(todoListViewModel)
                        
                    case let .memoView(isCreatedMode, memo):
                        // 메모 뷰로 넘어갈때 두가지 모드가 존재해서 파라미터로 받을 수 있다.
                        MemoView(
                            memoViewModel: isCreatedMode
                            ? MemoViewModel(memo: Memo(title: "", content: "", date: .now)) // create 모드
                            : MemoViewModel(memo: memo ?? Memo(title: "", content: "", date: .now)), // viewer 모드(편집가능)
                            isCreatedMode: isCreatedMode
                        )
                            .navigationBarBackButtonHidden()
                            .environmentObject(memoListViewModel)
                    }
                }
        }
        .environmentObject(pathModel)
    }
}

// MARK: - 온보딩 컨텐츠 뷰
// private - 다른데서 사용안되서
// fileprivatte - 초기화시에는 파일 내에서만 사용
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            // 온보딩 셀리스트 뷰
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            Spacer()
            
            // 시작 버튼 뷰
            StartBtnView()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex = 0
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            // 온보딩 셀
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5) // width는 꽉차게 height는 2/3정도 높이
        .background(
            selectedIndex % 2 == 0
            ? Color.customSky
            : Color.customBackgroundGreen
        )
        .clipped() // 탭뷰에서 잘리는 부분은 과감히 삭제
    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    
    fileprivate init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack {
            Image(onboardingContent.imageFileName)
                .resizable()    // 이미지 크기 조절 가능
                .scaledToFit()  // 화면에 꽉차고 비율 유지
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                }
                
                Spacer()
            }
            .background(Color.customWhite)
            .cornerRadius(0)
        }
        .shadow(radius: 10)
    }
}

// MARK: - 시작하기 버튼 뷰
private struct StartBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        Button {
            pathModel.paths.append(.homeView)
        } label: {
            Text("시작하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.customGreen)
            
            Image("startHome")
                .renderingMode(.template)   // template: 색상을 변경해주기 위해 사용
                .foregroundColor(.customGreen)
        }
        .padding(.bottom, 50)
    }
}

struct OnboardingView_prevoews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
