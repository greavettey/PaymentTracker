//
//  Enums.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-08.
//
import Foundation
import SwiftUI

struct UpcomingPaymentEntry: Identifiable, Codable {
    let name: String;
    let date: String;
    let cost: Double;
    let type: String;
    
    let cc: String;
    
    let id = UUID();
}

struct DebtPaymentEntry: Identifiable, Codable {
    let name: String;
    let date: String;
    var amount: Double;
    var paid: Double;
    
    let cc: String;
    
    let id = UUID();
}

enum Currency: String, CaseIterable, Identifiable, Codable {
    case USD, CAD, NZD, EUR, GBP
    
    var id: String { self.rawValue }
    var symbol: String {
        switch self {
            case .USD, .CAD, .NZD:
                    return "$"
            case .EUR:
                    return "€"
            case .GBP:
                    return "£"
        }
    }
    
}

enum StartPage: String, CaseIterable, Identifiable, Codable {
    case upcoming, debts

    var id: String { self.rawValue }
}

struct GlobalProps {
    static var SupportedIcons: [String] = ["Kickstarter", "Amazon", "Steam", "Alibaba", "Walmart"]
}
