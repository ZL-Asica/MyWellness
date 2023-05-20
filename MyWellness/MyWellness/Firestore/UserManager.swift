//
//  UserManager.swift
//  MyWellness
//
//  Created by ZL Asica on 5/17/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let dateCreated: Date
    var email: String?
    var displayName: String
    
    // User's personal data
    var weight: Double
    var height: Double
    var dateOfBirth: Date
    
    // For weight goal and checking the progress
    var weightAtGoalSetted: Double
    var weightGoal: Double
    
    // The date user setted their weight goal and date they want to achieve it
    var goalSettedDate: Date
    var goalExpectDate: Date
    
    init(userId: String, email: String, displayName: String, weight: Double, height: Double, dateOfBirth: Date, weightGoal: Double, goalExpectDate: Date) {
        self.userId = userId
        self.dateCreated = Date()
        self.email = email
        self.displayName = displayName
        
        // User's personal data
        self.weight = weight
        self.height = height
        self.dateOfBirth = dateOfBirth
        
        // For weight goal and checking the progress
        self.weightAtGoalSetted = self.weight
        self.weightGoal = weightGoal
        
        // The date user setted their weight goal
        self.goalSettedDate = self.dateCreated
        self.goalExpectDate = goalExpectDate
    }
}

final class UserManager {
    private var gravatarProfileFetcher = GravatarProfileFetcher()
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    func createnewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
    }
    
    func updateUserBasicInfo(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
    }
}
