//
//  ExerciseCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI
import HealthKit

struct ExerciseCardView: View {
    @ObservedObject var userSession: UserSession
    
    @State var date: Date
    
    @State private var totalSteps: Int = 2400
    @State private var totalMileage: Double = 3.2
    
    @State private var goalCalories: Int = 500
    @State private var totalCalories: Int = 100 // Calories from walking
    @State private var totalOtherCalories: Int = 200 // Calories from other activities
    @State private var totalOtherTime: TimeInterval = 1000 // Time spent on other activities
    
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
                            ProgressCircleView(consumed: totalOtherCalories + totalCalories, total: goalCalories)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showingChangeTargetCalories) {
                            ChangeCalorieGoalView(userSession: userSession, calorieGoal: $goalCalories, date: date)
                        }

            
            // Steps, mileage, and calories
            // HStack {
                
            // }
            // .frame(maxWidth: .infinity, alignment: .center)
            // .contentShape(Rectangle())
            // .padding(.bottom, 5)

            
            // Other activities and calories
            HStack {
                VStack(alignment: .leading) {
                    Text("Steps").frame(maxWidth: .infinity, alignment: .center)
                    Text("\(totalSteps)").frame(maxWidth: .infinity, alignment: .center)
                }
                VStack {
                    VStack {
                        Text("Mileage").frame(maxWidth: .infinity, alignment: .center)
                        Text(String(format: "%.2f", totalMileage)).frame(maxWidth: .infinity, alignment: .center)
                    }
                    VStack {
                        Text("Calories").frame(maxWidth: .infinity, alignment: .center)
                        Text("\(totalCalories) kcal").frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Divider()
                VStack(alignment: .leading) {
                    Text("Activities").frame(maxWidth: .infinity, alignment: .center)
                    Text("\(Int(totalOtherTime / 60)) min").frame(maxWidth: .infinity, alignment: .center)
                }
                VStack {
                    Text("Calories").frame(maxWidth: .infinity, alignment: .center)
                    Text("\(totalOtherCalories) kcal").frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .onTapGesture {
                showingExerciseLog.toggle()
            }
            .sheet(isPresented: $showingExerciseLog) {
                ExerciseLogView()
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
                RecordExerciseView()
            }
            .padding(.top, 5)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

//struct ExerciseCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseCardView()
//    }
//}
