//
//  GravatarProfileFetcher.swift
//  MyWellness
//
//  Created by ZL Asica on 5/7/23.
//

import Foundation
import Combine
import CryptoKit

class GravatarProfileFetcher: ObservableObject {
    @Published var userName: String = ""
    
    func fetchProfileInfo(userEmail: String) {
        let email = userEmail.lowercased()
        let hashedEmail = Insecure.MD5.hash(data: Data(email.utf8)).map { String(format: "%02hhx", $0) }.joined()
        let profileURL = "https://en.gravatar.com/\(hashedEmail).json"
        
        guard let url = URL(string: profileURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let gravatarProfile = try? JSONDecoder().decode(GravatarProfile.self, from: data) else { return }
            DispatchQueue.main.async {
                self.userName = gravatarProfile.entry.first?.displayName ?? ""
            }
        }.resume()
    }
}

struct GravatarProfile: Codable {
    let entry: [GravatarEntry]
}

struct GravatarEntry: Codable {
    let displayName: String
}
