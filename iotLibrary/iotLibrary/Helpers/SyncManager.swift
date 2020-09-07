//
//  SyncManager.swift
//  iotlibrary
//
//  Created by dev on 02/09/2020.
//  Copyright © 2020 Zynk. All rights reserved.
//

import Foundation

func synchronized<L: NSLocking>(lockable: L, criticalSection: () -> ()) {
    lockable.lock()
    criticalSection()
    lockable.unlock()
}

func synchronized<L: NSLocking, T>(lockable: L, criticalSection: () -> T) -> T {
    lockable.lock()
    let result = criticalSection()
    lockable.unlock()
    return result
}
