//
//  BetaBadge.UV.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

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
