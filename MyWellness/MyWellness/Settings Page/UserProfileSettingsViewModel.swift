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
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        print("Here is UserProfileSettingsViewModel with user: \(String(describing: authDataResult.email))")
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        print("get user info: \(String(describing: self.user?.userId))")
    }
}
