//
//  MemoListViewModel.swift
//  voiceMemo
//

import Foundation

class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo]    // 메모들에 대한 프로퍼티
    @Published var isEditMemoMode: Bool
    @Published var removeMemos: [Memo]
    @Published var isDisplayRemoveMemoAlert: Bool
    
    // 삭제될 메모카운트 개수
    var removeMemoCount: Int {
        return removeMemos.count
    }
    
    // 네비게이션바의 오른쪽버튼모드(생성, 완료, 편집 분기)
    var navigationRigntBtnMode: NavigationBtnType {
        isEditMemoMode ? .complete : .edit
    }
    
    init(memos: [Memo] = [],
         isEditMemoMode: Bool = false,
         removeMemos: [Memo] = [],
         isDisplayRemoveMemoAlert: Bool = false) {
        self.memos = memos
        self.isEditMemoMode = isEditMemoMode
        self.removeMemos = removeMemos
        self.isDisplayRemoveMemoAlert = isDisplayRemoveMemoAlert
    }
}

extension MemoListViewModel {
    // 메모 추가
    func addMemo(_ memo: Memo) {
        memos.append(memo)
    }
    
    // 메모 수정
    func updateMemo(_ memo: Memo) {
        // firstIndex()를 사용하여 memos 배열에서 업데이트하려는 메모와 동일한 id를 가진 메모의 인덱스를 찾는다.
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos[index] = memo
        }
    }
    
    // 메모 삭제
    func removeMemo(_ memo: Memo) {
        // remove(at:)을 사용하여 해당 인덱스의 요소를 제거한다
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos.remove(at: index)
        }
    }
    
    // 네비게이션바 우측 버튼
    func navigationRightBtnTapped() {
        // 수정모드라면
        if isEditMemoMode {
            // 비어있다면
            if removeMemos.isEmpty {
                isEditMemoMode = false
            } else {
                // 비어있지 않다면
                // 지우기 위해 삭제 얼럿 상태값 변경을 위한 메서드 호출
                setIsDisplayRemoveMemoAlert(true)
            }
        } else {
            // 편집 모드가 아니라면
            isEditMemoMode = true
        }
    }
    
    // 삭제 알림 표시 여부 설정
    func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool) {
        isDisplayRemoveMemoAlert = isDisplay
    }
    
    // 메모 삭제 모드에서 선택된 메모를 관리한다
    // 삭제 대상 메모가 선택되면 제거, 선택안됬으면 removeMemos배열에 추가
    func memoRemoveSelectedBoxTapped(_ memo: Memo) {
        if let index = removeMemos.firstIndex(of: memo) {
            removeMemos.remove(at: index)   // 이미 선택된 메모는 제거
        } else {
            removeMemos.append(memo)        // 세 메모는 추가
        }
    }
    
    // 선택된 메모를 memos 배열에서 제거하고, 삭제모드 종료
    func removeBtnTapped() {
        memos.removeAll { memo in
            removeMemos.contains(memo)
        }
        removeMemos.removeAll()
        isEditMemoMode = false
    }
}

// 13: 15
