//
//  SearchBar.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/7/25.
//
//
//import SwiftUI
//import BottomSheet
//
//struct SearchBar: View {
//    @State private var bottomSheetPosition: BottomSheetPosition = .relative(0.6)
//    @State private var text = ""
//    @State private var mapSearchTextFieldFrame: CGRect = .zero
//    var body: some View {
//        VStack {
//            TextField("search", text: $text)
//                .padding(.vertical, 14) // 내부 여백
//                .padding(.horizontal, 10)
//                .background(.white)
//                .cornerRadius(10)
//                .overlay {
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(lineWidth: 0.5)
//                }
//                .background {
//                    GeometryReader { geo in
//                        Color.clear
//                            .onAppear {
//                                mapSearchTextFieldFrame = geo.frame(in: .global)
//                            }
//                        
//                    }
//                }
//            
//            Spacer()
//        }
//        .padding(.horizontal)
//        .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
//                     switchablePositions: [
//                        .relative(0.6),
//                        .absoluteTop(UIScreen.main.bounds.height - (mapSearchTextFieldFrame.maxY + 20))
//                     ]) {
//            // body
//        }
//         .enableAccountingForKeyboardHeight(false)
//         .ignoresSafeArea(.keyboard, edges: .all)     // ✅ safe area 보정 완전 무시
//         .animation(nil, value: UUID())               // ✅ SwiftUI 자동 보간 애니메이션 차단
//         .transaction { transaction in                // ✅ 내부 트랜잭션 애니메이션 차단
//             transaction.animation = nil
//         }
//     
//    }
//}
//
//#Preview {
//    SearchBar()
//}
//




//
//  SearchBar.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/7/25.
//

import SwiftUI
import BottomSheet

struct SearchBar: View {
    @State private var bottomSheetPosition: BottomSheetPosition = .relative(0.6)
    @State private var text = ""
    @State private var mapSearchTextFieldFrame: CGRect = .zero
    @State private var fixedTop: CGFloat = 0
    @State private var initialHeight: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            // ✅ 메인 콘텐츠
            VStack {
                TextField("search", text: $text)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.5)
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                mapSearchTextFieldFrame = geo.frame(in: .global)
                                fixedTop = initialHeight - (geo.frame(in: .global).maxY + 20)
                                print("📍 fixedTop 초기값: \(Int(fixedTop))")
                            }
                        }
                    )

                Spacer()
            }
            .padding(.horizontal)
            .ignoresSafeArea(.keyboard, edges: .all)

            // ✅ 시트를 overlay로 별도 계층에 띄움
            FixedSheet(
                bottomSheetPosition: $bottomSheetPosition,
                absoluteTop: fixedTop
            )
            .allowsHitTesting(false) // ✅ 시트는 터치 무시 → TextField 정상 동작
            .zIndex(999)
        }
        .ignoresSafeArea(edges: .bottom)
//        .toolbar(.hidden, for: .tabBar) // ✅ 탭바 완전 숨김
    }
}

struct FixedSheet: UIViewControllerRepresentable {
    @Binding var bottomSheetPosition: BottomSheetPosition
    let absoluteTop: CGFloat

    func makeUIViewController(context: Context) -> UIViewController {
        let host = UIHostingController(
            rootView:
                VStack {
                    Spacer()
                    VStack {
                        Text("시트 내용 (절대 고정)")
                            .font(.headline)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
                    .bottomSheet(
                        bottomSheetPosition: $bottomSheetPosition,
                        switchablePositions: [
                            .relative(0.6),
                            .absoluteTop(absoluteTop)
                        ]
                    ) {
                        EmptyView()
                    }
                    .enableAccountingForKeyboardHeight(false)
                    .ignoresSafeArea(.keyboard, edges: .all)
                }
        )
        host.view.backgroundColor = .clear
        return host
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    SearchBar()
}
