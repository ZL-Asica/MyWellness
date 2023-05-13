//
//  LoginView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/7/23.
//

import SwiftUI

@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    func signIn() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            // TODO: validation for users, need to pop up a windows.
            print("No email or password found.")
            return false
        }
        Task{
            do{
                let returnedUserData = try await AuthenticationManager.shared.accountSignIn(email: email, password: password)
                print("Success")
                print(returnedUserData)
                return true
            } catch {
                print("Error: \(error)")
                alertTitle = "Sign In Failed"
                alertMessage = error.localizedDescription
                showAlert = true
                return false
            }
        }
        return false
    }
    
    func signUp() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            // TODO: validation for users, need to pop up a windows.
            print("No email or password found.")
            return false
        }
        
        Task{
            do{
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
                return true
            } catch {
                alertTitle = "Sign Up Failed"
                alertMessage = error.localizedDescription
                showAlert = true
                return false
            }
        }
        return false
    }
    
    func resetPassword() async throws {
        do {
            try await AuthenticationManager.shared.resetPassword(email: email)
            print("Success")
            alertTitle = "Success"
            alertMessage = "Check your email to reset your password, and come back to sign in."
            showAlert = true
        } catch {
            print("Error: \(error)")
            alertTitle = "Reset Failed"
            alertMessage = "\(error.localizedDescription) You can put your email inside the box above."
            showAlert = true
        }
    }
}

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SignInWithEmailViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Image("AppIcon-Pic") // logo here
                .resizable()
                .cornerRadius(30)
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 50)
            
            Text("My Wellness")
                .font(.headline)
            
            VStack {
                TextField("Email...", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                
                SecureField("Password...", text: $viewModel.password)
                    .textContentType(.password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
            }
            
            VStack{
                // Forget Password button
                Button {
                    Task{
                        do {
                            try await viewModel.resetPassword()
                        } catch {
                            print("Error with reset password: \(error)")
                        }
                    }
                } label: {
                    Text("Forgot Password?")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
                .padding()
                    
                // Sign in button
                Button {
                    if viewModel.signIn() {
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Sign In")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Sign up button
                Button {
                    if viewModel.signUp() {
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Sign Up")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            Spacer()
        }
    }
}
    
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

