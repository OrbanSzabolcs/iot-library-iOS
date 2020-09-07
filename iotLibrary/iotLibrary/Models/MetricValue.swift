//
//  MetricValue.swift
//  iotlibrary
//
//  Created by dev on 26/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

class MetricValue: Codable {
    var timestamp: Double!
    var value: String!
    
    init(timestamp: TimeInterval?, value: String?) {
        self.timestamp = timestamp
        self.value = value
    }
}
