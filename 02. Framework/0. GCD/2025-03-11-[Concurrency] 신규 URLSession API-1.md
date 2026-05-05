---
title: "[GCD] 네트워크 통신"
tags: 
- Concurrency
use_math: true
header: 
  teaser: 
---

## 네트워크 통신



### 1. HTTP 프로토콜

- HyperText Transfer Protocol
- 하이퍼 문서를 전송하는것에서 시작하였다
- 현재는 이미지/영상/음성파일/Json 등 모든 데이터 전송 가능
- 인터넷은` HTTP`로 이로어져 있다

### 2. Rest API

- API는 상호간의 정보 교환을 위한 인터페이스다.(약속)
- API 주소를 만들 때 명사형으로 작성하는 API이다.

### 3. 네트워킹

1. 무조건 요청을 먼저 해야한다
1. 요청을 받으면 응답 메시지를 받는다(json)

### 4. iOS 네트워킹

### 요청순서

- url - url 만들기
- URLSession - 브라우저를 키는 행위
- dataTask - 일을 던져준다
- resume - 시작 버튼(요청 메시지 날라감)

### 서버 응답순서

- 요청사항을 받고 messagebody에 json data를 담는다
- 응답 메시지를 보낸다

### 
