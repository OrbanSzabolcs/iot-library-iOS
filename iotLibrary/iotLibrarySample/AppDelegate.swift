//
//  AppDelegate.swift
//  iotLibrarySample
//
//  Created by dev on 03/09/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import UIKit
import iotLibrary

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("init AppDelegate")
        let configuarion = Configuration()
        configuarion.token = "projectiotglobal"
        configuarion.minBatchSize = 5
        configuarion.loggingEnabled = true
        configuarion.debouncingIntervalInMinutes = 15
        
        IotTracker.shared.set(configuration: configuarion)
        
        return true
    }
}

