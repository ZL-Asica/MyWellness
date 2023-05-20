//
//  LoginView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/7/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession
    @StateObject private var viewModel = SignInWithEmailViewModel()
    
    var body: some View {
        NavigationView {
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
                    
                    Text("After you click the Sign In button, please wait for 10 seconds for the server to update your personal info and validate your account information. Please do not click agian or change any value above before an alert pop up. Thanks!")
                        .font(.caption)
                        .padding()
                        .background(Color.pink.opacity(0.4))
                        .cornerRadius(10)
                    // Sign in button
                    Button {
                        do {
                            try viewModel.signIn()
                        } catch {
                            print("Sign In Error: \(error)")
                            viewModel.alertTitle = "Sign In Failed"
                            viewModel.alertMessage = error.localizedDescription
                            viewModel.showAlert = true
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
                }
                .alert(isPresented: $viewModel.showAlert) {
                    if viewModel.hideWindow {
                        print("Sign in success")
                        userSession.fetchUserEmail()
                        userSession.userImageLink = userSession.generateGravatarURL(userEmail: userSession.userEmail)
                        Task {
                            await userSession.loadUserBasicInfo()
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    return Alert(
                        title: Text(viewModel.alertTitle),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                Spacer()
            }
            .padding()
        }
    }
}
    
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UserProfileSettingsViewModel()
        let userSession = UserSession(profileViewModel: viewModel)
        LoginView(userSession: userSession)
    }
}

