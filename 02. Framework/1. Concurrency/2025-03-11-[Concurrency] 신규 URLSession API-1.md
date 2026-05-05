---
title: "[Concurrency] 신규 URLSession API-1"
tags: 
- Concurrency
use_math: true
header: 
  teaser: 
---

## 1. 신규 URLSession API 사용

### 강한참조

- 클로저가 실행되는 동안 self가 강하게 참조되므로, ImageLoader 인스턴스가 반드시 살아 있어야 한다.

  ### 장점

  - 네트워크 요청 완료 후. 반드시 ImageLoader의 image 프로퍼티가 업데이트된다.
  - 옵셔널 바인딩 없이 self에 안전하게 접근 가능하다.

  ### 단점

  - 네트워크 요청이 오래 걸리거나 클로저와 ImageLoader 간에 순환 참조(retain cycle)가 발생하면 메모리 누수 위험이 있다.
  - 불필요하게 객체를 오래 메모리에 유지할 수 있다.

  ```swift
  class ImageLoader {
      var image: UIImage?
      
      func loadImage() {
          NetworkService.shared.fetchImage { image in
              // 클로저 내부에서 self를 강하게 캡처합니다.
              self.image = image
              print("이미지 로드 완료")
          }
      }
  }
  ```



### 약한 참조

- [weak self]로 인해, 네트워크 요청 진행 동안 ImageLoader 인스턴스가 다른 곳에서 해제되면, 내부의 self는 nil이 된다.

  ### 장점

  - 메모리 누수와 순환 참조를 예방할 수 있다.
  - 필요한 시점에만 self를 사용하여, 객체가 불필요하게 오래 유지되지 않는다.

  ### 단점

  - 요청 완료 시점에 ImageLoader가 이미 해제되었으면 self가 nil이 되어 업데이트가 발생하지 않는다.
  - self 접근시 옵셔널 처리를 해야하므로 코드가 약간 복잡해진다.
