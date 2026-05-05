//
//  Memo.swift
//  TcaSample
//
//  Created by 김동현 on 12/13/25.
//

import Foundation

// MARK: - MemoElement
struct Memo: Decodable, Equatable, Identifiable {
    let id: String
    let createAt: String
    let title: String
    let viewCount: String
}
typealias MemoList = [Memo]
