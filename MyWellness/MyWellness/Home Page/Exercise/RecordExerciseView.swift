//
//  RecordExerciseView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct RecordExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var exerciseType = ""
    @State private var startTime: Date = Date()
    @State private var duration = ""
    @State private var caloriesBurned = ""
    @State private var totalMiles = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Exercise Type", text: $exerciseType)
                    DatePicker("Start Time", selection: $startTime, displayedComponents: [.hourAndMinute])
                    TextField("Duration - minutes", value: $duration, formatter: NumberFormatter()).keyboardType(.numberPad)
                    TextField("Calories - kcal", value: $caloriesBurned, formatter: NumberFormatter()).keyboardType(.numberPad)
                    TextField("Total Miles - Miles (optional)", value: $totalMiles, formatter: NumberFormatter()).keyboardType(.numberPad)
                }
            }
            .navigationTitle("Record Exercise")
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }.foregroundColor(.red),
                trailing:
                    Button("Save") {
                        // Save the exercise data
                        presentationMode.wrappedValue.dismiss()
                    }.foregroundColor(.blue)
            )
        }
    }
}

struct RecordExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        RecordExerciseView()
    }
}

