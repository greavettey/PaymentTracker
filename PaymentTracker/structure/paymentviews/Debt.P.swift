//
//  Debt.P.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-19.
//

import Foundation
import SwiftUI
import Combine

// Payment View
struct DebtPaymentView: View {    
    @Binding var debts: [DebtPaymentEntry]

    var entry: DebtPaymentEntry;
    var perc: Double { return Double(round(100 * (entry.paid / entry.amount)) / 100) * 100 }
    var notifications = UserDefaults.standard.bool(forKey: "notifications")

    @State var debtSheet = false;
    @State var stepperValue: Int = 10

    @AppStorage("debtIncrement") var increment = UserDefaults.standard.double(forKey: "debtIncrement")
    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");
    @AppStorage("currency") var c: String = UserDefaults.standard.string(forKey: "currency") ?? "CAD";
    @AppStorage("showBreakdown") var showBreakdown: Bool = UserDefaults.standard.bool(forKey: "showBreakdown");
    
    var body: some View {
        let v = ZStack {
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
                        Menu {
                            Button(action: {
                                let orig = debts.firstIndex{ $0.id == entry.id }!
                                let new = DebtPaymentEntry(name: entry.name, date: entry.date, added: entry.added, edited: date2String(d: Date()), amount: entry.amount, paid: entry.paid+increment, cc: entry.cc)
                                debts[orig] = new
                                
                                if (notifications){
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [entry.id.uuidString])
                                    queueNotification(t: 2, name: new.name, cost: forTrailingZero(temp: new.amount-new.paid), sub: 0, date: string2Date(s: new.date), id: new.id)
                                }
                            }) {
                                Label("Add \(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: increment)))", systemImage: "plus.circle")
                            }
                            Button(action: {
                                let orig = debts.firstIndex{ $0.id == entry.id }!
                                let new = DebtPaymentEntry(name: entry.name, date: entry.date, added: entry.added, edited: date2String(d: Date()), amount: entry.amount, paid: entry.paid-increment, cc: entry.cc)
                                debts[orig] = new
                                
                                if (notifications){
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [entry.id.uuidString])
                                    queueNotification(t: 2, name: new.name, cost: forTrailingZero(temp: new.amount-new.paid), sub: 0, date: string2Date(s: new.date), id: new.id)
                                }
                            }) {
                                Label("Remove \(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: increment)))", systemImage: "minus.circle")
                            }
                        } label: {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.amount - entry.paid)))
                                        .foregroundColor(.primary)
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
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, -8)
                                    Text(checkPunctuation(showSymbols: showSymbols, showCurrency: false, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.amount)) + " sum")
                                        .font(.caption)
                                        .padding(.trailing)
                                        .padding(.leading, -8)
                                        .foregroundColor(.red)
                                }
                                    .padding(.bottom, GlobalProps.PS)
                            }
                        }
                    } else {
                        Menu {
                            Button(action: {
                                let orig = debts.firstIndex{ $0.id == entry.id }!
                                let new = DebtPaymentEntry(name: entry.name, date: entry.date, added: entry.added, edited: date2String(d: Date()), amount: entry.amount, paid: entry.paid+increment, cc: entry.cc)
                                debts[orig] = new
                                
                                if (notifications){
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [entry.id.uuidString])
                                    queueNotification(t: 2, name: new.name, cost: forTrailingZero(temp: new.amount-new.paid), sub: 0, date: string2Date(s: new.date), id: new.id)
                                }
                            }) {
                                Label("Add \(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: increment)))", systemImage: "plus.circle")
                            }
                            Button(action: {
                                let orig = debts.firstIndex{ $0.id == entry.id }!
                                let new = DebtPaymentEntry(name: entry.name, date: entry.date, added: entry.added, edited: date2String(d: Date()), amount: entry.amount, paid: entry.paid-increment, cc: entry.cc)
                                debts[orig] = new
                                
                                if (notifications){
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [entry.id.uuidString])
                                    queueNotification(t: 2, name: new.name, cost: forTrailingZero(temp: new.amount-new.paid), sub: 0, date: string2Date(s: new.date), id: new.id)
                                }
                            }) {
                                Label("Remove \(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: increment)))", systemImage: "minus.circle")
                            }
                        } label: {
                            Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.amount)))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                        }
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
        }.sheet(isPresented: $debtSheet) {
            DebtEditForm(debts: $debts, name: entry.name, date: string2Date(s: entry.date), added: entry.added ?? "12/27/2002", amount: forTrailingZero(temp: entry.amount), paid: forTrailingZero(temp: entry.paid), cc: Currency(rawValue:entry.cc) ?? .CAD, id: entry.id)
        }
        
        if #available(iOS 15, *) {
            v.swipeActions(allowsFullSwipe: false) {
                SwipeDebtActions(showEdit: $debtSheet, debts: $debts, entry: entry)
            }
        } else if #available(iOS 14, *) {
            v.contextMenu {
                ContextMenuEdit(showEditSheet: $debtSheet)
                if(entry.paid/entry.amount != 1){ ContextMenuMarkAsPaid(debts: $debts, toFinish: entry.id) }
                ContextMenuDeleteDebt(debts: $debts, toDelete: entry)
            }
        }
    }
}

