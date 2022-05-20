//
//  Wishlist.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-19.
//

import Foundation
import SwiftUI
import Combine

// Payment View
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
                Link(entry.name, destination: URL(string: entry.link)!)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(checkPunctuation(showSymbols: showSymbols, showCurrency: showCC, globalDefault: c, def: entry.cc, value: forTrailingZero(temp: entry.cost)))
                    .multilineTextAlignment(.trailing)
            }
                .padding(.horizontal)
                .padding(.vertical, GlobalProps.PS)
        }.contextMenu {
            ContextMenuEdit(showEditSheet: $wishSheet)
            ContextMenuDeleteWish(wishes: $wishes, toDelete: entry)
        }.sheet(isPresented: $wishSheet) {
            WishlistEditForm(wishes: $wishes, name: entry.name, link: entry.link, cost: forTrailingZero(temp: entry.cost), type: entry.type, added: entry.added ?? "04/03/1984", cc: Currency(rawValue:entry.cc) ?? .CAD, id: entry.id)
        }
    }
}

// Entry Form
struct WishlistEntryForm: View {
    @Environment(\.presentationMode) var presentationMode

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
            wishes.append(WishlistEntry(name: name, cost: Double(cost)!, type: type, added: date2String(d: Date()), edited: nil, cc: cc.rawValue, link: link))
            self.presentationMode.wrappedValue.dismiss()
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

// Edit Form
struct WishlistEditForm: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var wishes: [WishlistEntry]
        
    @State var name: String;
    @State var link: String;
    @State var cost: String
    @State var type: String;
    @State var added: String;
    
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
                        let new = WishlistEntry(name: name, cost: Double(cost)!, type: type, added: added, edited: date2String(d: Date()), cc: cc.rawValue, link: link)
                        
                        wishes[orig] = new;
                                        
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
                    }.disabled(name.isEmpty || link.isEmpty || cost.isEmpty || type.isEmpty)
                }
            }
        }
    }
}
