//
//  TodosAPI+Combine.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/31/25.
//

import Foundation
import MultipartForm
import RxSwift
import RxCocoa
import Combine
import CombineExt

extension TodosAPI {
    // 데이터를 가져와서 응답에 대한 결과를 함수 밖으로 꺼내줘야한다 즉 비동기 처리가 이루어져야하는데 이떄 클로저를 사용한다 completion 블럭을 사용한다
    // dataTask 자체도 클로저이므로 클로저 안에서 클로저가 탈출이 일어나야한다
    // API 요청의 결과는 성공일수도 실패일수도 있어서 Result<>를 이용해 성공시 TodosResponse만 밖으로 내보내고 에러라면 Error를 내보내자
    
    // Just는 단일 값을 방출하고 완료되는 Publisher이다.
    // Fail은 에러만 방출하고 스트림을 종료한다.

    // URLSession의 dataTaskPublisher는 Data와 URLResponse를 방출하는 Publisher를 반환한다.
    // 네트워크 응답에 대한 후속 처리는 map, tryMap, decode 등을 통해 처리한다.
    
    // tryMap은 변환 과정에서 에러를 던질 수 있는 map이다.
    // map은 데이터만 변환하고 에러를 전달하지 않는다.
    // mapError는 에러 타입을 우리 앱에 맞는 커스텀 에러로 변환할 때 사용한다.
    
    // replaceError는 에러 발생 시 기본 값을 대체하여 스트림을 유지시킨다.
    // catch는 에러 발생 시 대체 Publisher를 연결할 수 있다.

    // flatMap은 이전 스트림의 결과를 바탕으로 새로운 Publisher를 연결해주는 연산자이다.
    // API 연쇄 호출 시 활용된다.

    // zip은 여러 Publisher의 결과를 순서대로 묶어 하나의 배열로 반환한다.
    // MergeMany는 다수의 Publisher를 병합해 단일 스트림으로 반환한다.



    
    // MARK: - 에러를 보내지 않는다: Never -> 에러가 들어오면 replaceError로 데이터 형태로 만들어줬다 Combine의 에러 스트림은 완전히 막고, 모든 성공/실패는 Result 안에서 처리하는 형태
    /// 모든 할 일 목록 가져오기 RESULT 방식(데이터를 보낼떄 Result로 감싸서 보낸다 -> return success/failure)
    /// - Parameter page: 페이지
    /// - Returns: 응답 결과 AnyPublisher<Result<BaseListResponse<Todo>, ApiError>, Never>
    static func fetchTodosWithPublisherResult(page: Int = 1) -> AnyPublisher<Result<BaseListResponse<Todo>, ApiError>, Never> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "?page=\(page)"

