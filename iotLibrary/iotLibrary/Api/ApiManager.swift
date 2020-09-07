//
//  ApiManager.swift
//  iotlibrary
//
//  Created by dev on 26/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

class ApiManager {
    static var shared = ApiManager()
    var apiKey: String?

    func sendMetrics(model: [MetricWithValue],
                     completionHandler: @escaping ([MetricWithValue]) -> Void,
                     errorHandler: @escaping (Error) -> Void) {
        IotLogger.shared.log("--starting METRIC upload with: \(model.count)")
        let urlString = "\(ApiConstants.apiPath)/metric/multiple"
        let request = buildPostRequest(urlString: urlString, encodableModel: model)
        callApi(request: request,
                completionHandler: completionHandler,
                errorHandler: errorHandler)
    }

    func sendLogStream(model: [Log],
                       completionHandler: @escaping (EmptyResponse) -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        IotLogger.shared.log("--starting LOG upload with: \(model.count)")
        let urlString = "\(ApiConstants.apiPath)/logstream/data"
        let request = buildPostRequest(urlString: urlString, encodableModel: model)
        callApi(request: request,
                completionHandler: completionHandler,
                errorHandler: errorHandler)
    }
}

// MARK: - Build Request

extension ApiManager {
    private func buildGetRequest(urlString: String) -> URLRequest? {
        return buildRequest(method: .GET,
                            urlString: urlString,
                            encodableModel: nil)
    }

    private func buildPostRequest(urlString: String, encodableModel: Encodable? = nil) ->
        URLRequest? {
        return buildRequest(method: .POST,
                            urlString: urlString,
                            encodableModel: encodableModel)
    }

    private func buildPutRequest(urlString: String, encodableModel: Encodable? = nil) ->
        URLRequest? {
        return buildRequest(method: .PUT,
                            urlString: urlString,
                            encodableModel: encodableModel)
    }

    private func buildDeleteRequest(urlString: String, encodableModel: Encodable? = nil) ->
        URLRequest? {
        return buildRequest(method: .DELETE,
                            urlString: urlString,
                            encodableModel: encodableModel)
    }

    private func buildRequest(method: ApiConstants.HttpMethod,
                              urlString: String,
                              encodableModel: Encodable?) -> URLRequest? {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            if let encodableModel = encodableModel {
                request.httpBody = encodableModel.toJSONData()
            }
            
            return request
        }
        return nil
    }
}

extension ApiManager {
    private func callApi<T: Decodable>(request: URLRequest?,
                 completionHandler: @escaping (T) -> Void,
                 errorHandler: @escaping (Error) -> Void) {
        guard var request = request else {
            errorHandler(IotError.invalidUrl)
            return
        }
        
        request.setValue(ApiConstants.HttpHeaderValue.applicationJson.rawValue,
            forHTTPHeaderField: ApiConstants.HttpHeaderField.contentType.rawValue)
        if let apiKey = apiKey {
            request.setValue(apiKey,
                             forHTTPHeaderField: ApiConstants.HttpHeaderValue.apiKey.rawValue)
        } else {
            errorHandler(IotError.noUserToken)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                errorHandler(error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
                  !(200...299).contains(httpResponse.statusCode) {
                errorHandler(IotError.apiError(code: httpResponse.statusCode))
                return
            }
            
            var data = data
            if data?.isEmpty ?? true {
                data = "{}".data(using: .utf8)
            }
            if let data = data,
                let model = try? JSONDecoder().decode(T.self, from: data) {
                completionHandler(model)
            } else {
                errorHandler(IotError.parseError)
            }
        }
        task.resume()
    }
}
