//
//  SleepCardView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct SleepCardView: View {
    @State private var showingAdjustSleepTime = false
    // startTime and endTime should be setted deafult value from yesterday's setting
    @State private var startTime: Date = Date(timeIntervalSinceNow : -86400)
    @State private var endTime: Date = Date(timeIntervalSinceNow: -86400 + 28800)
    @State private var timeIntervalSleep: TimeInterval = 28800
    @State private var showingDiaryInput = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Sleep") // align this text to center
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            

            Button(action: {
                            showingAdjustSleepTime.toggle()
                        }) {
                            HStack {
                                // Customize the UI for showing sleep time (startTime - endTime)
                                Text("\(startTime.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits))) - \(endTime.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)))")
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }.padding(.top, 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showingAdjustSleepTime) {
                            AdjustSleepTimeView(startTime: $startTime, endTime: $endTime, totalSleepTime: $timeIntervalSleep)
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
                DiaryInputView()
            }
            .padding(.top, 5)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}


struct SleepCardView_Previews: PreviewProvider {
    static var previews: some View {
        SleepCardView()
    }
}

