//
//  MetricWithValue.swift
//  iotlibrary
//
//  Created by dev on 26/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

class MetricWithValue: Codable {
    var metric: MetricShort!
    var metricValue: MetricValue!
    
    init(metric: MetricShort, metricValue: MetricValue) {
        self.metric = metric
        self.metricValue = metricValue
    }
    
    init(name: String, tag: String, value: String) {
        self.metric = MetricShort(name: name,
                                  tag: tag)
        self.metricValue = MetricValue(timestamp: NSDate().timeIntervalSince1970,
                                       value: value)
    }
}
