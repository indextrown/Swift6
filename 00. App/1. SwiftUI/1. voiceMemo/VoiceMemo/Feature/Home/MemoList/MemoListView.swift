//
//  MemoListView.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/2/25.
//

import SwiftUI

struct MemoListView: View {
    @EnvironmentObject private var pathViewModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if !memoListViewModel.memos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction: {
                            memoListViewModel.navigationRightBtnTapped()
                        },
                        rightBtnType:
                            memoListViewModel.navigationBarRigntBtnMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                // 타이틀 뷰
                TitleView()
                    .padding(.top, 20)
                    
                
                // 안내 뷰 혹은 메모리스트 컨텐츠 뷰
                if memoListViewModel.memos.isEmpty {
                    AnnouncementView()
                } else {
                    MemoListContentView()
                        .padding(.top, 20)
                }
            }
            // 메모작성 플로팅 아이콘 버튼 뷰
            WriteMemoBtnView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "메모 \(memoListViewModel.removeMemosCount)개 삭제하사겠습니까?",
            isPresented: $memoListViewModel.isDisplayRemoveMemoAlert
        ) {
            Button("삭제", role: .destructive) {
                memoListViewModel.removeBtnTapped()
            }
            
            Button("취소", role: .cancel) {}
        }
        // todos 추가되거나 삭제될때마다 반응
        .onChange(of: memoListViewModel.memos) { oldValue, newMemos in
            homeViewModel.setMemosCount(newMemos.count)
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if memoListViewModel.memos.isEmpty {
                Text("메모를\n추가해 보세요.")
            } else {
                Text("메모 \(memoListViewModel.memos.count)개가\n있습니다.")
            }
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template) // 색상을 텍스트와 함께 변화시키기 위함
            Text("\"퇴큰 9시간전 메모\"")
            Text("\"개발 끝낸 후 퇴근하기\"")
            Text("\"밀린 알고리즘 공부하기\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: - 메모 리스트 컨텐츠 뷰
private struct MemoListContentView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                Spacer()
            }
            
            ScrollView(.vertical) {
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
                
                ForEach(memoListViewModel.memos, id: \.self) { memo in
                    // 메모 셀 뷰 호출
                    MemoCellView(memo: memo)
                }
            }
        }
    }
}

// MARK: - Memo 셀 뷰
// 뷰어 타입에서는 뷰어를(메모뷰) 올려야 해서 클릭하면 실제로 보여줘야함
private struct MemoCellView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoveSelected: Bool
    private var memo: Memo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        memo: Memo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected) // 초기값
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button {
            // TODO: - path 관련 메모 구현 후 구현 필요
            pathModel.paths.append(.memoView(isCreatedMode: false, memo: memo))
        } label: {
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(memo.title)
                            .lineLimit(1)   // 한줄 표현
                            .font(.system(size: 16))
                            .foregroundColor(.customBlack)
                        
                        Text(memo.convertedDate)
                            .font(.system(size: 12))
                            .foregroundColor(.customIconGray)
                    }
                    
                    Spacer()
                    
                    // 현재 편집 모드라면
                    if memoListViewModel.isEditMemoMode {
                        Button {
                            isRemoveSelected.toggle()
                            memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                        } label: {
                            isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
            }
        }
    }
}

// MARK: - 메모 작성 버튼 뷰
private struct WriteMemoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    // TODO: - 메모 뷰 구현 후 돌아와서 구현 필요(메모 생성)
                    pathModel.paths.append(.memoView(isCreatedMode: true, memo: nil))
                } label: {
                    Image("writeBtn")
                }
            }
        }
    }
}

#Preview {
    MemoListView()
        .environmentObject(PathModel())
        .environmentObject(MemoListViewModel())
}
