//
//  FSCalendarWrapper.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI
import FSCalendar

struct FSCalendarWrapper: UIViewRepresentable {
    @Binding var selectedDate: Date
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.allowsMultipleSelection = false
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.weekdayTextColor = .black
        calendar.scrollDirection = .horizontal
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData()
    }
    
    class Coordinator: NSObject, FSCalendarDelegate {
        var parent: FSCalendarWrapper
        
        init(_ parent: FSCalendarWrapper) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
    }
}
