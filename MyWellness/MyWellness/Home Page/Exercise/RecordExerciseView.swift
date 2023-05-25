//
//  RecordExerciseView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct RecordExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession
    
    @State var date: Date
    @State var activitiesList: [Activities]
    
    @State private var exerciseType = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var duration = 0
    @State private var calories = ""
    @State private var totalMiles = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Exercise Type", text: $exerciseType)
                    DatePicker("Start Time", selection: $startTime, displayedComponents: [.hourAndMinute])
                    DatePicker("End Time", selection: $endTime, displayedComponents: [.hourAndMinute])
                    TextField("Calories - kcal", text: $calories)
                        .keyboardType(.numberPad)
                    TextField("Total Miles - Miles (optional)", text: $totalMiles)
                        .keyboardType(.numberPad)
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
                        if !(exerciseType.isEmpty || startTime >= endTime || calories.isEmpty) {
                            var exerciseValueDict = userSession.exerciseValueDict
                            
                            var tempActivities = Activities(exerciseType: exerciseType, duration: calculateDuration(startTime: startTime, endTime: endTime), calorie: Int(calories) ?? 0, totalMiles: 0.0)
                            if !totalMiles.isEmpty {
                                tempActivities.totalMiles = Double(totalMiles) ?? 0.0
                            }
                            activitiesList.append(tempActivities)
                            
                            exerciseValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date)].activitiesData = activitiesList
                            
                            Task {
                                let exercise = Exercise(userId: userSession.uid, exerciseValueDict: exerciseValueDict)
                                do {
                                    try await ExerciseManager.shared.updateUserExerciseInfo(exercise: exercise)
                                } catch {
                                    print("RecordExercise ERROR: \(error)")
                                }
                            }
                            userSession.reloadUserLoginInfo()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            )
        }
    }
    
    private func calculateDuration(startTime: Date, endTime: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: startTime, to: endTime)
        let minutes = components.minute ?? 0
        let seconds = minutes * 60
        return seconds
    }
}

//struct RecordExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordExerciseView()
//    }
//}
//