        guard let url = URL(string: urlString) else {
            // MARK: - 이벤트를 하나만 보내기, eraseToAnyPublisher: AnyPublisher형태로 바꾸어준다
            return Just(.failure(ApiError.nowAllowedUrl)).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map({ (data: Data, urlResponse: URLResponse) -> Result<BaseListResponse<Todo>, ApiError> in
                
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    return .failure(ApiError.unknownError(nil))
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    return .failure(ApiError.unAuthorized)
                default:
                    print("default")
                }
                
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    return .failure(ApiError.badStatus(code: httpResponse.statusCode))
                }
                
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                    let todos = listResponse.data
                    
                    // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
                    guard let todos = todos, !todos.isEmpty else {
                        return .failure(ApiError.noContentError)
                    }
                    
                    return .success(listResponse)
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    return .failure(.decodingError)
                }
            })
            // 에러 핸들링 1: 에러 발생시 에러를 다른 형태로 반환(이게 안전한 방법이다) 퍼블리셔 데이터 요소로 변경하는 작업
            // Combine 스트림의 에러(failure)**를 👉 Result.failure(...) 형태의 값으로 "감싸서" 보내주는 방식
            .replaceError(with: .failure(ApiError.unknownError(nil)))
         
            // 에러 핸들링 2: 테스트할때 사용방법: 에러가 무조건 나지 않을거라고 단언하는방식: 만약 실패일어나면 앱이 crash나기 때문에 잘 안씀
            //.assertNoFailure()
        
            // 에러 핸들링 3: catch - 들어오는 에러를 잡아서 failure 데이터(다른 publisher로 만들때) 형태로 반환한다 == replaceError랑 같다고 생각하자
        /*
            .catch({ err in
                return Just(.failure(ApiError.unknownError(nil)))
            })
         */
            // 에러 핸들링 4: try-catch - 다른 에러를 만들어서 전달하는 방식
            
            .eraseToAnyPublisher()
    }
    
    
    /// 모든 할 일 목록 가져오기 에러처리를 따로 던지는 방식(에러를 직접 던지는 방식) -> Observable 스코프 안에서 에러를 throw
    /// - Parameters:
    ///   - page: 페이지
    ///   - completion: 응답 결과
    // MARK: - 단점: 어떤 에러가 던져지는지에 대한 에러에 대한 타입을 알 수 없다 -> 수신하는 쪽에서 처리할 수 밖에 없다
    // MARK: - 면접질문: RXSwift vs Combine Publisher 차이가 뭐냐? -> Combine은 에러타입이 명시가 되어 있다
    static func fetchTodosWithPublisher(page: Int = 1) -> AnyPublisher<BaseListResponse<Todo>, ApiError> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "?page=\(page)"

        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.nowAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
        // MARK: - map사용이유: dataTaskPublisher에서 들어온 데이터를 형태를 변경하기 위함
            .tryMap { (data: Data, urlResponse: URLResponse) -> BaseListResponse<Todo> in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknownError(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    // return .failure(ApiError.unAuthorized)
                    
                    // 에러를 던지면 밖으로 나가버려서 밖으로 나가버려서 리턴을 따로 안해도됨
                    // 기존은 return failure로 즉 result클래스로 반환을 하겠다였는데 즉 OnservablResult였는데 이제는 BaseListResponse로 처리한다
                    // 에러에 대한 부분은 구독한 즉 수신한 쪽에서 처리한다
                    throw ApiError.unAuthorized
                    
                default:
                    print("default")
                }
                
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                    // return .failure(ApiError.badStatus(code: httpResponse.statusCode))
                    // return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
                }
                
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                    let todos = listResponse.data
                    
                    // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
                    guard let todos = todos, !todos.isEmpty else {
                        throw ApiError.noContentError
                        //return .failure(ApiError.noContentError)
                        // return completion(.failure(ApiError.noContentError))
                    }
                    
                    return listResponse
                    // return .success(listResponse)
                    // completion(.success(listResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    throw ApiError.decodingError
                    // return .failure(.decodingError)
                    // completion(.failure(.decodingError))
                }
            }
            .mapError({ error -> ApiError in
                if let error = error as? ApiError {
                    return error
                }
                return ApiError.unknownError(nil)
            })
            .eraseToAnyPublisher()
    }
    
    // .decode 오퍼레이터 사용 (Combine 내장 기능)
    // 코드 간결, Combine스러운 처리
    // 디코딩 실패 시 디버깅 어려울 수 있음
    static func fetchTodosWithPublisher_디코딩먼저하는방식(page: Int = 1) -> AnyPublisher<BaseListResponse<Todo>, ApiError> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "?page=\(page)"

        guard let url = URL(string: urlString) else {
            // combine 에러를 바로 던지는 방법
            return Fail(error: ApiError.nowAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
        // MARK: - map사용이유: dataTaskPublisher에서 들어온 데이터를 형태를 변경하기 위함 -> 형태를 변환하는 과정에서 에러를 던지고 싶을 때 tryMap사용
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknownError(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    // return .failure(ApiError.unAuthorized)
                    
                    // 에러를 던지면 밖으로 나가버려서 밖으로 나가버려서 리턴을 따로 안해도됨
                    // 기존은 return failure로 즉 result클래스로 반환을 하겠다였는데 즉 OnservablResult였는데 이제는 BaseListResponse로 처리한다
                    // 에러에 대한 부분은 구독한 즉 수신한 쪽에서 처리한다
                    throw ApiError.unAuthorized
                    
                default:
                    print("default")
                }
                
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                    // return .failure(ApiError.badStatus(code: httpResponse.statusCode))
                    // return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
                }
                
                return data
            }
        
            // MARK: - do Catch 대신 디코딩 처리를 중간에서 할 수 있다 즉 dataTaskPublisher 데이터 스트림 안에서 처리 가능
            // 하지만 에러 발생할 수 있어서 ApiError뿐반 아니라 디코딩 실패관련 DecodingError에도 지정해줘야한다
            // Json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            .decode(type: BaseListResponse<Todo>.self, decoder: JSONDecoder())
            .tryMap({ response in
                // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
                guard let todos = response.data, !todos.isEmpty else {
                    throw ApiError.noContentError
                }
                // 파싱한 데이터가 있다면 response 반환
                return response
            })
        
            // MARK: - 어떠한 에러가 들어오든 에러들의 타입을 체크해서 ApiError형태로 만들어 준것이다
            .mapError({ error -> ApiError in
                // 이미 ApiError 타입이면 그대로 반환
                if let error = error as? ApiError {
                    return error
                }
                
                // 시스템에서 발생한 DecodingError라면 우리가 만든 ApiError로 리턴해라
                // 앱 안에서 공통적으로 처리할 수 있도록 우리만의 에러타입으로 변환해서 통일하려는 의도
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknownError(nil)
            })
            .eraseToAnyPublisher()
    }
    
    /// 특정 할 일 가져오기
    /// - Parameters:
    ///   - id: 할일 아이디
    ///   - completion: 응답 결과
    static func fetchATodoWithPublisher(id: Int) -> AnyPublisher<BaseResponse<Todo>, ApiError> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "/\(id)"

        guard let url = URL(string: urlString) else { 
            return Fail(error: ApiError.nowAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknownError(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                    // return completion(.failure(ApiError.unAuthorized))
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                    // return completion(.failure(ApiError.noContentError))
                default:
                    print("default")
                }
    
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
    
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .tryMap({ response in
                // 파싱한 데이터가 없을 경우(data == nil) 커스텀 에러 던짐
                guard let _ = response.data else {
                    throw ApiError.noContentError
                }
                // 파싱한 데이터가 있다면 response 반환
                return response
            })
            .mapError({ error -> ApiError in
                // ApiError라면 그대로 반환
                if let error = error as? ApiError {
                    return error
                }
                
                // DecodingError라면 ApiError로 ApiError로 리턴해라
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknownError(nil)
            }).eraseToAnyPublisher()
    }
    
    /// 할 일 검색하기
    /// - Parameters:
    ///   - searchTerm: 검색텍스트
    ///   - page: 페이지
    ///   - completion: 응답 결과
    static func searchTodosWithPublisher(searchTerm: String, page: Int = 1) -> AnyPublisher<BaseListResponse<Todo>, ApiError> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let requestUrl = URL(baseUrl: baseURL + "/todos/search", queryItems: ["query": searchTerm, "page": "\(page)"])
        
        guard let url = requestUrl else {
            return Fail(error: ApiError.nowAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknownError(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                default:
                    print("default")
                }
                
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                return data
            }
            .decode(type: BaseListResponse<Todo>.self, decoder: JSONDecoder())
            .tryMap { response in
                // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
                guard let todos = response.data, !todos.isEmpty else {
                    throw ApiError.noContentError
                }
                return response
            }
            // MARK: - 어떠한 에러가 들어오든 에러들의 타입을 체크해서 ApiError형태로 만들어 준것이다
            .mapError({ error -> ApiError in
                // 이미 ApiError 타입이면 그대로 반환
                if let error = error as? ApiError {
                    return error
                }
                
                // 시스템에서 발생한 DecodingError라면 우리가 만든 ApiError로 리턴해라
                // 앱 안에서 공통적으로 처리할 수 있도록 우리만의 에러타입으로 변환해서 통일하려는 의도
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknownError(nil)
            })
            .eraseToAnyPublisher()
    }
    
    /// 할 일 추가하기 - FORM방식
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoWithPublisher(title: String, isDone: Bool = false) -> AnyPublisher<BaseResponse<Todo>, ApiError> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos"
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.nowAllowedUrl).eraseToAnyPublisher()
        }
        
        // header
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        let form = MultipartForm(parts: [
            // body
            MultipartForm.Part(name: "title", value: title),
            MultipartForm.Part(name: "is_done", value: "\(isDone)"),
        ])
        urlRequest.addValue(form.contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = form.bodyData
        // print("form: \(form.contentType)")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknownError(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                    // return completion(.failure(ApiError.unAuthorized))
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                    // return completion(.failure(ApiError.noContentError))
                default:
                    print("default")
                }
    
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
    
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .tryMap({ response in
                // 파싱한 데이터가 없을 경우(data == nil) 커스텀 에러 던짐
                guard let _ = response.data else {
                    throw ApiError.noContentError
                }
                // 파싱한 데이터가 있다면 response 반환
                return response
            })
            .mapError({ error -> ApiError in
                // ApiError라면 그대로 반환
                if let error = error as? ApiError {
                    return error
                }
                
                // DecodingError라면 ApiError로 ApiError로 리턴해라
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknownError(nil)
            }).eraseToAnyPublisher()
    }
    
    /// 할 일 추가하기 - Json방식
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoJsonWithPublisher(title: String, isDone: Bool = false) -> AnyPublisher<BaseResponse<Todo>, ApiError> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos-json"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.nowAllowedUrl).eraseToAnyPublisher()
        }
        
        // header
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestParams: [String: Any] = ["title": title, "is_done": isDone]
        
        do {
            // 딕셔너리 -> json 직렬화
            let jsonData = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            urlRequest.httpBody = jsonData
        } catch {
            return Fail(error: ApiError.jsonEncodingError).eraseToAnyPublisher()
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknownError(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                    // return completion(.failure(ApiError.unAuthorized))
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                    // return completion(.failure(ApiError.noContentError))
                default:
                    print("default")
                }
    
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
    
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .tryMap({ response in
                // 파싱한 데이터가 없을 경우(data == nil) 커스텀 에러 던짐
                guard let _ = response.data else {
                    throw ApiError.noContentError
                }
                // 파싱한 데이터가 있다면 response 반환
                return response
            })
            .mapError({ error -> ApiError in
                // ApiError라면 그대로 반환
                if let error = error as? ApiError {
                    return error
                }
                
                // DecodingError라면 ApiError로 ApiError로 리턴해라
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknownError(nil)
            }).eraseToAnyPublisher()
    }
    
    /// 할 일 수정하기 - Json방식
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func editATodoJsonWithPublisher(id: Int,
                              title: String,
                                           isDone: Bool = false) -> AnyPublisher<BaseResponse<Todo>, ApiError> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.nowAllowedUrl).eraseToAnyPublisher()
        }
        
        // header
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestParams: [String: Any] = ["title": title, "is_done": isDone]
        
        do {
            // 딕셔너리 -> json 직렬화
            let jsonData = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            urlRequest.httpBody = jsonData
        } catch {
            return Fail(error: ApiError.jsonEncodingError).eraseToAnyPublisher()
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknownError(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                    // return completion(.failure(ApiError.unAuthorized))
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                    // return completion(.failure(ApiError.noContentError))
                default:
                    print("default")
                }
    
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
    
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .tryMap({ response in
                // 파싱한 데이터가 없을 경우(data == nil) 커스텀 에러 던짐
                guard let _ = response.data else {
                    throw ApiError.noContentError
                }
                // 파싱한 데이터가 있다면 response 반환
                return response
            })
            .mapError({ error -> ApiError in
                // ApiError라면 그대로 반환
                if let error = error as? ApiError {
                    return error
                }
                
                // DecodingError라면 ApiError로 ApiError로 리턴해라
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknownError(nil)
            }).eraseToAnyPublisher()
    }
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func editATodoPutWithPublisher(id: Int,
                              title: String,
                                          isDone: Bool = false) -> AnyPublisher<BaseResponse<Todo>, ApiError> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.nowAllowedUrl).eraseToAnyPublisher()
        }
        
        // header
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestParams: [String: String] = ["title": title, "is_done": "\(isDone)"]
        urlRequest.percentEncodeParameters(parameters: requestParams)
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknownError(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                    // return completion(.failure(ApiError.unAuthorized))
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                    // return completion(.failure(ApiError.noContentError))
                default:
                    print("default")
                }
    
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
    
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .tryMap({ response in
                // 파싱한 데이터가 없을 경우(data == nil) 커스텀 에러 던짐
                guard let _ = response.data else {
                    throw ApiError.noContentError
                }
                // 파싱한 데이터가 있다면 response 반환
                return response
            })
            .mapError({ error -> ApiError in
                // ApiError라면 그대로 반환
                if let error = error as? ApiError {
                    return error
                }
                
                // DecodingError라면 ApiError로 ApiError로 리턴해라
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknownError(nil)
            }).eraseToAnyPublisher()
    }
    
    /// 할 일 삭제하기 - DELETE
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - completion: 응답 결과
    static func deleteATodoWithPublisher(id: Int) -> AnyPublisher<BaseResponse<Todo>, ApiError> {
        
        print(#fileID, #function, #line, "- deleteATodo 호출됨 / id: \(id)")
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.nowAllowedUrl).eraseToAnyPublisher()
        }
        
        // header
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknownError(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                    // return completion(.failure(ApiError.unAuthorized))
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                    // return completion(.failure(ApiError.noContentError))
                default:
                    print("default")
                }
    
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
    
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .tryMap({ response in
                // 파싱한 데이터가 없을 경우(data == nil) 커스텀 에러 던짐
                guard let _ = response.data else {
                    throw ApiError.noContentError
                }
                // 파싱한 데이터가 있다면 response 반환
                return response
            })
            .mapError({ error -> ApiError in
                // ApiError라면 그대로 반환
                if let error = error as? ApiError {
                    return error
                }
                
                // DecodingError라면 ApiError로 ApiError로 리턴해라
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknownError(nil)
            }).eraseToAnyPublisher()
    }
    
    
    
    
    

    
    
    // MARK: - 클로저 기반 api 연쇄 처리
    /// 할 일 추가 -> 모든 할 일 가져오기
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoAndFetchTodosWithPublisher_1(title: String,
                                                     isDone: Bool = false) -> AnyPublisher<BaseListResponse<Todo>, ApiError> {
        // 1
        return self.addATodoWithPublisher(title: title)
            // 첫번째 호출했던 API 응답 결과
            // 에러는 throw를 통해 던져지기 때문에 구독하는 쪽에서 처리하면됨
            .flatMap { _ in
                self.fetchTodosWithPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - 클로저 기반 api 연쇄 처리
    /// 할 일 추가 -> 모든 할 일 가져오기
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoAndFetchTodosWithPublisher_2(title: String,
                                                     isDone: Bool = false) -> AnyPublisher<[Todo], ApiError> {
        // 1
        return self.addATodoWithPublisher(title: title)
            // 첫번째 호출했던 API 응답 결과
            // 에러는 throw를 통해 던져지기 때문에 구독하는 쪽에서 처리하면됨
            .flatMap { _ in  // 응답
                self.fetchTodosWithPublisher()
            } // BaseListResponse<Todo>
            .compactMap { $0.data } // Optional([Todo]) -> [Todo]
            /*
            .catch { err in
                // 에러가 들어온다면 빈 리스트를 보낸다
                print("TodosAPI - catch : err: \(err)")
                return Just([]).eraseToAnyPublisher()
            }
            //.replaceError(with: [])
            */
        // MARK: - 어차피 호출에서 오는 에러는 APIError이기 때문에 주석부분 안해도됨
            .eraseToAnyPublisher()
    }
    
    // MARK: - 클로저 기반 api 연쇄 처리
    /// 할 일 추가 -> 모든 할 일 가져오기 - No 에러
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoAndFetchTodosWithPublisher_3(title: String,
                                                     isDone: Bool = false) -> AnyPublisher<[Todo], Never> {
        // 1
        return self.addATodoWithPublisher(title: title)
            // 첫번째 호출했던 API 응답 결과
            // 에러는 throw를 통해 던져지기 때문에 구독하는 쪽에서 처리하면됨
            .flatMap { _ in  // 응답
                self.fetchTodosWithPublisher()
            } // BaseListResponse<Todo>
            .compactMap { $0.data } // Optional([Todo]) -> [Todo]
            /*
            .catch { err in
                // 에러가 들어온다면 빈 리스트를 보낸다
                print("TodosAPI - catch : err: \(err)")
                return Just([]).eraseToAnyPublisher()
            }
             */
            .replaceError(with: [])
        // MARK: - 어차피 호출에서 오는 에러는 APIError이기 때문에 주석부분 안해도됨
            .eraseToAnyPublisher()
    }
    
    
    
    
    
    
    
    
    // MARK: - Zip 방식 - 결과를 배열(컬렉션)으로 반환한다
    // MARK: - 클로저 기반 api 동시 처리 -> 존재하지 않는 게시글은 에러를 던지는게 아니라 nil로 필터링 가능
    /// 선택된 할일들 삭제하기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSelectedTodosWithPublisher(selectedTodoIds: [Int]) -> Observable<[Int]> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열로 만들기
        // 2. 배열로 단일 api를 호출
        // MARK: - Map은 배열을 하나하나 반복문을 돌면서 형태를 변경시킨다
        let apiCallObservables = selectedTodoIds.map { id -> Observable<Int?> in
            return self.deleteATodoWithObservable(id: id)
                .map { $0.data?.id } // 현재 들어오는 Todo 데이터의 data.id를 Int?로 형태를 바꿈
            
                // MARK: - 에러를 가지고 분기처리할 때 or 특정한 에러타입에 따라 다른 형태를 반환하려면 이렇게 사용
                /*
                .catch { err in
                    return Observable.just(nil) // 에러가 나면 nil로 변경 -> 이러면 error 파이프라인을 안타고 onNext로 데이터가 들어올거다
                }
                */
                // MARK: - 에러가나면 단순히 다른 형태를 리턴한다면 이렇게 사용
                .catchAndReturn(nil)
                 
        }
        return Observable.zip(apiCallObservables)
            .map { // Observable<[Int?]>
                $0.compactMap { $0 } // Int, nil은 필터링되어 삭제된 애들만 배열로 들어온다
            } // Observable[Int]
    }
    
    // MARK: - Merge방식은 배열이 아닌 단일아이템 하나가 들어온다 -> 에러에 대한 명시가 필요할 때
    /// 선택된 할일들 삭제하기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSelectedTodosWithPublisherMerge_1(selectedTodoIds: [Int]) -> AnyPublisher<Int, ApiError> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열로 만들기
        // 2. 배열로 단일 api를 호출
        let apiPublishers: [AnyPublisher<Int, TodosAPI.ApiError>] = selectedTodoIds.map { id -> AnyPublisher<Int, ApiError> in
            return self.deleteATodoWithPublisher(id: id)
                .compactMap { $0.data?.id } // 현재 들어오는 Todo 데이터의 data.id를 Int로 형태를 바꿈
                .eraseToAnyPublisher()
        }
        // 하나의 스트림으로 만들기
        return Publishers.MergeMany(apiPublishers).eraseToAnyPublisher()
    }
    
    // MARK: - 에러에 대한 명시가 필요없을 때, replaceError하자
    static func deleteSelectedTodosWithPublisherMerge_2(selectedTodoIds: [Int]) -> AnyPublisher<Int, Never> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열로 만들기
        // 2. 배열로 단일 api를 호출
        let apiPublishers: [AnyPublisher<Int?, Never>] = selectedTodoIds.map { id -> AnyPublisher<Int?, Never> in
            return self.deleteATodoWithPublisher(id: id)
                .map { $0.data?.id } // Int?
                /*
                .catch({ error in
                    
                })
                 */
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        // 하나의 스트림으로 만들기
        return Publishers.MergeMany(apiPublishers).compactMap { $0 }.eraseToAnyPublisher()
    }
    
    static func deleteSelectedTodosWithPublisherZip(selectedTodoIds: [Int]) -> AnyPublisher<[Int], Never> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열로 만들기
        // 2. 배열로 단일 api를 호출
        let apiCallPublishers: [AnyPublisher<Int?, Never>] = selectedTodoIds.map { id -> AnyPublisher<Int?, Never> in
            return self.deleteATodoWithPublisher(id: id)
                .map { $0.data?.id } // Int?
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        
        // zip: apiCallPublishers 배열에 zip을 통해서 각각의 녀석들을 배열로 묶어서 동시 호출 가능해진다
        return apiCallPublishers.zip().map { $0.compactMap { $0 } }.eraseToAnyPublisher()
    }
    
    
    
    
    
    // MARK: - 클로저 기반 api 동시 처리
    /// 선택된 할일들 가져오기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디들
    ///   - completion: 응답 결과
    static func fetchSelectedTodosWithPublisher(selectedTodoIds: [Int]) -> AnyPublisher<[Todo], Never> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열로 만들기
        // 2. 배열로 단일 api를 호출
        let apiCallPublishers = selectedTodoIds.map { id -> AnyPublisher<Todo?, Never> in
            return self.fetchATodoWithPublisher(id: id)
                .map { $0.data } // Todo?
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        return apiCallPublishers.zip().map { $0.compactMap { $0 } }.eraseToAnyPublisher()
    }
    
    // MARK: - 클로저 기반 api 동시 처리
    /// 선택된 할일들 가져오기 - Merge -> 여러 묶은게 동시 호출되긴 하지만 결과들이 하나 하나 하나가 들어온다
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디들
    ///   - completion: 응답 결과
    static func fetchSelectedTodosWithPublisherMerge(selectedTodoIds: [Int]) -> AnyPublisher<Todo, Never> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열로 만들기
        // 2. 배열로 단일 api를 호출
        let apiCallPublishers = selectedTodoIds.map { id -> AnyPublisher<Todo?, Never> in
            return self.fetchATodoWithPublisher(id: id)
                .map { $0.data } // Todo?
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        return Publishers.MergeMany(apiCallPublishers).compactMap { $0 }.eraseToAnyPublisher()
    }
}


