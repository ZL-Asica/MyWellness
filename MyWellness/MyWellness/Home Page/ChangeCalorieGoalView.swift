//
//  ChangeCalorieGoalView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct ChangeCalorieGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession

    @Binding var calorieGoal: Int
    
    @State var date: Date
    
    @State private var userEntered: String = ""
    @State private var calorieNow: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Calorie Goal", text: $userEntered)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            .navigationBarTitle("Change Calories Goal")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red),
            trailing: Button("Save") {
                calorieNow = calorieGoal
                calorieGoal = Int(userEntered) ?? calorieGoal
                if calorieGoal != calorieNow {
                    var dietValueDict = userSession.dietValueDict
                    dietValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date)].dietValue.nutrientsGoals.kcal = calorieGoal
                    Task {
                        let diet = Diet(userId: userSession.uid, dietValueDict: dietValueDict)
                        do {
                            try await DietManager.shared.updateUserDietInfo(diet: diet)
                            userSession.reloadUserLoginInfo()
                        } catch {
                            print("ChangeCalorieGoal ERROR: \(error)")
                        }
                    }
                }
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.blue))
        }
    }
}

//struct ChangeCalorieGoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        var totalCalories = 1500
//        let viewModel = UserProfileSettingsViewModel()
//        let userSession = UserSession(profileViewModel: viewModel)
//        ChangeCalorieGoalView(userSession: userSession, calorieGoal: $totalCalories)
//    }
//}
//
