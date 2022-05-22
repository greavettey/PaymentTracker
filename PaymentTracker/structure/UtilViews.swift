//
//  Other.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-02.
//

import Foundation
import SwiftUI

struct BetaBadge: View {
    var body: some View {
        Text("Beta")
            .font(.footnote)
            .padding(.vertical, 1.0)
            .padding(.horizontal, 2.5)
            .foregroundColor(Color.red)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.red)
            )
    }
}

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

struct IconSwitch: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var index: Int
                
    var body: some View {
        ZStack(alignment: .top) {
            VStack{
                HStack{
                    Text("Set App Icon")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "x.square.fill")
                            .padding()
                            .font(.title)
                    })
                }
                Form {
                    Section(footer: Text("Changes are applied instantly, but take a few minutes to show up in-app.")) {
                        Picker(selection: $index, label: Text("Choose an app icon"), content: {
                            ForEach(0 ..< GlobalProps.AppIcons.count) { c in
                                HStack {
                                    Image(uiImage: UIImage(named: GlobalProps.AppIcons[c]) ?? UIImage())
                                        .resizable()
                                        .renderingMode(.original)
                                        .frame(width: 30, height: 30, alignment: .leading)
                                        .cornerRadius(5)
                                        .padding(.horizontal)
                                        .padding(.vertical, GlobalProps.PS)
                                    Text(GlobalProps.AppIcons[c].replacingOccurrences(of: "AppIcon", with: "Default Icon").replacingOccurrences(of: "_", with: " "))
                                        .padding(.vertical, GlobalProps.PS)
                                }
                            }
                        }).onChange(of: index, perform: { c in
                            UIApplication.shared.setAlternateIconName(index == 0 ? nil : GlobalProps.AppIcons[index], completionHandler: {
                                    error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                        self.presentationMode.wrappedValue.dismiss()
                                    } else {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                })
                        })
                            .pickerStyle(.inline)
                            .labelsHidden()
                    }
                }
            }
        }
    }
}


struct PatchNotes: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            Text("Version " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "[??]") + " 🎉")
                .padding(.horizontal)
                .padding(.top, GlobalProps.PS)
                .font(.title)
            Text("There's a lot in this update...")
                .padding(.horizontal)
                .font(.footnote)
            if #available(iOS 15, *) {
                List {
                    Text(try! AttributedString(markdown: "New *Pastel* and *Neumorphic* **App Icons**", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "App Icons are now **organized alphabetically** in the Icon Switcher", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "New **Vendor Icons**: *Etsy*, *Target*, *ASOS*, *Microsoft*, *Adobe*, *Apple*, *Microsoft*, *Xbox*, and *Wish*", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "New **Wishlist** tab! A centralized wishlist for all of your wants. Can be toggled or set to your default page in Settings", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "Complete **visual rehaul**. Updated padding and spacing for almost every element, added more information to both Upcoming and Debt views, and made sure it was consistent", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "**iOS 14 support**! If that's your thing it's here now", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "**Made some settings more clear**. Hopefully it's more intuitive what they do now", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "**Proper subscriptions**. Upcoming payments can now be categorized as *single*, *monthly*, or *yearly* payments, and if you have notifications on, they'll repeat in that term", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "**Patch notes**. You're looking at them 😊", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                }
                    .padding(.vertical, GlobalProps.PS)
                    .padding(.horizontal)
                    .listStyle(.inset)
            } else {
                List {
                    Text("New Pastel and Neumorphic App Icons")
                    Text("App Icons are now organized alphabetically in the Icon Switcher")
                    Text("New Vendor Icons: Etsy, Target, ASOS, Microsoft, Adobe, Apple, Microsoft, Xbox, and Wish")
                    Text("New Wishlist tab! A centralized wishlist for all of your wants. Can be toggled or set to your default page in Settings")
                    Text("Complete visual rehaul. Updated padding and spacing for almost every element, added more information to both Upcoming and Debt views, and made sure it was consistent")
                    Text("iOS 14 support! If that's your thing it's here now")
                    Text("Made some settings more clear. Hopefully it's more intuitive what they do now")
                    Text("Proper subscriptions. Upcoming payments can now be categorized as single, monthly, or yearly payments, and if you have notifications on, they'll repeat in that term")
                    Text("Patch notes**. You're looking at them 😊")
                }
                    .padding(.vertical, GlobalProps.PS)
                    .padding(.horizontal)
                    .listStyle(.inset)
            }
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Very cool, take me to the app!")
                    .padding(.vertical, GlobalProps.PS)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2))
            }
            .padding(.vertical, GlobalProps.PS)
            .padding(.horizontal)
        }
    }
}
