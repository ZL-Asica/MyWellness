//
//  HomeView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var userSession: UserSession
    
    @State private var greeting = ""
    @State private var icon = Image(systemName: "sunrise.fill")
    
    // --------------------------------
    // Update greeting info
    // --------------------------------
    private func updateGreeting() {
        // Based on the time of the day, give user a greeting with icon
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 5 && hour < 12 {
            greeting = "Good Morning"
        } else if hour >= 12 && hour < 17 {
            greeting = "Good Afternoon"
        } else if hour >= 17 && hour < 23{
            greeting = "Good Evening"
        } else {
             greeting = "Sweet dreams"
        }
    }
    
    private func updateIcon() {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 5 && hour < 12 {
            icon = Image(systemName: "sunrise.fill")
        } else if hour >= 12 && hour < 17 {
            icon = Image(systemName: "sun.max.fill")
        } else if hour >= 17 && hour < 23{
            icon = Image(systemName: "sunset.fill")
        } else {
            icon = Image(systemName: "moon.zzz.fill")
        }
    }
    
    // --------------------------------
    // Get Recommendation functions here
    // --------------------------------
    private func getDietRecommendation(BMI: Double, dietHistory: [DietAssignDate], exerciseHistory: [ExerciseAssignDate]) -> String {
        var recommendation = ""

        // Based on BMI
        if BMI < 18.5 {
            recommendation += "Increase intake with balanced meals."
        } else if BMI > 25 {
            recommendation += "Decrease intake and avoid high-fat/high-carb food."
        }

        // Based on diet history
        
        // 1. If first day register.
        if dietHistory.count == 1 {
            return recommendation
        }
        // 2. Get yestday's diet data.
        if let latestDiet = dietHistory.last?.dietValue {
            print("\tDietRecommendation load success")
            
            let carbIntake = latestDiet.meals[0].carbs + latestDiet.meals[1].carbs +  latestDiet.meals[2].carbs
            let proteinInstake = latestDiet.meals[0].protein + latestDiet.meals[1].protein +  latestDiet.meals[2].protein
            let fatIntake = latestDiet.meals[0].fat + latestDiet.meals[1].fat +  latestDiet.meals[2].fat
            // 3. update recommendation on basic nutrition
            if carbIntake == 0 && proteinInstake == 0 && fatIntake == 0 {
                recommendation = "\nStarts today's diet record."
                return recommendation
            }
            // carbs
            if carbIntake <  latestDiet.nutrientsGoals.carbs {
                recommendation += "\nIntake more carbs today."
            } else if Double(carbIntake) > (Double(latestDiet.nutrientsGoals.carbs) * 1.2) {
                recommendation += "\nDecrease carbs today."
            }
            // protein
            if proteinInstake <  latestDiet.nutrientsGoals.protein {
                recommendation += "\nIntake more protein today."
            } else if Double(proteinInstake) > (Double(latestDiet.nutrientsGoals.protein) * 1.2) {
                recommendation += "\nDecrease protein today."
            }
            // fat
            if fatIntake <  latestDiet.nutrientsGoals.fat {
                recommendation += "\nIntake more fat today."
            } else if Double(fatIntake) > (Double(latestDiet.nutrientsGoals.fat) * 1.1) {
                recommendation += "\nDecrease fat today."
            }
            // 4. update on kcal of each meal
            var exerciseConsumed = 0
            for i in stride(from: 0, through: exerciseHistory.last!.activitiesData.count - 1, by: 1) {
                exerciseConsumed += exerciseHistory.last!.activitiesData[i].calorie
            }
            let kcalTotalIntake = Double(latestDiet.meals[0].kcal + latestDiet.meals[1].kcal + latestDiet.meals[2].kcal)
            if kcalTotalIntake - Double(exerciseConsumed) > Double(latestDiet.nutrientsGoals.kcal) {
                recommendation += "\nReduce your total intake."
            } else {
                // Breakfast: Around 25-30% of daily calorie intake
                if Double(latestDiet.meals[0].kcal) > kcalTotalIntake * 0.35 {
                    recommendation += "\nReduce your breakfast portion."
                } else if Double(latestDiet.meals[0].kcal) < kcalTotalIntake * 0.20 {
                    recommendation += "\nIncrease your breakfast portion."
                }
                // Lunch: Around 35-40% of daily calorie intake
                if Double(latestDiet.meals[1].kcal) > kcalTotalIntake * 0.45 {
                    recommendation += "\nReduce your lunch portion."
                } else if Double(latestDiet.meals[1].kcal) < kcalTotalIntake * 0.30 {
                    recommendation += "\nIncrease your lunch portion."
                }
                // Dinner: Around 25-35% of daily calorie intake
                if Double(latestDiet.meals[2].kcal) > kcalTotalIntake * 0.40 {
                    recommendation += "\nReduce your dinner portion."
                } else if Double(latestDiet.meals[2].kcal) < kcalTotalIntake * 0.20 {
                    recommendation += "\nIncrease your dinner portion."
                }
            }
        } else {
            print("\tDietRecommendation load failed")
        }
        return recommendation
    }

    private func getExerciseRecommendation(BMI: Double, BMR: Double, exerciseHistory: [ExerciseAssignDate]) -> String {
        var recommendation = ""

        // Based on BMI
        if BMI > 25 {
            recommendation += "Include cardio exercises to lose weight."
        }

        // Based on exercise history
        // 1. If first day register.
        if exerciseHistory.count == 1 {
            return recommendation
        }
        // 2. Get yestday's exercise data.
        if let latestExercise = exerciseHistory.last?.activitiesData {
            print("\tExerciseRecommendation load success")
        
            if latestExercise.count == 0 {
                recommendation += "\nExercise plz."
            } else {
                var totalExerciseTime = 0
                var exerciseConsumed = 0
                for i in stride(from: 0, through: latestExercise.count, by: 1) {
                    totalExerciseTime += latestExercise[i].duration
                    exerciseConsumed += latestExercise[i].calorie
                }
                
                // based on exercise calorie
                if Double(exerciseConsumed) < Double(exerciseHistory.last!.kcalGoal) * 0.2 {
                    recommendation += "\nConsume more colorie."
                } else if Double(exerciseConsumed) < Double(exerciseHistory.last!.kcalGoal) * 0.5 {
                    recommendation += "\nConsume one time more colorie."
                } else if Double(exerciseConsumed) < Double(exerciseHistory.last!.kcalGoal) * 0.7 {
                    recommendation += "\nGreat! Just some more to your goal!"
                } else if Double(exerciseConsumed) < Double(exerciseHistory.last!.kcalGoal) {
                    recommendation += "\nAlmost there! Just one step more!"
                } else {
                    recommendation += "\nNice job today!"
                    return recommendation
                }
                
                // based on exercise time
                if totalExerciseTime / 60 < 30 {
                    recommendation += "\nIncrease your exercise time."
                }
            }
        } else {
            print("\tExerciseRecommendation load failed")
        }

        return recommendation
    }

    private func getSleepRecommendation(sleepHistory: [SleepAssignDate]) -> String {
        var recommendation = ""

        // Based on sleep history
        // 1. If first day register.
        if sleepHistory.count == 1 {
            recommendation += "Recommendation will start the next day you registered."
            return recommendation
        }
        
        if let latestSleep = sleepHistory.last {
            print("\tSleepRecommendation load success")
        
            let calendar = Calendar.current

            if calendar.component(.hour, from: latestSleep.actualStartTimeLastNight) == 23 &&
                calendar.component(.hour, from: latestSleep.actualEndTimeLastNight) == 7 &&
                calendar.component(.hour, from: latestSleep.settedStartTime) == 23 &&
                calendar.component(.hour, from: latestSleep.settedEndTime) == 7 {
                recommendation += "\nRecord last night sleep time and set today's goal below."
                return recommendation
            }
            
            let timeInterval = latestSleep.actualEndTimeLastNight.timeIntervalSince(latestSleep.actualStartTimeLastNight)
            let hoursOfSleep = timeInterval / 3600 // Convert seconds to hours

            if hoursOfSleep < 7 {
                recommendation += "\nTry to get at least 7-8 hours of sleep every night."
            } else if hoursOfSleep > 9 {
                recommendation += "\nTry to get at least 7-8 hours of sleep every night."
            }
            
            let calendarForSleepRecommendation = Calendar.current
            let now = Date()

            if latestSleep.diary.diaryContent == "" && calendarForSleepRecommendation.component(.hour, from: now) >= 18 {
                recommendation += "\nRemember to write your diary for today below."
            }
        } else {
            print("\tSleepRecommendation load failed")
        }

        return recommendation
    }

    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    // Give user a greeting based on the time of the day
                    Text("\(greeting) \(icon)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("\(userSession.displayName)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    // Show user's BMI and the corresponding health status
                    Text("BMI: \(userSession.BMI, specifier: "%.1f") (\(userSession.BMI < 18.5 ? "Underweight" : userSession.BMI < 25 ? "Normal" : userSession.BMI < 30 ? "Overweight" : "Obese"))")
                        .font(.title2)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding()
                
                // Recommendation Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recommendations for you:")
                        .font(.headline)
                    
                    // Recommendation for Diet
                    HStack {
                        Text("Diet: ")
                            .bold()
                        Text("\(getDietRecommendation(BMI: userSession.BMI, dietHistory: userSession.dietValueDict, exerciseHistory: userSession.exerciseValueDict))\n")
                    }
                    // Recommendation for Exercise
                    HStack {
                        Text("Exercise: ")
                            .bold()
                        Text("\(getExerciseRecommendation(BMI: userSession.BMI, BMR: Double(userSession.BMR), exerciseHistory: userSession.exerciseValueDict))\n")
                    }
                    // Recommendation for Sleep
                    HStack {
                        Text("Sleep: ")
                            .bold()
                        Text("\(getSleepRecommendation(sleepHistory: userSession.sleepValueDict))\n")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding()
                
                VStack {
                    DietCardView(userSession: userSession, date: Date())
                    ExerciseCardView(userSession: userSession, date: Date())
                    SleepCardView(userSession: userSession, date: Date())
                }
                .padding(.bottom)
                .onAppear {
                    updateGreeting()
                    updateIcon()
                }
                
                Spacer()
            }.padding()
        }
        .onAppear {
            updateGreeting()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UserProfileSettingsViewModel()
        let userSession = UserSession(profileViewModel: viewModel)
        HomeView(userSession: userSession)
    }
}
