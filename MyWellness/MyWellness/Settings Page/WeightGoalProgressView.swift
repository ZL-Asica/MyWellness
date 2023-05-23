//
//  WeightGoalProgressView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/6/23.
//

import SwiftUI

struct WeightGoalProgressView: View {
    var startWeight: Double
    var targetWeight: Double
    var currentWeight: Double

    var body: some View {
        VStack(alignment: .leading) {
            Text("Weight Progress")
                .font(.headline)
                .padding(.horizontal)
            
            HStack {
                Text("\(Int(startWeight)) lbs")
                Spacer()
                Text("\(Int(targetWeight)) lbs")
            }
            .font(.caption)
            .padding(.horizontal)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 20)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                    .cornerRadius(15)
                
                Rectangle()
                    .frame(width: goalProgress() * UIScreen.main.bounds.width, height: 20)
                    .foregroundColor(Color(UIColor.systemTeal))
                    .cornerRadius(15)
                
                Text("\(progressPercentage(), specifier: "%.1f") %")
                    .font(.caption)
                    .frame(width: 50, height: 30)
                    .background(Color.gray.opacity(0.95))
                    .foregroundColor(Color.black)
                    .clipShape(Ellipse())
                    .offset(x: CGFloat(goalProgress() * Double(UIScreen.main.bounds.width)) - 25)
            }
            .padding(.vertical, 10)
            
        }
        .padding()
    }

    func goalProgress() -> Double {
        let progress = (startWeight - currentWeight) / (startWeight - targetWeight)
        return Double(min(max(0.0, progress), 1.0))
    }

    func progressPercentage() -> Double {
        return goalProgress() * 100
    }
}

struct WeightGoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        WeightGoalProgressView(startWeight: 200, targetWeight: 150, currentWeight: 180)
    }
}
