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

        VStack {
            if(showSymbols && showCC) {
                Text(try! AttributedString(markdown: "Prices will be shown with currency symbols and codes. For example: **" + selectedCurrency.symbol + "100 " + selectedCurrency.rawValue.uppercased() + "**" + db, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            } else if (showSymbols && !showCC) {
                Text(try! AttributedString(markdown: "Prices will be shown with currency symbols. For example: **" + selectedCurrency.symbol + "100**" + db, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            } else if (showCC && !showSymbols){
                Text(try! AttributedString(markdown: "Prices will be shown with currency codes. For example: **100 " + selectedCurrency.rawValue.uppercased() + "**" + db, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            } else {
                Text("Prices will be shown without currency codes or symbols. For example: **100**")
            }
        }
    }
}

struct IconSwitch: View {
    @Environment(\.dismiss) var dismiss
    
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
                        dismiss()
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
                                let t = GlobalProps.AppIcons.sorted(by: <)
                                HStack {
                                    Image(uiImage: UIImage(named: t[c]) ?? UIImage())
                                        .resizable()
                                        .renderingMode(.original)
                                        .frame(width: 30, height: 30, alignment: .leading)
                                        .cornerRadius(5)
                                        .padding(.horizontal)
                                        .padding(.vertical, GlobalProps.PS)
                                    Text(t[c].replacingOccurrences(of: "AppIcon", with: "Default").replacingOccurrences(of: "_", with: " "))
                                        .padding(.vertical, GlobalProps.PS)
                                }
                            }
                        }).onChange(of: index, perform: { c in
                            UIApplication.shared.setAlternateIconName(index == 0 ? nil : GlobalProps.AppIcons[index], completionHandler: {
                                error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    dismiss()
                                } else {
                                    dismiss()
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

/*
 Thank you Jad Chaar on StackOverflow
 https://stackoverflow.com/questions/58425829/how-can-i-create-a-text-with-checkbox-in-swiftui
 */
struct CheckBoxView: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}
