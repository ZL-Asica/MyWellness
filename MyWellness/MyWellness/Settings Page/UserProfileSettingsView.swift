//
//  UserProfileSettingsView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/17/23.
//

import SwiftUI

struct UserProfileSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession
    @StateObject private var viewModel = UserProfileSettingsViewModel()
    
    @State private var weight = ""
    @State private var height = ""
    @State private var weightGoal = ""
    @State private var goalExpectDate = Date()
    @State private var compareDate = Date()
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
//            Form {
            VStack {
                Text("You can change your personal data below. \nLeave it blank if you do not want to change that.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                HStack{
                    Text("Weight(ponds):")
                        .font(.body)
                    TextField("Your current weight(pounds)...", text: $weight)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                }
                
                HStack{
                    Text("Height(inches):")
                        .font(.body)
                    TextField("Your current height(inches)...", text: $height)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                }
                
                HStack{
                    Text("Weight Goal(pounds):")
                        .font(.body)
                    TextField("Goal(pounds)...", text: $weightGoal)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                }
                
                HStack{
                    Text("Expect Achieve:")
                        .font(.body)
                    Spacer()
                    DatePicker("Select Expect Achieve Date", selection: $goalExpectDate, in: Date()..., displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                    Spacer()
                }
                
                Button {
                    if weight != "" || height != "" || weightGoal != "" {
                        Task {
                            var tempUser = try await UserManager.shared.getUser(userId: AuthenticationManager.shared.getAuthenticatedUser().uid)
                            if weight != "" {
                                tempUser.weight = Double(weight) ?? tempUser.weight
                            }
                            if height != "" {
                                tempUser.height = Double(height) ?? tempUser.height
                            }
                            if weightGoal != "" {
                                tempUser.weightGoal = Double(weightGoal) ?? tempUser.weightGoal

                                let calendar = Calendar.current
                                let currentDate = Date()

                                // Set the time components to 0:00:00
                                let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
                                let zeroTimeDate = calendar.date(from: components)

                                // Assign the zeroTimeDate to the goalSettedDate property
                                tempUser.goalSettedDate = zeroTimeDate ?? Date()

                                tempUser.goalExpectDate = goalExpectDate
                            }
                            do {
                                try await UserManager.shared.updateUserBasicInfo(user: tempUser)
                                userSession.reloadUserLoginInfo()
                            } catch {
                                print("User Data Error: \(error)")
                                alertTitle = "Changes Failed"
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }.padding()
    }
}

struct UserProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView() {
            let viewModel = UserProfileSettingsViewModel()
            let userSession = UserSession(profileViewModel: viewModel)
            UserProfileSettingsView(userSession: userSession)
        }
    }
}
