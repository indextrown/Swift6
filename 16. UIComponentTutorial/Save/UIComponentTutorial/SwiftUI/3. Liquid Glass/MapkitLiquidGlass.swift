//
//  MapkitLiquidGlass.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/1/25.
//

import SwiftUI
import MapKit

struct MapkitLiquidGlass: View {
    @State private var showSheet = false
    var body: some View {
        ZStack {
            Map()
            
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
        .sheet(isPresented: $showSheet) {
            SheetCustomView()
                .clearModalBackground()
        }
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct SheetCustomView: View {
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
}

/// View Extension
extension View {
    func clearModalBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}

#Preview {
    MapkitLiquidGlass()
}
