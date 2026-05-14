//
//  ContentLayoutMode.swift
//  ListKit
//
//  Created by 김동현 on 5/13/26.
//

import Foundation

public enum ContentLayoutMode: Equatable {
    case fitContainer
    case flexibleHeight(estimatedHeight: CGFloat)
    case flexibleWidth(estimatedWidth: CGFloat)
    case fitCotent(estimatedSize: CGSize)
}
