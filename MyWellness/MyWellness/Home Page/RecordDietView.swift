//
//  RecordDietView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct RecordDietView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var mealType = "Breakfast"
    @State private var calories = ""
    @State private var carbs = ""
    @State private var protein = ""
    @State private var fat = ""
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Meal Type", selection: $mealType) {
                    Text("Breakfast").tag("Breakfast")
                    Text("Lunch").tag("Lunch")
                    Text("Dinner").tag("Dinner")
                }
                
                TextField("Calories (kcal)", text: $calories)
                    .keyboardType(.numberPad)
                
                TextField("Carbs (g)", text: $carbs)
                    .keyboardType(.numberPad)
                
                TextField("Protein (g)", text: $protein)
                    .keyboardType(.numberPad)
                
                TextField("Fat (g)", text: $fat)
                    .keyboardType(.numberPad)
                
                // create a save button here
                Button("Save", action: {
                    // Save the data to Apple Health or Firebase, then dismiss the view
                    // Save the data to Apple Health or Firebase, then dismiss the view
                    // TODO: Save the data to Apple Health or Firebase
                    // Check if the user has entered all the data
                    if calories.isEmpty || carbs.isEmpty || protein.isEmpty || fat.isEmpty {
                        // TODO: Show an alert to the user
                        
                    }
                    presentationMode.wrappedValue.dismiss()
                })
            }
            .navigationBarTitle("Record Diet", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                // Dismiss the view
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct RecordDietView_Previews: PreviewProvider {
    static var previews: some View {
        RecordDietView()
    }
}
