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
    @State var date: Date
    @State var indi: Int // 0 is yestarday(actual), 1 is today's goal(setted)
    
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
                if !(startTime >= endTime || totalSleepTime <= 100) {
                    var sleepValueDict = userSession.sleepValueDict
                    
                    var tempSleep = SleepAssignDate(todayDate: date)
                    if indi == 0 {
                        tempSleep.actualStartTimeLastNight = startTime
                        tempSleep.actualEndTimeLastNight = endTime
                    } else {
                        tempSleep.settedStartTime = startTime
                        tempSleep.settedEndTime = endTime
                    }
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
