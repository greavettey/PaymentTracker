//
//  SettingsView.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI
import Foundation

struct SettingsView: View {
    @AppStorage("darkMode") var darkMode: Bool = UserDefaults.standard.bool(forKey: "darkMode");
    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");
    
    // Currently in beta
    @AppStorage("showWishlist") var showWishlist: Bool = UserDefaults.standard.bool(forKey: "showWishlist");
    @AppStorage("showBreakdown") var showBreakdown: Bool = UserDefaults.standard.bool(forKey: "showBreakdown");
    @AppStorage("showAdded") var showAdded: Bool = UserDefaults.standard.bool(forKey: "showAdded");

    @State private var selectedCurrency: Currency = Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "CAD") ?? .CAD
    @State private var notifications: Bool = UserDefaults.standard.bool(forKey: "notifications");
    
    @State private var startPage: Int = UserDefaults.standard.integer(forKey: "startPage");
    private var possibleStartPages: [String] = UserDefaults.standard.bool(forKey: "showWishlist") ? ["Upcoming", "Debts", "Wishlist"] : ["Upcoming", "Debts"];
    
    private var caught = UserDefaults.standard.bool(forKey: "notifications") ? true : false
    
    @State private var showSwitcher: Bool = false;
    @State private var iconIndex: Int = GlobalProps.AppIcons.firstIndex{ ((UIApplication.shared.alternateIconName != nil) ? UIApplication.shared.alternateIconName! : Bundle.main.name!).starts(with: $0 ) } ?? 0
    
    @State private var showPatchnotes: Bool = false;
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack{
                    Text("Settings")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    Button {
                        showSwitcher.toggle()
                    } label: {
                        Image(uiImage: UIImage(named: GlobalProps.AppIcons[iconIndex]) ?? UIImage())
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .leading)
                            .cornerRadius(5)
                            .padding()
                    }
                }
                List {
                    Section(header: Text("UI"), footer: Text("Notifications are always delivered at 1 am local time.")) {
                        HStack {
                            Text("Default Page")
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Spacer()
                            Picker(selection: $startPage, label: Text("Select your default page"), content: {
                                ForEach(0 ..< possibleStartPages.count) {
                                    Text(possibleStartPages[$0])
                                }
                            }).onChange(of: startPage, perform: { p in
                                startPage = 0
                                UserDefaults.standard.set(startPage, forKey: "startPage")
                            })
                                .pickerStyle(MenuPickerStyle())
                                .labelsHidden()
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                                .multilineTextAlignment(.leading)
                        }
                        Toggle(isOn: $showWishlist) {
                            Text("Show Wishlist")
                            BetaBadge()
                        }.onChange(of: showWishlist) { _ in
                            startPage = 0;
                            //UserDefaults.standard.set(0, forKey: "startPage")
                        }
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                        Toggle(isOn: $showAdded) {
                            Text("Show Entry Dates")
                            BetaBadge()
                        }
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                        Toggle("Dark Mode", isOn: $darkMode)
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                        Toggle("Notifications", isOn: $notifications)
                            .onChange(of: notifications, perform: { _ in
                                if(caught) {
                                    return;
                                } else {
                                    return UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                        if success && !caught {
                                            return UserDefaults.standard.set(true, forKey: "notifications")
                                        } else if let error = error {
                                            print(error.localizedDescription)
                                            return UserDefaults.standard.set(false, forKey: "notifications")
                                        }
                                    };
                                }
                            })
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                    }
                    Section(header: Text("Currency"), footer: pricePreview(showSymbols: $showSymbols, showCC: $showCC, selectedCurrency: $selectedCurrency, showDB: $showBreakdown)) {
                        
                        //Weird work around for the label attribute not showing.
                        HStack {
                            Text("Default Currency")
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Spacer()
                            Picker(selection: $selectedCurrency, label: Text("Select your default currency"), content: {
                                ForEach(Currency.allCases, id: \.self) {
                                    Text($0.symbol + " " + $0.rawValue.uppercased())
                                }
                            }).onChange(of: selectedCurrency, perform: { c in
                                UserDefaults.standard.set(c.rawValue, forKey: "currency")
                            })
                                .pickerStyle(MenuPickerStyle())
                                .labelsHidden()
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                                .multilineTextAlignment(.leading)
                        }
                        
                        //These labels work though...
                        Toggle("Show Symbols", isOn: $showSymbols)
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                        Toggle("Show Codes", isOn: $showCC)
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                        Toggle(isOn: $showBreakdown) {
                            Text("Show Breakdown")
                            BetaBadge()
                        }
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                    }
                    Section(header: Text("App Info"), footer: Text("Created by Axel Greavette")) {
                        HStack {
                            Link("Report a bug", destination: URL(string: "https://github.com/axelgrvt/payment-tracker/issues/new?labels=bug")!)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Spacer()
                            Image(systemName: "arrow.up.forward.app")
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                                .foregroundColor(Color.blue)
                                .font(.body)
                        }
                        HStack {
                            Link("Suggest a feature", destination: URL(string: "https://github.com/axelgrvt/payment-tracker/issues/new?labels=feature")!)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Spacer()
                            Image(systemName: "arrow.up.forward.app")
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                                .foregroundColor(Color.blue)
                                .font(.body)
                        }
                        Button {
                            showPatchnotes.toggle()
                        } label: {
                            HStack {
                                Text("Patch Notes")
                                    .padding(.horizontal)
                                    .padding(.vertical, GlobalProps.PS)
                                Spacer()
                                Image(systemName: "arrow.up.forward.app")
                                    .padding(.horizontal)
                                    .padding(.vertical, GlobalProps.PS)
                                    .font(.body)
                            }
                        }
                        HStack {
                            Text("Version")
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Spacer()
                            Text((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "[??]") + " [" + (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "??") + "]")
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                        }
                        HStack {
                            Text("Last Updated")
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Spacer()
                            Text(Bundle.main.infoDictionary?["LastUpdated"] as? String ?? "[??]")
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                        }
                    }
                }.listStyle(.insetGrouped)
            }
        }.sheet(isPresented: $showSwitcher, content: {
            IconSwitch(index: $iconIndex)
        }).sheet(isPresented: $showPatchnotes, content: {
            PatchNotes()
        })
        
    }
}
