//
//  AdjustSleepGoalView.swift
//  MyWellness
//
//  Created by ZL Asica on 6/5/23.
//

import SwiftUI

struct AdjustSleepGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession
    @State var date: Date
    
    @State var startTime: Date
    @State var endTime: Date
    @State var totalSleepTime: TimeInterval
    
    @State var insideStartTime: Date = Date()
    @State var insideEndTime: Date = Date()
    @State var insideTotalTime: TimeInterval = 0

    var body: some View {
        VStack {
            Text("Adjust Today's Sleep Goal")
                .font(.headline)
                .padding(.bottom, 10)
            
            HStack {
                DatePicker("Start Time (Today)", selection: $insideStartTime, displayedComponents: .hourAndMinute)
                    .padding(.top, 10)
                    .font(.footnote)
                    .onChange(of: insideStartTime) { newStartTime in // Add this block
                        insideTotalTime = endTime.timeIntervalSince(newStartTime)
                    }

                Text(Image(systemName: "arrow.right"))
                    .font(.title2)
                    .padding(.horizontal, 10)

                DatePicker("End Time (Tomorrow)", selection: $insideEndTime, displayedComponents: .hourAndMinute)
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
                    
                    var tempSleep = SleepAssignDate(todayDate: date)
                    
                    tempSleep.settedStartTime = startTime
                    tempSleep.settedEndTime = endTime
                    
                    sleepValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date)] = tempSleep
                    
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

//struct AdjustSleepGoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdjustSleepGoalView()
//    }
//}
