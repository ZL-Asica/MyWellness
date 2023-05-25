//
//  SignUpView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/18/23.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession
    @StateObject private var viewModel = SignUpWithEmailViewModel()
    @StateObject private var gravatarProfileFetcher = GravatarProfileFetcher()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image("AppIcon-Pic") // logo here
                        .resizable()
                        .cornerRadius(30)
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 50)
                    
                    Text("My Wellness")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 10)
                    
                    VStack {
                        TextField("Email...", text: $viewModel.email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(15)
                            .onTapGesture {
                                if viewModel.displayName == "" {
                                    gravatarProfileFetcher.fetchProfileInfo(userEmail: viewModel.email)
                                    viewModel.displayName = gravatarProfileFetcher.userName
                                }
                            }
                        
                        SecureField("Password...", text: $viewModel.password)
                            .textContentType(.password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(15)
                            .onTapGesture {
                                if viewModel.displayName == "" {
                                    gravatarProfileFetcher.fetchProfileInfo(userEmail: viewModel.email)
                                    viewModel.displayName = gravatarProfileFetcher.userName
                                }
                            }
                        Text("Must contain at least two of numbers, lower case, upper case, or special characters. Length minimun 6.")
                            .font(.caption)
                        Divider()
                        
                        VStack {
                            Text("Your Personal Info")
                                .font(.title2)
                                .bold()
                            
                            Text("(All Required)")
                            
                            HStack{
                                Text("Display Name:")
                                    .font(.body)
                                TextField("Name you want to use in app...", text: $viewModel.displayName)
                                    .keyboardType(.namePhonePad)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                    .onTapGesture {
                                        if viewModel.displayName == "" {
                                            gravatarProfileFetcher.fetchProfileInfo(userEmail: viewModel.email)
                                            viewModel.displayName = gravatarProfileFetcher.userName
                                        }
                                    }
                            }

                            HStack {
                                Text("Sex(born with):")
                                    .font(.body)
                                Picker(selection: $viewModel.sex, label: Text("")) {
                                    Text("Male").tag(true)
                                    Text("Female").tag(false)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                            }
                            
                            HStack{
                                Text("Weight(ponds):")
                                    .font(.body)
                                TextField("Your current weight(pounds)...", text: $viewModel.weight)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                            }
                            
                            HStack{
                                Text("Height(inches):")
                                    .font(.body)
                                TextField("Your current height(inches)...", text: $viewModel.height)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                            }
                            
                            HStack{
                                Text("Date of Birth:")
                                    .font(.body)
                                Spacer()
                                DatePicker("Select Date of Birth", selection: $viewModel.dateOfBirth, in: ...Date(), displayedComponents: .date)
                                                .datePickerStyle(.compact)
                                                .labelsHidden()
                                Spacer()
                            }
                            
                            HStack{
                                Text("Weight Goal(pounds):")
                                    .font(.body)
                                TextField("Goal(pounds)...", text: $viewModel.weightGoal)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                            }
                            
                            HStack{
                                Text("Expect Achieve:")
                                    .font(.body)
                                Spacer()
                                DatePicker("Select Expect Achieve Date", selection: $viewModel.goalExpectDate, in: Date()..., displayedComponents: .date)
                                                .datePickerStyle(.compact)
                                                .labelsHidden()
                                Spacer()
                            }
                        }.padding(.vertical, 15)
                    }
                    
                    VStack{
                        // Sign up button
                        Text("After you click the Sign Up button, please wait for 5-10 seconds for the server to update your personal info and validate your account information. Please do not click agian or change any value above before an alert pop up. Thanks!")
                            .font(.caption)
                            .padding()
                            .background(Color.pink.opacity(0.4))
                            .cornerRadius(10)
                        Button {
                            if viewModel.weight == "" || viewModel.height == "" || viewModel.displayName == "" || viewModel.weightGoal == "" || viewModel.dateOfBirth == viewModel.goalExpectDate || viewModel.goalExpectDate < Date() {
                                viewModel.alertTitle = "Personal Info"
                                viewModel.alertMessage = "You must fill in all of them before Sign Up."
                                viewModel.showAlert = true
                            } else {
                                do {
                                    try viewModel.signUp()
                                } catch {
                                    print("Sign Up Error: \(error)")
                                    viewModel.alertTitle = "Sign Up Failed"
                                    viewModel.alertMessage = error.localizedDescription
                                    viewModel.showAlert = true
                                }
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
                        if viewModel.hideWindow {
                            print("Sign up success")
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
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UserProfileSettingsViewModel()
        let userSession = UserSession(profileViewModel: viewModel)
        SignUpView(userSession: userSession)
    }
}
