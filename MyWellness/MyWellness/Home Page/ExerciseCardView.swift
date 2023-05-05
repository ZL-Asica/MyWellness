//
//  ExerciseCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct ExerciseCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Exercise")
                .font(.headline)
            
            // Add content for the Exercise card here
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ExerciseCardView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseCardView()
    }
}

