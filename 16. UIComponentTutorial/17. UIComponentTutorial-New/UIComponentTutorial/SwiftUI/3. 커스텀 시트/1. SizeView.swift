//
//  SizeView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/4/25.
//

import SwiftUI
import BottomSheet

struct SizeView: View {
    @State private var rectFrame: CGRect = .zero
    @State private var textFrame: CGRect = .zero
    @State private var bottomSheetPosition: BottomSheetPosition = .relative(0.45)
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                Rectangle()
                    .frame(width: 200, height: 50)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    rectFrame = geo.frame(in: .global) // 전역 좌표
                                }
                                .onChange(of: geo.frame(in: .global)) { _, newValue in
                                    rectFrame = newValue
                                }
                        }
                    )
                
                Text("Hello World")
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    textFrame = geo.frame(in: .global) // 전역 좌표
                                }
                                .onChange(of: geo.frame(in: .global)) { _, newValue in
                                    textFrame = newValue
                                }
                        }
                    )
                
                Spacer()
                
                // 좌표 정보 표시
                /*
                VStack(spacing: 0) {
                    Text("📏 Rectangle")
                    Text("top(minY): \(Int(rectFrame.minY))")
                    Text("bottom(maxY): \(Int(rectFrame.maxY))")
                    Text("height: \(Int(rectFrame.height))")
                    
                    Divider().padding(.vertical, 10)
                    
                    Text("📏 Text")
                    Text("top(minY): \(Int(textFrame.minY))")
                    Text("bottom(maxY): \(Int(textFrame.maxY))")
                    Text("height: \(Int(textFrame.height))")
                }
                 */
            }
        }
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                     switchablePositions: [
                                            // .absolute(0),
                                           .relative(0.45),
                                           .absolute(UIScreen.main.bounds.height - (textFrame.maxY + 10))
                                          ],
                     
        ) {
            SampleSheetView()
        }
        .showDragIndicator(false)
        .customBackground(.clear)
        .enableAppleScrollBehavior(true)
    }
}

#Preview {
    SizeView()
}

private struct SampleSheetView: View {
    var body: some View {
        VStack(spacing: 0) {
            // 상단 버튼 부분 (투명)
            HStack {
                Button {
                } label: {
                    Image(systemName: "binoculars.fill")
                }

                Spacer()

                Button {
                } label: {
                    Image(systemName: "sun.dust.fill")
                }
            }
            .padding(.horizontal)
            .frame(height: 60)
            .background(Color.clear) // ✅ 완전 투명

            // 아래쪽 (배경색 있는 부분)
            ZStack {
                Color.gray.opacity(0.6) // ✅ 배경 전체 채우기

                VStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.gray)
                        .frame(width: 50, height: 5)
                        .padding(.top, 10)

                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(0..<30) { i in
                                Text("Item \(i)")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                    // ✅ 시트 제스처와 동시에 허용
                    .simultaneousGesture(DragGesture())

                    Spacer(minLength: 0)
                }
            }
            .cornerRadius(20)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
