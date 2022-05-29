//
//  SwipeButtons.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-27.
//

import SwiftUI

@available(iOS 15, *)
struct SwipeUpcomingEdit: View {
    @Binding var showEdit: Bool
    var body: some View {
        Button {
            showEdit.toggle()
        } label: {
            Label("Edit", systemImage: "pencil")
        }
            .tint(.indigo)
    }
}

@available(iOS 15, *)
struct SwipeUpcomingDelete: View {
    @Binding var upcomings: [UpcomingPaymentEntry]
    
    var toDelete: UpcomingPaymentEntry
    
    var body: some View {
        Button {
            upcomings = upcomings.filter() { $0.id != toDelete.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toDelete.id.uuidString])
        } label: {
            Label("Delete", systemImage: "trash.fill")
        }
            .tint(.red)
    }
}
 
@available(iOS 15, *)
struct SwipeUpcomingActions: View {
    @Binding var showEdit: Bool
    @Binding var upcomings: [UpcomingPaymentEntry]
    
    var entry: UpcomingPaymentEntry
    
    var body: some View {
        SwipeUpcomingEdit(showEdit: $showEdit)
        SwipeUpcomingDelete(upcomings: $upcomings, toDelete: entry)
    }
}

