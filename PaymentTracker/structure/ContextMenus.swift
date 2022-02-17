//
//  ContextMenus.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-08.
//

import SwiftUI
import Combine

struct ContextMenuDeleteDebt: View {
    @Binding var debts: [DebtPaymentEntry]

    var toDelete: DebtPaymentEntry
    
    var body: some View {
        Button {
            debts = debts.filter(){ $0.id != toDelete.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toDelete.id.uuidString])
        } label: {
            Text("Delete")
        }
    }
}

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

struct ContextMenuEdit: View {
    @Binding var showEditSheet: Bool;
    
    var body: some View {
        Button {
            showEditSheet.toggle()
        } label: {
            Text("Edit")
        }
    }
}

struct ContextMenuMarkAsPaid: View {
    @Binding var debts: [DebtPaymentEntry]
    
    var toFinish: UUID
    
    var body: some View {
        Button {
            let index = debts.firstIndex{ $0.id == toFinish }!
            var temp = debts[index]
            temp.paid = temp.amount;
            debts[index] = temp;
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toFinish.uuidString])
        } label: {
            Text("Mark as Paid")
                .foregroundColor(.green)
        }
    }
}
