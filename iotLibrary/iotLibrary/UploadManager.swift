//
//  UploadManager.swift
//  iotlibrary
//
//  Created by dev on 26/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

class UploadManager {
    private var timer: Timer?
    private var configuration: Configuration!
    private let backgroundDataQueue = DispatchQueue(label: "BackgroundDataQueue", attributes: .concurrent)
    private let backgroundRunLoop = RunLoop()
    private var isMetricCallPending = false
    private var isLogCallPending = false
    private let metricLock = NSRecursiveLock()
    private let logLock = NSRecursiveLock()

    
    init(configuration: Configuration) {
        self.configuration = configuration
        ApiManager.shared.apiKey = configuration.token
        IotLogger.shared.loggingEnabled = configuration.loggingEnabled
        
        timer = Timer(timeInterval: configuration.debouncingIntervalInMinutes * 60,
                      target: self,
                      selector: #selector(upload),
                      userInfo: nil,
                      repeats: true)
        if let timer = timer {
            backgroundRunLoop.add(timer, forMode: .common)
        }
        
        MqttManager.shared.setup()
    }
    
    func trackMetric(name: String,
                            tag: String,
                            value: String) {
        backgroundDataQueue.async {
            let metric = MetricWithValue(name: name, tag: tag, value: value)
            
            Storage.shared.add(metric: metric)
            let metricsCount = Storage.shared.getMetrics().count
            
            IotLogger.shared.log("Metrics count: \(metricsCount), value: \(value)")
            if metricsCount >= self.configuration.minBatchSize {
                self.uploadMetrics()
            }
        }
    }
    
    func trackLog(logStream: String,
                            message: String,
                            value: String) {
        backgroundDataQueue.async {
            let log = Log(logStream: logStream, message: message)
            
            Storage.shared.add(log: log)
            let logsCount = Storage.shared.getLogs().count
            
            IotLogger.shared.log("Logs count: \(logsCount), value: \(value)")
            if logsCount >= self.configuration.minBatchSize {
                self.uploadLogs()
            }
        }
    }
    
    func sendMqttMessage(message: String) {
        MqttManager.shared.sendMessage(message: message)
    }
    
    @objc private func upload() {
        backgroundDataQueue.async {
            self.uploadMetrics()
            self.uploadLogs()
        }
    }
    
    private func uploadMetrics() {
        synchronized(lockable: metricLock) {
            if !isMetricCallPending && !Storage.shared.getMetrics().isEmpty {
                isMetricCallPending = true
                ApiManager.shared.sendMetrics(
                    model: Storage.shared.getMetricsForUpload(),
                    completionHandler: { (metrics) in
                        Storage.shared.deleteUploadedMetrics()
                        self.isMetricCallPending = false
                        IotLogger.shared.log("--METRICS deleted")
                    }) { (error) in
                        self.handleError(error: error)
                        self.isMetricCallPending = false
                    }
            }
        }
    }
    
    private func uploadLogs() {
        synchronized(lockable: logLock) {
            if !isLogCallPending && !Storage.shared.getLogs().isEmpty {
                isLogCallPending = true
                ApiManager.shared.sendLogStream(
                    model: Storage.shared.getLogsForUpload(),
                    completionHandler: { (response) in
                        Storage.shared.deleteUploadedLogs()
                        self.isLogCallPending = false
                        IotLogger.shared.log("--LOGS deleted")
                    }) { (error) in
                        self.handleError(error: error)
                        self.isLogCallPending = false
                    }
            }
        }
    }
    
    private func handleError(error: Error) {
        if let error = error as? IotError {
            switch error {
            case .invalidUrl:
                IotLogger.shared.log("The url was invalid")
            case .apiError(code: let code):
                IotLogger.shared.log("Api returned error with code: \(code)")
            case .parseError:
                IotLogger.shared.log("Could not parse response from server")
            case .trackingNotInitialized:
                IotLogger.shared.log("You need to call IoTTracker.set(configuration) before IotTracking.track()")
            case .noUserToken:
                IotLogger.shared.log("You need to set token first")
            }
        } else {
            IotLogger.shared.log("Unexpected error: \(error.localizedDescription)")
        }
    }
}
