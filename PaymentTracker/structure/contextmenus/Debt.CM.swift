//
//  Debt.CM.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import SwiftUI

struct ContextMenuDeleteDebt: View {
    @Binding var debts: [DebtPaymentEntry]

    var toDelete: DebtPaymentEntry;
    
    var body: some View {
        Button {
            debts = debts.filter(){ $0.id != toDelete.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toDelete.id.uuidString])
        } label: {
            Text("Delete")
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
