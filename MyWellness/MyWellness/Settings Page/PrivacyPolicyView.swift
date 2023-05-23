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
            Text("We will use your email to get your personal avatar and display name(if you have) from Gravatar's server. If you have any concern about that please visit their website.")
            
            Text("If you want to delete your account, please go to our website and contact us.")
            
            Text("")
            
            Link("View Full Privacy Policy", destination: URL(string: "https://mywellness.zla.app/privacy")!)
                .font(.headline)
                .padding(.top)
        }
        .padding()
    }
}
