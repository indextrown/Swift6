//
//  Constants.swift
//  MusicApp
//
//  Created by 김동현 on 3/12/25.
//

import UIKit

// MARK: - Name Space
// data 영역에 저장(열거형, 구조체 가능, 전역 변수로 선언 가능)
public enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}

// cell 문자열 묶음
public struct Cell {
    // 타입 저장속성(데이터 영역에 생김)
    static let musicCellIdentifier = "MusicCell"
    static let musicCollectionViewCellIdentifier = "MusicCellectionViewCell"
    // 생성을 못하도록 방지(인스턴스를 생성하지않고 타입 저장속성을 사용해라는 의도) 
    private init() {}
}

// 컬렉션뷰 구성을 위한 설정
public struct CVCell {
    static let spacingWidth: CGFloat = 1
    static let cellColumns: CGFloat = 3
    private init() {}
}
