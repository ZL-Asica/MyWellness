//
//  BMIView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/6/23.
//

import SwiftUI

struct BMIView: View {
    var bmi: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Current BMI")
                    .bold()
                Spacer()
                Text(String(format: "%.1f", bmi))
                    .bold()
            }
            .padding(.horizontal)
            
            ProgressView(value: normalize(bmi: bmi), total: 1.0)
                .progressViewStyle(BMIProgressViewStyle(bmi: bmi))
                .frame(height: 20)
                .padding(.horizontal)
        }
        .padding(.vertical, 10)
    }
    
    func normalize(bmi: Double) -> Double {
        let minBMI: Double = 15.0
        let maxBMI: Double = 40.0
        if bmi > maxBMI {
            return 1.0
        } else if bmi < minBMI {
            return 0.0
        }
        return (bmi - minBMI) / (maxBMI - minBMI)
    }
}

struct BMIProgressViewStyle: ProgressViewStyle {
    var bmi: Double
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            GeometryReader { geo in
                let width = geo.size.width
                
                // Underweight (10-18.4)
                Rectangle()
                    .frame(width: width * ((18.4999 - 15) / 25))
                    .foregroundColor(.gray.opacity(0.5))
                
                // Normal (18.5-24.9)
                Rectangle()
                    .frame(width: width * ((24.9999 - 18.5) / 25), alignment: .leading)
                    .offset(x: width * ((18.5 - 15) / 25))
                    .foregroundColor(.green.opacity(0.8))
                
                // Overweight (25.0-29.9)
                Rectangle()
                    .frame(width: width * ((29.9999 - 25.0) / 25), alignment: .leading)
                    .offset(x: width * ((25 - 15) / 25))
                    .foregroundColor(.yellow.opacity(0.8))
                
                // Obese (30-34.9)
                Rectangle()
                    .frame(width: width * ((34.9999 - 30.0) / 25), alignment: .leading)
                    .offset(x: width * ((30 - 15) / 25))
                    .foregroundColor(.orange.opacity(0.8))
                
                // Extremely Obese (35-50)
                Rectangle()
                    .frame(width: width * ((50 - 35) / 25), alignment: .leading)
                    .offset(x: width * ((35 - 15) / 25))
                    .foregroundColor(.red.opacity(0.8))
                
                // BMI Indicator
                Triangle()
                    .fill(Color.black)
                    .frame(width: 15, height: 20)
                    .rotationEffect(.degrees(180))
                    .offset(x: CGFloat(configuration.fractionCompleted ?? 0) * width - 10, y: 0)
            }
        }
        .cornerRadius(10)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct BMIView_Previews: PreviewProvider {
    static var previews: some View {
        BMIView(bmi: 21.0)
    }
}
