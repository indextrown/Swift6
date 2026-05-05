//
//  ch2-03-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/7/24.
//
// MARK: - 리스트의 추가와 삭제

/*
 State, Binding
 
 State
 - 데이터의 상태를 나타내는 기능
 - struct이기에 필요한 기능
 - 엑셀작업을 한다음에 저장해서 다른 사람에게 보냄, 보낸 데이터는 이제 우리와 상관 없어짐
 - 화면이 새로 그려져야 할 때를 알려준다(ex) 키보드로 타이핑하면 화면이 새로 그려진다)
 - @State로 표시한다
 
 Binding
 - State에 $를 붙이면 Binding(묶는것)이다
 - State가 붙잡고 있는 상태를 연결 해줄 때
 - 두 State가 연결된다고 생각하자(쟤가 변하면 바인딩으로 연결된 다른애도 변해야해)
 - 외워서쓰기x, 필요한 곳에 사용
 
 리스트 추가, 삭제
 - 데이터를 바꾸는 것은 어렵지 않다
 - 상태를 잘 이해하기만 한다면!
 - 추가는 append
 - 삭제는 remove
 - 그리고 이미 구현되어 제공되는 기능들
 - 리스트는 그것을 위한 것 
 */
import SwiftUI

struct ch2_03_View: View {
    
    // 얘가 변화면 화면을 다시그려야해서 State
    @State var favoriteFruits = [
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
    
    
    @State var fruitName: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // MARK: - 추가기능                     // 바인딩
                    TextField("insert fruit name", text: $fruitName)
                    
                    Button {
                        favoriteFruits.append(Fruit(name: fruitName, matchFruitName: "Apple", price: 9000))
                    } label: {
                        Text("insert")
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                List {
                    ForEach(favoriteFruits, id: \.self) { fruit in
                        VStack(alignment: .leading) {
                            Text("name: \(fruit.name)")
                            Text("MatchFruitName: \(fruit.matchFruitName)")
                            Text("price: \(fruit.price)")
                        }
                    }
                    // MARK: - 삭제기능
                    .onDelete(perform: { indexSet in
                        favoriteFruits.remove(atOffsets: indexSet)
                        // favoriteFruits.remove(at: 0) // 항상 맨위 삭제 
                    })
                }.navigationTitle("Fruit List")
            }
        }
    }
}

#Preview {
    ch2_03_View()
}
