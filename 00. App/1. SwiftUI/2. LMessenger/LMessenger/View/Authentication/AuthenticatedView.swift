//
//  AuthenticatedView.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

/*
 @StateObject의 역할
 @StateObject는 SwiftUI에서 뷰의 생명 주기 동안 ViewModel이나 객체의 소유권을 유지하기 위해 사용됩니다.
 @StateObject로 선언된 객체는 뷰가 새로 생성될 때 한 번만 초기화되며, 이후에는 동일한 인스턴스를 유지합니다.
 
 init 시점의 의미
 AuthenticatedView의 init 시점은 뷰가 처음 생성될 때를 말합니다. @StateObject는 이 초기화 과정에서 객체의 소유권을 가지며,
 SwiftUI는 뷰가 재생성되더라도 같은 StateObject 인스턴스를 재사용합니다.
 따라서 AuthenticatedView를 생성할 때 AuthenticationViewModel을 초기화하는 코드는 다음 순서로 실행됩니다:
 
 AuthenticatedView(authViewModel: AuthenticationViewModel()) 호출.
 AuthenticationViewModel 생성.
 생성된 AuthenticationViewModel이 @StateObject로 관리되기 시작.
 
 MARK: 정리
 AuthenticatedView가 생성될 때, AuthenticationViewModel이 함께 생성됩니다.
 중요한 부분은 AuthenticationViewModel이 container를 주입받아야 한다는 의도입니다.
 
 MARK: 결론
 @StateObject는 뷰의 초기화 시점에 뷰 모델을 한 번만 생성하고 유지하는 데 사용됩니다.
 init 시점에서 AuthenticationViewModel을 생성하거나 의존성을 주입하는 이유는 뷰 모델이 뷰의 동작에 필요한 상태와 로직을 관리하기 때문입니다.
 container와 같은 의존성을 다루려면 AuthenticationViewModel 생성 시 의존성을 주입하는 패턴이 적합합니다.
 
 
 의존성 주입(DI)의 원칙을 따르기 위해
 @StateObject var authViewModel: AuthenticationViewModel = AuthenticationViewModel()처럼 뷰 내부에서 뷰 모델을 직접 생성하면, 
 의존성 주입이 불가능합니다.
 반면, 외부에서 객체를 생성하고 주입하는 패턴은 테스트 및 재사용성이 훨씬 유리합니다.
 예:

 struct AuthenticatedView: View {
     @StateObject var authViewModel: AuthenticationViewModel
 }

 // Preview나 실제 코드에서 외부 주입
 let container = DIContainer(services: Services())
 AuthenticatedView(authViewModel: AuthenticationViewModel(container: container))
 
 위 코드처럼 주입받으면 AuthenticationViewModel이 특정 의존성을 가질 때도 쉽게 주입할 수 있습니다.
 
 결론
 @StateObject var authViewModel: AuthenticationViewModel = AuthenticationViewModel()를 사용하지 않은 이유는 다음과 같습니다:

 유연한 의존성 주입을 지원하기 위해.
 외부에서 생성된 AuthenticationViewModel을 주입받을 수 있어야 하므로 내부에서 강제 초기화하지 않습니다.
 
 재사용성과 테스트 가능성을 높이기 위해.
 Preview 및 다양한 컨텍스트에서 뷰 모델을 주입하여 유연하게 사용할 수 있습니다.
 
 SwiftUI의 상태 관리 패턴과 일관성을 유지하기 위해.
 @StateObject를 사용해 한 번만 초기화하고 상태를 유지하며, 외부에서 객체를 전달받아 더 많은 초기화 옵션을 지원합니다.
 */

import SwiftUI

struct AuthenticatedView: View {
    
    // MARK: - ViewModel을 init하는 시점은 이 view를 만들때로 하자. 왜냐하면 viewModel에서 container를 init할 때 주입해 줄 예정
    @StateObject var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
//            authViewModel.send(action: .logout)
            authViewModel.send(action: .chechAuthenticationState)
        }
    }
}

#Preview {
    AuthenticatedView(authViewModel: AuthenticationViewModel(container: DIContainer(services: StubServices())))
}
