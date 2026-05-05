//
//  PreUIView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/27/25.
//

import SwiftUI
import UIKit


class PreUIView: UIView {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = .systemYellow
    }
}


#if DEBUG
import SwiftUI

struct PreUIViewTest_Previews: PreviewProvider {
    static var previews: some View {
        PreUIView()
            .getPreview()
            .frame(width: 200, height: 200)
            .background(Color.blue)
            .previewLayout(.sizeThatFits)
            .ignoresSafeArea()
    }
}
#endif
