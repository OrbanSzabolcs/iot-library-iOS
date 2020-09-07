//
//  ApiConstants.swift
//  iotlibrary
//
//  Created by dev on 26/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

enum ApiConstants {
//    static let basePath = "http://10.8.0.24:8080" //alex
    static let basePath = "https://iot.zynksoftware.com" //test
    static let apiPath = ApiConstants.basePath + "/api"
    
    enum HttpMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    enum HttpHeaderField: String {
        case contentType = "Content-Type"
        case accept = "Accept"
    }
    
    enum HttpHeaderValue: String {
        case applicationJson = "application/json"
        case apiKey = "APIKEY"
    }
}
