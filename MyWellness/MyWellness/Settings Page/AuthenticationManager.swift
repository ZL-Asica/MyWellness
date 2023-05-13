//
//  AuthenticationManager.swift
//  MyWellness
//
//  Created by ZL Asica on 5/12/23.
//

import Foundation
import FirebaseAuth


struct AuthDtaResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDtaResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDtaResultModel(user: user)
    }
    
    @discardableResult
    func accountSignIn(email: String, password: String) async throws -> AuthDtaResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDtaResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDtaResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDtaResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
