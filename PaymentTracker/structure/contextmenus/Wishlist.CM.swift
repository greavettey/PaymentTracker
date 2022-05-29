//
//  Wishlist.CM.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import SwiftUI

struct ContextMenuDeleteWish: View {
    @Binding var wishes: [WishlistEntry]
    
    @State var showSheet: Bool = false;
    
    var toDelete: WishlistEntry
    
    var body: some View {
        Button {
            wishes = wishes.filter() { $0.id != toDelete.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toDelete.id.uuidString])
        } label: {
            Text("Delete")
                .foregroundColor(.red)
        }
    }
}
