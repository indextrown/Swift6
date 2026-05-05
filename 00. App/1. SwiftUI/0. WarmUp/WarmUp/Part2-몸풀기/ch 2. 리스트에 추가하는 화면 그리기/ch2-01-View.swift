//
//  ch2-02-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/7/24.
//

/*
 
 tip
 - command + i 하면 자동 정렬
 
 리스트
 - 같은 내용을 보여주는 방법 중 하나
 - 물론 VStack으로 할 수 있음
 - 많이 쓰는 기능이기에 제공
 
 리스트와 반복문
 - 리스트는 반복된다
 - 물론 손으로 반복할 수 있다
 - 이제는 반복문을 써야할 떄
 
 데이터 모델링
 - 데이터의 틀을 만들기
 - 반복이 되는 것들의 틀이 없으면 헷갈린다
 - 이름을 붙여주는 것
 - 있고 없고는 결과의 차이없음
 - 하지만 개발의 속도와 가독성의 차이(사람을 위한것)
 */

import SwiftUI

// 데이터 모델링(사람을 위한것)
struct Fruit: Hashable {
    let name: String
    let matchFruitName: String
    let price: Int
}



struct ch2_01_View: View {
    
    var favoriteFruits = [
        Fruit(name: "Apple", 
              matchFruitName: "lder berry",
              price: 1000),
        Fruit(name: "Banana",
              matchFruitName: "Double kiwi",
              price: 2000),
        Fruit(name: "Cherry",
              matchFruitName: "Apple",
              price: 3000),
        Fruit(name: "Double kiwi",
              matchFruitName: "Banana",
              price: 4000),
        Fruit(name: "Elder berry",
              matchFruitName: "Apple",
              price: 5000),
    ]
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(favoriteFruits, id: \.self) { fruit in
                    
                    VStack(alignment: .leading) {
                        Text("name: \(fruit.name)")
                        Text("MatchFruitName: \(fruit.matchFruitName)")
                        Text("price: \(fruit.price)")
                    }
                }
            }.navigationTitle("Fruit List")
        }
    }
}

#Preview {
    ch2_01_View()
}
