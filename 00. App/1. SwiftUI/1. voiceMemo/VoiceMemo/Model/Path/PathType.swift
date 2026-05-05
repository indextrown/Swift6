//
//  PathType.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/24/24.
//

// MARK: - Stack이 쌓일 수 있는 경로 생성
enum PathType: Hashable {
    case homeView
    case todoView
    case memoView(isCreatedMode: Bool, memo: Memo?) // 생성모드
}
