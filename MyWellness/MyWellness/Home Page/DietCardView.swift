//
//  DietCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct DietCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Diet")
                .font(.headline)
            
            // Add content for the Diet card here
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct DietCardView_Previews: PreviewProvider {
    static var previews: some View {
        DietCardView()
    }
}

