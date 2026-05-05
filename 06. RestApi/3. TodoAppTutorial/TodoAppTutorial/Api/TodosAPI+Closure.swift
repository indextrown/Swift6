//
//  TodosAPI+Closure.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/26/25.
//

import Foundation
import MultipartForm
import RxSwift
import Combine

extension TodosAPI {
    // 데이터를 가져와서 응답에 대한 결과를 함수 밖으로 꺼내줘야한다 즉 비동기 처리가 이루어져야하는데 이떄 클로저를 사용한다 completion 블럭을 사용한다
    // dataTask 자체도 클로저이므로 클로저 안에서 클로저가 탈출이 일어나야한다
    // API 요청의 결과는 성공일수도 실패일수도 있어서 Result<>를 이용해 성공시 TodosResponse만 밖으로 내보내고 에러라면 Error를 내보내자

    /// 모든 할 일 목록 가져오기
    /// - Parameters:
    ///   - page: 페이지
    ///   - completion: 응답 결과
    static func fetchTodos(page: Int = 1,
                           completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void) {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "?page=\(page)"
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        
        
        // 2. urlSession으로 API를 호출한다
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            // print("dat a: \(String(describing: data))")
            // print("urlResponse: \(String(describing: urlResponse))")
            // print("error: \(String(describing: error))")
            
            // 에러가 있다면 에러를 던진다
            if let error = error {
                return completion(.failure(ApiError.unknownError(error)))
            }

            // http urlResponse가 아니면 모르는 에러로 던진다
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknownError(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                // 인증이 되어있지않다면 에러를 던진다
                return completion(.failure(ApiError.unAuthorized))
            default:
                print("default")
            }
            
            // 상태코드가 200번대가 아니면 에러를 던진다
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: jsonData)
                    let todos = listResponse.data
                    
                    // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
                    guard let todos = todos, !todos.isEmpty else {
                        return completion(.failure(ApiError.noContentError))
                    }
                    
                    completion(.success(listResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
        
        // 3. API 호출에 대한 응답을 받는다
    }
    
    /// 특정 할 일 가져오기
    /// - Parameters:
    ///   - id: 할일 아이디
    ///   - completion: 응답 결과
    static func fetchATodo(id: Int,
                            completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos" + "/\(id)"
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            // print("dat a: \(String(describing: data))")
            // print("urlResponse: \(String(describing: urlResponse))")
            // print("error: \(String(describing: error))")
            
            // 에러가 있다면 에러를 던진다
            if let error = error {
                return completion(.failure(ApiError.unknownError(error)))
            }
            
            // http urlResponse가 아니면 모르는 에러로 던진다
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknownError(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                // 인증이 되어있지않다면 에러를 던진다
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                // 내용이 없다면 에러를 던진다
                return completion(.failure(ApiError.noContentError))
            default:
                print("default")
            }
            
            // 상태코드가 200번대가 아니면 에러를 던진다
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
        
        // 3. API 호출에 대한 응답을 받는다
    }
    
    /// 할 일 검색하기
    /// - Parameters:
    ///   - searchTerm: 검색텍스트
    ///   - page: 페이지
    ///   - completion: 응답 결과
    static func searchTodos(searchTerm: String,
                            page: Int = 1, completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void) {
        
        // 1. urlRequest를 만든다   ?: quary string
        // MARK: - 이렇게 쿼리를 직접 적으면 실수를 유발할 수 있어서 urlComponent를 사용한다
        // let urlString = baseURL + "/todos/search" + "?page=\(page)" + "&query=\(searchTerm)"
        // var urlComponents = URLComponents(string: baseURL + "/todos/search")!
        
        let requestUrl = URL(baseUrl: baseURL + "/todos/search", queryItems: ["query": searchTerm, "page": "\(page)"])
        
        guard let url = requestUrl else {
            return completion(.failure(.nowAllowedUrl))
        }
        
//        var urlComponents = URLComponents(string: baseURL + "/todos/search")
//        urlComponents?.queryItems = [
//            URLQueryItem(name: "query", value: searchTerm),
//            URLQueryItem(name: "page", value: "\(page)")
//        ]
//
//        guard let url = urlComponents?.url else {
//            return completion(.failure(.nowAllowedUrl))
//        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러를 던진다
            if let error = error {
                return completion(.failure(ApiError.unknownError(error)))
            }
            
            // http urlResponse가 아니면 모르는 에러로 던진다
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknownError(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                // 인증이 되어있지않다면 에러를 던진다
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                // 내용이 없다면 에러를 던진다
                return completion(.failure(ApiError.noContentError))
            default:
                print("default")
            }
            
            // 상태코드가 200번대가 아니면 에러를 던진다
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: jsonData)
                    let todos = listResponse.data
                    
                    // 상태코드는 200인데 파싱한 데이터에 따라서 달라지는 에러처리 -> 내용이 비어있다면 에러를 던진다
                    guard let todos = todos, !todos.isEmpty else {
                        return completion(.failure(ApiError.noContentError))
                    }
                    
                    completion(.success(listResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    /// 할 일 추가하기 - FORM방식
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodo(title: String,
                         isDone: Bool = false,
                         completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.nowAllowedUrl))
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
        print("form: \(form.contentType)")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러를 던진다
            if let error = error {
                return completion(.failure(ApiError.unknownError(error)))
            }
            
            // http urlResponse가 아니면 모르는 에러로 던진다
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknownError(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                // 인증이 되어있지않다면 에러를 던진다
                return completion(.failure(ApiError.unAuthorized))
            case 422:
                if let data = data,
                   let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    return completion(.failure(ApiError.errorResponseFromServer(errorResponse)))
                }
            case 204:
                // 내용이 없다면 에러를 던진다
                return completion(.failure(ApiError.noContentError))
            default:
                print("default")
            }
            
            // 상태코드가 200번대가 아니면 에러를 던진다
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
        
       
    }
    
