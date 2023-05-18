//
//  UserProfileSettingsView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/17/23.
//

import SwiftUI

struct UserProfileSettingsView: View {
    
    @StateObject private var viewModel = UserProfileSettingsViewModel()
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UID: \(user.userId)")
                
                if let uEmail = user.email {
                    Text("Email: \(uEmail.description)")
                }
                Text("Display Name: \(user.displayName.description)")
                
                Text("Register on: \(user.dateCreated.description)")
            }else {
                Text("Sign in Required")
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "gear")
                    .font(.headline)
            }
        }
    }
}

struct UserProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView() {
            UserProfileSettingsView()
        }
    }
}
