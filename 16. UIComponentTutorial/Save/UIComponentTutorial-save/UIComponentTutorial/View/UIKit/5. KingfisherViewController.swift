//
//  5. KingfisherViewCOntroller.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/28/25.
//

import UIKit
import Kingfisher

final class KingfisherViewController: UIViewController {
    
    private lazy var myImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        constraints()
        loadImage()
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        view.addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            myImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            myImageView.widthAnchor.constraint(equalToConstant: 300),
            myImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func loadImage() {
        guard let url = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQv8sv01DK7BoJGaJMZ972ig5mQ_JBbqxdINQ&s") else { return }
                
        myImageView.kf.setImage(with: url)
    }
}

#Preview {
    KingfisherViewController()
}

