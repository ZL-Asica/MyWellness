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
    private func getDietRecommendation(BMI: Double, dietHistory: [DietAssignDate], exerciseHistory: [ExerciseAssignDate], meals: Int) -> String {
        var recommendation = ""

        // Based on BMI
        if BMI < 18.5 {
            recommendation += "\n\tIncrease intake with balanced meals."
        } else if BMI > 25 {
            recommendation += "\n\tDecrease intake and avoid high-fat/high-carb food."
        }
        
        print("\tDietRecommendation load success")

        // Based on diet history
        let totalDataCount = dietHistory.count
        // 1. If first day register.
        if totalDataCount == 1 {
            return recommendation
        }
        // 2. Get last 5 days' diet data.
        // Rach data have 3 values, corresponse to 3 meals a day.
        var avgCarb = [0, 0, 0]
        var avgProtein = [0, 0, 0]
        var avgFat = [0, 0, 0]
        var avgKcal = [0, 0, 0]
        
        var validDaysCount = 0
        var exceedDietDays = 0
        var loopTime = 5
        
        // If not enough for 5 days data, use how many it has
        if totalDataCount < 5 {
            loopTime = totalDataCount
        }
        
        for i in 0..<loopTime {
            let tempDietValue = dietHistory[totalDataCount - i - 1].dietValue
            let tempExerciseValue = exerciseHistory[totalDataCount - i - 1].activitiesData
            if tempDietValue.meals[0].kcal == 0 && tempDietValue.meals[1].kcal == 0 && tempDietValue.meals[2].kcal == 0 {
                continue
            }
            // Add validDaysCount for calculating the average value
            validDaysCount += 1
            
            avgCarb[0] += tempDietValue.meals[0].carbs
            avgCarb[1] += tempDietValue.meals[1].carbs
            avgCarb[2] += tempDietValue.meals[2].carbs
            
            avgProtein[0] += tempDietValue.meals[0].protein
            avgProtein[1] += tempDietValue.meals[1].protein
            avgProtein[2] += tempDietValue.meals[2].protein
            
            avgFat[0] += tempDietValue.meals[0].fat
            avgFat[1] += tempDietValue.meals[1].fat
            avgFat[2] += tempDietValue.meals[2].fat
            
            avgKcal[0] += tempDietValue.meals[0].kcal
            avgKcal[1] += tempDietValue.meals[1].kcal
            avgKcal[2] += tempDietValue.meals[2].kcal
            
            // Consider exercise consumed calorie from BMR
            var exerciseConsumed = 0
            for j in stride(from: 0, through: tempExerciseValue.count - 1, by: 1) {
                exerciseConsumed += tempExerciseValue[j].calorie
            }
            
            if tempDietValue.meals[0].kcal + tempDietValue.meals[1].kcal + tempDietValue.meals[2].kcal > tempDietValue.nutrientsGoals.kcal - exerciseConsumed {
                exceedDietDays += 1
            }
        }
        // calculate the actual averga value here
        avgCarb[0] /= validDaysCount
        avgCarb[1] /= validDaysCount
        avgCarb[2] /= validDaysCount
        
        avgProtein[0] /= validDaysCount
        avgProtein[1] /= validDaysCount
        avgProtein[2] /= validDaysCount

        avgFat[0] /= validDaysCount
        avgFat[1] /= validDaysCount
        avgFat[2] /= validDaysCount
        
        avgKcal[0] /= validDaysCount
        avgKcal[1] /= validDaysCount
        avgKcal[2] /= validDaysCount
        
        // 3. Calculate the goal of carbs, protein, and fat based on the calorie intake
        let carbsShouldBe = Int(Double(avgKcal[meals]) * 0.5 / 4 * 1.1)
        let proteinShouldBe = Int(Double(avgKcal[meals]) * 0.3 / 4 * 1.1)
        let fatShouldBe = Int(Double(avgKcal[meals]) * 0.2 / 9 * 1.1)
        
        let mealsPortion = [(0.25, 0.35), (0.3, 0.4), (0.25, 0.35)]
        
        let mealsCorrespondWords = ["breakfast", "lunch", "dinner"]
        
        // 4. Check whether user has already logged today's meals th meal.
        
        var indi = meals
        if dietHistory.last?.dietValue.meals[meals].kcal != 0 {
            if meals == 2 {
                indi = 0
            } else {
                indi = meals + 1
            }
        }
        
        // 5. Recommendation of diet
        if avgCarb[indi] < Int(Double(carbsShouldBe) * mealsPortion[indi].0) {
            recommendation += "\n\tTake more carbs for your next \(mealsCorrespondWords[indi])"
        } else if avgCarb[indi] > Int(Double(carbsShouldBe) * mealsPortion[indi].1) {
            recommendation += "\n\tTake less carbs for your next \(mealsCorrespondWords[indi])"
        }
        
        if avgProtein[indi] < Int(Double(proteinShouldBe) * mealsPortion[indi].0) {
            recommendation += "\n\tTake more protein for your next \(mealsCorrespondWords[indi])"
        } else if avgProtein[indi] > Int(Double(proteinShouldBe) * mealsPortion[indi].1) {
            recommendation += "\n\tTake less protein for your next \(mealsCorrespondWords[indi])"
        }
        
        if avgFat[indi] < Int(Double(fatShouldBe) * mealsPortion[indi].0) {
            recommendation += "\n\tTake more fat for your next \(mealsCorrespondWords[indi])"
        } else if avgFat[indi] > Int(Double(fatShouldBe) * mealsPortion[indi].1) {
            recommendation += "\n\tTake less fat for your next \(mealsCorrespondWords[indi])"
        }
        
        if exceedDietDays > 0 {
            recommendation += "\n\tYou should consider decrease your total calorie intake."
        }
        
        return recommendation
    }

    private func getExerciseRecommendation(BMI: Double, BMR: Double, exerciseHistory: [ExerciseAssignDate]) -> String {
        var recommendation = ""

        // Based on BMI
        if BMI > 25 {
            recommendation += "\n\tInclude cardio exercises to lose weight."
        }
        
        print("\tExerciseRecommendation load success")
        
        // Based on exercise history
        let totalDataCount = exerciseHistory.count
        // 1. If first day register.
        if totalDataCount == 1 {
            return recommendation
        }
        // 2. Get last 5 days' exercise data.
        var avgDuration = 0
        var avgKcal = 0
        
        var achievedDays = 0
        var almostAchieve = 0
        var loopTime = 5
        
        // If not enough for 5 days data, use how many it has
        if totalDataCount < 5 {
            loopTime = totalDataCount
        }
        
        for i in 0..<loopTime {
            let tempExerciseValue = exerciseHistory[totalDataCount - i - 1].activitiesData
            let tempExerciseGoal = exerciseHistory[totalDataCount - i - 1].kcalGoal
            if tempExerciseValue.count == 0 {
                continue
            }
            // Temp variable for calculating the total duration and colorie consumed on that day.
            var totalDuration = 0
            var totalKcal = 0
            for j in 0..<tempExerciseValue.count {
                totalDuration += tempExerciseValue[j].duration
                totalKcal += tempExerciseValue[j].calorie
            }
            // If the kcal consumed is higher than the goal set, add 1 to it.
            if totalKcal > tempExerciseGoal {
                achievedDays += 1
            } else if totalKcal > Int(Double(tempExerciseGoal) * 0.8) {
                almostAchieve += 1
            }
            avgDuration += totalDuration
            avgKcal += totalKcal
        }
        
        // 3. Recommendation of exercise
        if achievedDays >= Int(Double(loopTime) * 0.5) {
            recommendation += "\n\tGreat job, you have achieved your goal pretty well!"
        } else if almostAchieve >= Int(Double(loopTime) * 0.5) {
            recommendation += "\n\tNice, you almost achieved your goal, just one more step!"
        } else if avgDuration / loopTime < 30 * 60{
            recommendation += "\n\tConsider exercise more than 30mins per day!"
        }

        return recommendation
    }

    private func getSleepRecommendation(sleepHistory: [SleepAssignDate]) -> String {
        var recommendation = ""
        
        print("\tSleepRecommendation load success")
        
        let totalDataCount = sleepHistory.count
        // Based on sleep history
        // 1. If first day register.
        if sleepHistory.count == 1 {
            recommendation += "\n\tRecommendation will start the next day you registered."
            return recommendation
        }
        
        let calendar = Calendar.current
        if calendar.component(.hour, from: sleepHistory.last?.actualStartTimeLastNight ?? Date()) == 23 && calendar.component(.hour, from: sleepHistory.last?.actualEndTimeLastNight ?? Date()) == 1 {
            recommendation += "\n\tLog your last night sleep data below"
            return recommendation
        }
        
        // 2. Get last 5 days' sleep data.
        var avgSleepTime = 0.0
        
//        var achievedDays = 0
        var validDataCount = 0
        var loopTime = 5
        
        // If not enough for 5 days data, use how many it has
        if totalDataCount < 5 {
            loopTime = totalDataCount
        }
        
        for i in 0..<loopTime {
            let tempSleepVlue = sleepHistory[totalDataCount - i - 1]
            
            let actualStart = calendar.component(.hour, from: tempSleepVlue.actualStartTimeLastNight)
            let actualEnd = calendar.component(.hour, from: tempSleepVlue.actualEndTimeLastNight)
            let setStart = calendar.component(.hour, from: tempSleepVlue.settedStartTime)
            let setEnd = calendar.component(.hour, from: tempSleepVlue.settedEndTime)
            if (actualStart == 23 && actualEnd == 1) || (setStart == 23 && setEnd == 1) {
                continue
            }
            
            validDataCount += 1
            let actualTimeInterval = tempSleepVlue.actualEndTimeLastNight.timeIntervalSince(tempSleepVlue.actualStartTimeLastNight)
            let hoursOfActualSleep: Double = actualTimeInterval / 3600 // Convert seconds to hours
            
//            let setTimeInterval = tempSleepVlue.actualEndTimeLastNight.timeIntervalSince(tempSleepVlue.actualStartTimeLastNight)
//            let hoursOfSetSleep = setTimeInterval / 3600 // Convert seconds to hours
            avgSleepTime += hoursOfActualSleep
        }
        
        avgSleepTime /= Double(validDataCount)
        
        if avgSleepTime < 7 {
            recommendation += "\n\tTry to get at least 7-8 hours of sleep."
        } else if avgSleepTime >= 10 {
            recommendation += "\n\tTry to get at most 7-8 hours of sleep."
        }

        return recommendation
    }
    
    private func recommendationSystem(BMI: Double, BMR: Double, dietHistory: [DietAssignDate], exerciseHistory: [ExerciseAssignDate], sleepHistory: [SleepAssignDate]) -> String {
        var recommendation = ""
        // Get the current time first
        // For recommendation part, get last first days of data maximum.
        // Use valid data only(valid data: 1. Have kcal log for at lease one of breakfast,
        // lunch, or dinner on last day. 2. Have actual sleep data on last day.). If not enough
        // for 5 days, use how many days valid for recommendation(average value).
        // If no valid data in past 5 days, just remind log the data as below.
        // 1. If user was the first day registered. Skip the sleep time log.
        // Go to the thrid part directly
        // 2. After the set sleep end time last night, and before 7 am,
        // and user not set their last night sleep data yet(start = 23, end = 1), remind them to set it.
        // 3. If user already set their last night sleep time, and time before 11am,
        // remind the user to log their breakfast data, based on last 5 days data
        // and the progress of their weight/goal date(if applicable) to remind them
        // what should to do(kcal, carb, protein, or fat).
        // If already set, and time after 10 am, remind them to log lunch data.
        // Otherwise, remind them to log exercise, and give recommendation.
        // 4. If time after 11 am and before 5 pm, remind them to set lunch.
        // give them recommendation same as breakfast.
        // If already set, and time after 4 pm, remind them to log dinner data.
        // Otherwise, remind them to log exercise, and give recommendation.
        // 5. If time after 5 pm and before 9 pm, remind them to set the dinner data,
        // give the same kind of recommendation as breakfast and lunch.
        // If already set, remind to set sleep time.
        // 6. After 9 pm, remind user to confirm their sleep time tonight
        // if they have not changed it to corrct data yet(start = 23, end = 1).
        // Give some recommendation on that. If already set, just remind
        // them recommendation of exercise and give recommendation.
        // 7. Set 50% of random chance to give recommendation on exercise for users,
        // during the breakfast, lunch, dinner setting time.
        
        // Get the current time first
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
            case 0...6:
                // User has not logged today's sleep
                if Int.random(in: 1...2) == 1 { // 50% chance to recommend exercise
                    recommendation += getSleepRecommendation(sleepHistory: userSession.sleepValueDict)
                } else {
                    // User already logged sleep, remind to log breakfast
                    recommendation += getDietRecommendation(BMI: BMI, dietHistory: dietHistory, exerciseHistory: exerciseHistory, meals: 0)
                }
            case 7...10:
                // Remind user to log breakfast and lunch
                let randomNumber = Int.random(in: 1...3)
                if randomNumber == 1 { // 50% chance to recommend exercise
                    recommendation += getExerciseRecommendation(BMI: BMI, BMR: BMR, exerciseHistory: exerciseHistory)
                } else if randomNumber == 2 {
                    recommendation += getDietRecommendation(BMI: BMI, dietHistory: dietHistory, exerciseHistory: exerciseHistory, meals: 0)
                } else {
                    recommendation += getSleepRecommendation(sleepHistory: userSession.sleepValueDict)
                }
            case 11...18:
                // Remind user to log lunch
                if Int.random(in: 1...2) == 1 { // 50% chance to recommend exercise
                    recommendation += getExerciseRecommendation(BMI: BMI, BMR: BMR, exerciseHistory: exerciseHistory)
                } else {
                    recommendation += getDietRecommendation(BMI: BMI, dietHistory: dietHistory, exerciseHistory: exerciseHistory, meals: 1)
                }
            case 19...20:
                // Remind user to log dinner
                recommendation += getDietRecommendation(BMI: BMI, dietHistory: dietHistory, exerciseHistory: exerciseHistory, meals: 2)
            case 21...23:
                // Remind user to confirm sleep time
                if let latestSleep = sleepHistory.last, Calendar.current.component(.hour, from: latestSleep.settedStartTime) == 23 && Calendar.current.component(.hour, from: latestSleep.settedEndTime) == 1 {
                    recommendation += "Please confirm your sleep time and write your diary for tonight."
                } else {
                    if Int.random(in: 1...2) == 1 { // 50% chance to recommend exercise
                        recommendation += getExerciseRecommendation(BMI: BMI, BMR: BMR, exerciseHistory: exerciseHistory)
                    } else {
                        let tempSleepRecon = getSleepRecommendation(sleepHistory: sleepHistory)
                        if tempSleepRecon == "" {
                            recommendation += getDietRecommendation(BMI: BMI, dietHistory: dietHistory, exerciseHistory: exerciseHistory, meals: 2)
                        } else {
                            recommendation += tempSleepRecon
                        }
                    }
                }
            default:
                break
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
                    // Recommendation
                    Text("\(recommendationSystem(BMI:userSession.BMI, BMR: Double(userSession.BMR), dietHistory: userSession.dietValueDict, exerciseHistory: userSession.exerciseValueDict, sleepHistory: userSession.sleepValueDict))")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding()
                
                VStack {
                    DietCardView(userSession: userSession, date: SelectedDate(Date()))
                    ExerciseCardView(userSession: userSession, date: SelectedDate(Date()))
                    SleepCardView(userSession: userSession, date: SelectedDate(Date()))
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