    /// 할 일 추가하기 - Json방식
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoJson(title: String,
                         isDone: Bool = false,
                         completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos-json"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.nowAllowedUrl))
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
            return completion(.failure(ApiError.jsonEncodingError))
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러를 던진다
            if let error = error {
                return completion(.failure(ApiError.unknownError(error)))
            }
            
            // http urlResponse가 아니면 모르는 에러로 던진다
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknownError(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                // 인증이 되어있지않다면 에러를 던진다
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                // 내용이 없다면 에러를 던진다
                return completion(.failure(ApiError.noContentError))
            default:
                print("default")
            }
            
            // 상태코드가 200번대가 아니면 에러를 던진다
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    /// 할 일 수정하기 - Json방식
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func editATodoJson(id: Int,
                              title: String,
                              isDone: Bool = false,
                              completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.nowAllowedUrl))
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
            return completion(.failure(ApiError.jsonEncodingError))
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러를 던진다
            if let error = error {
                return completion(.failure(ApiError.unknownError(error)))
            }
            
            // http urlResponse가 아니면 모르는 에러로 던진다
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknownError(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                // 인증이 되어있지않다면 에러를 던진다
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                // 내용이 없다면 에러를 던진다
                return completion(.failure(ApiError.noContentError))
            default:
                print("default")
            }
            
