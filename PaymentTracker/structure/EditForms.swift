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
    @State var sub: Bool;
    
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
                                    .padding(.horizontal)
                                    .padding(.vertical, GlobalProps.PS)
                                TextField("100", text: $cost)
                                    .padding(.vertical, GlobalProps.PS)
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
                                    .padding(.trailing)
                                    .padding(.vertical, GlobalProps.PS)
                                    .multilineTextAlignment(.leading)
                                    
                            }
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
                                    .padding(.leading)
                                TextField("ACME Co.", text: $type)
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                            }
                                .padding(.vertical, GlobalProps.PS)
                        }
                    }
                    Button {
                        let orig = upcomings.firstIndex{ $0.id == id }!
                        let new = UpcomingPaymentEntry(name: name, date: date2String(d: date), cost: Double(cost)!, type: type, sub: sub, cc: cc.rawValue)
                        
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
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
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


struct WishlistEditForm: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var wishes: [WishlistEntry]
        
    @State var name: String;
    @State var link: String;
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
                                    .multilineTextAlignment(.leading)
                                TextField("Moai Statue", text: $name)
                                    .multilineTextAlignment(.trailing)
                            }
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Divider()
                            HStack {
                                Text("Cost")
                                    .padding(.horizontal)
                                    .padding(.vertical, GlobalProps.PS)
                                    .multilineTextAlignment(.leading)
                                TextField("10000", text: $cost)
                                    .padding(.vertical, GlobalProps.PS)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(cost)) { newValue in
                                        self.cost = checkInput(original: newValue)

                                    }
                                Picker(selection: $cc, label: Text("Choose the payment currency"), content: {
                                    ForEach(Currency.allCases, id: \.self) {
                                        Text($0.rawValue.uppercased())
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
                        let orig = wishes.firstIndex{ $0.id == id }!
                        let new = WishlistEntry(name: name, cost: Double(cost)!, type: type, cc: cc.rawValue, link: link)
                        
                        wishes[orig] = new;
                                        
                        dismiss()
                        
                        
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
                    }.disabled(name.isEmpty || link.isEmpty || cost.isEmpty || type.isEmpty)
                }
            }
        }
    }
}
