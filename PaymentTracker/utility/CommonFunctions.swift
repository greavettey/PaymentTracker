//
//  Functions.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-08.
//

import SwiftUI

func date2String(d: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "MM/dd/yyyy"
    return df.string(from: d)
}

func string2Date(s: String) -> Date {
    let df = DateFormatter()
    df.dateFormat = "MM/dd/yyyy"
    return df.date(from: s)!
}

func forTrailingZero(temp: Double) -> String {
    let tempVar = String(format: "%g", temp)
    return tempVar
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }

}

func changeTab() -> Int {
    let check = UserDefaults.standard.string(forKey: "startPage");
    if(UserDefaults.standard.bool(forKey: "goToSettings")) {
        UserDefaults.standard.set(false, forKey: "goToSettings")
        UserDefaults.standard.synchronize()
        return 4
    } else if(check == "debts") {
        return 2
    } else if(check == "wishlist") {
        return 3
    } else { return 1 }
}

extension Bundle {
    public var name: String? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
                return lastIcon
        }
        return nil
    }
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
                return UIImage(named: lastIcon)
        }
        return nil
    }
}

func checkInput(original: String) -> String {
    var val: String = ""
    
    if(original.starts(with: "0")) {
        val = String(original.dropFirst())
    } else {
        val = original;
    }

    let filtered = val.filter { "0123456789".contains($0) }
    if filtered != val {
        return filtered
    } else { return val }
}


func checkPunctuation(showSymbols: Bool, showCurrency: Bool, globalDefault: String, def: String, value: String) -> String {
    var used = ""
    if(def == "_def") { used = globalDefault }
    
    if(!showSymbols && showCurrency) {
        return value + " " + (Currency(rawValue: used)?.rawValue.uppercased() ?? "CAD")
    } else if(showSymbols && showCurrency) {
        return (Currency(rawValue: def)?.symbol ?? "$") + value + " " + (Currency(rawValue: def)?.rawValue.uppercased() ?? "CAD")
    } else if(showSymbols && !showCurrency) {
        return (Currency(rawValue: def)?.symbol ?? "$") + value
    } else {
        return value
    }
}
