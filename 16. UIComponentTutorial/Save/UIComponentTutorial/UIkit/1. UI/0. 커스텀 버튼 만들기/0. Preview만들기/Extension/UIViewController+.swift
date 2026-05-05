//
//  UIViewController+.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/27/25.
//

import UIKit

#if DEBUG
import SwiftUI

extension UIViewController {
    private struct VCRepresentable: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
    
    func getPreview() -> some View {
        VCRepresentable(viewController: self)
    }
}
#endif


