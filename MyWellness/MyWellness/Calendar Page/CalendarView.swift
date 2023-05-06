//
//  CalendarView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI
import FSCalendar

struct CalendarView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack {
                FSCalendarWrapper(selectedDate: $selectedDate)
                    .frame(height: 350)
                
                VStack(spacing: 20) {
                    //                DietCardView(selectedDate: selectedDate)
                    //                ExerciseCardView(selectedDate: selectedDate)
                    //                SleepCardView(selectedDate: selectedDate)
                    DietCardView()
                    ExerciseCardView()
                    SleepCardView()
                }
                .padding(.top)
            }
            .navigationBarTitle("Calendar", displayMode: .large)
            .padding()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
