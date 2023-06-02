//
//  SleepManager.swift
//  MyWellness
//
//  Created by ZL Asica on 5/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Diary: Codable {
    // possible weatherIcons is ["sun.max", "cloud.sun", "cloud.bolt", "cloud.heavyrain", "cloud.snow", "wind", "hurricane"]
    var weatherSelected: String
    // possible emotion are [0: "Worst", 1: "Terrible", 2: "Bad", 3: "Unhappy", 4: "Sad", 5: "Moderate",
    //                       6: "Satisfied", 7: "Happy", 8: "Joyful", 9: "Excited", 10: "Best"]
    var emotionSelected: String
    // Set a limit of max words count user can enter.
    var diaryContent: String
    init() {
        self.weatherSelected = "sun.max"
        self.emotionSelected = "Moderate"
        self.diaryContent = ""
    }
}

struct SleepAssignDate: Codable {
    var settedStartTime: Date
    var settedEndTime: Date
    
    var actualStartTimeLastNight: Date
    var actualEndTimeLastNight: Date
    
    var diary: Diary
    
    init(todayDate: Date) {
        let calendar = Calendar.current
        
        // Get yesterday's date
        let yesterday = calendar.date(byAdding: .day, value: -1, to: todayDate)!
        
        // Set the start time to yesterday at 11 PM
        self.settedStartTime = calendar.date(bySettingHour: 23, minute: 0, second: 0, of: yesterday)!
        
        // Set the end time to today at 7 AM
        self.settedEndTime = calendar.date(bySettingHour: 7, minute: 0, second: 0, of: todayDate)!
        
        // Set actualStartTimeLastNight to settedStartTime minus one day
        self.actualStartTimeLastNight = calendar.date(byAdding: .day, value: -1, to: self.settedStartTime)!
        
        // Set actualEndTimeLastNight to settedEndTime minus one day
        self.actualEndTimeLastNight = calendar.date(byAdding: .day, value: -1, to: self.settedEndTime)!

        self.diary = Diary()
    }
}

struct Sleep: Codable {
    let userId: String
    var sleepValueDict: [SleepAssignDate] = []
    
    init(userId: String, todayDate: Date) {
        self.userId = userId
        self.sleepValueDict.append(SleepAssignDate(todayDate: todayDate))
    }

    init(userId: String, sleepValueDict: [SleepAssignDate]) {
        self.userId = userId
        self.sleepValueDict = sleepValueDict
    }
}

final class SleepManager {
    private var gravatarProfileFetcher = GravatarProfileFetcher()
    
    //    let healthStore = HKHealthStore()
    
    static let shared = SleepManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("sleep")
    
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    func createnewUser(sleep: Sleep) async throws {
        try userDocument(userId: sleep.userId).setData(from: sleep, merge: false, encoder: encoder)
    }
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func getUser(userId: String) async throws -> Sleep {
        try await userDocument(userId: userId).getDocument(as: Sleep.self, decoder: decoder)
    }
    
    func updateUserSleepInfo(sleep: Sleep) async throws {
        try userDocument(userId: sleep.userId).setData(from: sleep, merge: true, encoder: encoder)
    }
    
    // -----------------------------
    // Customized functions for Sleep Manager here
    // -----------------------------
    func calculateActivityDuration(from startDate: Date, to endDate: Date) -> TimeInterval {
        let duration = endDate.timeIntervalSince(startDate)
        return duration
    }
}
