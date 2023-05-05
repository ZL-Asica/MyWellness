//
//  DietCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct DietCardView: View {
    @State private var totalCalories = 2000
    @State private var consumedCalories = 1500
    @State private var carbs = (consumed: 200, total: 250)
    @State private var protein = (consumed: 80, total: 100)
    @State private var fat = (consumed: 50, total: 70)
    @State private var meals = (breakfast: 600, lunch: 500, dinner: 400)
    @State private var showingRecordDiet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Diet") // align this text to center
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            ProgressCircleView(consumed: consumedCalories, total: totalCalories)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                ProgressBarView(title: "Carbs", value: carbs.consumed, maxValue: carbs.total, color: .purple).padding(.trailing, 10)
                ProgressBarView(title: "Protein", value: protein.consumed, maxValue: protein.total, color: .purple).padding(.trailing, 10)
                ProgressBarView(title: "Fat", value: fat.consumed, maxValue: fat.total, color: .purple)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
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
                RecordDietView()
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

struct DietCardView_Previews: PreviewProvider {
    static var previews: some View {
        DietCardView()
    }
}
