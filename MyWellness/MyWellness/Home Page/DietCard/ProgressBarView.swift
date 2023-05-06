//
//  ProgressBarView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct ProgressBarView: View {
    var title: String
    var value: Int
    var maxValue: Int
    var progress: Float
    var color: Color = .purple
    // set color based on the value of progress
    // purple if progress < 1, green otherwise
    
    init (title: String, value: Int, maxValue: Int, color: Color = .purple) {
        self.title = title
        self.value = value
        self.maxValue = maxValue
        self.progress = Float(value) / Float(maxValue)
        self.color = progress < 1 ? .purple : .green
        if progress > 1 {
            self.progress = 1
        }
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
            
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(color.opacity(0.3))
                    .frame(height: 20)
                    // should be left aligned
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(color)
                            .frame(width: CGFloat(progress) * geometry.size.width, height: 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )
            }
            .frame(height: 20)
            
            Text("\(value) / \(maxValue) g")
                .font(.caption)
        }
        .frame(width: 80)
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(title: "Carbs", value: 200, maxValue: 250, color: .purple)
    }
}
