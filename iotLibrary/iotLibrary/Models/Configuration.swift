//
//  Configuration.swift
//  iotlibrary
//
//  Created by dev on 24/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

public class Configuration {
    public var token: String?
    public var minBatchSize: Int = Constants.minimumBatchSize
    public var loggingEnabled: Bool = Constants.defaultLogging
    public var debouncingIntervalInMinutes: Double = Constants.minimumDebouncing {
        didSet {
            if debouncingIntervalInMinutes < Constants.minimumDebouncing {
                debouncingIntervalInMinutes = Constants.minimumDebouncing
            }
        }
    }
    
    public init() { }
}
