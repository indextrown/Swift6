//
//  MemoClient.swift
//  TcaSample
//
//  Created by 김동현 on 12/13/25.
//

import Foundation
import ComposableArchitecture

// MARK: -
/// effect를 반환하는 클롣저들을 보유
/// effect는 외부에서 일어난 일을 가져와서 내부 상태를 변경시킨다
struct MemoClient {
    /// 단일 아이템 조회
    var fetchMemoItem: (_ id: String) -> Effect<MemoFeature.Action>
    
    /// 전체 아이템 조회
    var fetchMemoList: () -> Effect<MemoFeature.Action>
}

extension MemoClient {
    static let live = Self(
        fetchMemoItem: { id in
            .run { send in
                do {
                    let url = URL(string: "https://dev.poppang.co.kr/api/v1/test/memos/\(id)")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let memo = try JSONDecoder().decode(Memo.self, from: data)
                    await send(.fetchMemoItemResponse(.success(memo)))
                } catch {
                    await send(.fetchMemoItemResponse(.failure(.network)))
                }
            }
        },
        fetchMemoList: {
            .run { send in
                do {
                    let url = URL(string: "https://dev.poppang.co.kr/api/v1/test/memos")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let memos = try JSONDecoder().decode([Memo].self, from: data)
                    await send(.fetchMemoListResponse(.success(memos)))
                } catch {
                    await send(.fetchMemoListResponse(.failure(.network)))
                }
            }
        }
    )
}