// Entry Form
struct DebtEntryForm: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var debts: [DebtPaymentEntry]
    
    var notifications = UserDefaults.standard.bool(forKey: "notifications")
    
    @State var name: String = "";
    @State var date: Date = Date().dayAfter;
    @State var amount: String = "";
    @State var paid: String = "";
    
    @State var cc: Currency = Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "cad") ?? .CAD;
    
    var isValid: Bool {
            !name.isEmpty &&
            !date.description.isEmpty &&
            !amount.isEmpty &&
            !paid.isEmpty
    }
    
    var body: some View {
        Section(footer: footer(v: isValid)) {
            VStack {
                HStack {
                    Text("Owed to")
                        .multilineTextAlignment(.leading)
                    TextField("Stephen Strange", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
                Divider()
                HStack {
                    DatePicker("Due", selection: $date, in: Date.tomorrow.dayAfter..., displayedComponents: [.date])
                        .padding(.horizontal)
                        .padding(.vertical, GlobalProps.PS)
                }
                Divider()
                HStack {
                    Text("Amount")
                        .multilineTextAlignment(.leading)
                    TextField("50", text: $amount)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                        .padding(.vertical, GlobalProps.PS)
                        .onReceive(Just(amount)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.amount = filtered
                            }
                        }
                    Picker(selection: $cc, label: Text("Choose the payment currency"), content: {
                        ForEach(Currency.allCases, id: \.self) {
                            Text($0.rawValue.uppercased())
                                .multilineTextAlignment(.trailing)
                        }
                    })
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                        .multilineTextAlignment(.leading)
                        
                }
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
                Divider()
                HStack {
                    Text("Paid")
                        .multilineTextAlignment(.leading)
                    TextField("21", text: $paid)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onReceive(Just(paid)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.paid = filtered
                            }
                        }
                    Text(cc.rawValue.uppercased())
                        .multilineTextAlignment(.trailing)
                }
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)

            }
        }
        Button {
            let tmp = DebtPaymentEntry(name: name, date: date2String(d: date), added: date2String(d: Date()), edited: nil, amount: Double(amount)!, paid: Double(paid)!, cc: cc.rawValue)
            debts.append(tmp)
            
            if (!notifications) {
                self.presentationMode.wrappedValue.dismiss()
            } else {
                queueNotification(t: 2, name: name, cost: forTrailingZero(temp: tmp.amount-tmp.paid), sub: 0, date: date, id: tmp.id)
                self.presentationMode.wrappedValue.dismiss()
            }
        } label: {
            HStack {
                Spacer()
                Text("Save")
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isValid ? Color.green : Color.red)
                Spacer()
            }
        }.disabled(!isValid)
    }
}

// Edit Form
struct DebtEditForm: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var debts: [DebtPaymentEntry]
        
    @State var name: String;
    @State var date: Date;
    @State var added: String;
    @State var amount: String
    @State var paid: String;
    
    @State var cc: Currency;
    @State var id: UUID
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack{
                    Text("Edit Entry")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "x.square.fill")
                            .padding()
                            .font(.title)
                    }
                }
                Spacer()
                Form {
                    Section {
                        VStack {
                            HStack {
                                Text("Owed to")
                                    .multilineTextAlignment(.leading)
                                TextField("Stephen Strange", text: $name)
                                    .multilineTextAlignment(.trailing)
                            }
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Divider()
                            HStack {
                                DatePicker("Due", selection: $date, in: Date.tomorrow.dayAfter..., displayedComponents: [.date])
                                    .padding(.horizontal)
                                    .padding(.vertical, GlobalProps.PS)
                            }
                            Divider()
                            HStack {
                                Text("Amount")
                                    .padding(.horizontal)
                                    .padding(.vertical, GlobalProps.PS)
                                    .multilineTextAlignment(.leading)
                                TextField("50", text: $amount)
                                    .padding(.vertical, GlobalProps.PS)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(amount)) { newValue in
                                        self.amount = checkInput(original: newValue)
                                    }
                                Picker(selection: $cc, label: Text("Choose the payment currency"), content: {
                                    ForEach(Currency.allCases, id: \.self) {
                                        Text($0.rawValue.uppercased())
                                            .padding()
                                            .multilineTextAlignment(.trailing)
                                    }
                                })
                                    .pickerStyle(MenuPickerStyle())
                                    .labelsHidden()
                                    .padding(.trailing)
                                    .padding(.vertical, GlobalProps.PS)
                                    .multilineTextAlignment(.leading)
                                    
                            }
                            Divider()
                            HStack {
                                Text("Paid")
                                    .padding(.horizontal)
                                    .padding(.vertical, GlobalProps.PS)
                                    .multilineTextAlignment(.leading)
                                TextField("21", text: $paid)
                                    .padding(.vertical, GlobalProps.PS)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(paid)) { newValue in
                                        self.paid = checkInput(original: newValue)
                                    }
                                Text(cc.rawValue.uppercased())
                                    .padding(.trailing)
                                    .padding(.vertical, GlobalProps.PS)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                    Button {
                        let orig = debts.firstIndex{ $0.id == id }!
                        let new = (DebtPaymentEntry(name: name, date: date2String(d: date), added: added, edited: date2String(d: Date()), amount: Double(amount)!, paid: Double(paid)!, cc: cc.rawValue))
                        
                        debts[orig] = new
                        
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
                        queueNotification(t: 2, name: new.name, cost: forTrailingZero(temp: new.amount-new.paid), sub: 0, date: string2Date(s: new.date), id: new.id)

                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Save")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.blue)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Spacer()
                        }
                    }.disabled(name.isEmpty || date.description.isEmpty || amount.isEmpty || paid.isEmpty)
                }
            }
        }
    }
}
