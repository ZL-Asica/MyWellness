//
//  ProgressCircleView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct ProgressCircleView: View {
    var consumed: Int
    var total: Int
    var progress: CGFloat {
        CGFloat(consumed) / CGFloat(total)
    }
    
    var body: some View {
        // align this text to center
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.3)
                .foregroundColor(Color.blue)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(-90))
            
            VStack {
                Text("\(consumed) / \(total)")
                    .font(.body)
                    .padding(.bottom, 4)
                Text("kcal")
                    .font(.caption2)
            }
        }
        .frame(width: 120, height: 120)
        }
    }

    struct ProgressCircleView_Previews: PreviewProvider {
        static var previews: some View {
                ProgressCircleView(consumed: 1500, total: 2000)
        }
    }
