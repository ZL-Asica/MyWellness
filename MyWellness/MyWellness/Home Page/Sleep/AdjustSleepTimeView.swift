//
//  AdjustSleepTimeView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct AdjustSleepTimeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession
    @ObservedObject var date: SelectedDate
    
    @State var startTime: Date
    @State var endTime: Date
    @State var totalSleepTime: TimeInterval
    
    @State var insideStartTime: Date = Date()
    @State var insideEndTime: Date = Date()
    @State var insideTotalTime: TimeInterval = 0

    var body: some View {
        VStack {
            Text("Adjust Last Night's Sleep Time")
                .font(.headline)
                .padding(.bottom, 10)
            
            HStack {
                DatePicker("Start Time (Last night)", selection: $insideStartTime, displayedComponents: .hourAndMinute)
                    .padding(.top, 10)
                    .font(.footnote)
                    .onChange(of: insideStartTime) { newStartTime in // Add this block
                        insideTotalTime = endTime.timeIntervalSince(newStartTime)
                    }

                Text(Image(systemName: "arrow.right"))
                    .font(.title2)
                    .padding(.horizontal, 10)

                DatePicker("End Time (Today)", selection: $insideEndTime, displayedComponents: .hourAndMinute)
                    .padding(.top, 10)
                    .font(.footnote)
                    .onChange(of: insideEndTime) { newEndTime in // Add this block
                        insideTotalTime = newEndTime.timeIntervalSince(insideStartTime)
                    }
            }

            Text("Total Sleep Time: \(totalSleepTimeString(insideTotalTime))")
                .foregroundColor(insideTotalTime < 7 * 3600 ? .red : .primary)
                .padding(.top, 10)

            Button("Save") {
                // Return those three Date and TimeInterval values and close the popover
                insideTotalTime = insideEndTime.timeIntervalSince(insideStartTime)
                if !(insideStartTime >= insideEndTime || insideTotalTime <= 100) {
                    startTime = insideStartTime
                    endTime = insideEndTime
                    totalSleepTime = insideTotalTime
                    
                    var sleepValueDict = userSession.sleepValueDict
                    
                    var tempSleep = sleepValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date.date)]
                    
                    tempSleep.actualStartTimeLastNight = startTime
                    tempSleep.actualEndTimeLastNight = endTime
                    
                    sleepValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date.date)] = tempSleep
                    
                    Task {
                        let sleep = Sleep(userId: userSession.uid, sleepValueDict: sleepValueDict)
                        do {
                            try await SleepManager.shared.updateUserSleepInfo(sleep: sleep)
                            userSession.reloadUserLoginInfo()
                        } catch {
                            print("AdjustSleepTime ERROR: \(error)")
                        }
                    }
                }
                presentationMode.wrappedValue.dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .background(Color.blue)
            .cornerRadius(8)
            .onAppear {
                insideStartTime = startTime
                insideEndTime = endTime
                insideTotalTime = totalSleepTime
            }
        }
        .padding()
    }

    private func totalSleepTimeString(_ sleepTime: TimeInterval) -> String {
        let hours = Int(sleepTime / 3600)
        let minutes = Int((sleepTime.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours) hours \(minutes) minutes"
    }
}

//struct AdjustSleepTimeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdjustSleepTimeView(startTime: .constant(Date()), endTime: .constant(Date()), totalSleepTime: .constant(0))
//    }
//}
