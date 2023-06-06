//
//  WeightGoalDateView.swift
//  MyWellness
//
//  Created by ZL Asica on 6/4/23.
//

import SwiftUI

struct WeightGoalDateView: View {
    var startDate: Date
    var targetDate: Date
    var currentDate: Date = Date()
    let dateFormatter: DateFormatter

    init(startDate: Date, targetDate: Date) {
        self.startDate = startDate
        self.targetDate = targetDate
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(dateFormatter.string(from: startDate))") // only show month/day
                Spacer()
                Text("\(dateFormatter.string(from: targetDate))") // only show month/day
            }
            .font(.caption)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 20)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                    .cornerRadius(15)
                
                Rectangle()
                    .frame(width: dateGoalProgress() * UIScreen.main.bounds.width, height: 20)
                    .foregroundColor(Color(UIColor.systemTeal))
                    .cornerRadius(15)
                
                Text("\(progressPercentage(), specifier: "%.1f") %")
                    .font(.caption)
                    .frame(width: 50, height: 30)
                    .background(Color.gray.opacity(0.95))
                    .foregroundColor(Color.black)
                    .clipShape(Ellipse())
                    .offset(x: CGFloat(dateGoalProgress() * Double(UIScreen.main.bounds.width)) - 25)
            }
            
        }
        .padding()
    }

    func dateGoalProgress() -> Double {
        // calculate the days have passed
        let totalDays = Calendar.current.dateComponents([.day], from: startDate, to: targetDate).day!
        let passedDays = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day!
        let progress = Double(passedDays) / Double(totalDays)
        return min(max(0.0, progress), 1.0)
    }

    func progressPercentage() -> Double {
        return dateGoalProgress() * 100
    }
}

struct WeightGoalDateView_Previews: PreviewProvider {
    static var previews: some View {
        WeightGoalDateView(startDate: Date(), targetDate: Calendar.current.date(byAdding: .day, value: 60, to: Date())!)
    }
}
