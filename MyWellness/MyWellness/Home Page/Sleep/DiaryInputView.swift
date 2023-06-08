//
//  DiaryInputView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct DiaryInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession
    
    @State var diary: Diary
    @ObservedObject var date: SelectedDate
    
    @State private var weatherToday: String = ""
    @State private var emotionToday: String = ""
    @State private var diaryContentToday: String = ""

    // Mood level is from 1 to 10, 1 being the worst and 10 being the best
    @State private var moodLevel: Double = 5
    let moodDescriptions: [Int: String] = [
        0: "Worst",
        1: "Terrible",
        2: "Bad",
        3: "Unhappy",
        4: "Sad",
        5: "Moderate",
        6: "Satisfied",
        7: "Happy",
        8: "Joyful",
        9: "Excited",
        10: "Best"
    ]

    // Add your weather icons from SF Symbols

    let weatherIcons = ["sun.max", "cloud.sun", "cloud.bolt", "cloud.heavyrain", "cloud.snow", "wind", "hurricane"]

    var body: some View {
        VStack {
            Text("Today's Diary")
                .font(.headline)
                .padding(.bottom, 20)

            Text("Weather Today")
                .font(.subheadline)

            HStack {
                ForEach(weatherIcons, id: \.self) { icon in
                    Button(action: {
                        self.weatherToday = icon
                    }) {
                        VStack {
                            Image(systemName: icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(weatherToday == icon ? .blue : .gray)
                        }
                    }
                }
            }

            Text("Mood Today")
                .font(.subheadline)
                .padding(.top, 10)

            HStack {
                Text("0")
                    .font(.caption)
                Slider(value: $moodLevel, in: 0...10, step: 1)
                    .padding(.horizontal, 10)
                Text("10")
                    .font(.caption)
            }

            Text("Selected Mood Level: \(Int(moodLevel)) - \(moodDescriptions[Int(moodLevel)] ?? "")")
                .font(.caption)
                .padding(.bottom, 10)

            // Below here is the diary content box for the user to type in
            Text("Diary Content")
                .font(.subheadline)
                .padding(.top, 20)
            
            TextEditor(text: $diaryContentToday)
                .frame(height: 150)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .foregroundColor(.primary) // Ensure text color is visible in dark mode
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1) // Add border for better visibility
                )
                .background(Color(.systemGray5)) // Set background color for dark mode visibility
                .cornerRadius(10)
                .padding(.bottom, 10)
            
            // Word Count Indicator
            HStack {
                Spacer()
                Text("\(diaryContentToday.split(whereSeparator: \.isWhitespace).count) words")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            
            Button("Save") {
                // Save diary content, weatherToday, and emotionToday
                var sleepValueDict = userSession.sleepValueDict
                
                var tempDiary = Diary()
                
                tempDiary.weatherSelected = weatherToday
                tempDiary.emotionSelected = emotionToday
                tempDiary.diaryContent = diaryContentToday
                
                sleepValueDict[userSession.calculateDateDifference(date1: userSession.dateCreated, date2: date.date)].diary = tempDiary
                
                Task {
                    let sleep = Sleep(userId: userSession.uid, sleepValueDict: sleepValueDict)
                    do {
                        try await SleepManager.shared.updateUserSleepInfo(sleep: sleep)
                        userSession.reloadUserLoginInfo()
                    } catch {
                        print("AdjustSleepTime ERROR: \(error)")
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
            .padding(.top, 20)

        }
        .padding()
        .onAppear {
            weatherToday = diary.weatherSelected
            emotionToday = diary.emotionSelected
            diaryContentToday = diary.diaryContent
        }
    }
}

//struct DiaryInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiaryInputView()
//    }
//}
