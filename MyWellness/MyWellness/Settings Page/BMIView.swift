//
//  BMIView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/6/23.
//

import SwiftUI

struct BMIView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Current BMI")
                .font(.headline)
            // Implement your BMI progress bar here
            Text("BMI Progress Bar")
        }
    }
}

struct BMIView_Previews: PreviewProvider {
    static var previews: some View {
        BMIView()
    }
}