            // 상태코드가 200번대가 아니면 에러를 던진다
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func editATodoPut(id: Int,
                              title: String,
                              isDone: Bool = false,
                              completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.nowAllowedUrl))
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
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러를 던진다
            if let error = error {
                return completion(.failure(ApiError.unknownError(error)))
            }
            
            // http urlResponse가 아니면 모르는 에러로 던진다
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknownError(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                // 인증이 되어있지않다면 에러를 던진다
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                // 내용이 없다면 에러를 던진다
                return completion(.failure(ApiError.noContentError))
            default:
                // print("default")
                break
            }
            
            // 상태코드가 200번대가 아니면 에러를 던진다
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    /// 할 일 삭제하기 - DELETE
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - completion: 응답 결과
    static func deleteATodo(id: Int,
                              completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        print(#fileID, #function, #line, "- deleteATodo 호출됨 / id: \(id)")
        // 1. urlRequest를 만든다   ?: quary string
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.nowAllowedUrl))
        }
        
        // header
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러를 던진다
            if let error = error {
                return completion(.failure(ApiError.unknownError(error)))
            }
            
            // http urlResponse가 아니면 모르는 에러로 던진다
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknownError(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                // 인증이 되어있지않다면 에러를 던진다
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                // 내용이 없다면 에러를 던진다
                return completion(.failure(ApiError.noContentError))
            default:
                // print("default")
                break
            }
            
            // 상태코드가 200번대가 아니면 에러를 던진다
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // json -> Struct로 변경 즉 디코딩 즉 데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch {
                    // decoding error : JSON -> 우리가 사용하는 데이터 모델 class,struct
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    // MARK: - 클로저 기반 api 연쇄 처리
    /// 할 일 추가 -> 모든 할 일 가져오기
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoAndFetchTodos(title: String,
                                      isDone: Bool = false,
                                      completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void) {
        
        // 1
        self.addATodo(title: title) { result in // 여긴 왜 weak self안하는가? 공부하자
            switch result {
                // 1-1
            case .success(_):
                // 2
                self.fetchTodos {
                    switch $0 {
                        // 2-1
                    case .success(let data):
                        completion(.success(data))
                        // 2-2
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                }
                // 1-2
            case .failure(let failure):
                completion(.failure(failure)) // addATodo 에러
            }
        }
    }
    
    // MARK: - 클로저 기반 api 동시 처리
    /// 선택된 할일들 삭제하기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSelectedTodos(selectedTodoIds: [Int],
                                    completion: @escaping ([Int]) -> Void) {
        
        // 디스패치 그룹에 넣음
        let group = DispatchGroup()
        
        // 성공적으로 삭제가 이뤄진 아이디 배열
        var deletedTodoIds: [Int] = []
        
        selectedTodoIds.forEach { aTodoId in
            group.enter()
            self.deleteATodo(id: aTodoId) { result in
                switch result {
                case .success(let response):
                    // 삭제된 아이디를 삭제된 아이디 배열에 넣는다
                    if let todoId = response.data?.id {
                        deletedTodoIds.append(todoId)
                        print("inner deleteATodo - success - \(todoId)")
                    }
                case .failure(let failure):
                    print("inner deleteATodo - failure - \(failure)")
                }
                group.leave()
            } // 단일 삭제 API 호출
        }
        
        // Configure a completion callback
        group.notify(queue: .main) {
            // All requests completed
            print("모든 api 완료 됨")
            completion(deletedTodoIds)
        }
    }
    
    // MARK: - 클로저 기반 api 동시 처리
    /// 선택된 할일들 가져오기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디들
    ///   - completion: 응답 결과
    static func fetchSelectedTodos(selectedTodoIds: [Int],
                                    completion: @escaping (Result<[Todo], ApiError>) -> Void) {
        
        // 디스패치 그룹에 넣음
        let group = DispatchGroup()
        
        // 가져온 할일들
        var fetchedTodos: [Todo] = []
        
        // 에러들
        var apiErrors: [ApiError] = []
        
        // 응답 결과들
        // var apiResult: [Int: Result<BaseResponse<Todo>, ApiError>] = [:]
        
        selectedTodoIds.forEach { aTodoId in
            group.enter()
            self.fetchATodo(id: aTodoId) { result in
                switch result {
                case .success(let response):
                    // 가져온 할일을 가져온 할일 배열에 넣는다
                    if let todo = response.data {
                        fetchedTodos.append(todo)
                        print("inner fetchATodo - success - \(todo)")
                    }
                case .failure(let failure):
                    apiErrors.append(failure)
                    print("inner fetchATodo - failure - \(failure)")
                }
                group.leave()
            } // 단일 할일 조회 API 호출
        }
        
        // Configure a completion callback
        group.notify(queue: .main) {
            // All requests completed
            print("모든 api 완료 됨")
            
            // 만약 에러가 있으면 첫번째 에러를 이벤트로 태워준다
            if !apiErrors.isEmpty {
                if let firstError = apiErrors.first {
                    completion(.failure(firstError))
                    return
                }
            }
            
            completion(.success(fetchedTodos))
        }
    }
}

// MARK: - Closure to Async
extension TodosAPI {
    // 에러처리 x -> Result
    // MARK: - Closure -> Async
    static func fetchTodosClosureToAsync(page: Int = 1) async -> Result<BaseListResponse<Todo>, ApiError> {
        return await withCheckedContinuation { (continuation: CheckedContinuation<Result<BaseListResponse<Todo>, ApiError>, Never>) in
            // 클로저 함수 호출
            fetchTodos(page: page) { (result: Result<BaseListResponse<Todo>, ApiError>)in
                /// resume읋 한다 = continuation이라는 블럭을 나가면서 Result<BaseListResponse<Todo>, ApiError> 값이 async로 나간다
                continuation.resume(returning: result)
            }
        }
    }
    
