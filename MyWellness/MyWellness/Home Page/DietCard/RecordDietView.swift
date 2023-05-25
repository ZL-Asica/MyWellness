//
//  RecordDietView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct RecordDietView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession
    
    @State var date: Date
    
    @Binding var consumedCalories: Int
    @Binding var carbs: (consumed: Int, total: Int)
    @Binding var protein: (consumed: Int, total: Int)
    @Binding var fat: (consumed: Int, total: Int)
    @Binding var meals: (breakfast: Int, lunch: Int, dinner: Int)
    
    @Binding var breakfast: Meals
    @Binding var lunch: Meals
    @Binding var dinner: Meals
    
    @State private var mealType = "Breakfast"
    @State private var caloriesStr = ""
    @State private var carbsStr = ""
    @State private var proteinStr = ""
    @State private var fatStr = ""
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Meal Type", selection: $mealType) {
                    Text("Breakfast").tag("Breakfast")
                    Text("Lunch").tag("Lunch")
                    Text("Dinner").tag("Dinner")
                }
                
                TextField("Calories (kcal)", text: $caloriesStr)
                    .keyboardType(.numberPad)
                
                TextField("Carbs (g)", text: $carbsStr)
                    .keyboardType(.numberPad)
                
                TextField("Protein (g)", text: $proteinStr)
                    .keyboardType(.numberPad)
                
                TextField("Fat (g)", text: $fatStr)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Record Diet")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red),
            trailing: Button("Save") {
                // Save the data to Firebase, then dismiss the view
                // Check if the user has entered all the data
                if !(caloriesStr.isEmpty || carbsStr.isEmpty || proteinStr.isEmpty || fatStr.isEmpty) {
                    var dietValueDict = userSession.dietValueDict
                    if mealType == "Breakfast" {
                        breakfast.kcal = Int(caloriesStr) ?? breakfast.kcal
                        breakfast.carbs = Int(carbsStr) ?? breakfast.carbs
                        breakfast.protein = Int(proteinStr) ?? breakfast.protein
                        breakfast.fat = Int(fatStr) ?? breakfast.fat
                        dietValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date)].dietValue.meals[0] = breakfast
                    } else if mealType == "lunch" {
                        lunch.kcal = Int(caloriesStr) ?? lunch.kcal
                        lunch.carbs = Int(carbsStr) ?? lunch.carbs
                        lunch.protein = Int(proteinStr) ?? lunch.protein
                        lunch.fat = Int(fatStr) ?? lunch.fat
                        dietValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date)].dietValue.meals[1] = lunch
                    } else {
                        dinner.kcal = Int(caloriesStr) ?? dinner.kcal
                        dinner.carbs = Int(carbsStr) ?? dinner.carbs
                        dinner.protein = Int(proteinStr) ?? dinner.protein
                        dinner.fat = Int(fatStr) ?? dinner.fat
                        dietValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date)].dietValue.meals[2] = dinner
                    }
                    consumedCalories = breakfast.kcal + lunch.kcal + dinner.kcal
                    carbs.consumed = breakfast.carbs + lunch.carbs + dinner.carbs
                    protein.consumed = breakfast.protein + lunch.protein + dinner.protein
                    fat.consumed = breakfast.fat + lunch.fat + dinner.fat
                    Task {
                        let diet = Diet(userId: userSession.uid, dietValueDict: dietValueDict)
                        do {
                            try await DietManager.shared.updateUserDietInfo(diet: diet)
                            userSession.reloadUserLoginInfo()
                        } catch {
                            print("RecordDiet ERROR: \(error)")
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }.foregroundColor(.blue))
        }
    }
}

//struct RecordDietView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordDietView()
//    }
//}
