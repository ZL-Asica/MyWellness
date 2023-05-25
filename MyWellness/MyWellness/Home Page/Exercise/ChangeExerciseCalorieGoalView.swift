//
//  ChangeExerciseCalorieGoalView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/22/23.
//

import SwiftUI

struct ChangeExerciseCalorieGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession

    @Binding var calorieGoal: Int
    @State var date: Date
    
    @State private var userEntered: String = ""
    @State private var calorieNow: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Exercis Calorie Goal", text: $userEntered)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            .navigationBarTitle("Change Exercise Goal")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red),
            trailing: Button("Save") {
                calorieNow = calorieGoal
                calorieGoal = Int(userEntered) ?? calorieGoal
                if calorieGoal != calorieNow {
                    calorieNow = calorieGoal
                    var exerciseValueDict = userSession.exerciseValueDict
                    exerciseValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date)].kcalGoal = calorieGoal
                    Task {
                        let exercise = Exercise(userId: userSession.uid, exerciseValueDict: exerciseValueDict)
                        do {
                            try await ExerciseManager.shared.updateUserExerciseInfo(exercise: exercise)
                            userSession.reloadUserLoginInfo()
                        } catch {
                            print("ChangeExerciseCalorieGoal ERROR: \(error)")
                        }
                    }
                }
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.blue))
        }
    }
}

//struct ChangeExerciseCalorieGoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        var totalCalories = 1500
//        let viewModel = UserProfileSettingsViewModel()
//        let userSession = UserSession(profileViewModel: viewModel)
//        ChangeExerciseCalorieGoalView(userSession: userSession, calorieGoal: $totalCalories)
//    }
//}
//
