//
//  SwipeButtons.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-27.
//

import SwiftUI

@available(iOS 15, *)
struct SwipeDebtEdit: View {
    @Binding var showEdit: Bool
    var body: some View {
        Button {
            showEdit.toggle()
        } label: {
            Label("", systemImage: "pencil")
        }
            .tint(.indigo)
    }
}

@available(iOS 15, *)
struct SwipeDebtDelete: View {
    @Binding var debts: [DebtPaymentEntry]
    
    var toDelete: DebtPaymentEntry
    
    var body: some View {
        Button {
            debts = debts.filter() { $0.id != toDelete.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toDelete.id.uuidString])
        } label: {
            Label("", systemImage: "trash.fill")
        }
            .tint(.red)
    }
}

@available(iOS 15, *)
struct SwipeDebtFulfill: View {
    @Binding var debts: [DebtPaymentEntry]
    
    var toFinish: DebtPaymentEntry
    
    var body: some View {
        Button {
            let index = debts.firstIndex{ $0.id == toFinish.id }!
            var temp = debts[index]
            temp.paid = temp.amount;
            debts[index] = temp;
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toFinish.id.uuidString])
        } label: {
            Label("", systemImage: "checkmark")
        }
            .tint(.green)
    }
}
 
@available(iOS 15, *)
struct SwipeDebtActions: View {
    @Binding var showEdit: Bool
    @Binding var debts: [DebtPaymentEntry]
    
    var entry: DebtPaymentEntry
    
    var body: some View {
        SwipeDebtEdit(showEdit: $showEdit)
        if(entry.paid/entry.amount != 1){ SwipeDebtFulfill(debts: $debts, toFinish: entry) }
        SwipeDebtDelete(debts: $debts, toDelete: entry)
    }
}

