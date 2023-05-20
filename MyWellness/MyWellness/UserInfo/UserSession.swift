//
//  UserSession.swift
//  MyWellness
//
//  Created by ZL Asica on 5/19/23.
//

import SwiftUI
import CryptoKit
import Combine

class UserSession: ObservableObject {
    var profileViewModel: UserProfileSettingsViewModel
    
    @Published var isLoading = false
    
    @Published var userEmail: String = ""
    @Published var userImageLink: String = ""
    
    // user's name, gender, height, weight, age, BMR, BMI, weight goal progress
//    @Published var gender = "male"
    
    // User's personal info
    @Published var displayName: String = ""
    @Published var weight: Double = 0
    @Published var height: Double = 0
    
    @Published var dateOfBirth: Date = Date()
    @Published var age: Int = 0
    
    // Basal Metabolic Rate: BMR = 10 * weight (kg) + 6.25 * height (cm) - 5 * age (years) + 5
    @Published var BMR: Int = 0
    // Calculate BMI using the formula: BMI = weight (kg) / height (m) ^ 2
    @Published var BMI: Double = 0.0
    
    // Weight user wants to achieve
    @Published var weightGoal: Double = 0
    // Weight user have before starting the program
    @Published var startWeight: Double = 0
    @Published var goalExpectDate: Date = Date()
    
    init(profileViewModel: UserProfileSettingsViewModel) {
        self.profileViewModel = profileViewModel
        reloadUserLoginInfo()
    }
    
    func reloadUserLoginInfo() {
        fetchUserEmail()
        userImageLink = generateGravatarURL(userEmail: userEmail)
        
        // async operation to load user info
        if userEmail != "" {
            Task {
                await loadUserBasicInfo()
            }
        }
    }
    
    func resetUserData() {
        userEmail = ""
    }
    
    func fetchUserEmail(){
        do {
            let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
            userEmail = authUser.email ?? ""
        } catch {
            // handle error
            print("FetchUserEmail ERROR \(error)")
        }
    }
    
    // Helper function to generate Gravatar URL
    func generateGravatarURL(userEmail: String, defaultImage: String = "https://www.gravatar.com/avatar") -> String {
        let email = userEmail.lowercased()
        let hashedEmail = Insecure.MD5.hash(data: Data(email.utf8)).map { String(format: "%02hhx", $0) }.joined()
        let gravatarURL = "https://www.gravatar.com/avatar/\(hashedEmail)?d=\(defaultImage)&s=150"
        
        return gravatarURL
    }
    
    func loadUserBasicInfo() async {
        isLoading = true
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        do {
            try await profileViewModel.loadCurrentUser()
            print("Called loadCurrentuser")
            // User's personal info
            displayName = await profileViewModel.user?.displayName ?? ""
            height = await profileViewModel.user?.height ?? 0
            weight = await profileViewModel.user?.weight ?? 0
            
            dateOfBirth = await profileViewModel.user?.dateOfBirth ?? Date()
            age = calculateAge(from: dateOfBirth)
            
            calculateBMR()
            calculateBMI()
            
            // Weight user wants to achieve
            weightGoal = await profileViewModel.user?.weightGoal ?? 0
            // Weight user have before starting the program
            startWeight = await profileViewModel.user?.weightAtGoalSetted ?? 0
            goalExpectDate = await profileViewModel.user?.goalExpectDate ?? Date()
            isLoading = false
        } catch {
            DispatchQueue.main.async {
                print("Error in loadUserBasicInfo(): \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func calculateBMR() {
            let weightInKg = Float(weight) / 2.205 // Convert weight from pounds to kg
            let heightInCm = Float(height) * 2.54 // Convert height from inches to cm
            BMR = Int((10 * weightInKg) + (6.25 * heightInCm) - (5 * Float(age)) + 5)
        }

    private func calculateBMI() {
        let heightInM = Double(height) * 0.0254 // Convert height from inches to meters
        BMI = Double(weight) / Double((heightInM * heightInM))
    }
    
    private func calculateAge(from date: Date) -> Int {
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.year], from: date, to: currentDate)
        
        if let years = components.year {
            return years
        }
        
        return 0
    }
}
