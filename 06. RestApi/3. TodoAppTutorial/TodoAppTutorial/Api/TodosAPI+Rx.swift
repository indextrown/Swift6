//
//  TodosAPI+Rx.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/26/25.
//

import Foundation
import MultipartForm
import RxSwift
import RxCocoa

extension TodosAPI {
    // 데이터를 가져와서 응답에 대한 결과를 함수 밖으로 꺼내줘야한다 즉 비동기 처리가 이루어져야하는데 이떄 클로저를 사용한다 completion 블럭을 사용한다
    // dataTask 자체도 클로저이므로 클로저 안에서 클로저가 탈출이 일어나야한다
    // API 요청의 결과는 성공일수도 실패일수도 있어서 Result<>를 이용해 성공시 TodosResponse만 밖으로 내보내고 에러라면 Error를 내보내자

    /// 모든 할 일 목록 가져오기 RESULT 방식(데이터를 보낼떄 Result로 감싸서 보낸다 -> return success/failure)
    /// - Parameters:
    ///   - page: 페이지
    ///   - completion: 응답 결과
    static func fetchTodosWithObservableResult(page: Int = 1) -> Observable<Result<BaseListResponse<Todo>, ApiError>> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "?page=\(page)"
        // let url = URL(string: urlString)!
        guard let url = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.nowAllowedUrl))
            //return comppletion(.failure(ApiError.nowAllowedUrl))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
        return URLSession.shared.rx.response(request: urlRequest)
        // MARK: - map으로 형태 반환 Result<BaseListResponse<Todo>, ApiError>
            .map { (httpResponse: HTTPURLResponse, data: Data) -> Result<BaseListResponse<Todo>, ApiError> in
                
                // http urlResponse가 아니면 모르는 에러로 던진다
                
                /*
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    return .failure(ApiError.unknownError(nil))
                    // return completion(.failure(ApiError.unknownError(nil)))
                }
                 */
                 
                
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    return .failure(ApiError.unAuthorized)
                    // return completion(.failure(ApiError.unAuthorized))
                default:
                    print("default")
                }
                
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    return .failure(ApiError.badStatus(code: httpResponse.statusCode))
                    // return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
                }
                
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                    let todos = listResponse.data
                    
                    // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
                    guard let todos = todos, !todos.isEmpty else {
                        return .failure(ApiError.noContentError)
                        // return completion(.failure(ApiError.noContentError))
                    }
                    
                    return .success(listResponse)
                    // completion(.success(listResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    return .failure(.decodingError)
                    // completion(.failure(.decodingError))
                }
            }
    }
    
    /// 모든 할 일 목록 가져오기 에러처리를 따로 던지는 방식(에러를 직접 던지는 방식) -> Observable 스코프 안에서 에러를 throw
    /// - Parameters:
    ///   - page: 페이지
    ///   - completion: 응답 결과
    // MARK: - 단점: 어떤 에러가 던져지는지에 대한 에러에 대한 타입을 알 수 없다 -> 수신하는 쪽에서 처리할 수 밖에 없다
    // MARK: - 면접질문: RXSwift vs Combine Publisher 차이가 뭐냐? -> Combine은 에러타입이 명시가 되어 있다
    static func fetchTodosWithObservable(page: Int = 1) -> Observable<BaseListResponse<Todo>> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "?page=\(page)"
        //return Observable.error(ApiError.nowAllowedUrl) 

        guard let url = URL(string: urlString) else {
            // return Observable.just(.failure(ApiError.nowAllowedUrl)) // 스트림 끊기지 않고 성공/실패 처리시 result방식 사용
            return Observable.error(ApiError.nowAllowedUrl)             // 스트림이 끊겨도 상관없으면 error를 보내면 된다
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
        return URLSession.shared.rx.response(request: urlRequest)
        // MARK: - map으로 형태 반환 Result<BaseListResponse<Todo>, ApiError>
            .map { (httpResponse: HTTPURLResponse, data: Data) -> BaseListResponse<Todo> in
                
                // http urlResponse가 아니면 모르는 에러로 던진다
                
                /*
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    return .failure(ApiError.unknownError(nil))
                    // return completion(.failure(ApiError.unknownError(nil)))
                }
                 */
                 
                
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
    }
    
    static func fetchTodosWithObservableData(page: Int = 1) -> Observable<BaseListResponse<Todo>> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "?page=\(page)"
        //return Observable.error(ApiError.nowAllowedUrl)
    

        guard let url = URL(string: urlString) else {
            // return Observable.just(.failure(ApiError.nowAllowedUrl)) // 스트림 끊기지 않고 성공/실패 처리시 result방식 사용
            return Observable.error(ApiError.nowAllowedUrl)             // 스트림이 끊겨도 상관없으면 error를 보내면 된다
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
        return URLSession.shared.rx
            .response(request: urlRequest)
            .debug("Rx 리트라이 --")
        // MARK: - map으로 형태 반환 Result<BaseListResponse<Todo>, ApiError>
            .map { (httpResponse: HTTPURLResponse, data: Data) -> Data in
                
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
                return data
            }.decode(type: BaseListResponse<Todo>.self, decoder: JSONDecoder())
            .map { response in
                guard let todos = response.data, !todos.isEmpty else {
                    throw ApiError.noContentError
                }
                return response
            }
            .catch { error in
                if let error = error as? ApiError {
                    throw error
                }
                
                if error is DecodingError {
                    throw ApiError.decodingError
                }
                
                throw ApiError.unknownError(error)
            }
    }
    
    /// 특정 할 일 가져오기
    /// - Parameters:
    ///   - id: 할일 아이디
    ///   - completion: 응답 결과
    static func fetchATodoWithObservable(id: Int) -> Observable<BaseResponse<Todo>> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "/\(id)"

        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.nowAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (httpResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
    
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
    
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    return baseResponse
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    throw ApiError.decodingError
                }
            }
    }
    
    /// 할 일 검색하기
    /// - Parameters:
    ///   - searchTerm: 검색텍스트
    ///   - page: 페이지
    ///   - completion: 응답 결과
    static func searchTodosWithObservable(searchTerm: String, page: Int = 1) -> Observable<BaseListResponse<Todo>> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let requestUrl = URL(baseUrl: baseURL + "/todos/search", queryItems: ["query": searchTerm, "page": "\(page)"])
        
        guard let url = requestUrl else {
            return Observable.error(ApiError.nowAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (httpResponse: HTTPURLResponse, data: Data) -> BaseListResponse<Todo> in
                
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
                
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                    let todos = listResponse.data
                    
                    // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
                    guard let todos = todos, !todos.isEmpty else {
                        throw ApiError.noContentError
                    }
                    return listResponse
                    
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    throw ApiError.decodingError
                }
            }
    }
    
    /// 할 일 추가하기 - FORM방식
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoWithObservable(title: String, isDone: Bool = false) -> Observable<BaseResponse<Todo>> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos"
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.nowAllowedUrl)
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
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (httpResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
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
                
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    return baseResponse
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    throw ApiError.decodingError
                }
            }
    }
    
    /// 할 일 추가하기 - Json방식
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoJsonWithObservable(title: String, isDone: Bool = false) -> Observable<BaseResponse<Todo>> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos-json"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.nowAllowedUrl)
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
            return Observable.error(ApiError.jsonEncodingError)
            // return completion(.failure(ApiError.jsonEncodingError))
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (httpResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                default:
                    break
                    // print("default")
                }
                
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    return baseResponse
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    throw ApiError.decodingError
                }
            }
            
            
    }
    
    /// 할 일 수정하기 - Json방식
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func editATodoJsonWithObservable(id: Int,
                              title: String,
                              isDone: Bool = false) -> Observable<BaseResponse<Todo>> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.nowAllowedUrl)
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
            return Observable.error(ApiError.jsonEncodingError)
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (httpResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
                
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
                
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    return baseResponse
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    throw ApiError.decodingError
                }
            }
            

    }
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func editATodoPutWithObservable(id: Int,
                              title: String,
                                           isDone: Bool = false) -> Observable<BaseResponse<Todo>> {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.nowAllowedUrl)
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
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (httpResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                default:
                    // print("default")
                    break
                }
                
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                

                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    return baseResponse
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    throw ApiError.decodingError
                }
            }

    }
    
    /// 할 일 삭제하기 - DELETE
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - completion: 응답 결과
    static func deleteATodoWithObservable(id: Int) -> Observable<BaseResponse<Todo>> {
        
        print(#fileID, #function, #line, "- deleteATodo 호출됨 / id: \(id)")
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.nowAllowedUrl)
        }
        
        // header
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (httpResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo>in
                switch httpResponse.statusCode {
                case 401:
                    // 인증이 되어있지않다면 에러를 던진다
                    throw ApiError.unAuthorized
                case 204:
                    // 내용이 없다면 에러를 던진다
                    throw ApiError.noContentError
                default:
                    // print("default")
                    break
                }
                
                // 상태코드가 200번대가 아니면 에러를 던진다
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    return baseResponse
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    throw ApiError.decodingError
                }
            }
    }
    
    
    
    
    

    
    
    // MARK: - 클로저 기반 api 연쇄 처리
    /// 할 일 추가 -> 모든 할 일 가져오기
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoAndFetchTodosWithObservable_1(title: String,
                                                    isDone: Bool = false) -> Observable<BaseListResponse<Todo>> {
        // 1
        return self.addATodoWithObservable(title: title)
            // 첫번째 호출했던 API 응답 결과
            // 에러는 throw를 통해 던져지기 때문에 구독하는 쪽에서 처리하면됨
            .flatMapLatest { _ in
                self.fetchTodosWithObservable()
            }
            // [참고] share를 통해 구독에 대한 상태를 공유 가능 -> 안하면 구독을 할떄마다 이거를 탄다
            .share(replay: 1)
    }
    
    // MARK: - 클로저 기반 api 연쇄 처리
    /// 할 일 추가 -> 모든 할 일 가져오기
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoAndFetchTodosWithObservable_2(title: String,
                                                    isDone: Bool = false) -> Observable<[Todo]> {
        // 1
        return self.addATodoWithObservable(title: title)
            // 첫번째 호출했던 API 응답 결과
            // 에러는 throw를 통해 던져지기 때문에 구독하는 쪽에서 처리하면됨
            .flatMapLatest { _ in
                self.fetchTodosWithObservable()
            } // BaseListResponse<Todo>
        
            .compactMap { $0.data } // Optional([Todo]) -> [Todo]
            .catch({ err in
                // 에러가 들어온다면 빈 리스트를 보낸다
                print("TodosAPI - catch : err: \(err)")
                return Observable.just([])
            })
            // [참고] share를 통해 구독에 대한 상태를 공유 가능 -> 안하면 구독을 할떄마다 이거를 탄다
            .share(replay: 1)
    }
    
    
    
    
    
    
    
    
    // MARK: - Zip 방식
    // MARK: - 클로저 기반 api 동시 처리 -> 존재하지 않는 게시글은 에러를 던지는게 아니라 nil로 필터링 가능
    /// 선택된 할일들 삭제하기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSelectedTodosWithObservable(selectedTodoIds: [Int]) -> Observable<[Int]> {
        
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
    
    // MARK: - Merge방식은 배열이 아닌 단일아이템 하나가 들어온다
    /// 선택된 할일들 삭제하기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSelectedTodosWithObservableMerge(selectedTodoIds: [Int]) -> Observable<Int> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열로 만들기
        // 2. 배열로 단일 api를 호출
        let apiCallObservables = selectedTodoIds.map { id -> Observable<Int?> in
            return self.deleteATodoWithObservable(id: id)
                .map { $0.data?.id } // 현재 들어오는 Todo 데이터의 data.id를 Int?로 형태를 바꿈
                .catchAndReturn(nil)
        }
        // 하나의 스트림으로 만들기
        return Observable.merge(apiCallObservables).compactMap { $0 }
    }
    
    // MARK: - 클로저 기반 api 동시 처리
    /// 선택된 할일들 가져오기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디들
    ///   - completion: 응답 결과
    static func fetchSelectedTodosWithObservable(selectedTodoIds: [Int]) -> Observable<[Todo]> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열로 만들기
        // 2. 배열로 단일 api를 호출
        let apiCallObservables = selectedTodoIds.map { id -> Observable<Todo?> in
            return self.fetchATodoWithObservable(id: id)
                .map { $0.data } // Todo?
                .catchAndReturn(nil)
        }
        
        return Observable.zip(apiCallObservables)
            .map {  // Observable<[Todo?]>
                $0.compactMap { $0 } // Todo
            }   // Observable<[Todo]
    }
    
    // MARK: - 클로저 기반 api 동시 처리
    /// 선택된 할일들 가져오기 - Merge -> 여러 묶은게 동시 호출되긴 하지만 결과들이 하나 하나 하나가 들어온다
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디들
    ///   - completion: 응답 결과
    static func fetchSelectedTodosWithObservableMerge(selectedTodoIds: [Int]) -> Observable<Todo> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열로 만들기
        // 2. 배열로 단일 api를 호출
        let apiCallObservables = selectedTodoIds.map { id -> Observable<Todo?> in
            return self.fetchATodoWithObservable(id: id)
                .map { $0.data } // Todo?
                .catchAndReturn(nil)
        }
        
        return Observable.merge(apiCallObservables)
            .compactMap { $0 }
    }
}

