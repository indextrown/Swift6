//
//  CustomViewTest.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/27/25.
//

import UIKit
import SnapKit
import Then

final class CustomViewTest: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .systemYellow
        
        
        
        /*
         
        let image = UIImage(systemName: "square.and.arrow.up")
        let padding = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
         
         
        let button = AlignedIconButton(title: "버튼",
                                       radius: 16,
                                       image: image,
                                       padding: padding)
        self.addSubview(button)
         
        
        button.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
         */
    }
}

#if DEBUG
import SwiftUI

struct CustomViewTest_Previews: PreviewProvider {
    static var previews: some View {
        CustomViewTest()
            .getPreview()
            .frame(width: 250, height: 250)
            .previewLayout(.sizeThatFits)
            .ignoresSafeArea()
    }
}
#endif
