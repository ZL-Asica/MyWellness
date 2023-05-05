//
//  SleepCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct SleepCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sleep")
                .font(.headline)
            
            // Add content for the Sleep card here
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        }
    }

struct SleepCardView_Previews: PreviewProvider {
    static var previews: some View {
        SleepCardView()
    }
}

