//
//  SleepCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct SleepCardView: View {
    @ObservedObject var userSession: UserSession
    
    @ObservedObject var date: SelectedDate
    @State private var dateDifference: Int = 0
    
    @State private var showingAdjustSleepTimeLastNight = false
    @State private var showingAdjustSleepTimeToday = false
    
    // startTime and endTime should be setted deafult value from yesterday's setting
    @State private var settedStartTime: Date = Date() // today's setted start time
    @State private var settedEndTime: Date = Date() // today's setted end time
    @State private var timeIntervalSleep: TimeInterval = 28800 // setted sleep time(in seconds)
    
    @State private var actualStartTime: Date = Date() // yestarday sleep start time
    @State private var actualEndTime: Date = Date() // yestarday sleep end time
    @State private var yesterdayTimeInterval: TimeInterval = 28800 // yestarday sleep time(in seconds)
    
    @State private var diary: Diary = Diary()
    @State private var showingDiaryInput = false

    var body: some View {
        VStack(alignment: .center) {
            Text("Sleep")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                showingAdjustSleepTimeLastNight.toggle()
            }) {
                VStack(alignment: .center) {
                    Text("Last night")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    HStack {
                        Text("\(actualStartTime.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits))) - \(actualEndTime.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)))")
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }.padding(.top, 10)
                    // Add the total sleep time for yesterday (green for over or equal 7 hours, red for below 7 hours)
                    .foregroundColor(yesterdayTimeInterval >= 25200 ? .green : .red)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingAdjustSleepTimeLastNight) {
                AdjustSleepTimeView(userSession: userSession, date: date, startTime: actualStartTime, endTime: actualEndTime, totalSleepTime: yesterdayTimeInterval)
            }
            .padding(.bottom, 10)
            
            Button(action: {
                showingAdjustSleepTimeToday.toggle()
            }) {
                VStack(alignment: .center) {
                    Text("Today")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("\(settedStartTime.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits))) - \(settedEndTime.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)))")
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }.padding(.top, 10)
                    // Add the total sleep time set for today (green for over or equal 7 hours, red for below 7 hours)
                    .foregroundColor(timeIntervalSleep >= 25200 ? .green : .red)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingAdjustSleepTimeToday) {
                AdjustSleepGoalView(userSession: userSession, date: date, startTime: settedStartTime, endTime: settedEndTime, totalSleepTime: timeIntervalSleep)
            }
            
            Button(action: {
                self.showingDiaryInput.toggle()
            }) {
                Text("Diary")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $showingDiaryInput) {
                DiaryInputView(userSession: userSession, diary: diary, date: date)
            }
            .padding(.top, 5)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .onReceive(date.$date) { newDate in
            dateDifference = userSession.calculateDateDifference(date1: userSession.dateCreated, date2: newDate)
            let sleepValueCount = userSession.sleepValueDict.count
            if sleepValueCount < dateDifference {
                dateDifference = sleepValueCount - 1
            }
            let sleepToday = userSession.sleepValueDict[dateDifference]
            settedStartTime = sleepToday.settedStartTime
            settedEndTime = sleepToday.settedEndTime
            timeIntervalSleep = SleepManager.shared.calculateActivityDuration(from: settedStartTime, to: settedEndTime)
            
            actualStartTime = sleepToday.actualStartTimeLastNight
            actualEndTime = sleepToday.actualEndTimeLastNight
            yesterdayTimeInterval = SleepManager.shared.calculateActivityDuration(from: actualStartTime, to: actualEndTime)
            
            diary = sleepToday.diary
        }
    }
}


//struct SleepCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        SleepCardView()
//    }
//}
//