    // 에러처리 x -> [Todo] - 에러가 나도 빈 배열을 리턴
    // MARK: - Closure -> Async
    static func fetchTodosClosureToAsyncReturnArray(page: Int = 1) async -> [Todo] {
        return await withCheckedContinuation { (continuation: CheckedContinuation<[Todo], Never>) in
            // 클로저 함수 호출
            fetchTodos(page: page) { (result: Result<BaseListResponse<Todo>, ApiError>)in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success.data ?? [])
                case .failure:
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    // 에러처리 O
    // MARK: - Closure -> Async
    static func fetchTodosClosureToAsyncWithError(page: Int = 1) async throws -> BaseListResponse<Todo> {
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<BaseListResponse<Todo>, Error>) in
            
            fetchTodos(page: page) { (result: Result<BaseListResponse<Todo>, ApiError>) in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    // 에러처리 O - 커스텀 에러로 형태 변경 
    // MARK: - Closure -> Async
    static func fetchTodosClosureToAsyncWithMapError(page: Int = 1) async throws -> BaseListResponse<Todo> {
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<BaseListResponse<Todo>, Error>) in
            
            fetchTodos(page: page) { (result: Result<BaseListResponse<Todo>, ApiError>) in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    // failure가 enum ApiError의 .unknownError(Error) 케이스일 때
                    // 그 안에 담긴 underlyingError가 실제로 DecodingError 타입일 경우 ApiError.decodingError를 던짐
                    if case let .unknownError(underlyingError) = failure,
                       underlyingError is DecodingError {
                        continuation.resume(throwing: ApiError.decodingError)
                    } else {
                        continuation.resume(throwing: failure)
                    }
                    // 그 외의 에러는 그냥 그대로 던짐
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    // 에러처리 x, 에러가 나도 nil 리턴
    // MARK: - Closure -> Async
    static func fetchATodoClosureToAsyncNoError(id: Int) async -> BaseResponse<Todo>? {
        return await withCheckedContinuation { (continuation: CheckedContinuation<BaseResponse<Todo>?, Never>) in
            fetchATodo(id: id) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure:
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    // 에러처리 O
    // MARK: - Closure -> Async
    static func fetchATodoClosureToAsync(id: Int) async throws -> BaseResponse<Todo> {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<BaseResponse<Todo>, Error>) in
            fetchATodo(id: id) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    // 에러처리 O - 커스텀 에러로 형태 변경
    // MARK: - Closure -> Async
    static func fetchATodoClosureToAsyncMapError(id: Int) async throws -> BaseResponse<Todo> {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<BaseResponse<Todo>, Error>) in
            fetchATodo(id: id) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    if case let .unknownError(underlyingError) = failure,
                       underlyingError is DecodingError {
                        continuation.resume(throwing: ApiError.decodingError)
                    } else {
                        continuation.resume(throwing: failure)
                    }
                    // 그 외의 에러는 그냥 그대로 던짐
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
}

// MARK: - Closure to Rx
extension TodosAPI {
    // 에러처리 x -> Result
    // MARK: - Closure -> Rx
    static func fetchTodosClosureToObservable(page: Int = 1) -> Observable<Result<BaseListResponse<Todo>, ApiError>> {
        return Observable.create { (observer: AnyObserver<Result<BaseListResponse<Todo>, ApiError>>) in
            fetchTodos(page: page) { result in
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    // 에러처리 x -> [] - 에러시 빈배열
    // MARK: - Closure -> Rx
    static func fetchTodosClosureToObservableDataArray(page: Int = 1) -> Observable<[Todo]> {
        return Observable.create { (observer: AnyObserver<BaseListResponse<Todo>>) in
            fetchTodos(page: page) { result in
                switch result {
                case .success(let success):
                    observer.onNext(success)
                    observer.onCompleted()
                case .failure(let failure):
                    observer.onError(failure)// 이걸로도 가능하고 반응형 기반으로 물줄기 방식으로 catch로 변경도 가능하다
                }
            }
            return Disposables.create()
        }
        .map { $0.data ?? [] }
        .catch { err in
            return Observable.just([])
        }
        // catch대신 써도 됨
        // .catchAndReturn([])
    }
    
    // 에러처리 O
    // MARK: - Closure -> Rx
    static func fetchTodosClosureToObservableWithError(page: Int = 1) -> Observable<BaseListResponse<Todo>> {
        return Observable.create { (observer: AnyObserver<BaseListResponse<Todo>>) in
            fetchTodos(page: page) { result in
                switch result {
                case .success(let success):
                    observer.onNext(success)
                    observer.onCompleted()
                case .failure(let failure):
                    observer.onError(failure)
                }
            }
            return Disposables.create()
        }
    }
    
    // 에러처리 O - 커스텀 에러로(Map) 형태 변경
    // MARK: - Closure -> Rx
    static func fetchTodosClosureToObservableWithMapError(page: Int = 1) -> Observable<BaseListResponse<Todo>> {
        return Observable.create { (observer: AnyObserver<BaseListResponse<Todo>>) in
            fetchTodos(page: page) { result in
                switch result {
                case .success(let success):
                    observer.onNext(success)
                    observer.onCompleted()
                case .failure(let failure):
                    observer.onError(failure)// 이걸로도 가능하고 반응형 기반으로 물줄기 방식으로 catch로 변경도 가능하다
                }
            }
            return Disposables.create()
        }
        // rx는 stream = 물줄기 이기 떄문에 여기 중간에서 에러를 잡을 수 있다.
        /*
         에러를 변경할 때 switch 내에서 변경해도 되지만 리액티브 스트림을 사용하기 때문에 catch를 통해 에러의 형태를 변경할 수 있다
         에러시 데이터의 형태를 변경하고 싶으면 map, just or catchAndReturn활용하자
         */
        .catch { failure in
            if let _ = failure as? ApiError {
                throw ApiError.unAuthorized
            }
            
            throw failure
        }
    }
    
    // 에러처리 x -> Result
    // MARK: - Closure -> Rx
    static func fetchATodoClosureToObservableNoError(id: Int) -> Observable<Todo> {
        return Observable.create { (observer: AnyObserver<BaseResponse<Todo>>) in
            fetchATodo(id: id) { result in
                switch result {
                case .success(let result):
                    observer.onNext(result)
                    observer.onCompleted()
                case .failure(let failure):
                    observer.onError(failure)
                }
            }
            return Disposables.create()
        }
        .compactMap { response in
            guard let todo = response.data else {
                throw ApiError.noContentError
            }
            return todo
        }
    }
    
}

// MARK: - Closure -> Publisher
extension TodosAPI {
    // 에러처리 x -> []
    // MARK: - Closure -> Publisher 1
    static func fetchTodosClosureToPublisherNoError(page: Int = 1) -> AnyPublisher<[Todo], Never> {
        return Future { (promise: @escaping (Result<[Todo], Never>) -> Void) in
            fetchTodos(page: 1) { result in
                switch result {
                case .success(let data):
                    promise(.success(data.data ?? []))
                case .failure:
                    promise(.success([]))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // 에러처리 x -> []
    // MARK: - Closure -> Publisher 2
    static func fetchTodosClosureToPublisherNoError2 (page: Int = 1) -> AnyPublisher<[Todo], Never> {
        return Future { (promise: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void) in
            fetchTodos(page: page ) { result in
                // MARK: - 우리는 reactive개발하기 떄문에 여기 switch에서 가공할 필요가 없다.
                /*
                switch result {
                case .success(let data):
                    promise(.success(data.data ?? []))
                case .failure:
                    promise(.success([]))
                }
                 */
                promise(result)
            }
        }
        .map { $0.data ?? [] }
        .catch { error in
            return Just([])
        }
        //.replaceError(with: [])
        .eraseToAnyPublisher()
    }
    
    // 에러처리 O
    // MARK: - Closure -> Publisher
    static func fetchTodosClosureToPublisher(page: Int = 1) -> AnyPublisher<BaseListResponse<Todo>, ApiError> {
        return Future { (promise: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void) in
            fetchTodos(page: 1) { result in
                // 2번 방식
                promise(result)
                
                /*
                 // 1번 방식
                switch result {
                case .success(let success):
                    promise(.success(success))
                case .failure(let failure):
                    promise(.failure(failure))
                }
                */
            }
        }.eraseToAnyPublisher()
    }
    
    // 에러처리 O - 에러 형태 변경
    // MARK: - Closure -> Publisher
    static func fetchTodosClosureToPublisherMapError(page: Int = 1) -> AnyPublisher<BaseListResponse<Todo>, ApiError> {
        return Future { (promise: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void) in
            fetchTodos(page: 1) { result in
                // 2번 방식
                promise(result)
                    
            }
        }
        .mapError { error in
            /*
            if let urlError = error as? ApiError {
                return ApiError.unAuthorized
            }
             */
             
            
            return error
        }
        .eraseToAnyPublisher()
    }
    
    // 에러처리 x -> nil
    // MARK: - Closure -> Publisher
    static func fetchATodoClosureToPublisher(id: Int) -> AnyPublisher<Todo?, Never> {
        return Future { promise in
            /*
            fetchATodo(id: id) { result in
                promise(result)
            }
             */
            fetchATodo(id: id, completion: { promise($0) })
        }
        .map { $0.data }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
}
