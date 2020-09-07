//
//  Log.swift
//  iotlibrary
//
//  Created by dev on 27/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

class Log: Codable {
    var logStream: String!
    var timestamp: Double!
    var message: String!
    
    init(logStream: String?, message: String?) {
        self.logStream = logStream
        self.timestamp = NSDate().timeIntervalSince1970
        self.message = message
    }
}
