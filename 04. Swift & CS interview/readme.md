# Swift 면접 질문

## 1. Extension은 어떻게 사용되나요?

- Extension은 클래스, 구조체, 열거형 타입애 새로운 `메서드, 프로퍼티, 생성자`를 추가적으로 정의하여 사용하기 위해 사용됩니다.

- 저장 프로퍼티(저장 속성)는 extension에 정의할 수 없고, `연산 프로퍼티` 만 정의할 수 있습니다.

- 구조체인 경우 기존 구조체에 생성자를 직접 구현하면 `memberwise initializer`(기본 생성자)가 사라지지만 구조체의 Extension에 생성자를 정의하면 `memberwise initializer`가 사라지지 않습니다.

- `where`을 사용하면 특정한 조건을 가진 타입에 대해서만 Extension을 적용할 수 있습니다.

  ```swift
   // Idable 프로토콜을 채택하는 타입의 배열만 이 Extension을 사용가능
    extension Array where Element : Idable {
        func filterWithId(id : String) -> [Element] {
            return self.filter { (item) -> Bool in
                return item.id == id
            }
        }
    }
  ```

</br>

## 2. Swift의 upcasting과 downcasting의 차이에 대해서 설명해보세요.

- 서로 상속 관계에 있는 클래스에서 자식 클래스를 부모 클래스로 타입캐스팅 하는 것을 `업캐스팅`이라고 하고 `as`를 사용해서 업캐스팅을 할 수 있습니다.

- 컴파일 타임에 업캐스팅이 가능한지 여부가 판별되기 때문에 컴파일이 되면 항상 성공합니다.

  ```swift
  class Student {
      let name: String
  
      init(name: String) {
          self.name = name
      }
  }
  
  class HighSchoolStudent: Student {
      let gpa: Double
  
      init(name: String, gpa: Double) {
          self.gpa = gpa
          super.init(name: name)
      }
  }
  
  let hun = HighSchoolStudent(name: "hun", gpa: 4.5)
  let updacasted = hun as Student
  
  print(hun.name, hun.gpa)
  print(updacasted.name, updacasted.gpa) // compile error
  ```

  
