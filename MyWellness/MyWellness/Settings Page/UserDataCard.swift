//
//  UserDataCard.swift
//  MyWellness
//
//  Created by ZL Asica on 5/6/23.
//

import SwiftUI

struct UserDataCard: View {
    let title: String
    let value: String
    let imageName: String
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.largeTitle)
            
            Text(title)
                .font(.headline)
            
            Text(value)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct UserDataCard_Previews: PreviewProvider {
    static var previews: some View {
        UserDataCard(title: "Height", value: "5' 10\"", imageName: "person.crop.circle")
    }
}
