---
title: "[RestApi] Rest Api란?"
tags: 
- RestApi
use_math: true
header: 
  teaser: 

---

## 1. Rest란?

1. HTTP URL을 통해 자원을 명시하고
2. HTTP Method(Post, Put, Delete, Patch등)을 통해
3. 해당 자원(URL)에 대한 CRUD Operation을 적용하는 것을 의미한다.
4. 즉 자원을 이름으로 구분하여 해당 자원의 상태를 주고받는 모든 것을 의미한다.
5. 또는 클라이언트와 서버 간의 두 컴퓨터 시스템이 인터넷을 통해 정보를 안전하게 교환하기 위해 사용하는 인터페이스다.

## 2. Rest 특징

- Server-Client 구조
- Stateless(무상태)
- Cacheable(캐시 처리 가능)
- Layered System(계층화)
- Uniform Interface(인터페이스 일관성)

## 3 Rest API란?

- Rest의 원리를 따르는 API를 의미한다.

## 4. Rest API 설계 예시

### **R****EST API 설계 예시**

**1. URI는 동사보다는 명사를, 대문자보다는 소문자를 사용하여야 한다.**

> ***\**\*Bad Example [http://khj93.com/Running/](http://khj93.com/test/)\*\*\*\*
> \*\*\*\*\*\*\*\*\*\*Good Example\*\*\*\* [http://khj93.com/run/](http://khj93.com/test/)\*\***
>
> **\*\*\*\*\*\*\**** 

 

**2. 마지막에 슬래시 (/)를 포함하지 않는다.**

> ***\**\*\*\*Bad Example http://khj93.com/test/\*\* \*\*
> \*\*\*\*\*\*\*\*\*\*Good Example\*\*\*\* [http://khj93.com/test](http://khj93.com/test/)\*\*\*\*\*\*\*\*\*\**\***

 

**3. 언더바 대신 하이폰을 사용한다.**

> ***\**\*\*\*Bad Example [http://khj93.com/test_blog](http://khj93.com/test/)\*\*\*\*
> \*\*\*\*\*\*\*\*\*\*Good Example\*\*\*\* [http://khj93.com/test-blog](http://khj93.com/test/)\*\*\*\*\*\*\*\*\*\**\*** 

 

**4. 파일확장자는 URI에 포함하지 않는다.**

> ***\**\*\*\*Bad Example [http://khj93.com/photo.jpg](http://khj93.com/test/)\*\* \*\*
> \*\*\*\*\*\*\*\*\*\*Good Example\*\*\*\* [http://khj93.com/photo](http://khj93.com/test/)\*\*\*\*\*\*\*\*\*\**\*** 

 

**5. 행위를 포함하지 않는다.**

> ***\**\*Bad Example [http://khj93.com/delete-post/1](http://khj93.com/test/)\*\* \*\*
> \*\*\*\*\*\*\*\*\*\*Good Example\*\*\*\* [http://khj93.com/post/1](http://khj93.com/test/)\*\*\*\*\*\*\*\*\**** 
