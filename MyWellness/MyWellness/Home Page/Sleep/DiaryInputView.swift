//
//  DiaryInputView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI

struct DiaryInputView: View {
    @Environment(\.presentationMode) var presentationMode
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

            Button(action: {presentationMode.wrappedValue.dismiss()}) {
                // Save diary content, weatherToday, and emotionToday
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(Color.blue)
                    .cornerRadius(8)
                
            }
            .padding(.top, 20)

        }
        .padding()
    }
}

struct DiaryInputView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryInputView()
    }
}
