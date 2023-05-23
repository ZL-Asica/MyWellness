//
//  SignUpWithEmailViewModel.swift
//  MyWellness
//
//  Created by ZL Asica on 5/18/23.
//

import Foundation

@MainActor
final class SignUpWithEmailViewModel: ObservableObject {
    
    @Published var uid = ""
    @Published var sex = false
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var hideWindow = false
    
    // User's personal data
    @Published var displayName: String = ""
    @Published var weight: String = ""  // Double
    @Published var height: String = ""  // Double
    @Published var dateOfBirth: Date = Date()
    // For weight goal and checking the progress
    @Published var weightGoal: String = ""  // Double
    @Published var goalExpectDate: Date = Date()
    
    func signUp() throws {
        guard !email.isEmpty, !password.isEmpty else {
            // TODO: validation for users, need to pop up a windows.
            print("No email or password found.")
            throw URLError(.badServerResponse)
        }
        
        Task{
            do{
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Sign Up Success")
                print(returnedUserData)
                uid = returnedUserData.uid
                hideWindow = true
                alertTitle = "Sign Up Success"
                alertMessage = "You have successfully signed up! Remember to set your personal information first in order to use our app."
                showAlert = true
                if let weightValue = Double(weight), let heightValue = Double(height), let weightGoalValue = Double(weightGoal) {
                    let user = DBUser(userId: uid, sex: sex, email: email, displayName: displayName, weight: weightValue, height: heightValue, dateOfBirth: dateOfBirth, weightGoal: weightGoalValue, goalExpectDate: goalExpectDate)
                    try await UserManager.shared.createnewUser(user: user)
                }
                let userDiet = Diet(userId: uid, kcalGoal: 1000)
                try await DietManager.shared.createnewUser(diet: userDiet)
            } catch {
                print("Sign Up Error: \(error)")
                alertTitle = "Sign Up Failed"
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}
