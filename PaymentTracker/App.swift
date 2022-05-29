//
//  App.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI

@main
struct PaymentTrackerApp: App {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("appearance") var appearance: Int = UserDefaults.standard.integer(forKey: "appearance");
    
    @StateObject private var DebtStore = DebtPaymentStore();
    @StateObject private var UpcomingStore = UpcomingPaymentStore();
    @StateObject private var WishStore = WishlistStore();
        
    let formatter = DateFormatter()
    
    init() {
        formatter.dateFormat = "HH:mm"

        UserDefaults.standard.register(defaults: [ "showWishlist": true, "showBreakdown": true, "showSymbols": true, "showAdded": true, "appearance": [2], "showPatchnotes": "", "notificationTime": formatter.date(from: "00:00"), "debtIncrement": 10]);
        
        if(!UserDefaults.standard.bool(forKey: "notifications") && !UserDefaults.standard.bool(forKey: "askedForNotificationsAtFirstStartup")) {
            UserDefaults.standard.set(Bundle.main.infoDictionary?["PassPhrase"] as? String ?? "salute emoji", forKey: "showPatchnotes")
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    UserDefaults.standard.set(true, forKey: "askedForNotificationsAtFirstStartup")
                    UserDefaults.standard.set(true, forKey: "notifications")
                } else if let error = error {
                    print(error.localizedDescription)
                    UserDefaults.standard.set(true, forKey: "askedForNotificationsAtFirstStartup")
                    UserDefaults.standard.set(false, forKey: "notifications")
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
            }.preferredColorScheme([.dark, .light, nil][appearance])
        }
    }
}
