//
//  EntryForms.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-06.
//

import SwiftUI
import Combine

struct UpcomingEntryForm: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var upcomings: [UpcomingPaymentEntry]
    
    var notifications = UserDefaults.standard.bool(forKey: "notifications")
    
    @State var name: String = "";
    @State var date: Date = Date();
    @State var cost: String = "";
    @State var type: String = "";
    
    @State var cc: Currency = Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "cad") ?? .CAD;
    
    var isValid: Bool {
            !name.isEmpty &&
            !date.description.isEmpty &&
            !cost.isEmpty &&
            !type.isEmpty
    }
        
    var body: some View {
        Section(footer: footer(v: isValid)) {
            VStack {
                HStack {
                    Text("Title")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("", text: $name)
                        .padding()
                        .multilineTextAlignment(.trailing)
                }
                Divider()
                    .padding(.vertical, -4.0)
                HStack {
                    DatePicker( "Due", selection: $date, in: Date.tomorrow.dayAfter..., displayedComponents: [.date])
                        .padding()
                }
                Divider()
                    .padding(.vertical, -4.0)
                HStack {
                    Text("Cost")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("", text: $cost)
                        .padding()
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onReceive(Just(cost)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.cost = filtered
                            }
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
                        .padding()
                        .multilineTextAlignment(.leading)
                        
                }
                Divider()
                    .padding(.horizontal)
                HStack {
                    Text("Vendor")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("", text: $type)
                        .padding()
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        Button {            
            let tmp = UpcomingPaymentEntry(name: name, date: date2String(d: date), cost: Double(cost)!, type: type, cc: cc.rawValue)
            upcomings.append(tmp)
            
            if (!notifications) {
                dismiss()
            } else {
                queueNotification(t: 1, name: name, cost: cost, date: date, id: tmp.id)
                dismiss()
            }
        } label: {
            HStack {
                Spacer()
                Text("Save")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isValid ? Color.green : Color.red)
                    .padding()
                Spacer()
            }
        }.disabled(!isValid)
    }
}

struct DebtEntryForm: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var debts: [DebtPaymentEntry]
    
    var notifications = UserDefaults.standard.bool(forKey: "notifications")
    
    @State var name: String = "";
    @State var date: Date = Date();
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
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("", text: $name)
                        .padding()
                        .multilineTextAlignment(.trailing)
                }
                Divider()
                    .padding(.vertical, -4.0)
                HStack {
                    DatePicker( "Due", selection: $date, in: Date.tomorrow.dayAfter..., displayedComponents: [.date])
                        .padding()
                }
                Divider()
                    .padding(.vertical, -4.0)
                HStack {
                    Text("Amount")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("", text: $amount)
                        .padding()
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onReceive(Just(amount)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.amount = filtered
                            }
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
                        .padding()
                        .multilineTextAlignment(.leading)
                        
                }
                Divider()
                    .padding(.horizontal)
                HStack {
                    Text("Paid")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("", text: $paid)
                        .padding()
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onReceive(Just(paid)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.paid = filtered
                            }
                        }
                    Text(cc.rawValue.uppercased())
                        .padding()
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        Button {
            let tmp = DebtPaymentEntry(name: name, date: date2String(d: date), amount: Double(amount)!, paid: Double(paid)!, cc: cc.rawValue)
            debts.append(tmp)
            
            if (!notifications) {
                dismiss()
            } else {
                queueNotification(t: 2, name: name, cost: forTrailingZero(temp: tmp.amount-tmp.paid), date: date, id: tmp.id)
                dismiss()
            }
            dismiss()
        } label: {
            HStack {
                Spacer()
                Text("Save")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isValid ? Color.green : Color.red)
                    .padding()
                Spacer()
            }
        }.disabled(!isValid)
    }
}

struct footer: View {
    var v: Bool
    var body: some View {
        if(v) {
            HStack {
                Image(systemName: "checkmark.square.fill")
                Text("All fields are filled.")
            }
        } else {
            HStack {
                Image(systemName: "x.square.fill")
                Text("All fields must be filled.")
            }
        }
    }

}
