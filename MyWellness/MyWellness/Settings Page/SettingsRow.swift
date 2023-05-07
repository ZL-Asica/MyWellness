//
//  SettingsRow.swift
//  MyWellness
//
//  Created by ZL Asica on 5/6/23.
//

import SwiftUI

struct SettingsRow: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRow(title: "Account")
    }
}