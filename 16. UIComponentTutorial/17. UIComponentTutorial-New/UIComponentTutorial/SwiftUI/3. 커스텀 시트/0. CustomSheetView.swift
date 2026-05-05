//
//  CustomSheetView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 10/30/25.
//

import SwiftUI
import BottomSheet

struct CustomSheetView: View {
    @State private var bottomSheetPosition: BottomSheetPosition = .relative(0.6)
    @State private var secondSheetPosition: BottomSheetPosition = .hidden
    
    var body: some View {
        VStack {
            Text("CustomSheetView")
        }
        // 첫 시트
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                     switchablePositions: [
                        .absolute(120),
                        .relative(0.6),
                        .relativeTop(1.0)
                     ]) {
                         // view
                         FirstSheetView {
                             
                             // 버튼 누르면 두번째 시트 띄우기
                              secondSheetPosition = bottomSheetPosition
                         }
                     }
        
         // 시트 애니메이션 속도
         .customAnimation(.easeInOut(duration: 0.25))
        
        
        // 두 번째 시트
        .bottomSheet(bottomSheetPosition: $secondSheetPosition,
                  switchablePositions: [
                    .absolute(120),
                    .relative(0.6),
                    .relativeTop(1.0)
                  ]) {
                      // view
                      SecondSheetView {
                          // 닫을 때 숨기겠다
                          secondSheetPosition = .hidden
                      }
                  }
        // 시트 애니메이션 속도
        .customAnimation(.easeInOut(duration: 0.25))
        
        // 두 번째 시트 높이 변경 -> 첫 시트 동기화
        .onChange(of: secondSheetPosition) { _, newValue in
            if newValue != .hidden {
                bottomSheetPosition = newValue
            }
        }
    }
}

private struct FirstSheetView: View {
    let onButtonTap: () -> Void
    var body: some View {
        VStack {
            Button {
                onButtonTap()
            } label: {
                Text("두 번째 시트 열기")
                    .frame(width: 80, height: 50)
                    .foregroundStyle(.black)
                    .background(.gray)
                    .cornerRadius(10)
            }
        }
    }
}

private struct SecondSheetView: View {
    let onDIsmiss: () -> Void
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    onDIsmiss()
                } label: {
                     Text("닫기")
                }
                .frame(width: 100, height: 44)
                .background(.gray.opacity(0.2))
                .cornerRadius(5)
            }
            Spacer()
        }
    }
}

#Preview {
    CustomSheetView()
}
