//
//  SettingsView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var showLogin = false
    @State private var showEditUserData = false
    @State private var showAccountSettings = false
    @State private var showNotificationSettings = false
    @State private var showDataSettings = false
    @State private var showPrivacyPolicy = false
    @State private var showAboutUs = false
    
    // Replace with your user's data
    // user's name, gender, height, weight, age, BMR, BMI, weight goal progress
    // user's profile picture
    @State private var userName = "ZL Asica"
    @State private var userEmail = "zl-asica@outlook.com"
    @State private var gender = "male"
    @State private var height: Int = 68
    @State private var weight: Int = 150
    @State private var age: Int = 25
    // Basal Metabolic Rate: BMR = 10 * weight (kg) + 6.25 * height (cm) - 5 * age (years) + 5
    @State private var BMR: Int = 1500
    // Calculate BMI using the formula: BMI = weight (kg) / height (m) ^ 2
    @State private var BMI: Float = 0.0
    // Weight user wants to achieve
    @State private var weightGoal: Int = 140
    // Weight user have before starting the program
    @State private var weightStart: Int = 160
    @State private var weightGoalProgress: Float = 0.0

    
    var body: some View {
//        self.BMR = (10 * weight) + (6.25 * height) - (5 * age) + 5
//        self.BMI = weight / (height * height)
//        self.weightGoalProgress = (weight - weightGoal) / (weightStart - weightGoal)
        ScrollView {
            VStack {
                if showLogin {
                    Button(action: {
                        // Implement login functionality here
                    }) {
                        Text("Login")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 40)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                } else {
                    // Get user's profile picture from Gravatar
                    CircularImageView(gravatarURL: generateGravatarURL(userEmail: userEmail))
                        .frame(width: 100, height: 100)
                    
                    Text("\(userName)")
                        .font(.title2)
                    
                    HStack {
                        // Based on user's gender, show SFsymbol
                        Text("\(gender)")
                        Image(systemName: "person")
                    }
                }
                VStack {
                    HStack {
                        UserDataCard(title: "Height", value: "\(height) ft", imageName: "ruler")
                        UserDataCard(title: "Weight", value: "\(weight) lbs", imageName: "scalemass")
                    }
                    
                    HStack {
                        UserDataCard(title: "Age", value: "\(age)", imageName: "calendar")
                        UserDataCard(title: "BMR", value: "\(BMR) kcal", imageName: "flame")
                    }
                }
                
                VStack{
                    BMIView()
                    WeightGoalProgressView()
                }
                .padding(.vertical)
                
                Button(action: {
                    showAccountSettings.toggle()
                }) {
                    SettingsRow(title: "Account Settings")
                }
                .sheet(isPresented: $showAccountSettings) {
                    // Replace with Account Settings View
                    Text("Account Settings")
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
                
                Button(action: {
                    // Implement sign out functionality here
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(width: 200, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
