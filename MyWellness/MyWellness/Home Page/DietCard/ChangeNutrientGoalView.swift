//
//  ChangeNutrientGoalView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct ChangeNutrientGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession
    
    @State var date: Date
    
    @State var totalCalories: Int
    @Binding var currentCarbGoal: Int
    @Binding var currentProteinGoal: Int
    @Binding var currentFatGoal: Int
    
    @State private var carbGoal: String = ""
    @State private var proteinGoal: String = ""
    @State private var fatGoal: String = ""
    
    var body: some View {
        NavigationView {
            HStack {
                Spacer()
                Text("Leave it blank if you do not want to change that.")
                Spacer()
            }
            
            Form {
                // Show each nutrient goal and allow the user to change it
                Text("Carbs Goal (g)")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("(\(currentCarbGoal) g) Your new goal ...", text: $carbGoal)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)

                Text("Protein Goal (g)")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("(\(currentProteinGoal) g) Your new goal ...", text: $proteinGoal)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

                Text("Fat Goal (g)")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("(\(currentFatGoal) g) Your new goal ...", text: $fatGoal)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            .navigationBarTitle("Change Nutrients Goal")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red),
            trailing: Button("Save") {
                if !(carbGoal.isEmpty || proteinGoal.isEmpty || fatGoal.isEmpty) {
                    if !carbGoal.isEmpty {
                        currentCarbGoal = Int(carbGoal)  ?? currentFatGoal
                    }
                    if !proteinGoal.isEmpty {
                        currentProteinGoal = Int(proteinGoal) ?? currentProteinGoal
                    }
                    if !fatGoal.isEmpty {
                        currentFatGoal = Int(fatGoal) ?? currentFatGoal
                    }
                    
                    var dietValueDict = userSession.dietValueDict
                    let tempMeal = Meals(kcal: totalCalories, carbs: currentCarbGoal, protein: currentProteinGoal, fat: currentFatGoal)
                    dietValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date)].dietValue.nutrientsGoals = tempMeal
                    Task {
                        let diet = Diet(userId: userSession.uid, dietValueDict: dietValueDict)
                        do {
                            try await DietManager.shared.updateUserBasicInfo(diet: diet)
                        } catch {
                            print("ChangeNutrientGoal ERROR: \(error)")
                        }
                    }
                }
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.blue))
        }
    }
}

//struct ChangeNutrientGoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        var carbsNow = 20
//        var proteinNow = 20
//        var fatNow = 20
//        ChangeNutrientGoalView(
//            currentCarbGoal: carbsNow,
//            currentProteinGoal: proteinNow,
//            currentFatGoal: fatNow
//        ) { newCarbs, newProtein, newFat in
//            carbsNow = newCarbs
//            proteinNow = newProtein
//            fatNow = newFat
//        }
//    }
//}
//
