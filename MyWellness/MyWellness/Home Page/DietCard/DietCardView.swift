//
//  DietCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct DietCardView: View {
    @ObservedObject var userSession: UserSession
    
    @State var date: Date
    @State private var dateDifference: Int = 0
    
    @State private var totalCalories = 0
    @State private var consumedCalories = 0
    @State private var carbs = (consumed: 0, total: 0)
    @State private var protein = (consumed: 0, total: 0)
    @State private var fat = (consumed: 0, total: 0)
    @State private var meals = (breakfast: 0, lunch: 0, dinner: 0)
    
    @State private var breakfast = Meals(kcal: 0, carbs: 0, protein: 0, fat: 0)
    @State private var lunch = Meals(kcal: 0, carbs: 0, protein: 0, fat: 0)
    @State private var dinner = Meals(kcal: 0, carbs: 0, protein: 0, fat: 0)
    
    @State private var showingRecordDiet = false
    @State private var showingChangeCalorieGoal = false
    @State private var showingChangeNutrientGoal = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Diet") // align this text to center
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                            showingChangeCalorieGoal.toggle()
                        }) {
                            ProgressCircleView(consumed: consumedCalories, total: totalCalories)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showingChangeCalorieGoal) {
                            ChangeCalorieGoalView(userSession: userSession, calorieGoal: $totalCalories, date: date)
                        }
            
            HStack {
                ProgressBarView(title: "Carbs", value: carbs.consumed, maxValue: carbs.total, color: .purple).padding(.trailing, 10)
                ProgressBarView(title: "Protein", value: protein.consumed, maxValue: protein.total, color: .purple).padding(.trailing, 10)
                ProgressBarView(title: "Fat", value: fat.consumed, maxValue: fat.total, color: .purple)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .onTapGesture {
                showingChangeNutrientGoal.toggle()
            }
            .sheet(isPresented: $showingChangeNutrientGoal) {
                ChangeNutrientGoalView(userSession: userSession, date: Date(), totalCalories: totalCalories, currentCarbGoal: $carbs.total, currentProteinGoal: $protein.total, currentFatGoal: $fat.total)
            }
            
            HStack {
                MealInfoView(title: "Breakfast", calories: meals.breakfast).padding(.trailing, 10)
                MealInfoView(title: "Lunch", calories: meals.lunch).padding(.trailing, 10)
                MealInfoView(title: "Dinner", calories: meals.dinner)
            }
            .padding(.top, 5)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                showingRecordDiet.toggle()
            }) {
                Text("Record")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $showingRecordDiet) {
                RecordDietView(userSession: userSession, date: date, consumedCalories: $consumedCalories, carbs: $carbs, protein: $protein, fat: $fat, meals: $meals, breakfast: $breakfast, lunch: $lunch, dinner: $dinner)
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
            dateDifference = userSession.calculateDateDifference(date1: userSession.dateCreated, date2: Date())
            let dietToday = userSession.dietValueDict[dateDifference]
            totalCalories = dietToday.dietValue.nutrientsGoals.kcal
            
            carbs.total = dietToday.dietValue.nutrientsGoals.carbs
            protein.total = dietToday.dietValue.nutrientsGoals.protein
            fat.total = dietToday.dietValue.nutrientsGoals.fat
            
            breakfast = dietToday.dietValue.meals[0]
            lunch = dietToday.dietValue.meals[1]
            dinner = dietToday.dietValue.meals[2]
            
            meals.breakfast = breakfast.kcal
            meals.lunch = lunch.kcal
            meals.dinner = dinner.kcal
            
            consumedCalories = meals.breakfast + meals.lunch + meals.dinner
            carbs.consumed = breakfast.carbs + lunch.carbs + dinner.carbs
            protein.consumed = breakfast.protein + lunch.protein + dinner.protein
            fat.consumed = breakfast.fat + lunch.fat + dinner.fat
        }
    }
}

//struct DietCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = UserProfileSettingsViewModel()
//        let userSession = UserSession(profileViewModel: viewModel)
//        DietCardView(userSession: userSession, dateToday: Date())
//    }
//}
