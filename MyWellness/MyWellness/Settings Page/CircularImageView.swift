//
//  CircularImageView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/7/23.
//

import SwiftUI
import Combine

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
        CircularImageView(gravatarURL: "https://www.gravatar.com/avatar")
    }
}

