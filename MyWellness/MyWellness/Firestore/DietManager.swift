//
//  DietManager.swift
//  MyWellness
//
//  Created by ZL Asica on 5/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Meals: Codable {
    // calorie intake of this meal / calorie goal of the day
    var kcal: Int
    // carbs intake of this meal / carbs goal of the day
    var carbs: Int
    // carbs intake of this meal / carbs goal of the day
    var protein: Int
    // carbs intake of this meal / carbs goal of the day
    var fat: Int
    
    init(kcal: Int, carbs: Int, protein: Int, fat: Int) {
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fat = fat
    }
}

struct DietValue: Codable {
    var nutrientsGoals: Meals
    // 0: breakfast, 1: lunch, 2: dinner
    var meals: [Meals] = []
    
    init(nutrientsGoals: Meals) {
        self.nutrientsGoals = nutrientsGoals
        let emptyMeal = Meals(kcal: 0, carbs: 0, protein: 0, fat: 0)
        self.meals.append(emptyMeal) // breakfast: meals[0]
        self.meals.append(emptyMeal) // lunch: meals[1]
        self.meals.append(emptyMeal) // dinner: meals[2]
    }
}

struct DietAssignDate: Codable {
    // date of the day (only date, no time)
    var dietValue: DietValue
    init(kcalGoal: Int) {
        // Calculate the goal of carbs, protein, and fat based on the calorie goal
        let carbsGoal = Int(Double(kcalGoal) * 0.5 / 4)
        let proteinGoal = Int(Double(kcalGoal) * 0.3 / 4)
        let fatGoal = Int(Double(kcalGoal) * 0.2 / 9)
        self.dietValue = DietValue(nutrientsGoals: Meals(kcal: kcalGoal, carbs: carbsGoal, protein: proteinGoal, fat: fatGoal))
    }
}

struct Diet: Codable {
    let userId: String
    // date of the day (only date, no time)
    var dietValueDict: [DietAssignDate] = []
    
    init(userId: String, kcalGoal: Int) {
        self.userId = userId
        self.dietValueDict.append(DietAssignDate(kcalGoal: kcalGoal))
    }
    
    init(userId: String, dietValueDict: [DietAssignDate]) {
        self.userId = userId
        self.dietValueDict = dietValueDict
    }
}

final class DietManager {
    private var gravatarProfileFetcher = GravatarProfileFetcher()
    
    static let shared = DietManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("diet")
    
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    func createnewUser(diet: Diet) async throws {
        try userDocument(userId: diet.userId).setData(from: diet, merge: false, encoder: encoder)
    }
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func getUser(userId: String) async throws -> Diet {
        try await userDocument(userId: userId).getDocument(as: Diet.self, decoder: decoder)
    }
    
    func updateUserDietInfo(diet: Diet) async throws {
        try userDocument(userId: diet.userId).setData(from: diet, merge: true, encoder: encoder)
    }
}
