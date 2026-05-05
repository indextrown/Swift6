//
//  TodosAPI+Async.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 4/1/25.
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
    
    // MARK: - 에러를 보내지 않는다: Never -> 에러가 들어오면 replaceError로 데이터 형태로 만들어줬다 Combine의 에러 스트림은 완전히 막고, 모든 성공/실패는 Result 안에서 처리하는 형태
    /// 모든 할 일 목록 가져오기 RESULT 방식(데이터를 보낼떄 Result로 감싸서 보낸다 -> return success/failure)
    /// - Parameter page: 페이지
    /// - Returns: 응답 결과 AnyPublisher<Result<BaseListResponse<Todo>, ApiError>, Never>
    static func fetchTodosWithAsyncResult(page: Int = 1) async -> Result<BaseListResponse<Todo>, ApiError> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "?page=\(page)"

        guard let url = URL(string: urlString) else {
            // MARK: - 이벤트를 하나만 보내기, eraseToAnyPublisher: AnyPublisher형태로 바꾸어준다
            return .failure(ApiError.nowAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
            let todos = listResponse.data
            
            // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
            guard let todos = todos, !todos.isEmpty else {
                return .failure(ApiError.noContentError)
            }
            
            return .success(listResponse)
            
        } catch {
            // 만약 들어오는 에러가 디코딩 에러라면
            if let _ = error as? DecodingError {
                return .failure(ApiError.decodingError)
            }
            
            return .failure(ApiError.unknownError(error))
        }
    }
    
    
    /// 모든 할 일 목록 가져오기 에러처리를 따로 던지는 방식(에러를 직접 던지는 방식) -> Observable 스코프 안에서 에러를 throw
    /// - Parameters:
    ///   - page: 페이지
    ///   - completion: 응답 결과
    // MARK: - 단점: 어떤 에러가 던져지는지에 대한 에러에 대한 타입을 알 수 없다 -> 수신하는 쪽에서 처리할 수 밖에 없다
    // MARK: - 면접질문: RXSwift vs Combine Publisher 차이가 뭐냐? -> Combine은 에러타입이 명시가 되어 있다
    static func fetchTodosWithAsync(page: Int = 1) async throws -> BaseListResponse<Todo> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "?page=\(page)"

        guard let url = URL(string: urlString) else {
            throw ApiError.nowAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            }
            
            // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
            let todos = listResponse.data
            
            // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
            guard let todos = todos, !todos.isEmpty else {
                throw ApiError.noContentError
            }
            return listResponse
            
        } catch {
            
            // 만약 들어오는 에러가 URLError 에러라면
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            // 만약 들어오는 에러가 디코딩 에러라면
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknownError(error)
        }
    }
    
    /// 특정 할 일 가져오기
    /// - Parameters:
    ///   - id: 할일 아이디
    ///   - completion: 응답 결과
    static func fetchATodoWithAsync(id: Int) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "/\(id)"

        guard let url = URL(string: urlString) else {
            throw ApiError.nowAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            let aTodo = baseResponse.data
            
            // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
            guard let _ = aTodo else {
                throw ApiError.noContentError
            }
            
            return baseResponse
            
        } catch {
            // 만약 들어오는 에러가 URLError 에러라면
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            // 만약 들어오는 에러가 디코딩 에러라면
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknownError(error)
        }
    }
    
    /// 할 일 검색하기
    /// - Parameters:
    ///   - searchTerm: 검색텍스트
    ///   - page: 페이지
    ///   - completion: 응답 결과
    static func searchTodosWithAsync(searchTerm: String, page: Int = 1) async throws -> BaseListResponse<Todo> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let requestUrl = URL(baseUrl: baseURL + "/todos/search", queryItems: ["query": searchTerm, "page": "\(page)"])
        
        guard let url = requestUrl else {
            throw ApiError.nowAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                throw ApiError.unknownError(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unAuthorized
                
            default:
                print("default")
            }
            
            // 상태코드가 200번대가 아니면 에러를 던진다
            if !(200...299).contains(httpResponse.statusCode) {
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
            let todos = listResponse.data
            
            // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
            guard let todos = todos, !todos.isEmpty else {
                throw ApiError.noContentError
            }
            return listResponse
            
        } catch {
            
            // 만약 들어오는 에러가 URLError 에러라면
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            // 만약 들어오는 에러가 디코딩 에러라면
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknownError(error)
        }
    }
    
    /// 할 일 추가하기 - FORM방식
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoWithAsync(title: String, isDone: Bool = false) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos"
        guard let url = URL(string: urlString) else {
            throw ApiError.nowAllowedUrl
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
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            let aTodo = baseResponse.data
            
            // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
            guard let _ = aTodo else {
                throw ApiError.noContentError
            }
            
            return baseResponse
            
        } catch {
            // 만약 들어오는 에러가 URLError 에러라면
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            // 만약 들어오는 에러가 디코딩 에러라면
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknownError(error)
        }
    }
    
    /// 할 일 추가하기 - Json방식
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoJsonWithAsync(title: String, isDone: Bool = false) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos-json"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.nowAllowedUrl
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
            throw ApiError.jsonEncodingError
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            let aTodo = baseResponse.data
            
            // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
            guard let _ = aTodo else {
                throw ApiError.noContentError
            }
            
            return baseResponse
            
        } catch {
            // 만약 들어오는 에러가 URLError 에러라면
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            // 만약 들어오는 에러가 디코딩 에러라면
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknownError(error)
        }
    }
    
    /// 할 일 수정하기 - Json방식
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func editATodoJsonWithAsync(id: Int,
                              title: String,
                                           isDone: Bool = false) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.nowAllowedUrl
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
            throw ApiError.jsonEncodingError
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            let aTodo = baseResponse.data
            
            // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
            guard let _ = aTodo else {
                throw ApiError.noContentError
            }
            
            return baseResponse
            
        } catch {
            // 만약 들어오는 에러가 URLError 에러라면
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            // 만약 들어오는 에러가 디코딩 에러라면
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknownError(error)
        }
    }
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func editATodoPutWithAsync(id: Int,
                              title: String,
                                          isDone: Bool = false) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.nowAllowedUrl
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
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            let aTodo = baseResponse.data
            
            // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
            guard let _ = aTodo else {
                throw ApiError.noContentError
            }
            
            return baseResponse
            
        } catch {
            // 만약 들어오는 에러가 URLError 에러라면
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            // 만약 들어오는 에러가 디코딩 에러라면
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknownError(error)
        }
    }
    
    /// 할 일 삭제하기 - DELETE
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - completion: 응답 결과
    static func deleteATodoWithAsync(id: Int) async throws -> BaseResponse<Todo> {
        
        print(#fileID, #function, #line, "- deleteATodo 호출됨 / id: \(id)")
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.nowAllowedUrl
        }
        
        // header
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            let aTodo = baseResponse.data
            
            // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
            guard let _ = aTodo else {
                throw ApiError.noContentError
            }
            
            return baseResponse
            
        } catch {
            // 만약 들어오는 에러가 URLError 에러라면
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            // 만약 들어오는 에러가 디코딩 에러라면
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknownError(error)
        }
    }
    
    
    
    
    

    
    
    // MARK: - 클로저 기반 api 연쇄 처리
    /// 할 일 추가 -> 모든 할 일 가져오기
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoAndFetchTodosWitAsync_1(title: String,
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
    // MARK: - 에러가 있는 타입
    static func addATodoAndFetchTodosWithAsync_2(title: String,
                                                     isDone: Bool = false) async throws -> [Todo] {
        
        // 1번 끝나고
        let _ = try await addATodoWithAsync(title: title)
        
        // 2번 호출
        let secondResult = try await fetchTodosWithAsync()
        
        guard let finalResult = secondResult.data else {
            // 에러가 나도 빈배열로 내보내겠다
            return []
        }
        return finalResult
    }
    
    // MARK: - 에러가 없는 타입 - 빈배열로 들어온다
    static func addATodoAndFetchTodosWithAsync_2_NoError(title: String,
                                                     isDone: Bool = false) async -> [Todo] {
        
        do {
            // 1번 끝나고
            let _ = try await addATodoWithAsync(title: title)
            
            // 2번 호출
            let secondResult = try await fetchTodosWithAsync()
            
            guard let finalResult = secondResult.data else {
                // 에러가 나도 빈배열로 내보내겠다
                return []
            }
            return finalResult
            
        } catch {
            if let _ = error as? ApiError {
                return []
            }
            return []
        }
    }
    
    
    
    
    
    
    

    // MARK: - Async 기반 api 동시 처리
    // MARK: - 에러에 대한 명시가 필요없을 때, replaceError하자
    static func deleteSelectedTodosWithAsyncMerge_2(selectedTodoIds: [Int]) -> AnyPublisher<Int, Never> {
        
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
    
    static func deleteSelectedTodosWithAsyncZip(selectedTodoIds: [Int]) -> AnyPublisher<[Int], Never> {
        
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
    
    // MARK: - NoError방식
    static func deleteSelectedTodosWithAsync_NoError(selectedTodoIds: [Int]) async -> [Int] {
        
        // 각자가 출발
        async let firstResult = self.deleteATodoWithAsync(id: 7213)
        async let secondResult = self.deleteATodoWithAsync(id: 7212)
        async let thirdResult = self.deleteATodoWithAsync(id: 7210)
        
        do {
            let results = try await [firstResult.data?.id, secondResult.data?.id, thirdResult.data?.id]
            return results.compactMap { $0 }
        } catch {
            if let _ = error as? URLError {
                return []
            }
            if let _ = error as? ApiError {
                return []
            }
            return []
        }
    }
    
    // MARK: - Error방식
    static func deleteSelectedTodosWithAsyncWithError(selectedTodoIds: [Int]) async throws -> [Int] {
        
        // 각자가 출발
        async let firstResult = self.deleteATodoWithAsync(id: 7213)
        async let secondResult = self.deleteATodoWithAsync(id: 7212)
        async let thirdResult = self.deleteATodoWithAsync(id: 7210)
        
        let results = try await [firstResult.data?.id, secondResult.data?.id, thirdResult.data?.id]
        return results.compactMap { $0 }
    }
    
    // MARK: - Async 기반 api 동시 처리 -> 존재하지 않는 게시글은 에러를 던지는게 아니라 nil로 필터링 가능
    // MARK: - TaskGroup방식
    static func deleteSelectedTodosWithAsyncTaaskGroupWithError(selectedTodoIds: [Int]) async throws -> [Int] {
        
        try await withThrowingTaskGroup(of: Int?.self) { (group: inout ThrowingTaskGroup<Int?, Error>) -> [Int] in
            
            // 각각 자식 async 테스크를 그룹에 넣기
            for aTodoId in selectedTodoIds {
                group.addTask {
                    // 단일 API 쏘기
                    let childTaskResult = try await self.deleteATodoWithAsync(id: aTodoId)
                    return childTaskResult.data?.id
                }
            }
            var deleteTodoIds: [Int] = []
            for try await singleValue in group {
                if let value = singleValue {
                    deleteTodoIds.append(value)
                }
            }
            
            return deleteTodoIds
        }
    }
    
    // MARK: - TaskGroup방식 + 에러없는거를 잘 리턴하는방식
    static func deleteSelectedTodosWithAsyncTaaskGroupWithNoError(selectedTodoIds: [Int]) async -> [Int] {
        
        await withTaskGroup(of: Int?.self) { (group: inout TaskGroup<Int?>) -> [Int] in
            
            // 각각 자식 async 테스크를 그룹에 넣기
            for aTodoId in selectedTodoIds {
                group.addTask {
                    
                    do {
                        // 단일 API 쏘기
                        let childTaskResult = try await self.deleteATodoWithAsync(id: aTodoId)
                        return childTaskResult.data?.id
                    } catch {
                        return nil
                    }
                }
            }
            var deleteTodoIds: [Int] = []
            for await singleValue in group {
                if let value = singleValue {
                    deleteTodoIds.append(value)
                }
            }
            
            return deleteTodoIds
        }
    }
    
    
    
    
    
    // MARK: - Async 기반 api 동시 처리
    /// 선택된 할일들 가져오기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디들
    ///   - completion: 응답 결과
    static func fetchSelectedTodosWithAsyncNoError(selectedTodoIds: [Int]) async -> [Todo] {
        
        await withTaskGroup(of: Todo?.self) { (group: inout TaskGroup<Todo?>) -> [Todo] in
            
            // 각각 자식 async 테스크를 그룹에 넣기
            for aTodoId in selectedTodoIds {
                group.addTask {
                    
                    do {
                        // 단일 API 쏘기
                        let childTaskResult = try await self.deleteATodoWithAsync(id: aTodoId)
                        return childTaskResult.data
                    } catch {
                        return nil
                    }
                }
            }
            var fetchedTodoIds: [Todo] = []
            for await singleValue in group {
                if let value = singleValue {
                    fetchedTodoIds.append(value)
                }
            }
            
            return fetchedTodoIds
        }
    }
    
    // MARK: - 에러 있는 버전
    static func fetchSelectedTodosWithAsyncWithError(selectedTodoIds: [Int]) async throws -> [Todo] {
        
        try await withThrowingTaskGroup(of: Todo?.self) { (group: inout ThrowingTaskGroup<Todo?, Error>) in
            
            // 각각 자식 async 테스크를 그룹에 넣기
            for aTodoId in selectedTodoIds {
                group.addTask {
                    // 단일 API 쏘기
                    let childTaskResult = try await self.fetchATodoWithAsync(id: aTodoId)
                    return childTaskResult.data
                }
            }
            
            var fetchedTodos: [Todo] = []
            for try await singleValue in group {
                if let value = singleValue {
                    fetchedTodos.append(value)
                }
            }
            
            return fetchedTodos
        }
    }
    
}

// MARK: - Async to Combine
extension TodosAPI {
    static func fetchTodosAsyncToPublisher(page: Int) -> AnyPublisher<BaseListResponse<Todo>, Error> {
        return Future { (promise: @escaping (Result<BaseListResponse<Todo>, Error>) -> Void) in
            Task {
                do {
                    let asyncResult = try await fetchTodosWithAsync(page: page)
                    promise(.success(asyncResult))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}

extension TodosAPI {
    // MARK: - 제네릭하게 사용하는 방법
    static func genericAsyncToPublisher<T>(asyncWork: @escaping () async throws -> T) -> AnyPublisher<T, Error> {
        return Future { (promise: @escaping (Result<T, Error>) -> Void) in
            Task {
                do {
                    let asyncResult = try await asyncWork()
                    promise(.success(asyncResult))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}

extension Publisher {
    func mapAsync<T>(asyncWork: @escaping (Output) async throws -> T) -> Publishers.FlatMap<Future<T, Error>, Publishers.SetFailureType<Self, Error>> {
        
        return flatMap { output in
            return Future { (promise: @escaping (Result<T, Error>) -> Void) in
                Task {
                    do {
                        let asyncResult = try await asyncWork(output)
                        promise(.success(asyncResult))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}
