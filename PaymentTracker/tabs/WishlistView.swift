//
//  WishlistView.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-04-28.
//

import Foundation
import SwiftUI

struct WishlistView: View {
    @Binding var wishes: [WishlistEntry]
    @Binding var debts: [DebtPaymentEntry]
    @Binding var upcomings: [UpcomingPaymentEntry]
    
    var body: some View {
        VStack {
            HStack {
                Text("Wishlist")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
                PlusButton(debts: $debts, upcomings: $upcomings, wishes: $wishes, parent: Binding.constant(2))
            }
            if(wishes.count == 0) {
                Spacer()
                Text("Oh come on, surely you want something!")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding()
                    .multilineTextAlignment(.center)
                Spacer()
            }else {
                List(wishes) { entry in
                    Section {
                        WishlistPaymentView(entry: entry, wishes: $wishes);
                    }
                }.listStyle(.insetGrouped)
            }
        }
    }
    
}
