//
//  ExerciseManager.swift
//  MyWellness
//
//  Created by ZL Asica on 5/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
//import HealthKit

struct Activities: Codable, Identifiable {
    var id = UUID()
    var exerciseType: String // Entered by user
    var duration: Int // Gonna be calculated in seconds
    var calorie: Int // Entered by user
    var totalMiles: Double // 0 for no need for this value
    init(exerciseType: String, duration: Int, calorie: Int, totalMiles: Double) {
        self.exerciseType = exerciseType
        self.duration = duration
        self.calorie = calorie
        self.totalMiles = totalMiles
    }
}

//struct Walking: Codable {
//    // This structure should get data automatically from Apple Health
//    // Should be auto updated every 5 minustes if the app is runing in forntEnd
//    var steps: Int
//    var mileage: Double
//    var walkingCalories: Int
//    init(steps: Int, mileage: Double, walkingCalories: Int) {
//        self.steps = steps
//        self.mileage = mileage
//        self.walkingCalories = walkingCalories
//    }
//}

struct ExerciseAssignDate: Codable {
    var kcalGoal: Int
//    var walkingData: Walking
    var activitiesData: [Activities]
    init(kcalGoal: Int) {
        self.kcalGoal = kcalGoal
//        self.walkingData = Walking(steps: 1000, mileage: 10.0, walkingCalories: 300)
        self.activitiesData = []
    }
}

struct Exercise: Codable {
    let userId: String
    // date of the day (only date, no time)
    var exerciseValueDict: [ExerciseAssignDate] = []
    
    init(userId: String, kcalGoal: Int) {
        self.userId = userId
        self.exerciseValueDict.append(ExerciseAssignDate(kcalGoal: kcalGoal))
    }
    
    init(userId: String, exerciseValueDict: [ExerciseAssignDate]) {
        self.userId = userId
        self.exerciseValueDict = exerciseValueDict
    }
}

//enum HealthDataError: Error {
//    case authorizationDenied
//}

final class ExerciseManager {
    private var gravatarProfileFetcher = GravatarProfileFetcher()
    
//    let healthStore = HKHealthStore()
        
    static let shared = ExerciseManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("exercise")
    
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    func createnewUser(exercise: Exercise) async throws {
        try userDocument(userId: exercise.userId).setData(from: exercise, merge: false, encoder: encoder)
    }
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func getUser(userId: String) async throws -> Exercise {
        try await userDocument(userId: userId).getDocument(as: Exercise.self, decoder: decoder)
    }
    
    func updateUserExerciseInfo(exercise: Exercise) async throws {
        try userDocument(userId: exercise.userId).setData(from: exercise, merge: true, encoder: encoder)
    }
    
    // -----------------------------
    // Customized functions for Exercise Manager here
    // -----------------------------
    func calculateActivityDuration(from startDate: Date, to endDate: Date) -> Int {
        let diffInSeconds = Int(endDate.timeIntervalSince(startDate))
        return diffInSeconds
    }
//
//    func updateWalkingData(for date: Date) async throws -> Walking {
//        // 1. Define the HealthKit types to read
//        let stepsCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        let distanceWalkingRunningType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
//        let activeEnergyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
//
//        // 2. Set the types to read in a Set collection
//        let typesToRead: Set<HKObjectType> = [stepsCountType, distanceWalkingRunningType, activeEnergyBurnedType]
//
//        // 3. Request authorization to read the relevant data types
//        do {
//            let status = try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
//
//            guard status else {
//                throw HealthDataError.authorizationDenied
//            }
//        } catch {
//            print("ERROR-ExerciseManager: \(error)")
//        }
//
//        // 4. Calculate start and end of the specific day
//        let calendar = Calendar.current
//        let startOfDay = calendar.startOfDay(for: date)
//        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
//
//        // 5. Fetch the data from HealthKit and map it into Walking data
//        let steps = await fetchSum(for: stepsCountType, predicate: predicate)
//        let mileage = await fetchSum(for: distanceWalkingRunningType, predicate: predicate)
//        let walkingCalories = await fetchSum(for: activeEnergyBurnedType, predicate: predicate)
//
//        return Walking(steps: Int(steps), mileage: mileage, walkingCalories: Int(walkingCalories))
//    }
//
//    private func fetchSum(for type: HKQuantityType, predicate: NSPredicate) async -> Double {
//        let (result, error) = await withCheckedContinuation { continuation in
//            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
//                continuation.resume(returning: (result, error))
//            }
//
//            healthStore.execute(query)
//        }
//
//        guard let statResult = result, error == nil else {
//            return 0.0
//        }
//
//        let unit = type == HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) ? HKUnit.meterUnit(with: .kilo) : HKUnit.count()
//        return statResult.sumQuantity()?.doubleValue(for: unit) ?? 0.0
//    }
}
