//
//  LogView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/5/25.
//

/*
 https://stackoverflow.com/questions/40583721/print-to-console-log-with-color
 https://minsone.github.io/swift-unified-logging-system-and-macro
 https://zeddios.tistory.com/979
 */
import SwiftUI
import UIKit
//import os.log
import OSLog

struct LogView: View {
    var body: some View {
        VStack {
            
        }
        .onAppear {
       
            // Source - https://stackoverflow.com/questions/40583721/print-to-console-log-with-color
            // Posted by Mojtaba Hosseini
            // Retrieved 2025. 11. 5., License - CC-BY-SA 4.0

//            let logger = Logger(
//                subsystem: "StackOverflow",
//                category: "Answer"
//            )
//
//            logger.log("Log")
//            logger.trace("Trace")
//            logger.debug("Debug")
//            logger.info("Info")
//            logger.notice("Notice")
//            logger.warning("Warning")
//            logger.error("Error")
//            logger.critical("Critical")
//            logger.fault("Fault")
//            
//            
//            logger.warning("⚠️ warning message")
//            logger.fault("🛑 Fault")
//            print(#fileID, #function, #line, "- ")
        
                
//            struct WeapperLogger {
//                func debug(msg: String) {
//                    let logger = Logger(subsystem: "kr.minsone.feature.logger",
//                                        category: "debug")
//                    logger.log(level: .debug, "\(msg)")
//                }
//            }
//            
//            let logger = WeapperLogger()
//            logger.debug(msg: "Hello WOrld")
            
            // 일반 로그
//            Logger.d(message: "네트워크 요청 성공!")
//
//            // 경고 로그
//            Logger.w(message: "서버 응답이 느립니다.")
//
//            // 에러 로그
//            Logger.e(message: "데이터 파싱 실패")
            
            Logger.d("네트워크 요청 성공!")

            // 경고 로그
            Logger.w("서버 응답이 느립니다.")

            // 에러 로그
            Logger.e("데이터 파싱 실패")

            
        }
    }
}

#Preview {
    LogView()
}


//
//
//// Source - https://stackoverflow.com/questions/40583721/print-to-console-log-with-color
//// Posted by Reimond Hill
//// Retrieved 2025. 11. 5., License - CC-BY-SA 4.0
//
//struct Logger {
//    /// Type of logs available
//    enum LogType: String {
//        /// To log a message
//        case debug
//        /// To log a warning
//        case warning
//        /// To log an error
//        case error
//    }
//    
//    /// Logs a debug message
//    /// - Parameter message: Message to log
//    /// - Parameter file: File that calls the function
//    /// - Parameter line: Line of code from the file where the function is call
//    /// - Parameter function: Function that calls the functon
//    /// - Returns: The optional message that was logged
//    @discardableResult
//    static func d(message: String, file: String = #file, line: Int = #line, function: String = #function) -> String{
//        return log(type: .debug, message: message, file: file, line: line, function: function)
//    }
//    
//    /// Logs a warning message
//    /// - Parameter message: Message to log
//    /// - Parameter file: File that calls the function
//    /// - Parameter line: Line of code from the file where the function is call
//    /// - Parameter function: Function that calls the functon
//    /// - Returns: The optional message that was logged
//    @discardableResult
//    static func w(message: String, file: String = #file, line: Int = #line, function: String = #function) -> String{
//        return log(type: .warning, message: message, file: file, line: line, function: function)
//    }
//    
//    /// Logs an error message
//    /// - Parameter message: Message to log
//    /// - Parameter file: File that calls the function
//    /// - Parameter line: Line of code from the file where the function is call
//    /// - Parameter function: Function that calls the functon
//    /// - Returns: The optional message that was logged
//    @discardableResult
//    static func e(message: String, file: String = #file, line: Int = #line, function: String = #function) -> String{
//        return log(type: .error, message: message, file: file, line: line, function: function)
//    }
//    
//    /// Logs an message
//    /// - Parameter logType: Type of message to log
//    /// - Parameter message: Message to log
//    /// - Parameter file: File that calls the function
//    /// - Parameter line: Line of code from the file where the function is call
//    /// - Parameter function: Function that calls the functon
//    /// - Returns: The optional message that was logged
//    @discardableResult
//    static func log(type logType: LogType = .debug, message: String, file: String = #file, line: Int = #line, function: String = #function) -> String{
//        var logMessage = ""
//        
//        switch logType{
//        case .debug:
//            logMessage += "🟢"
//        case .warning:
//            logMessage += "🟡"
//        case .error:
//            logMessage += "🔴"
//        }
//        
//        let fileName = file.components(separatedBy: "/").last ?? ""
//        logMessage += " \(fileName) -> LINE: \(line) -> \(function) => \(message)"
//        
//        print(logMessage)
//        return logMessage
//    }
//
//}


struct Logger {
    enum LogType: String {
        case debug = "DEBUG"
        case warning = "WARNING"
        case error = "ERROR"
    }

    @discardableResult
    static func d(_ message: String,
                  file: String = #file,
                  line: Int = #line,
                  function: String = #function) -> String {
        return log(type: .debug, message: message, file: file, line: line, function: function)
    }

    @discardableResult
    static func w(_ message: String,
                  file: String = #file,
                  line: Int = #line,
                  function: String = #function) -> String {
        return log(type: .warning, message: message, file: file, line: line, function: function)
    }

    @discardableResult
    static func e(_ message: String,
                  file: String = #file,
                  line: Int = #line,
                  function: String = #function) -> String {
        return log(type: .error, message: message, file: file, line: line, function: function)
    }

    @discardableResult
    private static func log(type: LogType,
                            message: String,
                            file: String,
                            line: Int,
                            function: String) -> String {
        let icon: String
        switch type {
        case .debug: icon = "🟢"
        case .warning: icon = "🟡"
        case .error: icon = "🔴"
        }

        let fileName = (file as NSString).lastPathComponent
        // let logMessage = "\(icon) [\(fileName) -> \(line) -> \(function)] \(message)"
        let logMessage = "[\(icon)] [\(fileName):\(line)] \(function) — \(message)"

        print(logMessage)
        return logMessage
    }
}
