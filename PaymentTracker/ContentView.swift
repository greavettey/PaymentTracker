//
//  ContentView.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-04.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = changeTab();
    
    @Binding var debts: [DebtPaymentEntry]
    @Binding var upcomings: [UpcomingPaymentEntry]
    @Binding var wishes: [WishlistEntry]
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("showWishlist") var showWishlist: Bool = UserDefaults.standard.bool(forKey: "showWishlist");
    
    let saveAction: ()->Void

    var body: some View {
        TabView(selection: $tabSelection) {
            UpcomingView(upcomings: $upcomings, debts: $debts, wishes: $wishes)
                .tabItem {
                    Image(systemName: "clock.badge.exclamationmark.fill")
                    Text("Upcoming")
                }
                    .tag(1)
                    .highPriorityGesture(DragGesture().onEnded({
                        self.handleSwipe(translation: $0.translation.width)
                    }))
            DebtsView(debts: $debts, upcomings: $upcomings, wishes: $wishes)
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Debts")
                }
                    .tag(2)
                    .highPriorityGesture(DragGesture().onEnded({
                        self.handleSwipe(translation: $0.translation.width)
                    }))
            if(showWishlist == true) {
                WishlistView(wishes: $wishes, debts: $debts, upcomings: $upcomings)
                    .tabItem{
                        Image(systemName: "bag.fill")
                        Text("Wishlist")
                    }
                        .tag(3)
                        .highPriorityGesture(DragGesture().onEnded({
                            self.handleSwipe(translation: $0.translation.width)
                        }))
            }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                    .tag(4)
                    .highPriorityGesture(DragGesture().onEnded({
                        self.handleSwipe(translation: $0.translation.width)
                    }))
        }
            .onChange(of: scenePhase) { phase in
                if(phase == .inactive) { saveAction() }
            }
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation > 50 && tabSelection > 0 {
            tabSelection -= 1
        } else  if translation < -50 && tabSelection <= 3 {
            tabSelection += 1
        }
    }

}
