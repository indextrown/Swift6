/*
 (138강)
 중첩타입(Nested Types)
 
 사용하는 이유
 - 특정 타입 내에서만 사용하기 위함
 - 타입 간의 연관성을 명확히 구분하고, 내부 구조 디테일하게 설계 가능

 */
import UIKit

class Aclass {
    struct Bstruct {
        enum Cenum {
            case aCase
            case bCase
            
            struct Dstruct {
                
            }
        }
        var name: Cenum
        
        // 멤버와이즈 이니셜라이저로 자동으로 생성됨
//        init(name: Cenum) {
//            self.name = name
//        }
    }
}

// 중첩타입 사용시 명시적으로 타입을 적어줘야함
let aClass: Aclass = Aclass()
let bStruct: Aclass.Bstruct = Aclass.Bstruct(name: .bCase)// 멤버와이즈 이니셜라이저
let cEnum: Aclass.Bstruct.Cenum = Aclass.Bstruct.Cenum.aCase
let dStruct: Aclass.Bstruct.Cenum.Dstruct = Aclass.Bstruct.Cenum.Dstruct()



struct BlackjackCard {

    // 중첩으로 선언 타입 ==============================================
    // Suit(세트) 열거형
    enum Suit: Character {     // 원시값(rawValue)사용
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }

    // 순서(숫자) 열거형
    enum Rank: Int {     // 원시값(rawValue)사용
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace   // (원시값 존재하지만 사용하지 않고자 함 ===> values)
        
        // Values 타입정의 (두개의 값을 사용) //===> 열거형 값(순서)을 이용 새로운 타입을 반환하기 위함
        struct Values {
            let first: Int, second: Int?
        }
        
        // (읽기) 계산 속성 (열거형 내부에 저장 속성은 선언 불가)
        var values: Values {
            // 실제로 get{}이 생략 되어있음
            switch self {   // enum타입 내부에 선언되있어서 self는 Rank타입중하나
            case Rank.ace:
                // Value타입을 다시 만들어서 리턴하고있음
                // ace때문에 Value타입을 다시 만들어서 리턴하는듯?
                return Values(first: 1, second: 11)    // 에이스 카드는 1 또는 11 로 쓰임
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)  // 10으로 쓰임
            default:
                return Values(first: self.rawValue, second: nil)    // 2 ~ 10까지의 카드는 원시값으로 쓰임
            }
        }
    }
    
    // 블랙잭 카드 속성 / 메서드  =======================================
    // 어떤 카드도, 순서(숫자)와 세트(Suit)를 가짐
    // 저장속성인데 타입이 열거형인 상황
    let rank: Rank, suit: Suit
    
    // (읽기) 계산속성
    var description: String {
        get {
            var output = "\(suit.rawValue) 세트,"
            output += " 숫자 \(rank.values.first)"
            
            if let second = rank.values.second {   // 두번째 값이 있다면 (ace만 있음)
                output += " 또는 \(second)"
            }
            
            return output
        }
    }
}

// A - 스페이드

let card1 = BlackjackCard(rank: .ace, suit: .spades) // fullname: BlackjackCard.Suit.spades
print("1번 카드: \(card1.description)")



// 5 - 다이아몬드

let card2 = BlackjackCard(rank: .five, suit: .diamonds)
print("2번 카드: \(card2.description)")

//let card2 = BlackjackCard(rank: <#T##BlackjackCard.Rank#>, suit: <#T##BlackjackCard.Suit#>)





