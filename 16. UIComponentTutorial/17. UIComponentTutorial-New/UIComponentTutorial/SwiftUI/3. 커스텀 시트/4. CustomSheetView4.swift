////
////  CustomSheetView4.swift
////  UIComponentTutorial
////
////  Created by 김동현 on 11/20/25.
////
//
//import SwiftUI
//
//struct CustomSheetView4: View {
//    @State private var showSheet = false
//    
//    var body: some View {
//        VStack {
//            Button {
//                showSheet = true
//            } label: {
//                Text("모달 시트 열기")
//                    .font(.title3)
//                    .padding()
//                    .background(Color.blue.opacity(0.8))
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//        }
//        .sheet(isPresented: $showSheet) {
//            DetailView()
//                .presentationDetents([.medium])
//                .presentationDragIndicator(.visible)
//        }
//
//        
//    }
//}
//
//#Preview {
//    CustomSheetView4()
//}
//
//struct DetailView: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Hello, World!")
//                .font(.largeTitle)
//                .padding()
//            
//            Text("이 화면이 모달 시트입니다.")
//                .font(.headline)
//        }
//    }
//}

//
//  CustomSheetView4.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/20/25.
//

import SwiftUI

struct CustomSheetView4: View {
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Button {
                showSheet = true
            } label: {
                Text("모달 시트 열기")
                    .font(.title3)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .sheet(isPresented: $showSheet) {
            DetailView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    CustomSheetView4()
}


struct DetailView: View {
    @State private var showSecondSheet = false   // ✅ 두 번째 시트
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("첫 번째 시트")
                .font(.largeTitle)
                .padding()
            
            Button {
                showSecondSheet = true
            } label: {
                Text("두 번째 시트 열기")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showSecondSheet) {
            SecondDetailView()
                .presentationDetents([.medium])
                // .presentationDetents([.fraction(0.35)])    // 조금만 올라오는 작은 시트
                .presentationDragIndicator(.visible)
        }
    }
}


struct SecondDetailView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("두 번째 시트")
                .font(.title)
                .padding()
            
            Text("첫 번째 시트 위에 겹쳐서 올라온 화면입니다.")
        }
    }
}
