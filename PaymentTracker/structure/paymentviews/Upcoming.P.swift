//
//  Upcoming.P.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-19.
//

import Foundation
import SwiftUI
import Combine

//Payment View
struct UpcomingPaymentView: View {
    var entry: UpcomingPaymentEntry;
    
    @Binding var upcomings: [UpcomingPaymentEntry]

    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");
    @AppStorage("currency") var c: String = UserDefaults.standard.string(forKey: "currency") ?? "CAD";
    
    @State var upcomingSheet = false;
    
    var body: some View {
        let v = VStack {
                HStack {
                    Text(entry.name)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.cost)))
                        .multilineTextAlignment(.trailing)
                }
                    .padding(.horizontal)
                    .padding(.vertical, GlobalProps.PS)
            }.sheet(isPresented: $upcomingSheet) {
                UpcomingEditForm(upcomings: $upcomings, name: entry.name, date: string2Date(s: entry.date), cost: forTrailingZero(temp: entry.cost), type: entry.type, sub: entry.sub ?? 0, cc: Currency(rawValue:entry.cc) ?? .CAD, id: entry.id)
            }
        if #available(iOS 15, *) {
            v.swipeActions(allowsFullSwipe: false) {
                SwipeUpcomingActions(showEdit: $upcomingSheet, upcomings: $upcomings, entry: entry)
            }
        } else if #available(iOS 14, *) {
            v.contextMenu {
                ContextMenuEdit(showEditSheet: $upcomingSheet)
                ContextMenuDeleteUpcoming(upcomings: $upcomings, toDelete: entry)
            }
        }
    }
}

// Entry Form
struct UpcomingEntryForm: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var upcomings: [UpcomingPaymentEntry]
    
    var notifications = UserDefaults.standard.bool(forKey: "notifications")
    var notificationTime: Date = (UserDefaults.standard.object(forKey: "notificationTime") as! Date) ;

    @State var name: String = "";
    @State var date: Date = Date().dayAfter;
    @State var cost: String = "";
    @State var type: String = "";
    @State var sub: Int = 0;
    
    @State var cc: Currency = Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "cad") ?? .CAD;
    
    var isValid: Bool {
            !name.isEmpty &&
            !date.description.isEmpty &&
            !cost.isEmpty &&
            !type.isEmpty
    }
        
    var body: some View {
        let _ = print(notificationTime)
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
                    DatePicker( "Due", selection: $date, in: Date.tomorrow..., displayedComponents: [.date])
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
                    Text("Billing")
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, GlobalProps.PS)
                    Spacer()
                    Picker(selection: $sub, label: Text("Choose a subscription period"), content: {
                        ForEach(0 ..< GlobalProps.SubOps.count) {
                            Text(GlobalProps.SubOps[$0])
                                .padding(.horizontal, 0)
                        }
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .fixedSize()
                    .labelsHidden()
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
                self.presentationMode.wrappedValue.dismiss()
            } else {
                queueNotification(t: 1, name: name, cost: cost, sub: sub, date: date, id: tmp.id, delivery: notificationTime)
                self.presentationMode.wrappedValue.dismiss()
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

// Edit Form
struct UpcomingEditForm: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var upcomings: [UpcomingPaymentEntry]
        
    @State var name: String;
    @State var date: Date;
    @State var cost: String
    @State var type: String;
    @State var sub: Int;
    
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
                            HStack {
                                
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
                                Text("Billing")
                                    .multilineTextAlignment(.leading)
                                    .padding(.vertical, GlobalProps.PS)
                                Spacer()
                                Picker(selection: $sub, label: Text("Choose a subscription period"), content: {
                                    ForEach(0 ..< GlobalProps.SubOps.count) {
                                        Text(GlobalProps.SubOps[$0])
                                            .padding(.horizontal, 0)
                                    }
                                })
                                .pickerStyle(SegmentedPickerStyle())
                                .fixedSize()
                                .labelsHidden()
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
                        queueNotification(t: 1, name: new.name, cost: forTrailingZero(temp: new.cost), sub: sub, date: string2Date(s: new.date), id: new.id)
                        
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
                    }.disabled(name.isEmpty || date.description.isEmpty || cost.isEmpty || type.isEmpty)
                }
            }
        }
    }
}
