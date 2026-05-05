//
//  UISearchBarWrapper.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/25/25.
//

import UIKit
import SwiftUI

// UISearchbar를 감싸는 SwiftUI view 만들기
struct UISearchBarWrapper: UIViewRepresentable {
    // swiftUI View는 @State나 @Binding이 값이 변경되면 업데이트가 이루어져야하기 때문에 updateUIView 필요
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some UIView {
        return UISearchBar()
    }
}
