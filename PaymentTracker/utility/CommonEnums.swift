//
//  Enums.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-08.
//
import Foundation
import SwiftUI

struct UpcomingPaymentEntry: Identifiable, Codable, Hashable {
    let name: String;
    let date: String;
    let cost: Double;
    let type: String;
    let sub: Bool?;
    
    let cc: String;
    
    var id = UUID();
}

struct DebtPaymentEntry: Identifiable, Codable, Hashable {
    let name: String;
    let date: String;
    var amount: Double;
    var paid: Double;
    
    let cc: String;
    
    var id = UUID();
}

struct WishlistEntry: Identifiable, Codable, Hashable {
    let name: String;
    let cost: Double;
    let type: String;
    
    let cc: String;
    let link: String;
    
    var id = UUID();
}

enum Currency: String, CaseIterable, Identifiable, Codable {
    case USD, CAD, NZD, EUR, GBP, JPY, AUD, CNH
    
    var id: String { self.rawValue }
    var symbol: String {
        switch self {
            case .USD, .CAD, .NZD, .AUD:
                return "$"
            case .EUR:
                return "€"
            case .GBP:
                return "£"
            case .JPY, .CNH:
                return "¥"
        }
    }
    
}

enum StartPage: String, CaseIterable, Identifiable, Codable {
    case upcoming, debts

    var id: String { self.rawValue }
}

struct GlobalProps {
    static var SupportedIcons: [String] = ["PlayStation", "Kickstarter", "Amazon", "Steam", "Alibaba", "Walmart", "Indigo", "Indiegogo", "Best Buy", "Etsy", "Target", "ASOS", "Microsoft", "Adobe", "Apple", "Microsoft", "Xbox", "Wish"]
    static var AppIcons: [String] = ["AppIcon", "Royalty", "Periwinkle", "Eyebite", "Subdued", "Midnight", "Melons", "Turquoise", "Cotton_Candy", "Neumorphic", "Pastel"]
    static var PS: CGFloat = 6
}
