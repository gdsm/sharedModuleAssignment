//
//  Logging.swift
//  Logging
//
//  Created by Gagandeep on 19/02/24.
//

import Foundation

public struct Log {

    @inlinable public static func debug(_ message: String,
                                        _ function: String = #function,
                                        _ file: String = #file
    ) {
        Log.logMessage("DEBUG", message, function, file)
    }
    
    @inlinable public static func info(_ message: String,
                                       _ function: String = #function,
                                       _ file: String = #file
    ) {
        Log.logMessage("INFO", message, function, file)
    }
    
    @inlinable public static func warn(_ message: String,
                                       _ function: String = #function,
                                       _ file: String = #file
    ) {
        Log.logMessage("WARN", message, function, file)
    }
    
    @inlinable public static func error(_ message: String,
                                        _ function: String = #function,
                                        _ file: String = #file
    ) {
        logMessage("ERROR", message, function, file)
    }
    
    public static func logMessage(_ tag: String, _ message: String, _ function: String, _ file: String) {
        let fileName = file.components(separatedBy: "/").last ?? ""
        print("\(tag): \(fileName) - \(function) - \(message)")
    }
}
