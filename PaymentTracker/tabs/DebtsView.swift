//
//  DebtsView.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI

struct DebtsView: View {
    @Binding var debts: [DebtPaymentEntry]
    @Binding var upcomings: [UpcomingPaymentEntry]
    @Binding var wishes: [WishlistEntry]

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
                    Text("Nothing to see down here. That's good right?")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    List(debts) { entry in
                        Section {
                            DebtPaymentView(entry: entry, debts: $debts);
                        }
                    }
                }
            }
        }
    }
}
