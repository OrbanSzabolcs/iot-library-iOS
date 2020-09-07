//
//  IotTracker.swift
//  iotlibrary
//
//  Created by dev on 24/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation
import Darwin

public class IotTracker {
    public static var shared = IotTracker()
    private var uploadManager: UploadManager?
    
    public func set(configuration: Configuration) {
        uploadManager = UploadManager(configuration: configuration)
    }
    
    public func set(token: String) {
        let configuration = Configuration()
        configuration.token = token
        uploadManager = UploadManager(configuration: configuration)
    }
    
    public func trackMetric(name: String,
                            tag: String,
                            value: String) {
        uploadManager?.trackMetric(name: name, tag: tag, value: value)
    }
    
    public func trackLog(logStream: String,
                            message: String,
                            value: String) {
        uploadManager?.trackLog(logStream: logStream, message: message, value: value)
    }
}
