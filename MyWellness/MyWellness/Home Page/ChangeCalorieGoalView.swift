//
//  ChangeCalorieGoalView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct ChangeCalorieGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    var currentCalorieGoal: Int
    @State private var calorieGoal: String
    
    var onSave: (Int) -> Void

    init(currentCalorieGoal: Int, onSave: @escaping (Int) -> Void) {
        self.currentCalorieGoal = currentCalorieGoal
        _calorieGoal = State(initialValue: "\(currentCalorieGoal)")
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Calorie Goal", text: $calorieGoal)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            .navigationBarTitle("Change Calories Goal", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red),
            trailing: Button("Save") {
                if let newGoal = Int(calorieGoal) {
                    onSave(newGoal)
                }
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.blue))
        }
    }
}

struct ChangeCalorieGoalView_Previews: PreviewProvider {
    static var previews: some View {
        var totalCalories = 1500
        ChangeCalorieGoalView(currentCalorieGoal: totalCalories) { newGoal in
            totalCalories = newGoal
        }
    }
}

