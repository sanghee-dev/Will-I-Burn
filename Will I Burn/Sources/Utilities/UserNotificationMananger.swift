//
//  UserNotificationMananger.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/11/18.
//

import Foundation
import UserNotifications

final class UserNotificationMananger {
    static let shared = UserNotificationMananger()
    let center = UNUserNotificationCenter.current()

    private init() {}

    func requestNotification(after time: Int) {
        center.removeAllPendingNotificationRequests()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, _) in
            guard granted else { return }

            let content = UNMutableNotificationContent()
            content.title = "Time's Up!"
            content.body = "You are beginning to BURN!🥵"
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time * 60), repeats: false)
            let request = UNNotificationRequest(identifier: "burnNotification", content: content, trigger: trigger)
            self.center.add(request, withCompletionHandler: nil)
        }
    }
}
