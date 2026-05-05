//
//  LiquidGlass.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/1/25.
//
// https://www.youtube.com/watch?v=2gTMCNRcAz0
// https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views
// https://www.youtube.com/watch?v=pr-DoV46Zl8
// https://huniroom.tistory.com/entry/SwiftUI-sheet-배경-투명하게-만들기-ios164-대응
// https://www.reddit.com/r/SwiftUI/comments/1gmshxx/how_to_change_the_backdrop_color_of_all_sheets_in/

import SwiftUI

struct LiquidGlass: View {
    
    @State private var showSheet = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.25) // 여기서 투명도 조절
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .frame(width: 200, height: 200)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        showSheet.toggle()
                    } label: {
                        Circle()
                            .fill(.blue)
                            .frame(width: 50, height: 50)
                            .shadow(radius: 4)
                            
                    }
                    .padding(.trailing, 40)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true) // ← 뒤로가기 버튼 숨기기
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        // 시트 내용
        .sheet(isPresented: $showSheet) {
            SheetContentView()
                .clearModalBackground() 
        }
    }
}

struct SheetContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, this is a transparent sheet!")
                .font(.title)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.black.opacity(0.2)) // 살짝 어두운 레이어
                .blur(radius: 10)                // 흐림 정도
                .ignoresSafeArea()
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 2)
                .ignoresSafeArea()
        )
    }
}

struct SheetContentView3: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, this is a Custom sheet!")
                .font(.title)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
        .frame(maxWidth: .infinity)
        .background(
            // 시트 배경
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3)) // 원하는 배경 투명도
                .ignoresSafeArea()
        )
    }
}

struct SheetContentView2: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, this is a transparent sheet!")
                .font(.title)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
        .frame(maxWidth: .infinity)
        .background(
            // 시트 배경
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3)) // 원하는 배경 투명도
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purple.opacity(0.8), lineWidth: 2) // 테두리 색상과 두께
                )
                .ignoresSafeArea()
        )
    }
}

#Preview {
    LiquidGlass()
}

/*
import SwiftUI

/// iOS 16.3 이하에서 sheet 배경을 투명하게 만드는 뷰
struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            // 부모뷰(superview) 접근해서 배경 투명하게
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

/// sheet에 편하게 쓰기 위한 Modifier
struct ClearBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationBackground(.clear)
        } else {
            content
                .background(ClearBackgroundView())
        }
    }


/// View Extension
extension View {
    func clearModalBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}
 

  */



struct SheetContentViewSave: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, this is a sheet!")
                .font(.title)
                .foregroundColor(.white)

            Text("리퀴드 글래스 효과 적용된 시트")
                .foregroundColor(.white.opacity(0.8))

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial) // 여기에 적용
        .ignoresSafeArea()
        .presentationDetents([.medium, .large])
    }
}




//RoundedRectangle(cornerRadius: 20)
//    .fill(Color.white.opacity(0.1)) // Shape에 색을 입힘
//    .background(.ultraThinMaterial) // 뒤에 blur 효과
//    .frame(width: 200, height: 200)
//    .cornerRadius(20)


//RoundedRectangle(cornerRadius: 20)
//    .fill(Color.white.opacity(0.2)) // 밝기 추가
//    .frame(width: 200, height: 200)
//    .background(.ultraThinMaterial) // 유리 효과
//    .cornerRadius(20)
//    .overlay(
//        RoundedRectangle(cornerRadius: 20)
//            .stroke(Color.white.opacity(0.2), lineWidth: 1)
//    )
