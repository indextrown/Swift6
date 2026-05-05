/*
 
 (111강)
 
 생성자
 - 기본적인원칙: 상속이 되지 않고 재정의 하는게 원칙
 - 지정생성자만 재정의 가능하다-> 필숵으로 재정의를 고려해야한다
 - 지정생성자도 자동상속의경우??
 - 편의생성자는 일단 무조건 재정의가 불가능하다 하지만 예외상황이 있는데 자동상속이 되는 경우??
 
 지정생성자는 예외적인 사항에서 자동상속이된다
 - 새롭게 정의한 하위클래스에서 저장 속성이 아예 없는 경우나 저장속성에 기본값을 설정한경우나
 -> (실패 가능성이 없어짐)  그래서 자동상속됨
 -> 대신 하위에서 어떤 재정의도 하지 않는 전제하에
 
 편의생성자
 - 무조건 상속을 하지 않는게 원칙
 -!!! 예외적으로 자동 상속하는경우 존재!!!
 !!!상위 지정생성자를 모두 상속하는 경우!!! 하위 편의생성자도 자동으로 상속된다
 - 1) 지정 생상자 자동으로 상속하는 경우
 - 2) 상위 지정생성자 모두 재정의 구현 (실패 가능성 배제)
 */


class Food {
    var name :String
    
    // 지정생성자 정의
    init(name: String) {
        self.name = name
    }
    
    // 편의생성자 정의 -> 지정생성자 호출
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

let namedMeat = Food(name: "Bacon")
namedMeat.name
let mysteryMeat = Food()
mysteryMeat.name



// 상위 지정생성자
// init(name: String)

// 상위 편의생성자
// convenience init()
// 이 두가지 고려해야함


class RecipeIngredient: Food {
    // 기본값 설정 안한 상태
    var quantity: Int
    
    // 지정생성자
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    
    
    // 편의생성자로 재정의
    // 잘생각해보면 상위에 있는 지정생성자를 모두 재정의를 한경우다 -> 예외사항
    // 어떤 예외사항? 상위에 있는 편의생성자도 자동으로 상속된다
    // 상위의 지정생성자를 하위에서 지정생성자로 상속하든 편의생성자로 상속하든 상관없으나 상위생성자를 모두 재정의하면 무조건 편의생성자도 자동으로 상속을 하게 된다
    // 이유: 편의생성자는 결국 지정생성자를 호출함
    // 어차피 상위의 지정생성자를 편의생성자로 재정의 하더라도 편의생성자는 결국 지정생성자를 호출함
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
    
    // 자동상속 convenience init() {} // 자동상속(예외규칙)
}
 

// 상위의 지정생성자
// init(name: String, quantity: Int)

// 상위의 편의생성자
// override convenience init(name: String)

// 상위의 편의생성자
// convenience init() {}

// 상위의 지정생성자를 재정의 하지 않아도 자동으로 상속을 하고 상위의 지정생성자를 모두 자동 상속을 하는 경우 편의 생성자도 자동으로 상속하게됨
class ShoppingListItem: RecipeIngredient {
    // 기본값이 있어서 에러가 날 확률이 없다
    // 굳이 지정생성자를 정의할 필요 x
    var purchased = false
}
