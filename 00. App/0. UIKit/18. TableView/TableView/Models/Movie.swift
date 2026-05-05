//
//  Movie.swift
//  TableView
//
//  Created by 김동현 on 2/28/25.
//

import UIKit

struct Movie {
    // 이미지 파일이 없으면 에러가 날수있어서 var + optional
    var movieImage: UIImage?
    let movieName: String
    let movieDescription: String
}
