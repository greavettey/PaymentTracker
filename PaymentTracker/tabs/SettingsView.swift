//
//  SettingsView.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("darkMode") var darkMode: Bool = UserDefaults.standard.bool(forKey: "darkMode");
    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");

    @State private var selectedCurrency: Currency = Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "CAD") ?? .CAD
    @State private var notifications: Bool = UserDefaults.standard.bool(forKey: "notifications");
    @State private var startPage: StartPage = StartPage(rawValue: UserDefaults.standard.string(forKey: "startPage") ?? "upcoming") ?? .upcoming
    
    private var caught = UserDefaults.standard.bool(forKey: "notifications") ? true : false
    private var build: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "[??]"
    
    @State private var showSwitcher: Bool = false;
    @State private var iconIndex: Int = ["AppIcon", "Royalty", "Periwinkle", "Eyebite", "Subdued"].firstIndex{ ((UIApplication.shared.alternateIconName != nil) ? UIApplication.shared.alternateIconName! : Bundle.main.name!).starts(with: $0 ) } ?? 0

        
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
                        Image(uiImage: UIImage(named: ["AppIcon", "Royalty", "Periwinkle", "Eyebite", "Subdued"][iconIndex]) ?? UIImage())
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .leading)
                            .cornerRadius(5)
                            .padding()
                    }
                }
                List {
                    Section(header: Text("UI"), footer: Text("Notifications are always delivered at 12:01 AM.")) {
                        HStack {
                            Text("Default Page")
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                            Picker(selection: $startPage, label: Text("Select your default page"), content: {
                                ForEach(StartPage.allCases, id: \.self) {
                                    Text($0.rawValue.capitalized)
                                }
                            }).onChange(of: startPage, perform: { p in
                                UserDefaults.standard.set(p.rawValue, forKey: "startPage")
                            })
                                .pickerStyle(MenuPickerStyle())
                                .labelsHidden()
                                .padding()
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Text("Dark Mode")
                                .multilineTextAlignment(.leading)
                                .padding()
                            Toggle("", isOn: $darkMode)
                                .padding()
                        }
                        HStack {
                            Text("Notifications")
                                .multilineTextAlignment(.leading)
                                .padding()
                            Toggle("", isOn: $notifications)
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
                                .padding()
                        }
                    }
                    Section(header: Text("Currency"), footer: pricePreview(showSymbols: $showSymbols, showCC: $showCC, selectedCurrency: $selectedCurrency)) {
                        HStack {
                            Text("Default Currency")
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                            Picker(selection: $selectedCurrency, label: Text("Select your default currency"), content: {
                                ForEach(Currency.allCases, id: \.self) {
                                    Text($0.rawValue.uppercased())
                                }
                            }).onChange(of: selectedCurrency, perform: { c in
                                UserDefaults.standard.set(c.rawValue, forKey: "currency")
                            })
                                .pickerStyle(MenuPickerStyle())
                                .labelsHidden()
                                .padding()
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Text("Show Symbols")
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                            Toggle("", isOn: $showSymbols)
                                .padding()
                        }
                        HStack {
                            Text("Show CCs")
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                            Toggle("", isOn: $showCC)
                                .padding()
                        }
                        
                    }
                    Section(header: Text("App Info"), footer: Text("Created by Axel Greavette")) {
                        HStack {
                            Text("Version")
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                            Text(build)
                                .multilineTextAlignment(.trailing)
                                .padding()
                        }
                        HStack {
                            Text("Last Updated")
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                            Text("Sun., Feb 13th")
                                .multilineTextAlignment(.trailing)
                                .padding()
                        }
                    }
                }.listStyle(.insetGrouped)
            }
        }.sheet(isPresented: $showSwitcher, content: {
            IconSwitch()
        })
    }
}


struct pricePreview: View {
    @Binding var showSymbols: Bool
    @Binding var showCC: Bool
    @Binding var selectedCurrency: Currency
    
    var body: some View {
        VStack {
            if(showSymbols && showCC) {
                Text("Prices will be shown with currency symbols and codes. For example:")
                    .multilineTextAlignment(.leading)
                Text(selectedCurrency.symbol + "100 " + selectedCurrency.rawValue.uppercased())
                    .multilineTextAlignment(.leading)
            } else if (showSymbols && !showCC) {
                Text("Prices will be shown with currency symbols. For example:")
                    .multilineTextAlignment(.leading)
                Text(selectedCurrency.symbol + "100")
                    .multilineTextAlignment(.leading)
            } else if (showCC && !showSymbols){
                Text("Prices will be shown with currency codes. For example: ")
                    .multilineTextAlignment(.leading)
                Text("100 " + selectedCurrency.rawValue.uppercased())
                    .multilineTextAlignment(.leading)
            } else {
                Text("Prices will be shown without currency codes or symbols. For example:")
                    .multilineTextAlignment(.leading)
                Text("100")
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
