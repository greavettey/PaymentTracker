//
//  Upcoming.CM.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import SwiftUI

struct ContextMenuDeleteUpcoming: View {
    @Binding var upcomings: [UpcomingPaymentEntry]

    @State var showSheet: Bool = false;
    
    var toDelete: UpcomingPaymentEntry
    
    var body: some View {
        Button {
            upcomings = upcomings.filter() { $0.id != toDelete.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toDelete.id.uuidString])
        } label: {
            Text("Delete")
                .foregroundColor(.red)
        }
    }
}