// MARK: - Rx -> Async
extension TodosAPI {
    static func fetchTodosWithObservableToAsync(page: Int = 1) async throws -> BaseListResponse<Todo> {
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<BaseListResponse<Todo>, Error>) in
            var disposable: Disposable? = nil
            disposable = fetchTodosWithObservable(page: page)
                .subscribe(onNext: { response in
                    continuation.resume(returning: response)
                }, onError: { error in
                    continuation.resume(throwing: error)
                }, onCompleted: { // 스트림 종료시
                    disposable?.dispose()
                }, onDisposed: { // 완전히 날아갔을 때
                    print("onDisposed")
                })
        }
    }
}

extension ObservableType {
    func toAsync() async throws -> Element {
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Element, Error>) in
            var disposable: Disposable? = nil
            
            // 처음 들어오는 이벤트를 받는다
            disposable = single()
                .subscribe(onNext: { response in
                    continuation.resume(returning: response)
                }, onError: { error in
                    continuation.resume(throwing: error)
                }, onCompleted: { // 스트림 종료시
                    disposable?.dispose()
                }, onDisposed: { // 완전히 날아갔을 때
                    print("onDisposed")
                })
        }
    }
}

extension TodosAPI {
    
    /*
     기존에는 RXObservable로 처리할떄는 물줄기만 변경하는 방식이었다
     Observable -> Async 변경은 한번 구독을 하고 구독 결과에 따라서 Async로 이벤트륿 반환한다
     */
    static func fetchTodoWithObservableToAsync(page: Int = 1) async throws -> BaseListResponse<Todo> {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<BaseListResponse<Todo>, Error>) in
            var disposable: Disposable? = nil
            disposable = fetchTodosWithObservable(page: page)
                .subscribe(onNext: { response in
                    print("onNext: \(response)")
                    continuation.resume(returning: response)
                }, onError: { error in
                    print("onError: \(error)")
                    continuation.resume(throwing: error)
                }, onCompleted: {
                    print("onCompleted: 스트림 끊김 종료")
                    disposable?.dispose()
                }, onDisposed: {
                    print("onDisposed: 완전히 제거")
                })
        }
    }
}

