//
//  CircularImageView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/7/23.
//

import SwiftUI
import CryptoKit
import Combine

// Helper function to generate Gravatar URL
func generateGravatarURL(userEmail: String, defaultImage: String = "https://www.gravatar.com/avatar") -> String {
    let email = userEmail.lowercased()
    let hashedEmail = Insecure.MD5.hash(data: Data(email.utf8)).map { String(format: "%02hhx", $0) }.joined()
    let gravatarURL = "https://www.gravatar.com/avatar/\(hashedEmail)?d=\(defaultImage)&s=150"
    
    return gravatarURL
}

struct CircularImageView: View {
    @State private var userImage: UIImage? = nil
    let gravatarURL: String

    var body: some View {
        Image(uiImage: userImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .onAppear {
                loadImage(from: gravatarURL)
            }
    }

    private func loadImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.userImage = image
            }
        }.resume()
    }
}

struct CircularImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularImageView(gravatarURL: generateGravatarURL(userEmail: "someone@somewhere.com"))
    }
}

