//
//  IconSwitch.UV.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import SwiftUI

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
