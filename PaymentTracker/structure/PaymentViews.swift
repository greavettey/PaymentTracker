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

    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");
    @AppStorage("currency") var c: String = UserDefaults.standard.string(forKey: "currency") ?? "CAD";
    
    @State var upcomingSheet = false;
    
    var body: some View {
        VStack {
            HStack {
                Text(entry.name)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.cost)))
                    .multilineTextAlignment(.trailing)
            }
                .padding(.horizontal)
                .padding(.vertical, GlobalProps.PS)
        }.contextMenu {
            ContextMenuEdit(showEditSheet: $upcomingSheet)
            ContextMenuDeleteUpcoming(upcomings: $upcomings, toDelete: entry)
        }.sheet(isPresented: $upcomingSheet) {
            UpcomingEditForm(upcomings: $upcomings, name: entry.name, date: string2Date(s: entry.date), cost: forTrailingZero(temp: entry.cost), type: entry.type, sub: entry.sub ?? false, cc: Currency(rawValue:entry.cc) ?? .CAD, id: entry.id)
        }
    }
    
    var oldBody: some View {
        VStack {
            HStack {
                Text(entry.name)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.cost)))
                    .multilineTextAlignment(.trailing)
            }
                .padding(.horizontal)
                .padding(.vertical, GlobalProps.PS)
            Divider()
            HStack {
                Text(entry.date)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                Spacer()
                if(GlobalProps.SupportedIcons.contains(entry.type)) {
                    HStack {
                        Text(entry.type)
                            .multilineTextAlignment(.trailing)
                            .padding(.leading)
                        Image("vendors/"+entry.type)
                            .resizable()
                            .background(Color.white)
                            .frame(width: 25, height: 25, alignment: .leading)
                            .cornerRadius(5)
                            .padding(.trailing)
                    }
                } else {
                    Text(entry.type)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                }
            }
                .padding(.vertical, GlobalProps.PS)
        }.contextMenu {
            ContextMenuEdit(showEditSheet: $upcomingSheet)
            ContextMenuDeleteUpcoming(upcomings: $upcomings, toDelete: entry)
        }.sheet(isPresented: $upcomingSheet) {
            UpcomingEditForm(upcomings: $upcomings, name: entry.name, date: string2Date(s: entry.date), cost: forTrailingZero(temp: entry.cost), type: entry.type, sub: entry.sub ?? false, cc: Currency(rawValue:entry.cc) ?? .CAD, id: entry.id)
        }
    }
}

struct DebtPaymentView: View {
    var entry: DebtPaymentEntry;
    
    @Binding var debts: [DebtPaymentEntry]
    
    @State var debtSheet = false;

    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");
    @AppStorage("currency") var c: String = UserDefaults.standard.string(forKey: "currency") ?? "CAD";
    @AppStorage("showBreakdown") var showBreakdown: Bool = UserDefaults.standard.bool(forKey: "showBreakdown");
    
    var perc: Double { return Double(round(100 * (entry.paid / entry.amount)) / 100) * 100 }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if(showBreakdown) {
                        VStack {
                            HStack {
                                Text(entry.name)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal)
                                    .padding(.top, GlobalProps.PS)
                                Spacer()
                            }
                            HStack {
                                Text(entry.date)
                                    .font(.caption)
                                    .padding(.horizontal)
                                    .padding(.bottom, GlobalProps.PS)
                                Spacer()
                            }
                        }
                    } else {
                        Text(entry.name + " • " + entry.date)
                            .multilineTextAlignment(.leading)
                            .padding([.horizontal])
                            .padding(.vertical, GlobalProps.PS)
                    }
                    Spacer()
                    if(showBreakdown) {
                        VStack {
                            HStack {
                                Spacer()
                                Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.amount - entry.paid)))
                                    .padding([.leading, .trailing])
                                    .padding(.top, GlobalProps.PS)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Spacer()
                                Text(checkPunctuation(showSymbols: showSymbols, showCurrency: false, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.paid)) + " paid")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Text(",")
                                    .font(.caption)
                                    .padding(.horizontal, -8)
                                Text(checkPunctuation(showSymbols: showSymbols, showCurrency: false, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.amount)) + " sum")
                                    .font(.caption)
                                    .padding(.trailing)
                                    .padding(.leading, -8)
                                    .foregroundColor(.red)
                            }
                                .padding(.bottom, GlobalProps.PS)
                        }
                    } else {
                        Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.amount)))
                            .multilineTextAlignment(.trailing)
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                    }
                }
                Divider()
                VStack {
                    ProgressView(value: Float(entry.paid/entry.amount))
                        .padding(.bottom, -3.0)
                        .padding(.top, GlobalProps.PS)
                        .progressViewStyle(LinearProgressViewStyle(tint: (entry.paid/entry.amount == 1) ? Color.green : Color.blue))
                    HStack {
                        Text(forTrailingZero(temp: entry.paid))
                            .font(.footnote)
                            .multilineTextAlignment(.trailing)
                        Spacer()
                        Text(forTrailingZero(temp: perc) + "%")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Text(forTrailingZero(temp: entry.amount))
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                    }
                        .padding(.top, 0)
                        .padding(.bottom, GlobalProps.PS)
                }
                    .padding(.horizontal)
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

struct WishlistPaymentView: View {
    var entry: WishlistEntry;
    
    @Binding var wishes: [WishlistEntry]

    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");
    @AppStorage("currency") var c: String = UserDefaults.standard.string(forKey: "currency") ?? "CAD";
    
    @State var wishSheet = false;
    
    var body: some View {
        VStack {
            HStack {
                Text(entry.name)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.cost)))
                    .multilineTextAlignment(.trailing)
            }
                .padding(.horizontal)
                .padding(.vertical, GlobalProps.PS)
            Divider()
            HStack {
                if(GlobalProps.SupportedIcons.contains(entry.type)) {
                    HStack {
                        Link(entry.type, destination: URL(string: entry.link)!)
                            .multilineTextAlignment(.trailing)
                            .padding(.leading)
                        Spacer()
                        Image("vendors/"+entry.type)
                            .resizable()
                            .background(Color.white)
                            .frame(width: 25, height: 25, alignment: .leading)
                            .cornerRadius(5)
                            .padding(.trailing)
                    }
                } else {
                    Link(entry.type, destination: URL(string: entry.link)!)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                }
            }
                .padding(.vertical, GlobalProps.PS)
        }.contextMenu {
            ContextMenuEdit(showEditSheet: $wishSheet)
            ContextMenuDeleteWish(wishes: $wishes, toDelete: entry)
        }.sheet(isPresented: $wishSheet) {
            WishlistEditForm(wishes: $wishes, name: entry.name, link: entry.link, cost: forTrailingZero(temp: entry.cost), type: entry.type, cc: Currency(rawValue:entry.cc) ?? .CAD, id: entry.id)
        }
    }
}
