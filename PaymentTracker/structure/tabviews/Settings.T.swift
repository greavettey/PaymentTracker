//
//  Settings.T.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI
import Foundation

struct SettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var appearance: Int = UserDefaults.standard.integer(forKey: "appearance");
    @AppStorage("showSymbols") var showSymbols: Bool = UserDefaults.standard.bool(forKey: "showSymbols");
    @AppStorage("showCC") var showCC: Bool = UserDefaults.standard.bool(forKey: "showCC");
    @AppStorage("showWishlist") var showWishlist: Bool = UserDefaults.standard.bool(forKey: "showWishlist");
    @AppStorage("showBreakdown") var showBreakdown: Bool = UserDefaults.standard.bool(forKey: "showBreakdown");
    @AppStorage("showAdded") var showAdded: Bool = UserDefaults.standard.bool(forKey: "showAdded");
    @AppStorage("debtIncrement") var increment = UserDefaults.standard.double(forKey: "debtIncrement")

    @State private var selectedCurrency: Currency = Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "CAD") ?? .CAD
    @State private var notifications: Bool = UserDefaults.standard.bool(forKey: "notifications");
    private var caught = UserDefaults.standard.bool(forKey: "notifications") ? true : false
    @State private var currentDate: Date = (UserDefaults.standard.object(forKey: "notificationTime") as! Date) 

    @State private var startPage: Int = UserDefaults.standard.integer(forKey: "startPage");
    private var possibleStartPages: [String] = UserDefaults.standard.bool(forKey: "showWishlist") ? ["Upcoming", "Debts", "Wishlist"] : ["Upcoming", "Debts"];
        
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
                    Section(header: Text("UI")) {
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
                        HStack {
                            Text("Appearance")
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Spacer()
                            Picker(selection: $appearance, label: Text("Select your app appearance"), content: {
                                ForEach(0 ..< GlobalProps.AppOps.count) {
                                    Text(GlobalProps.AppOps[$0])
                                }
                            }).onChange(of: appearance, perform: { c in
                                if #available(iOS 15, *) {
                                    print(appearance)
                                    UserDefaults.standard.set(appearance, forKey: "appearance")
                                } else {
                                    if(colorScheme == .dark) {
                                        return UserDefaults.standard.set(0, forKey: "appearance");
                                    } else if(colorScheme == .light) {
                                        return UserDefaults.standard.set(1, forKey: "appearance");
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                                        UserDefaults.standard.set(2, forKey: "appearance")
                                    }
                                }
                            })
                                .pickerStyle(MenuPickerStyle())
                                .labelsHidden()
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                                .multilineTextAlignment(.leading)
                        }
                        Toggle("Show Wishlist", isOn: $showWishlist)
                            .onChange(of: showWishlist) { _ in
                                startPage = 0;
                            }
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                        Toggle("Show Entry Dates", isOn: $showAdded)
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                    }
                    Section(header: Text("Notifications"), footer: Text("If you said no to notifications the first time you launched the app you will need to enable them in your device's settings.")) {
                        Toggle("Notifications", isOn: $notifications)
                            .onChange(of: notifications, perform: { c in
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
                        HStack {
                            Text("Delivery Time")
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                            Spacer()
                            DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                                .onChange(of: currentDate, perform: { _ in
                                    UserDefaults.standard.set(currentDate, forKey: "notificationTime");
                                })
                                //.pickerStyle(MenuPickerStyle())
                                .labelsHidden()
                                .padding(.horizontal)
                                .padding(.vertical, GlobalProps.PS)
                                .multilineTextAlignment(.leading)
                                .disabled(!notifications)
                        }
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
                        Stepper("Debt Increment (\(forTrailingZero(temp: increment)))", value: $increment, step: 5)
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS) 
                        //These labels work though...
                        Toggle("Show Symbols", isOn: $showSymbols)
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                        Toggle("Show Codes", isOn: $showCC)
                            .padding(.horizontal)
                            .padding(.vertical, GlobalProps.PS)
                        Toggle("Show Breakdowns", isOn: $showBreakdown)
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
                        HStack {
                            Link("Join the beta", destination: URL(string: "https://testflight.apple.com/join/dmrYBa1W")!)
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
                                Text("See patch notes")
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
