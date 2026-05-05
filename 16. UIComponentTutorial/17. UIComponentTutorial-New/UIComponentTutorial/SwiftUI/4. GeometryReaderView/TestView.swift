//
//  TestView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/3/25.
//

import SwiftUI

struct TestView: View {
    @State private var textFrame: CGRect = .zero
    @State private var rectFrame: CGRect = .zero

    var body: some View {
        VStack(spacing: 50) {
            // MARK: - 텍스트
            Text("Hello World")
                .font(.system(size: 24))
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                textFrame = geo.frame(in: .global)
                            }
                    }
                )
                // .padding(.top, -92.33)

            // MARK: - 사각형
            Rectangle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 200, height: 80)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                rectFrame = geo.frame(in: .global)
                            }
                    }
                )

            // MARK: - 결과 표시
            VStack(alignment: .leading, spacing: 10) {
                Text("🧩 위치 정보")
                    .font(.headline)
                Text("📍 Text midY: \(textFrame.midY, specifier: "%.2f")")
                Text("📍 Rectangle midY: \(rectFrame.midY, specifier: "%.2f")")
                Text("📏 거리 차이: \(abs(rectFrame.midY - textFrame.midY), specifier: "%.2f") pt")
            }
            .font(.system(size: 14))
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    TestView()
}
