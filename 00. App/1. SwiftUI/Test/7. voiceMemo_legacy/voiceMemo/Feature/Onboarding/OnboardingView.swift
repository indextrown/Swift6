//
//  OnboardingView.swift
//  voiceMemo
//

//import SwiftUI
//
//struct OnboardingView: View {
//    @StateObject private var pathModel = PathModel()
//    @StateObject private var onboardingViewModel = OnboardingViewModel() // 처음 선언이라 StateObject로 선언해줌(온보딩뷰모델)
//    @StateObject private var todoListViewModel: TodoListViewModel
//    
//    
//    var body: some View {
//        
//        // TODO: - 화면 전환 구현 완료
//        NavigationStack(path: $pathModel.paths) {
//            OnboardingContentView(onboardingViewModel: onboardingViewModel)
//                .navigationDestination(for: PathType.self) { pathType in
//                    switch pathType {
//                    case .homeView:
//                        // MARK: - 디버깅용 임시로 사용
//                        TodoView()
//                            .navigationBarBackButtonHidden()
//                            .environmentObject(todoListViewModel)
//                            
//                        
////                        HomeView()
////                            .navigationBarBackButtonHidden()    // 커스텀 탭을 위해 숨김
//                    case .todoView:
//                     
//                        TodoView()
//                            .navigationBarBackButtonHidden()
//                            .environmentObject(todoListViewModel)
//                        //TodoView()
//                            //.navigationBarBackButtonHidden()
//                    case .memoView:
//                        MemoView()
//                            .navigationBarBackButtonHidden()
//                    }
//                }
//        }
//        // 각 뷰들을 pathModel을가지고 뒤로빠져나가는역할 -> environmentObject 로 감싸줘야함 -> 전역적사용으로 관리 수월해진다
//        .environmentObject(pathModel) // 전역주입
//    }
//}
//
//// MARK: - 온보딩 컨텐츠 뷰
//private struct OnboardingContentView: View {
//    @ObservedObject private var onboardingViewModel: OnboardingViewModel
//    
//    // 상위뷰에서만 사용, 이파일내에서만 사용되서 private사용, 초기화 선언시 이 파일내에서만 사용하기 위해 fileprivate로 둠
//    // 이게 private이면 OnboardingView에서 사용불가능해진다
//    fileprivate init(onboardingViewModel: OnboardingViewModel) {
//        self.onboardingViewModel = onboardingViewModel
//    }
//    
//    fileprivate var body: some View {
//        VStack {
//            // 온보딩 셀리스트 뷰
//            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
//            
//            Spacer()
//            
//            // 시작 버튼 뷰
//            StartBtnView()
//        }
//        // 위쪽 꽉채워줌(SafeArea 무시)
//        .edgesIgnoringSafeArea(.top)
//    }
//}
//
//// MARK: - 온보딩 셀리스트 뷰
//private struct OnboardingCellListView: View {
//    @ObservedObject private var onboardingViewModel: OnboardingViewModel
//    @State private var selectedIndex: Int    // 배경 변화
//    
//    fileprivate init(
//        onboardingViewModel: OnboardingViewModel,
//        selectedIndex: Int = 0
//    ) {
//        self.onboardingViewModel = onboardingViewModel
//        self.selectedIndex = selectedIndex
//    }
//    
//    fileprivate var body: some View {
//        TabView(selection: $selectedIndex) {
//            // 온보딩 셀
//            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
//                    OnboardingCellView(onboardingContent: onboardingContent)
//                    .tag(index)
//            }
//        }
//        // 탭뷰스타일: 페이지
//        .tabViewStyle(.page(indexDisplayMode: .never))
//        // 프레임은 전체적으로 꽉차게 -> 2/3
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
//        .background(
//            // 짝수는 하늘색 홀수는 그린색
//            selectedIndex % 2 == 0
//            ? Color.customSky
//            : Color.customBackgroundGreen
//        )
//        // 탭뷰로 인해 잘리는 부분이 존재 -> 과감히 절삭
//        .clipped()
//    }
//}
//
//// MARK: - 온보딩 셀 뷰
//private struct OnboardingCellView: View {
//    private var onboardingContent: OnboardingContent
//    
//    fileprivate init(
//        onboardingContent: OnboardingContent
//    ) {
//        self.onboardingContent = onboardingContent
//    }
//    
//    fileprivate var body: some View {
//        VStack {
//            Image(onboardingContent.imageFileName)
//                .resizable()
//                .scaledToFit()// 화면꽉차면서 비율유지
//            
//            HStack {
//                Spacer()
//                
//                VStack {
//                    Spacer()
//                        .frame(height: 46)
//                    
//                    Text(onboardingContent.title)
//                        .font(.system(size: 16, weight: .bold))
//                    
//                    Spacer()
//                        .frame(height: 5)
//                    
//                    Text(onboardingContent.subTitle)
//                        .font(.system(size: 16))
//                }
//                Spacer()
//            }
//            .background(Color.customWhite)
//            .cornerRadius(0) // shadow를 위함
//        }
//        .shadow(radius: 10)
//    }
//}
//
//// MARK: - 시작하기 버튼 뷰(뷰모델필요x, 비즈니스로직필요x)
//private struct StartBtnView: View {
//    @EnvironmentObject private var pathModel: PathModel
//    
//    fileprivate var body: some View {
//        Button(
//            action: {
//                pathModel.paths.append(.homeView) //
//            },
//            label: {
//                HStack {
//                    Text("시작하기")
//                        .font(.system(size: 16, weight: .medium))
//                        .foregroundColor(.customGreen)
//                    
//                    Image("startHome")
//                        .renderingMode(.template)   // 색상변경해주기위해사용
//                        .foregroundColor(.customGreen)
//                }
//            }
//        )
//        // 하단부터 50 공백
//        .padding(.bottom, 50)
//    }
//}
//
//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//    OnboardingView()
//    }
//}


