//
//  Upcoming.T.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI

struct UpcomingView: View {
    @Binding var upcomings: [UpcomingPaymentEntry]
    @Binding var debts: [DebtPaymentEntry]
    @Binding var wishes: [WishlistEntry]
        
    @State var showEditSheet = false;
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack{
                    Text("Upcoming")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    PlusButton(debts: $debts, upcomings: $upcomings, wishes: $wishes, parent: Binding.constant(0))
                }
                if(upcomings.count == 0) {
                    Spacer()
                    Text("Nothing to see here... yet.")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding()
                        .multilineTextAlignment(.center)
                    Spacer()
                }else {
                    List(upcomings) { entry in
                        Section(header: HStack {
                                Text(entry.type + " • " + entry.date)
                                if(GlobalProps.SupportedIcons.contains(entry.type)) {
                                    Spacer()
                                    Image("vendors/"+entry.type)
                                        .resizable()
                                        .background(Color.white)
                                        .frame(width: 20, height: 20, alignment: .leading)
                                        .cornerRadius(3)
                                }
                        }, footer: HStack {
                            switch(entry.sub) {
                                case 1:
                                    Text("Monthly payment")
                                case 2:
                                    Text("Yearly payment")
                                default:
                                    Text("One-time payment")
                            }
                            Spacer()
                            Image(systemName: (entry.sub != 0 && entry.sub == 2) ? "clock.arrow.2.circlepath" : "clock.arrow.circlepath")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }) {
                            UpcomingPaymentView(entry: entry, upcomings: $upcomings);
                        }
                    }
                      .listStyle(.insetGrouped)
                }
            }
        }
    }
}
