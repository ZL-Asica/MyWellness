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
    var color: Color
    var progress: CGFloat {
        CGFloat(value) / CGFloat(maxValue)
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(color)
                            .frame(width: geometry.size.width * progress, height: 20)
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
        ProgressBarView(title: "Carbs", value: 200, maxValue: 250, color: .red)
    }
}
