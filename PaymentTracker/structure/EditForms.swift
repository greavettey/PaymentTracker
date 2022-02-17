//
//  EditForm.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-09.
//

import Combine
import SwiftUI

struct UpcomingEditForm: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var upcomings: [UpcomingPaymentEntry]
        
    @State var name: String;
    @State var date: Date;
    @State var cost: String
    @State var type: String;
    
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
                                        self.cost = checkInput(original: newValue)

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
                        let orig = upcomings.firstIndex{ $0.id == id }!
                        let new = UpcomingPaymentEntry(name: name, date: date2String(d: date), cost: Double(cost)!, type: type, cc: cc.rawValue)
                        
                        upcomings[orig] = new;
                        
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
                        queueNotification(t: 1, name: new.name, cost: forTrailingZero(temp: new.cost), date: string2Date(s: new.date), id: new.id)
                        
                        dismiss()
                        
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text("Save")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.blue)
                                .padding()
                            Spacer()
                        }
                    }.disabled(name.isEmpty || date.description.isEmpty || cost.isEmpty || type.isEmpty)
                }
            }
        }
    }
}

struct DebtEditForm: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var debts: [DebtPaymentEntry]
        
    @State var name: String;
    @State var date: Date;
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
                                        self.paid = checkInput(original: newValue)
                                    }
                                Text(cc.rawValue.uppercased())
                                    .padding()
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                    Button {
                        let orig = debts.firstIndex{ $0.id == id }!
                        let new = (DebtPaymentEntry(name: name, date: date2String(d: date), amount: Double(amount)!, paid: Double(paid)!, cc: cc.rawValue))
                        
                        debts[orig] = new
                        
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
                        queueNotification(t: 2, name: new.name, cost: forTrailingZero(temp: new.amount-new.paid), date: string2Date(s: new.date), id: new.id)

                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Save")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.blue)
                                .padding()
                            Spacer()
                        }
                    }.disabled(name.isEmpty || date.description.isEmpty || amount.isEmpty || paid.isEmpty)
                }
            }
        }
    }
}
