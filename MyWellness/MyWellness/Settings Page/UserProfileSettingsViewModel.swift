//
//  UserProfileSettingsViewModel.swift
//  MyWellness
//
//  Created by ZL Asica on 5/18/23.
//

import Foundation

@MainActor
final class UserProfileSettingsViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var diet: Diet? = nil
    private var uid = ""
    
    private var userLoadedContinuation: CheckedContinuation<Void, Never>? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        print("UserProfileSettingsViewModel: \(String(describing: authDataResult.email))\n - \(String(describing: self.user?.userId))")
        self.uid = authDataResult.uid
        self.user = try await UserManager.shared.getUser(userId: self.uid)
        print("get user info: \(String(describing: self.user))")
        
        // Resume the continuation once the user is loaded
        userLoadedContinuation?.resume()
        userLoadedContinuation = nil
    }
    
    func loadCurrentUserDiet() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.uid = authDataResult.uid
        self.diet = try await DietManager.shared.getUser(userId: self.uid)
        
        // Resume the continuation once the user is loaded
        userLoadedContinuation?.resume()
        userLoadedContinuation = nil
    }
    
    func awaitUserLoaded() async {
        // Wait until the user is loaded
        await withCheckedContinuation { continuation in
            self.userLoadedContinuation = continuation
        }
    }
}
