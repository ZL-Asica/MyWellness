//
//  ExerciseCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct ExerciseLogView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var activitiesList: [Activities]
    
    var body: some View {
        NavigationView {
            if activitiesList.isEmpty {
                Text("No logs data yet. Do more exercise!")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            } else {
                List(activitiesList) { activity in
                    VStack(alignment: .leading) {
                        Text(activity.exerciseType)
                        Text("Duration: \(Int(activity.duration / 60)) min")
                        Text("Calories: \(activity.calorie) kcal")
                        if activity.totalMiles > 0 {
                            Text("Miles: \(String(format: "%.2f", activity.totalMiles))")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Show edit exercise log view
                    }
                }
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
