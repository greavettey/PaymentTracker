//
//  PaymentTrackerApp.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI

@main
struct PaymentTrackerApp: App {
    @AppStorage("darkMode") var mode: Bool = UserDefaults.standard.bool(forKey: "darkMode");
    
    @StateObject private var DebtStore = DebtPaymentStore();
    @StateObject private var UpcomingStore = UpcomingPaymentStore();
        
    var body: some Scene {
        WindowGroup {
            ContentView(debts: $DebtStore.debts, upcomings: $UpcomingStore.upcomings) {
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
                            fatalError(error.localizedDescription)
                        case .success(let upcomings):
                            UpcomingStore.upcomings = upcomings
                    }
                }
            }.preferredColorScheme(mode == true ? .dark : .light)
        }
    }
}
