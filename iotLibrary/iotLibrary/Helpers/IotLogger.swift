//
//  IotLogger.swift
//  iotlibrary
//
//  Created by dev on 03/09/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

class IotLogger {
    static var shared = IotLogger()
    
    var loggingEnabled = false
    func log(_ text: String) {
        if loggingEnabled {
            print("\(Constants.tag) \(text)")
        }
    }
}
