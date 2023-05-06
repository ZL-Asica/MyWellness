//
//  MealInfoView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct MealInfoView: View {
    var title: String
    var calories: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
            
            Text("\(calories) kcal")
                .font(.footnote)
        }
    }
}

struct MealInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MealInfoView(title: "Breakfast", calories: 600)
    }
}

