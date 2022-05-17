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
    @State var sub: Bool = false;
    
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
                        .multilineTextAlignment(.leading)
                    TextField("10 Oil Barrels", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
                Divider()
                HStack {
                    DatePicker( "Due", selection: $date, in: Date.tomorrow.dayAfter..., displayedComponents: [.date])
                        .padding(.horizontal)
                        .padding(.vertical, GlobalProps.PS)
                }
                Divider()
                HStack {
                    Text("Cost")
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, GlobalProps.PS)
                    TextField("100", text: $cost)
                        .padding(.horizontal)
                        .padding(.vertical, GlobalProps.PS)
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
                                .multilineTextAlignment(.trailing)
                        }
                    })
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                        .multilineTextAlignment(.leading)
                        
                }
                    .padding(.horizontal)
                Divider()
                HStack {
                    Text("Subscription")
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, GlobalProps.PS)
                    Spacer()
                    CheckBoxView(checked: $sub)
                        .padding(.vertical, GlobalProps.PS)
                }
                    .padding(.horizontal)
                Divider()
                HStack {
                    Text("Vendor")
                        .multilineTextAlignment(.leading)
                    TextField("ACME Co.", text: $type)
                        .multilineTextAlignment(.trailing)
                }
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
            }
        }
        Button {            
            let tmp = UpcomingPaymentEntry(name: name, date: date2String(d: date), cost: Double(cost)!, type: type, sub: sub, cc: cc.rawValue)
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
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
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
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isValid ? Color.green : Color.red)
                Spacer()
            }
        }.disabled(!isValid)
    }
}


struct WishlistEntryForm: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var wishes: [WishlistEntry]
        
    @State var name: String = "";
    @State var cost: String = "";
    @State var type: String = "";
    
    @State var cc: Currency = Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "cad") ?? .CAD;
    @State var link: String = "";
    
    var isValid: Bool {
            !name.isEmpty &&
            !link.isEmpty &&
            !cost.isEmpty &&
            !type.isEmpty
    }
        
    var body: some View {
        Section(footer: footer(v: isValid)) {
            VStack {
                HStack {
                    Text("Title")
                        .multilineTextAlignment(.leading)
                    TextField("Moai Statue", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)

                Divider()
                HStack {
                    Text("Cost")
                        .multilineTextAlignment(.leading)
                    TextField("10000", text: $cost)
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
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
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
                    Text("Vendor")
                        .multilineTextAlignment(.leading)
                    TextField("Chile", text: $type)
                        .multilineTextAlignment(.trailing)
                }
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
                Divider()
                HStack {
                    Text("Link")
                        .multilineTextAlignment(.leading)
                    TextField("https://bitly.com/98K8eH", text: $link)
                        .multilineTextAlignment(.trailing)
                }
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
                
            }
        }
        Button {
            wishes.append(WishlistEntry(name: name, cost: Double(cost)!, type: type, cc: cc.rawValue, link: link))
            dismiss()
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
