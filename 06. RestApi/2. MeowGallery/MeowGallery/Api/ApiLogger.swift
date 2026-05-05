//
//  ApiLogger.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import Foundation
import Alamofire

final class ApiLogger: EventMonitor {
    let queue = DispatchQueue(label: "Meow_Gallery")
    
    // Event called when any type of Request is resumed.
    func requestDidResume(_ request: Request) {
        // print("ApiLogger - Resuming: \(request)")
    }
    
    // Event called whenever a DataRequest has parsed a response.
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        // debugPrint("ApiLogger - Finished: \(response)")
    }
}
