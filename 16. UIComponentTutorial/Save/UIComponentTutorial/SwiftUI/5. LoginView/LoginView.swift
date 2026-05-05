//
//  LoginView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 8/3/25.
//
// https://www.youtube.com/watch?v=hkdku2_9hN8

import SwiftUI

// MARK: - Intro Model
struct Intro: Identifiable {
    let id: UUID = UUID()
    var text: String
    var textColor: Color
    var circleColor: Color
    var bgColor: Color
    var circleOffset: CGFloat = 0
    var textOffset: CGFloat = 0
}

// MARK: - Sample Intros
var sampleIntros: [Intro] = [
    .init(text: "잠시 멈춰도 괜찮아요.", textColor: .black, circleColor: .black, bgColor: .white),
    .init(text: "당신의 하루에", textColor: .black, circleColor: .black, bgColor: .white),
    .init(text: "작은 쉼표가 되어줄게요.", textColor: .black, circleColor: .black, bgColor: .white),
    .init(text: "지금, 함께 시작해요.", textColor: .black, circleColor: .black, bgColor: .white)
]

// MARK: - View
struct LoginView: View {
    
    @State private var intros: [Intro] = sampleIntros
    @State private var activeIntro: Intro?
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeAreaInsets = $0.safeAreaInsets
            
            VStack(spacing: 0) {
                if let activeIntro {
                    Rectangle()
                        .fill(activeIntro.bgColor)
                        .padding(.bottom, -30)
                        /// Circle and Text
                        .overlay {
                            Image("Comma")
                                .resizable()
                                .scaledToFit()
                            
//                            Circle()
//                                .fill(activeIntro.circleColor)
                                .frame(width: 45, height: 45)
                                .background(alignment: .leading, content: {
                                    Capsule()
                                        .fill(activeIntro.bgColor)
                                        .frame(width: size.width)
                                })
                                .background(alignment: .leading) {
                                    Text(activeIntro.text)
                                        .font(.largeTitle)
                                        .foregroundStyle(activeIntro.textColor)
                                        .frame(width: textSize(text: activeIntro.text))
                                        .offset(x: 10)
                                        /// Moving Text based on text Offset
                                        .offset(x: activeIntro.textOffset)
                                }
                                /// Moving Circle in the Opposite Direction
                                .offset(x: -activeIntro.circleOffset)
                            }
                    /// Login Buttons
                    logunButtons()
                        .padding(.bottom, safeAreaInsets.bottom)
                        .padding(.top, 10)
                        .background(.black, in: .rect(topLeadingRadius: 25, topTrailingRadius: 25))
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 8)
                }
            }
            .ignoresSafeArea()
        }
        .task {
            if activeIntro == nil {
                activeIntro = sampleIntros.first
                /// Delaying 0.15s and Starting Animation
                let oneSecond = UInt64(1_000_000_000 * 0.5)
                try? await Task.sleep(nanoseconds: oneSecond * UInt64(0.15))
                animate(0)
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true) // ← 뒤로가기 버튼 숨기기
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    /// Login Buttons
    @ViewBuilder
    func logunButtons() -> some View {
        VStack(spacing: 12) {
            Button {
                
            } label: {
                Label("애플로 계속하기", image: "Logo Apple")
                    .foregroundStyle(.black)
                    .fillButton(.white)
            }
            
            Button {
                
            } label: {
                HStack {
                    Image("Logo Google")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20) // 원하는 크기로 조절
                    Text("구글로 계속하기")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .fillButton(.gray5)
            }

            
//            Button {
//                
//            } label: {
//                Label("카카오로 계속하기", image: "Logo Kakao")
//                    .foregroundStyle(.white)
//                    .fillButton(.gray5)
//            }
            
            Button {
                
            } label: {
                HStack {
                    /*
                    Image("Logo Google")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20) // 원하는 크기로 조절
                     */
                    Text("Login")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .fillButton(.black)
                .shadow(color: .white, radius: 1)
            }

            Spacer()
                .frame(height: 3)
            
            VStack(spacing: 4) {
                Text("본 서비스 로그인 및 이용 시,")
                (
                    Text("이용약관")
                        .underline()
                        .foregroundStyle(.white)
                    +
                    Text(" 및 ")
                        .foregroundStyle(.white)
                    +
                    Text("개인정보처리방침")
                        .underline()
                        .foregroundStyle(.white)
                    +
                    Text("에 동의하신 것으로 간주됩니다.")
                        .foregroundStyle(.white)
                )
            }
            .multilineTextAlignment(.center)
            .font(.footnote)
            .frame(maxWidth: .infinity)
        }
        .padding(15)
    }
    
    func animate(_ index: Int, _ loop: Bool = true) {
        // ✅ index가 유효한 범위일 때 실행
        guard index < intros.count else {
            if loop {
                animate(0, loop)
            }
            return
        }

        // ✅ 현재 Intro 설정
        activeIntro = intros[index]

        withAnimation(.snappy(duration: 1), completionCriteria: .removed) {
            activeIntro?.textOffset = -(textSize(text: intros[index].text) + 20)
            activeIntro?.circleOffset = -(textSize(text: intros[index].text) + 20) / 2
        } completion: {
            withAnimation(.snappy(duration: 0.8), completionCriteria: .logicallyComplete) {
                activeIntro?.textOffset = 0
                activeIntro?.circleOffset = 0
                activeIntro?.circleColor = intros[index].circleColor
                activeIntro?.bgColor = intros[index].bgColor
            } completion: {
                animate(index + 1, loop)
            }
        }
    }

    
    func animate2(_ index: Int, _ loop: Bool = true) {
        if intros.indices.contains(index + 1) {
            /// updating text and text color
            activeIntro?.text = intros[index].text
            activeIntro?.textColor = intros[index].textColor
            
            /// Animating Offsets
            withAnimation(.snappy(duration: 1), completionCriteria: .removed) {
                activeIntro?.textOffset = -(textSize(text: intros[index].text) + 20)
                activeIntro?.circleOffset = -(textSize(text: intros[index].text) + 20) / 2
            } completion: {
                withAnimation(.snappy(duration: 0.8), completionCriteria: .logicallyComplete) {
                    activeIntro?.textOffset = 0
                    activeIntro?.circleOffset = 0
                    activeIntro?.circleColor = intros[index + 1].circleColor
                    activeIntro?.bgColor = intros[index + 1].bgColor
                } completion: {
                    /// Going to Next Slide
                    /// Simply Recursion
                    animate(index + 1, loop)
                }
            }
        } else {
            /// looping
            /// If looping Applied, Then Reset the Index to 0
            if loop {
                animate(0, loop)
            }
        }
    }
    
    /// Fetching Text Size based on Fonts
    func textSize(text: String) -> CGFloat {
        return NSString(string: text).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]).width
    }
}

#Preview {
    LoginView()
}


extension View {
    @ViewBuilder
    func fillButton(_ color: Color) -> some View {
        self
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(color, in: .rect(cornerRadius: 15))
    }
}