// MARK: - 리트라이 제네릭
extension ObservableType {
    
    // 횟수, 딜레이
    func retryWithDelayAndCondition1(
        retryCount: Int = 1,
        delay: Int = 1,
        when: @escaping (Error) -> Bool     // 에러 종류에 따라 언제 리트라이를 하면 되는지
        
        /*
         @escaping 필요한 이유:
         클로저 when은 이 함수 안에서 즉시 실행되지 않고,
         RxSwift의 .flatMap 블록 안에서 나중에 호출되기 때문입니다.
         */
    ) -> Observable<Element> {
        
        // 디버깅 출력용
        var requestCount: Int = 0
        return
            self.retry(when: { (observableError: Observable<TodosAPI.ApiError>) in //
                observableError.do { error in
                    print("observableError --: \(error)")
                }
                // 분기처리 가능해짐
                // retry는 성공이되거나 에러를 던지게 되면 종료가 된다
                .flatMap { error in
                    
                    // true가 아니라면 에러를 던진다 = 리트라이 멈춘다
                    if !when(error) {
                        throw error
                    }
                    
                    requestCount+=1
                    
                    /*
                    // 에러 -> bool 여부 클로저 만들자
                    if case TodosAPI.ApiError.noContentError = error {
                        return Observable<Void>.just(())
                            .delay(.seconds(delay), scheduler: MainScheduler.instance)
                    }
                     */
                    return Observable<Void>.just(())
                        .delay(.seconds(delay), scheduler: MainScheduler.instance)

                }
                .take(retryCount)
            })
    }
    
