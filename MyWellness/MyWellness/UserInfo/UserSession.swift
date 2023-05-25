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
    @Published var uid: String = ""
    
    // -------------------------------------
    // User Personal Info
    // -------------------------------------
    
    @Published var userEmail: String = ""
    @Published var userImageLink: String = ""
    @Published var dateCreated: Date = Date()
    @Published var sex: String = ""
    
    // user's name, gender, height, weight, age, BMR, BMI, weight goal progress
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
    
    // -------------------------------------
    // Diet Data
    // -------------------------------------
    
    @Published var dietValueDict: [DietAssignDate] = [DietAssignDate(kcalGoal: 100)]
    
    // -------------------------------------
    // Exercise Data
    // -------------------------------------
    
    @Published var exerciseValueDict: [ExerciseAssignDate] = [ExerciseAssignDate(kcalGoal: 100)]
    
    // -------------------------------------
    // Sleep Data
    // -------------------------------------
    
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
            uid = authUser.uid
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
            try await profileViewModel.loadCurrentUserDiet()
            print("Called loadCurrentuser")
            
            // -------------------------------------
            // User Personal Info
            // -------------------------------------
            
            // User's personal info
            displayName = await profileViewModel.user?.displayName ?? ""
            dateCreated = await profileViewModel.user?.dateCreated ?? Date()
            sex = await profileViewModel.user?.sex ?? true ? "male" : "female"
            
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
            
            // -------------------------------------
            // Diet Data
            // -------------------------------------
            
            dietValueDict = await profileViewModel.diet?.dietValueDict ?? [DietAssignDate(kcalGoal: 100)]
            
            // -------------------------------------
            // Exercise Data
            // -------------------------------------
            
            exerciseValueDict = await profileViewModel.exercise?.exerciseValueDict ?? [ExerciseAssignDate(kcalGoal: 100)]
            
            // -------------------------------------
            // Sleep Data
            // -------------------------------------
            
            isLoading = false
        } catch {
            DispatchQueue.main.async {
                print("Error in loadUserBasicInfo(): \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func calculateBMR() {
        var tempBMR: Double
        
        if sex == "male" {
            tempBMR = 66 + (13.75 * weight) + (5 * height) - (6.75 * Double(age))
        } else {
            tempBMR = 655 + (9.56 * weight) + (1.85 * height) - (4.68 * Double(age))
        }

        // Adjust BMR based on activity level
        let activityMultiplier: Double = 1.2 // Assume sedentary activity level (little to no exercise)
        tempBMR = tempBMR * activityMultiplier
        
        BMR = Int(tempBMR)
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
    
    func calculateDateDifference(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}
