//
//  MqttManager.swift
//  iotLibrary
//
//  Created by dev on 07/09/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation
import MQTTClient

class MqttManager: NSObject {
    static var shared = MqttManager()
    
    private let host = "163.172.206.145"
    private let port = 1883
    private let tls = false
    private let base = "MqttIot/"
    private var topic: String = "MqttIot/\(UIDevice.current.name)"
    private let user = "admin"
    private let password = "wa7pePqx"
    
    private var manager: MQTTSessionManager?
    
    func setup() {
        if let manager = manager {
            manager.connect { (error) in
                print(error?.localizedDescription ?? "")
            }
        } else {
            manager = MQTTSessionManager()
            manager?.delegate = self
            manager?.subscriptions = [
                "\(base)": NSNumber(integerLiteral: Int(MQTTQosLevel.exactlyOnce.rawValue))
            ]
            
            manager?.connect(to: host,
                            port: port,
                            tls: tls,
                            keepalive: 60,
                            clean: true,
                            auth: false,
                            user: user,
                            pass: password,
                            will: true,
                            willTopic: topic,
                            willMsg: "offline".data(using: .utf8),
                            willQos: .exactlyOnce,
                            willRetainFlag: false,
                            withClientId: nil,
                            securityPolicy: .none,
                            certificates: [],
                            protocolLevel: .version311) { (error) in
                                print(error?.localizedDescription ?? "")
            }
        }
        
    }
    
    func sendMessage(message: String) {
        if let manager = manager {
            manager.send(message.data(using: .utf8),
                         topic: topic,
                         qos: .exactlyOnce,
                         retain: false)
        }
    }
    
    func disconnect() {
        if let manager = manager {
            manager.disconnect { (error) in
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

extension MqttManager: MQTTSessionManagerDelegate {
    func sessionManager(_ sessionManager: MQTTSessionManager!, didChange newState: MQTTSessionManagerState) {
        if newState == .connected {
            sendMessage(message: "connected message")
        }
    }
    
    func handleMessage(_ data: Data!, onTopic topic: String!, retained: Bool) {
        let message = String(data: data, encoding: .utf8) ?? ""
        print("\(topic ?? ""): \(message)")
    }
}
