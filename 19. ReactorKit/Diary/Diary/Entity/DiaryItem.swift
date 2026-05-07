//
//  DiaryItem.swift
//  Diary
//
//  Created by 김동현 on 5/7/26.
//

import Foundation

struct DiaryItem: Equatable {
    let id: String
    let title: String
    let content: String
    let createdDate: Date
    let editedDate: Date
}
