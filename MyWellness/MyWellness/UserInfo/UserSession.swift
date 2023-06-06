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
    @Published var goalSetDate: Date = Date()
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
    
    @Published var sleepValueDict: [SleepAssignDate] = [SleepAssignDate(todayDate: Date())]
    
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
        DispatchQueue.main.async { self.isLoading = true }
        
        do {
            try await profileViewModel.loadCurrentUser()
            try await profileViewModel.loadCurrentUserDiet()
            print("Called loadCurrentuser")
            
            // -------------------------------------
            // User Personal Info
            // -------------------------------------
            
            // User's personal info
            let displayName = await profileViewModel.user?.displayName ?? ""
            let dateCreated = await profileViewModel.user?.dateCreated ?? Date()
            let sex = await profileViewModel.user?.sex ?? true ? "male" : "female"
            
            let height = await profileViewModel.user?.height ?? 0
            let weight = await profileViewModel.user?.weight ?? 0
            
            let dateOfBirth = await profileViewModel.user?.dateOfBirth ?? Date()
            let age = calculateAge(from: dateOfBirth)
            
            let weightGoal = await profileViewModel.user?.weightGoal ?? 0
            let startWeight = await profileViewModel.user?.weightAtGoalSetted ?? 0
            let goalSetDate = await profileViewModel.user?.goalSettedDate ?? Date()
            let goalExpectDate = await profileViewModel.user?.goalExpectDate ?? Date()
            
            // -------------------------------------
            // Diet Data
            // -------------------------------------
            
            let dietValueDict = await profileViewModel.diet?.dietValueDict ?? [DietAssignDate(kcalGoal: 100)]
            
            // -------------------------------------
            // Exercise Data
            // -------------------------------------
            
            let exerciseValueDict = await profileViewModel.exercise?.exerciseValueDict ?? [ExerciseAssignDate(kcalGoal: 100)]
            
            // -------------------------------------
            // Sleep Data
            // -------------------------------------
            
            let sleepValueDict = await profileViewModel.sleep?.sleepValueDict ?? [SleepAssignDate(todayDate: Date())]
            
            DispatchQueue.main.async {
                self.displayName = displayName
                self.dateCreated = dateCreated
                self.sex = sex
                self.height = height
                self.weight = weight
                self.dateOfBirth = dateOfBirth
                self.age = age
                self.weightGoal = weightGoal
                self.startWeight = startWeight
                self.goalSetDate = goalSetDate
                self.goalExpectDate = goalExpectDate
                self.dietValueDict = dietValueDict
                self.exerciseValueDict = exerciseValueDict
                self.sleepValueDict = sleepValueDict
                // Use DispatchGroup to wait for calculateBMR() and calculateBMI() to finish
                
                DispatchQueue.main.async {
                    Task {
                        self.BMR = await self.calculateBMR()
                        self.BMI = await self.calculateBMI()
                        self.updateIfNeeded(BMR: self.BMR)
                        self.isLoading = false
                        print("[SUCCESS] loadUserBasicInfo")
                    }
                }
            }
            
        } catch {
            DispatchQueue.main.async {
                print("Error in loadUserBasicInfo(): \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func updateIfNeeded(BMR: Int) {
        let dateDifference = calculateDateDifference(date1: dateCreated, date2: Date())
        let dietValueCount = dietValueDict.count
        let dietTimeInterval: TimeInterval = TimeInterval(dietValueCount * 86400) // 86400 is the number of seconds in a day
        if dietValueCount <= dateDifference {
            print("-----UPDATING START-----")
            let newDictNeedToAdd = dateDifference - dietValueCount + 1
            print("\(newDictNeedToAdd) more empty sheets need to be create")
            for i in stride(from: 0, to: newDictNeedToAdd, by: 1) {
                print("\tupdating user's sheets: \(i + 1) in \(newDictNeedToAdd) bmr \(BMR)")
                self.dietValueDict.append(DietAssignDate(kcalGoal: BMR))
                self.exerciseValueDict.append(ExerciseAssignDate(kcalGoal: Int(Double(BMR) * 0.15)))
                let iTimeInterval: TimeInterval = TimeInterval(i * 86400) // 86400 is the number of seconds in a day
                let sleepAssignDate = dateCreated.addingTimeInterval(dietTimeInterval + iTimeInterval)
                self.sleepValueDict.append(SleepAssignDate(todayDate: sleepAssignDate))
            }
            Task {
                do {
                    try await DietManager.shared.updateUserDietInfo(diet: Diet(userId: self.uid, dietValueDict: self.dietValueDict))
                } catch {
                    print("error: \(error)")
                }
            }
            Task {
                do {
                    try await ExerciseManager.shared.updateUserExerciseInfo(exercise: Exercise(userId: self.uid, exerciseValueDict: self.exerciseValueDict))
                } catch {
                    print("error: \(error)")
                }
            }
            Task {
                do {
                    try await SleepManager.shared.updateUserSleepInfo(sleep: Sleep(userId: self.uid, sleepValueDict: self.sleepValueDict))
                } catch {
                    print("error: \(error)")
                }
            }
            print("-----UPDATING COMPELETE-----")
        }
    }

    
    func calculateBMR() async -> Int {
        var tempBMR: Double

        if self.sex == "male" {
            tempBMR = 66 + (13.75 * self.weight) + (5 * self.height) - (6.75 * Double(self.age))
        } else {
            tempBMR = 655 + (9.56 * self.weight) + (1.85 * self.height) - (4.68 * Double(self.age))
        }

        // Adjust BMR based on activity level
        let activityMultiplier: Double = 1.2 // Assume sedentary activity level (little to no exercise)
        tempBMR = tempBMR * activityMultiplier
        
        return Int(tempBMR)
    }

    private func calculateBMI() async -> Double {
        let heightInM = self.height * 0.0254 // Convert height from inches to meters
        return self.weight / (heightInM * heightInM)
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
