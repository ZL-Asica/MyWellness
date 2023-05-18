//
//  FireStoreDataAccess.swift
//  MyWellness
//
//  Created by ZL Asica on 5/15/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct UserData {
    // This userData struct gonna be the basic struct of every user
    // Will be binded with user's personal UID
    var userDisplayName: String = "" // update this by gravatar
    var personalData: UserPersonalData
    var dailyHealthData: [Date:HealthDataOfUser]
}

struct UserPersonalData {
    // User's personal data
    var weight: Double
    var height: Double
    var dateOfBirth: Date
    // BMI and BMR now
    var bmi: Double
    var bmr: Double
    // For weight goal and checking the progress
    var weightAtGoalSetted: Double
    var weightGoal: Double
    // The date user setted their weight goal
    var goalSettedDate: Date
}

struct HealthDataOfUser {
    // Every day will have data split into diet, exercise, and sleeping
    // Each data structure is corresponde with each
    var diet: Diet
    var exercise: Exercise
    var sleeping: Sleeping
}

struct Diet {
    // Will have nutrientsGoals in total
    // The seperate nutrients intake will be auto calculated when frontend is runing
    var nutrientsGoals: Meals = Meals(kcal: 0, carbs: 0, protein: 0, fat: 0)
    var meals: [String:Meals] = [:]
}

struct Meals {
    // calorie intake of this meal / calorie goal of the day
    var kcal: Int
    // carbs intake of this meal / carbs goal of the day
    var carbs: Double
    // carbs intake of this meal / carbs goal of the day
    var protein: Double
    // carbs intake of this meal / carbs goal of the day
    var fat: Double
}

struct Exercise {
    var calorieGoal: Int
    // Should be calculated automatically based on the walkingData.walkingCalories + eveyone in activitiesData.calorie
    var calorieAchieved: Int?
    var walkingData: Walking // walking data
    var activitiesData: [Date:Activities] = [:]
}

struct Walking {
    // This structure should get data automatically from Apple Health
    // Should be auto updated every 5 minustes if the app is runing in forntEnd
    var steps: Int
    var mileage: Double
    var walkingCalories: Int
}

struct Activities {
    var exerciseType: String // Entered by user
    var duration: Int // Gonna be calculated in seconds
    var calorie: Int // Entered by user
    var totalMiles: Double? // Optional
}

struct Sleeping {
    // Use settedStatTime and settedEndTime to calculate the setted sleep goal in hours
    var settedStartTime: Date
    var settedEndTime: Date
    // Use actualStarTime and actualEndTime to calculate the actual sleep goal in hoours
    var actualStartTime: Date?
    var actualEndTime: Date?
    // The diary user has written
    var diary: Diary
}

struct Diary {
    // possible weatherIcons is ["sun.max", "cloud.sun", "cloud.bolt", "cloud.heavyrain", "cloud.snow", "wind", "hurricane"]
    var weatherSelected: String
    // possible emotion is [0: "Worst", 1: "Terrible", 2: "Bad", 3: "Unhappy", 4: "Sad", 5: "Moderate", 6: "Satisfied", 7: "Happy", 8: "Joyful", 9: "Excited", 10: "Best"]
    var emotionSelected: String
    // Set a limit of max words count user can enter.
    var diaryContent: String
}

//final class FirestoreManager {
//    
//    static let shared = FirestoreManager()
//    private let db = Firestore.firestore()
//    
//    private init() { }
//    
//    func getUserData(uid: String, completion: @escaping (Result<UserData, Error>) -> Void) {
//        let docRef = db.collection("users").document(uid)
//
//        docRef.getDocument { (document, error) in
//            if let error = error {
//                completion(.failure(error))
//            } else if let document = document, document.exists {
//                do {
//                    let result = try JSONDecoder().decode(UserData.self, from: document.data())
//                    completion(.success(result))
//                } catch let error {
//                    completion(.failure(error))
//                }
//            } else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: nil))) // No document found
//            }
//        }
//    }
//
//    func updateUserData(uid: String, data: UserData, completion: @escaping (Error?) -> Void) {
//        do {
//            let data = try JSONEncoder().encode(data)
//            db.collection("users").document(uid).setData(data) { error in
//                completion(error)
//            }
//        } catch let error {
//            completion(error)
//        }
//    }
//}