//  OnboardingView.swift
//  voiceMemo



import SwiftUI

struct OnboardingView: View {
  @StateObject private var pathModel = PathModel()
  @StateObject private var onboardingViewModel = OnboardingViewModel()
  @StateObject private var todoListViewModel = TodoListViewModel()

  
  var body: some View {
    // MARK: - 초기 온보딩 컨텐츠뷰를 초기점으로 만들어줌
    NavigationStack(path: $pathModel.paths) {
      OnboardingContentView(onboardingViewModel: onboardingViewModel)
        .navigationDestination(
          for: PathType.self,
          
          // MARK: - 어디를 갈지 지정해줌 -> 구분자 path타입 사용
          destination: { pathType in
            switch pathType {
            case .homeView:
                TodoView()
                    .navigationBarBackButtonHidden()
                    .environmentObject(todoListViewModel)
              
            case .todoView:
              TodoView()
                .navigationBarBackButtonHidden()
                .environmentObject(todoListViewModel)
                
            case .memoView:
                MemoView()
                    .navigationBarBackButtonHidden()
            
            }
          }
        )
    }
      // MARK: - 전역적으로 pathModel을 사용하기위해 전역적으로 주입
    .environmentObject(pathModel)
  }
}

// MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
  @ObservedObject private var onboardingViewModel: OnboardingViewModel
  
  fileprivate init(onboardingViewModel: OnboardingViewModel) {
    self.onboardingViewModel = onboardingViewModel
  }
  
  fileprivate var body: some View {
    VStack {
      OnboardingCellListView(onboardingViewModel: onboardingViewModel)
      
      Spacer()
      
      StartBtnView()
    }
    .edgesIgnoringSafeArea(.top)
  }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
  @ObservedObject private var onboardingViewModel: OnboardingViewModel
  @State private var selectedIndex: Int
  
  fileprivate init(
    onboardingViewModel: OnboardingViewModel,
    selectedIndex: Int = 0
  ) {
    self.onboardingViewModel = onboardingViewModel
    self.selectedIndex = selectedIndex
  }
  
  fileprivate var body: some View {
    TabView(selection: $selectedIndex) {
      ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
        OnboardingCellView(onboardingContent: onboardingContent)
          .tag(index)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
    .background(
      selectedIndex % 2 == 0
      ? Color.customSky
      : Color.customBackgroundGreen
    )
    .clipped()
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
        .resizable()
        .scaledToFit()
      
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
    Button(
      action: { pathModel.paths.append(.homeView) },
      label: {
        HStack {
          Text("시작하기")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.customGreen)
          
          Image("startHome")
            .renderingMode(.template)
            .foregroundColor(.customGreen)
        }
      }
    )
    .padding(.bottom, 50)
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
