//
//  NotificationMananger.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/11/18.
//

import Foundation

final class NotificationMananger {
    static let shared = NotificationMananger()
    let center = NotificationCenter.default
    
    private init() {}
    
    func postNotification(_ name: String, _ userInfo: [AnyHashable : Any]? = nil) {
        center.post(name: NSNotification.Name(rawValue: name), object: nil, userInfo: userInfo)
    }
}
