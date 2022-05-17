//
//  PlusButton.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-05.
//

import SwiftUI
import Combine

struct PlusButton: View {
    @Binding var debts: [DebtPaymentEntry]
    @Binding var upcomings: [UpcomingPaymentEntry]
    @Binding var wishes: [WishlistEntry]
    @Binding var parent: Int
    
    @State private var showSheet = false

    var body: some View {
        Button {
            showSheet.toggle()
        } label: {
            Image(systemName: "plus.square.fill")
                .padding()
                .font(.title)
        }
        .sheet(isPresented: $showSheet) {
            EntrySheet(debts: $debts, upcomings: $upcomings, wishes: $wishes, parent: parent)
        }
    }
}

struct EntrySheet: View {
    @Environment(\.dismiss) var dismiss

    @Binding var debts: [DebtPaymentEntry]
    @Binding var upcomings: [UpcomingPaymentEntry]
    @Binding var wishes: [WishlistEntry]
    @State var parent: Int
        
    let typeOptions = ["Upcoming", "Debt", "Wishlist"]

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack{
                    Text("New Entry")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.square.fill")
                            .padding()
                            .font(.title)
                    }
                }
                Spacer()
                Form {
                    Section {
                        HStack {
                            Text("Type")
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Picker(selection: $parent, label: Text("Choose the type of payment"), content: {
                                ForEach(0 ..< typeOptions.count) {
                                    Text(typeOptions[$0])
                                        .padding(.horizontal)
                                        .padding(.vertical, GlobalProps.PS)
                                        .multilineTextAlignment(.trailing)
                                }
                            })
                                .pickerStyle(MenuPickerStyle())
                                .labelsHidden()
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    switch parent {
                    case 1:
                        DebtEntryForm(debts: $debts).tag(1)
                    case 2:
                        WishlistEntryForm(wishes: $wishes).tag(2)
                    default:
                        UpcomingEntryForm(upcomings: $upcomings).tag(0)
                    }
                }
            }
        }
    }
}
