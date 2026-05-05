//
//  ViewController.swift
//  RxFlowTutorialTest
//
//  Created by Jeff Jeong on 2023/07/15.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var _title : String = ""
    
    var injectedNumber : Int? = nil
    
    convenience init(title: String = "타이틀 없음", injectedNumber: Int? = nil) {
        self.init(nibName: nil, bundle: nil)
        self._title = title
        self.injectedNumber = injectedNumber
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self._title = ""
        self.injectedNumber = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    let injectedNumberLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy var someStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, injectedNumberLabel])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .fill
        return stackView
    }()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        someStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

#if DEBUG
import SwiftUI

struct ViewControllerRepresentable : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}

#endif
