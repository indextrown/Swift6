//
//  DetailViewController.swift
//  MusicApp
//
//  Created by 김동현 on 3/13/25.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MVC패턴을 위한 따로만든 뷰
    private let detailView = DetailView()

    var musicData: Music?
    
    var detailImage: UIImage?
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupUI()
    }
    
    private func setupUI() {
        // MARK: - 셀에서 전달받은 이미지를 detailView의 이미지뷰에 설정
        detailView.mainImageView.image = detailImage
        detailView.songNameLabel.text = musicData?.songName
        detailView.artistNameLabel.text = musicData?.artistName
        detailView.albumNameLabel.text = musicData?.albumName
        detailView.releaseDateLabl.text = musicData?.releaseDateString
    }
}
