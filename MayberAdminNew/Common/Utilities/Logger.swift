
//  Created by Airtemium

import Foundation

enum LogType: Int {
    case kNormal = 1
    case kImportant = 2
}

class Logger {
    var isLogEnabled: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    class var sharedLogger: Logger {
        struct defaultSingleton {
            static let loggerInstance = Logger()
        }
        return defaultSingleton.loggerInstance
    }
    
    class func log(_ logString: Any, _ function: String = #function, logType: LogType? = .kNormal) {
        guard Logger.sharedLogger.isLogEnabled || (logType == .kImportant) else {
            return
        }
            
        print(Logger.sharedLogger.isLogEnabled ? "MA: \(logString) \(function)" : "")
    }
    
    class func logDebug(_ logString: Any, _ function: String = #function, logType: LogType? = .kNormal) {
        log("*** DEBUG *** \(logString)", function, logType: logType)
    }
}
