//
//  Storage.swift
//  iotlibrary
//
//  Created by dev on 25/08/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

extension Encodable {
    func toJSONData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

extension Data {
    func toObject<T: Decodable>() -> T? {
        try? JSONDecoder().decode(T.self, from: self)
    }
}

class Storage {
    static var shared: Storage = Storage()
    
    private let defaults = UserDefaults.standard
    private let metricsKey = "IotMetricsKey"
    private let pendingMetricsKey = "PendingIotMetricsKey"
    private let logsKey = "IotLogsKey"
    private let pendingLogsKey = "PendingIotLogsKey"
    
    private var isMetricPendingUpload = false
    private var isLogPendingUpload = false
    private let metricLock = NSRecursiveLock()
    private let logLock = NSRecursiveLock()
    
    private func save(metrics: [MetricWithValue]) {
        synchronized(lockable: metricLock) {
            if let jsonData = metrics.toJSONData() {
                defaults.set(jsonData, forKey: metricsKey)
            }
        }
    }
    
    func getMetrics() -> [MetricWithValue] {
        synchronized(lockable: metricLock) {
            let jsonData = defaults.data(forKey: metricsKey)
            return jsonData?.toObject() ?? []
        }
    }
    
    func add(metric: MetricWithValue) {
        synchronized(lockable: metricLock) {
            var metrics = getMetrics()
            metrics.append(metric)
            save(metrics: metrics)
        }
    }
    
    private func savePending(metrics: [MetricWithValue]) {
        synchronized(lockable: metricLock) {
            if let jsonData = metrics.toJSONData() {
                defaults.set(jsonData, forKey: pendingMetricsKey)
            }
        }
    }
    
    private func getPendingMetrics() -> [MetricWithValue] {
        synchronized(lockable: metricLock) {
            let jsonData = defaults.data(forKey: pendingMetricsKey)
            return jsonData?.toObject() ?? []
        }
    }
    
    func addPending(metrics: [MetricWithValue]) {
        synchronized(lockable: metricLock) {
            var pendingMetrics = getPendingMetrics()
            pendingMetrics.append(contentsOf: metrics)
            savePending(metrics: pendingMetrics)
        }
    }
    
    func getMetricsForUpload() -> [MetricWithValue] {
        synchronized(lockable: metricLock) {
            if isMetricPendingUpload {
                return getPendingMetrics()
            }
            isMetricPendingUpload = true
            let metrics = getMetrics()
            save(metrics: [])
            addPending(metrics: metrics)
            return metrics
        }
    }
    
    func deleteUploadedMetrics() {
        synchronized(lockable: metricLock) {
            savePending(metrics: [])
            isMetricPendingUpload = false
        }
    }
    
    
    
    private func save(logs: [Log]) {
        synchronized(lockable: logLock) {
            if let jsonData = logs.toJSONData() {
                defaults.set(jsonData, forKey: logsKey)
            }
        }
    }
    
    func getLogs() -> [Log] {
        synchronized(lockable: logLock) {
            let jsonData = defaults.data(forKey: logsKey)
            return jsonData?.toObject() ?? []
        }
    }
    
    func add(log: Log) {
        synchronized(lockable: logLock) {
            var logs = getLogs()
            logs.append(log)
            save(logs: logs)
        }
    }
    
    private func savePending(logs: [Log]) {
        synchronized(lockable: logLock) {
            if let jsonData = logs.toJSONData() {
                defaults.set(jsonData, forKey: pendingLogsKey)
            }
        }
    }
    
    private func getPendingLogs() -> [Log] {
        synchronized(lockable: logLock) {
            let jsonData = defaults.data(forKey: pendingLogsKey)
            return jsonData?.toObject() ?? []
        }
    }
    
    func addPending(logs: [Log]) {
        synchronized(lockable: logLock) {
            var pendingLogs = getPendingLogs()
            pendingLogs.append(contentsOf: logs)
            savePending(logs: pendingLogs)
        }
    }
    
    func getLogsForUpload() -> [Log] {
        synchronized(lockable: logLock) {
            if isLogPendingUpload {
                return getPendingLogs()
            }
            isLogPendingUpload = true
            let logs = getLogs()
            save(logs: [])
            addPending(logs: logs)
            return logs
        }
    }
    
    func deleteUploadedLogs() {
        synchronized(lockable: logLock) {
            savePending(logs: [])
            isLogPendingUpload = false
        }
    }
}
