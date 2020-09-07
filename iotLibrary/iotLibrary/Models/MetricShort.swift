//
//  MetricShort.swift
//  iotlibrary
//
//  Created by dev on 26/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

class MetricShort: Codable {
    var name: String!
    var tag: String!
    
    init(name: String?, tag: String?) {
        self.name = name
        self.tag = tag
    }
}
