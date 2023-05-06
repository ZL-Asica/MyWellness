//
//  ExerciseCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct ExerciseLogView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var exerciseLogs: [ExerciseLog] = [] // Replace this with actual exercise logs from HealthKit or Firebase

    var body: some View {
        NavigationView {
            List(exerciseLogs) { log in
                VStack(alignment: .leading) {
                    Text(log.exerciseType)
                    Text("Duration: \(Int(log.duration / 60)) min")
                    Text("Calories: \(log.caloriesBurned) kcal")
                    if log.totalMiles > 0 {
                        Text("Miles: \(String(format: "%.2f", log.totalMiles))")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // Show edit exercise log view
                }
            }
            .navigationTitle("Exercise Logs")
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }.foregroundColor(.red)
            )
        }
    }
}

struct ExerciseLog: Identifiable {
    var id = UUID()
    var exerciseType: String
    var startTime: Date
    var duration: TimeInterval
    var caloriesBurned: Int
    var totalMiles: Double
}
