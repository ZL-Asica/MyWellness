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

    
    // user's name, gender, height, weight, age, BMR, BMI, weight goal progress
    // User's personal info
    @State private var displayName: String = ""
    @State private var weight: Double = 0
    @State private var height: Double = 0
    
    @State private var age: Int = 0
    @State private var BMR: Int = 0
    @State private var BMI: Double = 0.0
    
    // Weight user wants to achieve
    @State private var weightGoal: Double = 0
    // Weight user have before starting the program
    @State private var startWeight: Double = 0
    @State private var goalExpectDate: Date = Date()

    
    var body: some View {
        ScrollView {
            if isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                VStack {
                    // Get user's profile picture from Gravatar
                    CircularImageView(gravatarURL: userSession.userImageLink)
                        .frame(width: 100, height: 100)
                    
                    Text("\(displayName)")
                        .font(.title2)
                    
                    // User's basic information data
                    VStack {
                        HStack {
                            UserDataCard(title: "Height", value: convertToFeetAndInches(inches: height), imageName: "ruler")
                            UserDataCard(title: "Weight", value: "\(weight) lbs", imageName: "scalemass")
                        }
                        
                        HStack {
                            UserDataCard(title: "Age", value: "\(age)", imageName: "calendar")
                            UserDataCard(title: "BMR", value: "\(BMR) kcal", imageName: "flame")
                        }
                    }
                    
                    // BMI and Weight Goal Progress
                    VStack {
                        BMIView(bmi: BMI)
                        WeightGoalProgressView(startWeight: startWeight, targetWeight: weightGoal, currentWeight: weight)
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
                            AccountSettingsView()
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
                            Text("Data Settings")
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
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .task {
            DispatchQueue.main.async {
                isLoading = true
            }
            displayName = userSession.displayName
            weight = userSession.weight
            height = userSession.height
            age = userSession.age
            BMR = userSession.BMR
            BMI = userSession.BMI
            weightGoal = userSession.weightGoal
            startWeight = userSession.startWeight
            goalExpectDate = userSession.goalExpectDate
            
            DispatchQueue.main.async {
                isLoading = false
            }
        }
        .navigationBarTitle("Settings")
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
