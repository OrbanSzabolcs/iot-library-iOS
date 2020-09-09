//
//  ViewController.swift
//  iotLibrarySample
//
//  Created by dev on 03/09/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import UIKit
import iotLibrary

class ViewController: UIViewController {

    @IBOutlet var addMetricButton: UIButton!
    @IBOutlet var addLogButton: UIButton!
    @IBOutlet var sendMqttMessageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addMetricButton.addTarget(self, action: #selector(addMetric), for: .touchUpInside)
        addLogButton.addTarget(self, action: #selector(addLog), for: .touchUpInside)
        sendMqttMessageButton.addTarget(self, action: #selector(sendMqttMessage), for: .touchUpInside)
    }

    @objc func addMetric() {
        DispatchQueue.global(qos: .background).async {
            for i in 1...50 {
                DispatchQueue.global(qos: .background).async {
                    IotTracker.shared.trackMetric(name: "szabi button", tag: "szabi pressed", value: "\(i)")
                }
            }
        }
        DispatchQueue.global(qos: .background).async {
            for i in 51...100 {
                DispatchQueue.global(qos: .background).async {
                    IotTracker.shared.trackMetric(name: "szabi button", tag: "szabi pressed", value: "\(i)")
                }
            }
        }
    }
    
    @objc func addLog() {
        DispatchQueue.global(qos: .background).async {
            for i in 1...50 {
                DispatchQueue.global(qos: .background).async {
                    IotTracker.shared.trackLog(logStream: "szabi_log", message: "szabi log message", value: "\(i)")
                }
            }
        }
        DispatchQueue.global(qos: .background).async {
            for i in 51...100 {
                DispatchQueue.global(qos: .background).async {
                    IotTracker.shared.trackLog(logStream: "szabi_log", message: "szabi log message", value: "\(i)")
                }
            }
        }
        DispatchQueue.global(qos: .background).async {
            for i in 101...150 {
                DispatchQueue.global(qos: .background).async {
                    IotTracker.shared.trackLog(logStream: "szabi_log", message: "szabi log message", value: "\(i)")
                }
            }
        }
        DispatchQueue.global(qos: .background).async {
            for i in 151...200 {
                DispatchQueue.global(qos: .background).async {
                    IotTracker.shared.trackLog(logStream: "szabi_log", message: "szabi log message", value: "\(i)")
                }
            }
        }
    }
    
    @objc func sendMqttMessage() {
        IotTracker.shared.sendMqttMessage(message: "Button pressed")
    }
}

