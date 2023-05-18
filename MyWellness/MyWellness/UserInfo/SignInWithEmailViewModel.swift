//
//  SignInWithEmailViewModel.swift
//  MyWellness
//
//  Created by ZL Asica on 5/17/23.
//

import Foundation

@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var hideWindow = false
    
    func signIn() throws {
        guard !email.isEmpty, !password.isEmpty else {
            // TODO: validation for users, need to pop up a windows.
            print("No email or password found.")
            throw URLError(.badServerResponse)
        }
        Task{
            do{
                let returnedUserData = try await AuthenticationManager.shared.accountSignIn(email: email, password: password)
                print("Sign In Success")
                print(returnedUserData)
                hideWindow = true
                alertTitle = "Sign In Success"
                alertMessage = "You have successfully signed in!"
                showAlert = true
            } catch {
                print("Sign In Error: \(error)")
                alertTitle = "Sign In Failed"
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    func resetPassword() async throws {
        do {
            try await AuthenticationManager.shared.resetPassword(email: email)
            print("Reset Pasword Success")
            alertTitle = "Success"
            alertMessage = "Check your email to reset your password, and come back to sign in."
            showAlert = true
        } catch {
            print("Reset Password Error: \(error)")
            alertTitle = "Reset Failed"
            alertMessage = "\(error.localizedDescription) You can put your email inside the box above."
            showAlert = true
        }
    }
}