    func retryWithDelayAndCondition(
        retryCount: Int = 1,
        delay: Int = 1,
        // MARK: - 클로저를 옵셔널로 감싸려면 괄호를씌어주고?  ()? = nil
        when: ((Error) -> Bool)?  = nil   // 에러 종류에 따라 언제 리트라이를 하면 되는지
        
        /*
         @escaping 필요한 이유:
         클로저 when은 이 함수 안에서 즉시 실행되지 않고,
         RxSwift의 .flatMap 블록 안에서 나중에 호출되기 때문입니다.
         */
    ) -> Observable<Element> {
        
        // 디버깅 출력용
        var requestCount: Int = 0
        return
            self.retry(when: { (observableError: Observable<TodosAPI.ApiError>) in //
                observableError.do { error in
                    print("observableError --: \(error)")
                }
                // 분기처리 가능해짐
                // retry는 성공이되거나 에러를 던지게 되면 종료가 된다
                .flatMap { error in
                    
                    // true가 아니라면 에러를 던진다 = 리트라이 멈춘다
                    
                    // MARK: - 클로저가 nil이면 true를 반환하겠다
                    if !(when?(error) ?? true)  {
                        throw error
                    }
                    
                    requestCount+=1
                    
                    /*
                    // 에러 -> bool 여부 클로저 만들자
                    if case TodosAPI.ApiError.noContentError = error {
                        return Observable<Void>.just(())
                            .delay(.seconds(delay), scheduler: MainScheduler.instance)
                    }
                     */
                    return Observable<Void>.just(())
                        .delay(.seconds(delay), scheduler: MainScheduler.instance)

                }
                .take(retryCount)
            })
    }
    
    func retryWithDelayAndConditionCatch(
        retryCount: Int = 1,
        delay: Int = 1,
        // MARK: - 클로저를 옵셔널로 감싸려면 괄호를씌어주고?  ()? = nil
        when: ((Error) -> Bool)?  = nil   // 에러 종류에 따라 언제 리트라이를 하면 되는지
        
    ) -> Observable<Element> {
        
        // 디버깅 출력용
        var requestCount: Int = 0
        
        return self.catch { error -> Observable<Element> in
            
            // MARK: - 클로저가 nil이면 true를 반환하겠다
            // 에러를 받아서 로직 처리를해서 리트라이여부가 false이면 에러를 던져서 종료됨.
            if !(when?(error) ?? true)  {
                throw error
            }
            
            return Observable<Void>
                .just(())
                .delay(.seconds(delay), scheduler: MainScheduler.instance )
                .flatMap { _ in // Void라 사용하지 않을 것
                    requestCount+=1
                    print("requestCount --: \(requestCount)")
                    return self
                }
                .retry(retryCount)
        }
    }
}
