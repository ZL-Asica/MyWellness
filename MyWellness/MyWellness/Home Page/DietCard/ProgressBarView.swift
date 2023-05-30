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
    var color: Color {
        progress < 1 ? .purple : .green
    }
    
    init (title: String, value: Int, maxValue: Int) {
        self.title = title
        self.value = value
        self.maxValue = maxValue
        self.progress = min(Float(value) / Float(maxValue), 1) // Make sure progress is at most 1
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
            
            GeometryReader { geometry in
                let validProgress = (geometry.size.width.isFinite && progress.isFinite) ? CGFloat(progress) : 0
                let progressWidth = validProgress * geometry.size.width

                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(color.opacity(0.3))
                    .frame(height: 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(color)
                            .frame(width: progressWidth, height: 20)
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
        ProgressBarView(title: "Carbs", value: 200, maxValue: 250)
    }
}
