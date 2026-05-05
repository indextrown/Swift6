//
//  MemoListViewModel.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/2/25.
//

import Foundation

final class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo]
    @Published var isEditMemoMode: Bool
    @Published var removeMemos: [Memo]
    @Published var isDisplayRemoveMemoAlert: Bool
    
    // 삭제할 Memo 개수
    var removeMemosCount: Int {
        return removeMemos.count
    }
    
    // 커스텀 네비게이션바 오른쪽 버튼 현재모드
    var navigationBarRigntBtnMode: NavigationBtnType {
        isEditMemoMode ? .complete : .edit
    }
    
    init(
        memos: [Memo] = [],
        isEditMemoMode: Bool = false,
        removeMemos: [Memo] = [],
        isDisplayRemoveMemoAlert: Bool = false
    ) {
        self.memos = memos
        self.isEditMemoMode = isEditMemoMode
        self.removeMemos = removeMemos
        self.isDisplayRemoveMemoAlert = isDisplayRemoveMemoAlert
    }
}

// MARK: - 실제 로직
extension MemoListViewModel {
    
    func addMemo(_ memo: Memo) {
        memos.append(memo)
    }
    
    // 메모 수정
    func updateMemo(_ memo: Memo) {
        // 들어온 메모와 일치하는 인덱스를 찾아서 인덱스를 갈아 끼워 준다
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos [index] = memo
        }
    }
    
    // 메모 삭제
    func removeMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos.remove(at: index)
        }
    }
    
    // 네비게이션 바 오른쪽 버튼 누를 때 동작
    func navigationRightBtnTapped() {
        // 편집모드라면
        if isEditMemoMode {
            // 지울 메모가 비어있다면
            if removeMemos.isEmpty {
                isEditMemoMode = false
            } else {
                // 삭제 알람 상태값 변경을 위한 메서드 호출
                setIsDisplayRemoveMemoAlert(true)
            }
        } else {
            // 편집모드가 아니라면 버튼을 누르면 편집모드가 되야한다
            isEditMemoMode = true
        }
    }
    
    // 알람 설정 상태값 변경 로직
    func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool) {
        isDisplayRemoveMemoAlert = isDisplay
    }
    
    // 삭제하기 위해 메모 셀렉트 박스 눌렀을 때 동작
    func memoRemoveSelectedBoxTapped(_ memo: Memo) {
        // 이미 삭제할 메모라면 삭제취소
        if let index = removeMemos.firstIndex(of: memo) {
            removeMemos.remove(at: index)
        } else {
            // 삭제하기 위해 배열에 추가
            removeMemos.append(memo)
        }
    }
    
    // 삭제버튼 눌렀을 때
    func removeBtnTapped() {
        memos.removeAll { memo in
            removeMemos.contains(memo)
        }
        removeMemos.removeAll()
        isEditMemoMode = false
    }
    
}
