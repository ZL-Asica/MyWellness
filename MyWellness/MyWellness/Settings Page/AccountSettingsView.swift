//
//  AccountSettingsView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/12/23.
//

import SwiftUI

@MainActor
final class AccountSettingsViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var displayName = ""
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    func updateEmail() async throws {
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
//    func updateDisplayName() async throws {
//        try await AuthenticationManager.shared.updateDisplayName(name: displayName)
//    }
}

struct AccountSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AccountSettingsViewModel()
    
    var body: some View {
        VStack{
            Spacer()
            Text("Update Account")
                .font(.title)
                .bold()
                .padding()
            Spacer()
            
            HStack{
                Text("Update Display Name/Avatar")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            Text("If you want to set/change your personal display name or avatar, please go to Gravatar website just clik on the button below.")
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(15)
            
            Link("Gravatar website", destination: URL(string: "https://gravatar.com/connect/?source=_signup")!)
                .padding()
                .bold()
                .background(Color.blue.opacity(0.8))
                .cornerRadius(15)
                .padding(.bottom, 15)
                .foregroundColor(Color.white)
            
            VStack{
                // Reset display name
//                TextField("Reset your display name if needed...", text: $viewModel.displayName)
//                    .textContentType(.name)
//                    .padding()
//                    .background(Color.gray.opacity(0.3))
//                    .cornerRadius(15)
//                Button("Update Display Name") {
//                    Task {
//                        do {
//                            try await viewModel.updateDisplayName()
//                            print("Sucess Updated the display name")
//                            viewModel.alertTitle = "Update Display Name Sucessed"
//                            viewModel.alertMessage = "Your display name has been sucessfully updated."
//                            viewModel.showAlert = true
//                            presentationMode.wrappedValue.dismiss()
//                        } catch {
//                            print("Error with updating display name: \(error)")
//                            viewModel.alertTitle = "Update Display Name Failed"
//                            viewModel.alertMessage = error.localizedDescription
//                            viewModel.showAlert = true
//                        }
//                    }
//                }
//                .padding()
//                .bold()
//                .background(Color.blue.opacity(0.8))
//                .cornerRadius(15)
//                .padding(.bottom, 15)
//                .foregroundColor(Color.white)
                
                Divider()
                
                // Reset email
                HStack{
                    Text("Reset Email")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                TextField("Reset email if needed...", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(15)
                Button("Update Email") {
                    Task {
                        do {
                            try await viewModel.updateEmail()
                            print("Sucess Updated the email")
                            viewModel.alertTitle = "Update Emial Sucessed"
                            viewModel.alertMessage = "Your email update successed"
                            viewModel.showAlert = true
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error with updating email: \(error)")
                            viewModel.alertTitle = "Update Email Failed"
                            viewModel.alertMessage = error.localizedDescription
                            viewModel.showAlert = true
                        }
                    }
                }
                .padding()
                .bold()
                .background(Color.blue.opacity(0.8))
                .cornerRadius(15)
                .padding(.bottom, 15)
                .foregroundColor(Color.white)
                
                Divider()
                // Reset password
                HStack{
                    Text("Reset Password")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                TextField("Reset password if needed...", text: $viewModel.password)
                    .textContentType(.password)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(15)
                Button("Update Password") {
                    Task {
                        do {
                            try await viewModel.updatePassword()
                            print("Sucess Updated the password")
                            viewModel.alertTitle = "Update Password Sucessed"
                            viewModel.alertMessage = "Your password updated successed."
                            viewModel.showAlert = true
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error with updating password: \(error)")
                            viewModel.alertTitle = "Update Password Failed"
                            viewModel.alertMessage = error.localizedDescription
                            viewModel.showAlert = true
                        }
                    }
                }
                .padding()
                .bold()
                .background(Color.blue.opacity(0.8))
                .cornerRadius(15)
                .padding(.bottom, 15)
                .foregroundColor(Color.white)
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
        .padding()
        
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AccountSettingsView()
        }
    }
}
