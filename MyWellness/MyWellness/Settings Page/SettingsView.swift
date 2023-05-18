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
    @StateObject private var viewModel = SettingsViewModel()
    @StateObject private var profileViewModel = UserProfileSettingsViewModel()
    
    @State private var showEditUserData = false
    @State private var showAccountSettings = false
    @State private var showNotificationSettings = false
    @State private var showDataSettings = false
    @State private var showPrivacyPolicy = false
    @State private var showAboutUs = false
    @State private var showLoginView = false
    @State private var showSignUpView = false

    
    // Replace with your user's data
    // user's name, gender, height, weight, age, BMR, BMI, weight goal progress
    // user's profile picture
    @State private var userEmail: String = ""
    
    @StateObject private var gravatarProfileFetcher = GravatarProfileFetcher()
    @State private var gender = "male"
    
    // User's personal info
    @State private var displayName: String = ""
    @State private var weight: Double = 0
    @State private var height: Double = 0
    
    @State private var dateOfBirth: Date = Date()
    @State private var age: Int = 0
    
    // Basal Metabolic Rate: BMR = 10 * weight (kg) + 6.25 * height (cm) - 5 * age (years) + 5
    @State private var BMR: Int = 0
    // Calculate BMI using the formula: BMI = weight (kg) / height (m) ^ 2
    @State private var BMI: Double = 0.0
    
    // Weight user wants to achieve
    @State private var weightGoal: Double = 0
    // Weight user have before starting the program
    @State private var startWeight: Double = 0
    @State private var goalExpectDate: Date = Date()

    
    var body: some View {
        ScrollView {
            VStack {
                // User's personal information here
                if userEmail == "" {
                    NavigationView {
                        VStack {
                            Button(action: {
                                showLoginView.toggle()
                            }) {
                                Text("Sign In")
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 40)
                            }
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding()
                            .sheet(isPresented: $showLoginView) {
                                LoginView()
                            }

                            Button(action: {
                                showSignUpView.toggle()
                            }) {
                                Text("Sign Up")
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 40)
                            }
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding()
                            .sheet(isPresented: $showSignUpView) {
                                SignUpView()
                            }
                        }
                    }
                } else {
                    // Get user's profile picture from Gravatar
                    CircularImageView(gravatarURL: generateGravatarURL(userEmail: userEmail))
                        .frame(width: 100, height: 100)

                    Text("\(displayName)")
                        .font(.title2)

                    HStack {
                        // Based on user's gender, show SFsymbol
                        Text("\(gender)")
                        Image(systemName: "person")
                    }
                

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
                    .onAppear {
                        calculateBMI()
                        calculateBMR()
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
                                userEmail = ""
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
            }
            .padding()
        }
        .task {
            fetchUserEmail()
            if userEmail != "" {
                try? await profileViewModel.loadCurrentUser()
                gravatarProfileFetcher.fetchProfileInfo(userEmail: userEmail)
                
                print(profileViewModel.user ?? "error with getting user info")
                // User's personal info
                displayName = profileViewModel.user?.displayName ?? ""
                height = profileViewModel.user?.height ?? 0
                weight = profileViewModel.user?.weight ?? 0
                
                dateOfBirth = profileViewModel.user?.dateOfBirth ?? Date()
                age = calculateAge(from: dateOfBirth)
                
                calculateBMR()
                calculateBMI()
                
                // Weight user wants to achieve
                weightGoal = profileViewModel.user?.weightGoal ?? 0
                // Weight user have before starting the program
                startWeight = profileViewModel.user?.weightAtGoalSetted ?? 0
                goalExpectDate = profileViewModel.user?.goalExpectDate ?? Date()
            }
        }
        .navigationBarTitle("Settings")
    }
    
    func fetchUserEmail() {
        do {
            let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
            userEmail = authUser.email ?? ""
        } catch {
            // handle error
            print("FetchUserEmail ERROR \(error)")
        }
    }
    
    func convertToFeetAndInches(inches: Double) -> String {
        let feet = Int(inches / 12)
        let remainingInches = Int(inches.truncatingRemainder(dividingBy: 12))
        return "\(feet)' \(remainingInches)\""
    }
    
    func calculateBMR() {
            let weightInKg = Float(weight) / 2.205 // Convert weight from pounds to kg
            let heightInCm = Float(height) * 2.54 // Convert height from inches to cm
            BMR = Int((10 * weightInKg) + (6.25 * heightInCm) - (5 * Float(age)) + 5)
        }

    func calculateBMI() {
        let heightInM = Double(height) * 0.0254 // Convert height from inches to meters
        BMI = Double(weight) / Double((heightInM * heightInM))
    }
    
    func calculateAge(from date: Date) -> Int {
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.year], from: date, to: currentDate)
        
        if let years = components.year {
            return years
        }
        
        return 0
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
