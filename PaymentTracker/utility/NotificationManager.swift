//
//  NotificationManager.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-09.
//

import SwiftUI

func queueNotification(t: Int, name: String, cost: String, date: Date, id: UUID) {
    let content = UNMutableNotificationContent()
    content.title = (t == 1 ? "Upcoming payment for" : "Payment due to " ) + name
    content.body = "$" + cost + ", " + date2String(d:date)
    content.sound = UNNotificationSound.default
    
    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: abs(notifFormat(d: date).timeIntervalSince(Date())), repeats: false)
    
    // choose a random identifier
    let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)

    // add our notification request
    UNUserNotificationCenter.current().add(request)
}
