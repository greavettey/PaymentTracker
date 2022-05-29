//
//  SwipeButtons.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-27.
//

import SwiftUI

@available(iOS 15, *)
struct SwipeWishlistEdit: View {
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
struct SwipeWishlistDelete: View {
    @Binding var wishes: [WishlistEntry]
    
    var toDelete: WishlistEntry
    
    var body: some View {
        Button {
            wishes = wishes.filter() { $0.id != toDelete.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toDelete.id.uuidString])
        } label: {
            Label("Delete", systemImage: "trash.fill")
        }
            .tint(.red)
    }
}
 
@available(iOS 15, *)
struct SwipeWishlistActions: View {
    @Binding var showEdit: Bool
    @Binding var wishes: [WishlistEntry]
    
    var entry: WishlistEntry
    
    var body: some View {
        SwipeWishlistEdit(showEdit: $showEdit)
        SwipeWishlistDelete(wishes: $wishes, toDelete: entry)
    }
}

