//
//  CalendarView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI
import FSCalendar

struct CalendarView: View {
    @ObservedObject var userSession: UserSession

    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack {
                FSCalendarWrapper(dateCreated: userSession.dateCreated, selectedDate: $selectedDate )
                    .frame(height: 350)
                
                VStack(spacing: 20) {
                    DietCardView(userSession: userSession, date: selectedDate)
                    ExerciseCardView(userSession: userSession, date: selectedDate)
                    SleepCardView(userSession: userSession, date: selectedDate)
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
        let viewModel = UserProfileSettingsViewModel()
        let userSession = UserSession(profileViewModel: viewModel)
        CalendarView(userSession: userSession)
    }
}
