//
//  ExerciseCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI
//import HealthKit

struct ExerciseCardView: View {
    @ObservedObject var userSession: UserSession
    
    @State var date: Date
    @State private var dateDifference: Int = 0
    
//    @State var exerciseToday: ExerciseAssignDate = ExerciseAssignDate(kcalGoal: 1000)
    
    // Define a Timer
    @State var timer: Timer? = nil
    
    @State private var goalCalories: Int = 0
    
//    @State private var totalSteps: Int = 0
//    @State private var totalMileage: Double = 0.0
//    @State private var walkingCalories: Int = 0 // Calories from walking
    
    @State private var activatesList: [Activities] = []
    
    @State private var activitiesCalories: Int = 0 // Calories from other activities
    @State private var totalActivitiesTime: Int = 0 // Time spent on other activities
    @State private var totalActivitiesMileage: Double = 0.0
    
    @State private var showingChangeTargetCalories: Bool = false
    @State private var showingExerciseLog: Bool = false
    @State private var showingRecordExercise: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Exercise")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Large progress circle and target calories

            Button(action: {
                            showingChangeTargetCalories.toggle()
                        }) {
//                            ProgressCircleView(consumed: walkingCalories + activitiesCalories, total: goalCalories)
                            ProgressCircleView(consumed: activitiesCalories, total: goalCalories)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showingChangeTargetCalories) {
                            ChangeExerciseCalorieGoalView(userSession: userSession, calorieGoal: $goalCalories, date: date)
                        }
            
            HStack {
//                // Steps, mileage, and calories
//                VStack(alignment: .leading) {
//                    Text("Steps").frame(maxWidth: .infinity, alignment: .center)
//                    Text("\(totalSteps)").frame(maxWidth: .infinity, alignment: .center)
//                }
//                VStack {
//                    VStack {
//                        Text("Mileage").frame(maxWidth: .infinity, alignment: .center)
//                        Text(String(format: "%.2f", totalMileage)).frame(maxWidth: .infinity, alignment: .center)
//                    }
//                    VStack {
//                        Text("Calories").frame(maxWidth: .infinity, alignment: .center)
//                        Text("\(walkingCalories) kcal").frame(maxWidth: .infinity, alignment: .center)
//                    }
//                }
//                Divider()
                
                // Other activities and calories
                VStack(alignment: .leading) {
                    Text("Activities").frame(maxWidth: .infinity, alignment: .center)
                    Text("\(Int(totalActivitiesTime / 60)) min").frame(maxWidth: .infinity, alignment: .center)
                }
                VStack {
                    Text("Calories").frame(maxWidth: .infinity, alignment: .center)
                    Text("\(activitiesCalories) kcal").frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .onTapGesture {
                showingExerciseLog.toggle()
            }
            .sheet(isPresented: $showingExerciseLog) {
                ExerciseLogView(activitiesList: activatesList)
            }

            
            // Record button
            Button(action: {
                showingRecordExercise.toggle()
            }) {
                Text("Record")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $showingRecordExercise) {
                RecordExerciseView(userSession: userSession, date: date, activitiesList: activatesList)
            }
            .padding(.top, 5)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .onAppear {
            dateDifference = userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date)
            let exerciseValueCount = userSession.sleepValueDict.count
            if exerciseValueCount < dateDifference {
                dateDifference = exerciseValueCount - 1
            }
            let exerciseToday = userSession.exerciseValueDict[dateDifference]
            goalCalories = exerciseToday.kcalGoal
//            Task {
//                do {
//                    let walkingDataRealTime: Walking = try await ExerciseManager.shared.updateWalkingData(for: date)
//                    updateWalkingData(walkingData: walkingDataRealTime)
//                } catch {
//                    print("ExerciseCard: \(error)")
//                }
//            }
            activatesList = exerciseToday.activitiesData
            updateActivitiesData(activitiesData: activatesList)
        }
//        .onDisappear {
//            if totalSteps != exerciseToday.walkingData.steps {
//                var tempExercise = exerciseToday
//                tempExercise.walkingData.mileage = totalMileage
//                tempExercise.walkingData.steps = totalSteps
//                tempExercise.walkingData.walkingCalories = walkingCalories
//                ExerciseManager.shared.updateUserExerciseInfo(exercise: Exercise(userId: userSession.uid, exerciseValueDict: tempExercise))
//            }
//        }
    }
    
//    func updateWalkingData(walkingData: Walking) {
//        totalSteps = walkingData.steps
//        totalMileage = walkingData.mileage
//        walkingCalories = walkingData.walkingCalories
//    }
    
    func updateActivitiesData(activitiesData: [Activities]) {
        for i in activitiesData {
            activitiesCalories += i.calorie
            totalActivitiesTime += i.duration
            totalActivitiesMileage += i.totalMiles
        }
    }
    
//    // Fetches the latest walking data and updates the UI
//    func fetchAndUpdateWalkingData() {
//        Task {
//            do {
//                let walkingData = try await ExerciseManager.shared.updateWalkingData(for: date)
//                updateWalkingData(walkingData: walkingData)
//            } catch {
//                print("Failed to update walking data: \(error)")
//            }
//        }
//    }
//
//    // Starts the timer to update walking data every 30 seconds
//    func startWalkingDataRealTimeUpdate() {
//        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
//            fetchAndUpdateWalkingData()
//        }
//    }
//
//    // Stops the timer
//    func stopWalkingDataRealTimeUpdate() {
//        timer?.invalidate()
//        timer = nil
//    }
//
//    // Starts and stops the timer when the view appears and disappears
//    .onAppear {
//        startWalkingDataRealTimeUpdate()
//    }
//    .onDisappear {
//        stopWalkingDataRealTimeUpdate()
//    }
}

//struct ExerciseCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseCardView()
//    }
//}
