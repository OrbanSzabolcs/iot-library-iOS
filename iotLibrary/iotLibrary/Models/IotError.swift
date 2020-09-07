//
//  IotError.swift
//  iotlibrary
//
//  Created by dev on 26/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

enum IotError: Error {
    case invalidUrl
    case apiError(code: Int)
    case parseError
    case trackingNotInitialized
    case noUserToken
}
