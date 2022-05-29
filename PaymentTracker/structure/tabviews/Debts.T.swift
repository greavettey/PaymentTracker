//
//  Debts.T.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI

struct DebtsView: View {
    @Binding var debts: [DebtPaymentEntry]
    @Binding var upcomings: [UpcomingPaymentEntry]
    @Binding var wishes: [WishlistEntry]
    
    @AppStorage("showAdded") var showAdded: Bool = UserDefaults.standard.bool(forKey: "showAdded");

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack{
                    Text("Debts")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    PlusButton(debts: $debts, upcomings: $upcomings, wishes: $wishes, parent: Binding.constant(1))
                }
                if(debts.count == 0) {
                    Spacer()
                    Text("Nothing to see here. That's good right?")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    List(debts) { entry in
                        Section(footer: HStack {
                            if(showAdded) {
                                (entry.edited == "" || entry.edited == nil) ? Text("Added " + (entry.added ?? "12/27/2002")) : Text("Edited " + (entry.edited ?? "12/27/2002"))
                                Spacer()
                                Image(systemName: "calendar.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            }
                        }) {
                            DebtPaymentView(debts: $debts, entry: entry);
                        }
                    }
                }
            }
        }
    }
}
