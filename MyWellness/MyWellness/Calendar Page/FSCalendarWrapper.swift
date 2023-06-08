//
//  FSCalendarWrapper.swift
//  MyWellness
//
//  Created by ZL Asica on 5/5/23.
//

import SwiftUI
import FSCalendar

struct FSCalendarWrapper: UIViewRepresentable {
    @State var dateCreated: Date
    @ObservedObject var selectedDate: SelectedDate
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.allowsMultipleSelection = false
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.scrollDirection = .horizontal

        // Appearance settings for both light and dark modes
        if #available(iOS 13.0, *) {
            calendar.appearance.weekdayTextColor = .label
            calendar.appearance.titleDefaultColor = .label
            calendar.appearance.titlePlaceholderColor = .tertiaryLabel
            calendar.appearance.titleSelectionColor = .label
            calendar.appearance.todayColor = .systemBlue
            calendar.appearance.selectionColor = .systemOrange // Change the selection color
            calendar.appearance.borderDefaultColor = .clear
            calendar.appearance.borderSelectionColor = .clear
            calendar.appearance.headerTitleColor = .label
        } else {
            calendar.appearance.weekdayTextColor = .black
            calendar.appearance.titleDefaultColor = .black
            calendar.appearance.titlePlaceholderColor = .lightGray
            calendar.appearance.titleSelectionColor = .black
            calendar.appearance.todayColor = .systemBlue
            calendar.appearance.selectionColor = .systemOrange // Change the selection color
            calendar.appearance.borderDefaultColor = .clear
            calendar.appearance.borderSelectionColor = .clear
            calendar.appearance.headerTitleColor = .black
        }

        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData()
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDelegateAppearance {
        var parent: FSCalendarWrapper

        init(_ parent: FSCalendarWrapper) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
                let today = Calendar.current.startOfDay(for: Date())
                if date >= parent.dateCreated && date <= today {
                    parent.selectedDate.date = date
                    print("\t\t\tselectedDate: \(parent.selectedDate.date)")
                }
            }
        
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            let today = Calendar.current.startOfDay(for: Date())
            return date >= parent.dateCreated && date <= today
        }

        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            let today = Calendar.current.startOfDay(for: Date())
            if date < parent.dateCreated || date > today {
                if #available(iOS 13.0, *) {
                    return UIColor.systemGray
                } else {
                    return UIColor.lightGray
                }
            }
            return nil // return nil for default color
        }
    }
}

//struct FSCalendarWrapper_Previews: PreviewProvider {
//    static var previews: some View {
//        FSCalendarWrapper(dateCreated: Date(), selectedDate: .constant(Date()))
//    }
//}
