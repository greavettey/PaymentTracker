//
//  Common.CM.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import SwiftUI

struct ContextMenuEdit: View {
    @Binding var showEditSheet: Bool;
    
    var body: some View {
        Button {
            showEditSheet.toggle()
        } label: {
            Text("Edit")
        }
    }
}
