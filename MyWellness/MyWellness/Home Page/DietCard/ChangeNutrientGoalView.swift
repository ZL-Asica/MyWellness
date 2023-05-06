//
//  ChangeNutrientGoalView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct ChangeNutrientGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    var currentCarbGoal: Int
    var currentProteinGoal: Int
    var currentFatGoal: Int
    var totalNutrientGoal: Int
    @State private var carbGoal: String
    @State private var proteinGoal: String
    @State private var fatGoal: String
    var onSave: (Int, Int, Int) -> Void

    init(currentCarbGoal: Int, currentProteinGoal: Int, currentFatGoal: Int, onSave: @escaping (Int, Int, Int) -> Void) {
        self.currentCarbGoal = currentCarbGoal
        self.currentProteinGoal = currentProteinGoal
        self.currentFatGoal = currentFatGoal
        _carbGoal = State(initialValue: "\(currentCarbGoal)")
        _proteinGoal = State(initialValue: "\(currentProteinGoal)")
        _fatGoal = State(initialValue: "\(currentFatGoal)")
        self.totalNutrientGoal = currentCarbGoal + currentProteinGoal + currentFatGoal
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Show each nutrient goal and allow the user to change it
                Text("Carbs Goal (g)")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $carbGoal)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)

                Text("Protein Goal (g)")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $proteinGoal)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

                Text("Fat Goal (g)")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $fatGoal)
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
                let newCarbs = carbGoal.isEmpty ? currentCarbGoal : Int(carbGoal) ?? 0
                let newProtein = proteinGoal.isEmpty ? currentProteinGoal : Int(proteinGoal) ?? 0
                let newFat = fatGoal.isEmpty ? currentFatGoal : Int(fatGoal) ?? 0

                onSave(newCarbs, newProtein, newFat)
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.blue))
        }
    }
}

struct ChangeNutrientGoalView_Previews: PreviewProvider {
    static var previews: some View {
        var carbsNow = 20
        var proteinNow = 20
        var fatNow = 20
        ChangeNutrientGoalView(
            currentCarbGoal: carbsNow,
            currentProteinGoal: proteinNow,
            currentFatGoal: fatNow
        ) { newCarbs, newProtein, newFat in
            carbsNow = newCarbs
            proteinNow = newProtein
            fatNow = newFat
        }
    }
}

