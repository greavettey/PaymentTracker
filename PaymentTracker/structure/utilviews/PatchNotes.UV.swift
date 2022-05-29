//
//  PatchNotes.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import SwiftUI

struct PatchNotes: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            Text("Version " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "[??]") + " 😊")
                .padding(.horizontal)
                .padding(.top)
                .font(.title)
            Text("A hearty little update...")
                .padding(.horizontal)
                .font(.footnote)
            if #available(iOS 15, *) {
                List {
                    Text(try! AttributedString(markdown: "Redid the **app appearance options**. Choose between *dark*, *light*, and *system*.", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "**Fixed a notification bug** from the dawn of mankind. Notifications no longer queue themselves from the present date backwards in time!", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "Notifications have **been made a bit more intuitive**, and you can now *customize the delivery-time*.", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "Tap on the debt amount or breakdown to **quickly and easily update how much you've paid**. The increment can be *customized in the settings tab*.", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "**Wishlist links are now optional**. Sometimes you don't have the link. Now you don't need it.", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "New **StockX icon**. Please suggest more.", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    Text(try! AttributedString(markdown: "A couple other very minor bugs were fixed.", options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                }
                    .padding(.vertical, GlobalProps.PS)
                    .padding(.horizontal)
                    .listStyle(.inset)
            } else {
                List {
                    Text("Redid the app appearance options. Choose between dark, light, and system.")
                    Text("Fixed a notification bug from the dawn of mankind. Notifications no longer queue themselves from the present date backwards in time!")
                    Text("Notifications have been made a bit more intuitive, and you can now customize the delivery-time.")
                    Text("Tap on the debt amount or breakdown to quickly and easily update how much you've paid. The increment can be customized in the settings tab.")
                    Text("Wishlist links are now optional. Sometimes you don't have the link. Now you don't need it.")
                    Text("New StockX icon. Please suggest more.")
                    Text("A couple other very minor bugs were fixed.")
                }
                    .padding(.vertical, GlobalProps.PS)
                    .padding(.horizontal)
                    .listStyle(.inset)
            }
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Sweet, take me to the app!")
                    .padding(.vertical, GlobalProps.PS)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2))
            }
            .padding(.vertical, GlobalProps.PS)
            .padding(.horizontal)
        }
    }
}
