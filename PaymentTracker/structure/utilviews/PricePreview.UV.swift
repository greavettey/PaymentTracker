//
//  PricePreview.UV.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import SwiftUI

struct pricePreview: View {
    @Binding var showSymbols: Bool
    @Binding var showCC: Bool
    @Binding var selectedCurrency: Currency
    @Binding var showDB: Bool
    
    var body: some View {
        let db: String = showDB ? "\n\nDebt breakdowns do not respect currency code choices." : "";

        if #available(iOS 15, *) {
            if(showSymbols && showCC) {
                Text(try! AttributedString(markdown: "Prices will be shown with currency symbols and codes. For example: **" + selectedCurrency.symbol + "100 " + selectedCurrency.rawValue.uppercased() + "**" + db, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            } else if (showSymbols && !showCC) {
                Text(try! AttributedString(markdown: "Prices will be shown with currency symbols. For example: **" + selectedCurrency.symbol + "100**" + db, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            } else if (showCC && !showSymbols){
                Text(try! AttributedString(markdown: "Prices will be shown with currency codes. For example: **100 " + selectedCurrency.rawValue.uppercased() + "**" + db, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            } else {
                Text("Prices will be shown without currency codes or symbols. For example: **100**")
            }
        } else {
            if(showSymbols && showCC) {
                Text("Prices will be shown with currency symbols and codes. For example: " + selectedCurrency.symbol + "100 " + selectedCurrency.rawValue.uppercased() + db)
            } else if (showSymbols && !showCC) {
                Text("Prices will be shown with currency symbols. For example: " + selectedCurrency.symbol + "100" + db)
            } else if (showCC && !showSymbols){
                Text("Prices will be shown with currency codes. For example: 100 " + selectedCurrency.rawValue.uppercased() + db)
            } else {
                Text("Prices will be shown without currency codes or symbols. For example: **100**")
            }
        }
            
    }
}
