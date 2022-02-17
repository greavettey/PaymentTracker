//
//  PaymentEntry.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI

struct UpcomingPaymentView: View {
    var entry: UpcomingPaymentEntry;
    
    @Binding var upcomings: [UpcomingPaymentEntry]
    @Binding var debts: [DebtPaymentEntry]

    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");
    @AppStorage("currency") var c: String = UserDefaults.standard.string(forKey: "currency") ?? "CAD";
    
    @State var upcomingSheet = false;
    
    var body: some View {
        VStack {
            HStack {
                Text(entry.name)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
                Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.cost)))
                    .multilineTextAlignment(.trailing)
                    .padding()
                    
            }
            Divider()
                //.padding(.vertical, -4.0)
            HStack {
                Text(entry.date)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
                if(GlobalProps.SupportedIcons.contains(entry.type)) {
                    HStack {
                        Text(entry.type)
                            .multilineTextAlignment(.trailing)
                            .padding([.vertical, .leading])
                        Image("vendors/"+entry.type)
                            .resizable()
                            .background(Color.white)
                            .frame(width: 25, height: 25, alignment: .leading)
                            .cornerRadius(5)
                            .padding([.vertical, .trailing])
                    }
                } else {
                    Text(entry.type)
                        .multilineTextAlignment(.trailing)
                        .padding()
                }
                
            }
        }.contextMenu {
            ContextMenuEdit(showEditSheet: $upcomingSheet)
            ContextMenuDeleteUpcoming(upcomings: $upcomings, toDelete: entry)
        }.sheet(isPresented: $upcomingSheet) {
            UpcomingEditForm(upcomings: $upcomings, name: entry.name, date: string2Date(s: entry.date), cost: forTrailingZero(temp: entry.cost), type: entry.type, cc: Currency(rawValue:entry.cc) ?? .CAD, id: entry.id)
        }
    }
}

struct DebtPaymentView: View {
    var entry: DebtPaymentEntry;
    
    @Binding var debts: [DebtPaymentEntry]
    @Binding var upcomings: [UpcomingPaymentEntry]
    
    @State var debtSheet = false;

    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");
    @AppStorage("currency") var c: String = UserDefaults.standard.string(forKey: "currency") ?? "CAD";
    
    var perc: Double { return Double(round(100 * (entry.paid / entry.amount)) / 100) * 100 }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(entry.name + " • " + entry.date)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.amount)))
                        .multilineTextAlignment(.trailing)
                        .padding()
                        
                }
                Divider()
                    //.padding(.vertical, -4.0)
                VStack {
                    ProgressView(value: Float(entry.paid/entry.amount))
                        .padding(.bottom, -3.0)
                        .padding([.top, .horizontal])
                        .progressViewStyle(LinearProgressViewStyle(tint: (entry.paid/entry.amount == 1) ? Color.green : Color.blue))
                    HStack {
                        Text(forTrailingZero(temp: entry.paid))
                            .font(.footnote)
                            .multilineTextAlignment(.trailing)
                            .padding([.horizontal, .bottom])
                        Spacer()
                        Text(forTrailingZero(temp: perc) + "%")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding([.horizontal, .bottom])
                        Spacer()
                        Text(forTrailingZero(temp: entry.amount))
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                            .padding([.horizontal, .bottom])
                    }
                }
            }
        }.contextMenu {
            ContextMenuEdit(showEditSheet: $debtSheet)
            if(entry.paid/entry.amount != 1){ ContextMenuMarkAsPaid(debts: $debts, toFinish: entry.id) }
            ContextMenuDeleteDebt(debts: $debts, toDelete: entry)
        }.sheet(isPresented: $debtSheet) {
            DebtEditForm(debts: $debts, name: entry.name, date: string2Date(s: entry.date), amount: forTrailingZero(temp: entry.amount), paid: forTrailingZero(temp: entry.paid), cc: Currency(rawValue:entry.cc) ?? .CAD, id: entry.id)
        }
    }
}