// MARK: - Combine -> Async [fetchTodosWithPublisher]
// MARK: - 기존은 구독이 일어나지 않고 바로 데이터 스트림 즉 물줄기만 바꾸었다
// MARK: - 한번 구독을 하고나서 구독에 대한 결과를 withCheckedThrowingContinuation 을 통해 이벤트를 async로 바꾼다
extension TodosAPI {
    
    // 구독 O
    // 받은 이벤트 기반으로 async로 보냄
    // MARK: - Combine -> Async
    static func fetchTodosWithPublisherToAsync(page: Int = 1) async throws -> BaseListResponse<Todo> {

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<BaseListResponse<Todo>, Error>) in
            var cancellable: AnyCancellable? = nil
            
            // cancellable는 구독을 하게 됬을 떄의 메모리 참조
            // API 호출행위가 끝나면 메모리 참조를 없애줘야 한다
            cancellable = fetchTodosWithPublisher(page: page)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("finished")
                    case .failure(let failure):
                        print("failure: \(failure)")
                        continuation.resume(throwing: failure)
                    }
                    cancellable?.cancel()
                }, receiveValue: { response in
                    print("receiveValue: \(response)")
                    continuation.resume(returning: response)
                })
        }
    }
}


extension AnyPublisher {
    func toAsync() async throws -> Output {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Output, Error>) in
            var cancellable: AnyCancellable? = nil
            
            // cancellable는 구독을 하게 됬을 떄의 메모리 참조
            // API 호출행위가 끝나면 메모리 참조를 없애줘야 한다
            cancellable = first()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        // print("finished")
                        break
                    case .failure(let failure):
                        // print("failure: \(failure)")
                        continuation.resume(throwing: failure)
                        break
                    }
                    cancellable?.cancel()
                }, receiveValue: { response in
                    // print("receiveValue: \(response)")
                    continuation.resume(returning: response)
                })
        }
    }
}
