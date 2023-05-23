//
//  SettingsView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}

struct SettingsView: View {
    @ObservedObject var userSession: UserSession
    @StateObject private var viewModel = SettingsViewModel()
    
    @State private var showEditUserData = false
    @State private var showAccountSettings = false
    @State private var showNotificationSettings = false
    @State private var showDataSettings = false
    @State private var showPrivacyPolicy = false
    @State private var showAboutUs = false
    @State private var showLoginView = false
    @State private var showSignUpView = false
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack{
                // Get user's profile picture from Gravatar
                CircularImageView(gravatarURL: userSession.userImageLink)
                    .frame(width: 100, height: 100)
                
                Text("\(userSession.displayName)")
                    .font(.title2)
                Text("\(userSession.sex)\(Image(systemName: "person"))")
                    .font(.caption)
                
                // User's basic information data
                VStack {
                    HStack {
                        UserDataCard(title: "Height", value: convertToFeetAndInches(inches: userSession.height), imageName: "ruler")
                        UserDataCard(title: "Weight", value: "\(userSession.weight) lbs", imageName: "scalemass")
                    }
                    
                    HStack {
                        UserDataCard(title: "Age", value: "\(userSession.age)", imageName: "calendar")
                        UserDataCard(title: "BMR", value: "\(userSession.BMR) kcal", imageName: "flame")
                    }
                }
                
                // BMI and Weight Goal Progress
                VStack {
                    BMIView(bmi: userSession.BMI)
                    WeightGoalProgressView(startWeight: userSession.startWeight, targetWeight: userSession.weightGoal, currentWeight: userSession.weight)
                }
                .padding(.vertical)
                
                // Settings
                VStack {
                    Button(action: {
                        showAccountSettings.toggle()
                    }) {
                        SettingsRow(title: "Account Settings")
                    }
                    .sheet(isPresented: $showAccountSettings) {
                        // Replace with Account Settings View
                        AccountSettingsView(userSession: userSession)
                    }
                    
                    Button(action: {
                        showNotificationSettings.toggle()
                    }) {
                        SettingsRow(title: "Notification Settings")
                    }
                    .sheet(isPresented: $showNotificationSettings) {
                        // Replace with Notification Settings View
                        Text("Notification Settings")
                    }
                    
                    Button(action: {
                        showDataSettings.toggle()
                    }) {
                        SettingsRow(title: "Data Settings")
                    }
                    .sheet(isPresented: $showDataSettings) {
                        // Replace with Data Settings View
                        UserProfileSettingsView(userSession: userSession)
                    }
                    
                    Button(action: {
                        showPrivacyPolicy.toggle()
                    }) {
                        SettingsRow(title: "Privacy Policy")
                    }
                    .sheet(isPresented: $showPrivacyPolicy) {
                        PrivacyPolicyView()
                    }
                    
                    Button(action: {
                        showAboutUs.toggle()
                    }) {
                        SettingsRow(title: "About Us")
                    }
                    .sheet(isPresented: $showAboutUs) {
                        // Replace with About Us View
                        Text("About Us")
                        Link("Here is our website", destination: URL(string: "https://mywellness.zla.app/")!)
                            .font(.headline)
                            .padding(.top)
                    }
                }
                
                Button("Sign Out"){
                    Task {
                        do {
                            try viewModel.signOut()
                            userSession.resetUserData()
                        } catch {
                            print("Sign Out ERROR \(error)")
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(.red)
                .frame(width: 200, height: 40)
                .background(Color.red.opacity(0.2))
                .cornerRadius(10)
                .padding(.top, 20)
            }
            .padding()
        }
    }
    
    func convertToFeetAndInches(inches: Double) -> String {
        let feet = Int(inches / 12)
        let remainingInches = Int(inches.truncatingRemainder(dividingBy: 12))
        return "\(feet)' \(remainingInches)\""
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UserProfileSettingsViewModel()
        let userSession = UserSession(profileViewModel: viewModel)
        SettingsView(userSession: userSession)
    }
}
