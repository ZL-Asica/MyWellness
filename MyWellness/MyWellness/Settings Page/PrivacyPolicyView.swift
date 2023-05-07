//
//  PrivacyPolicyView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/6/23.
//

import SwiftUI


struct PrivacyPolicyView: View {
    var body: some View {
        VStack {
            Text("Privacy Policy Summary")
                .font(.title)
            // Add the summary here
            Text("Privacy Policy summary content...")
            
            Link("View Full Privacy Policy", destination: URL(string: "https://mywellness.zla.app/privacy")!)
                .font(.headline)
                .padding(.top)
        }
        .padding()
    }
}
