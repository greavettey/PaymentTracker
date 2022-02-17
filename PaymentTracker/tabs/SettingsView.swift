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

    @State private var selectedCurrency: Currency = Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "CAD") ?? .CAD
    @State private var notifications: Bool = UserDefaults.standard.bool(forKey: "notifications");
    @State private var startPage: StartPage = StartPage(rawValue: UserDefaults.standard.string(forKey: "startPage") ?? "upcoming") ?? .upcoming
    
    private var caught = UserDefaults.standard.bool(forKey: "notifications") ? true : false
    private var build: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "[??]"
    
    @State private var showSwitcher: Bool = false;
    @State private var iconIndex: Int = GlobalProps.AppIcons.firstIndex{ ((UIApplication.shared.alternateIconName != nil) ? UIApplication.shared.alternateIconName! : Bundle.main.name!).starts(with: $0 ) } ?? 0

        
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
                    Section(header: Text("UI"), footer: Text("Notifications are always delivered at 12:01 AM UTC.")) {
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
                        Toggle("Dark Mode", isOn: $darkMode)
                            .padding()
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
                            .padding()
                    }
                    Section(header: Text("Currency"), footer: pricePreview(showSymbols: $showSymbols, showCC: $showCC, selectedCurrency: $selectedCurrency)) {
                        
                        //Weird work around for the label attribute not showing.
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
                        
                        //These labels work though...
                        Toggle("Show Symbols", isOn: $showSymbols)
                            .padding()
                        Toggle("Show CCs", isOn: $showCC)
                            .padding()
                    }
                    Section(header: Text("App Info"), footer: Text("Created by Axel Greavette")) {
                        Link("Report a bug", destination: URL(string: "https://github.com/axelgrvt/payment-tracker/issues/new?labels=bug")!)
                            .padding()
                        Link("Suggest a feature", destination: URL(string: "https://github.com/axelgrvt/payment-tracker/issues/new?labels=feature")!)
                            .padding()
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
                            Text("Thurs., Feb 17th")
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
                Text(try! AttributedString(markdown: "Prices will be shown with currency symbols and codes. For example: **" + selectedCurrency.symbol + "100 " + selectedCurrency.rawValue.uppercased() + "**"))
            } else if (showSymbols && !showCC) {
                Text(try! AttributedString(markdown: "Prices will be shown with currency symbols. For example: **" + selectedCurrency.symbol + "100**"))
            } else if (showCC && !showSymbols){
                Text(try! AttributedString(markdown: "Prices will be shown with currency codes. For example: **100 " + selectedCurrency.rawValue.uppercased() + "**"))
            } else {
                Text("Prices will be shown without currency codes or symbols. For example: **100**")
            }
        }
    }
}
