//
//  Wishlist.T.swift
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
    
    @AppStorage("showAdded") var showAdded: Bool = UserDefaults.standard.bool(forKey: "showAdded");
    
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
            } else {
                List(wishes) { entry in
                    Section(header: HStack {
                        Text(entry.type)
                        if(GlobalProps.SupportedIcons.contains(entry.type)) {
                            Spacer()
                            Image("vendors/"+entry.type)
                                .resizable()
                                .background(Color.white)
                                .frame(width: 20, height: 20, alignment: .leading)
                                .cornerRadius(3)
                        }
                }, footer: HStack {
                    if(showAdded) {
                        (entry.edited == "" || entry.edited == nil) ? Text("Added " + (entry.added ?? "04/03/1984")) : Text("Edited " + (entry.edited ?? "04/03/1984 "))
                        Spacer()
                        Image(systemName: "bag.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                }) {
                        WishlistPaymentView(entry: entry, wishes: $wishes);
                    }
                }.listStyle(.insetGrouped)
            }
        }
    }
}
