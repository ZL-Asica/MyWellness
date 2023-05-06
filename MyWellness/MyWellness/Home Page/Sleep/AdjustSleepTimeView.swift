//
//  AdjustSleepTimeView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct AdjustSleepTimeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var totalSleepTime: TimeInterval

    var body: some View {
        VStack {
            Text("Adjust Sleep Time")
                .font(.headline)
                .padding(.bottom, 10)

            HStack {
                DatePicker("Start Time (Today)", selection: $startTime, displayedComponents: .hourAndMinute)
                    .padding(.top, 10)
                    .font(.footnote)
                    .onChange(of: startTime) { newStartTime in // Add this block
                        totalSleepTime = endTime.timeIntervalSince(newStartTime)
                    }

                Text(Image(systemName: "arrow.right"))
                    .font(.title2)
                    .padding(.horizontal, 10)

                DatePicker("End Time (Tomorrow)", selection: $endTime, displayedComponents: .hourAndMinute)
                    .padding(.top, 10)
                    .font(.footnote)
                    .onChange(of: endTime) { newEndTime in // Add this block
                        totalSleepTime = newEndTime.timeIntervalSince(startTime)
                    }
            }

            Text("Total Sleep Time: \(totalSleepTimeString(totalSleepTime))")
                .foregroundColor(totalSleepTime < 7 * 3600 ? .red : .primary)
                .padding(.top, 10)

            Button("Save") {
                // Return those three Date and TimeInterval values and close the popover
                totalSleepTime = endTime.timeIntervalSince(startTime)
                presentationMode.wrappedValue.dismiss()
            }
            .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(Color.blue)
                    .cornerRadius(8)
        }
        .padding()
    }

    private func totalSleepTimeString(_ sleepTime: TimeInterval) -> String {
        let hours = Int(sleepTime / 3600)
        let minutes = Int((sleepTime.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours) hours \(minutes) minutes"
    }
}

struct AdjustSleepTimeView_Previews: PreviewProvider {
    static var previews: some View {
        AdjustSleepTimeView(startTime: .constant(Date()), endTime: .constant(Date()), totalSleepTime: .constant(0))
    }
}
