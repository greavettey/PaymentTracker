//
//  NotificationManager.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-09.
//

import SwiftUI

func queueNotification(t: Int, name: String, cost: String, sub: Int, date: Date, id: UUID) {
    var components = Calendar.current.dateComponents((sub == 2) ? [.day, .month, .year] : [.day, .month], from: date)
    components.timeZone = TimeZone.current
    components.hour = 1
    
    let content = UNMutableNotificationContent()
    content.title = (t == 1 ? "Upcoming payment for " : "Payment due to ") + name
    content.body = "$" + cost + ", " + date2String(d:date)
    content.sound = UNNotificationSound.default
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: (sub > 0) ? true : false) // sub
    
    // set id to the uuid of the original
    let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)

    // add our notification request
    UNUserNotificationCenter.current().add(request)
}
