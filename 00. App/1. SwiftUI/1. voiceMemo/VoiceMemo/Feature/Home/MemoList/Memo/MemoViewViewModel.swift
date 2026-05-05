//
//  MemoViewViewModel.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/2/25.
//

import Foundation

final class MemoViewModel: ObservableObject {
    @Published var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
    }
    
    
}
