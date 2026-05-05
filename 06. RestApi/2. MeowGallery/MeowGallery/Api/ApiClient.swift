//
//  ApiClient.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import Foundation
import Alamofire

final class ApiClient {
    static let shared = ApiClient()
    static let BASE_URL = Bundle.main.infoDictionary?["BASE_URL"] as! String
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    let monitors = [ApiLogger()] as [EventMonitor]
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
