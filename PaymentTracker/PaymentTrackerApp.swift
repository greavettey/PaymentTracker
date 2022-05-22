//
//  PaymentTrackerApp.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI

@main
struct PaymentTrackerApp: App {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("darkMode") var mode: Bool = UserDefaults.standard.bool(forKey: "darkMode");
    
    @StateObject private var DebtStore = DebtPaymentStore();
    @StateObject private var UpcomingStore = UpcomingPaymentStore();
    @StateObject private var WishStore = WishlistStore();
        
    init() {
        // For testing UserDefaults.standard.set(true, forKey: "showPatchnotes")
        UserDefaults.standard.register(defaults: [ "showWishlist": true, "showBreakdown": true, "showSymbols": true, "showAdded": true, "darkMode": colorScheme == .dark ? true : false, "showPatchnotes": ""]);
        
        if(!UserDefaults.standard.bool(forKey: "notifications") && !UserDefaults.standard.bool(forKey: "askedForNotificationsAtFirstStartup")) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    UserDefaults.standard.set(true, forKey: "askedForNotificationsAtFirstStartup")
                    return UserDefaults.standard.set(true, forKey: "notifications")
                } else if let error = error {
                    print(error.localizedDescription)
                    UserDefaults.standard.set(true, forKey: "askedForNotificationsAtFirstStartup")
                    return UserDefaults.standard.set(false, forKey: "notifications")
                }
            };
        }
        
        if(UserDefaults.standard.bool(forKey: "notifications") && !UserDefaults.standard.bool(forKey: "askedForNotificationsAtFirstStartup")) {
                UserDefaults.standard.set(true, forKey: "askedForNotificationsAtFirstStartup")
        }
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView(debts: $DebtStore.debts, upcomings: $UpcomingStore.upcomings, wishes: $WishStore.wishes) {
                DebtPaymentStore.save(debts: DebtStore.debts) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
                UpcomingPaymentStore.save(upcomings: UpcomingStore.upcomings) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
                WishlistStore.save(wishes: WishStore.wishes) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
            }.onAppear {
                DebtPaymentStore.load { res in
                    switch res {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(let debts):
                            DebtStore.debts = debts
                        }
                }
                UpcomingPaymentStore.load { res in
                    switch res {
                        case .failure(let error):
                            //print(error)
                            fatalError(error.localizedDescription)
                        case .success(let upcomings):
                            UpcomingStore.upcomings = upcomings
                    }
                }
                WishlistStore.load { res in
                    switch res {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let wishes):
                        WishStore.wishes = wishes
                    }
                }
            }.preferredColorScheme(mode == true ? .dark : .light)
        }
    }
}
